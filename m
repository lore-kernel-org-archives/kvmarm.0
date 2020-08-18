Return-Path: <SRS0=un+q=B4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F3F5C433E3
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 01:13:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 75D0D2078E
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 01:13:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BXqa2Lpw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75D0D2078E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C91A04B971;
	Mon, 17 Aug 2020 21:13:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M7teePAe0JJI; Mon, 17 Aug 2020 21:13:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45CA14C27D;
	Mon, 17 Aug 2020 21:13:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B9404C258
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 21:13:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h4zaxAvCQuYz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 21:13:34 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 489B24B971
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 21:13:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597713213;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=9JJErmVcdSieQGoy/zaT3rY/xFUlV6NX4ucnYHeTZR8=;
 b=BXqa2LpwQ9iHwktfy+e88NUymyttZnj5Hzi6XksiiE83pFoSblw7P8tYAVF9KpeTRwqHiI
 bIgq7QSQCkMhm3RIRKUSXfZEzuVVWYO3Whr5NFRYJelOBjjT8DAoUX0qcPINtxHFCLvOW4
 yBR1tRnsSole6B6ISXM+htxdnWvvwT0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-btTN4yOdNIufZfGRyT-UzA-1; Mon, 17 Aug 2020 21:13:30 -0400
X-MC-Unique: btTN4yOdNIufZfGRyT-UzA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7065A1DDED;
 Tue, 18 Aug 2020 01:13:29 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id CCA575D9D2;
 Tue, 18 Aug 2020 01:13:26 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/6] Support Asynchronous Page Fault
Date: Tue, 18 Aug 2020 11:13:13 +1000
Message-Id: <20200818011319.91777-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, shan.gavin@gmail.com, pbonzini@redhat.com, will@kernel.org
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

There are two stages of page fault. The guest kernel is responsible
for handling stage one page fault, while the host kernel is to take
care of the stage two page fault. When page fault is triggered because
of stage two page fault, the guest is suspended until the requested
memory (page) is populated. Sometimes, the cost to populate the requested
page isn't cheap and can take hundreds of milliseconds in extreme
cases. This impacts the overall guest's performance.

This series introduces the feature (asynchronous page fault) to resolve
the issue and improve the guest's performance. It depends on the series
to support SDEI virtualization and refactoring SDEI client driver. This
also depends on QEMU changes to export SDEI/APFT tables. All the code
including this series can be found from github:

   https://github.com/gwshan/linux ("sdei_client")
   https://github.com/gwshan/linux ("sdei")
   https://github.com/gwshan/linux ("apf")
   https://github.com/gwshan/qemu  ("apf")

The functionality is driven by two notifications: page-not-present and
page-ready. They're delivered from the host to guest via SDEI event and
PPI separately. In the mean while, each notification is always associated
with a token, used to identify the notification. The token is passed by
the shared memory between host/guest. Besides, the SMCCC interface is
mitigated by the guest to configure, enable or disable the functionality.
It's traditional control path.

When the guest is trapped to host because of stage two page fault, a
page-not-present notification is raised by the host, and sent to the guest
through (KVM private) SDEI event (0x40200001) if the requested page can't
be populated immediately. In the mean while, a (background) worker is also
started to populate the requested page. On receiving the SDEI event, the
guest marks the current running process with special flag (TIF_ASYNC_PF)
and associates the process with a pre-defined waitqueue. At same time,
a (reschedule) IPI is sent to the CPU where the process was running.
After the SDEI event is acknoledged by the guest, the (reschedule) IPI
is delivered and it causes context switch from kernel to user space.
During the context switch, the process with TIF_ASYNC_PF flag is
suspended on the associated waitqueue.

Later on, a page-ready notification is sent to guest after the requested
page is populated by the (background) worker. On receiving the interrupt,
the guest uses the associated token to locate the process, which was
previously suspended because of page-not-present, and wakes it up.

The series is organized as below:

PATCH[1-2]: support KVM hypervisor SMCCC services, which are developed by
            Will Deacon.
PATCH[3]:   export kvm_handle_user_mem_abort() with @prefault parameter
            supported, which is prepatory work to support the feature.
PATCH[4]:   support asynchronous page fault in host side.
PATCH[5]:   exposes APFT (Asynchronous Page Fault Table) ACPI table, which
            will be used by guest kernel to support the feature
PATCH[6]:   support asynchronous page fault in guest side.

=======
Testing
=======

In the test case [1] and [2], "testsuite mem" is executed to allocate
the specified percentage of free memory (90%) and then release them.
In the mean while, the calculation thread is started or not. When
the calculation thread isn't started, there isn't obvious performance
degradtion. When the calculation thread is started, the performance
is improved by 27.7% and 28.6% separately, depending on THP enablement
sttus on the host side.

In test case [3] and [4], the kernel image is built and check the
used time. The performance is improved by 9.7% and 9.9% separately,
depending on THP enablement status on the host side.

