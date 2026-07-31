Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AEC3E6394
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508565; cv=none; b=R2D/pTnvXVjicmAkdtN869dBJhdaKyYtvHmmc4xgZaIA6kwLZzcGu5UitNGmlpdTelaVC++6MQdvr+7IWZuW+ury3JNBzvyRkl4wZcgdcQMjElEEQsDTRo59kxOMIqRmaZY2jj48qFLuW63iH5Eaq0X67EXoCUIxlpRZiZ3CWUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508565; c=relaxed/simple;
	bh=lNRJQ6PW1tqyC90494Hhag1s993KXjO4q/F6Ec/gi3M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r3B94LdJTkRmaenSpf4FcK05x58JdoB3u51b96s0Ew7pmRiTDTpF02DyG0bfTXWMIxxAEBE6Gr+jc0flbczwfLvdtgbrSyZ1t5j8xfmdvxf/wrLGesVw9v72H4ujE+0fdT8HOnpsZ5ahgBYPUhFs6Tb48vPm1zJ/GjUsOsizA88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GFH6WPZ4; arc=none smtp.client-ip=209.85.218.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GFH6WPZ4"
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c160e8957d3so81664966b.0
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 07:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785508561; x=1786113361; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xxYCu5PqX7oQBor4HSEAD2JB2T+k3+Y2nJyvkFItg2w=;
        b=GFH6WPZ4o0w6fC6FnjagOFqfNS6CRYoche5WIyeJdQ2D4GMIeWnNvs0zdJvRiJ4E6y
         X25WR5w6z/1bXM5CHehwKjr1QndlfZjPPNKtqEmGDpKEWRPahN50QS3MxnKG1SbLhI0B
         qiuUpha4SWx9/J7BHlwX9kPupeDLb2lh0VtvmLsnyYK0RexCnrVZesdXGlVBBioI3XhH
         xck0V9JwYDpp1NSJ5VP59mfklXO2vJZT5WvT+7mYjZUuBjKbEbhkot3BMqWHMyRjpyhn
         es4Wjbh6VskEmSplKCgkS6J4Lp8TAZs+QXGi+a5W3JngR3mVCDdFn+NAIRps0Jrcrzhe
         P4UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785508561; x=1786113361;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xxYCu5PqX7oQBor4HSEAD2JB2T+k3+Y2nJyvkFItg2w=;
        b=SdZq/Ybm/DZbYaAFp5YcsR1IFhwpFkcSfTsK7ukvsHIF1zGpnjbHBrKok7s0pGsMyC
         a79/aQz9haCXo+TFrenHHaSGSFG90XKLQBKxRtyp9L4pTJN9fGioLss8gY1yg/Xn16iV
         mPBsISvRIBxjKj7VwKOqJofE09hE/sGKX/ihKDNOLHiFtS8Ll2+g856UpSOQq1bekkaB
         04mEW6JVkALSivw/y6e7I/Nc1nvHHVzBWUC5S5D1wjoVPencpbCpFnAdn67e1/nZDG+r
         V00R1LPEgnbAyOGaJYH4L2LUw9crTNTT3pKlfq1Y7P3hMlPK5R2cwt9GIxlnI3AwKGxG
         Hcwg==
X-Forwarded-Encrypted: i=1; AHgh+RoC5RW3/5aHBCXhA4uFnd4ZLJvQg/dEF9kzdBIWqDlijPMZICagRw3Al4m9faWM8jXhd3yOk0E=@lists.linux.dev
X-Gm-Message-State: AOJu0YyghkRljpjEJHaFGc5Ln1s6y9o7NXW4UxxDDR9BocDqApFbIIP4
	gILkOetpCa/7BhRG6nfFagOiNZzxvB7nGamXqcA9hWrNly3WcaIzyBYk2JyIJSzJwsN2HOAS47h
	AbulS05OJH9XMuUlVdMa/zQ==
