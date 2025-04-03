Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C0624C080
	for <kvmarm@lists.linux.dev>; Thu,  3 Apr 2025 15:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743694315; cv=none; b=oHFscsTDGmV0jdECWOdDxNK4Cbshc+DpwEIgNjRdOIxjsD4hQp5auJdrxOqQAE1Mkt7ASBRsol4KpmRuZZ3p+/aQui4ERbAJX7nIQolNJdVW6+Zq0JektY0gSARkbOMunOEvLn2ZRvAp3htj2ofn6Gl0yr0CyoeuGwm+euSYwrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743694315; c=relaxed/simple;
	bh=KPQddjkqY2woTfI2cLtPZbW+MJntKMtuNGsZM5WDnFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T9lpLxeMxQv3NFbkIopqyOgG/yIXBtaen2PE+1tEkrP2GmeIoQkk59nrAL1ady28/opK+atgTf01b336n2J3R4aphq1duHoh/n5OxlDCq0xBwd80Ejg0KaCajMaMRl9KW3HZ3e1tZGAOl95oEhirX0y8EuKSkFJlLpCVm2q+E34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vpy1M60v; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vpy1M60v"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5e5e22e6ed2so1542961a12.3
        for <kvmarm@lists.linux.dev>; Thu, 03 Apr 2025 08:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743694312; x=1744299112; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2SVexGeljhSdSxj9UAkbIi7n+kiPxQUm8cURRQIGIRA=;
        b=vpy1M60v/24jx+mdAoEALnK4iDFm47VTuEGJDMB4OX7qHWxP9aAT/LSpCU7GdJqHei
         ExMPex9LLXrG1SYRwqTDB4KD29BVHceGC4gWpiBZ/Ug6db16Oj5lrHgUG8bUzgdKbXRv
         7HHuUYYe7OLdErwj1xMSjyMjpZhm2NKRmmlzdLO6VwrmHZlRBInXaYOBe5rtq7KAkVxf
         I/bC7GlgYfXJoNehwkTKV1gbi8xTWtFbQ+TFyPhqppvpvTCnV167WZK2+RGWDMjqIIHY
         9alQNMUlo0qG7aUHa8823WpQCd3/KBDkteTaWbgtpWF8upcOgsfwH3sK21UBEuccIUgG
         gUEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743694312; x=1744299112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2SVexGeljhSdSxj9UAkbIi7n+kiPxQUm8cURRQIGIRA=;
        b=AR8ED/gBxrOOYK9MrxHyicvaJRdGH5MCL6Ha9J9AwEdyJlLUZw6Oq+h7cY3amQ9NjZ
         EOh8g5MgB5TuF1NaoNbcf+WDlHADIatXgABGPVuTAo9vLvIpMYKXAkLAt0Aij631h3V2
         hUFVCJwbR4S3EAYH3i53kxW5uyXn5SGv6XgsgbdRCDhgoJD97d/HTFJk3kDTwlysT6IY
         9TlAoStITVvGgJ5Rv8D3WN4L9mX3yVTU9/6z6hpjSCTWQf9/9JuQ4Gr2gdYIK4G880l/
         q9BV9V9wp3NtEhVjHI5zp5+C9QMU/E7TDWyMaoBjCw+4n+2PYUKjUt6DTsD2xCtr/6el
         JKoA==
X-Forwarded-Encrypted: i=1; AJvYcCUVtiCQ9q+NJUKTEsL+pcFtqRy+KeoLzwkXm2eL5YHwK40bEqQ6PMC5hydp5indO1NhQWbFp9Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YwHBtAKktxxvf0wc9twsWCwx0UGH/xFPivU6WKqX2Ve3zkWtyYi
	/T3KjbSHeh12Y5Kuh6H1zGZCqpA5Q0+UiQcx9sAznk9OhK+eJZHORCjBOuknUQ==
