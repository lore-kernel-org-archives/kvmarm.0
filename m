Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B2119B5BE
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 12:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734524089; cv=none; b=sc30qcPjOGGhosD71JVDCTTiq6ssJPKAw7GU1gSwA+RmPhB1BieVumYrnsQShnfIIBa513UMAAkyGONXWveQuqBSqVAnz+Wd/9lmpiqtc0Yv1SvWU9lDk511SwodxBZvx0lXHpoKE1LZubkoenRNoqPifKda+lmVKr7zBkW4WU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734524089; c=relaxed/simple;
	bh=KWaTeJL7rbLv9TLiGkDa+uKwbiSN162dPG9E0WqLCok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SRY1H9shYvhpx9KxeUAGmY636hg/sgPCCp3YNXPtxm7bnij5wKn4o29TAWitg9A5i/o7UwakCSzxCHWt+8ZYoEs85wCz0k92giWCfPVxMJajfYQBZAfSfxSXDbcdHt32BpaTiX0GG8ckr4RsoOmx+7Lo7BGjImjem6GZJHKa2pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dugqrRwf; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dugqrRwf"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-30229d5b21cso56504321fa.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 04:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734524085; x=1735128885; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TffUWnK8qRknoMZpdRrwzjPRWDBT0fSzYTx1ZBmTW4Q=;
        b=dugqrRwfLyyPBxWyscMEa9hkK3N35mvgzcLTQTgh/xiAQF8lXUVaMk4BU7p6o088Jm
         IJ4+janOoQ7uNKFZOhBXCzdGJq/b/R9VK7P9uf2AI0wXBdq2WeCkBnFtmuBmYdRXdNx9
         oF6DElQwn/jcBn2n37Bv9mLIhZIM71p3g8psrKAbLShEzlj4tGwhdHnihi7HnkHRUpfV
         rfzqM8ciCdHkPBFn/dLl02NxZvuM9Ibh4YYkf6QEwtJAJ8n3t7uiGGrIBS+fRTutxHvg
         led4bbXlKlakj8MN494nG1NvNdl4D3wPqBuvRQr1MDzhqZQ6yJnbkMN6tS7jc0B1qDrB
         LG7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734524085; x=1735128885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TffUWnK8qRknoMZpdRrwzjPRWDBT0fSzYTx1ZBmTW4Q=;
        b=Cadv4rj8lA2pZ+bgY0X5s0wETirH8LCm6iIoVmnIHhPdtCu5Eek+NKScOeECghyrd5
         azOTQkkfmj4I9G0S+TvuZzuXgI7r2R/hRTuHknrBmiwL8wOGl+ZCJ4jrdDiSa5XOHmK2
         04nq1NS9wlCnXu28axPCSiExxrSEZSHNhLKJ1NMHcFSgSX8zs2YgZyg7ztzB7TdYTXSh
         PgrDZupAoDFOKI/4IVp+6RBoIBtL6T97c5kqKaN7KxLy6Qc1DKNSbvljeVh3Pz3LQ3iR
         61o8ILM79LpJeGyom7XHEDNQHEZNHSK25Lt4/PWy2jZ0NgV/DJjK2IY1YeLK1h4/q48I
         z0lw==
X-Forwarded-Encrypted: i=1; AJvYcCUs4AM9N0xnS5FyCD7cI4YjviDksztVvfeOFMMrOzCOUodzkzRntNLG9BJFQob9Bs4StS1PFxc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzHwyEPV0C4cqW1XtghcS0TeL7vHdkbC9V6rEP6218LnQguJ+AD
	ZO0I+tZzKa1+4S6FJ7Po95envW6ElLmRIEJMw+bEtvlcsiKEcuhQ9QUkof+2K5+G0mrdkVPBscF
	HDQ==
X-Gm-Gg: ASbGncv98o2JKW4Qc7r2UZno6Q9PKTATMX2jkiHXDbqP541Y/i/OL/P1xFgT5ODkZeR
	F1PDO5gf9xqhvFt5G/TRwAeWebU4ezswU928Dd+5zMDC0eQyYhUIf4H16CxcWJaPN89euSvjW8z
	+H6w9wE9n49zv66YNquvnKsVO+DZ3w0nzN16n5GVEtDQ1JEHrTM4mwbCSoICBNbWatY2XOOYc+L
	OEPUbCTfBMGi6JoHoQUxQprijOFeprRUABC3UFCEcYmAjpq/iKuDtRle8JWqgPOteEqgThs3LOQ
	DT7+hgFYxQWpyAA=
