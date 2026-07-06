Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB14430318
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 16:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783356208; cv=pass; b=NizFM4cNoYZo9z+7tYYWd8HWqzjd08AOTroN7O3WwzHIZRgGR2jdkMtgZKRVdLFbflKt/vndZIxX0yNFwRuwLTAG7aVth6kbVOR/ToELG+nF0c8VsXolisMOGn1oqgpZf6+B/dCf/mnoSdcG7UIfufUJ8qxR32XbCNc9AMzTX7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783356208; c=relaxed/simple;
	bh=vrg3e9cxUNDpns9Bl1a5bKc3re+8UaUiVeOIgrtnLTE=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KcSM0jgwMvSpX3+kKFpL4ZkCNkA1UImatyqVJaf7KkaFubuwYKpl67BH/bkUuVvarR+qhYv8OD31gKkr0aN0OqPAGe6VXx2q3XMPp9Zmj1WKAflIIncd8zWoZAXFsRbNMn6JeN8eKXBG7p3PMfA1u6a/O14kqmmoiPB0hsZURas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YYJwB1SR; arc=pass smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YYJwB1SR"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cc7ef7ec27so22204245ad.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 09:43:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783356206; cv=none;
        d=google.com; s=arc-20260327;
        b=T4o9T12li9GEDwDevJo/SvYX2+++hwGd09mhRSPyilydVVWVsubAXrxnrp+nxAWVZV
         1sR4wYMr+TlJyfUIWjmaZYholUQkekp7M202NR+KEZSHojEZPcBVDQ11cPxhTpULXPOQ
         qriWHfc7I03DEfWFmJgKbIJFiIvZH6uTo0a7gqZMQt9KoYsS3PSIVl4C+QMC+zQJ57qn
         0pyyxTbn3KhpRqx8LLq39XG9W+CGZ5yudwrzXQ4uUgNvnj4eInD9FWMACOCAOcmBbKiE
         Frevg7ljWpUIq66aPoeKaiqHuuYCMT+sXuUb3EnnlTgwM5+fWDrY9/lQ50bHR/We4HHG
         GsYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=AUlAAYq1P3NlBc7es7tK425G79dZYYxCv/As82Uw0UE=;
        fh=D1mOZcQh4YjLHbkdqJvxFvQVR0JuW7gz1R4Po8u0b1E=;
        b=ZFCpAXWlxVMQdkEad3LjpixvuuWG98flQS7++O5KoO9OWBdfVVn3wpxHFCzWm6WWmk
         ArifK/rZL3gYsH925fdMOM24k0I1qyvmMC04FsAxwVkaXa/M0VKleNAYF8TSa6txkLXf
         FLSi1BXDMrkZ2kK/J/Ojs5csdPcexggXVHD1aC3wC4ao56/yzKm4hnpoxUnGufMNAtka
         WG+T4CZGjVGkfk0Rh6Rnw64tsKq8PoUMUWs0bV6uMkcifPod+l4N9y0fWlOgB2kKVLJN
         dGbHIDZYCYzlG1sRXj+1akPX3crDvYhPq1UWnIRCkt9r7nKBHlofbLxxXvQpaAiRhS8A
         VHHQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783356206; x=1783961006; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AUlAAYq1P3NlBc7es7tK425G79dZYYxCv/As82Uw0UE=;
        b=YYJwB1SRhGi7b8meXVM4z9FUNGP2VNc2rDyG2fWtFzQW4KDx3k5N5PQK1FEOXvzlqf
         hJa8VCTiGjD8tyKwwKUncPdmigeRERfwzTpFkJwYlqI673hAILSURUJfR9nN65aqaOVl
         iSdALQ/trcl9GHOAa/t5/Jer6ptgKgKQWPTx5IrEZ6DPgVlgicRTSnTn65+2ETbhQIue
         S1ucfegAcpAoyeeErjufvSY9ZpttiPgRJYxym8+3vwAkKW9oxd+ebie7Kd/se8ScM3Jk
         iW8JI1i5vByxEoD0G/txxSoxPGhxbhCjYh4/OHgbbD2VKT5bH7DWAQRICaHHnmMkq6/h
         tQug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783356206; x=1783961006;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AUlAAYq1P3NlBc7es7tK425G79dZYYxCv/As82Uw0UE=;
        b=dfWuTqNzHh1QHH7R0vpXE7pakGAIa3bTJVuDEopPaSGIV3cOPcBzt3Q/8CPm8MkVSA
         nfIeuVxGdNiMjDJ4LLK80msVY2CgHVtOvjTOztUAPqCPgoGmDNt91oE6q08/fTMgHQdc
         jHdSrsJfod/9oq/qOX7a9qrLxvAsRIWxdb3ApVelhhuoTD7oweR/NAACU80boypWpFey
         o2FUlQ1LurTqqK2mJCaQv89ifv+n1D5jAnn7R7dEmelC5vCdfcnPpwsT0Ayt2gN1nbIp
         f6rikv8GbSYVgrl+K/4rTdwuCmacvwqKDgBVKPsbMpMs7DKwreJgCUruUTk30BIHxBAt
         6N/Q==
