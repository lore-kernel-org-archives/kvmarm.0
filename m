Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE4B2FBFFD
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 20:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968372; cv=none; b=TdYpfKdPiUd7rE1Y8xZrkXWNP/FGxY+OxkaEKsDv/nRmXYrKkO4n0Psq/bDCIW7FpmUlf37Kz4FJeMifQmp8sBMrH1OiuhbrVJFkJdowjM7ZnDvaoLAGG6d5m+mQLQqtkaxCFkdkVxt6ThguIBIJy5aU8p/IhxCjhccrhHcbxAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968372; c=relaxed/simple;
	bh=8z/ZhUBiJsaGtKB7500oDCpj9d2atPMBBLxlj1YRgaY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eZDfEWnFEHnG5VgKPV4+z75+LqPZ8+1+FecGBeR3153FiNx6Ud7QoUoL3VhlEo2sJeFCAr0SgCHb7QgzvZdDSkgbmGYFB8xxspTAEfzg5EXKMqqba9aRawzURwNmQS11somoJi6NI6RWFWL4UlvzkaMLUUq+Mri4NQBN3v2Zoww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EOIY+Ahq; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EOIY+Ahq"
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-61168eb522aso1961365eaf.0
        for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 13:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968368; x=1751573168; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EggI+2LInzJ3wRO1GPi9TTSrlVG7gA6O9HYI2Cdzh00=;
        b=EOIY+AhqCjuJTCKUWzpyaPYLabduvrphLxRyQHC5ryoo2apKdJ7OB8Mx4zvHdp1ZQp
         JRYqUa2aS0+ucRn0kjm8uhFePKDKE9E7FBplMcsIoPgkkYeyz989yrw4G2r8//8NqQq2
         tmiLyv8nmu7+4dix4SvU63SmcuKi66sD1HW5Q6Brb1iv4xI31cigEK7fd3T8EEP93Ffi
         OXwTNa9lYbJM4qEiIcHUfmiLI9Iw5whi/M0OVk75BD+SwUbqHZAm8xu9j7byxPX1CTkn
         IDyCi3kdN6r4KVBS6QodtDN6je7+5CnvBsQKgHjF0zD6sHJbNO8APhxWq/ScqrJsyCsq
         JEbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968368; x=1751573168;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EggI+2LInzJ3wRO1GPi9TTSrlVG7gA6O9HYI2Cdzh00=;
        b=cfGBkuPXBlfW94yaUtp1sgILYu3MWQhqTsNrc0qazofnfH1beFIixLqr66li/URLGc
         RaGWGahJepyc3GByDPcn2XtdFKTOUaaOZBvGFbX2gSP+sHPw/Wugc06Br5Wk4kysGdY0
         uThUNEI03OLQXyRJ4A/cJDbWWOy5ypDf0In2bqZdR4UbjKW1H3fW/aU70Gk9b7w2wM6W
         D+qzl/48KF8+zQbrsDTfKgU7/lXrt1Ss8cZynjvzu0tKUXRVrhKT3kM7/45y8cm3l6UP
         pv+zibZTtMHTrDHvhZYmOKJmiwH87jGGt+TujLtZMnrZLlkMzLerM4e7CBsDoJoHyL8s
         Alxw==
X-Forwarded-Encrypted: i=1; AJvYcCXaJ/GEoTNXSkLmpsd2E4hiJrabWO+JwOX6E9V+HKk126AM+9z1YBhsp7bjvsu8vPrWF1AXFO4=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywprg/zrnDotZ7Ahvbwkh2QBSq5Tsk22Hwou0d4nNn3AbGlUpua
	tjM/vMw1zzIUefZ4yhk19hxWShluNhJZ1C0tSDGTSjwiQUORrJzER8OWNjunyk2yqVhgz9GYMES
	G60UgrCddLN4ihjdkFGVoJPkOYA==
X-Google-Smtp-Source: AGHT+IEDQi6MUvs/OOb8kHvz1Lzcrs7koLOsO+Cfk8AV6zjNya1DxUg2y1UQDMm5ESpCnmdsnoP82zEcgDNAL2N1IQ==
X-Received: from oigs15-n2.prod.google.com ([2002:a05:6808:68cf:20b0:40a:f58a:e126])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:3a14:b0:408:fef8:9c91 with SMTP id 5614622812f47-40b341ca298mr321047b6e.5.1750968368200;
 Thu, 26 Jun 2025 13:06:08 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:52 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-17-coltonlewis@google.com>
Subject: [PATCH v3 16/22] KVM: arm64: Account for partitioning in PMCR_EL0 access
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
index 338e7eebf0d1..9469f1e0a0b6 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -884,7 +884,7 @@ u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
 	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
-	u64 n = vcpu->kvm->arch.nr_pmu_counters;
+	u64 n = kvm_pmu_guest_num_counters(vcpu);
 
 	if (vcpu_has_nv(vcpu) && !vcpu_is_el2(vcpu))
 		n = FIELD_GET(MDCR_EL2_HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b80cf6194fa3..e3d53f2da60b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1249,7 +1249,9 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
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

