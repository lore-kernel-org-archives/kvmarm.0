Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B9B2FBE14
	for <kvmarm@lists.linux.dev>; Tue,  9 Dec 2025 20:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313565; cv=none; b=UmKaLi2ufCiN/8PL6avK8yUCgGcr3GmKJeRIA4mipd+iR0vApwRwYSJ0wG5D9HR+USCsGNuPgkXxmrYuuvUEkujP+EJGabSMph0aHZjeyTMAJ2K/N5TpnFkyHdjd0Oneqmaf+MEhyhc7kSIMoipbwRhLGnVnNRPNuX46QTzSjCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313565; c=relaxed/simple;
	bh=SQ6Z1MwvA88uzbzI+XtO/m3rZVQWhJdhjpiP6b/54yU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EVWwc7I5sdW4A8aVMhn36rtck6cRcszMgaUGS6OcYht+zAYZeSjbjeov2XRxRqHc8Wrob89P2pA9gRUAU/FhRmjZFYLgC5RTAos921riVRqefJSlbmnsvg53p+DIrwHF0v0juINzMHCxDDvmoHUbmYMxRRjlKZ2WI7u04pzjR7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4pJmGuzK; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4pJmGuzK"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-450fd003480so8460664b6e.2
        for <kvmarm@lists.linux.dev>; Tue, 09 Dec 2025 12:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313559; x=1765918359; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AJ1EthCH6ONdnoakqWvxYQ6ZZxvXCgKuA673W4BNIkM=;
        b=4pJmGuzK9u288n9Y5Gi6LB7l36UTwWlw76kHgmPG1LgmTGJyHu8ByStT0pRuVKDpm7
         13JL7K7mkUg8mWorUmAV0srYA9MLFVgtWXo65SaWcsPoX8UK+u1bJi7nDM2LHEMKKeBW
         TT5oKKUJ1PdaPrRXFlmyx3p6XmqDMVVMgEsrP+vaIjmutmeOtA0ZvZJ5lVRCRtQRJjGO
         n25eB2u8bFIybcKPyShp5DHzPZrbuOw3ek3HkA6MwGuFsy5ggZ8dgbnDrDtYZdbZ9r21
         bSBMm8aKpZZPIolJMTr3E0zJAJzuZlGjIRPfJsn2uD8RCm7ljvFLiTU5SVjTGDPkeIqY
         xDCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313559; x=1765918359;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AJ1EthCH6ONdnoakqWvxYQ6ZZxvXCgKuA673W4BNIkM=;
        b=h6j7Ldb4qsrZTFchsZuYU4N8mrl71EdqYgV3aNiHa4Q2izWVUvgOqHDkqLRk/rqUhs
         3s+pVDATPDSnrLnIgQMxLq0moQ9rU2obn33+M0kexPsebryzcMITRy0ooIIteYedXbcE
         96HsoeyKLrRvHXL+QTkc5VWkbXDQWHbAFTxARTFP3iSGFfraPdQ+RSnNcuHrqS7wBwJZ
         VaO2HS5VdWhlkNcFc1fgYtd+vTtliP4y+43UO4796wiV8ra1wGQKMl7PYyuuodJw5CD6
         +WvYCz1xIWHzReDCefAsuApueMkYIZ8owwndMXawWTRyI4E81TZZ8fuchoV5XywOe42U
         q2Yg==
X-Forwarded-Encrypted: i=1; AJvYcCU/3lxns4pEHM8p9YlAycspE+f0WtXZq/ZLja5OO7FmzQyjULxwdceYIqImGqIZtDb3p2gmrXs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzl+u6p8vzbppU2h57VeeS+b14EbXj2b7S98lb4P/Z9aDCXJn2/
	99gEaXq01f0PfNHuY0K1Ij0DpvPwEZB60nmFbURxK5kdpne48kc+9jCUA/qSU2OEup5JPAVws77
	axIWdtJ/MWY5ZhwITrOaQwEWtRA==
X-Google-Smtp-Source: AGHT+IEXFAGDtIzcAMUsWr76V/QsGbzsYAGUdLx+/ZdxOcslRVX0AGiIPoGFGxMRz56nzOeGb3yai/VbNoKlqj0WOg==
X-Received: from jabgz26.prod.google.com ([2002:a05:6638:6b1a:b0:5b7:27fd:4267])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a4a:ee05:0:b0:657:717a:8c8 with SMTP id 006d021491bc7-65b2abef8e5mr121600eaf.3.1765313559184;
 Tue, 09 Dec 2025 12:52:39 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:10 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-14-coltonlewis@google.com>
Subject: [PATCH v5 13/24] KVM: arm64: Writethrough trapped PMOVS register
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Because PMOVS remains trapped, it needs to be written through when
partitioned to affect PMU hardware when expected.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/arm_pmuv3.h | 10 ++++++++++
 arch/arm64/kvm/sys_regs.c          | 17 ++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 60600f04b5902..3e25c0313263c 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -140,6 +140,16 @@ static inline u64 read_pmicfiltr(void)
 	return read_sysreg_s(SYS_PMICFILTR_EL0);
 }
 
+static inline void write_pmovsset(u64 val)
+{
+	write_sysreg(val, pmovsset_el0);
+}
+
+static inline u64 read_pmovsset(void)
+{
+	return read_sysreg(pmovsset_el0);
+}
+
 static inline void write_pmovsclr(u64 val)
 {
 	write_sysreg(val, pmovsclr_el0);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2e6d907fa8af2..bee892db9ca8b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1307,6 +1307,19 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static void writethrough_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p, bool set)
+{
+	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
+
+	if (set) {
+		__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, (p->regval & mask));
+		write_pmovsset(p->regval & mask);
+	} else {
+		__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=, ~(p->regval & mask));
+		write_pmovsclr(p->regval & mask);
+	}
+}
+
 static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
@@ -1315,7 +1328,9 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
-	if (p->is_write) {
+	if (kvm_vcpu_pmu_is_partitioned(vcpu) && p->is_write) {
+		writethrough_pmovs(vcpu, p, r->CRm & 0x2);
+	} else if (p->is_write) {
 		if (r->CRm & 0x2)
 			/* accessing PMOVSSET_EL0 */
 			__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, (p->regval & mask));
-- 
2.52.0.239.gd5f0c6e74e-goog

