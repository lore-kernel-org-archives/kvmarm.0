Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DA8399002
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 22:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783551139; cv=none; b=s1H4YsyY/moiByafWC9CPdkDUYWcIIyW7F6ujFeN96Pg6EruX5HgPZNyhmZroJDe+ykKqXM1k1pkQOnj86aanyUBBls8Hx44aCfQaDYSqWO14G2xd0njcx+fbGfj2M0pBg6lR0Nq/oDcqyr8jaF8Fvn6r6KZQpb9UpOh1ekdbrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783551139; c=relaxed/simple;
	bh=lIhEm2wVtEXNQNvGEaqy2EwOqFAEAnqOIu34Qyyuk0A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GZo/XPnXCJVj9efBIGCJgjvSv6a4mzEzM/Lq6R8dtkPROgFoKXvlWqkQqtzQQGl746lQ1C9dl6U23tUU5/e+5fGnmCDDMPPYrh/4mwV7u72aMLcsDZwlIzWEUL3i0pXXoZMOvkwiiVtjtGwtARrXAO0QLhj6BDxE32jfCToHCkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BiV59Ifc; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BiV59Ifc"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7e9f6f0240eso1429918a34.3
        for <kvmarm@lists.linux.dev>; Wed, 08 Jul 2026 15:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783551133; x=1784155933; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mutBHrPPn84rf+SwTAASYZI6R7q+QxGKCuZHvQ7HuZU=;
        b=BiV59Ifc5Pzxc/DcP8m0TsC53dkR0fzojFK1KC7n5wJ1F0TwMVncjrBzvSNDJcBdQ5
         qvNizUy504/Ffp4tG1lXzqeIg5fyTeoJ+GmL3MQR4Wy24Yp99gW/gMKo3txwyuDiGtTa
         lfmS6wgfc9VgF+3SIo8g5d3yurxcKgJwvkIcV9UHdDvc7I9vn4xiqKsiohfOpJOOgDfC
         41weI+0KOdsiKiI9dofwEbgPPzjfdHPOs3sfaUcGgM9r0v98Jm6ZprEWSlb7falWHijB
         m7ySSCQIaMFTIHenTgYv17E1DdfsbW/Sy8BBUV0+drjiQDLN8XFSusr6arsdz8ppaoTJ
         RjLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783551133; x=1784155933;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mutBHrPPn84rf+SwTAASYZI6R7q+QxGKCuZHvQ7HuZU=;
        b=MI0lA3ixDE1+Yqsxd+Jmk7T6BkqUS+D1Vc0QyuN7ZBTyHjLQEWRZp1CTeAzXEiz4pc
         SPBntwPuVgcfkSmb4eXk1Dt1/AmOwnm4lZSxVPc1QG4riq/wBgmvraSkgCOEe1SXs09s
         R+J8GfSu5t60vQI0hEolZTbfo0YmAZdueM4UxIJgnV2ubzPPwbgRCPasM1lGm7gBS0uE
         G7BT37plOyG8In+AtgKvmAJBly30zWyg3mza04J8ajgFXJGiypBpwD49UP4LKN+DFqoF
         j//LF6iC/Ef1M7VCgArTejDh+QaYSbRV+DkYQJi7zQ481YG6SEj5VF7b9RilF+EwEY43
         IiVg==
X-Forwarded-Encrypted: i=1; AFNElJ+vGB85dRWlbZCs88IR3KiJML0It66lnRtBSCr3rxmc4NYecgQjEDkSJPqhuaZxc4hvjlIX+ME=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3iXm6gixan/z7h0YRMQJuQHws0LwFtq3sqRhl7ymXMsaQoLwI
	8WmcLN+1TZvu6wZt1RvzNJo0oC/3ILrXYRmxsN9Ru59216jl78XnW0ZSeBTZUfSn6v1s5rM3lMZ
	YXs/HLTATBdnNZJnjnaX3BFRzvg==
X-Received: from iltr14.prod.google.com ([2002:a92:c5ae:0:b0:502:eb99:7080])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:c0d4:10b0:6a3:76ab:476b with SMTP id 006d021491bc7-6a376ab4a96mr1122254eaf.57.1783551132443;
 Wed, 08 Jul 2026 15:52:12 -0700 (PDT)
