Return-Path: <SRS0=QOrb=52=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDFFC2BA2B
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 09:42:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2BC2820787
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 09:42:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e5gebCcw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BC2820787
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 863764B1E8;
	Fri, 10 Apr 2020 05:42:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nIh0TgmO5PIL; Fri, 10 Apr 2020 05:42:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 391904B1A0;
	Fri, 10 Apr 2020 05:42:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D03EE4B0CF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 04:58:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ioW2AT6r+gC0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2020 04:58:47 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC88D4B0BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 04:58:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586509127;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=G3f0EPaOuYHkB6GokgNnOnOoW30L4EgkhXCQaRsBz9g=;
 b=e5gebCcwB7yUSm2nsjpGn2fYTxkVN+P41hGrALd8hVhjGGQvTPaiQKnQu3RA56Izg25B+m
 h5VxkokC6Caw8aYi9LRc3lN5kEKd64ZOYj8iDEBiMvrtF2G0Nb6RJS3FyHPlh/8w8c8fWe
 5esB17y1+3Myje1MPqM5I3/h1tBlPXM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-StyM4M6KPfyBp5fqS3K5uw-1; Fri, 10 Apr 2020 04:58:45 -0400
X-MC-Unique: StyM4M6KPfyBp5fqS3K5uw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 111B218C35A1;
 Fri, 10 Apr 2020 08:58:44 +0000 (UTC)
Received: from 192-168-1-115.tpgi.com.com (vpn2-54-29.bne.redhat.com
 [10.64.54.29])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 69B65BEA67;
 Fri, 10 Apr 2020 08:58:35 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH RFCv1 0/7] Support Async Page Fault
Date: Fri, 10 Apr 2020 18:58:13 +1000
Message-Id: <20200410085820.758686-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Fri, 10 Apr 2020 05:42:17 -0400
Cc: maz@kernel.org, sudeep.holla@arm.com, shan.gavin@gmail.com,
 catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

There are two stages of page faults and the stage one page fault is
handled by guest itself. The guest is trapped to host when the page
fault is caused by stage 2 page table, for example missing. The guest
is suspended until the requested page is populated. To populate the
requested page can be costly and might be related to IO activities
if the page was swapped out previously. In this case, the guest has
to suspend for a few of milliseconds at least, regardless of the
overall system load.

The series adds support to asychornous page fault to improve above
situation. If it's costly to populate the requested page, a signal
(PAGE_NOT_PRESENT) is sent to guest so that the faulting process can
be rescheduled if it can be. Otherwise, it is put into power-saving
mode. Another signal (PAGE_READY) is sent to guest once the requested
page is populated so that the faulting process can be waken up either
from either waiting state or power-saving state.

In order to fulfil the control flow and convey signals between host
and guest. A IMPDEF system register (SYS_ASYNC_PF_EL1) is introduced.
The register accepts control block's physical address, plus requested
features. Also, the signal is sent using data abort with the specific
IMPDEF Data Fault Status Code (DFSC). The specific signal is stored
in the control block by host, to be consumed by guest.

Todo
====
* CONFIG_KVM_ASYNC_PF_SYNC is disabled for now because the exception
  injection can't work in nested mode. It might be something to be
  improved in future.
* KVM_ASYNC_PF_SEND_ALWAYS is disabled even with CONFIG_PREEMPTION
  because it's simply not working reliably.
* Tracepoints, which should something to be done in short term.
* kvm-unit-test cases.
* More testing and debugging are needed. Sometimes, the guest can be
  stuck and the root cause needs to be figured out.

PATCH[01] renames kvm_vcpu_get_hsr() to kvm_vcpu_get_esr() since the
          aarch32 host isn't supported.
PATCH[02] allows various helper functions to access ESR value from
          somewhere other than vCPU struct.
PATCH[03] replaces @hsr with @esr as aarch32 host isn't supported.
PATCH[04] exports kvm_handle_user_mem_abort(), which is used by the
          subsequent patch.
PATCH[05] introduces API to inject data abort with IMPDEF DFSC
PATCH[06] supports asynchronous page fault for host
PATCH[07] supports asynchronous page fault for guest

Testing
=======

Start a VM and its QEMU process is put into the specific memory cgroup.
The cgroup's memory limitation is less that the total amount of memory
assigned to the VM. For example, the VM is assigned with 4GB memory, but
the cgroup's limitaton is 2GB. A program is run after VM boots up, to
allocate (and access) all free memory. No system hang is found.

Gavin Shan (7):
  kvm/arm64: Rename kvm_vcpu_get_hsr() to kvm_vcpu_get_esr()
  kvm/arm64: Detach ESR operator from vCPU struct
  kvm/arm64: Replace hsr with esr
  kvm/arm64: Export kvm_handle_user_mem_abort() with prefault mode
  kvm/arm64: Allow inject data abort with specified DFSC
  kvm/arm64: Support async page fault
  arm64: Support async page fault

 arch/arm64/Kconfig                       |  11 +
 arch/arm64/include/asm/exception.h       |   5 +
 arch/arm64/include/asm/kvm_emulate.h     |  87 +++----
 arch/arm64/include/asm/kvm_host.h        |  46 ++++
 arch/arm64/include/asm/kvm_para.h        |  55 +++++
 arch/arm64/include/asm/sysreg.h          |   3 +
 arch/arm64/include/uapi/asm/Kbuild       |   3 -
 arch/arm64/include/uapi/asm/kvm_para.h   |  22 ++
 arch/arm64/kernel/smp.c                  |  47 ++++
 arch/arm64/kvm/Kconfig                   |   1 +
 arch/arm64/kvm/Makefile                  |   2 +
 arch/arm64/kvm/handle_exit.c             |  48 ++--
 arch/arm64/kvm/hyp/switch.c              |  33 +--
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |   7 +-
 arch/arm64/kvm/inject_fault.c            |  38 ++-
 arch/arm64/kvm/sys_regs.c                |  91 +++++--
 arch/arm64/mm/fault.c                    | 239 ++++++++++++++++++-
 virt/kvm/arm/aarch32.c                   |  27 ++-
 virt/kvm/arm/arm.c                       |  36 ++-
 virt/kvm/arm/async_pf.c                  | 290 +++++++++++++++++++++++
 virt/kvm/arm/hyp/aarch32.c               |   4 +-
 virt/kvm/arm/hyp/vgic-v3-sr.c            |   7 +-
 virt/kvm/arm/mmio.c                      |  27 ++-
 virt/kvm/arm/mmu.c                       |  69 ++++--
 24 files changed, 1040 insertions(+), 158 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_para.h
 delete mode 100644 arch/arm64/include/uapi/asm/Kbuild
 create mode 100644 arch/arm64/include/uapi/asm/kvm_para.h
 create mode 100644 virt/kvm/arm/async_pf.c

-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
