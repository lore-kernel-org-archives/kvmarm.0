Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480454DA1C
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 09:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706780757; cv=none; b=FtBegD/mfGWno9tH6cqOvhfOm5mYfesb0FTa48LyXw4yPi7m4bVWLU4Eb9342LyTzK3uGhNMZsyQ+xMRlNZP50rozYFZW8O8EHxs2CXzgibWJuqOSuJOAItXznpHPUX6CfgSUts3+jiq9h2IKaaXBV3aDEKnPMDQbiNO37/dZdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706780757; c=relaxed/simple;
	bh=aNqWZW6RcqK8RA8lTfX+odywxwnNVRg2P8cqZ4BDSgU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qlwb/44zA80BzZUEQ00wY9upABYxt3qLQT5wgdH+kq66XCdRNNVjyXPWWYirX9NrOsDKPWycpAqKBb6rMM3woX2tGNEo16V3XdSskUz7oD41uw2xVPZSHisHGp5RcJoKMZbXpF/Yppr6onHLicXjj5n0dcTywZrmhtCpRf+eAds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dXjisPIu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dXjisPIu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706780754;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DrVU+bxCb/uw2+gU2fqkwUl2STpHNw8pC2Tx+pltE8s=;
	b=dXjisPIu9NPGwquCDncceSDaCH9pyfHhzjapXl7JjWWBMxeW/2GsB33RYe16MfXzJjswNq
	eAzgt+HhoiCnfmERR16GQ+x0YfHTMIGV/dajjHfOH38w8y8Vd8kbz5vqrwFO6sBDRcrg1v
	CEZOVkvknb2Z9v2QFCrA7AkVoibUWng=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-P4IyO09MNYGAmdIvhw2dwg-1; Thu, 01 Feb 2024 04:45:52 -0500
X-MC-Unique: P4IyO09MNYGAmdIvhw2dwg-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-68c4ea596cdso8149646d6.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 01:45:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706780752; x=1707385552;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DrVU+bxCb/uw2+gU2fqkwUl2STpHNw8pC2Tx+pltE8s=;
        b=vXWTaxCfa7yek9DRwGtweTOZqj6v508zwIzE4+8V6tC1UQLyhwZesvFtPub3xzpOc8
         C9N1sXXmwa9QJ5K6nmzTjm1tyNUd8bF88KgZJyCme61XsWC/um3b3qz57RPqn2o5YB9n
         4CTuQBtwiuh5z0+BsU0uPwQqnu/cHsIFTB12Dro45lr8kzr71+JNPtbenJjXa9IkP9AQ
         GmLI6w6Ab1nIy04zqd2p2EEM/ZHqZvjcQUAQGiLhhuXA4Cr3Sj54RXnNjZ34d3HJKgjW
         OrfXlpNhcwOi8wWBzUHsHqeFeUWI97QWkAgcjbWJlb3q5AMRpwz9n/nsV+qSSmOG/ZWK
         M0Mw==
X-Gm-Message-State: AOJu0YzmMoeTWnZOBrGvVv7slPyKUCrS4fc73NBbR2GNr4ZMGWHWV0Nr
	mIyLRGN7xsxwkTFjZ2Cu9draryt3iffEa99fYZD5ygka1Sz6DsFJ42UrVHPRXclyDbrSwC7J1tH
	nNL/CZHRA9Zq9R9+LXHliketsdbzAhgmJ1WZ5LdOuyIPdnk9KdzES/A==
X-Received: by 2002:a05:6214:1314:b0:685:a8d7:4c24 with SMTP id pn20-20020a056214131400b00685a8d74c24mr4751658qvb.32.1706780752225;
        Thu, 01 Feb 2024 01:45:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFG28NP3prMqpJ8rQDWnq3QonHb0ZxcexPRck7gHhbp2xafjHdgp1Ueix8Ur/1n+r+ZLdchpQ==
