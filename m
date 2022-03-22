Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E27C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 08:07:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA4BE49E44;
	Tue, 22 Mar 2022 04:07:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wRPqER1-epVB; Tue, 22 Mar 2022 04:07:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E23949EDE;
	Tue, 22 Mar 2022 04:07:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5B6949E44
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:07:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zxXH+qY4t-4p for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 04:07:45 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C36540CDE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:07:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647936464;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=xDEmee2vip/jzjOaF4lPSQBRA3QBj0Yqyh4o3nXrkBs=;
 b=i77y6ueSsMa1Y0uwP+dSexZBIh7ScjgFRbrbYkxRx17NCqtM6YFhLuXlB2GOm5FPAhONXp
 dNO270QkJgNqEimj25UC+teekgUE756ERQ90zmd1tmAAuNb5HUR5JpNGG++pgC5sfbkn5d
 rtS0lmFsxMQ/a3vyP0cGTUrovq96G0M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-Domw68_KNIug73ZHAZJX1w-1; Tue, 22 Mar 2022 04:07:41 -0400
X-MC-Unique: Domw68_KNIug73ZHAZJX1w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 242C4811E76;
 Tue, 22 Mar 2022 08:07:41 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-33.pek2.redhat.com [10.72.12.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 914E91121324;
 Tue, 22 Mar 2022 08:07:30 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 00/22] Support SDEI Virtualization
Date: Tue, 22 Mar 2022 16:06:48 +0800
Message-Id: <20220322080710.51727-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org
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

This series intends to virtualize Software Delegated Exception Interface
(SDEI), which is defined by DEN0054C (v1.1). It allows the hypervisor to
deliver NMI-alike SDEI event to guest and it's needed by Async PF to
deliver page-not-present notification from hypervisor to guest. The code
and the required qemu changes can be found from:

   https://developer.arm.com/documentation/den0054/c
   https://github.com/gwshan/linux    ("kvm/arm64_sdei")
   https://github.com/gwshan/qemu     ("kvm/arm64_sdei")

For the design and migration needs, please refer to the document in
PATCH[21/22] in this series. The series is organized as below:

  PATCH[01]    Introduces template for smccc_get_argx()
  PATCH[02]    Adds SDEI virtualization infrastructure
  PATCH[03-17] Supports various SDEI hypercalls and event handling
  PATCH[18-20] Adds ioctl commands to support migration and configuration
               and exports SDEI capability
  PATCH[21]    Adds SDEI document 
  PATCH[22]    Adds SDEI selftest case

Testing
=======

[1] The selftest case included in this series works fine. The default SDEI
    event, whose number is zero, can be registered, enabled, raised. The
    SDEI event handler can be invoked.

    [host]# pwd
    /home/gavin/sandbox/linux.main/tools/testing/selftests/kvm
    [root@virtlab-arm01 kvm]# ./aarch64/sdei 

        NR_VCPUS: 2    SDEI Event: 0x00000000

    --- VERSION
        Version:              1.1 (vendor: 0x4b564d)
    --- FEATURES
        Shared event slots:   0
        Private event slots:  0
        Relative mode:        No
    --- PRIVATE_RESET
    --- SHARED_RESET
    --- PE_UNMASK
    --- EVENT_GET_INFO
        Type:                 Private
        Priority:             Normal
        Signaled:             Yes
    --- EVENT_REGISTER
    --- EVENT_ENABLE
    --- EVENT_SIGNAL
        Handled:              Yes
        IRQ:                  No
        Status:               Registered-Enabled-Running
        PC/PSTATE:            000000000040232c 00000000600003c5
        Regs:                 0000000000000000 0000000000000000
                              0000000000000000 0000000000000000
    --- PE_MASK
    --- EVENT_DISABLE
    --- EVENT_UNREGISTER

        Result: OK

