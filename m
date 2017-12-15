From: Shih-Wei Li <shihwei@cs.columbia.edu>
Subject: [kvm-unit-tests PATCH] Support micro operation measurement on arm64
Date: Fri, 15 Dec 2017 16:15:38 -0500
Message-ID: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, drjones@redhat.com, pbonzini@redhat.com, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

The patch provides support for quantifying the cost of micro level
operations on arm64 hardware. The supported operations include hypercall,
mmio accesses, EOI virtual interrupt, and IPI send. Measurements are
currently obtained using timer counters. Further modifications in KVM
will be required to support timestamping using cycle counters, as KVM
now disables accesses to the PMU counters from the VM.

We iterate each of the tests for millions of times and output their
average, minimum and maximum cost in timer counts. Instruction barriers
were used before and after taking timestamps to avoid out-of-order
execution or pipelining from skewing our measurements.

To improve precision in the measurements, one should consider pinning
each VCPU to a specific physical CPU (PCPU) and ensure no other task
could run on that PCPU to skew the results. This can be achieved by
enabling QMP server in the QEMU command in unittest.cfg for micro test,
allowing a client program to get the thread_id for each VCPU thread
from the QMP server. Based on the information, the client program can
then pin the corresponding VCPUs to dedicated PCPUs and isolate
interrupts and tasks from those PCPUs.

The patch has been tested on arm64 hardware including AMD Seattle and
ThunderX2, which has GICv2 and GICv3 respectively.

Shih-Wei Li (1):
  arm64: add micro test

 arm/Makefile.common |   1 +
 arm/micro-test.c    | 289 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |   6 ++
 3 files changed, 296 insertions(+)
 create mode 100644 arm/micro-test.c

-- 
1.9.1
