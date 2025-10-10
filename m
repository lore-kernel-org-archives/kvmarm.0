Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11D42701B6
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 17:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760119174; cv=none; b=McEb7WM5qtILil1l435vc01lWDNcBN2JFRca3VMDWrkOgFeC5DEsxZNBx0EGxVzRLpkB2ZgLMulWIlO8eeE04h4PEo24MwhUvVWLG4Vz+LEoj7JBRRp8d5pxx1GyJcU1jInYe8j7Rwwl2mGDdHJC/td9BVBJhXPu0xaOlTo1Roc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760119174; c=relaxed/simple;
	bh=/O4J+xOHjAuEp3KBUHoVkp1FiMuNBMhKCunHsW3BgCY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iFr++XIzeNgn5h9u1HzR4L3AojmukCWTsAZxj4RE/7+GxaiarSYj9cCv6SL+d3HXqruvEumYgeYMmY1wA3ZlomdhWSrq3/w8XLk/N3Lis10lMny5rVFsyx/UHJbU6JoHPMAV+qDD1h7YbDXEVlpJa49gz2XhGV+XSdyRUAGdBc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mgv+ozsl; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mgv+ozsl"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-780f9cc532bso3720363b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 10:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760119171; x=1760723971; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XsiTGDp45+d8REu3L6sx1lSo7GE9fyB7bHGlv479Ljo=;
        b=Mgv+ozslhJ/SFnh33DkxQ3lBVhgoCtyeq5tqmEbxCyWgnkJRnUxdX+Rm0vLMlv90xI
         dzDo8lUHynA7qJaaLsy0RcBxXJKEJUEO3SAQvzRCuj9mUOm/Qnnk4LV299B0NjZr8KPM
         oCyUeX19uqRLUu3VnFaNCLM8ygF4kseV91LVe5MbPNk9IMGMlEUaJl8uzuITi2hNndhW
         SvkrgLicl01CB0chStbO/PJ6kh45SWxgEul+Qa1OyJv++eR7awBmJZqDeOl96LeHIMwy
         17PLqI54UyGQmlwjiWoQzzdWL9sA71bycuVYx77HGf4tCXqwStasIoLIjPTfJeme2vXd
         W3wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760119171; x=1760723971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XsiTGDp45+d8REu3L6sx1lSo7GE9fyB7bHGlv479Ljo=;
        b=uQZRHJOUMQALvRrcJurhaEbdTYSuT7xbm5284QZw1GsiVNU3tQIrO3leFlz9RP6y9U
         Gjtsu6pdUo42Nyq3Ym4hQ378OYFm0R/3vShMKe4AUh1jGo7KUT9W23idRVNWzS13AyEC
         MU18bhV69yYmZPL1ae8SXgiG1o7pkniFVoZ6SXLIFj8LoFnO6220RSk1tu25hJxxJ9fW
         W9J8tFw14LsXqiskj1Oql/l24/DhoSAFEg14LkDDfgCYTc09Z/0u+HLNXyiu8m+bg8VX
         EDyCfzyeASWzKEzkd4Es38Jetm4RZDkbWciUlCTCzdOUL552/ltRBIQj+/t4+jZiq5qn
         X4og==
X-Forwarded-Encrypted: i=1; AJvYcCWRyoj5/FZO5UpVXjE7TFFEY4D5qcNKVEPzdbc+hszWQnYNVGdamZuOWw7UU2mJfSElA/SuuHY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxNT7P8E+nD0Qj59qzyHEs8CMUphOk+FJh22ckU5JxhFeqoYck
	o0lj0Lq34AjBCAFtc8ZStFoDA00mxHpGlt44pjk2FGw6ppNi+cUTGp/XRwbXJ2xA2ZFiS5N/ABE
	RdvCeTa1sSyWPwQaE76f8MuJUBw==