[2] There are additional patches in the following repositories to create
    procfs entries, allowing to inject SDEI event from host side. The
    SDEI client in the guest side registers the SDEI default event, whose
    number is zero. Also, the QEMU exports SDEI ACPI table and supports
    migration for SDEI.

    https://github.com/gwshan/linux    ("kvm/arm64_sdei")
    https://github.com/gwshan/qemu     ("kvm/arm64_sdei")

    [2.1] Start the guests and migrate the source VM to the destination
          VM.

    [host]# /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64       \
            -accel kvm -machine virt,gic-version=host                     \
            -cpu host -smp 6,sockets=2,cores=3,threads=1                  \
            -m 1024M,slots=16,maxmem=64G                                  \
               :                                                          \
            -kernel /home/gavin/sandbox/linux.guest/arch/arm64/boot/Image \
            -initrd /home/gavin/sandbox/images/rootfs.cpio.xz             \
            -append earlycon=pl011,mmio,0x9000000                         \
               :

    [host]# /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64       \
            -accel kvm -machine virt,gic-version=host                     \
            -cpu host -smp 6,sockets=2,cores=3,threads=1                  \
            -m 1024M,slots=16,maxmem=64G                                  \
               :                                                          \
            -kernel /home/gavin/sandbox/linux.guest/arch/arm64/boot/Image \
            -initrd /home/gavin/sandbox/images/rootfs.cpio.xz             \
            -append earlycon=pl011,mmio,0x9000000                         \
            -incoming tcp:0:4444                                          \
               :

    [2.2] Check kernel log on the source VM. The SDEI service is enabled
          and the default SDEI event (0x0) is enabled.

     [guest-src]# dmesg | grep -i sdei
     ACPI: SDEI 0x000000005BC80000 000024 \
                (v00 BOCHS  BXPC     00000001 BXPC 00000001)
     sdei: SDEIv1.1 (0x4b564d) detected in firmware.
     SDEI TEST: Version 1.1, Vendor 0x4b564d
     sdei_init: SDEI event (0x0) registered
     sdei_init: SDEI event (0x0) enabled

 
     (qemu) migrate -d tcp:localhost:4444

    [2.3] Migrate the source VM to the destination VM. Inject SDEI event
          to the destination VM. The event is raised and handled.

    (qemu) migrate -d tcp:localhost:4444

    [host]# echo 0 > /proc/kvm/kvm-5360/vcpu-1

    [guest-dst]#
    =========== SDEI Event (CPU#1) ===========
    Event: 0000000000000000  Parameter: 00000000dabfdabf
    PC: ffff800008cbb554  PSTATE: 00000000604000c5  SP: ffff800009c7bde0
    Regs:    00000000000016ee ffff00001ffd2e28 00000000000016ed 0000000000000001 
             ffff800016c28000 0000000000000000 0000000000000000 0000000000000000 
             0000000000000000 0000000000000000 0000000000000000 0000000000000000 
             0000000000000000 0000000000000000 0000000000000000 0000000000000000 
             0000000000000000 0000000000000000 0000000000000000 ffff800009399008 
             ffff8000097d9af0 ffff8000097d99f8 ffff8000093a8db8 ffff8000097d9b18 
             0000000000000000 0000000000000000 ffff000000339d00 0000000000000000 
             0000000000000000 ffff800009c7bde0 ffff800008cbb5c4 
    Context: 00000000000016ee ffff00001ffd2e28 00000000000016ed 0000000000000001 
             ffff800016c28000 03ffffffffffffff 000000024325db59 ffff8000097de190 
             ffff00000033a790 ffff800008cbb814 0000000000000a30 0000000000000000 

Changelog
========= 
v5:
   * Rebased to v5.17.rc7                                     (Gavin)
   * Unified names for the objects, data structures, variables
     and functions. The events have been named as exposed,
     registered and vcpu event. The staes needs to be migrated
     is put into kvm_sdei_state.h                             (Eric)
   * More inline functions to visit SDEI event's properties   (Eric)
   * Support unregistration pending state                     (Eric)
   * Support v1.1 SDEI specification                          (Eric)
   * Fold the code to inject, deliver and handle SDEI event
     from PATCH[v4 13/18/19] into PATCH[v5 13]                (Eric)
   * Simplified ioctl interface to visit all events at once   (Eric/Gavin)
   * Improved reference count and avoid its migration. Also,
     the limit to memory allocation is added based on it.     (Eric)
   * Change the return values from hypercall functions        (Eric) 
   * Validate @ksdei and @vsdi in kvm_sdei_hypercall()        (Shannon)
   * Add document to explain how SDEI virutalization and the
     migration are supported                                  (Eric)
   * Improved selftest case to inject and handle SDEI event   (Gavin)
   * Improved comments and commit logs                        (Eric)
   * Address misc comments from Eric. Hopefully, all of them
     are covered in v5 because Eric provided lots of comments
     in the last round of review                              (Eric)
v4:
   * Rebased to v5.14.rc5                                         (Gavin)
v3:
   * Rebased to v5.13.rc1                                         (Gavin)
   * Use linux data types in kvm_sdei.h                           (Gavin)
v2:
   * Rebased to v5.11.rc6                                         (Gavin)
   * Dropped changes related to SDEI client driver                (Gavin)
   * Removed support for passthrou SDEI events                    (Gavin)
   * Redesigned data structures                                   (Gavin)
   * Implementation is almost rewritten as the data structures
     are totally changed                                          (Gavin)
   * Added ioctl commands to support migration                    (Gavin)

Gavin Shan (22):
  KVM: arm64: Introduce template for inline functions
  KVM: arm64: Add SDEI virtualization infrastructure
  KVM: arm64: Support SDEI_VERSION hypercall
  KVM: arm64: Support SDEI_EVENT_REGISTER hypercall
  KVM: arm64: Support SDEI_EVENT_{ENABLE, DISABLE} hypercall
  KVM: arm64: Support SDEI_EVENT_CONTEXT hypercall
  KVM: arm64: Support SDEI_EVENT_UNREGISTER hypercall
  KVM: arm64: Support SDEI_EVENT_STATUS hypercall
  KVM: arm64: Support SDEI_EVENT_GET_INFO hypercall
  KVM: arm64: Support SDEI_EVENT_ROUTING_SET hypercall
  KVM: arm64: Support SDEI_PE_{MASK, UNMASK} hypercall
  KVM: arm64: Support SDEI_{PRIVATE, SHARED}_RESET
  KVM: arm64: Support SDEI_FEATURES hypercall
  KVM: arm64: Support SDEI event injection, delivery and cancellation
  KVM: arm64: Support SDEI_EVENT_SIGNAL hypercall
  KVM: arm64: Support SDEI_EVENT_{COMPLETE,COMPLETE_AND_RESUME}
    hypercall
  KVM: arm64: Support SDEI event notifier
  KVM: arm64: Support SDEI ioctl commands on VM
  KVM: arm64: Support SDEI ioctl commands on vCPU
  KVM: arm64: Export SDEI capability
  KVM: arm64: Add SDEI document
  KVM: selftests: Add SDEI test case

 Documentation/virt/kvm/api.rst               |   10 +
 Documentation/virt/kvm/arm/sdei.rst          |  325 +++
 arch/arm64/include/asm/kvm_emulate.h         |    1 +
 arch/arm64/include/asm/kvm_host.h            |    5 +
 arch/arm64/include/asm/kvm_sdei.h            |  187 ++
 arch/arm64/include/uapi/asm/kvm.h            |    1 +
 arch/arm64/include/uapi/asm/kvm_sdei_state.h |  101 +
 arch/arm64/kvm/Makefile                      |    2 +-
 arch/arm64/kvm/arm.c                         |   20 +
 arch/arm64/kvm/hypercalls.c                  |   21 +
 arch/arm64/kvm/inject_fault.c                |   29 +
 arch/arm64/kvm/sdei.c                        | 1900 ++++++++++++++++++
 include/kvm/arm_hypercalls.h                 |   24 +-
 include/uapi/linux/arm_sdei.h                |    2 +
 include/uapi/linux/kvm.h                     |    4 +
 tools/testing/selftests/kvm/Makefile         |    1 +
 tools/testing/selftests/kvm/aarch64/sdei.c   |  525 +++++
 17 files changed, 3145 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/sdei.rst
 create mode 100644 arch/arm64/include/asm/kvm_sdei.h
 create mode 100644 arch/arm64/include/uapi/asm/kvm_sdei_state.h
 create mode 100644 arch/arm64/kvm/sdei.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/sdei.c

-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
