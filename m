Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B3D47CA87
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 15:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785943584; cv=none; b=s+SMQ+l1t4DwhbAWRWo05y3vl/QyzQgv+6P29CuZK3DERdkpazszRl0jDoEy65YqV4DlVk4+1g3U5YEkeXB6RsH27tnjOk066KRoODDfW8S8qW+FkUXnJu0XUCvIxauOBIyC/u/TBLfqVmQncYRskwbSevhOq8US+s3XLghzxtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785943584; c=relaxed/simple;
	bh=k2dfPXeOzAHpRioWn2Z8dsyVF7DcClGaHxC6ZjFMKf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DPTRqg3+YJJY4tC0V9sBRH3ywDxG97TpHwoLTsdaBj3z1K6GLfrm/5pEq0EY7jNBpa1KKxI1eKCStbErVzU2cAq1k3NcwwVeOPh/l51+axTz9l2RwXKVazb4v3Izy46rE9qjyGFj2qZWZ0F7YNKJkYVmew8Ajq4vGayhvhdxGGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rQJKtFo5; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rQJKtFo5"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6a177b2dc8dso9687a12.0
        for <kvmarm@lists.linux.dev>; Wed, 05 Aug 2026 08:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785943572; x=1786548372; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hNRmrl2B/brOKHnxIA/lHQtuwZlyNTPIK3U8kLKpdDc=;
        b=rQJKtFo5KkAcR8QutQ/+pnH7sUNsKnCB0rBKoIgfR7ndQlVK4l6g7YxbJR5uhG++wY
         ZJZ3VdFL1hbpbnspNa+5s7iIh9887zQXaEWObefCQmVFPPopzYaVYm7gnBnX/KASOTqk
         lscifaJnHYyRdWVikqyyH5acOkP/y92beNJdaAwukygu1GptTnhgruXLmtRzxeK2V8Z0
         DPpdoqz09sQPqhEt1hvyMjBnUVscdoZrUjmXiZgsHkqwqwBexi7+ImZ4235qDDxQpKQz
         wq9zUKTZ8yN2ieZHE6ICnpScjPIIbduRohl7bc7ZiSVHie1FCokIOaZJMZr/Jajj2SZX
         yFmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785943572; x=1786548372;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hNRmrl2B/brOKHnxIA/lHQtuwZlyNTPIK3U8kLKpdDc=;
        b=KNhPlQd/V+1UszmLXf46VW69B5qFWxZozr/dgWU1Qbi4Vr7V5ZSgX36YfQPdXcIcbp
         ONHCh+bVqfKxqcDTT1nQrCg03//Z3EEME0BJ5Z6JJdjyDL6egS/+DdSCUuDyqXqVodg7
         Ji7sVSFJKYTLEcvPGErIzcRjZxqZa56JrqWimEdPjTE0v8AkbNN6NyNnDJReaA5edefX
         rx6FhpagE7icmlforUhmc3qfsle3iuyrMzkAN612wJjc7mB0sYdClW8Yc+sRwKqzejks
         igHhmJWzEJDmiZs1dkuA8NwrpvbidICBpaACrIZbo0Rxr2OosfKyihqjOOw8vjC3AJG2
         YHAQ==
X-Forwarded-Encrypted: i=1; AHgh+RoRfVKdKsHB+Sf3FyOfXTXFj9udPwcWSwpaEYz9EM9yqDNaAtt6PqubsUKaIbo6bMClhCQ1p4U=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvYD0/+KGn8TGhbnIUo9l6DFWPXHPzxkEmzKU3RwSRWAaP2WW+
	mhb6YuM5CQpmUGg2z2oZ7ilsSUxEkFcxo6n8rP28Fr8gLuu50RQwPGTbtgSaThcRDQ==
