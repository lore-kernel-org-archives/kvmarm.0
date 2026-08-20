Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD4A415B7A
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 10:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787220569; cv=none; b=kuvOWnFTMb+LgdVjYquEhc4jWJG3lupOhgWUSIRh2JF/+C3gnvvHj07nnsuIJet+NR7TUbAO/QqumHqjVK45SNkOIUSj07/LOGzorULDV1VowKkFjVzAHTQW2+QXwqYoeHMC7cGAeWBmB614fGyGv6kFjAYsBJTStl5duFuzDfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787220569; c=relaxed/simple;
	bh=sH2sAQhq79low0xTG+PL3gzMzDeoD9iF7DiNLRoELSI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F7uMAdd18JzKpy+DOI38sGOs9mdEI9+rkHnS2CNxua50Uw7rUKivQXYJQWamzjUIq9KVhkAHownY1qKqEFBcRTxh4GITz05IhGV+9J0lXn2+G2ITggmTDl8VJ1pXEAvL4qUO6NSMSXtQpRJeAKFgxgne0JYs+jL50U2aR6iiJnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HN013ZR9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HN013ZR9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787220553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VWz7OuqsDy/FzjRS0OiNSUvLi8xeYgzLLggshpzDzkE=;
	b=HN013ZR93Htnrxss20tZpHnRqML8QpyuNcX0lLPaPsufRdiDJYpg1gGPnQVbW33DEoMFur
	7qS2lG2JlBVykD5cBaYRlWROLLXdwKSkGs/admi4rVLeHUcFPxAtDjWmSoVCL7OJxT7+lB
	KjwzmJAEUMxmVz5M1UTHALN6zDsy+uc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-3H5fUafTOXqMyWyn3Y-8-w-1; Thu, 20 Aug 2026 06:09:10 -0400
X-MC-Unique: 3H5fUafTOXqMyWyn3Y-8-w-1
X-Mimecast-MFC-AGG-ID: 3H5fUafTOXqMyWyn3Y-8-w_1787220549
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49554715277so20189415e9.1
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 03:09:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787220549; x=1787825349;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VWz7OuqsDy/FzjRS0OiNSUvLi8xeYgzLLggshpzDzkE=;
        b=Dglg9AHrPdZa3xe8t0vXtDIrPjRUwvSna2HTxnaZSHBrwX27zUcr5G+P3AxVH+H+JW
         WPIJk+wTTzMxvjT5JD007hGP/xQrA240CxJiNEIWILFn2SV1NnDxbPSGe4C7HKaZFjgc
         Ufn9bfep7w3ceAVwhDzlz9pgVP/kSpOgEJdddxhtA7w1brs4rYscB/Lok83MuuR4zxOc
         mzh+6vwDmCgvCJmRb0ppNU26S10mauIk5Qo/wUU1Cnpi/6XkDWQDucjAy9sDgAG9AFXJ
         RH4cHmJdUBDB2ZfX+SWDgAtL9UIblogufRu7HQ74Drofbe5D3tXURcl0dOoHgJ2XoyLA
         MonQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrk6T0Hl5uKyqf0YGogbYMZ5wSzbhjZmCVF7mCH7RFFWJKxty2TYMbrLmWdvRKeSxUShWJaoZI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx23ol5q6TbjCPk5rJd1KHnzUzfW7sTJ5cp+OVXvBgtDe23L0Yh
	7BlHwn4LDwyeOwLSAvnU9Sco3S4p9jade0zY7CmOLNkEUL0n79FwHPiSeDY22od3dMEaPBDpBaH
	D7m1X5s3+yqXsYn4D/SO7ShwDJ+FsUCw2wQABAHc6rc4gvGKVlpP34IBYOg==