[1] Two threads to allocate/free memory and do calculation
    vCPU:                  1
    Memory:                8GB
    memory.limit_in_bytes: 2GB
    memory.swappiness:     100
    host:                  THP disabled
    command:               "testsuite mem 90 1 [thread]"
    "-": Disabled asynchronous page fault
    "+": Enabled asynchronous page fault
    "T"  With the calculation thread

    Idx  -      +     Output  T-                   T+                   Output
    ==========================================================================
    1   93.1s  93.6s    -     223.8s 21117147961   391.9s 49845637101     -
    2   93.3s  94.2s    -     237.9s 23394567744   397.0s 50506074773     -
    3   93.5s  94.3s    -     244.2s 24305177553   405.8s 51853498870     -
    4   94.1s  95.0s    -     262.8s 27113310073   421.7s 54338181069     -
    5   94.3s  95.2s    -     272.7s 28565479414   434.3s 56171922019     -
    ==========================================================================
        93.6s  94.4s   -0.8%  248.2s 24899136549   410.1s 52543062766
                                       100318841/s          128122562/s  +27.7%

[2] Two threads to allocate/free memory and do calculation
    vCPU:                  1
    Memory:                8GB
    memory.limit_in_bytes: 2GB
    memory.swappiness:     100
    host:                  THP enabled
    command:               "testsuite mem 90 1 [thread]"
    "-": Disabled asynchronous page fault
    "+": Enabled asynchronous page fault
    "T"  With the calculation thread

    Idx  -      +     Output  T-                   T+                   Output
    ==========================================================================
    1   91.3s  91.2s    -     218.8s 20319612017   389.6s 49016175698     -
    2   91.7s  91.6s    -     233.9s 22619566161   402.0s 50901616319     -
    3   91.8s  91.9s    -     251.1s 25066180266   405.3s 51247353704     -
    4   92.7s  92.2s    -     251.1s 25262121229   406.9s 51692420054     -
    5   93.1s  92.2s    -     260.7s 26532616925   425.4s 54412348724     -
    ==========================================================================
        92.1s  91.8s   +3.0%  243.1s 23960019319   405.8  51453982899
                                       98560342/s          126796409/s  +28.6%

[3] Clear kernel image and rebuild it.
    vCPU: 24  Memory:      8GB
    memory.limit_in_bytes: 2GB
    memory.swapiness:      100
    Host:                  THP disabled
    command:               "make -j 24 clean > /dev/null 2>&1 &&
                            make -j 24 > /dev/null 2>&1"

    Idx   Disabled   Enabled   Output
    ==================================
    1     2211s      2000s     +9.5%
    2     2333s      2060s     +11.7%
    3     2568s      2192s     +14.6%
    4     2631s      2423s     +7.9%
    5     2756s      2605s     +5.4%
    ==================================
          2499s      2256s     +9.7%

[4] Clear kernel image and rebuild it.
    vCPU: 24  Memory:      8GB
    memory.limit_in_bytes: 2GB
    memory.swapiness:      100
    Host:                  THP enabled
    command:               "make -j 24 clean > /dev/null 2>&1 &&
                            make -j 24 > /dev/null 2>&1"

    Idx   Disabled   Enabled   Output
    ==================================
    1     2049s      1850s     +9.7%
    2     2144s      1947s     +9.1%
    3     2164s      1997s     +7.7%
    4     2192s      2031s     +7.3%
    5     2515s      2141s     +14.8%
    ==================================
          2214s      1993s     +9.9%


Gavin Shan (4):
  kvm/arm64: Export kvm_handle_user_mem_abort() with prefault mode
  arm64/kvm: Support async page fault
  drivers/acpi: Import ACPI APF table
  arm64/kernel: Support async page fault

Will Deacon (2):
  arm64: Probe for the presence of KVM hypervisor services during boot
  arm/arm64: KVM: Advertise KVM UID to guests via SMCCC

 arch/arm64/Kconfig                     |  11 +
 arch/arm64/include/asm/esr.h           |   5 +
 arch/arm64/include/asm/hypervisor.h    |  11 +
 arch/arm64/include/asm/kvm_emulate.h   |   8 +-
 arch/arm64/include/asm/kvm_host.h      |  54 +++
 arch/arm64/include/asm/kvm_para.h      |  41 +++
 arch/arm64/include/asm/processor.h     |   1 +
 arch/arm64/include/asm/thread_info.h   |   4 +-
 arch/arm64/include/uapi/asm/Kbuild     |   2 -
 arch/arm64/include/uapi/asm/kvm_para.h |  23 ++
 arch/arm64/kernel/Makefile             |   1 +
 arch/arm64/kernel/kvm.c                | 478 +++++++++++++++++++++++++
 arch/arm64/kernel/setup.c              |  32 ++
 arch/arm64/kernel/signal.c             |  17 +
 arch/arm64/kvm/Kconfig                 |   1 +
 arch/arm64/kvm/Makefile                |   1 +
 arch/arm64/kvm/arm.c                   |  45 ++-
 arch/arm64/kvm/async_pf.c              | 462 ++++++++++++++++++++++++
 arch/arm64/kvm/hypercalls.c            |  37 +-
 arch/arm64/kvm/mmu.c                   |  47 ++-
 arch/arm64/kvm/sdei.c                  |   8 +
 include/acpi/actbl2.h                  |  18 +
 include/linux/arm-smccc.h              |  41 +++
 23 files changed, 1321 insertions(+), 27 deletions(-)
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