X-Google-Smtp-Source: AGHT+IGh5JR9f+iJg3ul5+Dz1gzA6cwcFZttYXLX++lDo61oRhkeZsMd4gZ18WSWTQ8EuZRU856ksg==
X-Received: by 2002:a17:907:7854:b0:aa6:3e97:f9e2 with SMTP id a640c23a62f3a-aabf48b987dmr181518166b.47.1734523619346;
        Wed, 18 Dec 2024 04:06:59 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aab9635996asm561668766b.102.2024.12.18.04.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2024 04:06:58 -0800 (PST)
Date: Wed, 18 Dec 2024 12:06:55 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 18/18] KVM: arm64: Plumb the pKVM MMU in KVM
Message-ID: <Z2K63zlpoQz76hnl@google.com>
References: <20241216175803.2716565-1-qperret@google.com>
 <20241216175803.2716565-19-qperret@google.com>
 <86ttb2qudi.wl-maz@kernel.org>
 <Z2GLR8KZzJn1YpUu@google.com>
 <86pllqqpzm.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86pllqqpzm.wl-maz@kernel.org>

On Tuesday 17 Dec 2024 at 15:38:21 (+0000), Marc Zyngier wrote:
> On Tue, 17 Dec 2024 14:31:35 +0000,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > On Tuesday 17 Dec 2024 at 14:03:37 (+0000), Marc Zyngier wrote:
> > > My gripe with this is that it makes it much harder to follow what is
> > > happening by using tags (ctags, etags, whatever). I ended up with the
> > > hack below, which is super ugly, but preserves the tagging
> > > functionality for non-pKVM.
> > 
> > Ack.
> > 
> > > I'll scratch my head to find something more elegant...
> > 
> > I find your proposal pretty reasonable -- I had a few different ideas
> > but they were all really over-engineered, so I figured relying on a
> > naming convention was the simplest. And any divergence will be flagged
> > at compile time, so that shouldn't be too hard to maintain looking
> > forward.
> > 
> > The __S2 name isn't massively descriptive though. Maybe KVM_PGT_CALL()
> > or something? Thinking about it, this abstraction doesn't need to be
> > restricted to stage-2 stuff. We could most likely hide the
> > __pkvm_host_{un}share_hyp() logic behind a pkvm_pgtable_hyp_{un}map()
> > implementation in pkvm.c as well...
> 
> Oh, I'm happy with *any* name. I just changed it to make sure any
> missing occurrence would blow up.
> 
> And yes, if we can make that more uniform, I'm all for that.

I had a go at porting the hyp stage-1 code to the same logic and
ended up with the diff below.

It's not completely obvious it is much better than the existing code
TBH. I ended up resorting to odd things like passing a NULL pgt to the
pkvm_pgtable_hyp_*() functions and such. All the mess comes from the
pKVM boot flow, where Linux originally creates the hyp stage-1
page-table, but then frees it after pKVM has initialized and switches to
using hypercalls.

None of this is needed for this series though, so I won't include that
in v4. I'll post it separately once that series lands, and then we can
decide if it's worth it, or if it should be done differently.

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index d116ab4230e8..b35c909f4d0a 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -152,8 +152,7 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 #include <asm/kvm_pgtable.h>
 #include <asm/stage2_pgtable.h>
 
-int kvm_share_hyp(void *from, void *to);
-void kvm_unshare_hyp(void *from, void *to);
+void remove_hyp_mappings(void *from, void *to);
 int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int __create_hyp_mappings(unsigned long start, unsigned long size,
 			  unsigned long phys, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 65f988b6fe0d..db7851459ef3 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -143,6 +143,11 @@ struct pkvm_mapping {
 	u64 pfn;
 };
 
+int pkvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits, struct kvm_pgtable_mm_ops *mm_ops);
+void pkvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt);
+int pkvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
+			 enum kvm_pgtable_prot prot);
+u64 pkvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
 int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			     struct kvm_pgtable_mm_ops *mm_ops);
 void pkvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9bcbc7b8ed38..2dada891c199 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -183,7 +183,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm_init_nested(kvm);
 
-	ret = kvm_share_hyp(kvm, kvm + 1);
+	ret = create_hyp_mappings(kvm, kvm + 1, PAGE_HYP);
 	if (ret)
 		return ret;
 
@@ -217,7 +217,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 err_free_cpumask:
 	free_cpumask_var(kvm->arch.supported_cpus);
 err_unshare_kvm:
-	kvm_unshare_hyp(kvm, kvm + 1);
+	remove_hyp_mappings(kvm, kvm + 1);
 	return ret;
 }
 
@@ -268,7 +268,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kfree(kvm->arch.sysreg_masks);
 	kvm_destroy_vcpus(kvm);
 
