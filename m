Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765B524DD02
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 22:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750457935; cv=none; b=hMQUCTbJ1a4FXPxcRGklUZhtb4weSzfrc2HI3dNKKNcoT1cCzdsPLeg91yyos8W7kECZSLcH7oWlrFDTVO4oY9qi5WTuhxZhgpilpeMFuM2l2zTPZJAa4knQ8ItPnhtg3axs4dndUdQwPcHPVUjJzB21hU8h/mbukOjlZWapR3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750457935; c=relaxed/simple;
	bh=r9/vMoXr3lfiFToKxSojMMbuj31iMx90TgFdXWddsZ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jA9+FFO0RKU+StbCkBPtDdaiJLytVOArVECx4uwYomXij2OEnixYmF7IHRsYYNynwd09gYdow0qKbiL3U2BVGpg9qHVkbBXsmerOtRGAM/zS3ooBSiX/YAkcPU0CWu8cp8YqAtyqAYWuALUsAZfs6EOzKiRCZIjoQ1QSLL24vts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4odWR40x; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4odWR40x"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-86d0aa2dc99so172895139f.1
        for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 15:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750457931; x=1751062731; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1gZPdqHIaC5N89cxtk14Y15WeUbkAXiFR8OakDw0fW4=;
        b=4odWR40x0smDX8PGy40bp+EaSntCt9fsQ22lWyE8T+PpANbeGWExeJJRrRLnU6wgKM
         7c2aZ2lNYv3uzkQJxsf0TvsGtdFDhKTh/gqiYmr5y21S4YHASszbH58RtCd6C3FUBv9a
         ei4YiJHS48N39yrpEwc3jRHxx/6kYQP94VUamxNSo6d7Mtg/u+jVZYprSdV0e3iRavD/
         pqNfS64+XLvDcVPyF5keWqOnJu2Hm1dCG777Fg26/Cj60d/NnGbR3Ody/xOoeNn5vvdB
         TLq7SB+mCVtL7KJQbE+he1WBjQR/Uv5M3tUWNObzTvpYdWmr9tzY7oQrezh72K8FIYNG
         nrkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750457931; x=1751062731;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1gZPdqHIaC5N89cxtk14Y15WeUbkAXiFR8OakDw0fW4=;
        b=auk55MMKKy8bb9qUMGb3rkEWzVoRPOexc3ykD+gwAQpIftkHJMchQSjq5q7CTiEIrw
         tllQASY1fFeXuRxHmk9RRdOHJaD9a56kYKoH17abAmEERXsL/56zHp2vK+15QQfwXPQu
         62ZQ8WG/OOkG5jyfzVMzq5tRJzV5EWLmVbrbwoafpGhSkXjtkMUmkeP/xekGrEvc4Bac
         H0LrMxpK2qT8LnITtmbkCbspQznFBCt7phCoN3u7l/a6nTSkXOdefE8kd1olz6l+31tk
         hOSOtRXSqzKU82lEi4ZqD7CRn2JuIMPkEW8msIxHsRdyBuBVLGAQSLhb42U3yt4ilmCn
         aHuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZLaXoItGjnkKRn40W/hIpuIwIE+2zKcR/fFB31E2l/hgN8ZKXvNHPm43ktd3j1cgrz9tkCNw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxY3X+y0pj9ffqtUos+LjTFDs7bkcdGFXadSQ3fPD4JdatZdLJB
	hZ3SExY/+Yjt9/e+NItYq48/L/NCyaGjaD5OvQhSz73kHYjI2eKsJwm6axWGtkxllNJ5y8IkdcY
	7X0yGSmhOlVKYpwUgt8g9HZcI1Q==
X-Google-Smtp-Source: AGHT+IGjv4MwAm4QLbkXWrYC7rAHKw9/iUlbnKxWWkdEwdxKvGAPykFMMacviS9dcIIIxXL7XUy6syolfW7Tyi7fWg==
X-Received: from ilbbd7.prod.google.com ([2002:a05:6e02:3007:b0:3dd:b63a:d0bb])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:3801:b0:3dd:b655:2d6a with SMTP id e9e14a558f8ab-3de38c245c5mr47355195ab.7.1750457931036;
 Fri, 20 Jun 2025 15:18:51 -0700 (PDT)
Date: Fri, 20 Jun 2025 22:13:14 +0000
In-Reply-To: <20250620221326.1261128-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250620221326.1261128-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <20250620221326.1261128-15-coltonlewis@google.com>
Subject: [PATCH v2 13/23] KVM: arm64: Use physical PMSELR for PMXEVTYPER if partitioned
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Because PMXEVTYPER is trapped and PMSELR is not, it is not appropriate
to use the virtual PMSELR register when it could be outdated and lead
to an invalid write. Use the physical register.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/arm_pmuv3.h | 7 ++++++-
 arch/arm64/kvm/sys_regs.c          | 9 +++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index e2057365ba73..1880e426a559 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -72,11 +72,16 @@ static inline u64 read_pmcr(void)
 	return read_sysreg(pmcr_el0);
 }
 
-static inline void write_pmselr(u32 val)
+static inline void write_pmselr(u64 val)
 {
 	write_sysreg(val, pmselr_el0);
 }
 
+static inline u64 read_pmselr(void)
+{
+	return read_sysreg(pmselr_el0);
+}
+
 static inline void write_pmccntr(u64 val)
 {
 	write_sysreg(val, pmccntr_el0);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3733e3ce8f39..3140d90849c1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1066,14 +1066,19 @@ static bool writethrough_pmevtyper(struct kvm_vcpu *vcpu, struct sys_reg_params
 static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			       const struct sys_reg_desc *r)
 {
-	u64 idx, reg;
+	u64 idx, reg, pmselr;
 
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
 	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 1) {
 		/* PMXEVTYPER_EL0 */
-		idx = SYS_FIELD_GET(PMSELR_EL0, SEL, __vcpu_sys_reg(vcpu, PMSELR_EL0));
+		if (kvm_vcpu_pmu_is_partitioned(vcpu))
+			pmselr = read_pmselr();
+		else
+			pmselr = __vcpu_sys_reg(vcpu, PMSELR_EL0);
+
+		idx = SYS_FIELD_GET(PMSELR_EL0, SEL, pmselr);
 		reg = PMEVTYPER0_EL0 + idx;
 	} else if (r->CRn == 14 && (r->CRm & 12) == 12) {
 		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
-- 
2.50.0.714.g196bf9f422-goog

