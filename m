Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9093644B7
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 11:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769080945; cv=none; b=DfIGUr9TjQeBgoZpK8K59YZqqk0+RimskgOnfuuIfx1qSQv/MNW0Fhv//k0r5yZD79hqUR+4O2nP7Si2Gb9jB29lEF/cU7RFGMhLnDZ9F+O1+zoZShpaLYCBzzpODwvvBbd68fqeodf+I4TahrPwLgTfJ3SqMCVtyrDSWPVot1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769080945; c=relaxed/simple;
	bh=/mtIyzUL0PF1roZhK47lcDjbWk2ZW58B0DLICGKk6rI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U6uywuBf8HhqsaCU5/xqjjkBEQa8j8wbjQnoh+rPDca6SKjm834VWCCo/aZkZt+QCr/k37zvicCqMLOhP5LC3ZouumGIrg2IkopW7DM1nphLnargDlOVXgdbCvTiVD++hIjTcgvLIs7oYvZg54hNsZBrD/vl9Xy+T7WF36P7CaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FOnXKSG0; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FOnXKSG0"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-64b735f514dso901440a12.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 03:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769080942; x=1769685742; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2J6EeAezXJllHDzySrmJ4PCNEfxO88c9P+Q7J7R6rRw=;
        b=FOnXKSG0EMD7UTvx6xqro54Vxe2Xw8bN16WoYhWoqbLmJntqpnTfsgr9HqhQsOtJnl
         +inuHFhbeLQ8dZIQ80xmM+EqphEWS6BzQVAVUrM4N3aWnpsBOgRXCf66Jp0KB2bZoTMy
         0Uux+ZFac8QQ68zRi9FyWYBd+1fyT3xG9k7i44IkObIMYTCyUA7UYKcYh/6U9YUBRZA4
         0OmI3x9bYFvjmqh0dyMxZON/THRyiv3Hh6HntIUgxoq8UkTLRmO6RA8mBBvXKQL1ftpv
         lv5edVAAK5t2+fxdY0PpfgwyXplyaxN8P2b7YJL3OA0WBvoY4DjFD+/K2dgwYqkLfem9
         ukgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769080942; x=1769685742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2J6EeAezXJllHDzySrmJ4PCNEfxO88c9P+Q7J7R6rRw=;
        b=eE0SiHkxFS18h+O1RDckDkEmMoiDcLmM7JEufUyRjraOujlAzD0ge1AgNgL4MBkTir
         JXhD3Btko+4WxdSwErRwaKy8RG8pL53upAvqO9kaTdnJeDLYFO4047NqoSWiqG6k/VlS
         GMT8UAqTKCseaOQgjLkTvgSR6ITDtP+xG3fwCTXh3V0Bu5aBVHPOuCNQ9cBYe7zAX6gh
         IldFCqL3o/S7qlZPK3G/x5opSPFbHzFt/WpUbsvJQ/mxZTLO+Kq3R80C3l4z7JQW0re9
         Hk3Wff32Csd6y8pk0JvthMoGC4Y1kkx66Ej0+a7LOiRzPkbuzYXblG+FDT14TfufSwn9
         KFZQ==
X-Gm-Message-State: AOJu0YwgBdnLV+Z/p8Paz6d9TgCWBhJmYBSYhfiNP7dIGul9D2lk5VTI
	NUFoKpM5gx8kycpy3go9liKJCag7VCHSacFzy1fRh0ZRHAHTVdlX8di0Fgj+XlqGf1SAklGrCiS
	9RiUOzG3k/pYxJrte6pDCB97h8HgtkiJAorEqPuSwMG+dHOhVHoJjC1xV+UWpjs2FuVO3Bu/zmT
	eR8+W02SEsFJLbUQVkp1Y9j5n1LcXJ+Jk=
X-Received: from eduf18.prod.google.com ([2002:a05:6402:52:b0:64b:c59e:7562])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:2550:b0:658:1eee:8a4a
 with SMTP id 4fb4d7f45d1cf-6581eee8d21mr2762062a12.11.1769080941575; Thu, 22
 Jan 2026 03:22:21 -0800 (PST)
