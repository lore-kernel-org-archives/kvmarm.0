Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49411DB361
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 17:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740679109; cv=none; b=dYR9Fz+NqyQUBFexUlq67z1oI7qjAIl2gwAkFWXkwjOsTelQJRkQgqITegLpFVT3H6s+I+IzJgIiNkefTvjK9xH86KLA7TsHQw3AJs04eGJ1AqdN1Feb5QCQ4/s27vPr8tBd4jJA7qnP5mn2nAJQR3gP4Rj6//m44OQjlwBMqR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740679109; c=relaxed/simple;
	bh=G0uPe1bQYN5d95vQKr7I4HNFRFMTII4scu4mntJt4OA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W4w6rIvD0THwPT6OxKK/dnzUsKYtbH1/NjMGFKg9q5ipY7Z8o79mwEg8KdjXEcdneuQHjySvw9V4JKkWwlsGdbYC/doekZ6iBjEv4ozmLKtYxL+35P82Vnub1xb+MDhs+bVqubUOOwiukMNFWuFOyULvLWxOF/IRfaigNiRE7jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ik4/I9o+; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ik4/I9o+"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-439849103c8so1705e9.0
        for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 09:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740679106; x=1741283906; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=witULyw7TtoqLetVGW1Y6LysfNxj0X5B05/dTt9izbo=;
        b=ik4/I9o+wcl5ByTMWiknl629WQl1yjroOBJxiW4pwJ350kA71gpEPpC7/rWj352NXG
         eKVAazqyDUMM1WXzHjwmN4pqJJWdDdptnGO0QO+hd//MqJwzIPVCxl2nNB6wNq0PF7Cp
         lVWL5gxRzOaLAKqSNhDJoEb88MsPOfZA6SlDbUl/TKpWcTrs0NDBW1hZUr+lh5A1PGrr
         MGBRsnv3Mb7ngY2d0UjlY2X1kOxC3I8cHIEONJ4RGOJtaK+KVYcl7hMXWAvE4vdrJ9kl
         H9+5Fe2oSOY08KmC6jH04K7QVml1utZASX9JUiN9qRb6yget8jvg1sQwa3baFzu6n1Fa
         qaSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740679106; x=1741283906;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=witULyw7TtoqLetVGW1Y6LysfNxj0X5B05/dTt9izbo=;
        b=IOHyZ6Qxrhb0UWfs3Q9PK4IqCz1EikorVqR3ZeeNPRaoNlKBNTcg5YQPwCYmXvlHzG
         z3xBHP6OXi81khQ1L4D0c5v1ddu9BENyTOC6ks7xMFNJ64ji78kjwlpvIi8swkiQCvGN
         pmgBAIL5TYgoSTuNUUNQdM5zH+MWDnQtMoKVVR5YTfE00pvjtWYyB44QlbXFQEQcsgzq
         uSD/T+ZRy5tc3ZNUVOxWmcOcSpXTZV5FDa5FSUaybSUC2s/RqKUU7H7W2yMyIPpN/Kvw
         Vp3xApahZGkWzhGOYUXzs2jSkCf4iZe37J1IMVOCyvI4IhQkF7s+egT2UvZn/rEyGGr+
         BOCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYiadlQyAfvdflZkgi6+5iO+QktuUDfwUBaSwWm9tPLx8t2abTYj+8V+wKyOz5AwEqT3YXUaE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSRXu5dsz6VHTmRaThOR6rV00tHn186xmdjda48OZyS0+IiCDn
	/8Q/Xlv8I3XPrUbZ8kIyEnExoE9oGGTdlYqItPtSwolLUnsKaK4v4sFCm8qrXA==
X-Gm-Gg: ASbGnctHPPEGwuKxYXYxdQ+4Ls8aAdQL9U7POXBea56OypNeSAehFAudSOhK9Nq5eW5
	1ENhJG9GaORuOmxmczziD1j5XHIj6JffW8Mr59VbOpKhu/nja9DMb6My9SXS7I3EHUFcm6KPkJn
	1SvhM4gMC7Nr9wOct/6opIX/K2WnFhWTMPofy7TOzj34Kb/1AUIenq3mp7O2SWv8PIcAaBUicbc
	UDA4hpOYfUf5RInvGav5fgHhr/VqKT3wWBnHrUvUNcmHkGDUoq7Nlv65fw6qnvlpcr2mwyLRWDB
	+0OxiLNqj/m22l4HA0/cqv1ebsk1FnV1OaDViTrqFe2LpzprZphjqTG4wFMN8eEJ2Ql6rQ==
X-Google-Smtp-Source: AGHT+IGXNHWKRbpRDhtRxmSOQkQhsusbKI17eAfdufiuBuU7YJHxATrJHQS1X9gdlxiAiDFx96bvtA==
X-Received: by 2002:a05:600c:3ca8:b0:439:9434:1b6c with SMTP id 5b1f17b1804b1-43ba6bb74a0mr15565e9.3.1740679105829;
        Thu, 27 Feb 2025 09:58:25 -0800 (PST)
Received: from google.com (100.235.22.34.bc.googleusercontent.com. [34.22.235.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e47a7868sm2738983f8f.24.2025.02.27.09.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 09:58:24 -0800 (PST)
Date: Thu, 27 Feb 2025 17:58:22 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, snehalreddy@google.com,
	suzuki.poulose@arm.com, vdonnefort@google.com, will@kernel.org,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH 2/3] KVM: arm64: Map the hypervisor FF-A buffers on ffa
 init
Message-ID: <Z8CnvkUwGKxcz2hj@google.com>
References: <20250226214853.3267057-1-sebastianene@google.com>
 <20250226214853.3267057-3-sebastianene@google.com>
 <Z8A3RLoZxVxcz3wj@bogus>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8A3RLoZxVxcz3wj@bogus>

On Thu, Feb 27, 2025 at 09:58:28AM +0000, Sudeep Holla wrote:
> On Wed, Feb 26, 2025 at 09:48:52PM +0000, Sebastian Ene wrote:
> > Map the hypervisor's buffers irrespective to the host and return
> > a linux error code from the FF-A error code on failure. Remove
> > the unmap ff-a buffers calls from the hypervisor as it will
> > never be called and move the definition of the
> > ffa_to_linux_error map in the header where it should belong to.
> > Prevent the host from using FF-A if the hypervisor could not
> > map its own buffers with Trustzone.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c     | 46 ++++++++++++-------------------
> >  drivers/firmware/arm_ffa/driver.c | 24 ----------------
> >  include/linux/arm_ffa.h           | 24 ++++++++++++++++

Hi Sudeep,

> 
> Can you post the code movement from driver to the header as separate patch
> so that I can take it separately to avoid conflicts with the other changes
> I have. It could be just fine but I see no reason as why it can't be a
> separate change or why it needs to be bundled here.

Yes, let me do that and I will spin up a v2.

Thanks,
Sebastian

> 
> -- 
> Regards,
> Sudeep
