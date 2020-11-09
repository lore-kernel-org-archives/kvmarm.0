Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CC4C388F7
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:32:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F1B3D2084C
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:32:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="BXaNTDV/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1B3D2084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 136EE4B749;
	Mon,  9 Nov 2020 06:32:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4nLjxUDGHsBk; Mon,  9 Nov 2020 06:32:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E65BF4B73E;
	Mon,  9 Nov 2020 06:32:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 940E84B71D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:32:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jr1QWQfE8irY for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:32:41 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5FDBB4B710
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:32:41 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id 33so8296346wrl.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=0ZRwpWqiRxh6H0dUE4gLBKSGk4q2tKmquRejIxcgxFE=;
 b=BXaNTDV/I9A+Ior9s2SMJWvnZvN3f8FvwZ1ZxGgerLSQJ8qM+G9dnZTuJ5gnntBYcR
 rWKHFep/4eNrOkmlVjA8KtaSh2Gr21go+Dw3Gmi2lI0FifKAi/4vV9liP2vmu7tjJNnn
 NyOmf0yW+IpfyKrLs0Co5BX0RysMtqmmLjKUI9rCTbqC7CFbQw8gNIMVwtNptBovLv01
 k1g/LGidp549GuxAnjb+9U/05zR1kXPz35KHPcnXQwJhkAxwsaGU5Vew0zxBbu2EafU5
 LdpHE2h6Lt2VJGGcnTNtcLes3yIYOhAktTFXJKztOm+cKRN/TZpG2qNyY/QMue+8cLYM
 3M8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=0ZRwpWqiRxh6H0dUE4gLBKSGk4q2tKmquRejIxcgxFE=;
 b=BGzT6Ua6oviWskEmRedoyGSzK224qxR2ztM4I/UumjbwuyS2LAAZjoBLqLIaklE5kW
 uA3Hkz9anmwPLgvYjzf0YBBbqvebf45M+i86+Mqiv401cbh9j7PUUFp0jTEIAZ0qQkNo
 ABTNNKYTkRXY3fahnl3jWYuEoeoMoC42zl6pvBY9aEZoYhnBJI2POlHjcOA5F+pfVm2B
 dWPvrJL/PTntBBDYK1qJAs9MYB2mos14JV3ZhdVtETEbYGeokRK4Uc31nCZJLz6GWHeS
 SoVHiR7KQW0639sAIWHRQUR009lAxFYXiRRh8pW/6KyvEmeeH4U/qsAMOhEqx2pmRnSV
 Kqow==
X-Gm-Message-State: AOAM5302DW0uJl7uOzwFnGwquNwp23q1jP+JoiD7N+mMh1vp1llR/10k
 oeKmGBN39rAV9vDyYgIC0Kk8PCc+5TuWeg==
X-Google-Smtp-Source: ABdhPJzDsIAHjs/TbQ/3Gce0pr8CVqmGsBHIkcGYcAHffi2qKUhqIo5HkYvg7EyAu3nXBqwQxOkmfw==
X-Received: by 2002:adf:fe82:: with SMTP id l2mr12800711wrr.406.1604921559749; 
 Mon, 09 Nov 2020 03:32:39 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id s202sm12524126wme.39.2020.11.09.03.32.37
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:32:38 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 00/24] Opt-in always-on nVHE hypervisor
Date: Mon,  9 Nov 2020 11:32:09 +0000
Message-Id: <20201109113233.9012-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

As we progress towards being able to keep guest state private to the
host running nVHE hypervisor, this series allows the hypervisor to
install itself on newly booted CPUs before the host is allowed to run
on them.

All functionality described below is opt-in, guarded by an early param
'kvm-arm.protected'. Future patches specific to the new "protected" mode
should be hidden behind the same param.

The hypervisor starts trapping host SMCs and intercepting host's PSCI
CPU_ON/OFF/SUSPEND calls. It replaces the host's entry point with its
own, initializes the EL2 state of the new CPU and installs the nVHE hyp
vector before ERETing to the host's entry point.

