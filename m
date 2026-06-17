Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF96230BE9
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 14:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781707752; cv=none; b=ga7CwNcBXoL2SBD5ToFSLAnR3eNNnyZsAqUQ9LPmv7d+Zry9a7j0mLFXW7vPbNsbTNkGSiQNQBtICfwK04nHHsVJ6EaDjiL7ryJzXshiIj0MyoVOq3uJk1M54q/gN7Tjm1MANrdgBpwXp8t7mlqrnpTGFM92UkVt4DfmAjb/bu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781707752; c=relaxed/simple;
	bh=q0pSEUqdJA4bwhaqc+E7N4lq2Ipxbkx0JIJ4VwtBBEA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jM/IgIUwuZVJNaYiPTQGPUPLp1J15o8WlZpq3RXhdhCp/jYZ++t4d1pCHEciuRWuLN7r3Mw7k8fn83y1782dxUc//e3AVqLFc7PadPuyDBmcGVQB36k7nvfPg+eNwTESAF690Lj8xv0gBlSOaYGr/6cCAdAtoyS8bWe5P1/1KX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jawYZys4; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jawYZys4"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-69565111f96so788808a12.0
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 07:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781707749; x=1782312549; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pMZzZ6fqN5YBPOf12bGJv42Jck9RA2bQObyqdO6aFM4=;
        b=jawYZys4z/tSkTxPbnyxxk6/CJI3N95y2p9H6nZOpG8mijqWSBJ6Fy2ME4FQ2O42Qn
         9Rz9NLDkIfZ841UWbrWbtOn5s/PpRxYlBpOfcFkYr+LwwBXMG+dBe2PUgbAtjql/cD7g
         5QpVzV9gdlu+ffq3Gm4dX0TYUFjFFLmTGKdinUR3Zo/UNxOcHR1/1y9dlMZ2ncudqYWe
         9zvWOWSdsmEg50YdDlIHieUufYEaFVoEabN/4VmUPcgot9B80j6ka1uxbgypgPWIYfI0
         7r1x75I8MUITcHZiVB/XKCJhfDgpFADsIqCQdW9c58lCyLg5h/XQoVg7x5Aee8emEJCo
         w88w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781707749; x=1782312549;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pMZzZ6fqN5YBPOf12bGJv42Jck9RA2bQObyqdO6aFM4=;
        b=i5EdP2MZE8w4fp7hfDddxes3MlkdaMy3ceidMwjXQqfDlzPsUa7tudk7y2G+C3rEkW
         6Tzj3eNnC4UwEkWtw3ktZK4L8rwYyMPmtcU1PfUYDnb3dpfL+N5d+Gp+pKGdX3sf01Nn
         hVFZQ5+DzS2UkEP0hSpbtbVjvdJJPXEhcDnQDWcm74RpMl0JXdPH0NWmtXljjVnP8BhH
         WI8rgJ46/mWQUJgZ0gPE9Ms2sNkyny2zYOrsLoGlmd8H9Wx8rrPqoCmoef07qsFAR0uS
         Mtjspqm74lUisSGiiD/43fjZhGAa8br+uf9aHlV2XCzeYEJwCIMgs9PBvkq23EsepmKW
         T+7g==
X-Forwarded-Encrypted: i=1; AFNElJ/6v1Sd9RYI4tGJ5MENKFZqr6uF0QSirADccP+KIkuT8N3D/OE2wqyZOltHmpSeX63mA97VUXQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwHlDR2bafSXnu7McginpfrturRSSmx0AWibYc+ue+uBsmBGC4X
	W6k169hPjREHdzY5F7JHWshwMbrjaqeWzZB3e+DFHgUhJ8IMqMcDttgnnQQMpq1r/ztLE1sRGMe
	sLQ==
X-Received: from edr13.prod.google.com ([2002:a05:6402:44cd:b0:68c:16ac:54aa])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:11ca:b0:68d:235a:cdaf
 with SMTP id 4fb4d7f45d1cf-695471ea956mr2493921a12.5.1781707748559; Wed, 17
 Jun 2026 07:49:08 -0700 (PDT)
