Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD6856B81
	for <kvmarm@lists.linux.dev>; Tue,  6 Aug 2024 17:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722965099; cv=none; b=d8iCLDQswkWhDo+35aoJA/TsCLssrkK7u0LBpVWW/OKir+/3oyyVGJZ4gQqIFXVWyUGyA5Vj936uiRgWW+PXSv0dFB3Yzlc9mRktsJ+eywyjOsYdFquFrqYM7fzsrIkfGz4XjtcDIvVfNVju5S82cWLbMVudpliPfKCRv5fx+58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722965099; c=relaxed/simple;
	bh=MqaKHZxPTEOOQL0dPc8HBy57ffLggZgGByL+56jCEA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGQ3YKMbKR6jzkKYIWaeuIQ3KpPmv9b3z0t4lA5hiQ+0kPPHm15M486K0nBnCH88CuqMYKA2Pjm4uH5AKD72lifTmYuWT1qjJ0R73NbdG1vhD2dJrZqYLHJ1Db5XNxNBc64lJbLcu4uHwE5Ld2BtivGgKaf75FBYKSPLVfg951U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=l6S8cpO9; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="l6S8cpO9"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6bb96ef0e96so5105366d6.2
        for <kvmarm@lists.linux.dev>; Tue, 06 Aug 2024 10:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1722965096; x=1723569896; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T7HE5qomFnShgNw+dAFpKQn8211Vw3rMqkRCxPcaqwk=;
        b=l6S8cpO9t4cO39hKD/qwWoklguTyV5cc0aVejMnTJPPLiNx+ukAGQXuFbnOKZAohfm
         aJonfSpuPQeINXKWIQnKDX3P2uQjpGYy0Ga2xzlL6QS5VVh2Q/16FusO6E1j4uqhk3j4
         DV0w9T0BSG/R7OPf3LbhhwbETYLlITHH6YGF9ZXKeWmcui1xxpyVbrgB85bH6wW9WVb5
         WU0+2LbEb4pU6Y82pgLahFS0oy0s+ZsNcQWgzjejuCyNOhB+hp74FBahSRavAd6zqryh
         uG5lMGDg4gIaP9JCohqf9V1nrW15n6rsYJLbwjIqcKDK2DhgxMxwi4sZTL8+4Tyqs4k6
         VZiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722965096; x=1723569896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T7HE5qomFnShgNw+dAFpKQn8211Vw3rMqkRCxPcaqwk=;
        b=fBRfFq4IMhWCireXzz4JCvSenG1+rZcWadjfK+s+i9L8tIK3To3mR+q7FIWu3O9U6h
         vaiDQdCMI+WUyGwKnZ6xPMM9s9DksG9quoO4zq8jbeHI7FCrlYa0PRRpN+j7nq0N7J/x
         Q4LCYYlTlJtKSwcczi32FpfJ/aJgMs8ecViBJRweZ0caatawWghAeIsOoDtfN14jSFrL
         TQojASneeNAgXTkHFxOOtSlW3bRgkDrRb6172249TbloG6KChN+VEOlQ+b6vfAleYMc/
         dZSl4BCwHRn983DsYxRHcc/TU1zt0OoJERzcNsfCu1qgnVi9MDBhyyBMIeDsAtF1EgcQ
         aHIw==
X-Forwarded-Encrypted: i=1; AJvYcCVE5V4jUSlVoi03Xi/SkGAqBmtttacTxzt4VPs6ErY15P/JUHhVmoOGyytjrvYqFxmqgjZAcBC1/TgPz+ohF+QCWZdA0jTG
X-Gm-Message-State: AOJu0YwT8W6gg5enljp3aoOgtYKEJvkhz5oNHPoV1DCdjMk/MRyY7RDU
	1V5ZqrQUqXe+oere+7dFhpzkWhU7onK3Wie0RTcdK1lGJ4vhtdjwfYjy4QtIW3Y=
X-Google-Smtp-Source: AGHT+IFa9dVhWCrdPdbUkpdGZrho6h2SYLIO4aEGRVqFcYo1XlMAaNoBZNabBpbHu2isVnX5Mnu2Pw==
X-Received: by 2002:a05:6214:3a08:b0:6b7:9bdd:c5ac with SMTP id 6a1803df08f44-6bb9845d291mr182312036d6.54.1722965095947;
        Tue, 06 Aug 2024 10:24:55 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb9c86772bsm48644876d6.124.2024.08.06.10.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 10:24:55 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sbNvb-00FYkR-1o;
	Tue, 06 Aug 2024 14:24:55 -0300
Date: Tue, 6 Aug 2024 14:24:55 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>,
	Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 04/11] mm: Add missing mmu_notifier_clear_young for
 !MMU_NOTIFIER
Message-ID: <20240806172455.GR676757@ziepe.ca>
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-5-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240724011037.3671523-5-jthoughton@google.com>

On Wed, Jul 24, 2024 at 01:10:29AM +0000, James Houghton wrote:
> Remove the now unnecessary ifdef in mm/damon/vaddr.c as well.
> 
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  include/linux/mmu_notifier.h | 7 +++++++
>  mm/damon/vaddr.c             | 2 --
>  2 files changed, 7 insertions(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
