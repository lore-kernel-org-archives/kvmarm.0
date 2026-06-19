Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C4C3101C2
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852844; cv=none; b=s+nGkUgIi7rye0oBb5lmHbvv+scxV4x4a7/H2xwrBL40X9pqEISp4wTkhZ1zfAIiJ42/gRdJIOUYIajLxBcv08vj1/XIi7KHaJYXDSmR5oPkNVPUsQrHXvQDQ0jME7wj6On0jEqtfg3Wyi9OBoVfgf0jDuAOIroODWTEVhDcNTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852844; c=relaxed/simple;
	bh=p8zLycY+wAssG4/53MKFl1WK0XraVe4S0eUc1H0xs0o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D6nqJY6Vnq04ZPwSoezi5vSTL1PypCiJTWgmsrLF5xYw7tJ2k9SXiI5gvk/Y+5rVBd517rcwfry2taBqvP9CSEFTFDE4PPXvw9r5a2wY/4otoJ/+S2F1Hsi5talK2CaxtM8x9UQ/fAsMoJRwd9LBv5llfMflF6AwTqEOAzXBcpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A6Yg/ydk; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A6Yg/ydk"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490b37e1f47so12028015e9.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781852842; x=1782457642; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UbL9lwJzeVbN1iJUU9ZRwmA6X1IAE6tmxjMtgc8Iqwc=;
        b=A6Yg/ydkmyMoW2gP+N3mteDUAziQP+I62z14PEcOVFHdkaApRQYBUWaUl5bMShSN+0
         oVTFg0XZBYtBCUEAg7GIvfSJBzmWnsLMhmX/Xgwemt+qV6+7l09quE1KYD/S1E0g6Sju
         T+KQZdJ6W/MUatni/JseLWt4HqHu3k7p9O9j3cjW2yrI+43IqCe8ORDvCpdDjtWggfRz
         KRTsuO5EiJlmRrdX0CH03wLsD1GAS2MVCXoeGGLgmlHXcf/vNLQ4YRnbjoBDXT50Ul/N
         1CtD1nnXcKEYAT1LbxwLnbBQgQpAt9KSGmJWWYYcpnfswLimO6scwzQ3ZOUOHtk7piUq
         oPgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781852842; x=1782457642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UbL9lwJzeVbN1iJUU9ZRwmA6X1IAE6tmxjMtgc8Iqwc=;
        b=ixdBwvCyxdw6tG3DafMH+6JSGygsh80T/m5y5qViVAk61R1oWRCUwOlHIDzpyDXRcc
         j4d4O5NaayikqgT8TUhcdlbWj3UXRUm1MxPbXvH3KB98NkvXK7WSp/RYhwY+7iUUUD0c
         imc4LiCQ+ZG9abSuMr2pR3fb72kF9xO0srzQbnCaZBHb0X0vS3BTUQ0qbA9kziZHeeIo
         TMPFIjgNEa/EkdU06TN3skioq33FTjb4qtdVB7lEmNLekaIYNHy7FzqjxDidKb4Rbdm+
         3++1DCxo9/TAJOGgUGhf19TONgNJSaVhdCudFuFj7GzjCusJXnB/RHAvFv2HksCJFlFE
         c8aQ==
X-Forwarded-Encrypted: i=1; AFNElJ9ocd91ReC0t2lqLNZI0trvvn8LnxYRyboc1GZtTpgrE4JbOMdKnG34dnK4cbeVuDcrWdY3BIo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjAauOGZFRnM0qEtfCm9r1YNcX298OTiILNBciNdvmbAGVWcOS
	i94ByGXV3DakdRaI4dQ+p++eqVEu8PaQmhhHQO9YzUjQruV1XfWzwoBEtMSniDONcUD61dOPF3+
	Uyw==
X-Received: from wmsk6-n2.prod.google.com ([2002:a05:600d:8486:20b0:48d:1bc8:5961])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b17:b0:492:40a1:1e16
 with SMTP id 5b1f17b1804b1-49240a11e34mr32742455e9.8.1781852841684; Fri, 19
 Jun 2026 00:07:21 -0700 (PDT)
Date: Fri, 19 Jun 2026 08:07:12 +0100
In-Reply-To: <20260619070719.812227-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260619070719.812227-1-tabba@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260619070719.812227-2-tabba@google.com>
Subject: [PATCH v2 1/8] KVM: arm64: Extract MPIDR computation into a shared header
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

Extract the vCPU MPIDR computation embedded in reset_mpidr() into a
kvm_calculate_mpidr() inline in sys_regs.h, so it can be computed
without duplicating the logic. A follow-up series reuses it to reset
protected vCPUs at EL2.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/sys_regs.c | 14 +-------------
 arch/arm64/kvm/sys_regs.h | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 33c921df19b5..674fabe1d40d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -976,21 +976,9 @@ static u64 reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 
 static u64 reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	u64 mpidr;
+	u64 mpidr = kvm_calculate_mpidr(vcpu);
 
-	/*
-	 * Map the vcpu_id into the first three affinity level fields of
-	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
-	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
-	 * of the GICv3 to be able to address each CPU directly when
-	 * sending IPIs.
-	 */
-	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
-	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
-	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
-	mpidr |= (1ULL << 31);
 	vcpu_write_sys_reg(vcpu, mpidr, MPIDR_EL1);
-
 	return mpidr;
 }
 
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 2a983664220c..bd56a45abbf9 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -222,6 +222,25 @@ find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
 	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
 }
 
+static inline u64 kvm_calculate_mpidr(const struct kvm_vcpu *vcpu)
+{
+	u64 mpidr;
+
+	/*
+	 * Map the vcpu_id into the first three affinity level fields of
+	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
+	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
+	 * of the GICv3 to be able to address each CPU directly when
+	 * sending IPIs.
+	 */
+	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
+	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
+	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
+	mpidr |= (1ULL << 31);
+
+	return mpidr;
+}
+
 const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num);
-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog

