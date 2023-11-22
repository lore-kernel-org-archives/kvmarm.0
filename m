Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29CD21361
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 23:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e4pm5gE3"
Date: Wed, 22 Nov 2023 23:35:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700696162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PXyWegmwCnXnOPFvQ6LT5Yd+ik2iCdUmtXvgYfqocuM=;
	b=e4pm5gE3C8oJZdXhVRFH6B7ru6llu+TZOT2vj+rXc1A8XJ/IzaHkbbHIXWc/cKv42uWKbQ
	Lv+4Edhcgo35m59DoNtbxqh6HwTcWq7482blb85/acmgy7R7sBHRgCqBB8AY+KQ44fZcpn
	xOvVYVFoyPrW/OtqEgeifOUQ/uFxH7A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ene <sebastianene@google.com>
Cc: will@kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, catalin.marinas@arm.com,
	mark.rutland@arm.com, akpm@linux-foundation.org, maz@kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com,
	vdonnefort@google.com, qperret@google.com, smostafa@google.com
Subject: Re: [PATCH v3 10/10] arm64: ptdump: Add support for guest stage-2
 pagetables dumping
Message-ID: <ZV6QXSV_SrYjjoE_@linux.dev>
References: <20231115171639.2852644-2-sebastianene@google.com>
 <20231115171639.2852644-12-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231115171639.2852644-12-sebastianene@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 15, 2023 at 05:16:40PM +0000, Sebastian Ene wrote:
> +struct ptdump_registered_guest {
> +	struct list_head		reg_list;
> +	struct ptdump_info		info;
> +	struct kvm_pgtable_snapshot	snapshot;
> +	rwlock_t			*lock;
> +};

Why can't we just store a pointer directly to struct kvm in ::private?
Also, shouldn't you take a reference on struct kvm when the file is
opened to protect against VM teardown?

> +static LIST_HEAD(ptdump_guest_list);
> +static DEFINE_MUTEX(ptdump_list_lock);

What is the list for?

>  static phys_addr_t ptdump_host_pa(void *addr)
>  {
>  	return __pa(addr);
> @@ -757,6 +768,63 @@ static void stage2_ptdump_walk(struct seq_file *s, struct ptdump_info *info)
>  	kvm_pgtable_walk(pgtable, start_ipa, end_ipa, &walker);
>  }
>  
> +static void guest_stage2_ptdump_walk(struct seq_file *s,
> +				     struct ptdump_info *info)
> +{
> +	struct ptdump_info_file_priv *f_priv =
> +		container_of(info, struct ptdump_info_file_priv, info);
> +	struct ptdump_registered_guest *guest = info->priv;
> +
> +	f_priv->file_priv = &guest->snapshot;
> +
> +	read_lock(guest->lock);
> +	stage2_ptdump_walk(s, info);
> +	read_unlock(guest->lock);

Taking the mmu lock for read allows other table walkers to add new
mappings and adjust the granularity of existing ones. Should this
instead take the mmu lock for write?

> +}
> +
> +int ptdump_register_guest_stage2(struct kvm *kvm)
> +{
> +	struct ptdump_registered_guest *guest;
> +	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> +	struct kvm_pgtable *pgt = mmu->pgt;
> +
> +	guest = kzalloc(sizeof(struct ptdump_registered_guest), GFP_KERNEL);

You want GFP_KERNEL_ACCOUNT here.

-- 
Thanks,
Oliver
