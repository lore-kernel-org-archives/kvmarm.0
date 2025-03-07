Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EFB21885B
	for <kvmarm@lists.linux.dev>; Fri,  7 Mar 2025 11:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741347267; cv=none; b=mgObOnfnxgoAVkV/MFdM+G9P5iuM60UcBVMXpuWsJAWWZZvCKo2PCkuon7JRy8P8Zy06pysot2nJpCFE/milYdDqKWsMuzV5acKSo8Zzpz/BeC2wAOFNS0gtn/VtXL8EhIEWbY54dytOYw40Vp9ZAEudRTis2DQADr+kgSnjn8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741347267; c=relaxed/simple;
	bh=HH6yLXJUvxDiJ1cSfj8yphZfz5sICSe4TnVL3hkc6bA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Enz3ErPKC+CHEN13zE4SZfBNGhGArp0d8buUuVoTwQL+NtKiV5FiOGMRgrheIZaRmYQefPemoQaDcB5T8ZA8VRbnfx+nSJcimXZSLO3VOTBK+u4x5NkOviFixv1aBew+hf+hFCSIioPNRCk6jnmkFx1PURFLpDlcqT5CKkd1yOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wLqFilAp; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wLqFilAp"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43bcddbe609so15618145e9.3
        for <kvmarm@lists.linux.dev>; Fri, 07 Mar 2025 03:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741347263; x=1741952063; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7ntuubx8ETsO6TTIOT42EyExqJBNP9f2/d8qVb4BOX4=;
        b=wLqFilAphwziAeW1ykkKR94cGHdN7vjtLxHXhOeEqoXRA+MrFZlDvmf+xja5gVutZu
         j5g6RBHLgc8HgtZ79QRO43/xw1T2sTAv0DSKlASHFa1Vhc/wybiw0M7Ec6DjwfHItH7Z
         48sydytlMJpx6VSSgg8/8RGp210aUnSEeIb0WQB6e2eY6ZTkNJV99W/Iep+F+5ih7NzN
         JP8WIGoudRyirSagvB1vGNqT5DYtkJeSjW99VH6VE4oGlxppUQ8bqGiUnofcJWjObBSk
         fbhWTLmYRaLNldptqD+hrT4If8zRw8fqG5LuJ9KwymXfHm9xxMTz0156zuAPZiNDrrm4
         7aIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741347263; x=1741952063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7ntuubx8ETsO6TTIOT42EyExqJBNP9f2/d8qVb4BOX4=;
        b=w8G7LOJIDr3HAxqmcX18HwkWoI3Skyy3XUxyibNkY3NsNlXR8gu0AU515ccyH04c/l
         voJFAJMjfooGLSX5c9nhQizJkvoVvDaeBze/1qQUjLRyW75vvNeDN/fbdJt7sdULntmT
         F1D3JoJFj+u5+wyjC1l/Oi4MM/IEVF0YhVQ9fYJnn/T+dO3WDluSCajcb1x6CcAGnaQF
         56cQcDubdKPVnBzNa6dbz1edCbIFKRhz2YFobgtD7KMWRM9bQmeX9iW/tRWaKwF33tu7
         MMXXOn2fmtd1hEE6JR4l7yvxK9upZo8v4MW+p7mq6+UVMCVrRRiehAvMoIVixxt0r9v2
         AXeg==
X-Forwarded-Encrypted: i=1; AJvYcCU6hFDs4v4X2pCqF7y1GCCyhuNqX2QXB2yQxLznvKcm6iehbcEnWR8vwfVMqqt3vtmZVohTEtI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwXI7z5Nbw1pVB5AWC+9o3lKItjo4Sh6AxRrH6ItED7V1zZD358
	+vv+QV2teijuupNf/sYRwwRXKBhITwc0y3SRwPlc/Dv8R0X/k8qvRwNI8Z+bvBAIg42Ft8DnQ0t
	NipohOaFkh6UuFEybvA==
X-Google-Smtp-Source: AGHT+IHklc9pmH21U3YbDQ5Gwc1RGIuSlYKt8XLy0tqeyn/MaP9krs7wUaI3Q0qrAvYZEPn9BnOr0sZM8eUcQbxr
X-Received: from wmbja12.prod.google.com ([2002:a05:600c:556c:b0:43b:d8f9:568a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:310c:b0:43b:d72d:368 with SMTP id 5b1f17b1804b1-43c5a630260mr27416035e9.2.1741347263644;
 Fri, 07 Mar 2025 03:34:23 -0800 (PST)
Date: Fri,  7 Mar 2025 11:34:11 +0000
In-Reply-To: <20250307113411.469018-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250307113411.469018-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Message-ID: <20250307113411.469018-4-vdonnefort@google.com>
Subject: [PATCH v3 3/3] KVM: arm64: Count pKVM stage-2 usage in secondary
 pagetable stats
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Count the pages used by pKVM for the guest stage-2 in memory stats under
secondary pagetable, similarly to what the VHE mode does.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ace3969e8106..51754a354b7a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -86,6 +86,8 @@ struct kvm_hyp_memcache {
 	phys_addr_t head;
 	unsigned long nr_pages;
 	struct pkvm_mapping *mapping; /* only used from EL1 */
+
+#define	HYP_MEMCACHE_ACCOUNT_STAGE2	BIT(1)
 	unsigned long flags;
 };
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c01ad4430729..73b44f1200c7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1088,12 +1088,24 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 
 static void hyp_mc_free_fn(void *addr, void *mc)
 {
+	struct kvm_hyp_memcache *memcache = mc;
+
+	if (memcache->flags & HYP_MEMCACHE_ACCOUNT_STAGE2)
+		kvm_account_pgtable_pages(addr, -1);
+
 	free_page((unsigned long)addr);
 }
 
 static void *hyp_mc_alloc_fn(void *mc)
 {
-	return (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+	struct kvm_hyp_memcache *memcache = mc;
+	void *addr;
+
+	addr = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+	if (addr && memcache->flags & HYP_MEMCACHE_ACCOUNT_STAGE2)
+		kvm_account_pgtable_pages(addr, 1);
+
+	return addr;
 }
 
 void free_hyp_memcache(struct kvm_hyp_memcache *mc)
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 19921ca407c6..7e6e3b0518f8 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -165,12 +165,16 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
 	handle = ret;
 
 	host_kvm->arch.pkvm.handle = handle;
+	host_kvm->arch.pkvm.stage2_teardown_mc.flags |= HYP_MEMCACHE_ACCOUNT_STAGE2;
+	kvm_account_pgtable_pages(pgd, PAGE_ALIGN(pgd_sz) >> PAGE_SHIFT);
 
 	/* Donate memory for the vcpus at hyp and initialize it. */
 	hyp_vcpu_sz = PAGE_ALIGN(PKVM_HYP_VCPU_SIZE);
 	kvm_for_each_vcpu(idx, host_vcpu, host_kvm) {
 		void *hyp_vcpu;
 
+		host_vcpu->arch.pkvm_memcache.flags |= HYP_MEMCACHE_ACCOUNT_STAGE2;
+
 		/* Indexing of the vcpus to be sequential starting at 0. */
 		if (WARN_ON(host_vcpu->vcpu_idx != idx)) {
 			ret = -EINVAL;
-- 
2.49.0.rc0.332.g42c0ae87b1-goog

