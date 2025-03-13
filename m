Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31DE267387
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 11:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741866057; cv=none; b=jM5VWvLsF4wRxGQbHu/4OuuwMINTGlTh0n32eIh4eJ/xlxiLm5JOzwyhQvO97b5BkpuoxnQqa7nPceVEshxOnuTfPB+r+doyqguU27spsiTUkAC3SYCPuO6RiqFNYGrFH54J+LjyXSOqBJb4JaQdCPRoYwhc5f6lo/eHA/HhaOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741866057; c=relaxed/simple;
	bh=xQw7CCkIa/tItrTgXKvKC4t9RKukRRO3SkH3BuVk0FY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l8HCuOsvzDp1wfDoR2GSLPximtuyyie1M3wRvyTKs4FUYyEbSHeumpFqWlH5nFBo3L1hE7FSQyYIT8GJc5+Yg37uOWPEXylWhj1qw82MGSt6Chp3HT9MGfpk7K5SS3Jxq1cFHyML3s/+aKJ5ssntJhDSsfH/z/tiLACHTgLK2BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XoSDQis6; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XoSDQis6"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3912b54611dso563710f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 04:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741866054; x=1742470854; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fp6lx89NDYaCWj8yztXIUiroS+BazPKE4hbafizh3a4=;
        b=XoSDQis6mu1AXuMNGcaELdiQkPSiuAPijy2BjdyKogxdn0JaSnAQcrnFSQfjr6w5vz
         iXXolkcwkdWHqYidvgK6cHvllRJMhwnUl4RmGY2+KUGOb4GRR3+jb1bUC8O1vL1KJzcG
         AFa29ePyL3Q3CpzFxCrJeJHR3APdHIJqnxmMnNcU3jn1USKxILcIk9UNdLODE5rknCRx
         bXL5d06Mi+u4Jw0xNC513aOoe4zl7fTNPM9zMudY5i/AaheuXW78j2TEteUfoB4oTWC+
         X3lq8rrLVroJM9unnif52WhR9Tk/vF9aYosPAGYDPkZAaVfLHgNEXjySQAfpcM3AzD8E
         LqWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741866054; x=1742470854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fp6lx89NDYaCWj8yztXIUiroS+BazPKE4hbafizh3a4=;
        b=EYdfjY1pV/JxKXovZzaWyfxbbT6FYd8l3C7pxcwpIHr8XbltEbkMCpbhtaTr2hYuKa
         xbQdJMfolNSMreJakaKPW2fs2Qe10j/D+gC2IW3khMvQM6y64tQFzWhdErKpRch+EVAq
         vkEh39dm1HkhOZOwm5JowjtFSNwWhsveErL1qJvfNpKVbhNUypoLxYdXvqZIAHsbDDsS
         csHqGpAmVpnA+NuWlNwHjwNYRE1j32t8i0hN9vzSC+ECRYD/7bv8MZFgmioEHpW+Z049
         uIRKhQkDHUm+SfYQBGUzpBf7h2zjfMcNjaKKj2OVYZgvsJovrZcrN4J+UhhrrGl/HQgR
         TbiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAM3xmDbA1wfqiA4cCGupEUjU2mRRz6aRwZOPSrIPnG6gkjtlo5xLjktOBH8Ad3qsxgsx995Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YwE4H6jXaWP6AWnwdGZK9Y6kgJF/7fZMNARGyyNb0mkdk1F2lOb
	s0pTf2FyCZxeX4Qwu0QCi+zTSrvmDjiyrZlT4lKJ+D1CHTNEZyn9I0OJBuH/p0aqOXG+FTVrxxC
	ofI3pKMKgbyhklb3IyA==
X-Google-Smtp-Source: AGHT+IFt9bxBQ+OiJ6M9T42VJJBXQ3dgE7XPDiGETKJiQhO61thf8YCecySsYum/tlZhh/1oFpOYkgivgvMyU5WF
X-Received: from wryv4.prod.google.com ([2002:a5d:59c4:0:b0:391:3be0:78cb])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1a87:b0:391:1923:5a91 with SMTP id ffacd0b85a97d-39132dc4395mr17764441f8f.55.1741866054357;
 Thu, 13 Mar 2025 04:40:54 -0700 (PDT)
Date: Thu, 13 Mar 2025 11:40:38 +0000
In-Reply-To: <20250313114038.1502357-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250313114038.1502357-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Message-ID: <20250313114038.1502357-4-vdonnefort@google.com>
Subject: [PATCH v4 3/3] KVM: arm64: Count pKVM stage-2 usage in secondary
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
index 6107a3c8ccf6..2feb6c6b63af 100644
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
index 19921ca407c6..4409a10d02b6 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -165,12 +165,16 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
 	handle = ret;
 
 	host_kvm->arch.pkvm.handle = handle;
+	host_kvm->arch.pkvm.stage2_teardown_mc.flags |= HYP_MEMCACHE_ACCOUNT_STAGE2;
+	kvm_account_pgtable_pages(pgd, pgd_sz / PAGE_SIZE);
 
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

