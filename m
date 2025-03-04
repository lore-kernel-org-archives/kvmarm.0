Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF971FE478
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 09:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741079014; cv=none; b=oYF9byxGZbEfntep84L2GIH4PAr/wqR4T/ordbhvdkgmocGsyHIr5L1f/tGj74oAiC5yH2igMD5A3tzUGR+6RArVsGufckJZ0X7LDi4P9dms1g9quCzMDRHcUNPCCBMEmE4+TThBJZyKpnZfVz3k4Y6uH77PoranAq9p6TbFxdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741079014; c=relaxed/simple;
	bh=pD2QlyVVHGAg8ptt/VjbZEKq6kOGSccucp9idXzSK1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d+Tee8BqTd2iAOwxRVF7ChWeSfMoL3NjwMeRkagSfUxbPdw1KCpJ3ycq+pXMbZSsmOHqDoCx2H+fM4hGxkM9FRxkRu9ZzsBNPHET9lZQ9f4CujCSoNTqkWGkw5VYa1x7tBgenA5tnh6pOQW3buhGIdD4z/163dhB9LkdBxc5t7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U19dlO1t; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U19dlO1t"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-438a39e659cso36317275e9.2
        for <kvmarm@lists.linux.dev>; Tue, 04 Mar 2025 01:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741079011; x=1741683811; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c/pyfoaR/eT3J3WSzi9ciqMZLn3faPQuYj0+Pv+ikCU=;
        b=U19dlO1tdnx4XeZKLQAGvEsjkmzYvI8MTHex11OW9rl88ziyC4P505oDsXn8v/rtSc
         RT8vJ60yk7zJeOWwIDhjc5LFlxwkIzHFsGA5gMF8Op4oaQXpnQQYoKNSR8mLwzSr+glB
         YS4C/ZW/A+odk81dSv6n2wZNIEI0o75s9wfEfLL3K4k77naDGqhjSvslZq8F7fY+pwkH
         xy5hhXx1nPd8olDj3zwvimE745YlnDhvWSvz4gJt+EBMee0rKlvYHd5LOTH9zC+Tamus
         fzUruriMjPdOISMdNM1NQrrMm3yHHTQzbpdwR9eikswZqOa5Uc/AvGHCrwOIfygOZsaF
         hBtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741079011; x=1741683811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c/pyfoaR/eT3J3WSzi9ciqMZLn3faPQuYj0+Pv+ikCU=;
        b=qD7Jddcrc1IDUQCmJOEWLgfe9BBrlUibDJaj1hykhzHtsaw/U29NpBTLjkJhbgK/AD
         I5C95Wm5ey302h3Ef2x28NfNAnXiavRoTSyRPiU78LTiES64FiZ6rEk5Wq0Lh8IkqMAJ
         2aYFyuqZ5WlkVHHNZlSPCi6tEbNspkX+u9YRjS+TXUOIvOwM8yAOcmZFmpuzNllCffk4
         EU8J7drdo0OVWVUCrDt+iYk5oIM2WKqCb3chkb8o9zodaMs6knuwA6xmuHz/F+FRiq/1
         i0D6TjtN5+51LOBYc6bPe0hPPLbqqP4ifo8ZwaiV+HkHvw6dZLRbOeTnmdHT0It1mcox
         ZOIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDKZT5XYacjg3177nrSVgmB7NQZOmwudIBEtRwiSwd0Hms9K2TMoRODbhJ6YrlYttwTfP/XJc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwiPMcu1K/i8hiCShbnIkpD3aAVxk1naC0AKGEjiZZ/P8y9Jwmm
	L/hYjnfs8PBDbvqZsg0L1F7TThcQsfV0q0w/GylGpY5KJr8rSz0+gmO2/IK4TTIMvPTyH5j8mGn
	rpQ==
X-Gm-Gg: ASbGnctx2kkN239sIyL46YE7B+WIvJdFnJs9Y1Iz/YrP0SyyjaYg6rG70C8otetqAeo
	RfbZrux3a+GCPynrAvWGx620iCYKZIZ5fDycasVGqVr+IkxyB7paW+lj6Y+TvNwqCu074n9uGO8
	F9rgQl061ZfTINeKRB8cJeMA3ESYj/F09B+24tHuugwTBvXTRUCEEytM/XYcgup4hiDqUeeaaNJ
	bdcDeKuy2ixeAuW5m1RPx/dvMhJRGR5aKm3VV8Pgap5i5J4cTqQZkHizBeZOZYxq6AEKvmsOdzB
	1JuIQ5iTO0TqV0NQ7WZombP4ot4exltSji8JTUrBkrvPVZHcWKH3eajI3epyl/65EAPq5UR7jbm
	wNMsoJiFE07W+
X-Google-Smtp-Source: AGHT+IG+qNv3nEuovxtZ4Kh1LW4uAVYUbOr45A5k0T9kpCaFC9wlZiiNL+99xr4j/zMeBCPF6NNn8w==
X-Received: by 2002:a05:600c:3ba0:b0:43b:cbe2:ec0c with SMTP id 5b1f17b1804b1-43bcbe2efa9mr11724355e9.27.1741079010911;
        Tue, 04 Mar 2025 01:03:30 -0800 (PST)
Received: from google.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bcb96b0c5sm18735925e9.19.2025.03.04.01.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 01:03:30 -0800 (PST)
Date: Tue, 4 Mar 2025 09:03:26 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	qperret@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Count pKVM stage-2 usage in secondary
 pagetable stats
Message-ID: <Z8bB3sr7X4RRV0CN@google.com>
References: <20250228121355.1377891-1-vdonnefort@google.com>
 <Z8Ycq3d7O8_3fozk@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8Ycq3d7O8_3fozk@linux.dev>

On Mon, Mar 03, 2025 at 01:18:35PM -0800, Oliver Upton wrote:
> On Fri, Feb 28, 2025 at 12:13:55PM +0000, Vincent Donnefort wrote:
> > Count the pages used by pKVM for the guest stage-2 in memory stats under
> > secondary pagetable stats, similarly to what the VHE mode does.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 1f55b0c7b11d..c2e022c41313 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1088,12 +1088,18 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
> >  
> >  static void hyp_mc_free_fn(void *addr, void *unused)
> >  {
> > +	kvm_account_pgtable_pages(addr, -1);
> >  	free_page((unsigned long)addr);
> >  }
> 
> Don't we drain more than just stage-2 page tables into the teardown_mc
> (e.g. vcpu structs)?

Sigh, yes we do. I've left behind some changes we have in our Android branches.
Let me respin a proper version :-\ 

> 
> Thanks,
> Oliver
