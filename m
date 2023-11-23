Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB092575A
	for <kvmarm@lists.linux.dev>; Thu, 23 Nov 2023 14:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oVAGiDBX"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-40b35199f94so68835e9.0
        for <kvmarm@lists.linux.dev>; Thu, 23 Nov 2023 06:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700750931; x=1701355731; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Id8FFmZPqAcjX9nM2kv7yhFZ7V91eseH8kTxLchD3kM=;
        b=oVAGiDBXe+tHH5ml8JdAYbjDdfEh4/iB15A/ldMq9zQtznJuoXGT5q79dF0snEjSPR
         luHg61ChWCC8jZKAgwcZZLEW95u/MSPEHIKtWP4afZH+U/LbjV+kpmuq/Yw7oWWO9hSQ
         duTSA7qvx1EC6rdEDTREPxp9YdlIb653/2mBECsXAC0hSzlzTLyF5LKywujAJIOLj1r3
         pGe4cHb3Q3dPqhQ2YxYGf8zj7b1w8TM6PnfjSN6/L71jqNZDbW6Y7zI6a76bvJpqQ72f
         DmokcKiuPM8Ot1RT3HhonzbR3mnZhdwov13O6WS9x05A+AO2lY0bYRsvUWbQI2NIuC5Q
         JSKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700750931; x=1701355731;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Id8FFmZPqAcjX9nM2kv7yhFZ7V91eseH8kTxLchD3kM=;
        b=vvbAQzwmVf8ev+3RNIng5qycs81g+BYJcwB6wVZa6hy6PjkzFfTzI0GRtFiFl8sp5m
         6j21QLDYcwOZ2Gaox3rAKrD+4haPVDgk2LkmhlE6InISrkoHda9uOrCqcyI6G/ezaNzY
         C3De/O1sQwgjrIbQCPFOozfmWyEpnu2aIJROeiOLHIvm8YMGuPpo9ocg8qyHqfL34Etb
         V/4OGng+KknslfbabLtL/uaTvt995LunCptUOXAZGe9tp49w/P9tP7tMfrZERvR4x+9B
         cjxDvttdiUDa9OUXELr2pcB6YeNbTTvDHsSu3FiMyKeU2i7ibfODp87ZmglL+n7i4F2U
         OSiw==
X-Gm-Message-State: AOJu0YyfaC+czkfffFjatTal2agsmmj2Xt1v8kW0+7NJh/ea+5xKBVhg
	SAoYrhnhFQuAycJl209vXsYwcA==
X-Google-Smtp-Source: AGHT+IFCh5xgc0nF4xb2cR9PLPVK5PT5r87gQj8D+vxwP8OMDt4I+IMAbggtwK74+wGLTcgejKtYDg==
X-Received: by 2002:a05:600c:b4f:b0:404:7462:1f87 with SMTP id k15-20020a05600c0b4f00b0040474621f87mr287391wmr.6.1700750931337;
        Thu, 23 Nov 2023 06:48:51 -0800 (PST)
Received: from google.com (110.121.148.146.bc.googleusercontent.com. [146.148.121.110])
        by smtp.gmail.com with ESMTPSA id t4-20020a0560001a4400b003316eb9db40sm1859750wry.51.2023.11.23.06.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Nov 2023 06:48:50 -0800 (PST)
Date: Thu, 23 Nov 2023 14:48:49 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: will@kernel.org, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, catalin.marinas@arm.com,
	mark.rutland@arm.com, akpm@linux-foundation.org, maz@kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com,
	qperret@google.com, smostafa@google.com
Subject: Re: [PATCH v3 06/10] arm64: ptdump: Register a debugfs entry for the
 host stage-2 tables
Message-ID: <ZV9mUbWXr2hlKJI6@google.com>
References: <20231115171639.2852644-2-sebastianene@google.com>
 <20231115171639.2852644-8-sebastianene@google.com>
 <ZVzlRY8Dm9FjGo8i@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVzlRY8Dm9FjGo8i@google.com>

On Tue, Nov 21, 2023 at 05:13:41PM +0000, Vincent Donnefort wrote:
> On Wed, Nov 15, 2023 at 05:16:36PM +0000, Sebastian Ene wrote:

Hi,

