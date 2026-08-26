Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8D72F7F1C
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 08:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787733960; cv=none; b=XaAVXfqNXdG7nG23YYxS/YF/LiC/kBwU5qimIMkb10oaYpj6FRAU7PRR7HRgg4AfjGtOxQkPY97y9fUUwgw2C6rY4JSpLT42Mx0Pd3ZJgzoHJ2/gkTYyqFVBWglWwnlcnb7D1B7gy6KfkYo8NfXzy/vuRkpfLOYdILHaeTUdcF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787733960; c=relaxed/simple;
	bh=K9/006qP2S/t1c0k8aOwQB0wN1VttIpqm0FmDwp5pK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SN9+W3Egf24w7MmCXI+D1Cot4WctQ0oa81yhfFRk5L8OSq3YWuewKQ/ELJXia09+n2Kkh37L36kYfhb2+MH+5I2MxKsWkBI0QPk4J3EhbzJYoBhthK5IGUwmY8voqXKzJJCy7ROzRvJ0aCgC/7MAW6EoeE9960940GTHNyQENwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B5tzQ9Dd; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B5tzQ9Dd"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4996e2575dbso43295e9.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 01:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787733957; x=1788338757; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z7ckLEdPbhTyPVPfJ+i3gxu5g8YB3cToPtYH/B0h4a8=;
        b=B5tzQ9DdcUvydmP4iZKvGr8HijcQgGBvzTeg1Swhh2QxG8ZyEYHwoJz5/gvzYafBPf
         ic6g1HIxIlja+4De63xs8j4j0HquiRqdX7lhf6hNX/dDsrdv+9DiBMv4tIL2E9vY4uVs
         IqwmUubKK64BDf0EYg81j6pOtlTOjej8jzHyovCpip12lzM8+39lm4I/XOtvrHX5ggaV
         +lYUsCwr+h0HYe2JLadX3Duuv72KyYzlwWYGsmli4pe9D4LIxU1LFJ91RrG9LlEIpUs1
         AUgE7QS704KGZDnjO/nmdqPquhhb34Rl9bm9IRH98tBH98beDQMyK2/WArCMaDtx32Uo
         bs7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787733957; x=1788338757;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z7ckLEdPbhTyPVPfJ+i3gxu5g8YB3cToPtYH/B0h4a8=;
        b=jkAP7ciVvf9ar7AY/L6dDfd0GqilP+usFpRXg4cFPM1xHSTDhFpR1He1BOp4CljBfw
         SoVH/9Fop1H8iZEQP7p4JpFqc9KwN0L3f58XWKqdn1Li4SSBGuEGOR1wiu7QHGopYJyz
         k29loIBfxwdLKuHtp315vbgKK5PVJmbkhXi4JdUDrRBciVSJJmmK3Vlpkm6AmZohWtaJ
         OObJh1HJnX14/UkK6pbRbvud1FTxQHrz06FKMGAdzF89LpGj9kKsrHiE5DiiEJg13umh
         xUILWSqBq3U0y7X2cDV7XaAWIVBoD0P99wWeHYl+haGfU3LAkDRkEQykpE1y+O+XoHT6
         mEQg==
X-Forwarded-Encrypted: i=1; AHgh+RpiQiTC2FX2OVrnQZe/belnWwL3LCEioSZ+8xT+r3ITQX3eHKWwrflsj6bbFwSZbtKgqso+ZVs=@lists.linux.dev
X-Gm-Message-State: AFuF++k5r7fUngFiw2dLKJMLqm/9ExvSbsBp2n6wqROpRNAhRHMLLxlw
	lhc343SEvW2WdAfBts1kiAriqwIeTmXVtm2dBNa6Oiuf+k5odA2vRP+fMjQLGexOlg==
X-Gm-Gg: AR+sD12iaIYdmX1yniWyI9QdJUSm4NuOcYkxjikaEXQetCBoypXlyk2EdY2984p5dEK
	jlK7TOOZZYdjhuO/I15fQPm3OP/byeLXAz7xubqHkjukle11Lsn1R+govuQgkCGQ5Pm0e4k9zyk
	gLd8d47UNcTlCxbSqtWmD5L5sro+BnTsenHldJr8RVqsQztM7MwlmPW+Xyg7E99zmq5Kf0fVDCO
	dFMHjDn9G+T3Ol43lhusZ1V6rPRDETVccLj/q14+WUm8okKq4XXbef5W3hFUKNZDKl8NTIgLk6O
	u0j3XboaVULEu5VWntI1xsodmLCgj8DTPzqJ9mjCpHSwtCQ2Ae3F/pqUKcbqt3oqZHrtcNd1D6j
	mZXPCY5RAmXmeMsJweuK2BqJT9GcmO5aDoqdwqKMzFt/fWlEuOm2Cavy0q+62IAlcWV6JHshQBy
	ddzbcTVcaXquhXgAUiephTlT3z5A27IqmooPjOlvqjmBuZLGkh/vx3sSRvi3/yP5cexmf1eoh9e
	mnQWpQKumc6Qzo3zg24lOzcs56eHQNRbNH5LoKp
X-Received: by 2002:a05:600c:2d91:b0:493:b47f:a24 with SMTP id 5b1f17b1804b1-499dd500ce3mr457395e9.6.1787733956245;
        Wed, 26 Aug 2026 01:45:56 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499dd5b3958sm8743505e9.0.2026.08.26.01.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 01:45:54 -0700 (PDT)
Date: Wed, 26 Aug 2026 08:45:50 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v7 00/24] KVM: arm64: SMMUv3 driver for pKVM (trap and
 emulate)
Message-ID: <ao6nvupFg7neLqbN@google.com>
References: <20260715115906.2664882-1-smostafa@google.com>
 <178769159057.3356902.1232440069489543145.b4-review@b4>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178769159057.3356902.1232440069489543145.b4-review@b4>

On Tue, Aug 25, 2026 at 05:59:50PM -0300, Jason Gunthorpe wrote:
> > This is v7 of pKVM SMMUv3 support with trap and emulate
> 
> I tried to compile it:
> 
> ld.lld-21: error: undefined symbol: __kvm_nvhe_iova_bitmap_set
> >>> referenced by __kvm_nvhe_io-pgtable-arm.c
> >>>               arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o:(__kvm_nvhe_visit_dirty) in archive vmlinux.a
> 
> I think it is because I have CONFIG_IOMMUFD turned on.
> 
> -#if IS_ENABLED(CONFIG_IOMMUFD_DRIVER)
> +#if IS_ENABLED(CONFIG_IOMMUFD_DRIVER) && !IS_ENABLED(__KVM_NVHE_HYPERVISOR__)
>  struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
> 
> ?

Ah, I don't think I tested that config, sorry about that, I will fix
it in the next version, I think I will just stub it in the hypervisor
if possible.

Thanks,
Mostafa

> 
> -- 
> Jason
