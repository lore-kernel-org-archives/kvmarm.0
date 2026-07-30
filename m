Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C36F3655CD
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 18:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785435528; cv=pass; b=q7gYkI2AzwiTWFYixmUpe7tz9nQmywhQhiBQu34RUeDAQ6AGqhUl3cF+zk8I7geniMTJRjyVff8mDeSrmMmKUYlcgYq9xyBukz8HpgKLfEjz+9Ymz6nXMm1c37vkDha/BwIdj69LHBf8oPRBLvTkXHbPXr+JzRVRgBYOaSOx7XM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785435528; c=relaxed/simple;
	bh=gJHV3b2Sc8xEI8IKQeSL3rSLGGFn/d5inPeMCN2Ei2g=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TTzQ0FwawNYM0E98kQ+5QzIQgyhIH82PE8JfN4TkXEtEOkIMMHZ4awCFM+nWw/QERPCKDoTTyEwBAP6SDcG07GJVR8c8Pd4OhkhYEJAqv6Wz2zFmiUwK1yyxqA//wCOvLcvSodzhQFkPG3JGZWlqOsQKhlDU4DOuXGlobzNyRfQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JNUD0z2Y; arc=pass smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JNUD0z2Y"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so247831a91.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 11:18:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785435527; cv=none;
        d=google.com; s=arc-20260327;
        b=VnEXXrW77xvAiNIeaKK5m7QeqQHQGkBKZ83er1AJorT0l9k+vknENov6dS/x+8xtx2
         ppudVG4b3F2NWwOJVGF0paYlxsclPuikVy44a15nl4qgOqOKqq8+QykYda+25kSscG+1
         0kn9qOUYrw0SbdI4s5nYyRqPk3njnWt8MbC/i55Cp/27tkg6lKXa83rn0N00Ocl8YU7j
         1kpSyx7RmoJRjyOrSOjVZQoQ7UuD6njbhBG7Mz86iZZCCNni60N39DMdZUOVHgtlbX4u
         664e0OnnBeSdHiT0DV+H8oDIRlYNhaiA6pI13OxtT69zTuShHFS8hc36FzHzmKC8b34C
         FYSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=BcSk1/y4fhEYP1oDWtEyRtQmE44YyXI71BVE0scYBk4=;
        fh=8rnYPkWVsvq+OCkOIKOqstOQCbqAUWjmR/bF3JGYzBo=;
        b=grA7d1buxn/RDfMBcaX3M5sDm2rZtd7lOGgaiu7qvcjlXKFTQ7KWBvGUscsCzgKafP
         lH0X1E9Lpz6+dSt14eA/0s3SNfthoYjVqM/afoHUxpvBzEu3ryQsag6d1LsDKzNb6+dY
         /RHQk0l399c/YpftDUKKObNTUj7wDnVm7dK5scwC0VA9N6LclEsC9X5ivgo61O4r2wrE
         lSH3ZD+eRdj/hvrl1AhXjUrY93TDWru21wbyTgfBaM/Y4XWSaN88tYLR4lZJ74EJG/+e
         HAt5X47xt5/HBwQbyUxD4+yIWL6k88/HaITCCgsK5KNLyRdFOh7NC76hUa+vkoHIlJOZ
         Qa9A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785435527; x=1786040327; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BcSk1/y4fhEYP1oDWtEyRtQmE44YyXI71BVE0scYBk4=;
        b=JNUD0z2Yt8SzBy0J90VV6eIGUTPRpldKQt/+yix51U6qVwfFa/qzTLswbY7Lg4xgRA
         QPisp10UVfxOGNzUzTBJTTz+h1CX76NldrX8KN1/ZrI3+dNLedi95u/cMvH5VtZvGHOA
         Gw4TEKov0wGIbX99qQIVrwUFFe8Fs74sJvRJ78HpIDKeFs+Mul/BbkP6/s+b2DePq33s
         5pYJdPeZwLAb9t1pLs20VXXLNvQklF5DyR9fa+JN0jmyVh5fWWk+3J8ODJfRopNttiju
         3gcSWwZgsZgIRAE4wUWuEnEbu4DxJyQ9Tm5Dk9WHG7CSsrq1eYHbHvh5faQHQ+gZg6wl
         2B7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785435527; x=1786040327;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BcSk1/y4fhEYP1oDWtEyRtQmE44YyXI71BVE0scYBk4=;
        b=cCD1xwQ9p5wpDdHQG4XyXdp3Rw4Hj2TYxkfkY6a15dtpHMLTzNJtZIOKVJEtuWlyFA
         ghCaN1sw5pSohtfnEIRmcyb+Q27NbVGjuC5Z47wwPgniWIERNJ3YDZhA84dyjeGPw7kk
         CTc2bZvepPthz4uDyXAVtZ/cZADjZ1p3KemY/AeqeYzZPBIXF7Qn8VznGpW6sQT0RRV1
         01B4rTB8lP7UDLXhGWr8FH1c2zKwBMQPwjPU2rur8vqtXd7pgiaC+9TmCxlzbDSgBDXk
         eT299dvyY6qHSIJibRGC/m2TUJrVwcBIquIThPOioFLbBJiImt9hxSpg797YLa1L3+Nf
         jU2g==
