Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A4E2144CC
	for <kvmarm@lists.linux.dev>; Thu,  5 Dec 2024 10:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733392978; cv=none; b=uJWoUboFYER7ngK/ufY9dUv9jxPxOAvXErERzZJiF/YHLRw25W3o94YBZR+gmcBRsZeNa0VTaVSv4AW3rNWK+Fk436wpJ4LxOTUywK5ziejyNHscwEyKHnwTtsmeeFDgtNHri75LW2S1yig+sBM5xrpdp2R4ZT5AbD5LjTvuB0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733392978; c=relaxed/simple;
	bh=LvkMfRbMkc3UJedkuhSesFiMUtwIfWIIsDgAKT96qtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p9kaLvNx0M4sWnZD03aekhsQf1l4TqaWEVf2BVtBsRXoJhyV6WySxVZCoUSV4zGCOHkUrINEowswtYQYZL34xXmpHo4wdtVflcEHTQpQFKgzPK/c8Ynvkxof+YAb36ucA6O5v0fLGrAw+IVn9uXlAKU6wDuGE+ECSy4xF81iiFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KN0vGAaG; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KN0vGAaG"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-aa560a65fd6so127441866b.0
        for <kvmarm@lists.linux.dev>; Thu, 05 Dec 2024 02:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733392974; x=1733997774; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9IYXa/40G7joZADcNJXVHtQr7MJC/A4r2U/Fvo3+xRw=;
        b=KN0vGAaGUlvucbNXrZ4DVKwLxEoHrN4/q7oUoUWXldHDaDVuDkeVe2mCKZKA3D48eD
         93m1oyWCsxuAap6ROSbfQVwZEaDNK/rZakcnDgqIKdsbB5s3szL0IJ51wdpUyIel85yx
         8Xe/IlPBSYHUTy2IaiUirQ/2eWTG5/sL3lETCMuydnN40+PY+L/oCOEa2V16ISwxc1Il
         L7mXftalJoNa2XaEBQIm+JUQ9mXBg+LlbNhr2m/017uwb9QQkPBkghEPKY3z8Rydfd++
         inKBao6Zt2UCzE1I2Q+BYaQY/hNWrJgOqltbSRXBuiY1qPjR4f8cBa8gWxYuCUmzwoor
         1F/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733392974; x=1733997774;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9IYXa/40G7joZADcNJXVHtQr7MJC/A4r2U/Fvo3+xRw=;
        b=qO0EIln/J32Bn2mw4nj0RtnHNq2iI7GIkS5RgOOxyTDIysI1TMLIyWHc96k3h6QtIm
         2kJQO87XA3yIYyd6vGKpJCC/qUl6RP9+QHeXczOpeCQBMrc3YNxn1F/Z4MjiXE4AZLAH
         mvl/tRv4nuHfRWO1wniTy8DdCB8njwEkUIDmSiWcPQEBvPpNtKIpdqdrMEAuO7hOGU0g
         KwgH1TBwa0h8hztch5016clAotSdXGIMcCreN85po3/jfrpOokztSRxlq4rXSkdCm9Ft
         ccoS3AMuWLtR4Q2G5iOPJ2VE+kOQI4FPHwVz0x1GIxYY6LzAOEQtI5grTadPSkppHu79
         CWPg==
X-Forwarded-Encrypted: i=1; AJvYcCUet42cNQMdtqDaou2H8hnSs2Mt2VnTsvf9ce3d29acQ5Vw8br91eMxKmEbk4HTz1psNDAC4HM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzKir96EssqShM+Rd85Jdb0oIpILeA72XAkgL+Qfb3HQNnGG1VS
	quzoH2GieRxrdDpmcNjEomg7Q16P0VfDw22rMqfO42pS+cbWyi6XdammpV8XkA==
X-Gm-Gg: ASbGncs3O1EB1L6hVtBlO0/146xzpQmusGHdviQrwNmR1q3Lil0d+PyzAZNDCaUwRNo
	cLJeIOc/dOr5fiZQqmBL3o+whCbkJMs8K6dxB4JYOj9gmTR3mD/CuggPYyy0Moco6gKBeSfiwXD
	mns9W5hBrJnLUk3wP6bJ8EZl0nXa+OCwVh9ZJsIg5mDuYzXr90skiXXDFTsJJ+4xBbs04/+k6nO
	3vZS9RaXvXHsIjz87tpRArQzDUu5eCtzpAPWVqwse0VlAQP5L2E3Mi06/5hX+oDRykiwer7Y96c
	nHRY7oic
X-Google-Smtp-Source: AGHT+IEbhaHnvcO/xjmAgQQ/5FSK25YVud/dNBmZ9dieMMOF7KaYUX8uT/6vgqqWi0UM3CwOtDPrag==
X-Received: by 2002:a17:907:d86:b0:aa5:340a:fb48 with SMTP id a640c23a62f3a-aa6202e0911mr233913266b.6.1733392973962;
        Thu, 05 Dec 2024 02:02:53 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa625e4db84sm70268866b.41.2024.12.05.02.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 02:02:53 -0800 (PST)
Date: Thu, 5 Dec 2024 10:02:50 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Always check the state from hyp_ack_unshare()
Message-ID: <Z1F6SpUQVPdjllUG@google.com>
References: <20241128154406.602875-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241128154406.602875-1-qperret@google.com>

On Thursday 28 Nov 2024 at 15:44:06 (+0000), Quentin Perret wrote:
> There are multiple pKVM memory transitions where the state of a page is
> not cross-checked from the completer's PoV for performance reasons.
> For example, if a page is PKVM_PAGE_OWNED from the initiator's PoV,
> we should be guaranteed by construction that it is PKVM_NOPAGE for
> everybody else, hence allowing us to save a page-table lookup.
> 
> When it was introduced, hyp_ack_unshare() followed that logic and bailed
> out without checking the PKVM_PAGE_SHARED_BORROWED state in the
> hypervisor's stage-1. This was correct as we could safely assume that
> all host-initiated shares were directed at the hypervisor at the time.
> But with the introduction of other types of shares (e.g. for FF-A or
> non-protected guests), it is now very much required to cross check this
> state to prevent the host from running __pkvm_host_unshare_hyp() on a
> page shared with TZ or a non-protected guest.
> 
> Thankfully, if an attacker were to try this, the hyp_unmap() call from
> hyp_complete_unshare() would fail, hence causing to WARN() from
> __do_unshare() with the host lock held, which is fatal. But this is
> fragile at best, and can hardly be considered a security measure.
> 
> Let's just do the right thing and always check the state from
> hyp_ack_unshare().
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index caba3e4bd09e..e75374d682f4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -783,9 +783,6 @@ static int hyp_ack_unshare(u64 addr, const struct pkvm_mem_transition *tx)
>  	if (tx->initiator.id == PKVM_ID_HOST && hyp_page_count((void *)addr))
>  		return -EBUSY;
>  
> -	if (__hyp_ack_skip_pgtable_check(tx))
> -		return 0;
> -
>  	return __hyp_check_page_state_range(addr, size,
>  					    PKVM_PAGE_SHARED_BORROWED);
>  }
> -- 
> 2.47.0.338.g60cca15819-goog

Shameless inbox bump for this one :-)

It should hopefully be a fairly straightforward fix.

Thanks,
Quentin
