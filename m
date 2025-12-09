Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D0930B52C
	for <kvmarm@lists.linux.dev>; Tue,  9 Dec 2025 20:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313573; cv=none; b=CIEIoUcq0Nyi0S56l7OAjhXi7YiqEW5pMJx6knOQLGAt/uAYO+d7JYhFT/u/FoWO4feQnO9nZpHKOqyFnXJRcPuDdLR9Pcqm92k830pPxNp1M8jZZuySk6NLxQlymozUn2kuba0YWlvk21sfI5ygsJoejHukRxyVkm4My4+xjy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313573; c=relaxed/simple;
	bh=L6JRHNao9Dv2st9IstObJcFX6EfxZz6LafDaZCOeTJ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hYVYpzMCyH5WH5Fny8PqC3vLHHJmloc4Ekuleimj6FDGAfS1pmXzxp9FWtUKNMpQgR9mtHlLe7f4nO5FCatS+4T2o5nAzfCcJSudNbuciunE+P40zXOXE0ZqvhXWl2uioRlOrztfgU8ta4O+XyXZ/JlQlQb3SgvA8BjbjfxyaCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZZ4nQwu8; arc=none smtp.client-ip=209.85.160.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZZ4nQwu8"
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-3e88de1d93aso7193456fac.0
        for <kvmarm@lists.linux.dev>; Tue, 09 Dec 2025 12:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313562; x=1765918362; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0zQsEiABUjsdMkMEnByRoAgIWKd7GLr6DjLwzP+aDHY=;
        b=ZZ4nQwu8uQ7cD1vI0kPG/2B5p/wdkCHKFir6FUZSOY5pzf77ePd7h3YfSAcC4ID89d
         RVWi8nlUNGlLCzqmlFUbAqlngLIIz8+wRX6GMc9avVKyIepGKqOGnQhqT28Uzj/qTdeY
         JcsdMVmgH2F8yO+yE8zFIVqmu7OIeTLbttQhQVikvydPr/+J42ktxDMatLGDTk00nQZk
         Xk8tPQmgvRphIdLadisq//1b3wekhLWebGdsPorskNS9KNHHCiM2TiQmmVhwm8++puqY
         ee/Rvir9Ij2VJhQshANss4C0eiF1mAM+7mknPab8GSZbKmdxGfembh/uev/LKOzRjeN3
         qImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313562; x=1765918362;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0zQsEiABUjsdMkMEnByRoAgIWKd7GLr6DjLwzP+aDHY=;
        b=qJ+GNetLThqN0dYras7eH7gvFXG1nLHz/ZAlH+0tkY1Igr29tFRdv4DBfmvEwiv2GH
         RgMxO48JHDFuVGiNhxDa6rkFbitJk+SWmlwv7LW1BeEQJ63ykk8Kj01YtqawcftyEELj
         LjVWl8zCZF6fMsgwTnqaQRFgnmn4voNpdA6rk9QTrnc++IPcHKovCY1Qq0/YmLMv+yTe
         LX1wK6869dMZgr3KuHUvZXPQY/dXiITZDdG/4ZDVtD7uyK8O5vqo8Eb2eoiO06wklCnD
         CdkYOrH5LSs/R1Tt82gsD5pi/FEHYghAlI+GzkaZNGctsqP8rYiknFew4QlWMy+gqsj3
         WA4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXLBstvBfOs4MduGN8EU/+EJ3u4EQepubMsrUaDJ2VD5uRfey5gM8ozVzccnmTpN6QFK7Sck5s=@lists.linux.dev
X-Gm-Message-State: AOJu0YxromLGgD+eiJ2l32ut0j2E6FaHluXNpD1rQZS9asa9rilS2l/K
	sETrzcY8CK9fkTiSHswIfWQ4nNfGlTRlVwNzuEGqpMvGzuOcB9UObwD5Eg/gewf411ZpDHbYm0M
	JCq4Y6NDxa1iA0hoes5QjMTC93Q==
X-Google-Smtp-Source: AGHT+IFRKHeoUmjGuNFSlsmzEp/JswAlPAyHOqJKqkJs0+bQVeMX9v3ykC4h/RUbKQXV9XNTVLE12IZWXk6mEzWBCQ==
X-Received: from oahn5.prod.google.com ([2002:a05:6870:3485:b0:3ec:4657:83cc])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6871:8208:b0:3ec:3b3e:4f38 with SMTP id 586e51a60fabf-3f5bdbe25e0mr227516fac.36.1765313562359;
 Tue, 09 Dec 2025 12:52:42 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:13 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-17-coltonlewis@google.com>
Subject: [PATCH v5 16/24] KVM: arm64: Account for partitioning in PMCR_EL0 access
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

Make sure reads and writes to PMCR_EL0 conform to additional
constraints imposed when the PMU is partitioned.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu.c      | 2 +-
 arch/arm64/kvm/sys_regs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 1fd012f8ff4a9..48b39f096fa12 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -877,7 +877,7 @@ u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
 	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
-	u64 n = vcpu->kvm->arch.nr_pmu_counters;
+	u64 n = kvm_pmu_guest_num_counters(vcpu);
 
 	if (vcpu_has_nv(vcpu) && !vcpu_is_el2(vcpu))
 		n = FIELD_GET(MDCR_EL2_HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 70104087b6c7b..f2ae761625a66 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1360,7 +1360,7 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	 */
 	if (!kvm_vm_has_ran_once(kvm) &&
 	    !vcpu_has_nv(vcpu)	      &&
-	    new_n <= kvm_arm_pmu_get_max_counters(kvm))
+	    new_n <= kvm_pmu_hpmn(vcpu))
 		kvm->arch.nr_pmu_counters = new_n;
 
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.52.0.239.gd5f0c6e74e-goog

