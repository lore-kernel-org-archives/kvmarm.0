Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F89482C7
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513638; cv=none; b=dZPolWpTBGNm5h2PNPvpSmMHIc6jMBJcaP+/3ipsftlL83wH7ugUp1SvityQZh5YcjV3KyHotN7HLM5H35I4RLaliGSeWTs+Y2W+e++p5F2CMtHwIJg7ADj5EGO1As/5G5/jeoZ0haNcNB1WjzP7TYMfZG21xKDNtfPtDPBSR7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513638; c=relaxed/simple;
	bh=H120HCXBI3/guyh6tfue56/bfmVkmtQxzhaIWdicHvk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I/GvImRMwHcf9hJ+Y2lncgA+j84uejqw4oHth9rmM9oKyqH5SVH+ub9viskATmBmRfaBhRbTfta0gCnMuwKBmSev3dc5GXCXNtzSSPy+BbVlVuAucr7ffr/cZOJcArc5wZ0jGyyNgEpiQGMeVpNpLNu4zmoIygmd3/k/P861P9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fkBOgWJb; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fkBOgWJb"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de468af2b73so2977775276.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513636; x=1714118436; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WAASiQj8ySouqSnzFWGUNnXYH4XrZldkqK8o7Htn7bk=;
        b=fkBOgWJbfmfTnVKUsEPHlqc2iB5kvdRfKKia08qK0EcOGHcsWuKhW3t0immlv7bPTj
         TopF1GMqlWGodd+Q3S3+FCvpArkXQEttgtWCzc4xANgel/KqN6fdrtnK9zQ9dVOqrIlV
         q4GTLD4TIDuSpLpbmjyovis8PgFIH73q3uJoJ92cdqaqDgcljcS50fuqWVMYjT2cTHVT
         ikP1XjYaOTu7mFw4mgcBuudLO0aCwHniufkhpBGrym+PUGT+xD2s0/6+RhOCwHdtNIbl
         trzmLHrsBsg8AW1h55fVfdu723Oayf9fkP4DxJdZb3mYFlGLm9S58DSiH15xLmZYnA+S
         tTxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513636; x=1714118436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WAASiQj8ySouqSnzFWGUNnXYH4XrZldkqK8o7Htn7bk=;
        b=tMYX8RcSIVGpRDmYV4PkNfpN8awDpw2i8oTqUkL8Aa3rLXSA8ZsEFNnX7KiupQ6131
         KdwITVUaeiYr5LO6AKxeRNnthJCxt4jP7ZFzgUgH3XDTD16pFl+y+QW2XeRGlsnIJGNQ
         3mSiLurmu3gUTAaGQZbEKm4bnpXHEvrXNCL0YyQJZCgKkVgYkH80vYXNvdlMXIxvMhwt
         te4WqoSmHNv6wcgDF3rVGL6aJgoxz8HDZ39inL3H7u+iW3r/PNFJQU+KRzfJEDlBcRZc
         5t4S2sbLxh4a0y5p4pcKI3g9ZC61wKI2incOv6cikr59PWC0lHda2HIgB9SlW/OzwxNB
         3u4A==
X-Gm-Message-State: AOJu0Yy3XhBQ+SMyTGW0N3eEZTsjbNsVBi9+GoI1dihN0Ub+v1LgXnn7
	oQc51O2YZ/OGWAArDdbBEo0rDatwRr+he7RU/nPJWIhfJ9k1L3Quqnk079mNejqsKxDPMqCg+cZ
	Fr8a6W9XFJV6OhcK0CM5RuWiRJNRf7ma/LgVom9fn6znJ4X0PV3uqd7E4XzEbm4VbCCNYHKnEk8
	Afr9Q1EHTY+Ku/1w1h/Jem8FGyXTg=
X-Google-Smtp-Source: AGHT+IHsO1vpAAtYm3GqpVpGOnl4NtrQTN07FK+ZRjkZOQ6p/OuN3sJAFb2rBU1MpVWxlJsD5J9I44TKog==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:20ca:b0:de1:2220:862b with SMTP id
 dj10-20020a05690220ca00b00de12220862bmr390939ybb.12.1713513636134; Fri, 19
 Apr 2024 01:00:36 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:33 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-24-tabba@google.com>
Subject: [PATCH v3 23/31] KVM: arm64: Refactor reset_mpidr() to extract its computation
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
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
index 33efa441e21d..c6da7dd891bd 100644
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
2.44.0.769.g3c40516874-goog

