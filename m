Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B5728DF25
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 22:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533989; cv=none; b=YzdN9lfqpYOqw7IVL5X2UTj/MVZFOoQKauOlfS76IN/72tSVtYK7bPrGoQBHwIp3RirnI/9Vf0Vck1ORtSa0E4c81gamSQ020Btrp3sHBc2W2JBEp71ns/jchgDQuHC1u5pFsqcxNGCxVWjVWG9Xs1T5wVKSwcxHSRV2VvmJpLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533989; c=relaxed/simple;
	bh=mWJcjSVKE8Hfx300gV16GcG/h8AihYm2XSLxVa+DzAI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KDojIT6qz6EpxyVIkN3dz5d/h0CAOtoIv9rvuEfZHqUKs1hJZDpWrDlbJ3wGkSA9waFotgRt4BSRh5bJJLMmOG1NU/gkp7lmMSLqI3Wf3/DGzK790GiM7NgQBjSDLKWq8WOyK3yMVCaZZQecpRz8gpxRUfV9bOAgNvmdekQyKMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xcz/o9hV; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xcz/o9hV"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-41b5e254f2bso411085b6e.3
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 15:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752533986; x=1753138786; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ryTFSv4SUuWjEo9ITdyyZg4InYYKN2XpVG4LgfvjWks=;
        b=Xcz/o9hVQFc+/OFyf51tge2JLxgyQY0GayNgZgZ1Blugd5HRJ/TyGHo95CxZ2Bipbe
         OXUOsNKpxrc14+93J5r+oWO4zG6pepHH95h8lQud8S0+3qEKrKIUdHsoeeix1UdFHYTY
         IeiUZO1ShKtA85C/NTueYl+PC/n1oE/XZHPJ/iyQ+7QLBuI2qDjUUT7BDRZmf6P2IdTr
         WDN1YhORkA9VspgIXP0afHKBxjGotD4iQ+5G6Xh0lNO8wLR/fgkbad5TMhLW79hD0Vzy
         e8iDkjFtDJLZ60oEU2+oLGFB7mkxnwYs2mP0Ol7IQRPe7NOLBQWr8+xLIwYVb3+G3aFr
         3WYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752533986; x=1753138786;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ryTFSv4SUuWjEo9ITdyyZg4InYYKN2XpVG4LgfvjWks=;
        b=L+A97HYVglt+3sYDl8F2QeI18KaqwMoft/RUt9to5iRlig7Y47x7eggs3P1EWe7U9s
         f36FMMB+EdXZGpaqmhIQxzmeSCRjy+uAYZV4tG59WAkdAFBgdvH/Xr74eEugy+P0qy6V
         jaz5JeE+crgxTRH88Gxmdl9cosAcWV0Bv4YNUmXUx8NYPUbBGrjLru/VeJ/gk24+7tjL
         FpU54miD46qL6V8kvBs7mijuNfGdQwPqTK4BnZtXLGiTaH+JxVZaH9QCwqCPiDv6Q4iK
         yrOj3IDZzubeyAjgmUq0OVqGflTjYgpZDQJrxTvyODM0vxp3RXUc2b058cD2uwcOfTSW
         Y7uQ==
X-Forwarded-Encrypted: i=1; AJvYcCVb/13PRfP4eKl+OHgNpw3Sa23MLLNskzoY+5Ck57k25qf72pL0rGeBHSA9/l1V+IRjE+lFxLo=@lists.linux.dev
X-Gm-Message-State: AOJu0YznKq2mA81SQIG1lK0bTQVFWTly/rNOAykYJSrOU1CAaBY4lMC9
	iVXWJ+SMV4o0oXAaCYC9KKPZA8AO2DAYkpoTh35jO/kSS8Aq8ancix6rulVl8eGjVTulPvIDFjA
	lqDz21d/+lf4UrHkjh38aCmNtMA==
X-Google-Smtp-Source: AGHT+IH/cZ/kysTLecvFDqp/vKXsI7g6OHRQd1TfsMdUj361wwQB7SXIxVBhNRKY/b1QS1sS6spRQdB4N1nadhlFuA==
X-Received: from oibix7.prod.google.com ([2002:a05:6808:5187:b0:40a:fcea:87ac])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1a0e:b0:40b:4208:7fc0 with SMTP id 5614622812f47-4150faa232dmr10429766b6e.30.1752533985740;
 Mon, 14 Jul 2025 15:59:45 -0700 (PDT)
Date: Mon, 14 Jul 2025 22:59:09 +0000
In-Reply-To: <20250714225917.1396543-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250714225917.1396543-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250714225917.1396543-16-coltonlewis@google.com>
Subject: [PATCH v4 15/23] KVM: arm64: Account for partitioning in PMCR_EL0 access
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

For some reason unknown to me, KVM allows writes to PMCR_EL0.N even
though the architecture specifies that field as RO. Make sure these
accesses conform to additional constraints imposed when the PMU is
partitioned.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu.c      | 2 +-
 arch/arm64/kvm/sys_regs.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 30244eb7bc9b..1e5f46c1346c 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -883,7 +883,7 @@ u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
 	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
-	u64 n = vcpu->kvm->arch.nr_pmu_counters;
+	u64 n = kvm_pmu_guest_num_counters(vcpu);
 
 	if (vcpu_has_nv(vcpu) && !vcpu_is_el2(vcpu))
 		n = FIELD_GET(MDCR_EL2_HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ad9c406734a5..e3d4ca167881 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1247,7 +1247,9 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	 */
 	if (!kvm_vm_has_ran_once(kvm) &&
 	    !vcpu_has_nv(vcpu)	      &&
-	    new_n <= kvm_arm_pmu_get_max_counters(kvm))
+	    new_n <= kvm_arm_pmu_get_max_counters(kvm) &&
+	    (!kvm_vcpu_pmu_is_partitioned(vcpu) ||
+	     new_n <= kvm_pmu_hpmn(vcpu)))
 		kvm->arch.nr_pmu_counters = new_n;
 
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.50.0.727.gbf7dc18ff4-goog