The kernel checks new cores' features against the finalized system
capabilities. To avoid the need to move this code/data to EL2, the
implementation only allows to boot cores that were online at the time of
KVM initialization and therefore had been checked already.

Other PSCI SMCs are forwarded to EL3, though only the known set of SMCs
implemented in the kernel is allowed. Non-PSCI SMCs are also forwarded
to EL3. Future changes will need to ensure the safety of all SMCs wrt.
private guests.

The host is still allowed to reset EL2 back to the stub vector, eg. for
hibernation or kexec, but will not disable nVHE when there are no VMs.

Tested on Rock Pi 4b, based on 5.10-rc3.

changes since rfc:
  * add early param to make features opt-in
  * simplify CPU_ON/SUSPEND implementation
  * replace spinlocks with CAS atomic
  * make cpu_logical_map ro_after_init

  -David

David Brazdil (24):
  psci: Accessor for configured PSCI version
  psci: Accessor for configured PSCI function IDs
  arm64: Move MAIR_EL1_SET to asm/memory.h
  kvm: arm64: Initialize MAIR_EL2 using a constant
  kvm: arm64: Add .hyp.data..ro_after_init ELF section
  kvm: arm64: Support per_cpu_ptr in nVHE hyp code
  kvm: arm64: Create nVHE copy of cpu_logical_map
  kvm: arm64: Move hyp-init params to a per-CPU struct
  kvm: arm64: Refactor handle_trap to use a switch
  kvm: arm64: Extract parts of el2_setup into a macro
  kvm: arm64: Add SMC handler in nVHE EL2
  kvm: arm64: Extract __do_hyp_init into a helper function
  kvm: arm64: Add CPU entry point in nVHE hyp
  kvm: arm64: Add function to enter host from KVM nVHE hyp code
  kvm: arm64: Bootstrap PSCI SMC handler in nVHE EL2
  kvm: arm64: Add offset for hyp VA <-> PA conversion
  kvm: arm64: Add __hyp_pa_symbol helper macro
  kvm: arm64: Forward safe PSCI SMCs coming from host
  kvm: arm64: Intercept host's PSCI_CPU_ON SMCs
  kvm: arm64: Intercept host's CPU_SUSPEND PSCI SMCs
  kvm: arm64: Add kvm-arm.protected early kernel parameter
  kvm: arm64: Keep nVHE EL2 vector installed
  kvm: arm64: Trap host SMCs in protected mode.
  kvm: arm64: Fix EL2 mode availability checks

 arch/arm64/include/asm/kvm_arm.h   |   1 +
 arch/arm64/include/asm/kvm_asm.h   | 136 ++++++++++++++
 arch/arm64/include/asm/kvm_hyp.h   |   9 +
 arch/arm64/include/asm/memory.h    |  13 ++
 arch/arm64/include/asm/percpu.h    |   6 +
 arch/arm64/include/asm/sections.h  |   1 +
 arch/arm64/include/asm/virt.h      |  26 +++
 arch/arm64/kernel/asm-offsets.c    |   5 +
 arch/arm64/kernel/head.S           | 140 ++------------
 arch/arm64/kernel/image-vars.h     |   7 +
 arch/arm64/kernel/vmlinux.lds.S    |  10 +
 arch/arm64/kvm/arm.c               | 157 ++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/Makefile   |   3 +-
 arch/arm64/kvm/hyp/nvhe/host.S     |   9 +
 arch/arm64/kvm/hyp/nvhe/hyp-init.S |  84 +++++++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  56 +++++-
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S  |   1 +
 arch/arm64/kvm/hyp/nvhe/percpu.c   |  38 ++++
 arch/arm64/kvm/hyp/nvhe/psci.c     | 291 +++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c   |   5 +-
 arch/arm64/mm/proc.S               |  13 --
 drivers/firmware/psci/psci.c       |  25 ++-
 include/linux/psci.h               |  18 ++
 include/uapi/linux/psci.h          |   1 +
 24 files changed, 865 insertions(+), 190 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/percpu.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/psci.c

-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
