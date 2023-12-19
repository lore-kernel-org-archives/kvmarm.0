Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFC61A587
	for <kvmarm@lists.linux.dev>; Tue, 19 Dec 2023 11:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TyKVkkha"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-40c32bea30dso47885e9.0
        for <kvmarm@lists.linux.dev>; Tue, 19 Dec 2023 03:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702986358; x=1703591158; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YcdYvkUdUc07HVNjkVvPG6bswzAfzCrn7zyTgGe/v8M=;
        b=TyKVkkhauehFOZx96FfpC/Zw8tgvm7nmVkhBHDGnmIvU3rmZy3/+2ZEUFClH5RdW+H
         o+cziQpxzNlNkaCOt/xn9ALO/fkzdeEIBLDNpjW1UGVuAYIH8BY/Lk50DVv5GNG5tFAd
         rsujbym9raX4ijdI7yXR+6bFDzMTu1h1WP8ooVJfaMwWKsdn+AZHw/K1syEHsY40gKyN
         m52GcvMXNVgjZx6yz++S0yTITowrKj+cSVFVvuRisC2/QgNycrBrxGBsBhllsCElUyAa
         2lElY4C/nmxgGzS+Q+Xi0e44qHLL83ITp7qxzAt1w2UgM2FdMnV30m9nztv+qt1PglGa
         +Y4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702986358; x=1703591158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YcdYvkUdUc07HVNjkVvPG6bswzAfzCrn7zyTgGe/v8M=;
        b=pLI/OJl8QvXXNqcPe/94f+3Prw4BLVzIdbDXys6PnCvgDWS7CJ8jWM0nNOOzel39dv
         qrJDOcFfUf6IEUbvE2LWo1VoFYrhwHqaEJXrcP3witIT0OuScJcC9Ge99pO0r87vTjq/
         mLbPBlxCcfMBg26LT08LOoSCM6YQEVByFGFGFcC/xLmehkJQSYX8ukab3t2/rGiaEvr/
         pLcPAYnq8oE1N2pKlt9C4WH/MnJZyMfIULvSUpfyEKkSDBayyESl+O5rUxdpGgG2jg7n
         8pM0yhiioWHIys4dIi5Sr5oqWiM+tZLwGNoHMwDEdPLVHcTKd/VXlij8jVOTMVxFS7+V
         ybQQ==
X-Gm-Message-State: AOJu0YwOLT2T4R8Qfh/eGDK+tV8Zgrcmjo9++vWnP0QwVQNbQmFoV8+B
	qzNDdR0qGD3kglyK562tP1dEaXu0mU4w
X-Google-Smtp-Source: AGHT+IGWXS5SsQDP3A5fto770wDgm/oet6UOw1Nk2k0AW7Z+DvOY9nLEuzR8ykz7oVqRs2hWFVf+lQ==
X-Received: by 2002:a7b:ce10:0:b0:40d:1976:426 with SMTP id m16-20020a7bce10000000b0040d19760426mr100528wmc.5.1702986357754;
        Tue, 19 Dec 2023 03:45:57 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id v17-20020a5d6111000000b0033660f75d08sm7987367wrt.116.2023.12.19.03.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 03:45:57 -0800 (PST)
Date: Tue, 19 Dec 2023 11:45:55 +0000
From: Sebastian Ene <sebastianene@google.com>
To: will@kernel.org, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, catalin.marinas@arm.com,
	mark.rutland@arm.com, akpm@linux-foundation.org, maz@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com,
	vdonnefort@google.com, qperret@google.com, smostafa@google.com
Subject: Re: [PATCH v4 03/10] KVM: arm64: Invoke the snapshot interface for
 the host stage-2 pagetable
Message-ID: <ZYGCcxhGuXlP4mbY@google.com>
References: <20231218135859.2513568-2-sebastianene@google.com>
 <20231218135859.2513568-5-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218135859.2513568-5-sebastianene@google.com>

