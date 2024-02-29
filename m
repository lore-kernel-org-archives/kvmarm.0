Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF9F2E644
	for <kvmarm@lists.linux.dev>; Thu, 29 Feb 2024 00:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709168141; cv=none; b=pMbQzyF07TMURUY3fSV92ysXySlzwCc+1wJXRNSBJk6dYyaE6mlTPK3qS5yeh0gI9JUjVQFnfS0xHny3VgDPHj+jDK+u5Ts+yTmRKcXN2ga510edz0w/ZOJaUbmyvnY+PlPtPkdER6RLSS6R8rzP9bzGAhDHVB5R2l8u0sWHw8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709168141; c=relaxed/simple;
	bh=i6eHilJBW3eqkl1QuCHLL88/9qCtvwmmijhDpn1hbzE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ue6wUIuNiKqcEbYzlASf2hJ7O0foAX70S3IYP76Jqg7Z3ACzlRUlj64TxmGMGUsHKKPf1u6WDf67Syix7i8TdCD6X4/46i+AXiTxNfJWAhOWySrc1Vbaq84+RwxzbHOimp3pSvSypBJNgUmj9T0GQyUVGKNWWZOTI3QweJWFUWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tez/QLiH; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tez/QLiH"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-299d76d3a5eso240407a91.3
        for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 16:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709168138; x=1709772938; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eliV97qbvjzlWA6WTHOIiPM9PEq5O0yXOeFOONF3xgI=;
        b=tez/QLiHLSqgsChxCOkGz/+rOrCkBB1SXAafxJWqF47PRHEJqQZJTxibkHS3a92arf
         s1vqqm/IowkZvnKIeKHcajODAHfixCM2u/bX9HyF8fngU/dQWYm1577Ec0wEFmaeBoYE
         8mkvn0brMBmdBFN1YNMiIFfasaJasGFejpA4KcmRRIhcTOcdeNf9/0p03qI3F3ahY/QE
         0TZ0XTyWujUQ//dvHAyyGgXTBkhmnA8+jQrd71wero7zdBxYN4+zbIE4DXD+6X67PPyR
         EMVYutgl+Oa9RyBkOo2poVF1sGVAvAl5P2Mp5lc6Ium4OD5Hsr2WvU0R5rh7HZd1frDk
         KX9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709168138; x=1709772938;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eliV97qbvjzlWA6WTHOIiPM9PEq5O0yXOeFOONF3xgI=;
        b=J5z3Jj9pqecBF5oDxkTqtfixDGDdxfw95RAlJIZLb4TAQwDBhZST6H1VZCwAekYA0l
         x/6xGUMcOKh54m0Cma8MTVEsd//Meh22Ef6MWXCE6kah8ZBchankVsEU/tjYMmzq/iCH
         cKPKyfx7ICrIcG/4VRvwHgBD37X+QNlAIRiJM/0WLjkzLqi8bD/C6rwv2ijKNzB6qTa0
         9XuHKpdrLsRI4eoLARRFGWv8VqXkZY9fjJYIPN7tVtoV9Y0nKhV4YTUegDdv93yRIo4o
         lcbz831+JUlDs8mLGn7rQwmvosrjmMN+kpezgc4hdQ1zzFUlYhUcTnKgz6n8wlIC5koS
         Co7w==
X-Forwarded-Encrypted: i=1; AJvYcCVLFdd9cuLXBJDxaoDGLn9dKwvtw5trSEDWsQ65AZrT442usPDiG93U5noj6rSblmhrkKuBFtoay21xWZSGrm/DiX5IK9zQ
X-Gm-Message-State: AOJu0YzOQj91ng1VYEbENZu6aO4/xwKa1vzGUpNj3neaoPntjD8GC8w/
	2wm24dYEJ1kfqFIEAB0JbvY5l69/VnVjQncWaIMY7zZokZg68q98yrmSBXh6ZdVLd9ctt030lUM
	kHQ==
X-Google-Smtp-Source: AGHT+IGzoolXH5/Ep5baoVnZ7lanocljLeHRfew+WA071KUPfkGU9QcYsHqkuQzMw7/1VGlx+YyYgvht8/s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1b49:b0:299:dbe9:353b with SMTP id
 nv9-20020a17090b1b4900b00299dbe9353bmr2092pjb.9.1709168138371; Wed, 28 Feb
 2024 16:55:38 -0800 (PST)
