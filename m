Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2AD37646B
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 10:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781777202; cv=none; b=XA6Sd0DeL/C6gBs01OKxexbloTVYeSTOJP95biTkJa4EO+oi19t9ucPTOxlRhlnX65aD+KQXkCk5U192N9KewR2aKpVZuAQ/ySQSqSLznpGM2QbcEmv7f71NMT1SJblO048E8jtnsbJawM3NbD61xrBSPr3OnJc7N2ubBxmT6nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781777202; c=relaxed/simple;
	bh=gPL4eZcKb04rzqdXsrloz4icZUFrxqzZOdNO6LTORGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qe3vDLO7p1j37y4cpkb6u12rbrUFZGyVB3qmm7z2sgthrwkO07W0PMNJv3NAWmcaG2JgCycY8Dm1Nzli5cRilkc2pQp+iQwdfeHC1VhsbuARBvckkp4eChijEJiaxAZSxgcdQcxJdYrIy4hZ7KqnyTaac2d+DEySc6IFWi8qoEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jvxtTbA5; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jvxtTbA5"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-68bac6e24fdso918838a12.1
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 03:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781777200; x=1782382000; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1cRgp7Kc3/ev10BqeC/Hyj5uuQ9SERtntEd44mPwyR0=;
        b=jvxtTbA5MftAc80S3reKj16TsioLpqUV17oEyWZyNWsrSUVsO5iv7D9Jh377T9OcQr
         2GM6THi/p7S4X2TUwRqZveCPOiVE2zDCQMaVu5lQpSzEyV6P4DcNGRVEwMKfq6wXFYMz
         fprG3dokESImXyXm5vkA/p5cGV0F0PgAWHFHRfWKpCz1lQ8uW/1Yq3XCvSBxy4iOH0p8
         9GZ0SvEY7Fl3ICDNqJ7/8mT8i3xEtyu7i3VM74mrCcZgZlRJKtD/nYQhlig5i5vLaWGA
         Gs7wB+1EK1k1BSPAjMy//ZVyBv4BOn5Yu/QqtzYeu4xNZvKwcuadT8k6z9G2XM9LlgM0
         ibmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781777200; x=1782382000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1cRgp7Kc3/ev10BqeC/Hyj5uuQ9SERtntEd44mPwyR0=;
        b=d+PWHXugKH8Ll6LltTkD6+xavbutc2HWUEt/YpG2ekWXO6eFOxYZCiVlscoMw5Ebj2
         B//hjWcfexBthRZcdiLJXF2dswRu0hIZzXm+n1PGx9sxnjRFhmR9IUFWN4gaNz2zToM1
         /eMC1lfL/MJ//bQOXTdpG4C/RE1u0827vIDFPs6SiWlOJKv8BDwCM1ubLeWom19Udd0m
         qDx8NbkMBvA+l0dk7dJrJAyypdaEEPsCTF7Ta39MVw2W22fo5iNDTNKiti+UObsurgTb
         PEwqfZ/usT2zp0CqB3vLIuQixOGuJGbTN9hTOKptw7lqKYabl2j4gmmNyX69SiytQlZr
         4gyw==
X-Forwarded-Encrypted: i=1; AFNElJ+6uV2Zn2G/qra31n1DhAQyA1VYptMRIGqbeSndDTV9qjnoNGFmz0RXJrMu2ON5fyhQorDVmDc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzBVuUS4lbjsAy1N/9hEkjXgG+1OovHB+IAEnoTDw2FlrskrbLM
	odWudKbCpboTefqnLGZr1iRwxNblUVDkH00EHEF2ZGW5YKGxyZkwYUoGeBSGc2lUcw==
X-Gm-Gg: AfdE7cnmy+mgZwz/4KvCDYHj9XZpR+FIYH+JHna48aaU4GxIl/uY7OVQica85B+1dR0
	RJRpg9KDPNkDbC4QuIr96stFmCloxUHhmyD81T13h+IZIhcuE94fjhLUzTkl9EOLWRdxRFxdjri
	E5xqRfr87QoqPKyiJGxzJbX7M/2bO/jnrRP6YuaJeUi0cVWg4HROcZIaG+P1+iuQwPyIIlEuu8l
	ByU9f9FhEF4SSVKxaw6+ZGprValrrnZ7eRd4m94UwfHGcuZYczQgcA3yUs6qq0vQwrZyv578DNx
	nadpnlfAWKWLkuocHS3FaSDS2bvrix2fpADHmyYA4TVmrbAaV4zDffgQB4lbaUB3kIMwOO3OZsF
	0vV446NCSMfChdfF5yV72J2aJWh3Z7fExdP+I/4f5TsLCk8MFha07FaiH6zXVJb3CVRYGbQ8WZj
	vvRENJNt2yj2GJMhlw8rOe76jU6rfAvkIV/eEMkniyH0uZ
X-Received: by 2002:a05:6402:348b:b0:68e:4c0:f5b1 with SMTP id 4fb4d7f45d1cf-695bb1abd61mr1501371a12.2.1781777199202;
        Thu, 18 Jun 2026 03:06:39 -0700 (PDT)
Received: from google.com (213.53.77.34.bc.googleusercontent.com. [34.77.53.213])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6937949bcbfsm7548192a12.24.2026.06.18.03.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 03:06:38 -0700 (PDT)
Date: Thu, 18 Jun 2026 10:06:33 +0000
From: Keir Fraser <keirf@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: arm64: pKVM is_created cleanup
Message-ID: <ajPDKYHxnletCV9s@google.com>
References: <20260618090128.3913688-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618090128.3913688-1-tabba@google.com>

On Thu, Jun 18, 2026 at 10:01:25AM +0100, Fuad Tabba wrote:
> This small series tidies up the host-side kvm->arch.pkvm.is_created flag,
> which tracks whether the hypervisor-side (EL2) VM has been instantiated.
> 
> It comes out of the ongoing pKVM (protected KVM) upstreaming work and runs
> in parallel with it. The changes only remove dead or redundant code around
> the flag, not any of the functional paths that work touches, so there is no
> dependency in either direction and the two can be applied in any order.
> 
> is_created stays: the pKVM handle is reserved early (so host MMU-notifier
> TLB invalidations have a valid handle before the first vCPU run), so a
> non-zero handle no longer implies the EL2 VM exists. is_created is what
> distinguishes "reserved" from "created", and the teardown path relies on it.
> Only the cruft around it goes.

For the whole series: Reviewed-by: Keir Fraser <keirf@google.com>

> Cheers,
> /fuad
> 
> Fuad Tabba (3):
>   KVM: arm64: Drop the unused EL2-side is_created write
>   KVM: arm64: Remove unreachable early checks in pkvm_init_host_vm()
>   KVM: arm64: Drop redundant READ_ONCE() in pkvm_hyp_vm_is_created()
> 
>  arch/arm64/kvm/hyp/nvhe/pkvm.c |  1 -
>  arch/arm64/kvm/pkvm.c          | 13 +++++--------
>  2 files changed, 5 insertions(+), 9 deletions(-)
> 
> -- 
> 2.54.0.1189.g8c84645362-goog
> 
