Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B70A402B86
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 15:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808091; cv=none; b=gdQSPwphHKqIT/2LQuub4ok1UR7S4VovkS7K1UP4xuTVTYizFrYh5lDB5TcgRnZAgyxIZNU5VEbBHIxFBiWKFavUwG0//PpvqOXsC+tTBgkcifjii6n6qimDJDHnzEZ8/G99+dDxnw5+rAnzxBrewvLX1HSleZJ8s+PRDvfGt40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808091; c=relaxed/simple;
	bh=F79pnaBKV+Uqnp9jQtxERhWYHBM+5P/JLdBygMQn6fI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=IXjjpymwM3dbBXIxWV10tCxlUKEDlbNn3K0Aep+IbEbSpp/+w0qJa5JMUaeoOaysOWg9sBbFUcaj8bAeCDRbayb12mPcMxet61wdkIdCiOx8QU8sjodzvACwUPNbdZSCN6Sr1ihPwtZ8dq15ebzBFUJLUWwJcm69DnvpgKUJEIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XW4VPDfo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XW4VPDfo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779808088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nTzMQSKdxFipCdF2ry9Ey+MwrneHn3RX2NvYnEq5DPA=;
	b=XW4VPDfocYNzPoK8LSYQq5zAaMtJHqrZ768iK3jU0n5RRmJN8p3t3zr7O8OZNlw22K9fAL
	Ue4E3ZVKzJADilVvcImBqy/T71d211PRU4nNtALG+g+Z6KA//CZtc+yIyqGSScku0E73sG
	s9KT6l8EAydN5+3ymZSQiz1HMUipHnA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-VrHfw9fBOXGvj3RK_ecSQQ-1; Tue, 26 May 2026 11:08:03 -0400
X-MC-Unique: VrHfw9fBOXGvj3RK_ecSQQ-1
X-Mimecast-MFC-AGG-ID: VrHfw9fBOXGvj3RK_ecSQQ_1779808083
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-45aeac88af4so8686059f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 08:08:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779808082; x=1780412882;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nTzMQSKdxFipCdF2ry9Ey+MwrneHn3RX2NvYnEq5DPA=;
        b=C3TtNYdGCbxrCZvhHD0rtLhrr3K+gadmYSNGLMIEhIhyyddF8n90SsPCnQjaSoQjbe
         E6Dw4XYj0dxYyBPWpeHFgIQQx0hwMyDcbeOzJvjRjOQ0FpyKTGWOtIHfHUBhtgl3zYNz
         utLp+/bz6IH0K5OAL4kemNDRAFAljbv8eWl3DhCHIxwGjo7c++0RwmtJ5R/8mnjaLiQL
         U8omdcieS5TBdoVIxHPl0Noo/0ddPz1XaenO3XoOFHkF5mMYdVyUTuNiVAdQ3w3o4EfT
         OxBQbgQFNjApJ/GHENdXPB8Zd35RHo+wUSIAejRfAV3G2oXObjJpoWIXDhaw9bzIsP7I
         +PtQ==
X-Forwarded-Encrypted: i=1; AFNElJ/TPJtMj/NhCnuSCzQm/llGRVSktsIxEFGq5GW+B7ECIRIackc/+mX/J9CkE8UZo4fFO77s0Js=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzi8cRP/iOaUsXl4IJdvGYW9s3FJYT20D6mb314fh1fGfn1LveI
	lO+7jnOj5y1Wi3bMcLVt7V6FaTsL7jazd7heehHugrqghvECIyQvpf1Ej6AD9dV6mO6nf0eBhOr
	VNM6yKJNTVpj9Ij8689GTpGxq7THSYyNqhMukeuIGr6guUhLiz6n7wFnhHQ==
X-Gm-Gg: Acq92OH06C7/8Os0oKvBVm/PQS031LcJQbOi7pHTkKH0LNEtYH5t/jb2Hrnij93i7vv
	/NWDYUb48X7sBwXY20y7whPBand3AcnOHFWv+efBZ44MO1pJSV5OFMVBFRnuJaKLmRM5aVeVwBn
	hFzGau35GypOw1a8EGd/dBpsQzSwRlTdetTGvxPdTpyfGYp3P6zXYq3mA9zhyTtY5q/nc3DtXi5
	K6gpkVkCkXYckfZAHQYGqXEotDBH0LCAEpxbYCB2iZxsj0gzG6i+JlLux+aZCuVH/R/NfI/sxqz
	hdCheuQHGGHMWhDbD6kC7I+lpwPOENboyDXORk2GpUVuxWFmibrPUJdwEgiPER6uC4ZPMGujtJq
	D64J7nJXzV/zjAfFiFt7+adQQMQFJt7SBvXr1sfD9uf6wUESkfK9zBqiyQfFpCA/93f2XHec=
X-Received: by 2002:a05:6000:4a10:b0:441:1fa5:457c with SMTP id ffacd0b85a97d-45eb367f9f6mr33776482f8f.5.1779808082592;
        Tue, 26 May 2026 08:08:02 -0700 (PDT)
X-Received: by 2002:a05:6000:4a10:b0:441:1fa5:457c with SMTP id ffacd0b85a97d-45eb367f9f6mr33776417f8f.5.1779808082068;
        Tue, 26 May 2026 08:08:02 -0700 (PDT)
Received: from rh (p200300f6af2a6100f239e076bbd76784.dip0.t-ipconnect.de. [2003:f6:af2a:6100:f239:e076:bbd7:6784])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5cb9asm39251687f8f.27.2026.05.26.08.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 08:08:01 -0700 (PDT)
Date: Tue, 26 May 2026 17:08:00 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
    kvmarm@lists.linux.dev, peter.maydell@linaro.org, 
    shaju.abraham@nutanix.com, khushit.shah@nutanix.com, 
    yangjinqian1@huawei.com, cohuck@redhat.com, richard.henderson@linaro.org, 
    skolothumtho@nvidia.com, philmd@linaro.org, maz@kernel.org, 
    oliver.upton@linux.dev, pbonzini@redhat.com, armbru@redhat.com, 
    berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Subject: Re: [PATCH v5 14/18] target/arm/kvm: Special case REVIDR_EL1 and
 AIDR_EL1
In-Reply-To: <20260519132905.145643-15-eric.auger@redhat.com>
Message-ID: <5f6c1d59-f2d1-e21b-5d83-c5d64ab8a484@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com> <20260519132905.145643-15-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: f6ueb3F1831jUjBh-xT_hZZsSXVR1eSv5DCKXifCAnY_1779808083
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

On Tue, 19 May 2026, Eric Auger wrote:
> Special case REVIDR_EL1 and AIDR_EL1 which are writable but
> does not expose named fields. They will need to be handled
> separately
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
> target/arm/kvm.c | 10 +++++++++-
> 1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 960052e67e..6373a66bbd 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -472,7 +472,15 @@ void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs)
>                 warn_report("%s: reg %d writable, but not in list of idregs?",
>                             __func__, i);
>             } else {
> -                decode_idreg_writemap(obj, i, mask, &regs[idx]);
> +                /*
> +                 * special case REVIDR_EL1 and AIDR_EL1 which are writable but
> +                 * does not expose named fields. They will need to be handled
> +                 * separately
> +                 */

"Special case REVIDR_EL1 and AIDR_EL1 which are writable but
do not expose named fields. They will need to be handled
separately."

Reviewed-by: Sebastian Ott <sebott@redhat.com>

