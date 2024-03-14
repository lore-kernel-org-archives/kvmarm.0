Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C6C73178
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 20:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447825; cv=none; b=KVO2uySFc8HVjj6wztwJVq8Wo3Pzz7PsYzhH5Dn50bhPkP+ggpwwF7ZZ8/fTAQmNCim+9VfyWagFYFix0/bnZkyQKMkoF01BGfXDum2lkKKnEIPo90CuD1aFosmTuvLFuj/MrY80E1Suz4QxEEzAkgoKUFJ/dTLG8HOY0HdAxAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447825; c=relaxed/simple;
	bh=/g/HcoEQQBJkRAL4ZwbS8omMCk85N2nyfxKtjk668ZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MQ+3ENWdvbeIJwPoY9a/9HaXVO9YZO+FnTPt9QBZNMtbIQEztxfaffCWR1xsEsI7usgxXhmOPNj8GRRTIZTz/T7qlXcd/nvVYUXag1WpAnsjA3pCIRLbkrqPbKyTI2vzz1o61gcQx8d3+Ozfck9sw21m4KXOp9VlNKQdPq8WzDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pvBn15y6; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pvBn15y6"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-513d599dbabso684441e87.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 13:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447822; x=1711052622; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bhfRLCv5E8LczXhWX76XPlZKS4T8I7qgV0XO4dVuEZg=;
        b=pvBn15y6TQx6BZnrBHHT5DZpnF5ahIZimn4TVCqKG7FuarCaSs5Exk6YBSaWex5x3d
         +d6Qg7pAo3FRP05Kd+23Bm5gHdxuw3G62Q0o19M/P0airmqOLhmdNGJDEi1GiaMsEvl4
         2EQJzo3irMAfO8W8hmdATHpeWII+uJ8tr7YiT5+PWmD4YZnRF8W/BdA5V5cRCT207T4S
         xnUsPXNgX+7yWCsqkHVmVYL1SHg21uDdM0R/JbAOZKfJgthKMlhlKqu+++I3AB1JVa5z
         +7BsHZ4FkR3qrqO4KKz0AI0fRQg1iP6Tw7Sz4GAYOXHbCiz8o/Ggx0x7pn7Nm1os0BCZ
         FHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447822; x=1711052622;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bhfRLCv5E8LczXhWX76XPlZKS4T8I7qgV0XO4dVuEZg=;
        b=sJpSBRJF+UB1wmVdt/oR8ncJ109RM1ry4cKZWfHE00stk/I3kHq9MXQJdAROpUlG3p
         OP7bLECPCBDzk7LzvL4+IcTIhOzK/zJWIn8P1TIcYWT1BAqoqe0Wy6UrWz0HbdrtVVp3
         eKWFyZqN9eRgDoCWDMkbj7qBro7pUdfNSDamFqG+VVjJWRMkgAQ/cokL98LZt2T0tCaE
         fphQzAu5N5o4TnG1oRN1j0cenP8Sat8F/tOUD6q+0eurMjHgObVhDUMSsmt4xNc/d8XG
         m5thZLCBja5jYgnetwtjophMS3gQYEVr6qArx6QrZO6yE5tj5iyjLlC1sQ6hYqgiwmOU
         pmgA==
X-Gm-Message-State: AOJu0Yw+XD0qSOtzwOGDA5+7LLnmejyEqU5Al/P+DtWTVHzv4n5UWkJz
	38z1cGt8z4f4Kwyt/QpT+qaYhDrmhwPavnvfuYHIliPA8qiZRIEhK2xSiOAobnT3ROiiZliFaLU
	GI853
X-Google-Smtp-Source: AGHT+IFKN6Q76VRunakd62YijaomXD5YfYUy4KHbzgcm8HAUJxkFpfyEXSR19suk+AGp/vhNuREp1g==
X-Received: by 2002:a05:6512:52f:b0:513:ba0d:c2fa with SMTP id o15-20020a056512052f00b00513ba0dc2famr1938984lfc.54.1710447821974;
        Thu, 14 Mar 2024 13:23:41 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id v15-20020a1709063bcf00b00a46454a7e24sm1007519ejf.71.2024.03.14.13.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:23:41 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:23:37 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Subject: [PATCH 02/10] KVM: arm64: Fix __pkvm_init_switch_pgd C signature
Message-ID: <cd18b1eb89dc91230692e0534bd4e338b91b6867.1710446682.git.ptosi@google.com>
References: <cover.1710446682.git.ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1710446682.git.ptosi@google.com>

Update the function declaration to match the asm implementation.

Fixes: f320bc742bc2 ("KVM: arm64: Prepare the creation of s1 mappings at EL2")
Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 3 +--
 arch/arm64/kvm/hyp/nvhe/setup.c  | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 145ce73fc16c..7a0082496d4a 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -123,8 +123,7 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
 #endif
 
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __pkvm_init_switch_pgd(phys_addr_t phys, unsigned long size,
-			    phys_addr_t pgd, void *sp, void *cont_fn);
+void __pkvm_init_switch_pgd(phys_addr_t params, void (*finalize_fn)(void));
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 		unsigned long *per_cpu_base, u32 hyp_va_bits);
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index bc58d1b515af..bcaeb0fafd2d 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -316,7 +316,7 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 {
 	struct kvm_nvhe_init_params *params;
 	void *virt = hyp_phys_to_virt(phys);
-	void (*fn)(phys_addr_t params_pa, void *finalize_fn_va);
+	typeof(__pkvm_init_switch_pgd) *fn;
 	int ret;
 
 	BUG_ON(kvm_check_pvm_sysreg_table());

-- 
Pierre
