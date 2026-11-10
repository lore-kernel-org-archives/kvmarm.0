Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794302438;
	b=XyUFkjsXwn5/fvhWAuJIFOSsXPjfm+F4PRLB8aWhM48L+n50zUu6p9szurQPFk5BrVdI
	 vSIUx7ejwsVDQ+Ae/Itje4K8ErvIP59bjB0JGUfhCB2b3vun+bzyRo01qQlRHg/IczPip
	 cad/pbxDh4+ecMvYHOzY+/g9REr6oEKsKqtwROAos8SnLNEZBrGihb8NA9YZqax56it4l
	 HWSlDulL6hL4vssUw6lkHaj5lMmd49aJc89zo4ia1Tuo7EeO5y5xjn0dd9/obld0I74C8
	 NU9X3g+wNIm+nJqB+Pt4UV0i6bvU0WVmeTutGjYeC4hrzoo3WWG8z+3jZzkRrLwAN8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794302438;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=z1EiYiesShrPXkvDVgUvtrE7Nbx28aPk1xRDvgjsVXE=;
	b=E+kNJKRslMpPVdvqZN23BcxG/td2g8EleKJFdu6BB+pqoIOj5gpun8nlAeO8snVDZCZn
	 FSLh1Lh4NZVvqcb/WRqEVRq2iQ7hjIS7oRmRqICRpegLNbKFtG6Mq7lCArOh3tfdD2msk
	 /TJ9OD79xEKLkhk8aw08JJ39k1NWOgSyM6hTuo/xCJwoFDGSRHPolBzY6FMf5E07Ke2HQ
	 tVRKf8HpVDY2fpQqMppajyhLyI1GI2NojwJlWHAxg+YG6vzftQUeAxbKYr1ub3evzGRwN
	 /ewRD0Ff4B6FZ4Wb4hNSwlp0EXU9P6qEPuTXVTyQ0y9O2VzLYy2ffVpVL/uQgVp7RCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=c4AipAvd;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1571607E061
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 09:20:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1571607E061
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=c4AipAvd
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4afe2d546f9so24290345e9.3
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 01:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794302436; x=1794907236; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z1EiYiesShrPXkvDVgUvtrE7Nbx28aPk1xRDvgjsVXE=;
        b=c4AipAvdLyJ2G4xzeujvWxmwdsqtrc2wb7kCesG77VqA5CIpvTkhBgbOF2F5ddlcmb
         bpD3/OFySjk0RJiR2Vqz8hIIkUx1vtSSP/87PDQKSaegSKYfLA6BJ40yyQbfcxoeNqdf
         RwcYKobmnKNcucJ9sJBBfWXJJkQi4fb28nuzyeSCj4v9gJYEt9owR9k9dR4Ep87Hf5SQ
         bEGpF6b/85rA5OUowEhW8HghReLuivM/f0I76+3/UNe7fCJ8kj2DlsRCx/XzSEhQWKP5
         9QaEpVfVzhBrBedhHrENRUOyk4vYF4KcJSeI3r5Fl0n/uHjGSCcNG69HQ1MyC9xAfmDL
         YR1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794302436; x=1794907236;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z1EiYiesShrPXkvDVgUvtrE7Nbx28aPk1xRDvgjsVXE=;
        b=rzbXi2ylW3Dhc7Lbtzj9fu9VlOCfyG5glBlFCq1ngrGlTdIhMcLqJ3mKLpAjM3q3R4
         dOqHKmTeaYwqgEpnYnndVG53PaRTCb0AOOjC8NJgg7CokX6wsLowUbQUouDLvKdj9o8m
         v0+Oe9SlT/312fwxAuSwTOo9PR4GSY9kvmkvEiNfVLVlHpROWuDaw1t9FwzDokJpzdzL
         FUYANihbvN9GZEqXeVWnGte4NZsys+3OQV/fK2awuksFh+6qIlkXZ7XKmmqaDHdorAmO
         AQYx5tyVXAUqPFovHIuOe1TCeTie+MKTy0k/QEH8IRIjU4vvlQ0FftRk+IzbhYo4fgmD
         DB+w==
X-Forwarded-Encrypted: i=1; AL+hErH3WuEpP1LndfCqpwiVPCAJJ68WZQO52pYJqKUNb2bYoTv1AKckkbnmHg5IHigei3XkUo5a7wM=@lists.linux.dev
X-Gm-Message-State: APuU4Z82Ksvhon2G1R8ll5a+zFwYx/mq9RMDrslZsEghNc5kNImNxpfu
	HmAddrTv6k7WE+ElU/RQJm69zDH6mseKqQjR3ep5ZKm8E5dcLvyc3vCtdUxoJcjoWg==
X-Gm-Gg: AYBFou0DcBv30JMRTRRHD4LU1gEIyXg72CVg3+Pnd0zmKr3nqOuLrOUxpRXVmxquYBF
	za91EwTa4bAPhU7iNb2ent/QDp4OHcy9LZQ8VeZqKcSRkMzZKoHhTfAuFEfFXSV7USo6UwsYFT5
	PqHZV0wN/RCgc3FEqjq8CoRjlZ72KCWGPbuAb+M6QUTLfE6dChwoBwir3xiBdMi89dG4bGo0Kxe
	KLOFVR9O04B2jpjsgdV6oweUNRyhO+Ve+QFVOVbR0i2qUEBNjw+IY8FrGtiW+yL/b5ip3X/Z8DN
	9Lcl0g+0/kwXsImZX1V8gcVZ0aLFNbFQuPlkihvcgzhG7kPci1haaH3XFsQ9uQy29iZwCdNJmC1
	17FBE56zV6/+k0ZUfXIx9uW5G6msSBhgPPoHbEVIi+Hj42cCMKnbMTGqN1P5xaHWVxEE2BxRRUh
	QRFDFotVX1mzukf4Oicdh1FT0rP6fJAKukrSed7Gq0qsynwq7aXidZVEs8WB2m1mOtCRzDuNpvu
	Wh0tCRDySeT09/2w8dkTe3yZx7owbjb9g2lL1MuBQF8LA/JxN2GU151tuNwmrBe9L92xBPqPYq1
	XXS6qRlEbiJGXjSA1ZXwVajetBIrmTb+4AIEChB375H7A66CVVh2s4z10Ej7fioVvA==