X-Received: from wmsk18.prod.google.com ([2002:a05:600d:8492:b0:495:59ae:3d1f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:e15b:20b0:c16:72ba:d352 with SMTP id a640c23a62f3a-c1fd2572e4amr110967966b.31.1785508560418;
 Fri, 31 Jul 2026 07:36:00 -0700 (PDT)
Date: Fri, 31 Jul 2026 15:35:29 +0100
In-Reply-To: <20260731143541.956291-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731143541.956291-6-vdonnefort@google.com>
Subject: [PATCH v4 05/17] KVM: arm64: Allow kvm_hyp_memcache usage outside of stage-2
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Although currently limited to guest stage-2 page-table allocations,
struct kvm_hyp_memcache is a useful primitive for passing a list of
discontiguous pages between host and hypervisor.

Introduce init_hyp_memcache() to initialise a generic hyp memcache, and
init_hyp_stage2_memcache() for stage-2 specific memcaches. The generic
initialiser will be used to top up the upcoming pKVM heap allocator.

Note that the generic kvm_hyp_memcache does not account for the
allocated memory. This is expected: donations to the heap allocator are
shared and recycled, they cannot be accounted for a specific VM.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bae2c4f92ef5..caea8e9986d1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -91,9 +91,22 @@ struct kvm_hyp_memcache {
 	struct pkvm_mapping *mapping; /* only used from EL1 */
 
 #define	HYP_MEMCACHE_ACCOUNT_STAGE2	BIT(1)
+#define	HYP_MEMCACHE_ACCOUNT_KMEMCG	BIT(2)
 	unsigned long flags;
 };
 
+static inline void init_hyp_memcache(struct kvm_hyp_memcache *mc)
+{
+	memset(mc, 0, sizeof(*mc));
+	mc->mapping = ZERO_SIZE_PTR; /* Prevent allocation, solely useful for stage2 memcache */
+}
+
+static inline void init_hyp_stage2_memcache(struct kvm_hyp_memcache *mc)
+{
+	memset(mc, 0, sizeof(*mc));
+	mc->flags = HYP_MEMCACHE_ACCOUNT_STAGE2 | HYP_MEMCACHE_ACCOUNT_KMEMCG;
+}
+
 static inline void push_hyp_memcache(struct kvm_hyp_memcache *mc,
 				     phys_addr_t *p,
 				     phys_addr_t (*to_pa)(void *virt))
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6c941aaa10c6..1e37f2f56c68 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1160,8 +1160,10 @@ static void *hyp_mc_alloc_fn(void *mc)
 {
 	struct kvm_hyp_memcache *memcache = mc;
 	void *addr;
+	gfp_t gfp;
 
-	addr = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+	gfp = memcache->flags & HYP_MEMCACHE_ACCOUNT_KMEMCG ? GFP_KERNEL_ACCOUNT : GFP_KERNEL;
+	addr = (void *)__get_free_page(gfp);
 	if (addr && memcache->flags & HYP_MEMCACHE_ACCOUNT_STAGE2)
 		kvm_account_pgtable_pages(addr, 1);
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 428723b1b0f5..d2681da0b629 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -111,7 +111,7 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
 	void *hyp_vcpu;
 	int ret;
 
-	vcpu->arch.pkvm_memcache.flags |= HYP_MEMCACHE_ACCOUNT_STAGE2;
+	init_hyp_stage2_memcache(&vcpu->arch.pkvm_memcache);
 
 	hyp_vcpu = alloc_pages_exact(hyp_vcpu_sz, GFP_KERNEL_ACCOUNT);
 	if (!hyp_vcpu)
@@ -172,7 +172,7 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
 		goto free_vm;
 
 	kvm->arch.pkvm.is_created = true;
-	kvm->arch.pkvm.stage2_teardown_mc.flags |= HYP_MEMCACHE_ACCOUNT_STAGE2;
+	init_hyp_stage2_memcache(&kvm->arch.pkvm.stage2_teardown_mc);
 	kvm_account_pgtable_pages(pgd, pgd_sz / PAGE_SIZE);
 
 	return 0;
-- 
2.55.0.508.g3f0d502094-goog

