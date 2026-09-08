Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBC64CA79E
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 10:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788862690; cv=none; b=rSEIaRvRfvXkoctvHVg/YQ61cKnReVZfaKneyX+/N/vRDzyumsLj4mPtIuNSB7RFabnSgcXDhPTGSzlAMWqn8kTrEjwHSE/kgreeUnP57uWq5BUoSXibOsa6/LPgfIVRs+BY12I+ZRZCJWQ7DaC6Pn+IclGFz677QLKDTBQ+tYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788862690; c=relaxed/simple;
	bh=gH8GKTLeIWw+FBKSnSfe/oVFYPKpCgD1sKzliWltZdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mho3gWf955Bwu6UY4iuzgDC43ks8VDq/C+dxP0KKNSi1R+wIE3EYaFH8elHGAXjiN2O4jr/76a61fnhdRZyFyVxF5ISXd1ntkQAJCHfeZYpSbZPEXRiY3QNrJl/PDXAE1Om6ynnDEWrBsTR47D8mmp4c2T3ojp/0Fhje3i2eeeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FCptYRkc; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FCptYRkc"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a18840e2abso5948031a12.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Sep 2026 03:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788862686; x=1789467486; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vX3UV4IiPZoSn1HS5bXJ5ASbfLJY6NAq1a0CpQiDt3g=;
        b=FCptYRkcQDCc4/NZX+h75SIZAOoM21HMZqMmeqewOc4eGlM6r082DNz/LOEJqiVJtX
         qgPodyh7G0UEuqApbnSHNzKcg4fLBI8ZUjKjV+9wgNgvs7GC8MrJatMU1s/MUsvYRl4Q
         gqvNpglj8jADeRnDVkIoAkwz7WzrC1bugbyM3sQTAls5MdSgVdB++/lQBFOmKAG1aYO3
         xGpExAqQ+ATfzp0ZlzzBS9YpO3HWOK/G5MvPcYlkehtFYdZTdqulqkj5TUpcXorLND+S
         KVOyTizsEoAf2cBVJ71Ln67X74rL1QvlqnCyzlVJmLGwaUEHDl8Yw4VeHaiVfRzqvSFH
         mHjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788862686; x=1789467486;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vX3UV4IiPZoSn1HS5bXJ5ASbfLJY6NAq1a0CpQiDt3g=;
        b=Dx6nMVBtIqc7xnamLUA+Kif3XwnGkVsxS/qO5xb8CviQP4opQe2eUSZmZFk5S908Mj
         r5pDdcNOGdSkT2qs+kcynHOLxCygeeNj0oyEvJpS2bV+S1PAH/CYXNOgvHaS9aG8aYhX
         RaVeDBZRZe/nniJ2Sge8r+SfZmQ/WtbfCpl1u23OxGENaOWozqsyXOJ/5wjOONUJIJSC
         lj/5nmQV2GVmaQRqQYysekgDnGwgIeGL/f/VF1ogaWkNcvk0aYOLqgSDi0ijhg2yxWiW
         PQIvTQpT86oOfo+9DjctYMtfh2Xotyy1kofLs+0g6ugewjcVZYeBnQ2hXnUe3M8TgnsH
         65Vg==
X-Forwarded-Encrypted: i=1; AKwUvBzQSWKt1Q94au9ncevKa6/+bUQPry3fEoSpQNHY3NuhRPvMnlMyhrscNLGP4m7PhM5n5Da2VwY=@lists.linux.dev
X-Gm-Message-State: AFuF++nt2sPpaVlZVXCayGyQ5jb7caiTtcB/WMUrJJJu6DVqIHjDjJ/n
	jxDuNp1pblNyg0G9iZgyZrECtTwkx+Blal0mOs1JNubRyJeA8PRTixC2pYDoLw0HZA==
X-Gm-Gg: AYBFou3RweMK46DWYXPNzepH24GTbbCAzL75QjMjrRDVtZiJmq4/wvwcRHersrdwWoL
	rSgbCcEE2NxgX7RaP/v/Vl0hw/SfiBJy4Tvi9vCOsLAjFbroFbO6bVfrbfiHfrsBQJxGEG7qOU3
	1E4kzbN3c95k3rFFjinQIK68yF6te4EHKWmeBBOWTzjc6bh+QaylQe+G6MfobgtbA7TRQffTyWn
	NXX/VghZ/AF+guPWm39cmMCglx0s7cBgslhn8+kOcMo2oSH4VfNaIJlwS8VRIa9nHyPOUSdQZT0
	IpiU/XIKyWUbOOdBu6qLV8IXVE7J8tICrFPIUcVZAZRwUyrTLJ+kG5faNZBxdYus5ldD6ZBfwc6
	BHbpU3/tb31xtL8k1DySqWIDi5agNzu/OSWT/45BQaowTAm1ByUgbrFvaBuoIUs1n3AE817zN1Z
	JM0t+OBAeRSv0xK/ZnWKNMyW2RSGrdpH+SrVLrAa5JvLgRxjtwx+BurZAtKcQl/y1OTxxN+CPSL
	E4BO1p6l7chz9iMbRbv79MQUgqPtwn8
