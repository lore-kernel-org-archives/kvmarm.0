Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254C6C433B4
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:41:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E3D2613CD
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:41:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E3D2613CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E53834B2C4;
	Fri,  7 May 2021 02:41:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6tGGF+QDDvcz; Fri,  7 May 2021 02:41:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7115E4B491;
	Fri,  7 May 2021 02:41:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88E304B2FA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:41:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r3WlgPcsGmRw for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 02:40:59 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3211D4B2C4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:40:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620369659;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=hIh0otIUHTexqBioQS3MAszEgilgoVYBkkMZ172duEM=;
 b=IfMwD5RsU1dWRQFnvjUmaaBbQ4NE2ZF+Oh7/es8ffUPgCmlXzlKNtxoBP14EJdTgjTh0zh
 Mj9HUZHHTdpsvyA2J4RUus1TKq4JnGf2JeN/30LUCm2qYFD9XiUR4/YRrX2KN9E/+o9q8C
 0PTQPnbadM9+z1r47/iLSoNilkFN1Qw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-Oe6H3XRrO1m_63z_tbbZ5Q-1; Fri, 07 May 2021 02:40:55 -0400
X-MC-Unique: Oe6H3XRrO1m_63z_tbbZ5Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DE6E80059E;
 Fri,  7 May 2021 06:40:54 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
 by smtp.corp.redhat.com (Postfix) with ESMTP id C0FFA5C276;
 Fri,  7 May 2021 06:40:50 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 00/15] Support Asynchronous Page Fault
Date: Fri,  7 May 2021 16:40:38 +0800
Message-Id: <20210507084053.44407-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, will@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

There are two stages of page fault. The guest kernel is responsible for
handling stage-1 page fault, while the host kernel is to take care of the
stage-2 page fault. When the guest is trapped to host because of stage-2
page fault, the guest is suspended until the requested memory (page) is
populated. Sometimes, the cost to populate the requested page isn't cheap
and can take hundreds of milliseconds in extreme cases. Similarly, the
guest has to wait until the requested memory is ready in the scenario of
post-copy live migration.

This series introduces the feature (Asynchronous Page Fault) to improve
situation, so that the guest needn't have to wait in the scenarios. With
it, the overall performance is improved on the guest. This series depends
on the feature "SDEI virtualization" and QEMU changes. All code changes
can be found from github:

 https://github.com/gwshan/linux ("kvm/arm64_sdei") # SDEI virtualization
 https://github.com/gwshan/linux ("kvm/arm64_apf")  # This series + "sdei"
 https://github.com/gwshan/qemu  ("kvm/arm64_apf")  # QEMU code changes

About the design, the details can be found from last patch. Generally,
it's driven by two notifications: page-not-present and page-ready. They
are delivered from the host to guest via SDEI event and PPI separately.
In the mean while, each notification is always associated with a token,
used to identify the notification. The token is passed by the shared
memory between host/guest. Besides, the SMCCC and ioctl interface are
mitigated by VMM and guest to configure, enable, disable, even migrate
the functionality.

When the guest is trapped to host because of stage-2 page fault, a
page-not-present notification is raised by the host, and sent to the
guest through dedicated SDEI event (0x40400001) if the requested page
can't be populated immediately. In the mean while, a (background) worker
is also started to populate the requested page. On receiving the SDEI
event, the guest marks the current running process with special flag
(TIF_ASYNC_PF) and associates it with a pre-allocated waitqueue. At
same time, a (reschedule) IPI is sent to current CPU. After the SDEI
event is acknowledged by the guest, the (reschedule) IPI is delivered
and it causes context switch from that process tagged with TIF_ASYNC_PF
to another process.

Later on, a page-ready notification is sent to guest after the requested
page is populated by the (background) worker. On receiving the interrupt,
the guest uses the associated token to locate the process, which was
previously suspended because of page-not-present. The flag (TIF_ASYNC_PF)
is cleared for the suspended process and it's waken up.

The series is organized as below:

   PATCH[01-04] makes the GFN hash table management generic so that it
                can be shared by x86/arm64.
   PATCH[05-06] preparatory work to support asynchronous page fault.
   PATCH[07-08] support asynchronous page fault.
   PATCH[09-11] support ioctl and SMCCC interfaces for the functionality.
   PATHC[12-14] supoort asynchronous page fault for guest
   PATCH[15]    adds document to explain the design and internals