-	kvm_unshare_hyp(kvm, kvm + 1);
+	remove_hyp_mappings(kvm, kvm + 1);
 
 	kvm_arm_teardown_hypercalls(kvm);
 }
@@ -493,7 +493,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		return err;
 
-	return kvm_share_hyp(vcpu, vcpu + 1);
+	return create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
 }
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index ea5484ce1f3b..49acdda3f1d0 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -33,7 +33,7 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 		return 0;
 
 	/* Make sure the host task fpsimd state is visible to hyp: */
-	ret = kvm_share_hyp(fpsimd, fpsimd + 1);
+	ret = create_hyp_mappings(fpsimd, fpsimd + 1, PAGE_HYP);
 	if (ret)
 		return ret;
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4e6cf4a1a6eb..53e584a5e8d7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -407,44 +407,20 @@ void __init free_hyp_pgds(void)
 {
 	mutex_lock(&kvm_hyp_pgd_mutex);
 	if (hyp_pgtable) {
-		kvm_pgtable_hyp_destroy(hyp_pgtable);
+		KVM_PGT_CALL(kvm_pgtable_hyp_destroy, hyp_pgtable);
 		kfree(hyp_pgtable);
 		hyp_pgtable = NULL;
 	}
 	mutex_unlock(&kvm_hyp_pgd_mutex);
 }
 
-static bool kvm_host_owns_hyp_mappings(void)
-{
-	if (is_kernel_in_hyp_mode())
-		return false;
-
-	if (static_branch_likely(&kvm_protected_mode_initialized))
-		return false;
-
-	/*
-	 * This can happen at boot time when __create_hyp_mappings() is called
-	 * after the hyp protection has been enabled, but the static key has
-	 * not been flipped yet.
-	 */
-	if (!hyp_pgtable && is_protected_kvm_enabled())
-		return false;
-
-	WARN_ON(!hyp_pgtable);
-
-	return true;
-}
-
 int __create_hyp_mappings(unsigned long start, unsigned long size,
 			  unsigned long phys, enum kvm_pgtable_prot prot)
 {
 	int err;
 
-	if (WARN_ON(!kvm_host_owns_hyp_mappings()))
-		return -EINVAL;
-
 	mutex_lock(&kvm_hyp_pgd_mutex);
-	err = kvm_pgtable_hyp_map(hyp_pgtable, start, size, phys, prot);
+	err = KVM_PGT_CALL(kvm_pgtable_hyp_map, hyp_pgtable, start, size, phys, prot);
 	mutex_unlock(&kvm_hyp_pgd_mutex);
 
 	return err;
@@ -461,138 +437,18 @@ static phys_addr_t kvm_kaddr_to_phys(void *kaddr)
 	}
 }
 
