Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6D613D62A
	for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 08:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737704; cv=none; b=C5KN+uJX7ozSvpbDqNCjUZZRh1I1mwH/2+jh01OeQuNMF/6tXL3mbXK92BpBMeU6bvINXGcOzc/P44kq2c9fGQRwS++tBhKWB3+nNk7zTksMiFJueW8Jfc02f17yAp43gFxlFushvagRtT94WH673qdVB5B7mLvjoSb59BVmVx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737704; c=relaxed/simple;
	bh=SNsqoj9eNqjKtvp5/K3OU5JaLw8PBS6M12dONrb5QKc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=TjG7vXzaKMZHLbOJjM30K2TQFb2eftsvFVrjyRx6JJ+msm7V12NoCR6YrLLYoyrblM7xF9pWpvWei41LuHnuiVu91ey9iRLdkIfBV5CrCpyPiZxmU5SZvIGlWJrJKFnu8kjIMOoqNFZ8CEppP5nAWsLWpfu90NnhTrBja31u4uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Seq24GvW; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Seq24GvW"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a51ddc783e3so365047566b.0
        for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 01:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737701; x=1713342501; darn=lists.linux.dev;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AcC4Vj21DILBZiNE6/g7j9wakFMnVaxsPp20pxP4UlU=;
        b=Seq24GvWSwapsTRXmWLySYbMapGTX+bpE08mH9qCyqowLxkAGG0FPIwULkTBUsXUN2
         vZwcC3QGvjfRuFGRnJs3CFQr5ZCf2HOrrhjlD/KSwmPAtOBnE4kxKgdijbc2ngQIwOQl
         5CfSz8rxrPu2+h8UoXRb6CarRaNNstDWOg2oSBfjfyUj8US6iBBjS/Ma3XRUedf1mrKQ
         zEf3Q17nKyBZ66l5ea7FbwTsgeFlTEqLIh0JHGZ5v1JxCNFxrsHNVgIHpkaKUCuqY2cf
         yCpG8gXgvS1gRgbxwYQ9bH8Mcaakb7k/n70PXzb1aR0nqN2+pPEgL+iqE+M5SoPRS70P
         7V6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737701; x=1713342501;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AcC4Vj21DILBZiNE6/g7j9wakFMnVaxsPp20pxP4UlU=;
        b=uXCrC8HAyVQkELWCCbLVt+p/WLQZAAPopHX7AtP7l0w872v+j1Y1s55XbPj5gIllqD
         0VkMQ5AiPcISthbz/ilY1IG/T0U3NEV3yb37jc7sKkPizvhBCio/25V4Nv6YGq7GknFG
         DyP22d+eMU4YkKWFxSHWbpXyE/ZTapNO1kZkRFkZNLaHYNxukNHJB9Fxgy9q08kp31Ws
         h2bcWdcReuHef3Vjg9DkaJO1YaopWyOcwuQzezciLyNy1pcPJUjQvEfliQ6Bixd+w8KJ
         sJQEGFzaelrj8910/Jbk9b9uCvjWnfxO0Q3gjj1yOWpi5SpUCiDYRj8LyeH86HPArl1s
         r6vA==
X-Gm-Message-State: AOJu0Yx7wdhq8ligOOkHL4Kt5Ai8V5eOxUGnDhj+YDfjduScnzLXGeJ9
	GK/0roQj0FxZnmkrtJ+MGmy9mwzChQ0FMIpkL4xW1bgyWRaQ0FYV8538LZpodvCmG93HHd3CnoX
	9Wg==
X-Google-Smtp-Source: AGHT+IGDOlmZUNa/b3VDkvm8WfG9UbS0FH17m/cxzH6+qrZhejCFvYfRumRMzmA89IrkJpXU6vz+vw==
X-Received: by 2002:a17:907:70c1:b0:a4e:a068:7f with SMTP id yk1-20020a17090770c100b00a4ea068007fmr962531ejb.49.1712737700913;
        Wed, 10 Apr 2024 01:28:20 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id qq18-20020a17090720d200b00a51cdf560b9sm4255362ejb.37.2024.04.10.01.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:28:20 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:28:16 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 02/12] KVM: arm64: Fix __pkvm_init_switch_pgd C signature
Message-ID: <22rqvzc34ehoirj42j6q27gfkxj53gjuryvtqqwh2q5d5yggme@rffmqhcxmtvy>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Update the function declaration to match the asm implementation.

Fixes: f320bc742bc2 ("KVM: arm64: Prepare the creation of s1 mappings at EL2")
Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 3 +--
 arch/arm64/kvm/hyp/nvhe/setup.c  | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 3e2a1ac0c9bb..96daf7cf6802 100644
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
2.44.0.478.gd926399ef9-goog


-- 
Pierre