> > Initialize a structures used to keep the state of the host stage-2 ptdump
> > walker when pKVM is enabled. Create a new debugfs entry for the host
> > stage-2 pagetables and hook the callbacks invoked when the entry is
> > accessed. When the debugfs file is opened, allocate memory resources which
> > will be shared with the hypervisor for saving the pagetable snapshot.
> > On close release the associated memory and we unshare it from the
> > hypervisor.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/include/asm/ptdump.h |  12 +++
> >  arch/arm64/kvm/Kconfig          |  13 +++
> >  arch/arm64/kvm/arm.c            |   2 +
> >  arch/arm64/mm/ptdump.c          | 168 ++++++++++++++++++++++++++++++++
> >  arch/arm64/mm/ptdump_debugfs.c  |   8 +-
> >  5 files changed, 202 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
> > index 9b2bebfcefbe..de5a5a0c0ecf 100644
> > --- a/arch/arm64/include/asm/ptdump.h
> > +++ b/arch/arm64/include/asm/ptdump.h
> > @@ -22,6 +22,7 @@ struct ptdump_info {
> >  	void (*ptdump_walk)(struct seq_file *s, struct ptdump_info *info);
> >  	int (*ptdump_prepare_walk)(void *file_priv);
> >  	void (*ptdump_end_walk)(void *file_priv);
> > +	size_t				mc_len;
> >  };
> >  
> >  void ptdump_walk(struct seq_file *s, struct ptdump_info *info);
> > @@ -33,13 +34,24 @@ struct ptdump_info_file_priv {
> >  #ifdef CONFIG_PTDUMP_DEBUGFS
> >  #define EFI_RUNTIME_MAP_END	DEFAULT_MAP_WINDOW_64
> >  void __init ptdump_debugfs_register(struct ptdump_info *info, const char *name);
> > +void ptdump_debugfs_kvm_register(struct ptdump_info *info, const char *name,
> > +				 struct dentry *d_entry);
> >  #else
> >  static inline void ptdump_debugfs_register(struct ptdump_info *info,
> >  					   const char *name) { }
> > +static inline void ptdump_debugfs_kvm_register(struct ptdump_info *info,
> > +					       const char *name,
> > +					       struct dentry *d_entry) { }
> >  #endif
> >  void ptdump_check_wx(void);
> >  #endif /* CONFIG_PTDUMP_CORE */
> >  
> > +#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
> > +void ptdump_register_host_stage2(void);
> > +#else
> > +static inline void ptdump_register_host_stage2(void) { }
> > +#endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
> > +
> >  #ifdef CONFIG_DEBUG_WX
> >  #define debug_checkwx()	ptdump_check_wx()
> >  #else
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 83c1e09be42e..cf5b7f06b152 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -71,4 +71,17 @@ config PROTECTED_NVHE_STACKTRACE
> >  
> >  	  If unsure, or not using protected nVHE (pKVM), say N.
> >  
> > +config PTDUMP_STAGE2_DEBUGFS
> > +	bool "Present the stage-2 pagetables to debugfs"
> > +	depends on NVHE_EL2_DEBUG && PTDUMP_DEBUGFS && KVM
> > +	default n
> > +	help
> > +	  Say Y here if you want to show the stage-2 kernel pagetables
> > +	  layout in a debugfs file. This information is only useful for kernel developers
> > +	  who are working in architecture specific areas of the kernel.
> > +	  It is probably not a good idea to enable this feature in a production
> > +	  kernel.
> > +
> > +	  If in doubt, say N.
> > +
> >  endif # VIRTUALIZATION
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index e5f75f1f1085..987683650576 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -28,6 +28,7 @@
> >  
> >  #include <linux/uaccess.h>
> >  #include <asm/ptrace.h>
> > +#include <asm/ptdump.h>
> >  #include <asm/mman.h>
> >  #include <asm/tlbflush.h>
> >  #include <asm/cacheflush.h>
> > @@ -2592,6 +2593,7 @@ static __init int kvm_arm_init(void)
> >  	if (err)
> >  		goto out_subs;
> >  
> > +	ptdump_register_host_stage2();
> >  	kvm_arm_initialised = true;
> >  
> >  	return 0;
> > diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
> > index d531e24ea0b2..0b4cb54e43ff 100644
> > --- a/arch/arm64/mm/ptdump.c
> > +++ b/arch/arm64/mm/ptdump.c
> > @@ -24,6 +24,9 @@
> >  #include <asm/memory.h>
> >  #include <asm/pgtable-hwdef.h>
> >  #include <asm/ptdump.h>
> > +#include <asm/kvm_pkvm.h>
> > +#include <asm/kvm_pgtable.h>
> > +#include <asm/kvm_host.h>
> >  
> >  
> >  enum address_markers_idx {
> > @@ -378,6 +381,170 @@ void ptdump_check_wx(void)
> >  		pr_info("Checked W+X mappings: passed, no W+X pages found\n");
> >  }
> >  
> > +#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
> > +static struct ptdump_info stage2_kernel_ptdump_info;
> > +
> > +static phys_addr_t ptdump_host_pa(void *addr)
> > +{
> > +	return __pa(addr);
> > +}
> > +
> > +static void *ptdump_host_va(phys_addr_t phys)
> > +{
> > +	return __va(phys);
> > +}
> > +
> > +static size_t stage2_get_pgd_len(void)
> > +{
> > +	u64 mmfr0, mmfr1, vtcr;
> > +	u32 phys_shift = get_kvm_ipa_limit();
> > +
> > +	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
> > +	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > +	vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
> > +
> > +	return kvm_pgtable_stage2_pgd_size(vtcr);
> 
> That's a lot of conversions to go from the kvm_ipa_limit to VTCR and
> VTCR back to ia_bits and the start level, but that would mean rewrite pieces of
> pgtable.c there. :-\
> 

Right, I think with Oliver's suggestion we will no longer have to move
these bits around and the code will be self contained under /kvm.

> > +}
> > +
> > +static int stage2_ptdump_prepare_walk(void *file_priv)
> > +{
> > +	struct ptdump_info_file_priv *f_priv = file_priv;
> > +	struct ptdump_info *info = &f_priv->info;
> > +	struct kvm_pgtable_snapshot *snapshot;
> > +	int ret, pgd_index, mc_index, pgd_pages_sz;
> > +	void *page_hva;
> > +	phys_addr_t pgd;
> > +
> > +	snapshot = alloc_pages_exact(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
> > +	if (!snapshot)
> > +		return -ENOMEM;
> 
> For a single page, __get_free_page is enough.
> 

I can use this, thanks.

> > +
> > +	memset(snapshot, 0, PAGE_SIZE);
> > +	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, virt_to_pfn(snapshot));
> > +	if (ret)
> > +		goto free_snapshot;
> 
> It'd probably be better to not share anything here, and let the hypervisor do
> host_donate_hyp() and hyp_donate_host() before returning back from the HVC. This
> way the hypervisor will protect itself.
> 

Right, as we took this discussion offline, I will update this and use
the *donate* API.

> > +
> > +	snapshot->pgd_len = stage2_get_pgd_len();
> > +	pgd_pages_sz = snapshot->pgd_len / PAGE_SIZE;
> > +	snapshot->pgd_hva = alloc_pages_exact(snapshot->pgd_len,
> > +					      GFP_KERNEL_ACCOUNT);
> > +	if (!snapshot->pgd_hva) {
> > +		ret = -ENOMEM;
> > +		goto unshare_snapshot;
> > +	}
> > +
> > +	for (pgd_index = 0; pgd_index < pgd_pages_sz; pgd_index++) {
> > +		page_hva = snapshot->pgd_hva + pgd_index * PAGE_SIZE;
> > +		ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp,
> > +					virt_to_pfn(page_hva));
> > +		if (ret)
> > +			goto unshare_pgd_pages;
> > +	}
> > +
> > +	for (mc_index = 0; mc_index < info->mc_len; mc_index++) {
> > +		page_hva = alloc_pages_exact(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
> 
> ditto.
> 

Ack.

> > +		if (!page_hva) {
> > +			ret = -ENOMEM;
> > +			goto free_memcache_pages;
> > +		}
> > +
> > +		push_hyp_memcache(&snapshot->mc, page_hva, ptdump_host_pa);
> > +		ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp,
> > +					virt_to_pfn(page_hva));
> > +		if (ret) {
> > +			pop_hyp_memcache(&snapshot->mc, ptdump_host_va);
> > +			free_pages_exact(page_hva, PAGE_SIZE);
> > +			goto free_memcache_pages;
> > +		}
> 
> Maybe for the page-table pages, it'd be better to let the hyp does the
> host_donate_hyp() / hyp_donate_host()? It might be easier than sharing + pin.
> 
> > +	}
> > +
> > +	ret = kvm_call_hyp_nvhe(__pkvm_copy_host_stage2, snapshot);
> > +	if (ret)
> > +		goto free_memcache_pages;
> > +
> > +	pgd = (phys_addr_t)snapshot->pgtable.pgd;
> > +	snapshot->pgtable.pgd = phys_to_virt(pgd);
> > +	f_priv->file_priv = snapshot;
> > +	return 0;
> > +
> > +free_memcache_pages:
> > +	page_hva = pop_hyp_memcache(&snapshot->mc, ptdump_host_va);
> > +	while (page_hva) {
> > +		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp,
> > +					virt_to_pfn(page_hva));
> > +		WARN_ON(ret);
> > +		free_pages_exact(page_hva, PAGE_SIZE);
> > +		page_hva = pop_hyp_memcache(&snapshot->mc, ptdump_host_va);
> > +	}
> > +unshare_pgd_pages:
> > +	pgd_index = pgd_index - 1;
> > +	for (; pgd_index >= 0; pgd_index--) {
> > +		page_hva = snapshot->pgd_hva + pgd_index * PAGE_SIZE;
> > +		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp,
> > +					virt_to_pfn(page_hva));
> > +		WARN_ON(ret);
> > +	}
> > +	free_pages_exact(snapshot->pgd_hva, snapshot->pgd_len);
> > +unshare_snapshot:
> > +	WARN_ON(kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp,
> > +				  virt_to_pfn(snapshot)));
> > +free_snapshot:
> > +	free_pages_exact(snapshot, PAGE_SIZE);
> > +	f_priv->file_priv = NULL;
> > +	return ret;
> 
> Couldn't this path be merged with stage2_ptdump_end_walk()?
> 

