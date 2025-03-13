Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E824B1531C1
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 19:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741892908; cv=none; b=IVLXhfe0zF9J6loFdCqMVKJsSXAtBwQYEtjPC98cq0f6o6u9G9WAjIQX6Ey7uF9CkN4vCkg+Qgao+aryjQtXFwnOXHQnR+du0UgAIoe3sca7bvOqrwNCzgxH4yW9wTTwkaFTqI5An2jqEr4F+y82NZ36/YqAdaOcvo5f+BaKPUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741892908; c=relaxed/simple;
	bh=zebU4/k/EeqtjpAsS6Cj6e8OZa3BjJTLbL/wQkDK6t4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=do+hxqmmqq58tehuFL4L38VJEP5urZb88NvmPTt6OLAPjaeYaeWXi5D4B3qn6VV81i+y5MPV5XxjC16fcBwbkP/SFh8VckipPPx7q1+dbiquF6+9I+EYjFslVeoDacCLELe3V1Gwd8Hi5Ut239zMXbWvhvGbtHubMSor5hlx8Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bzjjle+Y; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bzjjle+Y"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac29fd22163so229373066b.3
        for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 12:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741892905; x=1742497705; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v8INpOFDdy6zgQZNj++IeYTATBDv20/pe9DlHWL5cZs=;
        b=bzjjle+YltrvwEzPaQ/nIfIGias2mZ7q/2d9WdxlAU5YHfWT33LzxThGy0GzkPPGSO
         xxchSyaFt8D7Q9OcbCQZDbj6vxPqZxi/vZuLH2rMszPjX6u0O+W559oRvIaiAuJkSJDG
         Ek+9h6s9xCReI4mdN+DMHFs3QDAbv2yZXJGUK64DW0/m2LijvUVbPaGDoihHkkvd5wjp
         EoEDxNqPAROHtJBf4l/u/rwqhlah4D/qS9jZF/+s+2wiPnIAG5yRccyC3exaZ5PNdSc1
         QAkhZp88at0Voxry8x26z9cALYWmBS74kDwabIcGNg5PzYus9Ty/xdA/9MIJ6H7vQlSw
         20dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741892905; x=1742497705;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v8INpOFDdy6zgQZNj++IeYTATBDv20/pe9DlHWL5cZs=;
        b=lJtWIgQTD6i32kEHHG9gVdEUzoG8SIiOsaZovardvY85iB7/3pK/tR7mwcTglJuLUf
         iyhDXgLN1cit5ifsCrTacQeroOWcxu+wxdnVkETNKpcAGTm5Vke/xXhBB2uKb4NBJlnz
         q4Gacfof0W5KKtpK9OIdZ7k+GW8tWF5V8xswx+RnXo6mLao/V1HHxQJwIvE8IMj7iJIp
         qvrtKL/j+ftxKf6F8TQPHBHXoUrqHoqj2w/IV3RkVyzMox+uOTVIKq110+8MRrdWWuVy
         18CxlkM85Tfm5UMHB+9QTIa+waVL/PECGntHBjUr6r3oQ0CWyyMyouZSdxuJ8ibbJaDU
         ZdOg==
X-Gm-Message-State: AOJu0YxDu2S1xFGm1hVCYdlzu7EPg4jKB5rIf06da1PuQ4/kZSis4TG4
	6PZMcy0p4nnqfJyiJQehpWT/043Fj9wEoi31teht6eyFaknGxZR5cLqaKiBhqA==
X-Gm-Gg: ASbGnct5nYTPblDAf22SCGivdXDpX7nsRt6Mbb5QFwv3655TDr88NAUj2gp1vbULenN
	b4SBKQmKYHehS8zTtDwQaPhwPrvGedjlIYD+fxH9VF7gVMEfXRmiElBD9caJLWiwNPrhf40IwXQ
	mr0I/iG0Ch4NzHgx6ce2GCNvhhvkAaURb+T5R+PHvnbs6769sGOuerIKY1PW6PJ+11NziVaTqyS
	sKxwd48+tesuvCuY8k1oDdcGI/+SNsLcAAus41wkXCvSK6uXL40S6YZpOLcqQwcpW06gDHQowXF
	EvyR71/HvHW/NPdy8JC/vhkn0GEr+ieMFiTX4aKVD2diooNqtZzom3jDTqRVx2xeTzoA1oYRBpa
	46FlBvLSc8wfRCw==
X-Google-Smtp-Source: AGHT+IFa00JtzqukTdU3WMYr5CjZc1RVh7xO3wiZcNVvi/pVcZene2/D4xio0rZGpWde7c+HTNy7zQ==
X-Received: by 2002:a17:907:9452:b0:ac2:bde9:22af with SMTP id a640c23a62f3a-ac3290943a7mr61434466b.13.1741892905085;
        Thu, 13 Mar 2025 12:08:25 -0700 (PDT)
Received: from google.com (140.20.91.34.bc.googleusercontent.com. [34.91.20.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3149cfb96sm112178066b.119.2025.03.13.12.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 12:08:24 -0700 (PDT)
Date: Thu, 13 Mar 2025 19:08:20 +0000
From: Quentin Perret <qperret@google.com>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	shan.gavin@gmail.com
Subject: Re: [PATCH] KVM: arm64: Drop sort_memblock_regions()
Message-ID: <Z9MtJPNm1pLATGo7@google.com>
References: <20250311043718.91004-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250311043718.91004-1-gshan@redhat.com>

On Tuesday 11 Mar 2025 at 14:37:18 (+1000), Gavin Shan wrote:
> Drop sort_memblock_regions() and avoid sorting the copied memory
> regions to be ascending order on their base addresses, because the
> source memory regions should have been sorted correctly when they
> are added by memblock_add() or its variants.
> 
> This is generally reverting commit a14307f5310c ("KVM: arm64: Sort
> the hypervisor memblocks"). No functional changes intended.

I think this was originally introduced in an early version of the code
where the reserved regions were also registered, hence requiring
sorting. But yes, with the code as it is today I can't see what would
break without it, so:

  Reviewed-by: Quentin Perret <qperret@google.com>

Thanks!
Quentin