X-Received: by 2002:a05:600c:6990:b0:4a1:777b:8a12 with SMTP id 5b1f17b1804b1-4ba0233e86cmr29624555e9.14.1794302435405;
        Tue, 10 Nov 2026 01:20:35 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba01fef675sm50469705e9.14.2026.11.10.01.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 01:20:34 -0800 (PST)
Date: Tue, 10 Nov 2026 09:20:31 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: xuheng@cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: arm64: Don't replace a valid hyp block mapping
 with a table
Message-ID: <avLh32oF-TnQrxtz@google.com>
References: <20261109-hyp-block-map-v3-1-bd70e67eb0bf@cs.columbia.edu>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109-hyp-block-map-v3-1-bd70e67eb0bf@cs.columbia.edu>

On Mon, Nov 09, 2026 at 10:13:35PM +0000, Xuheng Li via B4 Relay wrote:
> From: Xuheng Li <xuheng@cs.columbia.edu>
> 
> When kvm_pgtable_hyp_map() is asked to map part of a range that a valid
> block mapping already covers, hyp_map_walker_try_leaf() declines, as the
> request cannot be a leaf at the block's level.  hyp_map_walker() then
> allocates a zeroed table and stores it over the valid block entry.  The
> walk descends into the new table and maps the requested pages, but the
> rest of the block is now unmapped, and the valid block was replaced
> without break-before-make.
> 
> No in-tree caller maps into an existing hyp block mapping today, so this
> cannot be triggered in mainline.  Fail such a request with -EEXIST
> instead, so that a future caller gets an error rather than silently
> losing the rest of the block.
> 
> The same check now catches a conflicting remap of an existing leaf, so
> drop the WARN_ON() from hyp_map_walker_try_leaf(): every caller checks
> the error, and a WARN is fatal at EL2.  Do the check before the
> last-level WARN_ON(), which is kept for internal errors, and update the
> kernel-doc of kvm_pgtable_hyp_map() to match.
> 
> Signed-off-by: Xuheng Li <xuheng@cs.columbia.edu>
> ---

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> This is patch 3/3 of v2, sent alone: 1/3 is superseded by Mostafa's
> "KVM: arm64: Use consistent type for pool size" [1], and 2/3 is dropped.
> 
> With the WARN_ON() gone from hyp_map_walker_try_leaf(), a conflicting
> remap through the EL1 path (__create_hyp_mappings()) also returns
> -EEXIST without a warning, where it used to warn and return -EINVAL.
> 
> [1] https://lore.kernel.org/r/20261106172750.2678873-1-smostafa@google.com
> ---
> Changes in v3:
> - Drop the WARN_ON() from the new check and from
>   hyp_map_walker_try_leaf(), and update the kernel-doc of
>   kvm_pgtable_hyp_map() (Vincent, Fuad).
> - Do the check before the last-level WARN_ON(), so that a conflicting
>   page-level mapping returns -EEXIST instead of reaching it.
> - Link to v2: https://lore.kernel.org/r/20261105-hyp-pool-and-map-v2-3-44a6ca90190b@cs.columbia.edu
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  2 +-
>  arch/arm64/kvm/hyp/pgtable.c         | 10 +++++++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 1c9c57cd6..6d6ed8596 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -508,7 +508,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt);
>   * If device attributes are not explicitly requested in @prot, then the
>   * mapping will be normal, cacheable. Attempts to install a new mapping
>   * for a virtual address that is already mapped will be rejected with an
> - * error and a WARN().
> + * error.
>   *
>   * Return: 0 on success, negative error code on failure.
>   */
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 9c83837b1..94a59f29a 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -414,7 +414,7 @@ static bool hyp_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  		return true;
>  	if (!kvm_pte_valid(ctx->old))
>  		ctx->mm_ops->get_page(ctx->ptep);
> -	else if (WARN_ON((ctx->old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW))
> +	else if ((ctx->old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW)
>  		return false;
>  
>  	smp_store_release(ctx->ptep, new);
> @@ -431,6 +431,14 @@ static int hyp_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  	if (hyp_map_walker_try_leaf(ctx, data))
>  		return 0;
>  
> +	/*
> +	 * A valid entry here is a leaf that conflicts with the request.
> +	 * Replacing a block with a table would need break-before-make, and
> +	 * would leave the rest of the block unmapped.
> +	 */
> +	if (kvm_pte_valid(ctx->old))
> +		return -EEXIST;
> +
>  	if (WARN_ON(ctx->level == KVM_PGTABLE_LAST_LEVEL))
>  		return -EINVAL;
>  
> 
> ---
> base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
> change-id: 20261109-hyp-block-map-0c19f8e9424b
> 
> Best regards,
> -- 
> Xuheng Li <xuheng@cs.columbia.edu>
> 
> 

-- 
Vincent