X-Received: by 2002:a05:6402:4025:b0:6a8:591:6bd2 with SMTP id 4fb4d7f45d1cf-6a805917040mr6570996a12.20.1788862685976;
        Tue, 08 Sep 2026 03:18:05 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a7e68c42c2sm5275845a12.14.2026.09.08.03.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 03:18:05 -0700 (PDT)
Date: Tue, 8 Sep 2026 11:18:01 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 04/20] KVM: arm64: Use block-level annotations when
 setting up the host stage-2
Message-ID: <ap_g2eb1sn1Mp_Qd@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-5-vdonnefort@google.com>
 <n2cker7zphcsacuck5ovwtj6k622ykpadg6njs2qirhqxj5keh@ub2dnnarnmmm>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <n2cker7zphcsacuck5ovwtj6k622ykpadg6njs2qirhqxj5keh@ub2dnnarnmmm>

On Mon, Sep 07, 2026 at 03:37:56PM +0100, Wei-Lin Chang wrote:
> On Mon, Aug 03, 2026 at 11:08:48AM +0100, Vincent Donnefort wrote:
> 
> [...]
> 
> > +static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > +				     enum kvm_pgtable_walk_flags visit)
> > +{
> > +	struct fix_host_ownership_data *data = ctx->arg;
> > +	enum kvm_pgtable_prot prot = 0;
> > +	phys_addr_t phys = 0;
> > +	int ret;
> > +
> > +	if (kvm_pte_valid(ctx->old))
> > +		prot = kvm_pgtable_hyp_pte_prot(ctx->old);
> > +
> > +	if (!prot) {
> > +		/* Unchanged region */
> > +		if (!data->prot)
> > +			return 0;
> > +
> > +		goto apply_ownership;
> > +	}
> > +
> > +	phys = kvm_pte_to_phys(ctx->old);
> > +	if (!addr_is_memory(phys))
> > +		return -EINVAL;
> > +
> > +	/* We already know phys is contiguous as we walk the linear map */
> > +
> > +	if (prot != data->prot)
> > +		goto apply_ownership;
> > +
> > +	/* Accumulate in the current region */
> > +	data->size += kvm_granule_size(ctx->level);
> > +
> > +	return 0;
> > +
> > +apply_ownership:
> > +	ret = __fix_host_ownership(data);
> > +	if (ret)
> > +		return ret;
> > +
> > +	data->phys = phys;
> > +	data->size = kvm_granule_size(ctx->level);
> > +	data->prot = prot;
> > +
> > +	return 0;
> > +}
> 
> I think this function can be simplified, if we check phys first:
> 
> static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
> 				     enum kvm_pgtable_walk_flags visit)
> {
> 	struct fix_host_ownership_data *data = ctx->arg;
> 	enum kvm_pgtable_prot prot = 0;
> 	phys_addr_t phys = 0;
> 	int ret;
> 
> 	if (kvm_pte_valid(ctx->old))
> 		prot = kvm_pgtable_hyp_pte_prot(ctx->old);
> 
> 	if (prot) {
> 		phys = kvm_pte_to_phys(ctx->old);
> 		if (!addr_is_memory(phys))
> 			return -EINVAL;
> 	}
> 
> 	if (prot != data->prot) {
> 		ret = __fix_host_ownership(data);
> 		if (ret)
> 			return ret;
> 
> 		data->phys = phys;
> 		data->size = kvm_granule_size(ctx->level);
> 		data->prot = prot;
> 	} else {
> 		data->size += kvm_granule_size(ctx->level);
> 	}
> 	return 0;
> }
> 
> Did I miss anything?
> 
> Thanks,
> Wei-Lin Chang

Indeed, I think it's my:

   if (prot != data->prot)
       goto apply_ownership

that is clumsy. With

  if (prot == data->prot) {
      data->size += kvm_granule_size();
      return 0;
  }

(which is basically what you suggested)

I can get rid of the label.

-- 
Vincent