X-Received: by 2002:a05:6214:1314:b0:685:a8d7:4c24 with SMTP id pn20-20020a056214131400b00685a8d74c24mr4751642qvb.32.1706780751974;
        Thu, 01 Feb 2024 01:45:51 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXXSldVy67JtjS3zYuvLQ7dLV4xY/2lUtZvTKDaUuT0poXQEL5joBK+zCKbk+yFEg7eH7J4zGbGgVU8gLcIS2J0NtDzyEml/cW46f8HI9Ul/EsGro9DzrmVJYV83VPhR91gxoNGWiB9CYdGp24L8KdJ/kzwUm3oEt5OwURZHUKhPZO1lYPEeEOxPRxA/3sI2Xbh/OFBpmmc8ozfV+kKjCwC835yioAfFprDR7EzY5RKi1sqUcUC3Z+nFu2F9628d8GmbL/RsepRn4w+2Byvm7KkE90IojwX7w+6wUnCnrDy3X6dCVlv7/A=
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ma4-20020a0562145b0400b006843f949b29sm6375102qvb.16.2024.02.01.01.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 01:45:51 -0800 (PST)
Message-ID: <9087ae37-e42c-456c-a9f1-b62fd101e9e0@redhat.com>
Date: Thu, 1 Feb 2024 10:45:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 21/24] lib: Add strcasecmp and
 strncasecmp
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-47-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240126142324.66674-47-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/26/24 15:23, Andrew Jones wrote:
> We'll soon want a case insensitive string comparison. Add toupper()
> and tolower() too (the latter gets used by the new string functions).
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Acked-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  lib/ctype.h  | 10 ++++++++++
>  lib/string.c | 14 ++++++++++++++
>  lib/string.h |  2 ++
>  3 files changed, 26 insertions(+)
>
> diff --git a/lib/ctype.h b/lib/ctype.h
> index 48a9c16300f8..45c96f111e19 100644
> --- a/lib/ctype.h
> +++ b/lib/ctype.h
> @@ -37,4 +37,14 @@ static inline int isspace(int c)
>          return c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '\v' || c == '\f';
>  }
>  
> +static inline int toupper(int c)
> +{
> +	return islower(c) ? c - 'a' + 'A' : c;
> +}
> +
> +static inline int tolower(int c)
> +{
> +	return isupper(c) ? c - 'A' + 'a' : c;
> +}
> +
>  #endif /* _CTYPE_H_ */
> diff --git a/lib/string.c b/lib/string.c
> index 6d8a6380db92..ab6a724a3144 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -54,11 +54,25 @@ int strncmp(const char *a, const char *b, size_t n)
>  	return 0;
>  }
>  
> +int strncasecmp(const char *a, const char *b, size_t n)
> +{
> +	for (; n--; ++a, ++b)
> +		if (tolower(*a) != tolower(*b) || *a == '\0')
> +			return tolower(*a) - tolower(*b);
> +
> +	return 0;
> +}
> +
>  int strcmp(const char *a, const char *b)
>  {
>  	return strncmp(a, b, SIZE_MAX);
>  }
>  
> +int strcasecmp(const char *a, const char *b)
> +{
> +	return strncasecmp(a, b, SIZE_MAX);
> +}
> +
>  char *strchr(const char *s, int c)
>  {
>  	while (*s != (char)c)
> diff --git a/lib/string.h b/lib/string.h
> index 758dca8af36a..a28d75641530 100644
> --- a/lib/string.h
> +++ b/lib/string.h
> @@ -15,6 +15,8 @@ extern char *strcat(char *dest, const char *src);
>  extern char *strcpy(char *dest, const char *src);
>  extern int strcmp(const char *a, const char *b);
>  extern int strncmp(const char *a, const char *b, size_t n);
> +int strcasecmp(const char *a, const char *b);
> +int strncasecmp(const char *a, const char *b, size_t n);
>  extern char *strchr(const char *s, int c);
>  extern char *strrchr(const char *s, int c);
>  extern char *strchrnul(const char *s, int c);

