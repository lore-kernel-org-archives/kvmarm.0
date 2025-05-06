Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482E017B4EC
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 10:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746526218; cv=none; b=PPyMbcb3lULMwKLs1W4uEk9AOdnoLqHHW4Fe6uL1Z9zA86R+J+FIuTb+AQnPhng4xcLCuz7mJf2eO/2NYNAgCyBGVtJXNLHRuOmDBCtVCZZf9oeQA37VbM5GiCRbLTB8gzhIethMoSZP6RmMhG14BSTI2z4zy+roX4qazezJsTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746526218; c=relaxed/simple;
	bh=4ymTURkC2WHBNUaMBm0GbRCjkPcBy8xTuk2uDzpTIdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EUTxX0g/5xXOzSzCrPlMye7KnySYp5b/p/keGItTzVUXXmh1r5KiHvWgZRlm7qoyrjhoJD5umGhDDT6FYzmXKJ90XBrUGKcsKl/stbMvQsyRVYN7KdcYDoAgaWgjPNQHQYqC1qu8pKicYBz6fZpRB5qb6lxA2/XDxyYoxHl/3Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AiNwFgmp; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AiNwFgmp"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43d5f10e1aaso52085e9.0
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 03:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746526214; x=1747131014; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Np31GT5x8wgm7/sKQHFUJ4Rm2JmmDAX9KCDSS5Rzjf4=;
        b=AiNwFgmpCjk/9M6bl/qg4zUrincipEF2ZkdZTR3Cr/WtNhiWBD48ZDpWvxgguehDoD
         dRfNe/j75DizD5iBVOP1VXiNmiAA5116gYtCvUo4u3PPp8gFlwXQRgbeYCJIjm4Osyr6
         Y8x38kR2iKOB9G7MAdEXKrCItvqaivbycTuUAqyv2uRutT842k9LYpp42IRNmXBBTYil
         ilPzc0B87N/rG0GGN3dhxFC7VCchniQvnRBZ6+GW31Q6WKIcUADmcRFFPkM3fyS8Hu7M
         IklfYX/M+xsmkJVw3Iszvuah2lopcktlRwZX4H27FcNAgEijOzgam2h4Rp9+9PiHQWH/
         dBUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746526214; x=1747131014;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Np31GT5x8wgm7/sKQHFUJ4Rm2JmmDAX9KCDSS5Rzjf4=;
        b=kwKFQiblz7hZw/6zkargYgdtFm4ge3Wk3n8UlC4yu9Lxz3tv8ElwzCiiOxbnT8/zKA
         S51wiNolVAMpvSLWWxZFl68I5/bvKrsSQ6j3LzoIN8aLC+vUK34xqxOGojRC+x/cSpx3
         h/ib66iKzGaF36FLylFdkkTdocVKzlxmBgBeOyiwyFyMtqNFJSC+eAJeR/E94RflsKw0
         zCGseJ0jI9MtqVu0ILDLIST50mgLprmJcJp1kjz/D1cCuC0utqWedL8ReDORYB7tCzRF
         aCxdx3HXiG81z4e18Xa9qJNpDQwlVHQT64/AkYpW2yp3Seulx5aQm065mCnHYi/NJdvk
         PgIw==
X-Forwarded-Encrypted: i=1; AJvYcCV6+T8VpWiOeCV4gwjJOJgMkAyxlpVHkiIrd+Z9oLv1x29V+Tepkkg7j3nnRVjkIRuCkWnayuc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPubyC4XD8rFr6c2uQPPacMV1E/o4RINtyz8Vv3D7rPFhYvVjy
	OTlfiMx4Da/lGWODA75JpgXlp1wwONLJnqTuxYU4i15RTHRy3AuQsYP6d/YNDg==
X-Gm-Gg: ASbGncuyaG8n4CfjsGY2D7VqY6I6RI+nnR0oaEMeFMKcwfYagmJfhLYmp3U6GpnjjGH
	2TH3nb5HOrx0sryTsD0uHENfZ+dHKzpMpiV5VH1JVgGTT2yBp6CV6b27SVvpDubQhBvFWTdI47k
	Isdw9l9nqhVhg9nLEKhv0THQe4z+/JA2DdX47I03SMRhip+4ZqnKfKjPycRinMpfHmC6N9zDfgR
	uQ+WLtzLnWzlVtUpz6hC6B2ZKcGwvZeIQYQRxtp8hwgchZfjXnknpW+xpn50rsrh6QM7IdM9lzM
	FBhw9hUF8Q87o8Ea41CHCExNTLYABvyivdo3OkgEShedhCQTlvuiIDh49l74Jn8t4yYyUN9qNBL
	6Kd9MFg==