I think it should be doable.

> > +}
> > +
> > +static void stage2_ptdump_end_walk(void *file_priv)
> > +{
> > +	struct ptdump_info_file_priv *f_priv = file_priv;
> > +	struct kvm_pgtable_snapshot *snapshot = f_priv->file_priv;
> > +	void *page_hva;
> > +	int pgd_index, ret, pgd_pages_sz;
> > +
> > +	if (!snapshot)
> > +		return;
> > +
> > +	page_hva = pop_hyp_memcache(&snapshot->mc, ptdump_host_va);
> > +	while (page_hva) {
> > +		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp,
> > +					virt_to_pfn(page_hva));
> > +		WARN_ON(ret);
> > +		free_pages_exact(page_hva, PAGE_SIZE);
> > +		page_hva = pop_hyp_memcache(&snapshot->mc, ptdump_host_va);
> > +	}
> > +
> > +	pgd_pages_sz = snapshot->pgd_len / PAGE_SIZE;
> > +	for (pgd_index = 0; pgd_index < pgd_pages_sz; pgd_index++) {
> > +		page_hva = snapshot->pgd_hva + pgd_index * PAGE_SIZE;
> > +		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp,
> > +					virt_to_pfn(page_hva));
> > +		WARN_ON(ret);
> > +	}
> > +
> > +	free_pages_exact(snapshot->pgd_hva, snapshot->pgd_len);
> > +	WARN_ON(kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp,
> > +				  virt_to_pfn(snapshot)));
> > +	free_pages_exact(snapshot, PAGE_SIZE);
> > +	f_priv->file_priv = NULL;
> > +}
> > +
> > +void ptdump_register_host_stage2(void)
> > +{
> > +	if (!is_protected_kvm_enabled())
> > +		return;
> > +
> > +	stage2_kernel_ptdump_info = (struct ptdump_info) {
> > +		.mc_len			= host_s2_pgtable_pages(),
> > +		.ptdump_prepare_walk	= stage2_ptdump_prepare_walk,
> > +		.ptdump_end_walk	= stage2_ptdump_end_walk,
> > +	};
> > +
> > +	ptdump_debugfs_kvm_register(&stage2_kernel_ptdump_info,
> > +				    "host_stage2_page_tables",
> > +				    kvm_debugfs_dir);
> > +}
> > +#endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
> > +
> >  static int __init ptdump_init(void)
> >  {
> >  	address_markers[PAGE_END_NR].start_address = PAGE_END;
> > @@ -386,6 +553,7 @@ static int __init ptdump_init(void)
> >  #endif
> >  	ptdump_initialize();
> >  	ptdump_debugfs_register(&kernel_ptdump_info, "kernel_page_tables");
> > +
> 
> Not needed.
> 

Will remove this, checkpatch didn't seem to complain about it.

> >  	return 0;
> >  }
> >  device_initcall(ptdump_init);
> > diff --git a/arch/arm64/mm/ptdump_debugfs.c b/arch/arm64/mm/ptdump_debugfs.c
> > index 3bf5de51e8c3..4821dbef784c 100644
> > --- a/arch/arm64/mm/ptdump_debugfs.c
> > +++ b/arch/arm64/mm/ptdump_debugfs.c
> > @@ -68,5 +68,11 @@ static const struct file_operations ptdump_fops = {
> >  
> >  void __init ptdump_debugfs_register(struct ptdump_info *info, const char *name)
> >  {
> > -	debugfs_create_file(name, 0400, NULL, info, &ptdump_fops);
> > +	ptdump_debugfs_kvm_register(info, name, NULL);
> 
> Not really related to kvm, the only difference is passing or not a dentry.
> 
> How about a single (non __init) function?
> 

I don't think it works because you have to keep the signature of the
original function. This 'ptdump_debugfs_register' is also called from the
non-arch drivers code.

> > +}
> > +
> > +void ptdump_debugfs_kvm_register(struct ptdump_info *info, const char *name,
> > +				 struct dentry *d_entry)
> > +{
> > +	debugfs_create_file(name, 0400, d_entry, info, &ptdump_fops);
> >  }
> > -- 
> > 2.43.0.rc0.421.g78406f8d94-goog
> > 
