From: Shih-Wei Li <shihwei@cs.columbia.edu>
Subject: [PATCH v3 0/2] Support micro operation measurement on arm64
Date: Wed, 17 Jan 2018 16:46:34 -0500
Message-ID: <1516225596-27071-1-git-send-email-shihwei@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D53649E04
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 16:41:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FkvGuIhOQEtg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jan 2018 16:41:07 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C12649DDF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 16:41:07 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id w0HLiDIm038298
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 16:46:12 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id BB07D98
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 16:46:12 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id 850B4A2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 16:46:12 -0500 (EST)
Received: from mail-qt0-f198.google.com (mail-qt0-f198.google.com
 [209.85.216.198])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id w0HLkBt4032119
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 16:46:11 -0500
Received: by mail-qt0-f198.google.com with SMTP id o22so16500986qtb.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 13:46:11 -0800 (PST)
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
now disables accesses to the PMU counters from the VM. The micro test
is currently non-default and can be used as a standalone test.

We iterate each of the tests for millions of times and output their
average, minimum and maximum cost in timer counts. Instruction barriers
were used before and after taking timestamps to avoid out-of-order
execution or pipelining from skewing our measurements. We currently
skip the test if its cost is smaller than a timer tick for 1000 times.

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

Changes since v2:
  - Rebased atop of 4a671159.
  - Make microtest nondefault.
  - Output the cost in microseconds.
  - Added fail safe option to skip the test if the cost is consistently
    smaller than a timer tick.
  - Fixed nits from comments in v2.

Shih-Wei Li (2):
  arm/arm64: add GICD_IIDR definition
  arm64: add micro test

 arm/Makefile.common |   1 +
 arm/micro-test.c    | 252 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |   7 ++
 lib/arm/asm/gic.h   |   1 +
 4 files changed, 261 insertions(+)
 create mode 100644 arm/micro-test.c

-- 
1.9.1