X-Gm-Gg: AR+sD10zmVjWZCPW925H3QF3yW1qnrR1UNYmVnVZFoEaOagudhQeXlP5me/FaXRl3j3
	D+U52z8cCBap3rXZWMl8ohhpRuOpcqVZ3mLaQLUj3fcLKgKr3nFU9vUrmDIXxDDS53XsGb+QgqX
	I88KH2CmV0XRXkXSlKihwmEd0s9BeL52ZT4ANhh2HkZPu4WFzF03hdGIkUBQaIO64MViWepwEzX
	7E4tbrp7gyUpmOK6c8pzmKQLcgDywPEC7+XA5xmBQAPdak9bfG9cvEKrLw/wzYJXPlbsLNOJUGp
	WG/gVdniC0LTM/heAOjvqZSpmkj2Ae0ntm42CSSXErzUlp7UL2KEppaOKXNkEWAf/U+QbYXDTol
	7Bku6H/MQoxwSbg7QbXmqn4CHE+CjfPmaGbiJGrf8phM=
X-Received: by 2002:a05:600c:3553:b0:499:8156:cd3f with SMTP id 5b1f17b1804b1-499aa1b0350mr172531325e9.8.1787220549245;
        Thu, 20 Aug 2026 03:09:09 -0700 (PDT)
X-Received: by 2002:a05:600c:3553:b0:499:8156:cd3f with SMTP id 5b1f17b1804b1-499aa1b0350mr172530735e9.8.1787220548689;
        Thu, 20 Aug 2026 03:09:08 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499aa0dd5fcsm143802935e9.14.2026.08.20.03.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 03:09:07 -0700 (PDT)
Message-ID: <78d60d96-d0c7-4eaa-b425-ca4f75263b12@redhat.com>
Date: Thu, 20 Aug 2026 12:09:06 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] KVM: arm64: vgic-its: Free the caches when GITS_BASER
 changes
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
 Sascha Bischoff <sascha.bischoff@arm.com>,
 Sebastian Ene <sebastianene@google.com>, Fuad Tabba <tabba@google.com>,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20260819102809.310708-1-fuad.tabba@linux.dev>
 <20260819102809.310708-2-fuad.tabba@linux.dev>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20260819102809.310708-2-fuad.tabba@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 84yB9CZtcyyQgDQ5rPcMcPkR0zCRZO9et51iqKcoShY_1787220549
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 8/19/26 12:28 PM, Fuad Tabba wrote:
> A guest that disables the ITS and re-points or shrinks GITS_BASER<n>
> with VALID still set keeps the devices and collections it mapped
> against the old table, as KVM frees them only when VALID is cleared.
> The table format is not architected, so a write with a different value
> is allowed to lose what it describes. Free the list whenever the
I don't really get "a write with a different value is allowed to lose
what it describes". A write at which place, in the collection table?
> stored value changes.
> 
> Test for a change rather than a write: its_restore_enable() rewrites
> GITS_BASER<n> from its probe-time cache on resume, and KVM reports
> GITS_TYPER.HCC as 0, so nothing re-maps the boot CPU's collection
> afterwards.
> 
> Fixes: 36d6961c2b481 ("KVM: arm/arm64: vgic-its: Free caches when GITS_BASER Valid bit is cleared")
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/all/87ecg9owwa.wl-maz@kernel.org/
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index f6538b1976f9b..3339d9977af27 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -1649,7 +1649,7 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>  				      unsigned long val)
>  {
>  	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> -	u64 entry_size, table_type;
> +	u64 old, entry_size, table_type;
>  	u64 reg, *regptr, clearbits = 0;
>  
>  	/* When GITS_CTLR.Enable is 1, we ignore write accesses. */
> @@ -1672,7 +1672,9 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>  		return;
>  	}
>  
> -	reg = update_64bit_reg(*regptr, addr & 7, len, val);
> +	old = *regptr;
> +
> +	reg = update_64bit_reg(old, addr & 7, len, val);
>  	reg &= ~GITS_BASER_RO_MASK;
>  	reg &= ~clearbits;
>  
> @@ -1682,7 +1684,8 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>  
>  	*regptr = reg;
>  
> -	if (!(reg & GITS_BASER_VALID)) {
> +	/* The ITS driver rewrites an unchanged GITS_BASER<n> on resume. */
> +	if (reg != old) {
>  		/* Take the its_lock to prevent a race with a save/restore */
>  		mutex_lock(&its->its_lock);
>  		switch (table_type) {
One question: There is no vgic_its_invalidate_cache() in the function.
Is it OK?

Besides out of curiosity, why don't we go further and remove ite entries
that refer to removed collections in vgic_its_free_collection()?

Thanks

Eric



