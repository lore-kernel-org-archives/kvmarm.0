Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160A5184E
	for <kvmarm@lists.linux.dev>; Sat, 17 Aug 2024 01:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723856454; cv=none; b=GOdqZURIz7AuFthxfGMUhZen9uR83ML6LMeyYOQynr/3CbQ5a+HiGAr6+txuRledprZzAkzbKrN0SvhetJ1SDpMxPpYKSh30KqpGNPb4DlB98vjo5o7Yi1pCanSgZkwmtc5HyskOdhHDQr2SKRSdxPASrVqqjTMG1GrAbewc+Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723856454; c=relaxed/simple;
	bh=xME3BnPckt7E13btYdrc63u8unf/OOEIYZuvPJ+UGKE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZSxuT/s7jlM24xXuCrMKNRKsSUIS4gUJEPQhQJ6zK3s6TS5xWnjMv3JdJmI0Ys5xahvDPqCpPzs0+wiI1ubVcZHm74/ZIonacHE+MiLOnri59haUlGcy6bPrQtngEVU0wRYje1NHDgSKqhznlUU4wTlgRWumRmK7YAo3EWI5oZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DAJStbtm; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DAJStbtm"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a994e332a8so2047238a12.3
        for <kvmarm@lists.linux.dev>; Fri, 16 Aug 2024 18:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723856452; x=1724461252; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DHurR+fx7zf8gF+fH8OqsanlwZHSvsgIt3z0suTHGLw=;
        b=DAJStbtmh8npYE/u3rM4vU2N0gy7374SjlvvLEMtn8ggxLJnSjXgcsMGjRijkJLJfK
         o43NMdFaO2xdtXM+HrFW9VCnZRsZJ0/bYbfgLT8xUhSxmiXlRkWKFhSL5iCIDgoccLsy
         2WETV9rWpOU9AdKO2cK9JScBYRGP2Yzzw8RQeHMMQeGFJ8dJZUTjx1ea3E5KDt7z3id2
         4kXvcNVppEwuUuGT/PJ3C1hDA47U+5hfP9LQkgmOpHnXYmzKhSyqJ6RqP0yg5eK3PsC5
         gh/YbI4UkpxNfnC7qh8ty5VXzDNDOdrVwChWnwbkOBDy2xp3UHE4EmEioypMG8jcYVcR
         bSbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723856452; x=1724461252;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DHurR+fx7zf8gF+fH8OqsanlwZHSvsgIt3z0suTHGLw=;
        b=C3v6BfhDY5CEHaj9Rmi2c/3oEzgOx5leuPxb8OUQdt6FM1hidPT+NyZSM9961fHY8A
         40YSv/Y0cME11+YhwuL3ws/bd11sN2tGr6u3O/yKpgJbDatIVh3oy8GPbYwLDdi7maV8
         1sIDv0HpQ4FI8DTwlOJAFcKv2TQmNhvHuZmrxwRlQ7ms84xiDm0eatkEDmMQmcrvwcYI
         /Mi5zjm+XpoxdP4C9JBqY/Qd2zzEMRx8ZoQAZsJQnCaKS6QretZHT1jhA7LechFBmQsm
         aDSppTU+IZ6mvan7ZbWS8CUUEZ5hnpVj5vPHzlhIsvxSyYaAmJtjnJvdH2DJRoV45EKz
         DS3w==
X-Forwarded-Encrypted: i=1; AJvYcCUbfQL+BfH2UYwW4UQKFlFwFV8+NjXU10CT+zCaZYtxlC8r+bQicZt5lfwZ0rgP8QQIoEMGyc/knrvRL3QQq7I2ETxbZwGn
X-Gm-Message-State: AOJu0Yx4NI81OhaMif3IwmEOnurMsDYJjO0WuUoAh91ro9WpZ7orGyxM
	3klxZjN8ncLW+lgxDTpEmSmhCP7QrsOcA3tRGxP/JukldVIyjkiwUGvysZOgFlmmZQcJDsUyJw9
	T1g==
X-Google-Smtp-Source: AGHT+IGgQ5L96WEtrOF85LpPpxMbEdlboogX890StOgCMUdrhDjVb+vU60wuE1WwXFLKi0Z3aJ4DtITuwPA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:4a3:b0:75f:3d6e:6461 with SMTP id
 41be03b00d2f7-7c97af56e6bmr10481a12.6.1723856452244; Fri, 16 Aug 2024
 18:00:52 -0700 (PDT)
Date: Fri, 16 Aug 2024 18:00:50 -0700
In-Reply-To: <ZqKWxfqRoJzUWroG@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-9-jthoughton@google.com> <ZqKWxfqRoJzUWroG@google.com>
Message-ID: <Zr_2Qhflx5xBhFCY@google.com>
Subject: Re: [PATCH v6 08/11] KVM: x86: Optimize kvm_{test_,}age_gfn a little bit
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: James Houghton <jthoughton@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 25, 2024, David Matlack wrote:
> On 2024-07-24 01:10 AM, James Houghton wrote:
> > Optimize both kvm_age_gfn and kvm_test_age_gfn's interaction with the
> 
> nit: Use () when referring to functions.
> 
> > shadow MMU by, rather than checking if our memslot has rmaps, check if
> > there are any indirect_shadow_pages at all.
> 
> What is optimized by checking indirect_shadow_pages instead of
> have_rmaps and what's the benefit? Smells like a premature optimization.

Checking indirect_shadow_pages avoids taking mmu_lock for write when KVM doesn't
currently have shadow MMU pages, but did at some point in the past, whereas
kvm_memslots_have_rmaps() is sticky and will return true forever.

> > Also, for kvm_test_age_gfn, reorder the TDP MMU check to be first. If we
> > find that the range is young, we do not need to check the shadow MMU.
> 
> This should be a separate commit since it's a logically distinct change
> and no dependency on the other change in this commit (other than both
> touch the same function).
> 
> Splitting the commits up will also make it easier to write more specific
> short logs (instead of "optimize a little bit" :)

+1.  Especially code movement and refactoring, e.g. factoring out
tdp_mmu_clear_spte_bits_atomic() would ideally be in a standalone patch that's
dead simple to review.
