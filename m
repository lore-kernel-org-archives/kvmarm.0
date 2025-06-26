Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222472F547A
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 20:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968369; cv=none; b=mVwFShOVb5QT4rThrBBj3jqa/Q5/qVp5NjQezrRLOPucJxGtSyVvK/daog1QLkOxJNKvbsqUsj/uOU4k9oEnCnay64hoR1bLeb77ELQsVVeMVVn0nVx01yDp8PnGh2Wx2sVzAPvaDLADp8eTx6Qh5L6W8FJMQOzWJ+DBvbQXX9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968369; c=relaxed/simple;
	bh=Sugt0ZAWw0whdfnB19zyTKRQsY2Z9PQHTBS1EdvqwWo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xy1xs8k1xOfr7Kr6q9qKsaT2Stq4OymBPhCEzrm0pnNJtglwNk79jNll1ZRgGqPrJ2/ihRRcuAN4HoDRmzr2Pqr2Bb/flURH0Ud4aiAEkZPzIHkSCzA0vaOFntbEfzdLEFzyC6sf8c+BEOgcyVQnjB2WOj27jDxJTxkQKTFBnnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r265lbHz; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r265lbHz"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-40b2c2e52easo646101b6e.0
        for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 13:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968365; x=1751573165; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oR9vFP5SFauEza8dTMYPljjE6wfKaScNOs3wNYF4UAU=;
        b=r265lbHzWA7KuYCfvH5GvqMNPWym7CvTa9gyxBPEUZbkCPgfcx4iDIq2cd3fZTIt0v
         ZuOPhT6Zv2UckJLfmi3Pml3Dhsu54E8sipl7isqI/44NL8qdZrJuYkqcXGKiUEnkPz2D
         XXZ6YJBECao7yqz+jYhMYmeo6RbrAYgRXf5EkfNBVd5K0V9DMtRX3iPA1lgkhgNcU9mM
         4OE158wdNZRcOMm7e1NB6qycoVDeCOBAFqIYL2E4qq6HFBSAOGvET+m6OMGKqmRiz2G9
         PfC6HiSVA5jPhyHG8sQhUodOZkGSMF4NmRQg2VAc70NNcKvEpR3y3oKEMuCGQUr/V8Sq
         yO+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968365; x=1751573165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oR9vFP5SFauEza8dTMYPljjE6wfKaScNOs3wNYF4UAU=;
        b=vsDqO5HsDFnKc3MZUQGtXbF8czpNkgVXqoo5VLYoNwmVi6JiUYnZO/X090W2Kmt988
         nxzzSGdFF0x0o0e05h13Lp9xniZ3wsJpYnXb5GwWkTZhpbtTSOl60mQPtdNloEY0fUiZ
         Hglur8IhiEDe2sQsWQte22cpRMB1ze8GtIqE3ee6U42LpPlg/ygL0t0c1e3Ns4il4QY+
         pZ49+pmYmJkSNBWBfdHrGD5f07zGYncmUfQGcRfda/r3f5KW9+xPl8yUNFIvOGbVqUKk
         cKiCv+/vaUU7nVp5CE+23tU//yMM9nBkQ85ygpYHACEJoIuEgLA5VHoj1fduj7QkuOSN
         6TaA==
X-Forwarded-Encrypted: i=1; AJvYcCV0MCnxxDl+ApqQ4NLNFiqeyz5M9BqXTT5AAWJWDJJXi3XqBumt+94LVihiIzSUosNbdeqCVzs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1+5UgkMRKI+wxQ5KxCFPsVzlR/0RvCdzyY4fS4fqluXhmGNnL
	aAPHbmDkNXhgaVPQr627oDnYLW206ITn3AbiemZ1RtHiFy03MnTfdkPdbYTUVGMPvYcV+VAhz0S
	+iKh5UKunhLV6i2NmlarvH9Eeig==
X-Google-Smtp-Source: AGHT+IHKPzqyXuHjLhNaVF48d4dlM1ddP8qVK1Z3JzzP3RzzSVDOilpZen/JKG4nnFQT/I6NY42YIxRN76XnpGTzTw==
X-Received: from oobbq3.prod.google.com ([2002:a05:6820:1a03:b0:60e:fcff:daa1])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:3196:b0:401:e721:8b48 with SMTP id 5614622812f47-40b33c31cf5mr524973b6e.8.1750968364756;
 Thu, 26 Jun 2025 13:06:04 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:49 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-14-coltonlewis@google.com>
Subject: [PATCH v3 13/22] KVM: arm64: Writethrough trapped PMOVS register
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

With FGT in place, the remaining trapped registers need to be written
through to the underlying physical registers as well as the virtual
ones. Failing to do this means delaying when guest writes take effect.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/arm_pmuv3.h | 10 ++++++++++
 arch/arm64/kvm/sys_regs.c          | 17 ++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 1880e426a559..3bddde5f4ebb 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -142,6 +142,16 @@ static inline u64 read_pmicfiltr(void)
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
index 771d73451b9a..cfbce4537b4c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1173,6 +1173,19 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
@@ -1181,7 +1194,9 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
2.50.0.727.gbf7dc18ff4-goog

