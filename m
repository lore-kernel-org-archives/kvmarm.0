Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B5F14E2D2
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560979; cv=none; b=Dc1YmWk98ypC+4rYjLgoF9dxOARQ/JyhVzmGyN14G402c5erknCNxuxW5l6B4ey87GoavnVlsMlcHnV7kBSoqKQpyNQaBjCqWydTGFGtZ9G+hpWUp7ArQJu1CX6RYp13RLKl+6rsHC+FRx1xhnpwr5NSbubnUD7GNd6Lj+CQcmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560979; c=relaxed/simple;
	bh=Bdp6O8jB35tN9ECvPwmDWYnNzOvYm3Q5+HQdQIqJmwo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZUENGGInBl8kvljT7GDXu+GhunhVNF/4sLT+nKOTP8U75aqRl9wZva7MgkRRt9x13POW6dX02XflCMvFPY9F4HxmQ/sloN7P7DZf2JFLxCLXADl8cExXndVcJ/sPHdjpFJyjaorcD6b0jRTvhSBrz3D9tQ4WYf1cDsQkn6TgT7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OaqfxcFw; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OaqfxcFw"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-33ed234bcb1so586941f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560976; x=1712165776; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BWMPC0MFGpH4Hc3mnrye4M+AfYD6204eVzGhpN00K6M=;
        b=OaqfxcFwkHvJZnI+AMOw98lZLN1+1oZbC1NvRTlwETvZJP4yLlR5ldjkeUWH3PVy79
         nCgsoRWIKXuiLxcDj99XcP1zlOU4z7jhAEXs7rhrYFIjQQUlgeayTmP4MxuxIH1JFxhO
         1ce11wgLjjOs4NCMJ8qIhYPbGLIaEdDvXSgRAp7XO34TILGgiW7N7FM+Znj66xvE3ujN
         N6nhkXAW8CHHKGeIjMMsKp1x6PGV58GVs0UrvmkT4yTPfIdp1YKTRrlRqs7Th8WYNLfF
         biH2ShtYbi8eMA3G4Qj+2IvDhzD7LhVrRbZTZjMlyv1RmzA9bAWrbbA/UTnZPAzuFsqB
         QARg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560976; x=1712165776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BWMPC0MFGpH4Hc3mnrye4M+AfYD6204eVzGhpN00K6M=;
        b=AO3sScoWo31EOPyUM0cxW8zR6WgqeRRdeK8UXPO1axGGyPwmi3C+vGZIjR8WbyCDCr
         u923reGv9Tze5rI57PNiM2duRAbWnNE6GUrDgBH9zq7k6rtghDf/RNcz2+VLgV2aohz+
         y7h+Hx8nvDljMmWPswR1T1BiSaBY7frdgzZ9ylfK72Szanq6oUaeCqb8L/WcrJ9+7uZg
         q+CMd2puQJvCzB98+nPXs8ol4rxTpPcufISWQUCDfm8rqUr9AT7+F++nZFLyEVveaYVr
         WQRCIHzFzN3ArQbfBUGWYultdfxa4TYNRW24RKqXanCXWwECaodLsHCjkAxOeXyX/Swa
         9yxA==
X-Gm-Message-State: AOJu0YwVLQUu29dY2CEN8ukvXqwJhbcntrcuttK8d73puaqk6mbKBjjz
	sR1msONDOWnT/oCUHtpoiq1H8uxuyLX0CKgvb0U4pk94SEBMkwmbwGmn/yoMYhNPOpiY9F2J4fV
	pZrzOl//m7chpFRmW6n33k3dUqVjfxAXzc3ZE1P1of1tL8+DJqxmynfUxwN73nJEaM3vdrn9RSM
	8gOfBZxTsbjLbtyFtrvVFnyt2nltU=
X-Google-Smtp-Source: AGHT+IE+1nlQZkFEr5bZVfCZdDyIp/j6bGOrl0xzNIW4Ruo6sK4RCGLFmkVEjHreogsi7UlfaQM1No4x7g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:11ce:b0:33e:c69f:b5fc with SMTP id
 i14-20020a05600011ce00b0033ec69fb5fcmr659wrx.0.1711560975873; Wed, 27 Mar
 2024 10:36:15 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:05 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-19-tabba@google.com>
Subject: [PATCH v1 18/44] KVM: arm64: Refactor reset_mpidr() to extract its computation
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Move the computation of the mpidr to its own function in a shared
header, as the computation will be used by hyp in protected mode.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/sys_regs.c | 14 +-------------
 arch/arm64/kvm/sys_regs.h | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c9f4f387155f..0ad788686bbf 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -816,21 +816,9 @@ static u64 reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 
 static u64 reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	u64 mpidr;
+	u64 mpidr = calculate_mpidr(vcpu);
 
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
index 997eea21ba2a..1dfd2380a1ae 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -222,6 +222,25 @@ find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
 	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
 }
 
+static inline u64 calculate_mpidr(const struct kvm_vcpu *vcpu)
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
2.44.0.478.gd926399ef9-goog