Date: Wed,  8 Jul 2026 22:51:23 +0000
In-Reply-To: <20260708225124.4130846-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260708225124.4130846-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708225124.4130846-6-coltonlewis@google.com>
Subject: [PATCH 6.6 v2 5/6] KVM: arm64: Initialize SCTLR_EL1 in __kvm_hyp_init_cpu()
From: Colton Lewis <coltonlewis@google.com>
To: stable@vger.kernel.org
Cc: oliver.upton@linux.dev, sashal@kernel.org, gregkh@linuxfoundation.org, 
	mizhang@google.com, catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, ahmed.genidi@arm.com, leo.yan@arm.com, 
	miguel.luis@oracle.com, dbrazdil@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Ben Horgan <ben.horgan@arm.com>
Content-Type: text/plain; charset="UTF-8"

From: Ahmed Genidi <ahmed.genidi@arm.com>

[ Upstream commit 3855a7b91d42ebf3513b7ccffc44807274978b3d ]

When KVM is in protected mode, host calls to PSCI are proxied via EL2,
and cold entries from CPU_ON, CPU_SUSPEND, and SYSTEM_SUSPEND bounce
through __kvm_hyp_init_cpu() at EL2 before entering the host kernel's
entry point at EL1. While __kvm_hyp_init_cpu() initializes SPSR_EL2 for
the exception return to EL1, it does not initialize SCTLR_EL1.

Due to this, it's possible to enter EL1 with SCTLR_EL1 in an UNKNOWN
state. In practice this has been seen to result in kernel crashes after
CPU_ON as a result of SCTLR_EL1.M being 1 in violation of the initial
core configuration specified by PSCI.

Fix this by initializing SCTLR_EL1 for cold entry to the host kernel.
As it's necessary to write to SCTLR_EL12 in VHE mode, this
initialization is moved into __kvm_host_psci_cpu_entry() where we can
use write_sysreg_el1().

The remnants of the '__init_el2_nvhe_prepare_eret' macro are folded into
its only caller, as this is clearer than having the macro.

Fixes: cdf367192766ad11 ("KVM: arm64: Intercept host's CPU_ON SMCs")
Reported-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Ahmed Genidi <ahmed.genidi@arm.com>
[ Mark: clarify commit message, handle E2H, move to C, remove macro ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ahmed Genidi <ahmed.genidi@arm.com>
Cc: Ben Horgan <ben.horgan@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Link: https://lore.kernel.org/r/20250227180526.1204723-3-mark.rutland@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h   | 4 ----
 arch/arm64/kernel/head.S             | 3 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S   | 1 -
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 3 +++
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 3498dc5d02c18..76b0d50d286d5 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -229,10 +229,6 @@
 .Lskip_fgt_\@:
 .endm
 
-.macro __init_el2_nvhe_prepare_eret
-	mov	x0, #INIT_PSTATE_EL1
-	msr	spsr_el2, x0
-.endm
 
 /**
  * Initialize EL2 registers to sane values. This should be called early on all
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index ff7769821166a..9996029853d23 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -601,7 +601,8 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
 	msr	sctlr_el1, x1
 	mov	x2, xzr
 3:
-	__init_el2_nvhe_prepare_eret
+	mov	x0, #INIT_PSTATE_EL1
+	msr	spsr_el2, x0
 
 	mov	w0, #BOOT_CPU_MODE_EL2
 	orr	x0, x0, x2
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 3efa9cfaa9d48..9b2ada54be538 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -207,7 +207,6 @@ SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
 	/* Initialize EL2 CPU state to sane values. */
 	init_el2_state				// Clobbers x0..x2
 	finalise_el2_state
-	__init_el2_nvhe_prepare_eret
 
 	/* Enable MMU, set vectors and stack. */
 	mov	x0, x28
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index d57bcb6ab94d2..5688a16e2ea75 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -218,6 +218,9 @@ asmlinkage void __noreturn __kvm_host_psci_cpu_entry(bool is_cpu_on)
 	if (is_cpu_on)
 		release_boot_args(boot_args);
 
+	write_sysreg_el1(INIT_SCTLR_EL1_MMU_OFF, SYS_SCTLR);
+	write_sysreg(INIT_PSTATE_EL1, SPSR_EL2);
+
 	__host_enter(host_ctxt);
 }
 
-- 
2.55.0.795.g602f6c329a-goog