X-Gm-Gg: ASbGncs6oTOV7QYJQ1BckUW+AVATokbkWqhfUr3kRJqePUtqU6uRipTGAQ3cmZw5NS+
	//kqTFpkUjuqYRUiTCPVdXZMMa0+eUNXMXx4CWrKr6F/b24we05zJYBocHQRCBcYkErk4XRUvlQ
	ol/0D3VixxFMqPdQGpL46Ua8jCE0hKe0fPAsIiUDSUHvtcGQRoka0juh+Z4F9ZN9iU6f+b0ks5Z
	poOrZJwSf5JLewBIg6Xz0X4f+zxT5RALyEwPJKQAp0fM57VHqNbHnOvrZfAQqxUiI5LlRfPO8Cv
	e+EEeHBVolbUEDAbWVxcZF7XCGpDVgGaKPD7Ij7NjSl6b4U3e7ChKsov+ftLX78pj5BMzygT7N/
	Zk66SRcFIX6WSfFT5
X-Google-Smtp-Source: AGHT+IEGEPfe6jLP9yTD8EczNIfaOYVt4yM5HvzJTIY1ayuEiVqh4iVP20QX+O0oM2W0n9OiZudOCQ==
X-Received: by 2002:a05:6402:1e8e:b0:5e1:dac1:fa22 with SMTP id 4fb4d7f45d1cf-5edfdafe39dmr16976129a12.21.1743694311816;
        Thu, 03 Apr 2025 08:31:51 -0700 (PDT)
Received: from google.com (40.162.204.35.bc.googleusercontent.com. [35.204.162.40])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f0880a4027sm1097010a12.73.2025.04.03.08.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 08:31:50 -0700 (PDT)
Date: Thu, 3 Apr 2025 15:31:47 +0000
From: Quentin Perret <qperret@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v2 3/9] KVM: arm64: Add a range to
 __pkvm_host_unshare_guest()
Message-ID: <Z-6p49EcsZKid7L1@google.com>
References: <20250306110038.3733649-1-vdonnefort@google.com>
 <20250306110038.3733649-4-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306110038.3733649-4-vdonnefort@google.com>

On Thursday 06 Mar 2025 at 11:00:32 (+0000), Vincent Donnefort wrote:
> @@ -1012,51 +1011,52 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
>  		return ret;
>  	if (!kvm_pte_valid(pte))
>  		return -ENOENT;
> -	if (level != KVM_PGTABLE_LAST_LEVEL)
> +	if (kvm_granule_size(level) != size)
>  		return -E2BIG;
>  
> -	state = guest_get_page_state(pte, ipa);
> -	if (state != PKVM_PAGE_SHARED_BORROWED)
> -		return -EPERM;
> +	ret = __guest_check_page_state_range(vm, ipa, size, PKVM_PAGE_SHARED_BORROWED);
> +	if (ret)
> +		return ret;

Given that hard rely on kvm_granule_size(level) == size above, we should
be guaranteed that the PTE covers the entire range we're interested in.
So is there a point in starting a new page-table walk here? Could we
just keep guest_get_page_state() directly?

>  
>  	phys = kvm_pte_to_phys(pte);
> -	ret = check_range_allowed_memory(phys, phys + PAGE_SIZE);
> +	ret = check_range_allowed_memory(phys, phys + size);
>  	if (WARN_ON(ret))
>  		return ret;
>  
> -	page = hyp_phys_to_page(phys);
> -	if (page->host_state != PKVM_PAGE_SHARED_OWNED)
> -		return -EPERM;
> -	if (WARN_ON(!page->host_share_guest_count))
> -		return -EINVAL;
> +	for_each_hyp_page(phys, size, page) {
> +		if (page->host_state != PKVM_PAGE_SHARED_OWNED)
> +			return -EPERM;
> +		if (WARN_ON(!page->host_share_guest_count))
> +			return -EINVAL;
> +	}
>  
>  	*__phys = phys;
>  
>  	return 0;
>  }
