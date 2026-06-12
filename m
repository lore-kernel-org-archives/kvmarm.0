Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F1B3AA1B8
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 06:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781247575; cv=none; b=Y8KgFNzmSzHB87lkaFVxQn255hmm6yjw9VyWt3u4xLgcLu+tibhPPZhwtUqlZwPpBeqEF4W1IgbvxV/Nq7QaiT7lDlDzHKM3QGRV+nzu4WdqjiBxQ9opo69No0Kpx3Ff/hUK3T0LA2DMxfb8RZ5/Zh/WzpCiNmdfNwFIhECDIOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781247575; c=relaxed/simple;
	bh=oUndi4kwUXoWg5lumryXFXpNAfQ0A0QlqigFUa6sS3w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RgTXOCyTQAEc9JWaYv83llR+yQQ/ux71PqFmWeIcZ0dY4zfaBcVjD45ucBeqwZKckiQxWQjG6yEsqfzuvCy3ex1uwjnGemYiUV8dC/nT5OBJZym4bGGOSsId9Ip6Y3lIzstex2MsGNI28TfptkPWfzaNSaofqevWsYCnNsrz8AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UEknOayl; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UEknOayl"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490b0682d2fso5965255e9.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 23:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781247571; x=1781852371; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m6lByUAON2kwH/WVx8s6LHD92Bsz3VHXajDWnpZfQxc=;
        b=UEknOaylVhsTsrEJM1jvHB4T5aetbZ3R9niNCIwSgS82vNkhSgdREulFGA5VOBHpHy
         AfdNdiLfMUb/zSQTHGFrfaF9Y6L7B/DXBYojC73BH4ImVEyHbR7OE5Z1W0sopxhkW8fE
         LVq5LQnbYUuRKvHTT7Q+1aqpL7SCxcmhAIDHSvTgg1F2CvJ9ixg08017Hs3UjIA8cLih
         DWH9jMwI+OOuBbazYmDzj+m2WzX7P6lHOhsWEG8HuTAPvMS89HkjM71wP6XrPMIkd6Qk
         xIo7gskdhXqQvH1s1OPKtVfv0/ZgPZTQbBnhcz1ncpPz2qtESXfxaT6hGq0QUAOYbp2K
         ASKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781247571; x=1781852371;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m6lByUAON2kwH/WVx8s6LHD92Bsz3VHXajDWnpZfQxc=;
        b=oMrEhxSViAUh/GuS/NW+JkpHQ7VJfevlPWEUaKNYdBUPluZt56ptCtwfpW2yEYZZNA
         ptLvQqhAHk+NAfAblqjYs6vCdzSYx4CJnStXiZm4s6cUjoxJWXd2xTOW82mOz+/FF6Hl
         mEvpd45UN9wBJHSdjJY5w3pyKDuGLsKCAJJwJxXrwp6MCBeeWMgc/FW3un1CZoflpkkH
         uIO+4JW0uu36/9XsKL7byl1iKQlaoeFgd8McgfFuJwxJREgagJ23St/filzoIUzPMLIX
         kpgQn6dyepcZvoQ/UZ87W33d0qCkSP4xoY2kE298JLzKfn6SL37OK+w2e58kTomfn+fD
         DNPQ==
X-Forwarded-Encrypted: i=1; AFNElJ/r8BC0tirW3xPyVBqUGlxHP94ExwKBXhzZtnGHyvW89QVz/NION9h1zvwf2bm0lLcV13i27Gc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4wymwpAhZyl5/7yzboyx9d+5XBEHF0fmYN3EouZW0efQMUa9C
	Cnxk2WV0fNDNGZE7BBQ2QyDKeKmSifUdLEZ/+rBT8aajmJDTFjdarSQ8eUWBBXirBh0b26UFlD8
	wzg==
X-Received: from wmoo1.prod.google.com ([2002:a05:600d:101:b0:490:b195:62b3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8012:b0:490:b9d3:a9ce
 with SMTP id 5b1f17b1804b1-490ec5047d3mr16382375e9.30.1781247570557; Thu, 11
 Jun 2026 23:59:30 -0700 (PDT)
Date: Fri, 12 Jun 2026 07:59:18 +0100
In-Reply-To: <20260612065925.755562-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612065925.755562-5-tabba@google.com>
Subject: [PATCH v1 04/11] KVM: arm64: Extract MPIDR computation into a shared header
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
index fa5c93c7a135..869a4bac96d6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -979,21 +979,9 @@ static u64 reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 
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
2.54.0.1136.gdb2ca164c4-goog

