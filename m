Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FBA3D5247
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 06:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781247575; cv=none; b=g7BvaJSMOsHd8c60y9v7hk+tlt2RkQl/KvunHFIjIazCqdC4P9/147XFjWhsqKZvgpU5F0Co3FhpdGpFr4kYT2XQfwOgL0SDChlUzFeRfq9YcpIZOiNx69sYrt/39GKJ5ri8EOfkENe5+qfkeOsCii1BNInjzwk0J7qF8BlDigc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781247575; c=relaxed/simple;
	bh=4WURvpJDPVYYj0WGTWF5CptahrmCXc9euJ9wF9TVrqg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nneQL2wYcHuw7bTjZKX3ZsTgYmXtWPHF1PIzmNXsSt6DDOqTrcEm/advOLigdYJSg/5lDLFEx6E0S5HPBCowUkWEXSKfNXOKNj6iivgLx2wWMK3etd3oSoccHf/Sp2jgZpbzkTDXRWsr2yaCJo9I7NeUeqGqr02WvloKVeLQ34w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a2RLYrW6; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a2RLYrW6"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490abeb7298so5745195e9.2
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 23:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781247572; x=1781852372; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cPQ40+RMSw9qS4ujNZWl4iP11kHXvB3QBni3mxBtwvQ=;
        b=a2RLYrW6RbeJwor5hP/km4PJIXfoqUP3/4YjocD7hcn9LMcSSuAcDwoD1YuSOKIjXU
         Qw8qlw35SyLiLCBlg7Je1ChW6USC8vNqzao9vU9piwQKx5vluDE0DZ3aeVTl7ddyG1qK
         m3tTEZN1QbArIkCkUyqQ2oepGdxA9bC4njzYRZ5NXHjW8TBUXV2eWd/amGXRWUBv0wzq
         Grk68KHQWH7mmiRm5kfYQKxwWECtxavI8g1dhsEf3yFL1SiTivPeWFiFMx8C9floNhMZ
         DRwrransUQH7av54p6Y2zt7zM/ZZemt7ygxiVsc/QLqGWBq72loKLEs2v/Yce1c/JkTg
         ykTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781247572; x=1781852372;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cPQ40+RMSw9qS4ujNZWl4iP11kHXvB3QBni3mxBtwvQ=;
        b=drf3DHciUqAQHvG+CNDod64m6iOj21k2UQKh0ghQ/tu+YKZhBm54QJL6BfH5bOMpW7
         ujExVVm/1N77VdOo/EDXtIaTXEdeuZIiqkKePUXRDgHvFmGj2tb74OxLy2QRRKrQvjwC
         aeE6InqautiZCy0YGvkDT1lr9CkA8m+WrE3DKyq6J4Opx0oLSnnd1OmbNVtJ/ARyybmJ
         qrknMZ8zSdC9PH16EANAPs/ojPTajaLhQM+p5P/RHaVFhC9NBJuGjQcak8XOShEZzoep
         NkHnXkR2prrdn1X9gJe8cv4D+p/6aUHP2whwPtb+WfXnypezP5XIIpJ78912kJXsWOON
         tb4g==
X-Forwarded-Encrypted: i=1; AFNElJ/qBegAFpNpL8rldsNu2pA5c9kriSqFuw6IKeLwXnqt2VpEsaXdtauk7Qm1rNpdYxu3nzRViUY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0EdHTy8eAp1+M4SruQt3bePyLS+Lf9k6DEyyiq1AT/HGF3izd
	qZvqlpxOsZBJwfy5DhNuv52BPqrsAs22Z3WGEdeJ/volHZ79A9SDb7xHvvxu+RDazjsIbOazVsL
	xvQ==
X-Received: from wmdd27.prod.google.com ([2002:a05:600c:a21b:b0:488:9c2a:aec4])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3104:b0:490:58ef:cea7
 with SMTP id 5b1f17b1804b1-490ec4f2603mr16796025e9.22.1781247571436; Thu, 11
 Jun 2026 23:59:31 -0700 (PDT)
Date: Fri, 12 Jun 2026 07:59:19 +0100
In-Reply-To: <20260612065925.755562-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612065925.755562-6-tabba@google.com>
Subject: [PATCH v1 05/11] KVM: arm64: Make vcpu_{read,write}_sys_reg available
 to HYP code
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sebastian Ene <sebastianene@google.com>, 
	Per Larsen <perlarsen@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The vcpu_{read,write}_sys_reg() accessors are host-only, so helpers
built on them such as kvm_vcpu_set_be()/kvm_vcpu_is_be() cannot be
shared with hyp code. Add _vcpu_read_sys_reg()/_vcpu_write_sys_reg()
inlines in kvm_emulate.h that dispatch on is_nvhe_hyp_code() to the
host- or hyp-side accessor. A follow-up series uses this to share that
emulation code at EL2.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5bf3d7e1d92c..aed9fc0b717b 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -506,6 +506,22 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
 }
 
+static inline u64 _vcpu_read_sys_reg(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
+{
+	if (!is_nvhe_hyp_code())
+		return vcpu_read_sys_reg(vcpu, reg);
+
+	return __vcpu_sys_reg(vcpu, reg);
+}
+
+static inline void _vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg)
+{
+	if (!is_nvhe_hyp_code())
+		vcpu_write_sys_reg(vcpu, val, reg);
+	else
+		__vcpu_assign_sys_reg(vcpu, reg, val);
+}
+
 static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu)) {
@@ -516,9 +532,9 @@ static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
 
 		r = vcpu_has_nv(vcpu) ? SCTLR_EL2 : SCTLR_EL1;
 
-		sctlr = vcpu_read_sys_reg(vcpu, r);
+		sctlr = _vcpu_read_sys_reg(vcpu, r);
 		sctlr |= SCTLR_ELx_EE;
-		vcpu_write_sys_reg(vcpu, sctlr, r);
+		_vcpu_write_sys_reg(vcpu, sctlr, r);
 	}
 }
 
@@ -533,7 +549,7 @@ static inline bool kvm_vcpu_is_be(struct kvm_vcpu *vcpu)
 	r = is_hyp_ctxt(vcpu) ? SCTLR_EL2 : SCTLR_EL1;
 	bit = vcpu_mode_priv(vcpu) ? SCTLR_ELx_EE : SCTLR_EL1_E0E;
 
-	return vcpu_read_sys_reg(vcpu, r) & bit;
+	return _vcpu_read_sys_reg(vcpu, r) & bit;
 }
 
 static inline unsigned long vcpu_data_guest_to_host(struct kvm_vcpu *vcpu,
-- 
2.54.0.1136.gdb2ca164c4-goog

