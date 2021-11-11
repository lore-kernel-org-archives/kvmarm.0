Return-Path: <SRS0=nF4w=P6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2926C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 02:07:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 32258611AD
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 02:07:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 32258611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D3214B17C;
	Wed, 10 Nov 2021 21:07:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d6PoDU0uwwDa; Wed, 10 Nov 2021 21:07:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3E054B162;
	Wed, 10 Nov 2021 21:07:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29D1C4B15A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 21:07:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ArkwTCbGJnfi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 21:07:42 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17A954B12E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 21:07:42 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 t75-20020a63784e000000b002993a9284b0so2485803pgc.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 18:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:message-id:mime-version:subject:from:to:cc;
 bh=tUIQRP/L4Fp0gX6OhmNi7HbxcL+5uZ5JBj+c5s8Epc0=;
 b=SHNbfqTm3J0sCYDnSCPJl2DJ6T9yOTXJQHvuHx8d04TG6gGxpzfaf/C1v4gFFxrBPV
 Nqw7AUHS01qZz0UD93QTZiHv9vFDhe2GdeiYEKJ4f9tX2pvUysavfJFD5gQ4gNAG6pKe
 lJuw7Z3tdfLgDKejGON+MO9SGmEzmVIPRzmdTSDCNpCRdZIISx15JlmN7eHU6e0hABbO
 ggSU2q0H1akcoFCvWhLk23HEYoCc8zZRMmEW+nbv3sbHxH0cDekH6WrEbtb1X+tgaA6k
 FbiWW2J5zLyfWA9uMi2CyYilMp6JqRACLddKb1B7Cqi9I+sv88k2AOHAQxuAqltrxkop
 Ei4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
 :from:to:cc;
 bh=tUIQRP/L4Fp0gX6OhmNi7HbxcL+5uZ5JBj+c5s8Epc0=;
 b=FNvIUxEW9iEl8Eua1nr85TjvXjGkZS+yJoSln3paaB33iYc3Sq59EJPipW+yw1oPvq
 zsURWZnVQbl4EPCG6krcLwSsSh+oG3ZSpkLr6THGLxtFmqcsX4ZFEQTyPvCojHDSBbpe
 a4wOY413Zgolx3EiFoxKBTJiAS6guCBRRCp2KxpmhVGTRptxP8zpTbLnWAookRQgZ0nS
 ZjKEJfw5CfDH3MQMYuTB6rcprnxG9WaZ2BjySFiL8hsaQ95HIpBfBf/11NDvB0J86By3
 9lgg3UwjBr16aZXhyBVLI6V/PFfE3+h0URkdWfboZoyzn4BZ6xZB4qb1Dod8QDrHy4mM
 Sg5w==
X-Gm-Message-State: AOAM531Uu/jQqK+ASjy6ZVB5Hkm8ytZyzPngMxriRotzV5WHHk67pvJb
 zCzCc91jyiUfmAkjj7hbD36XNk70d/4=
X-Google-Smtp-Source: ABdhPJyLbpoo29ePfTjvBFgohxjl3NBLChAqmG4K4wYBtXh/2rWx5xqvq1BN1sRzHdfKDemaaNnkz7tBMNU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:2004:b0:142:6344:2c08
 with SMTP id
 s4-20020a170903200400b0014263442c08mr3739627pla.51.1636596461111; Wed, 10 Nov
 2021 18:07:41 -0800 (PST)
Date: Thu, 11 Nov 2021 02:07:21 +0000
Message-Id: <20211111020738.2512932-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH v4 00/17] perf: KVM: Fix, optimize, and clean up callbacks
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, 
 Russell King <linux@armlinux.org.uk>, Marc Zyngier <maz@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>, 
 Nick Hu <nickhu@andestech.com>, Greentime Hu <green.hu@gmail.com>, 
 Vincent Chen <deanbo422@gmail.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 Paolo Bonzini <pbonzini@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
 Juergen Gross <jgross@suse.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Jiri Olsa <jolsa@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Stefano Stabellini <sstabellini@kernel.org>, Like Xu <like.xu@linux.intel.com>,
 Joerg Roedel <joro@8bytes.org>, linux-csky@vger.kernel.org,
 xen-devel@lists.xenproject.org, Zhu Lingshan <lingshan.zhu@intel.com>,
 Namhyung Kim <namhyung@kernel.org>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Like Xu <like.xu.linux@gmail.com>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

This is a combination of ~2 series to fix bugs in the perf+KVM callbacks,
optimize the callbacks by employing static_call, and do a variety of
cleanup in both perf and KVM.

For the non-perf patches, I think everything except patch 13 (Paolo) and
patches 15 and 16 (Marc) has the appropriate acks.

Patch 1 fixes a set of mostly-theoretical bugs by protecting the guest
callbacks pointer with RCU.

Patches 2 and 3 fix an Intel PT handling bug where KVM incorrectly
eats PT interrupts when PT is supposed to be owned entirely by the host.

Patches 4-9 clean up perf's callback infrastructure and switch to
static_call for arm64 and x86 (the only survivors).

Patches 10-17 clean up related KVM code and unify the arm64/x86 callbacks.

Based on Linus' tree, commit cb690f5238d7 ("Merge tag 'for-5.16/drivers...).