Date: Wed, 17 Jun 2026 15:49:07 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260617144907.2972095-1-tabba@google.com>
Subject: [PATCH] KVM: arm64: nv: Fix PSTATE construction on illegal exception return
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Jintack Lim <jintack.lim@linaro.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, linux-kernel@vger.kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

kvm_check_illegal_exception_return() sourced the flags {N,Z,C,V} and
masks {D,A,I,F} of the resulting PSTATE from the current PSTATE, but
R_VWJHB takes them from the SPSR being returned to and leaves
PSTATE.{EL,SP,nRW} (and EXLOCK when FEAT_GCS) unchanged. PAN, ALLINT
and PM were not applied at all.

Build the PSTATE by taking those fields from the SPSR while preserving
EL, SP, nRW and EXLOCK from the current PSTATE, then set IL.

Fixes: 47f3a2fc765a ("KVM: arm64: nv: Support virtual EL2 exceptions")
Suggested-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/all/86wlvxs5r0.wl-maz@kernel.org/
Signed-off-by: Fuad Tabba <tabba@google.com>
---
This is a modified version of Marc's suggested diff [1]. That diff applied
a single mask to the incoming SPSR, which also takes PSTATE.{EL,SP,nRW}
(and EXLOCK) from the SPSR. The ARM ARM leaves those fields unchanged on an
illegal exception return. This path is reached precisely because SPSR.M is
illegal (EL3, M[1]=1, AArch32, EL1 under TGE), so this version preserves
EL/SP/nRW/EXLOCK from the current PSTATE and takes only the flags, masks
and PAN/ALLINT/PM from the SPSR.

[1] https://lore.kernel.org/all/86wlvxs5r0.wl-maz@kernel.org/
---
 arch/arm64/kvm/emulate-nested.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index dba7ced74ca5..ace2b40cf875 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2738,17 +2738,30 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 	    (spsr & PSR_MODE32_BIT) ||
 	    (vcpu_el2_tge_is_set(vcpu) && (mode == PSR_MODE_EL1t ||
 					   mode == PSR_MODE_EL1h))) {
-		/*
-		 * The guest is playing with our nerves. Preserve EL, SP,
-		 * masks, flags from the existing PSTATE, and set IL.
-		 * The HW will then generate an Illegal State Exception
-		 * immediately after ERET.
-		 */
-		spsr = *vcpu_cpsr(vcpu);
+		u64 cpsr = *vcpu_cpsr(vcpu);
+		u64 mask;
 
-		spsr &= (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
-			 PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT | PSR_V_BIT |
-			 PSR_MODE_MASK | PSR_MODE32_BIT);
+		/*
+		 * On an illegal exception return, PSTATE.{EL,SP,nRW} and,
+		 * if FEAT_GCS, PSTATE.EXLOCK are unchanged, while the flags
+		 * and masks are taken from the SPSR (R_VWJHB). Set IL so the
+		 * HW generates an Illegal State Exception right after ERET.
+		 */
+		mask = PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
+		       PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT | PSR_V_BIT;
+
+		if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, PAN, IMP))
+			mask |= PSR_PAN_BIT;
+		if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, NMI, IMP))
+			mask |= ALLINT_ALLINT;
+		/* FEAT_SPE_EXC and FEAT_TRBE_EXC also gate PSTATE.PM one day... */
+		if (kvm_has_feat(vcpu->kvm, ID_AA64DFR1_EL1, EBEP, IMP))
+			mask |= BIT_ULL(32);	/* PSTATE.PM */
+
+		spsr &= mask;
+		spsr |= cpsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
+		if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
+			spsr |= cpsr & BIT_ULL(34);	/* PSTATE.EXLOCK */
 		spsr |= PSR_IL_BIT;
 	}
 
-- 
2.54.0.1136.gdb2ca164c4-goog