Date: Wed, 28 Feb 2024 16:55:36 -0800
In-Reply-To: <Zd-2VK2kvMr_t1jx@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com> <170900037528.3692126.18029642068469384283.b4-ty@google.com>
 <Zd-2VK2kvMr_t1jx@google.com>
Message-ID: <Zd_WCJtlPpJVDcyg@google.com>
Subject: Re: [PATCH v9 00/11] KVM: selftests: Add SEV and SEV-ES smoke tests
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Peter Gonda <pgonda@google.com>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 28, 2024, Sean Christopherson wrote:
> FYI, the hashes changed due to a force push to squash a bug in a different
> series.
> 
> [1/11] KVM: selftests: Extend VM creation's @shape to allow control of VM subtype
>       https://github.com/kvm-x86/linux/commit/126190379c57
> [2/11] KVM: selftests: Make sparsebit structs const where appropriate
>       https://github.com/kvm-x86/linux/commit/35f50c91c43e
> [3/11] KVM: selftests: Add a macro to iterate over a sparsebit range
>       https://github.com/kvm-x86/linux/commit/57e19f057758
> [4/11] KVM: selftests: Add support for allocating/managing protected guest memory
>       https://github.com/kvm-x86/linux/commit/cd8eb2913205
> [5/11] KVM: selftests: Add support for protected vm_vaddr_* allocations
>       https://github.com/kvm-x86/linux/commit/d210eebb51a2
> [6/11] KVM: selftests: Explicitly ucall pool from shared memory
>       https://github.com/kvm-x86/linux/commit/31e00dae72fd
> [7/11] KVM: selftests: Allow tagging protected memory in guest page tables
>       https://github.com/kvm-x86/linux/commit/bf47e87c65be
> [8/11] KVM: selftests: Add library for creating and interacting with SEV guests
>       https://github.com/kvm-x86/linux/commit/bdceeebcddb8
> [9/11] KVM: selftests: Use the SEV library APIs in the intra-host migration test
>       https://github.com/kvm-x86/linux/commit/8b174eb9d289
> [10/11] KVM: selftests: Add a basic SEV smoke test
>       https://github.com/kvm-x86/linux/commit/faa0d7027de3
> [11/11] KVM: selftests: Add a basic SEV-ES smoke test
>       https://github.com/kvm-x86/linux/commit/974ba6f0e595

That didn't last long.  I forgot that I needed to change the include guards in
kvm_util_arch.h.  New-new hashes:

[1/11] KVM: selftests: Extend VM creation's @shape to allow control of VM subtype
      https://github.com/kvm-x86/linux/commit/126190379c57
[2/11] KVM: selftests: Make sparsebit structs const where appropriate
      https://github.com/kvm-x86/linux/commit/35f50c91c43e
[3/11] KVM: selftests: Add a macro to iterate over a sparsebit range
      https://github.com/kvm-x86/linux/commit/57e19f057758
[4/11] KVM: selftests: Add support for allocating/managing protected guest memory
      https://github.com/kvm-x86/linux/commit/cd8eb2913205
[5/11] KVM: selftests: Add support for protected vm_vaddr_* allocations
      https://github.com/kvm-x86/linux/commit/d210eebb51a2
[6/11] KVM: selftests: Explicitly ucall pool from shared memory
      https://github.com/kvm-x86/linux/commit/31e00dae72fd
[7/11] KVM: selftests: Allow tagging protected memory in guest page tables
      https://github.com/kvm-x86/linux/commit/be1bd4c5394f
[8/11] KVM: selftests: Add library for creating and interacting with SEV guests
      https://github.com/kvm-x86/linux/commit/ae20eef5323c
[9/11] KVM: selftests: Use the SEV library APIs in the intra-host migration test
      https://github.com/kvm-x86/linux/commit/69f8e15ab61f
[10/11] KVM: selftests: Add a basic SEV smoke test
      https://github.com/kvm-x86/linux/commit/be250ff437fa
[11/11] KVM: selftests: Add a basic SEV-ES smoke test
      https://github.com/kvm-x86/linux/commit/40e09b3ccfac