X-Forwarded-Encrypted: i=1; AHgh+RobAkDu986cxHSr/MANkk0n9YN2sQa6BHwROpQxIEPtOKsT1cp3D4xCyibM4QBd1PiQcpaqgAs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxp4U+VZnFrSmmZpHAO9iNOeSsXALsP54pwnB0OgXtJYzVxlvxY
	QdQH0qEu/rZF6pdroyUTE56TmHGr9ks53wzYFAo+t+X4cqDX2DVgcbVin8lv05L+9/gXAtwz0DR
	iqPvaEcSf8rXMeItvVtorKoQP0cIB9ivQTsAoModk
X-Gm-Gg: AfdE7ckDCwCNtBjNtY5xql+pBiJXod81RA1rHFO7gwvqIPPKcLKSF07zep2I73dFBPB
	DTacP2KUV26QcZUai7vIdEEF+F0f5nNHaqmBB6GaKvCWtVgHB8zlO7CNhLYDi6DOii8MzaHHyEB
	d/p9ukQwHhD6m9WZcVBsh1zOXBUBdHGyZm5wJj43wnNBimTLAq0vylNXBS6LKoQf6t/MXOgGQ0v
	bE8YZAwZUhuJZS7wFDV0nhOBln1zYgoI4zANlHTl7DK+/8ApN6EVE8/J0Bo/lycvtTHVpJFydBM
	zWIWO7sUxkevYTJcZUPvZeKvItVJ67wT2RM9WfTZC44JQSAloSjz9IZsL08=
X-Received: by 2002:a17:902:e5c8:b0:2c6:90ec:f601 with SMTP id
 d9443c01a7336-2ccbe50a8f8mr13298475ad.8.1783356205420; Mon, 06 Jul 2026
 09:43:25 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 6 Jul 2026 09:43:24 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 6 Jul 2026 09:43:24 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260513131757.116630-27-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com> <20260513131757.116630-27-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 6 Jul 2026 09:43:24 -0700
X-Gm-Features: AVVi8Cc7UELd1-7ZAYEyOZ88G8y7OqpaGYaDp3NNsXOnmH1AvIzaHGeBstkVLUA
Message-ID: <CAEvNRgHTu5ZDAamO_sXkqP3V=_5MhFjdzTYmJn4i=a9ni=9tfw@mail.gmail.com>
Subject: Re: [PATCH v14 26/44] arm64: RMI: Allow populating initial contents
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
Content-Type: text/plain; charset="UTF-8"

Steven Price <steven.price@arm.com> writes:

>
> [...snip...]
>
> +
> +static int populate_region_cb(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> +			      struct page *src_page, void *opaque)
> +{
> +	unsigned long data_flags = *(unsigned long *)opaque;
> +	phys_addr_t ipa = gfn_to_gpa(gfn);
> +
> +	if (!src_page)
> +		return -EOPNOTSUPP;

Came here from [0]!

Sean recently moved this check to before kvm_gmem_populate() was called
and returned -EINVAL [1]. I think the rationale would also apply for
CCA.

[0] https://lore.kernel.org/all/114e2488-97ed-4740-a8e8-1edd991f26c5@arm.com/
[1] https://lore.kernel.org/all/20260630213711.479692-3-seanjc@google.com/

> +
> +	return realm_data_map_init(kvm, ipa, pfn, page_to_pfn(src_page),
> +				   data_flags);
> +}
> +
>
> [...snip...]
>