-struct hyp_shared_pfn {
-	u64 pfn;
-	int count;
-	struct rb_node node;
-};
-
-static DEFINE_MUTEX(hyp_shared_pfns_lock);
-static struct rb_root hyp_shared_pfns = RB_ROOT;
-
-static struct hyp_shared_pfn *find_shared_pfn(u64 pfn, struct rb_node ***node,
-					      struct rb_node **parent)
-{
-	struct hyp_shared_pfn *this;
-
-	*node = &hyp_shared_pfns.rb_node;
-	*parent = NULL;
-	while (**node) {
-		this = container_of(**node, struct hyp_shared_pfn, node);
-		*parent = **node;
-		if (this->pfn < pfn)
-			*node = &((**node)->rb_left);
-		else if (this->pfn > pfn)
-			*node = &((**node)->rb_right);
-		else
-			return this;
-	}
-
-	return NULL;
-}
-
-static int share_pfn_hyp(u64 pfn)
-{
-	struct rb_node **node, *parent;
-	struct hyp_shared_pfn *this;
-	int ret = 0;
-
-	mutex_lock(&hyp_shared_pfns_lock);
-	this = find_shared_pfn(pfn, &node, &parent);
-	if (this) {
-		this->count++;
-		goto unlock;
-	}
-
-	this = kzalloc(sizeof(*this), GFP_KERNEL);
-	if (!this) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
-
-	this->pfn = pfn;
-	this->count = 1;
-	rb_link_node(&this->node, parent, node);
-	rb_insert_color(&this->node, &hyp_shared_pfns);
-	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn, 1);
-unlock:
-	mutex_unlock(&hyp_shared_pfns_lock);
-
-	return ret;
-}
-
-static int unshare_pfn_hyp(u64 pfn)
-{
-	struct rb_node **node, *parent;
-	struct hyp_shared_pfn *this;
-	int ret = 0;
-
-	mutex_lock(&hyp_shared_pfns_lock);
-	this = find_shared_pfn(pfn, &node, &parent);
-	if (WARN_ON(!this)) {
-		ret = -ENOENT;
-		goto unlock;
-	}
-
-	this->count--;
-	if (this->count)
-		goto unlock;
-
-	rb_erase(&this->node, &hyp_shared_pfns);
-	kfree(this);
-	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn, 1);
-unlock:
-	mutex_unlock(&hyp_shared_pfns_lock);
-
-	return ret;
-}
-
-int kvm_share_hyp(void *from, void *to)
-{
-	phys_addr_t start, end, cur;
-	u64 pfn;
-	int ret;
-
-	if (is_kernel_in_hyp_mode())
-		return 0;
-
-	/*
-	 * The share hcall maps things in the 'fixed-offset' region of the hyp
-	 * VA space, so we can only share physically contiguous data-structures
-	 * for now.
-	 */
-	if (is_vmalloc_or_module_addr(from) || is_vmalloc_or_module_addr(to))
-		return -EINVAL;
-
-	if (kvm_host_owns_hyp_mappings())
-		return create_hyp_mappings(from, to, PAGE_HYP);
-
-	start = ALIGN_DOWN(__pa(from), PAGE_SIZE);
-	end = PAGE_ALIGN(__pa(to));
-	for (cur = start; cur < end; cur += PAGE_SIZE) {
-		pfn = __phys_to_pfn(cur);
-		ret = share_pfn_hyp(pfn);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
-void kvm_unshare_hyp(void *from, void *to)
+void remove_hyp_mappings(void *from, void *to)
 {
-	phys_addr_t start, end, cur;
-	u64 pfn;
+	unsigned long start = kern_hyp_va((unsigned long)from);
+	unsigned long end = kern_hyp_va((unsigned long)to);
+	unsigned long size = end - start;
 
-	if (is_kernel_in_hyp_mode() || kvm_host_owns_hyp_mappings() || !from)
+	if (!is_protected_kvm_enabled() || !from)
 		return;
 
-	start = ALIGN_DOWN(__pa(from), PAGE_SIZE);
-	end = PAGE_ALIGN(__pa(to));
-	for (cur = start; cur < end; cur += PAGE_SIZE) {
-		pfn = __phys_to_pfn(cur);
-		WARN_ON(unshare_pfn_hyp(pfn));
-	}
+	mutex_lock(&kvm_hyp_pgd_mutex);
+	WARN_ON(KVM_PGT_CALL(kvm_pgtable_hyp_unmap, hyp_pgtable, start, size) != size);
+	mutex_unlock(&kvm_hyp_pgd_mutex);
 }
 
 /**
@@ -615,9 +471,6 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	if (is_kernel_in_hyp_mode())
 		return 0;
 
-	if (!kvm_host_owns_hyp_mappings())
-		return -EPERM;
-
 	start = start & PAGE_MASK;
 	end = PAGE_ALIGN(end);
 
@@ -699,16 +552,6 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
 	unsigned long addr;
 	int ret = 0;
 
-	if (!kvm_host_owns_hyp_mappings()) {
-		addr = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
-					 phys_addr, size, prot);
-		if (IS_ERR_VALUE(addr))
-			return addr;
-		*haddr = addr;
-
-		return 0;
-	}
-
 	size = PAGE_ALIGN(size + offset_in_page(phys_addr));
 	ret = hyp_alloc_private_va_range(size, &addr);
 	if (ret)
@@ -2094,7 +1937,7 @@ int __init kvm_mmu_init(u32 *hyp_va_bits)
 		goto out;
 	}
 
-	err = kvm_pgtable_hyp_init(hyp_pgtable, *hyp_va_bits, &kvm_hyp_mm_ops);
+	err = KVM_PGT_CALL(kvm_pgtable_hyp_init, hyp_pgtable, *hyp_va_bits, &kvm_hyp_mm_ops);
 	if (err)
 		goto out_free_pgtable;
 
@@ -2106,7 +1949,7 @@ int __init kvm_mmu_init(u32 *hyp_va_bits)
 	return 0;
 
 out_destroy_pgtable:
-	kvm_pgtable_hyp_destroy(hyp_pgtable);
+	KVM_PGT_CALL(kvm_pgtable_hyp_destroy, hyp_pgtable);
 out_free_pgtable:
 	kfree(hyp_pgtable);
 	hyp_pgtable = NULL;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 64de20e8001d..f5a02b4039b1 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -270,6 +270,124 @@ static int __init finalize_pkvm(void)
 }
 device_initcall_sync(finalize_pkvm);
 
+struct hyp_shared_page {
+	struct rb_node node;
+	phys_addr_t phys;
+	void *hyp_va;
+	int count;
+};
+static struct rb_root hyp_shared_pages = RB_ROOT;
+
+static struct hyp_shared_page *find_shared_page(void *hyp_va, struct rb_node ***node,
+					       struct rb_node **parent)
+{
+	struct hyp_shared_page *page;
+
+	*node = &hyp_shared_pages.rb_node;
+	*parent = NULL;
+	while (**node) {
+		page = container_of(**node, struct hyp_shared_page, node);
+		*parent = **node;
+		if (page->hyp_va < hyp_va)
+			*node = &((**node)->rb_left);
+		else if (page->hyp_va > hyp_va)
+			*node = &((**node)->rb_right);
+		else
+			return page;
+	}
+
+	return NULL;
+}
+
+int pkvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits, struct kvm_pgtable_mm_ops *mm_ops)
+{
+	if (pgt)
+		return kvm_pgtable_hyp_init(pgt, va_bits, mm_ops);
+	return 0;
+}
+
+void pkvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
+{
+	if (pgt)
+		return kvm_pgtable_hyp_destroy(pgt);
+}
+
+static int share_page_hyp(void *hyp_va, phys_addr_t phys)
+{
+	struct rb_node **node, *parent;
+	struct hyp_shared_page *page;
+
+	page = find_shared_page(hyp_va, &node, &parent);
+	if (page) {
+		page->count++;
+		return 0;
+	}
+
+	page = kzalloc(sizeof(*page), GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+	page->hyp_va = hyp_va;
+	page->phys = phys;
+	page->count = 1;
+	rb_link_node(&page->node, parent, node);
+	rb_insert_color(&page->node, &hyp_shared_pages);
+
+	return kvm_call_hyp_nvhe(__pkvm_host_share_hyp, phys >> PAGE_SHIFT, 1);
+}
+
+int pkvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
+			 enum kvm_pgtable_prot prot)
+{
+	u64 off;
+	int ret;
+
+	if (pgt)
+		return kvm_pgtable_hyp_map(pgt, addr, size, phys, prot);
+
+	addr = ALIGN_DOWN(addr, PAGE_SIZE);
+	phys = ALIGN_DOWN(phys, PAGE_SIZE);
+	size = PAGE_ALIGN(size);
+	if (addr != (u64)kern_hyp_va(__va(phys)))
+		return -EINVAL;
+	if (prot != PAGE_HYP)
+		return -EPERM;
+
+	for (off = 0; off < size; off += PAGE_SIZE) {
+		ret = share_page_hyp((void *)(addr + off), phys + off);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+u64 pkvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	struct rb_node **node, *parent, *next;
+	struct hyp_shared_page *page;
+	u64 pfn, off = 0;
+
+	if (pgt)
+		return kvm_pgtable_hyp_unmap(pgt, addr, size);
+
+	page = find_shared_page((void *)addr, &node, &parent);
+	while (page && ((u64)page->hyp_va == addr + off) && off < size) {
+		next = rb_next(&page->node);
+		page->count--;
+		if (!page->count) {
+			pfn = page->phys >> PAGE_SHIFT;
+			rb_erase(&page->node, &hyp_shared_pages);
+			kfree(page);
+			if (kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn, 1))
+				break;
+		}
+		off += PAGE_SIZE;
+		page = next ? container_of(next, struct hyp_shared_page, node) : NULL;
+	}
+
+	return off;
+}
+
 static int cmp_mappings(struct rb_node *node, const struct rb_node *parent)
 {
 	struct pkvm_mapping *a = rb_entry(node, struct pkvm_mapping, node);
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 470524b31951..e8b3d08e26dd 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -115,7 +115,7 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 	if (!buf)
 		return -ENOMEM;
 
-	ret = kvm_share_hyp(buf, buf + reg_sz);
+	ret = create_hyp_mappings(buf, buf + reg_sz, PAGE_HYP);
 	if (ret) {
 		kfree(buf);
 		return ret;
@@ -154,9 +154,9 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	void *sve_state = vcpu->arch.sve_state;
 
-	kvm_unshare_hyp(vcpu, vcpu + 1);
+	remove_hyp_mappings(vcpu, vcpu + 1);
 	if (sve_state)
-		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
+		remove_hyp_mappings(sve_state, sve_state + vcpu_sve_state_size(vcpu));
 	kfree(sve_state);
 	kfree(vcpu->arch.ccsidr);
 }
-- 
2.47.1.613.gc27f4b7a9f-goog

