Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27059204879
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 13:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741095840; cv=none; b=nmjJkNT7YZBrlEswzi6SEreX2C2TearYttjq52EzTuCH+01IyjpK0+ZvcIo5XrNNHleoGGJcoIL6V6z21xAZD8fTFDl6DuxrrdvVvRUdbn+boruHKRXrWSetNMO46UCC5CtS58jZqXube8iw4lN2uiDbG+Twsx25R3MA/v7q8tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741095840; c=relaxed/simple;
	bh=TtDaAc80G3uF6Qy8Dx8fbtAtbyeSJL7qw00QyGEAccU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oSXI38eHSGfWESf56nUHhsb0ZAYsSpS6uMiu1T1oUGAYv1phmnGeKrZ/6B0Xs+H5v0lGOqP1y96Y7saBe2OAesbzhmW9nJeg5gxMEF8NY0/A0lErSuxVLQMWk0czCec/19Nz5WT7Js7KZDPlcLmQqQMpKdm+qQ37RuoFDCAjNwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=04nxE/Vg; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="04nxE/Vg"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-390e271517fso3329094f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Mar 2025 05:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741095837; x=1741700637; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nOQyJ57ni6L+J8E7B8owB1YjEi2kSEAuov44m6pse38=;
        b=04nxE/VgvsaMuX0Load/ahcrJU0Cf9tm5DM6kBK2CG8rsa0+LX6qh0I3ct5MgrH8jL
         LiXRgToRgE9wDS9MDPlgNFKpxPZh4pOMBw3hzTL2Ut3VoQlICwU/TCGDkvTDEjD+Ybiv
         wIajvjtPyVU9GJ0M9CcRedvXsEa53B3M47/d06nE08jIYJC1G0dvHtM9m0WNJNGj6crx
         07nD+ExIOJBnlwercQmv47gcPA1qgrm0tHn0bKvUkO2wxwOacxFJuzL9PWCFT/2zncz4
         h1Oxe+nf1lNWGIGFQX+kPG+eflScQ9Bj967anUyZzT1+ag18yJgt/anN+UTheP3mKWmG
         Yj0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741095837; x=1741700637;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nOQyJ57ni6L+J8E7B8owB1YjEi2kSEAuov44m6pse38=;
        b=vzfRIeYgwvMbtTrgz1KpBBvwWb9NcUF54l8OCD4fqjJMxBWgdNz9qRTUikYiUcvHQ6
         7Db1tgzE7th4OdOByH2PiVOXxmUS78NbFUg460TDp0/SddPVJ7EQnum63VIsEYzj0C9P
         4HKhd+JP48hcf4GDhtU4WVplngO2+UkhVr2O4U7ln7rX81Rr09fiyP4LydwQiOmouhAn
         4KYp1IlTnnfnup4tJorFlRz5OkQ41D/tGqyUDCqqsLE85NUmMiuYvqo1R1F5Is2rqZmO
         c6Ns0GrVNns2rZDB8Cy1MPzlZ2NVgLdwdyLhwMBNudOuAwA9Uj7Xb95P7yxowzGthngT
         kU+A==
X-Forwarded-Encrypted: i=1; AJvYcCUP9aYxWMDRVwKsI5vEreAXLw7KApR0/EEAFtACz44ybOcGt1i2LN8i/MngNImNC+xVXq/T7Wk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5SCizJtDkpbKkXaRtujjSFBVHl5GN3LPMnr0/JbGTfJLEWnuB
	hbL4aLREK6FQ3PXUA7Qe/9rr6657Z+G1LjGADQNIOVbxRv5FRwO16owXeH9vD6IQbMOtIYdBMNM
	8PRenNAiUU0Kx52X0FA==
X-Google-Smtp-Source: AGHT+IEFMhEaRI/rg8Se9LHpsnXPQyKb7X7zdX+0i//MGRw5LE5hwf7vaICZu9T6cB0TCPM/wkm9G80CRMo3IsJ2
X-Received: from wmbbe7.prod.google.com ([2002:a05:600c:1e87:b0:43b:c6a4:89a0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:418a:b0:38f:32a7:b6f3 with SMTP id ffacd0b85a97d-390eca41867mr10968930f8f.40.1741095837446;
 Tue, 04 Mar 2025 05:43:57 -0800 (PST)
Date: Tue,  4 Mar 2025 13:43:46 +0000
In-Reply-To: <20250304134347.369854-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250304134347.369854-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304134347.369854-4-vdonnefort@google.com>
Subject: [PATCH v2 3/3] KVM: arm64: Count pKVM stage-2 usage in secondary
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
secondary pagetable stats, similarly to what the VHE mode does.

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
index 68d99baa76c2..85d739fbddb8 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1088,12 +1088,20 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 
 static void hyp_mc_free_fn(void *addr, void *flags)
 {
+	if ((unsigned long)flags & HYP_MEMCACHE_ACCOUNT_STAGE2)
+		kvm_account_pgtable_pages(addr, -1);
+
 	free_page((unsigned long)addr);
 }
 
 static void *hyp_mc_alloc_fn(void *flags)
 {
-	return (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+	void *addr = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+
+	if (addr && (unsigned long)flags & HYP_MEMCACHE_ACCOUNT_STAGE2)
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
2.48.1.711.g2feabab25a-goog