Testing
=======
The tests are taken using program "testsuite", which is written by myself.
The program basically does two things: (a) Starts a thread to allocate
all the available memory, write random values to them by the specified
times, and then release them; (b) The parallel thread is started to do
calculation if needed.

The VM has 4096MB memory and the QEMU process is put into memory cgroup,
which has 512MB memory limitation. It enforces memory swapping on host
side when the test program "testsuite" allocates all available memory
and writes random values to them on the guest side.

    host# echo "never" > /sys/kernel/mm/transparent_hugepage/enabled
    host# mkdir /sys/fs/cgroup/test                                        \
    host# echo "max" > /sys/fs/cgroup/test/memory.swap.max;                \
          echo "max" > /sys/fs/cgroup/test/memory.swap.high;               \
          echo "1024M" > /sys/fs/cgroup/test/memory.max;                   \
          echo "1024M" > /sys/fs/cgroup/test/memory.high
    host# echo $$ > /sys/fs/cgroup/test/cgroup.procs
    host# /home/gavin/sandbox/qemu.main/build qemu-system-aarch64          \
          -accel kvm -machine virt,gic-version=host                        \
          -cpu host -smp 1,sockets=1,cores=1,threads=1 -m 4096M,maxmem=64G \
          -object memory-backend-ram,id=mem0,size=4096M                    \
          -numa node,nodeid=0,cpus=0,memdev=mem0                           \
            :
          -kernel /home/gavin/sandbox/linux.guest/arch/arm64/boot/Image    \
          -initrd /home/gavin/sandbox/images/rootfs.cpio.xz

[1] Access all available memory without calculation thread

    The performance is improved slightly because of the background swapin
    introduced by asynchronous page fault.

    Index   -APF          +APF         Performance
    -----------------------------------------------
      1     61399ms       59911ms      +0.24%
      2     61121ms       59941ms      +0.19%
      3     60812ms       59728ms      +0.17%
      4     60749ms       59698ms      +0.17%
      5     60723ms       59678ms      +0.17%


