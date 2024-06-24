Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6168019EEBF
	for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 19:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719256951; cv=none; b=b/P/9X5obb+NssjF74J+OP87H2BsJMg7bB9d3WXE54CEeUiyOd6QWYf3YEppHsfe5Q7zkYLjQ32qAGXv2qxzmPVJ0zgsnzlHtiBMAmVh4pUxjI8mlUH3oXzrJSwDimQPRbPWyf8cDALZwFseqrsSpZFsTE5PFWOvAsVlE+r8KWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719256951; c=relaxed/simple;
	bh=5x4r/zXOVwVJe4QtQtfVyBQGuOPauWKN0AubbyhcIC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fFGmvY7OQ1rVFZ+VfMJ23m5HHpnCckr1ERImIRObtVpdFWZ6nZf22meDksFrWGrXYoVFSjWWZ/2pbpObt1ICrBA28aWAdvflIAglGNyWfmY1fRAM6r9emrSHss+/Ri4VX/eoyByTBCIeMteziMMvSWMgC4HH1xpKjIMXfn7QrI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QXkgqDbh; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QXkgqDbh"
X-Envelope-To: shameerali.kolothum.thodi@huawei.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719256947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Iz/SvvFKosNQtePNUPQ7Yw5Xgp3helNlx/07uL+eC2A=;
	b=QXkgqDbhnEo+AB6ddh5OBYnCQiizcNcAwTOFbkQjzNYBfjK4dn9dti9Uh/J+Jb/Kf/GFD6
	MpS+MNzFxueY4OFnnK3dIV5f9agAexO4JwsqHZjo8CYflZ+lel6z/ZC9oWUvEmMfpQUtWz
	S5XE9LUNEAhnNtmlbH0zNcbv7BbIOHk=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: iommu@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linuxarm@huawei.com
X-Envelope-To: kevin.tian@intel.com
X-Envelope-To: jgg@ziepe.ca
X-Envelope-To: alex.williamson@redhat.com
X-Envelope-To: maz@kernel.org
X-Envelope-To: will@kernel.org
X-Envelope-To: robin.murphy@arm.com
X-Envelope-To: jean-philippe@linaro.org
X-Envelope-To: jonathan.cameron@huawei.com
Date: Mon, 24 Jun 2024 12:22:20 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com,
	kevin.tian@intel.com, jgg@ziepe.ca, alex.williamson@redhat.com,
	maz@kernel.org, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, jonathan.cameron@huawei.com
Subject: Re: [RFC PATCH v2 2/7] KVM: arm64: Introduce support to pin VMIDs
Message-ID: <ZnnHbM0p8amCqkeJ@linux.dev>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-3-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240208151837.35068-3-shameerali.kolothum.thodi@huawei.com>
X-Migadu-Flow: FLOW_OUT

Hi Shameer,

On Thu, Feb 08, 2024 at 03:18:32PM +0000, Shameer Kolothum wrote:

[...]

> +unsigned long kvm_arm_pinned_vmid_get(struct kvm_vmid *kvm_vmid)
> +{
> +	unsigned long flags;
> +	u64 vmid;
> +
> +	if (!pinned_vmid_map)
> +		return 0;

Like I'd mentioned over in the other thread, returning 0 for error
conditions is rather confusing unless one is staring at the VMID
allocator code.

Can you rework this to return an actual error (e.g. -EINVAL) on failure?

> +	raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
> +
> +	vmid = atomic64_read(&kvm_vmid->id);
> +
> +	if (refcount_inc_not_zero(&kvm_vmid->pinned))
> +		goto out_unlock;
> +
> +	if (nr_pinned_vmids >= max_pinned_vmids) {
> +		vmid = 0;
> +		goto out_unlock;
> +	}

You need to decrement the refcount in this error path.

> +
> +	/*
> +	 * If we went through one or more rollover since that VMID was
> +	 * used, make sure it is still valid, or generate a new one.
> +	 */
> +	if (!vmid_gen_match(vmid))
> +		vmid = new_vmid(kvm_vmid);
> +
> +	nr_pinned_vmids++;
> +	__set_bit(vmid2idx(vmid), pinned_vmid_map);
> +	refcount_set(&kvm_vmid->pinned, 1);
> +
> +out_unlock:
> +	raw_spin_unlock_irqrestore(&cpu_vmid_lock, flags);
> +
> +	vmid &= ~VMID_MASK;
> +
> +	return vmid;
> +}
> +
> +void kvm_arm_pinned_vmid_put(struct kvm_vmid *kvm_vmid)
> +{
> +	unsigned long flags;
> +	u64 vmid = atomic64_read(&kvm_vmid->id);
> +
> +	if (!pinned_vmid_map)
> +		return;
> +
> +	raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
> +
> +	if (refcount_dec_and_test(&kvm_vmid->pinned)) {
> +		__clear_bit(vmid2idx(vmid), pinned_vmid_map);
> +		nr_pinned_vmids--;
> +	}
> +
> +	raw_spin_unlock_irqrestore(&cpu_vmid_lock, flags);
> +}
> +
>  /*
>   * Initialize the VMID allocator
>   */
> @@ -191,10 +263,20 @@ int __init kvm_arm_vmid_alloc_init(void)
>  	if (!vmid_map)
>  		return -ENOMEM;
>  
> +	pinned_vmid_map = bitmap_zalloc(NUM_USER_VMIDS, GFP_KERNEL);
> +	nr_pinned_vmids = 0;
> +
> +	/*
> +	 * Ensure we have at least one emty slot available after rollover

typo: empty

-- 
Thanks,
Oliver