X-Gm-Gg: AR+sD137yplHikIEn9a73HHcg8w6FlKe+UxTN9cpv7nOkQgb8jNXbgDy2CoNYC0nS8H
	uTMYfRrUJdxhPfw4OEmkkBQ/r5zX/EkgFfTxcSE0H/JiBMdk3PBXgS7PVFdgLqNsrJTZV6qmWid
	G3ymDvgp8U1qL39jbi9VkBVrcumtfxwWfXlzBScnANTf1i9UAu+hN5itqwbQT1j3hxBCQBmDhHS
	WHTSI9lXbtqSZiLU8H+hTABbYhhKpWP8vBm2xPHXQmo5CJ9ndOllm/suPgqPIxgXZTKrjdic9OH
	Q7FYLxKj4p5XHs497e+Oz1ph+3b9U6fMFSeAGrOA6oDVn8FUwYLeXzi5oPZ1vWVf21DbP5aLXxX
	He02ph4XmYS4XX8PM035A9/0e/A/yyMnFHMfRU/SIOycF07H/xUE8/uTX7toa3UYBFDXTlo/t3w
	Ml6OXsxYmNE4juv623+Dplua7XhY0/kKD7bC4ELFkwuCtVXhMxRbAQKDfWb+Q5CIpfeWskWqiVB
	xi+4tqtRMpzD5SayKRjNaT/WbzzTw==
X-Received: by 2002:a05:6402:44c8:b0:697:7f69:48e3 with SMTP id 4fb4d7f45d1cf-6a14fc7db15mr77076a12.10.1785943571545;
        Wed, 05 Aug 2026 08:26:11 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a17c55aa21sm1309954a12.21.2026.08.05.08.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 08:26:10 -0700 (PDT)
Date: Wed, 5 Aug 2026 15:26:06 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, keirf@google.com
Subject: Re: [PATCH v7 02/24] KVM: arm64: Donate MMIO to the hypervisor
Message-ID: <anNWDt4fNFNkbSdO@google.com>
References: <20260715115906.2664882-1-smostafa@google.com>
 <20260715115906.2664882-3-smostafa@google.com>
 <anMwxy9gEEt_Wu6M@google.com>
 <anM9sk_gXTt5F1Ie@google.com>
 <anNPPrjGd2Z2dSwc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anNPPrjGd2Z2dSwc@google.com>

On Wed, Aug 05, 2026 at 02:57:02PM +0000, Sebastian Ene wrote:
> > > > +			      KVM_HOST_INVALID_PTE_TYPE_DONATION,
> > > > +			      FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, PKVM_ID_HYP));
> > > > +unlock:
> > > > +	host_unlock_component();
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size)
> > > 
> > > This function seems to only update the host stage-2 annotation but it
> > > doesn't destroy the hyp mapping.
> > 
> > Yes, as mentioned above there is no way to destroy it, and this was
> > not desgined for frequent use. Typicaly, __pkvm_host_donate_hyp_mmio()
> > is called at boot per area/device. And __pkvm_hyp_donate_host_mmio()
> > is only used for failures.
> > 
> 
> Yes, I saw that you only allow the call during the init pKVM calls, however it seems a bit fragile.

Why is it fragile? Nothing is wrong with leaking private mapping it's
not real memory and it's massive, and given that this shouldn't happen
and will cause KVM to fail on the system, it is not that bad. (as
mentioned all other callers do the same)

> 
> > > 
> > > I was looking to make use of this patch in an upcoming posting for the
> > > v2 ITS hardening but in my case I don't need the private VA range
> > > creation.
> > 
> > I believe if you need to map MMIO, private range is the right way to
> > do it as the linear map was mainly designed around system memory.
> 
> Is there a reason behind not having MMIO as part of the linear
> map in the hypervisor ? I would like to avoid holding the hva around and
> just do a simple addition to resolve the hyp_va.

When the linear is created it only considers the system memory layout
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/kvm/va_layout.c#n82

Which means that on some systems an MMIO address can be larger than the
linear map.
There is another comment about tha also in:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/kvm/hyp/nvhe/mm.c#n420

Thanks,
Mostafa

> 
> > 
> > Thanks,
> > Mostafa
> >
> 
> Thanks,
> Sebastian
