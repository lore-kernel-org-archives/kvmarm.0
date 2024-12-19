Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4240A222D68
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 11:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734607391; cv=none; b=ejYaX0hJclcFSHUwtw4mYVSdCxiWxDntOeX1hxob9ToiGhH47kB8DvIqq+GtdQ/Wpvw1jWoB6apPCJsw+X9dNOKhgvlxkkTN4G0g/uOIudBNwfFtIgtBYR0bJ8wWG5SFk4YGZ+ghL6hE5HidGfLzXDsds0ER41ivgtXa1N5Uzec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734607391; c=relaxed/simple;
	bh=4zgfT7Xg+JQmuyr3IdhaXo3BVOo4fRBTlxoKmbMDBiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TtLp1LjjCjoZBCgEmlRxoU23V1BpzpDiP6aq3UvZNXox8D3C+JHc+YF3Jmq4ewmwSckxhabjdcLxYLxcHw0FpbJuAYOdnm8cUocn5GylponyOehhJqxT/JMg3rknVvuSzR9OH1zvqpOyxAt+fWZKtgQDYbDybqyxaKNyLjT1mow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lW9dw0gJ; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lW9dw0gJ"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aa679ad4265so299610766b.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 03:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734607387; x=1735212187; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MNoCLTk5PLrDllVxHnAKqOI/0xe6p3W8/JGr5L06//I=;
        b=lW9dw0gJ+ZtMhbq43uayXZBHkNauVkujzzy/dMpLd4MdZdCIvXgHZwi2jbkO070PjB
         xPwatqR7tsntpfR12vR57Xvmf7cag+CCN1m61/j45+Na/lRbwHbvPvJs6mnD+qGX4aU3
         XtN2bwvCEK6zKM01AU61VDXZrgmkP9LhoNqa+olTfguPXUbdynuHrEXMkC3c7iHeajKG
         5B48zmAZ76KMh4nIX9VHY/mlcHP3SPCdsAi69JGf+ln1dKTXjp+4JHKcs7D8Or1qPYFE
         3RY888/kD8xQ5OnH+LSRR41BWUYMc+h1QMNKzHuIUUtLMgZGGQ+Idf33wduf0yd94ImO
         IJcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734607387; x=1735212187;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNoCLTk5PLrDllVxHnAKqOI/0xe6p3W8/JGr5L06//I=;
        b=D+5yJguBjRUFmtztfiNpMF6yYVriHbS3zqZY1AOeorIZ6/C/E7VydwFMxd51rsVkc/
         +5ASrNf8b191VGHIjmVwZz6xqgmpDLnOfPvzBJCQD5mIf74BBPL8h55kKIikvwZXEP/Q
         Xjlpj7IPI5swm1Q2+qQ/XHKiOHVH3wIeAz9I/Xs3wMDEkfYV98e43eJ5FoJZT7m7NT3b
         qkLhj9OGCv3pmF7Fv2W44xNoicRKIsuU+9heaeyCIx+bpLHrjFDAmNNheeC2UzUw1xAR
         Yurhl6SJDjc/4JSokhQPkv31uTZ6Xn1DSVDbl4lFK2xCP6Dfbw8nfFXyVg0hbXMHq5es
         DbCg==
X-Forwarded-Encrypted: i=1; AJvYcCUnm5+m3Ap/zpILOGSOCEoFOPtrQ5qz2lWV9XhBvhtjPyXuHoshE2mBEHd6WFfLPA2mtzLznyM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTTs8jUT8e0/X2KfUbwIc2M8VryAOUBD85zzNvT/wPyepjwHtl
	fOO/aOyZL5Mtoaa6WG6KQDI7gwwh8vyI/dmpdm7LrOG6fCdzGmRYnvOdHu6lzg==
X-Gm-Gg: ASbGncsk8iyJCpYDZL0d2EpTRhz0Q5OYnpRoIP3AxOBWyZ5SsFp+KcLAeGjnlqtgxz/
	s7/j+t2VIpQBw+ZwEi5nvgsx952ye0hNaMuZU5qooTylEqr6mHkRDq14uXGDqB3cXmPx9mIEaDN
	fYs9rQRmSaSAAIPPidq62QYaMVRdaVEdG4p1qNtq57SWU1hiE0SkwVyjKQ0z3L8923hINxLrVSr
	AtFvzBtGpytkefyJ84P7RLN4urVL7jxK+hLTl0nxDUrRHkNS9XnsXNnfPKsE/idF9rGJHA3avOL
	ADCNTaQmgzJKv2Y=
X-Google-Smtp-Source: AGHT+IGBbkrBT1+E3hcflKVgebxmfU7Se8YKjT9HtDdCtUo3a97FGuUSH0zyshOzjTlEgkesB5a4qg==
X-Received: by 2002:a17:907:9615:b0:a9a:6c41:50a8 with SMTP id a640c23a62f3a-aac08155183mr234984166b.17.1734607387303;
        Thu, 19 Dec 2024 03:23:07 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0e82f31bsm54976666b.1.2024.12.19.03.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 03:23:06 -0800 (PST)
Date: Thu, 19 Dec 2024 11:23:04 +0000
From: Quentin Perret <qperret@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org,
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca,
	nicolinc@nvidia.com, vdonnefort@google.com, tabba@google.com,
	danielmentz@google.com, tzukui@google.com
Subject: Re: [RFC PATCH v2 12/58] KVM: arm64: Add __pkvm_{use, unuse}_dma()
Message-ID: <Z2QCGFN5V41Vux6Z@google.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212180423.1578358-13-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212180423.1578358-13-smostafa@google.com>

On Thursday 12 Dec 2024 at 18:03:36 (+0000), Mostafa Saleh wrote:
> +int __pkvm_host_unuse_dma(phys_addr_t phys_addr, size_t size)
> +{
> +	int i;
> +	size_t nr_pages = size >> PAGE_SHIFT;
> +
> +	if (WARN_ON(!PAGE_ALIGNED(phys_addr | size)))
> +		return -EINVAL;
> +
> +	host_lock_component();
> +	if (!range_is_memory(phys_addr, phys_addr + size))
> +		goto out_ret;

Nit: I think you can do this out of the critical section -- the memblock
list is guaranteed stable by construction.

> +	/*
> +	 * We end up here after the caller successfully unmapped the page from
> +	 * the IOMMU table. Which means that a ref is held, the page is shared
> +	 * in the host s2, there can be no failure.
> +	 */
> +	for (i = 0; i < nr_pages; i++)
> +		__pkvm_host_unuse_dma_page(phys_addr + i * PAGE_SIZE);
> +
> +out_ret:
> +	host_unlock_component();
> +	return 0;
> +}
> +
>  int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
>  			    enum kvm_pgtable_prot prot)
>  {
> -- 
> 2.47.0.338.g60cca15819-goog
> 
