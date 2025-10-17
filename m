Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7302BE043
	for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 16:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760717905; cv=none; b=mdVEhRltD0jW9m3TddJMMgRdVekMroshSVh5ywJRZHZvJp1pFXSuw/EcwaKSkP1PE3OXesG7TBqWA4RU7kUTv1fZQcP5qgZfxzel0Yf2G7LY8alcsUd0bUeSpv/RYgbYSg08uxfOb/P9ZlCsk6nSWNe6kO4ceXEmPWjIiA9i7hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760717905; c=relaxed/simple;
	bh=dCo1MGrJD9Z3p+JSjI9DqLCn1a7bM1B+iqCsSzHDk9c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZduhaE2wzzeLpuBAYzdFPkuV592mXv4gJEbtj/BJboEtL5JU51eW/coqZlAPADPu8Oi6Up0pCRgkOXVPWnhSpy/9mjVuNFOVtrKN4krR/EYCJO3YQ57GBFYlvU7JtNaYzPRH2m8ACdjuyvrOQpuab2KQbNL2yTbGkWp42LwQK5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pv+Zo7sO; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pv+Zo7sO"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b62b7af4fddso1391920a12.2
        for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 09:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760717903; x=1761322703; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h2EFLTX0PYpEWD6o7KiV0FgHN4LA5AiygCdXWH4JDp8=;
        b=Pv+Zo7sO6UgHXHYoriWAc8vCgIB6qw2wiizfyDI4W0wEN1dBIf113G6wZDAO1MFt+k
         An60eeH+p1D4gqGpFg00+QpXPEtnckwMY6RJNDjLZLAjUYJlkkPByUFJ3hrXCSo7sKCs
         dnre2zq6ed9vXQn/LeXVd5iMrp0YoqLMKbw5SGqENo6F21GpJze0OfOiSYP1EiHnuoot
         XaPtyYMK67anQB/H21gF8zjoKD5CWu9If/fNDUZAL9hD5XVu9jK+zjtnpR8e3c3trLmB
         iMOb+XEtormed23VhuiyAYunMwY4mZKI8ZccfZF7lKG2s95ReQvxEShXbbME7N/lKC72
         CP1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760717903; x=1761322703;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h2EFLTX0PYpEWD6o7KiV0FgHN4LA5AiygCdXWH4JDp8=;
        b=PZ6MCfVr6va3AhbGjsIqwhcd/vxe3nDRRn8ZYDMDLLQsvVaWrLLuGAAE6okv+BQPij
         lU3OOtTbUkQuvNIxgv/7SXwwAv5eqgwAE7PR01hQX/7eF7jhESMv61khl8MjESxuQaDp
         9kr3F5IHuEhJHyW8qC+NDhki3FuR+gJH2dNINzs9TwXAR6E/lwCX4NfAZrZGkeUMWkW0
         Se3Mx0fLsfM8oM1mmRuThNlWEjztSsVp6EhvNiqrT4lWKvTDJVvjOBr36HRShPqxPYx5
         yqZ9gRN7D9QpKc202ch8GZytaoS2XQHKGEHXpGlQtGw73Uftd9uhVfmWu6PN4RuBU9Sk
         h7YA==
X-Forwarded-Encrypted: i=1; AJvYcCUTTsAciaTbQZrN1b8myfAyvgHEIdT1oQcSdWFK45BIq9ni1iVT7xbbv1wpnCh+fxZLTzzpeAg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSQkOXsLEts84Ku/VWqfVHfnaEiSJo9q9u+xv/t+jCz4F4X8DP
	ZU0IPRU/l7BFmPhofDO96XW9ObIC/rIjwsVyHZSJv4PJMEojdSKVUcTQ66LNbxHvQEk9fndXnxN
	bAfEeBQ==
X-Google-Smtp-Source: AGHT+IFaZEr2a3gvr9j34mwQCkJH9r0m1tq7ki6LSm2/57IK1g+qw40tWnhbdWwdpyVbTfr8muq81KAy8bI=
X-Received: from pjbta13.prod.google.com ([2002:a17:90b:4ecd:b0:332:5712:5242])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec8b:b0:327:ba77:a47
 with SMTP id 98e67ed59e1d1-33bcf87b356mr4450218a91.15.1760717902777; Fri, 17
 Oct 2025 09:18:22 -0700 (PDT)
Date: Fri, 17 Oct 2025 09:18:21 -0700
In-Reply-To: <5303684f-3acf-402a-8154-a02a2194ce34@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com> <20251016172853.52451-10-seanjc@google.com>
 <5303684f-3acf-402a-8154-a02a2194ce34@amd.com>
Message-ID: <aPJsTVxajpP6-vKV@google.com>
Subject: Re: [PATCH v13 09/12] KVM: selftests: Use proper uAPI headers to pick
 up mempolicy.h definitions
From: Sean Christopherson <seanjc@google.com>
To: Shivank Garg <shivankg@amd.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 17, 2025, Shivank Garg wrote:
> 
> 
> On 10/16/2025 10:58 PM, Sean Christopherson wrote:
> > Drop the KVM's re-definitions of MPOL_xxx flags in numaif.h as they are
> > defined by the already-included, kernel-provided mempolicy.h.  The only
> > reason the duplicate definitions don't cause compiler warnings is because
> > they are identical, but only on x86-64!  The syscall numbers in particular
> > are subtly x86_64-specific, i.e. will cause problems if/when numaif.h is
> > used outsize of x86.
> > 
> > Opportunistically clean up the file comment as the license information is
> > covered by the SPDX header, the path is superfluous, and as above the
> > comment about the contents is flat out wrong.
> > 
> > Fixes: 346b59f220a2 ("KVM: selftests: Add missing header file needed by xAPIC IPI tests")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  tools/testing/selftests/kvm/include/numaif.h | 32 +-------------------
> >  1 file changed, 1 insertion(+), 31 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/numaif.h b/tools/testing/selftests/kvm/include/numaif.h
> > index aaa4ac174890..1554003c40a1 100644
> > --- a/tools/testing/selftests/kvm/include/numaif.h
> > +++ b/tools/testing/selftests/kvm/include/numaif.h
> > @@ -1,14 +1,5 @@
> >  /* SPDX-License-Identifier: GPL-2.0-only */
> > -/*
> > - * tools/testing/selftests/kvm/include/numaif.h
> > - *
> > - * Copyright (C) 2020, Google LLC.
> > - *
> > - * This work is licensed under the terms of the GNU GPL, version 2.
> > - *
> > - * Header file that provides access to NUMA API functions not explicitly
> > - * exported to user space.
> > - */
> > +/* Copyright (C) 2020, Google LLC. */
> 
> Given this file got a complete overhaul in this series, Should the copyright be 2020, 2025?
> Not entirely sure what the rules are for this.

Me either.  I just figure I can't really go totally wrong by doing nothing :-)
