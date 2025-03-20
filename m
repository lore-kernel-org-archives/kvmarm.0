Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809CF1EB1B4
	for <kvmarm@lists.linux.dev>; Thu, 20 Mar 2025 15:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742485391; cv=none; b=fGjgL8QJOyimvApjVIkyaNTIZwBIRQySlRYpteretqkPGZLT29QXYAEsQ07x1XpA+D2iStSi4zVKOIEHr+Hoe2DuxnAolaEZos/fRuxCqoUPJn26j4U9hHvUrm2Ckwe6Op/QoJGTJO4hO+LykVGud4NKYz9DZ3Tx3THbADZAOPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742485391; c=relaxed/simple;
	bh=uigvaE2aO9niM5MsJPQOMfGTFNYAvgSBFc3K/Zw5s+M=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Mcpijxnv+gBaFRuspi6zoqwoMU7GwVOB4RRp4F5vzHf3BhlsvtBGqIXXArpFC/iXUX5Rkp37jGVdIhxpNjVxgeilq5BlMyzXEAt87d16DnBQW4qg4d5Oy8hOPw4jx17IvikKAeNQSC8188S9bEjpOhIdsGxDtJvwUZLSPC4RpH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ad5Rbg5r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ad5Rbg5r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742485388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wPwr5oYVIaghPBmG3tNmTIpiegpJlMIqdWSy5HJcBsQ=;
	b=ad5Rbg5rJZE7HUrWrb2ijWI9RMxZQPBASZ2qJZ4ipWiyqMIWzOeAAE/D7IkyH9xhB3d4fv
	NmSjGMtxZEtYUWTMvcQOqNfYXhTa9QQMeGIv/1d2n+HkcHVacZlo07v2WYYVkOh6z7J6tS
	XLaomjIU+O89yG7Ke/Cy34dQbT0YcEw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-zjLHcilkPeelZUqBwMDLFA-1; Thu, 20 Mar 2025 11:43:07 -0400
X-MC-Unique: zjLHcilkPeelZUqBwMDLFA-1
X-Mimecast-MFC-AGG-ID: zjLHcilkPeelZUqBwMDLFA_1742485386
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43d209dc2d3so5869515e9.3
        for <kvmarm@lists.linux.dev>; Thu, 20 Mar 2025 08:43:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742485386; x=1743090186;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wPwr5oYVIaghPBmG3tNmTIpiegpJlMIqdWSy5HJcBsQ=;
        b=dPwMF3ZGJI/4GJUJcxlaVoZu9ZwcYv8TxutM7n2yxorLtoQa4qQNiPFgLivAEsA+uR
         LKYjnM1FYR7zj1e+vXy57Zz/B1b2iU8aJN0DA/5hjLKymgeeGhebY1rSPQmJu/E1zQ04
         19md7ltQZAZXaMkAG36sJequwpYoHsgkNcrMnTSEKYbdLaQrosWnaRafLykZtAg8icd0
         z6t/epjPRl6de9bU40IFB1g9TSfvKpe1cf6J+ertKn+6MIzJ6taHgP6DX3viZL+t/dMD
         gBFE2+Hv2OjSOo9AR0YHskXfkdtKkAYvT0N/HcmtsE/d/+nMQQn4+oDG3eTxn3Z5Q0kT
         ywXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdw2D7ed/4n9G2Bf09BJcpKBW85wkKpsw23ygcE+8udISKBNKZSsze+L/Lj38+fDGy1spuZNQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwJJMBNNrZyebgsXn8G3NEwuLebtFMUZN5rDrlZzubqImj9XJvP
	2Qeo8BVoqLob7Pcyw9sn7+lXnLNd0eGAG64xwxSrTVO0AYymxZxvpUkdVfOXYGGZSRblbl9UgQI
	jzvcBhVDLrIcuTC1z/fOmNK6RzuYLrQYjz7PS0wiq7svJj/of6y/Upg==
X-Gm-Gg: ASbGnctNWbGmFaLyU7B6qdvuWbs0k4qd9pRye92YKsNEcQkEVX/qtO7H079MYTcONNs
	7rxeza6VlMx6GMvPuATa3UXtU3AYFodqHX0IVlPyFiX5tNvpG7mr5trl6Og0FqAveyf+agNqrdu
	Y0lSIvJnc4tqGsQJunCL3kIhI16FPnvY/ZoWMFC+TEagH9wM82XshUYdPbV0Fr7ELgWTWCi39FZ
	UBtMR1EJBF8nZOlBenPWKLzu9idsX9tiNwSjVFEtSd5UEMXUUl40ZUvxVLNiPvyF6LGiF9P59mv
	jbk1cRRxyD4LL2fEgsNXejMx7UjNedMMn7etu7FjwHaEE7UxljgL29xq5LSaTX7N
X-Received: by 2002:a05:600c:c8a:b0:43c:f597:d565 with SMTP id 5b1f17b1804b1-43d437986b6mr60471985e9.12.1742485386053;
        Thu, 20 Mar 2025 08:43:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHePUYhiOBmwzpVGqlSTNpZrxiZia4aYTokS/lw3ZqG8KN7vuZOThxxGVbUPgfYbV4qWmeqYw==
X-Received: by 2002:a05:600c:c8a:b0:43c:f597:d565 with SMTP id 5b1f17b1804b1-43d437986b6mr60471645e9.12.1742485385569;
        Thu, 20 Mar 2025 08:43:05 -0700 (PDT)
Received: from rh (p200300f6af11ec00f9928575aec32536.dip0.t-ipconnect.de. [2003:f6:af11:ec00:f992:8575:aec3:2536])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d440ed4cbsm52762105e9.34.2025.03.20.08.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 08:43:05 -0700 (PDT)
Date: Thu, 20 Mar 2025 16:43:03 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Cornelia Huck <cohuck@redhat.com>
cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org, 
    qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org, 
    richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org, 
    oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com, 
    armbru@redhat.com, berrange@redhat.com, abologna@redhat.com, 
    jdenemar@redhat.com, agraf@csgraf.de, shahuang@redhat.com, 
    mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 01/14] arm/cpu: Add sysreg definitions in
 cpu-sysregs.h
In-Reply-To: <20250311162824.199721-2-cohuck@redhat.com>
Message-ID: <7c6ab887-2c9f-6646-4f0c-790671b28c62@redhat.com>
References: <20250311162824.199721-1-cohuck@redhat.com> <20250311162824.199721-2-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -_7kgFV_4C9bel0kZJW70ryX6CPlY3WjkExMYR1alLQ_1742485386
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

On Tue, 11 Mar 2025, Cornelia Huck wrote:
> +++ b/target/arm/cpu.h
[...]
> +/* REG is ID_XXX */
> +#define FIELD_DP64_IDREG(ISAR, REG, FIELD, VALUE)                       \
> +    ({                                                                  \
> +        ARMISARegisters *i_ = (ISAR);                                   \
> +        uint64_t regval = i_->idregs[REG ## _EL1_IDX];                  \

This won't work for regs that don't fit this naming scheme. Up to this
point in the series that's only CTR_EL0, later with the auto generation it
will be more. But I guess this can be extended when/if there's an actual
need..

Sebastian