v4:
  - Rebase.
  - Collect acks and reviews.
  - Fully protect perf_guest_cbs with RCU. [Paolo].
  - Add patch to hide arm64's kvm_arm_pmu_available behind
    CONFIG_HW_PERF_EVENTS=y.

v3:
  - https://lore.kernel.org/all/20210922000533.713300-1-seanjc@google.com/
  - Add wrappers for guest callbacks to that stubs can be provided when
    GUEST_PERF_EVENTS=n.
  - s/HAVE_GUEST_PERF_EVENTS/GUEST_PERF_EVENTS and select it from KVM
    and XEN_PV instead of from top-level arm64/x86. [Paolo]
  - Drop an unnecessary synchronize_rcu() when registering callbacks. [Peter]
  - Retain a WARN_ON_ONCE() when unregistering callbacks if the caller
    didn't provide the correct pointer. [Peter]
  - Rework the static_call patch to move it all to common perf.
  - Add a patch to drop the (un)register stubs, made possible after
    having KVM+XEN_PV select GUEST_PERF_EVENTS.
  - Split dropping guest callback "support" for arm, csky, etc... to a
    separate patch, to make introducing GUEST_PERF_EVENTS cleaner.
  
v2 (relative to static_call v10):
  - Split the patch into the semantic change (multiplexed ->state) and
    introduction of static_call.
  - Don't use '0' for "not a guest RIP".
  - Handle unregister path.
  - Drop changes for architectures that can be culled entirely.

v2 (relative to v1):
  - https://lkml.kernel.org/r/20210828003558.713983-6-seanjc@google.com
  - Drop per-cpu approach. [Peter]
  - Fix mostly-theoretical reload and use-after-free with READ_ONCE(),
    WRITE_ONCE(), and synchronize_rcu(). [Peter]
  - Avoid new exports like the plague. [Peter]

v1:
  - https://lkml.kernel.org/r/20210827005718.585190-1-seanjc@google.com

v10 static_call:
  - https://lkml.kernel.org/r/20210806133802.3528-2-lingshan.zhu@intel.com

Like Xu (1):
  perf/core: Rework guest callbacks to prepare for static_call support

Sean Christopherson (16):
  perf: Protect perf_guest_cbs with RCU
  KVM: x86: Register perf callbacks after calling vendor's
    hardware_setup()
  KVM: x86: Register Processor Trace interrupt hook iff PT enabled in
    guest
  perf: Stop pretending that perf can handle multiple guest callbacks
  perf: Drop dead and useless guest "support" from arm, csky, nds32 and
    riscv
  perf: Add wrappers for invoking guest callbacks
  perf: Force architectures to opt-in to guest callbacks
  perf/core: Use static_call to optimize perf_guest_info_callbacks
  KVM: x86: Drop current_vcpu for kvm_running_vcpu + kvm_arch_vcpu
    variable
  KVM: x86: More precisely identify NMI from guest when handling PMI
  KVM: Move x86's perf guest info callbacks to generic KVM
  KVM: x86: Move Intel Processor Trace interrupt handler to vmx.c
  KVM: arm64: Convert to the generic perf callbacks
  KVM: arm64: Hide kvm_arm_pmu_available behind CONFIG_HW_PERF_EVENTS=y
  KVM: arm64: Drop perf.c and fold its tiny bits of code into arm.c
  perf: Drop guest callback (un)register stubs

 arch/arm/kernel/perf_callchain.c   | 28 ++------------
 arch/arm64/include/asm/kvm_host.h  | 11 +++++-
 arch/arm64/kernel/image-vars.h     |  2 +
 arch/arm64/kernel/perf_callchain.c | 13 ++++---
 arch/arm64/kvm/Kconfig             |  1 +
 arch/arm64/kvm/Makefile            |  2 +-
 arch/arm64/kvm/arm.c               | 10 ++++-
 arch/arm64/kvm/perf.c              | 59 ------------------------------
 arch/arm64/kvm/pmu-emul.c          |  2 +
 arch/csky/kernel/perf_callchain.c  | 10 -----
 arch/nds32/kernel/perf_event_cpu.c | 29 ++-------------
 arch/riscv/kernel/perf_callchain.c | 10 -----
 arch/x86/events/core.c             | 13 ++++---
 arch/x86/events/intel/core.c       |  5 +--
 arch/x86/include/asm/kvm_host.h    |  7 +++-
 arch/x86/kvm/Kconfig               |  1 +
 arch/x86/kvm/pmu.c                 |  2 +-
 arch/x86/kvm/svm/svm.c             |  2 +-
 arch/x86/kvm/vmx/vmx.c             | 25 ++++++++++++-
 arch/x86/kvm/x86.c                 | 58 +++++------------------------
 arch/x86/kvm/x86.h                 | 17 +++++++--
 arch/x86/xen/Kconfig               |  1 +
 arch/x86/xen/pmu.c                 | 32 +++++++---------
 include/kvm/arm_pmu.h              | 19 ++++++----
 include/linux/kvm_host.h           | 10 +++++
 include/linux/perf_event.h         | 44 ++++++++++++++++------
 init/Kconfig                       |  4 ++
 kernel/events/core.c               | 41 +++++++++++++++------
 virt/kvm/kvm_main.c                | 44 ++++++++++++++++++++++
 29 files changed, 246 insertions(+), 256 deletions(-)
 delete mode 100644 arch/arm64/kvm/perf.c

-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