X-Forwarded-Encrypted: i=1; AHgh+RoPOK+cUogSzSv1Uv1s0CY67Xh0Qf0M5URLIjpe4alyKyldiMKLs2N6xTyyywD9Pb/N90+Z7+k=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMDluLF51yIfQehqy9fvOXDoJsWt/4/82+fhy2ncXwBiqaEL44
	C3BofYNECWqKzZU9hZosHaICCurtVD5iS1GvRP2APS8NzKpZyrAugW4LBP8XDy2AS2jAGmMRQNz
	N6Su5N64+nYxJm0GhF7AR73uVQmVExdL2JQnBmrnQ
X-Gm-Gg: AR+sD13D7plOHAY3+NgFqhM82qxGF7AHrqZJKFKIshOygd4cw1uwI4g1cE6LOmWHQ2n
	MFv0qEHdcl+oEQ+i8xIRbnZgD4fu+H1hjSB8RAcbKiJFxJiu+tRfnQPKC0KcJhfPPkm83GzGoKL
	cEXuN6i+gVE8WeYzUpFnfAxmcPp/72XHlaerbF0Qa82J9VmskckUo/fwaRDcxMBvNKrmmDKSaMH
	Dm6oZ57HUVjzyCzvCJ4jrqD/jLnXJue0InMFILT46aTanWrGVUNnpVHdP2WrnOFInji6vd2NdKq
	lYGNfGtEScOHec6ptLORSlGF6U1JFomlzV/K0EWojft0GcCAUV+rA/Xca4NqWuuJWAr8+IQZrGh
	2HRvKVyyChIqb8L8BSRxJSoIx7jXVwq+WvA==
X-Received: by 2002:a17:90a:d007:b0:37c:6130:7a5b with SMTP id
 98e67ed59e1d1-38fa7dcb036mr912482a91.8.1785435525974; Thu, 30 Jul 2026
 11:18:45 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:18:45 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:18:44 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260728121138.1103610-12-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-12-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 11:18:44 -0700
X-Gm-Features: AUfX_mzurojFzFl7kQ4jInKyqzMda986c-EWBvJn_4YyREdNQpyHfl__fqR3AfU
Message-ID: <CAEvNRgEbS06snhyHznPSqxnUrdudVEKUuOpPwnU+AJATWFBRBA@mail.gmail.com>
Subject: Re: [PATCH v4 11/11] KVM: selftests: Add guest_memfd_preservation_test
To: Tarun Sahu <tarunsahu@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"

Tarun Sahu <tarunsahu@google.com> writes:

> Add guest_memfd_preservation_test to verify that KVM VM state and guest
> memory backed by guest_memfd are preserved across a kexec reboot via Live
> Update Orchestrator (LUO).
>
> This test includes multiple tests
> - (A) Test to preserve non-guest_memfd, non-memfd which must fail (/dev/null)
> - (B) Test to preserve guest_memfd with no INIT_SHARED flag which must fail
> - (C) Test to allocate the guest_memfd memory after preservation because
>   preservation makes the guest_memfd frozen. Which must fail as well.
> - (D) Test to verify guest_memfd with INIT_SHARED flag preservation across
>   kexec: Below is the details of stages in this test.
>

I think we should split this into multiple patches, where each patch
introduces 1 test.

>
> [...snip...]
>
> +++ b/tools/testing/selftests/kvm/guest_memfd_preservation_test.c
> @@ -0,0 +1,357 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2026, Google LLC.
> + *
> + * Author: Tarun Sahu <tarunsahu@google.com>
> + *
> + * Test for VM and guest_memfd preservation across kexec (Live Update) via LUO.
> + *
> + * NOTE: This is a MANUAL test and is excluded from automated CI/testing
> + * frameworks because Stage 1 daemonizes into the background to pin resources
> + * and requires a human operator to manually trigger kexec before Stage 2
> + * is executed. Running Stage 1 automatically would leak the background daemon
> + * and cause CI runners to falsely interpret it as a passed test.
> + *

Usually there aren't many printfs in tests, but since this is a MANUAL
test, maybe that's ok?

Would like to know what Sean thinks of this, and printfs in general.

>
> [...snip...]
>