[2] Access all available memory with calculation thread

   With the asynchronous page fault, the overall time to access all the
   available memory is dropped by 40.2% (Index#1) in the cost of calculation
   loss. It proves the asynchronous page fault is beneficial to system
   responsiveness.

    Index  -APF    Calculation      +APF    Calculation      Performance
    ----------------------------------------------------------------------------
      1   108392ms 8279539k 76k/ms  64751ms 4658761k 71k/ms  +40.2% -43.7% -6.5%
      2   107402ms 8160632k 75k/ms  64020ms 4520263k 70k/ms  +40.3% -44.6% -6.6%
      3   106854ms 8163024k 76k/ms  63654ms 4478215k 70k/ms  +40.4% -45.1% -7.6%
      4   106844ms 8156974k 76k/ms  63563ms 4461158k 70k/ms  +40.5% -45.3% -7.6%
      5   106769ms 8146449k 76k/ms  62885ms 4434800k 70k/ms  +41.1% -45.5% -7.6%

[3] Live migration while accessing all available memory with calculation
    thread

    This is also beneficial to live migration. With the asynchronous page
    fault is enabled, less time are needed to completee the live migration
    and much more calculation capability is provided.

    Index  Item                    -APF               +APF             Performance
    -----------------------------------------------------------------------------
      1    test.used_time            59755ms            55708ms        +6.7%
           test.calculation/speed  4515595k 75k/ms    7049430k 126k/ms +68%
           migrate.total_time        62275ms            63012ms        -1.1%
           migrate.setup_time          148ms              145ms        +2.0%
           migrate.down_time            38ms               83ms        -118%
           migrate.throughput          487mbps            589mbps      +20.9%
      2    test.used_time            59063ms            53123ms        +10.0%
           test.calculation/speed  4456194k 75k/ms    6755980k 127k/ms +69.3% 
           migrate.total_time        61555ms            57373ms        +6.7%
           migrate.setup_time          120ms               93ms        +22.5%
           migrate.down_time            47ms               30ms        +36.1%
           migrate.throughput          492mbps            608mbps      +23.5%

Changelog
=========
v3:
   * Rebase to v5.13.rc1                                          (Gavin)
   * Drop patches from Will to detected SMCCC KVM service         (Gavin)
   * Retest and recapture the benchmarks                          (Gavin)
v2:
   * Rebase to v5.11.rc6                                          (Gavin)
   * Split the patches                                            (James)
   * Allocate "struct kvm_arch_async_control" dymaicall and use
     it to check if the feature has been enabled. The kernel
     option (CONFIG_KVM_ASYNC_PF) isn't used.                     (James)
   * Add document to explain the design                           (James)
   * Make GFN hash table management generic                       (James)
   * Add ioctl commands to support migration                      (Gavin)

Gavin Shan (15):
  KVM: async_pf: Move struct kvm_async_pf around
  KVM: async_pf: Add helper function to check completion queue
  KVM: async_pf: Make GFN slot management generic
  KVM: x86: Use generic async PF slot management
  KVM: arm64: Export kvm_handle_user_mem_abort()
  KVM: arm64: Add paravirtualization header files
  KVM: arm64: Support page-not-present notification
  KVM: arm64: Support page-ready notification
  KVM: arm64: Support async PF hypercalls
  KVM: arm64: Support async PF ioctl commands
  KVM: arm64: Export async PF capability
  arm64: Detect async PF para-virtualization feature
  arm64: Reschedule process on aync PF
  arm64: Enable async PF
  KVM: arm64: Add async PF document

 Documentation/virt/kvm/arm/apf.rst     | 143 +++++++
 Documentation/virt/kvm/arm/index.rst   |   1 +
 arch/arm64/Kconfig                     |  11 +
 arch/arm64/include/asm/esr.h           |   6 +
 arch/arm64/include/asm/kvm_emulate.h   |  27 +-
 arch/arm64/include/asm/kvm_host.h      |  83 ++++
 arch/arm64/include/asm/kvm_para.h      |  37 ++
 arch/arm64/include/asm/processor.h     |   1 +
 arch/arm64/include/asm/thread_info.h   |   4 +-
 arch/arm64/include/uapi/asm/Kbuild     |   2 -
 arch/arm64/include/uapi/asm/kvm.h      |  19 +
 arch/arm64/include/uapi/asm/kvm_para.h |  23 ++
 arch/arm64/include/uapi/asm/kvm_sdei.h |   1 +
 arch/arm64/kernel/Makefile             |   1 +
 arch/arm64/kernel/kvm.c                | 452 +++++++++++++++++++++
 arch/arm64/kernel/signal.c             |  17 +
 arch/arm64/kvm/Kconfig                 |   2 +
 arch/arm64/kvm/Makefile                |   1 +
 arch/arm64/kvm/arm.c                   |  37 +-
 arch/arm64/kvm/async_pf.c              | 533 +++++++++++++++++++++++++
 arch/arm64/kvm/hypercalls.c            |   5 +
 arch/arm64/kvm/mmu.c                   |  76 +++-
 arch/arm64/kvm/sdei.c                  |   5 +
 arch/x86/include/asm/kvm_host.h        |   2 -
 arch/x86/kvm/Kconfig                   |   1 +
 arch/x86/kvm/mmu/mmu.c                 |   2 +-
 arch/x86/kvm/x86.c                     |  88 +---
 include/linux/arm-smccc.h              |  15 +
 include/linux/kvm_host.h               |  72 +++-
 include/uapi/linux/kvm.h               |   3 +
 virt/kvm/Kconfig                       |   3 +
 virt/kvm/async_pf.c                    |  95 ++++-
 virt/kvm/kvm_main.c                    |   4 +-
 33 files changed, 1619 insertions(+), 153 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/apf.rst
 create mode 100644 arch/arm64/include/asm/kvm_para.h
 create mode 100644 arch/arm64/include/uapi/asm/kvm_para.h
 create mode 100644 arch/arm64/kernel/kvm.c
 create mode 100644 arch/arm64/kvm/async_pf.c

-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