On Mon, Dec 18, 2023 at 01:58:53PM +0000, Sebastian Ene wrote:
> Allocate memory for the snapshot by creating a memory cache with empty
> pages that will be used by the hypervisor during the page table copy.
> Get the required size of the PGD and allocate physically contiguous
> memory for it. Allocate contiguous memory for an array that is used to
> keep track of the pages used from the memcache. Call the snapshot
> interface and release the memory for the snapshot.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/ptdump.c | 107 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 107 insertions(+)
> 
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index 5816fc632..e99bab427 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -25,6 +25,9 @@ static int kvm_ptdump_open(struct inode *inode, struct file *file);
>  static int kvm_ptdump_release(struct inode *inode, struct file *file);
>  static int kvm_ptdump_show(struct seq_file *m, void *);
>  
> +static phys_addr_t get_host_pa(void *addr);
> +static void *get_host_va(phys_addr_t pa);
> +
>  static const struct file_operations kvm_ptdump_fops = {
>  	.open		= kvm_ptdump_open,
>  	.read		= seq_read,
> @@ -32,6 +35,11 @@ static const struct file_operations kvm_ptdump_fops = {
>  	.release	= kvm_ptdump_release,
>  };
>  
> +static struct kvm_pgtable_mm_ops ptdump_host_mmops = {
> +	.phys_to_virt	= get_host_va,
> +	.virt_to_phys	= get_host_pa,
> +};
> +
>  static int kvm_ptdump_open(struct inode *inode, struct file *file)
>  {
>  	struct kvm_ptdump_register *reg = inode->i_private;
> @@ -78,11 +86,110 @@ static void kvm_ptdump_debugfs_register(struct kvm_ptdump_register *reg,
>  
>  static struct kvm_ptdump_register host_reg;
>  
> +static size_t host_stage2_get_pgd_len(void)
> +{
> +	u32 phys_shift = get_kvm_ipa_limit();
> +	u64 vtcr = kvm_get_vtcr(read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1),
> +				read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1),
> +				phys_shift);
> +	return (kvm_pgtable_stage2_pgd_size(vtcr) >> PAGE_SHIFT);
> +}
> +
> +static phys_addr_t get_host_pa(void *addr)
> +{
> +	return __pa(addr);
> +}
> +
> +static void *get_host_va(phys_addr_t pa)
> +{
> +	return __va(pa);
> +}
> +
> +static void kvm_host_put_ptdump_info(void *snap)
> +{
> +	void *mc_page;
> +	size_t i;
> +	struct kvm_pgtable_snapshot *snapshot;
> +
> +	if (!snap)
> +		return;
> +
> +	snapshot = snap;
> +	while ((mc_page = pop_hyp_memcache(&snapshot->mc, get_host_va)) != NULL)
> +		free_page((unsigned long)mc_page);
> +
> +	if (snapshot->pgd_hva)
> +		free_pages_exact(snapshot->pgd_hva, snapshot->pgd_pages);
> +
> +	if (snapshot->used_pages_hva) {
> +		for (i = 0; i < snapshot->used_pages_indx; i++) {
> +			mc_page = get_host_va(snapshot->used_pages_hva[i]);
> +			free_page((unsigned long)mc_page);
> +		}
> +
> +		free_pages_exact(snapshot->used_pages_hva, snapshot->num_used_pages);
> +	}
> +
> +	free_page((unsigned long)snapshot);
> +}
> +
> +static void *kvm_host_get_ptdump_info(struct kvm_ptdump_register *reg)
> +{
> +	int i, ret;
> +	void *mc_page;
> +	struct kvm_pgtable_snapshot *snapshot;
> +	size_t memcache_len;
> +
> +	snapshot = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> +	if (!snapshot)
> +		return NULL;
> +
> +	memset(snapshot, 0, sizeof(struct kvm_pgtable_snapshot));
> +
> +	snapshot->pgd_pages = host_stage2_get_pgd_len();
> +	snapshot->pgd_hva = alloc_pages_exact(snapshot->pgd_pages, GFP_KERNEL_ACCOUNT);

The allocation should be specified in the number of bytes here.

> +	if (!snapshot->pgd_hva)
> +		goto err;
> +
> +	memcache_len = (size_t)reg->priv;
> +	for (i = 0; i < memcache_len; i++) {
> +		mc_page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> +		if (!mc_page)
> +			goto err;
> +
> +		push_hyp_memcache(&snapshot->mc, mc_page, get_host_pa);
> +	}
> +
> +	snapshot->num_used_pages = DIV_ROUND_UP(sizeof(phys_addr_t) * memcache_len,
> +					     PAGE_SIZE);
> +	snapshot->used_pages_hva = alloc_pages_exact(snapshot->num_used_pages,
> +						  GFP_KERNEL_ACCOUNT);

the same as previous comment.

> +	if (!snapshot->used_pages_hva)
> +		goto err;
> +
> +	ret = kvm_call_hyp_nvhe(__pkvm_host_stage2_snapshot, snapshot);
> +	if (ret) {
> +		pr_err("ERROR %d snapshot host pagetables\n", ret);
> +		goto err;
> +	}
> +
> +	snapshot->pgtable.pgd = get_host_va((phys_addr_t)snapshot->pgtable.pgd);
> +	snapshot->pgtable.mm_ops = &ptdump_host_mmops;
> +
> +	return snapshot;
> +err:
> +	kvm_host_put_ptdump_info(snapshot);
> +	return NULL;
> +}
> +
>  void kvm_ptdump_register_host(void)
>  {
>  	if (!is_protected_kvm_enabled())
>  		return;
>  
> +	host_reg.get_ptdump_info = kvm_host_get_ptdump_info;
> +	host_reg.put_ptdump_info = kvm_host_put_ptdump_info;
> +
>  	kvm_ptdump_debugfs_register(&host_reg, "host_page_tables",
>  				    kvm_debugfs_dir);
>  }
> -- 
> 2.43.0.472.g3155946c3a-goog
> 
