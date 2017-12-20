From: Shih-Wei Li <shihwei@cs.columbia.edu>
Subject: [kvm-unit-tests PATCH V2 0/2] Support micro operation measurement on
 arm64
Date: Tue, 19 Dec 2017 20:34:43 -0500
Message-ID: <1513733685-32573-1-git-send-email-shihwei@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEECE49D46
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Dec 2017 20:30:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZFM9F2H3m5sY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Dec 2017 20:30:46 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF89040795
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Dec 2017 20:30:46 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id vBK1V830034939
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Dec 2017 20:34:35 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 7E8787E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Dec 2017 20:34:35 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id 3B8A67E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Dec 2017 20:34:35 -0500 (EST)
Received: from mail-qk0-f200.google.com (mail-qk0-f200.google.com
 [209.85.220.200])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id vBK1YYr9061372
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Dec 2017 20:34:34 -0500
Received: by mail-qk0-f200.google.com with SMTP id j7so14546953qkj.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Dec 2017 17:34:34 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, Shih-Wei Li <shihwei@cs.columbia.edu>
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

Shih-Wei Li (2):
  arm/arm64: add GICD_IIDR definition
  arm64: add micro test

 arm/Makefile.common |   1 +
 arm/micro-test.c    | 219 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |   7 ++
 lib/arm/asm/gic.h   |   1 +
 4 files changed, 228 insertions(+)
 create mode 100644 arm/micro-test.c

-- 
1.9.1