Date: Thu, 22 Jan 2026 11:22:17 +0000
In-Reply-To: <20260122112218.531948-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260122112218.531948-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260122112218.531948-4-tabba@google.com>
Subject: [PATCH v3 3/4] KVM: arm64: Inject UNDEF when accessing MTE sysregs
 with MTE disabled
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

When MTE hardware is present but disabled via software (`arm64.nomte` or
`CONFIG_ARM64_MTE=n`), the kernel clears `HCR_EL2.ATA` and sets
`HCR_EL2.TID5`, to prevent the use of MTE instructions.

Additionally, accesses to certain MTE system registers trap to EL2 with
exception class ESR_ELx_EC_SYS64. To emulate hardware without MTE (where
such accesses would cause an Undefined Instruction exception), inject
UNDEF into the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 67 ++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index a7c689152f68..faed1b38e6cc 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -687,6 +687,69 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 	kvm_skip_host_instr();
 }
 
+/*
+ * Inject an Undefined Instruction exception into the host.
+ *
+ * This is open-coded to allow control over PSTATE construction without
+ * complicating the generic exception entry helpers.
+ */
+static void inject_undef64(void)
+{
+	u64 spsr_mask, vbar, sctlr, old_spsr, new_spsr, esr, offset;
+
+	spsr_mask = PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT | PSR_V_BIT | PSR_DIT_BIT | PSR_PAN_BIT;
+
+	vbar = read_sysreg_el1(SYS_VBAR);
+	sctlr = read_sysreg_el1(SYS_SCTLR);
+	old_spsr = read_sysreg_el2(SYS_SPSR);
+
+	new_spsr = old_spsr & spsr_mask;
+	new_spsr |= PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT;
+	new_spsr |= PSR_MODE_EL1h;
+
+	if (!(sctlr & SCTLR_EL1_SPAN))
+		new_spsr |= PSR_PAN_BIT;
+
+	if (sctlr & SCTLR_ELx_DSSBS)
+		new_spsr |= PSR_SSBS_BIT;
+
+	if (system_supports_mte())
+		new_spsr |= PSR_TCO_BIT;
+
+	esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT) | ESR_ELx_IL;
+	offset = CURRENT_EL_SP_ELx_VECTOR + except_type_sync;
+
+	write_sysreg_el1(esr, SYS_ESR);
+	write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
+	write_sysreg_el1(old_spsr, SYS_SPSR);
+	write_sysreg_el2(vbar + offset, SYS_ELR);
+	write_sysreg_el2(new_spsr, SYS_SPSR);
+}
+
+static bool handle_host_mte(u64 esr)
+{
+	switch (esr_sys64_to_sysreg(esr)) {
+	case SYS_RGSR_EL1:
+	case SYS_GCR_EL1:
+	case SYS_TFSR_EL1:
+	case SYS_TFSRE0_EL1:
+		/* If we're here for any reason other than MTE, it's a bug. */
+		if (read_sysreg(HCR_EL2) & HCR_ATA)
+			return false;
+		break;
+	case SYS_GMID_EL1:
+		/* If we're here for any reason other than MTE, it's a bug. */
+		if (!(read_sysreg(HCR_EL2) & HCR_TID5))
+			return false;
+		break;
+	default:
+		return false;
+	}
+
+	inject_undef64();
+	return true;
+}
+
 void handle_trap(struct kvm_cpu_context *host_ctxt)
 {
 	u64 esr = read_sysreg_el2(SYS_ESR);
@@ -702,6 +765,10 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 	case ESR_ELx_EC_DABT_LOW:
 		handle_host_mem_abort(host_ctxt);
 		break;
+	case ESR_ELx_EC_SYS64:
+		if (handle_host_mte(esr))
+			break;
+		fallthrough;
 	default:
 		BUG();
 	}
-- 
2.52.0.457.g6b5491de43-goog

