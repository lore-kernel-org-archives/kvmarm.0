Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ED73A63FB
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 06:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780639315; cv=none; b=FOAAMLArbvuAV6bYcfheN2TJV2nI4y7RW6DdQN5jM8A7Q1dYwHXMGZ+F3eMjvXwoNiJVkHAigdHCJMvtWfHnX5v4YT/woCscBvKJEwUzWCNmfZ/mWmrB6pVKwtCy7NkKFM+//+6TQ0mokgAcycPSQ+VDoIFEuPXwQ1sb0YpXimo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780639315; c=relaxed/simple;
	bh=ej37GtpqNValOQ5voiE5G798A3PGvFxWMi9LPZSsN4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rv2ISl6N9du8dKfoIre9a0YaSjkeC+37yYs/Lw/XYQ5+9Kphj7urfx8NS1umsZW8TospU/DL+JEC4xpBvDLy0Q5dD9JqxZ3UvmzBy/DzCiKLMW5Cf2EMKVmNnssHESOHAhdsyLEHQl98+iutTCaHQGzVqNRUrdVXiD4lPC2AjKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ewkGhwdX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ewkGhwdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51E01F00893;
	Fri,  5 Jun 2026 06:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780639314;
	bh=mOltCJFAEiXOMn/JouwewzAaDuJLAap1VZFGpCvHcIA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ewkGhwdXA3jXxCUU/ZDD+xelPAyMLHoLodsabcEAwbdwR+baNzCAIcq0KXv9m5DRt
	 Gk4+HDVIIpTnXDWc1cfBMqDZVD3jZa/T/QlgOmJTHPKjeYBowRuwmG86MXPFwMFreY
	 K+FVNdCiNitq+7J9mgYhjt6zEgCIAIWMYATyXTEmdPzZGNauwJ02p7tX/jupEooyDR
	 rJHCSZ5Xayl+TEkTsezpd903WaFRxGLyUiRw1kOAfehkDv7sYuWQtWeApJXqRSoAxz
	 usC4diPpSx8T5WjmvGzhoQvt5ofjR7s8CNpFrogDZ9fhrKqNT03ZgSKbDMcmWxeDpj
	 6S6t0PHSdDEPA==
Date: Thu, 4 Jun 2026 23:01:52 -0700
From: Oliver Upton <oupton@kernel.org>
To: Jackie Liu <liu.yun@linux.dev>
Cc: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
	yuzenghui@huawei.com, will@kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2] KVM/arm64: vgic-its: Make ABI commit helpers return
 void
Message-ID: <aiJmUCvsSt6k4bvd@kernel.org>
References: <20260604075147.53299-1-liu.yun@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604075147.53299-1-liu.yun@linux.dev>

On Thu, Jun 04, 2026 at 03:51:47PM +0800, Jackie Liu wrote:
> From: Jackie Liu <liuyun01@kylinos.cn>
> 
> The return values of vgic_its_set_abi() and vgic_its_commit_v0() are always
> 0 and do not carry useful error information. Simplify by changing them to
> void.
> 
> Suggested-by: Oliver Upton <oupton@kernel.org>
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver

> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 1d7e5d560af4..ca48b34dec20 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -27,7 +27,7 @@ static struct kvm_device_ops kvm_arm_vgic_its_ops;
>  
>  static int vgic_its_save_tables_v0(struct vgic_its *its);
>  static int vgic_its_restore_tables_v0(struct vgic_its *its);
> -static int vgic_its_commit_v0(struct vgic_its *its);
> +static void vgic_its_commit_v0(struct vgic_its *its);
>  static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
>  			     struct kvm_vcpu *filter_vcpu, bool needs_inv);
>  
> @@ -168,7 +168,7 @@ struct vgic_its_abi {
>  	int ite_esz;
>  	int (*save_tables)(struct vgic_its *its);
>  	int (*restore_tables)(struct vgic_its *its);
> -	int (*commit)(struct vgic_its *its);
> +	void (*commit)(struct vgic_its *its);
>  };
>  
>  #define ABI_0_ESZ	8
> @@ -192,13 +192,13 @@ inline const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its)
>  	return &its_table_abi_versions[its->abi_rev];
>  }
>  
> -static int vgic_its_set_abi(struct vgic_its *its, u32 rev)
> +static void vgic_its_set_abi(struct vgic_its *its, u32 rev)
>  {
>  	const struct vgic_its_abi *abi;
>  
>  	its->abi_rev = rev;
>  	abi = vgic_its_get_abi(its);
> -	return abi->commit(its);
> +	abi->commit(its);
>  }
>  
>  /*
> @@ -472,7 +472,8 @@ static int vgic_mmio_uaccess_write_its_iidr(struct kvm *kvm,
>  
>  	if (rev >= NR_ITS_ABIS)
>  		return -EINVAL;
> -	return vgic_its_set_abi(its, rev);
> +	vgic_its_set_abi(its, rev);
> +	return 0;
>  }
>  
>  static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
> @@ -1888,14 +1889,11 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
>  	its->baser_coll_table = INITIAL_BASER_VALUE |
>  		((u64)GITS_BASER_TYPE_COLLECTION << GITS_BASER_TYPE_SHIFT);
>  	dev->kvm->arch.vgic.propbaser = INITIAL_PROPBASER_VALUE;
> -
>  	dev->private = its;
>  
> -	ret = vgic_its_set_abi(its, NR_ITS_ABIS - 1);
> -
> +	vgic_its_set_abi(its, NR_ITS_ABIS - 1);
>  	mutex_unlock(&dev->kvm->arch.config_lock);
> -
> -	return ret;
> +	return 0;
>  }
>  
>  static void vgic_its_destroy(struct kvm_device *kvm_dev)
> @@ -2610,7 +2608,7 @@ static int vgic_its_restore_tables_v0(struct vgic_its *its)
>  	return ret;
>  }
>  
> -static int vgic_its_commit_v0(struct vgic_its *its)
> +static void vgic_its_commit_v0(struct vgic_its *its)
>  {
>  	const struct vgic_its_abi *abi;
>  
> @@ -2623,7 +2621,6 @@ static int vgic_its_commit_v0(struct vgic_its *its)
>  
>  	its->baser_device_table |= (GIC_ENCODE_SZ(abi->dte_esz, 5)
>  					<< GITS_BASER_ENTRY_SIZE_SHIFT);
> -	return 0;
>  }
>  
>  static void vgic_its_reset(struct kvm *kvm, struct vgic_its *its)
> -- 
> 2.54.0
> 
> 