X-Google-Smtp-Source: AGHT+IGtRPKB/+Q9Ge4udRxLhd2o6sZguJW0tmzy+145XL5MDm4emH9nCDY7KueOSoFmJsSuDoU+rg==
X-Received: by 2002:a05:600c:2111:b0:43b:c396:7405 with SMTP id 5b1f17b1804b1-441d123f7cdmr702955e9.7.1746526214349;
        Tue, 06 May 2025 03:10:14 -0700 (PDT)
Received: from google.com (207.57.78.34.bc.googleusercontent.com. [34.78.57.207])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b2b20a70sm211382205e9.31.2025.05.06.03.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 03:10:13 -0700 (PDT)
Date: Tue, 6 May 2025 10:10:08 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Per Larsen <perl@immunant.com>
Cc: linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
	james.morse@arm.com, jean-philippe@linaro.org,
	kernel-team@android.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, lpieralisi@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com,
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com,
	armellel@google.com, arve@android.com, ahomescu@google.com,
	Per Larsen <perlarsen@google.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Restrict FF-A host version renegotiation
Message-ID: <aBngABDE-wtpM9o6@google.com>
References: <20250502092108.3224341-1-perl@immunant.com>
 <20250502092108.3224341-2-perl@immunant.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502092108.3224341-2-perl@immunant.com>

On Fri, May 02, 2025 at 02:21:06AM -0700, Per Larsen wrote:
> From: Per Larsen <perlarsen@google.com>
> 
> FF-A implementations with the same major version must interoperate with
> earlier minor versions per DEN0077A 1.2 REL0 13.2.1 but FF-A version 1.1
> broke the ABI on several structures and 1.2 relies on SMCCC 1.2 is not

The wording here is a bit hard to follow. Why don't we re-write to
something as simple as:

"Prevent the host from re-negotiating a smaller version with the
hypervisor. Once the hypervisor negotiates a version, that should
remain locked in. Fix the current behaviour by returning NOT_SUPPORTED
to avoid the FF-A ineroperability rules with ealier minor versions which
allows the host version to downgrade."

> backwards compatible with SMCCC 1.2 (see DEN0028 1.6 G BET0 Appendix F).
> 
> If we return the negotiated hypervisor version when the host requests a
> lesser minor version, the host will rely on the FF-A interoperability
> rules. Since the hypervisor does not currently have the necessary
> compatibility paths (e.g. to handle breaking changes to the SMC calling
> convention), return NOT_SUPPORTED.



> 
> Signed-off-by: Per Larsen <perlarsen@google.com>
> Signed-off-by: Per Larsen <perl@immunant.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 3369dd0c4009..10e88207b78e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -712,7 +712,24 @@ static void do_ffa_version(struct arm_smccc_res *res,
>  
>  	hyp_spin_lock(&version_lock);
>  	if (has_version_negotiated) {
> -		res->a0 = hyp_ffa_version;
> +		/*
> +		 * FF-A implementations with the same major version must
> +		 * interoperate with earlier minor versions per DEN0077A 1.2
> +		 * REL0 13.2.1 but FF-A version 1.1 broke the ABI on several
> +		 * structures and 1.2 relies on SMCCC 1.2 is not backwards
> +		 * compatible with SMCCC 1.2 (see DEN0028 1.6 G BET0 Appendix F).
> +		 *
> +		 * If we return the negotiated hypervisor version when the host
> +		 * requests a lesser minor version, the host will rely on the
> +		 * aforementioned FF-A interoperability rules. Since the
> +		 * hypervisor does not currently have the necessary compatibility
> +		 * paths (e.g. to paper over the above-mentioned calling
> +		 * convention changes), return NOT_SUPPORTED.
> +		 */

I would drop this comment as the commit message should be pretty
descriptive.

> +		if (FFA_MINOR_VERSION(ffa_req_version) < FFA_MINOR_VERSION(hyp_ffa_version))
> +			res->a0 = FFA_RET_NOT_SUPPORTED;
> +		else
> +			res->a0 = hyp_ffa_version;
>  		goto unlock;
>  	}
>  
> -- 
> 2.49.0
> 

Thanks,
Seb
