Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D5F18035
	for <kvmarm@lists.linux.dev>; Mon,  7 Jul 2025 16:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751905887; cv=none; b=nFo/HOnBuKgRFsK04Q3NuYUb5pReYhMrE4c1RIb/V0rkhv3fuM+BmVxwxb1Nj7F2FZE/OIvH2Gji1hHwsvlpIxQjc4RRLZU+h63qkWaaQk2CbRDXGzNXKO3UcSgJmXbPahLRNYHiz3Ck9065nHt74FUVWliizpjt7lFxAJEJGHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751905887; c=relaxed/simple;
	bh=CTGTIMfddBoIpV0RuG6mIYxA9hlfuIrcvXHD4cWlliI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SeIpEvUyFLqDbDubUxJFXdoOntAQBpE90YDz4pO0FzbLQoYqStDU/7Mdozsig4KOQOGbrU2CZO0pjPiETB0ew8ZrNV2EMYaRpfCdqWeMgEE3/nmGqu53W6xgxh5F5V/O8l1B8+aE2EhAbGCJObQrNIfVZPm1AnnhB80JnXtloBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZNHNZ76x; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZNHNZ76x"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-749068b9b63so1955019b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 07 Jul 2025 09:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751905885; x=1752510685; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T65upEdCDY7gEQSF7YmZBvbMiIUrTEJa2opQbxpVZOA=;
        b=ZNHNZ76xBNYS3+fyXEx8j//tqEy3/MVPn7jBDVUrsjpiYJq0BS4H50Je5qtPz1TzbS
         cr98zKluPMF7VA5aN4M1j0MNS29XJ80bdWxVwEzlEPG+rfpfeSuxxNEqhwZxIugM/UG5
         f0/SZJNXgE6mvlAK7izEptY2n2Ae75OMfpo2O/eOf550CeS5oQnCi+cWTSoqE3empRGv
         bMX8MS5nEsV5x75sTBfCeyJQDvTAyn4dsOfxy6RNiuQ7NErUw7GAu4B8VDjIA9/Im3TA
         7JTP2ReefNLX7uUtOlZVOU/boa9g3c+UkTpMMP+MODj3fn6ablz3ykoxj71/m5z8JLY0
         hdnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751905885; x=1752510685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T65upEdCDY7gEQSF7YmZBvbMiIUrTEJa2opQbxpVZOA=;
        b=wkBFIv6aDl+leZlC61iAAduZpUzbOe4DQ6m9LMkFoeLYt6gVsYMI6vSAvhUSsSowqg
         5bO/WsYGhdwtb7nP4JNBdf7nvGyANXt3SNwlW0PJgR+lAyjgxV+6PjIurblBVUWHkTAb
         /lnaqyetRw4zlAV70oECGatVNzhNhuWzOq2ey7uSzSu+rAaEvgjhQRt6qCMUImfV0VoP
         PX538ja8Flej+hnu4YaV/g3vZIrwDfohHxyE5fbT7C7fJYYYuq11BStu67kI0IPBgM4f
         tnsut5yNlnIkB/zjJs++foVXJMJhK4QV0KYuLwE3hh99FJROBvpzLE+vEdp0gUokv6X5
         aLoQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGcKD3nIz/ey0npvdNfonlSxQzV6p8xggA5q9LQLXATJl64Qo61V0fEcHBy53gpSxwIlr/jp4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxN+4oP+NMrODHQ8ybDEp06wMLfO+BnlDkXishwv/SiVDaQDN8
	vClBVXsls2ICCJqtTRb+b7Htq4/fJZ2YfgtyYSLvWx8YFIXd5x6ANSWCEvAHlw==
X-Gm-Gg: ASbGncuCGLAIpaaJrVwYTMhXV4f5fNAFHinJP6P+owB4quW9uQeVWEzJfPynOrJ0U06
	kBZ4NqTCrrjEoC7QhaJHTtLOdiybv8oDWolTiyqrz5AB9h3kfdnje+v4mBlA7WPBf23uR7qM2gT
	/ZIYacATAj9Fuv1yWmRXOKj8f1yOTYkQlxGcnDi9tuqvJWwL+pcy2yKy1XFzYVG5AttfLYxLiWH
	pQGQKHtK03/UWhkQtiEFNKwxv3b6pOZPZcw5dTIv0QMFvcRlngOYy9SJX5AZXL7+2VgYgnMvCKi
	cqqlb7gLLp51ZS1wUR8oHG1UYmWVwi2HeG0x8lSW5ExVQy7avEE/RLYEnMvXSA==
X-Google-Smtp-Source: AGHT+IE9LUw0GOAkRdv3EbKLvPJ2vN2Wm1zWt6kB2645lDr4uxnf9kEor2mDWupUMMQ9E1c4bRBisg==
X-Received: by 2002:a05:6a00:2409:b0:749:112:c172 with SMTP id d2e1a72fcca58-74cf6fd8194mr11055113b3a.16.1751905885276;
        Mon, 07 Jul 2025 09:31:25 -0700 (PDT)
Received: from localhost ([216.228.127.130])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74ce417f765sm9231493b3a.75.2025.07.07.09.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 09:31:24 -0700 (PDT)
Date: Mon, 7 Jul 2025 12:31:22 -0400
From: Yury Norov <yury.norov@gmail.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux@rasmusvillemoes.dk,
	linux-kernel@vger.kernel.org, james.morse@arm.com
Subject: Re: [PATCH 2/2] bitfield: Ensure the return value of
 type##_replace_bits() is checked
Message-ID: <aGv2WoAtxnEgqV4y@yury>
References: <20250703135729.1807517-1-ben.horgan@arm.com>
 <20250703135729.1807517-3-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250703135729.1807517-3-ben.horgan@arm.com>

Hi Ben,

On Thu, Jul 03, 2025 at 02:57:29PM +0100, Ben Horgan wrote:
> As type##_replace_bits() has no side effects it is only useful if its
> return value is checked. Add __must_check to enforce this usage. To have
> the bits replaced in-place typep##_replace_bits() can be used instead.
> 
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
>  include/linux/bitfield.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
> index 6d9a53db54b6..39333b80d22b 100644
> --- a/include/linux/bitfield.h
> +++ b/include/linux/bitfield.h
> @@ -195,8 +195,8 @@ static __always_inline __##type type##_encode_bits(base v, base field)	\
>  		__field_overflow();					\
>  	return to((v & field_mask(field)) * field_multiplier(field));	\
>  }									\
> -static __always_inline __##type type##_replace_bits(__##type old,	\
> -					base val, base field)		\
> +static __always_inline __##type __must_check type##_replace_bits(__##type old,	\
> +							base val, base field)	\
>  {									\
>  	return (old & ~to(field)) | type##_encode_bits(val, field);	\
>  }									\

So, would it make sense to mark _encode_bits() and _get_bits() as
__must_check as well? At least from the point of unification, it
would.

How would we move this - with my bitmap-for next or with arm branch?

Thanks,
Yury
