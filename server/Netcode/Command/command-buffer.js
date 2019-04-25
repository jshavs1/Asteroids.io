module.exports = class CommandBuffer {

    constructor(length) {
        this.length = length;
        this.buffer = [];
        this.frame = 0;
    }

    setFrame(frame) {
        this.frame = frame
    }

    addCommand(command) {
        if (this.buffer.length < this.length) {
            this.buffer.push(command);
        }
        else {
            this.buffer.shift();
            this.buffer.push(command);
        }
        this.frame++;
    }

    insertCommand(command) {
        var index = (this.buffer.length - 1) - (this.frame - command.frame);
        if (index > 0) {
            this.buffer[index] = command;
        }
    }

    simulateFrom(frame, func) {
        var from = (this.buffer.length - 1) - (this.frame - frame);
        var to = this.buffer.length;

        for (from; from < to; from++) {
            func(this.buffer[from]);
        }
    }

    revertTo(frame, func) {
        console.log(this.frame + ' ' + frame);
        var to = (this.buffer.length - 1) - (this.frame - frame);
        var from = this.buffer.length - 1;
        for (from; from >= to; from--) {
            console.log(this.buffer[from]);
            func(this.buffer[from]);
        }
    }

    getCommandAt(frame) {
        return this.buffer[this.frame - frame];
    }
}
