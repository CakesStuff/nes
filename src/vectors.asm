.import nmi
.import reset
.import irq

.segment "VECTORS"
.word nmi
.word reset
.word irq