X-Google-Smtp-Source: AGHT+IFFulhZ6XtWtUEt5DU+FzApmeb72eQ72O6ZaO2RaynTOo8A78bn76Qqn2PHdxN8Dmi5RIdQ4MD/+FcahKppIg==
X-Received: from pjca12.prod.google.com ([2002:a17:90b:5b8c:b0:32b:35fb:187f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6d93:b0:2ca:f345:5673 with SMTP id adf61e73a8af0-32da90145fdmr15350975637.27.1760119171293;
 Fri, 10 Oct 2025 10:59:31 -0700 (PDT)
Date: Fri, 10 Oct 2025 10:59:29 -0700
In-Reply-To: <20251007221420.344669-10-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-10-seanjc@google.com>
Message-ID: <diqzy0pifxj2.fsf@google.com>
Subject: Re: [PATCH v12 09/12] KVM: selftests: Use proper uAPI headers to pick
 up mempolicy.h definitions
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Include mempolicy.h in KVM's numaif.h to pick up the kernel-provided NUMA
> definitions,

mempolicy.h was actually already added in the patch before this, maybe
rephrase as

Use included mempolicy.h's definitions

> and drop selftests' definitions, which are _mostly_
> equivalent.  The syscall numbers in particular are subtly x86_64-specific,
> i.e. will cause problems if/when numaif.h is used outsize of x86.
>
> Opportunistically clean up the file comment

This is true

> and make the syscall wrappers
> static inline so that including the header multiple times won't lead to
> weirdness (currently numaif.h is included by exactly one header).
>

The inlining part doesn't appear in this patch, I think it was already
inlined right from the introduction in patch 6.

> Fixes: 346b59f220a2 ("KVM: selftests: Add missing header file needed by xAPIC IPI tests")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/numaif.h | 32 +-------------------
>  1 file changed, 1 insertion(+), 31 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/numaif.h b/tools/testing/selftests/kvm/include/numaif.h
> index aaa4ac174890..1554003c40a1 100644
> --- a/tools/testing/selftests/kvm/include/numaif.h
> +++ b/tools/testing/selftests/kvm/include/numaif.h
> @@ -1,14 +1,5 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
> -/*
> - * tools/testing/selftests/kvm/include/numaif.h
> - *
> - * Copyright (C) 2020, Google LLC.
> - *
> - * This work is licensed under the terms of the GNU GPL, version 2.
> - *
> - * Header file that provides access to NUMA API functions not explicitly
> - * exported to user space.
> - */
> +/* Copyright (C) 2020, Google LLC. */
>  
>  #ifndef SELFTEST_KVM_NUMAIF_H
>  #define SELFTEST_KVM_NUMAIF_H
> @@ -37,25 +28,4 @@ KVM_SYSCALL_DEFINE(mbind, 6, void *, addr, unsigned long, size, int, mode,
>  		   const unsigned long *, nodemask, unsigned long, maxnode,
>  		   unsigned int, flags);
>  
> -/* Policies */
> -#define MPOL_DEFAULT	 0
> -#define MPOL_PREFERRED	 1
> -#define MPOL_BIND	 2
> -#define MPOL_INTERLEAVE	 3
> -
> -#define MPOL_MAX MPOL_INTERLEAVE
> -
> -/* Flags for get_mem_policy */
> -#define MPOL_F_NODE	    (1<<0)  /* return next il node or node of address */
> -				    /* Warning: MPOL_F_NODE is unsupported and
> -				     * subject to change. Don't use.
> -				     */
> -#define MPOL_F_ADDR	    (1<<1)  /* look up vma using address */
> -#define MPOL_F_MEMS_ALLOWED (1<<2)  /* query nodes allowed in cpuset */
> -
> -/* Flags for mbind */
> -#define MPOL_MF_STRICT	     (1<<0) /* Verify existing pages in the mapping */
> -#define MPOL_MF_MOVE	     (1<<1) /* Move pages owned by this process to conform to mapping */
> -#define MPOL_MF_MOVE_ALL     (1<<2) /* Move every page to conform to mapping */
> -
>  #endif /* SELFTEST_KVM_NUMAIF_H */
> -- 
> 2.51.0.710.ga91ca5db03-goog
