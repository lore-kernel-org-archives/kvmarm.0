Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0451516E0
	for <kvmarm@lists.linux.dev>; Fri, 29 Sep 2023 16:06:36 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d8153284d6eso21593495276.3
        for <kvmarm@lists.linux.dev>; Fri, 29 Sep 2023 09:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696003596; x=1696608396; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7748UyaRicB9vuLDG8lZI9y3UedmYNxjGs6THbhcXv4=;
        b=yW7MxuXwaMX1qRS9WHqNwe6qCKABcA2QYLXtJ8wcOtSRQ5i1PpryzZFQZmZojPE70Q
         ceyrV533xNFowWFN/JugAVaG733oniXrgMXERIMzsqLfxpSJZjW/30SbEPgG0EwKVOAo
         4AbnulwKjc7jSLd9uFLZuk9g7u+q1UzIaAaF+elb7W1LKczj1reOLFSl9HPU8YgaXMml
         MrGFm4X7fOhxjuDKPqWXGbrZkKw6trqgpK1/IG1c0ElsAdATD7cUZbMLvmXZg8MeRRwS
         cF8ir6eQI4cgLsCGJvplKsq5G23wPp7Mzpnlcd63BITwRdW5X3509Vwc1nxNTWQnFMav
         g0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696003596; x=1696608396;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7748UyaRicB9vuLDG8lZI9y3UedmYNxjGs6THbhcXv4=;
        b=stRIpa+K+2k2GQImNIVtQNnz/Uz3An05aUW1QH35ElEoA58xAu4C+ALWIQ8AnC/6sJ
         +tfSXZsxIUtsYKAt1kST1PPhl/1EgR+1IBRiVMZHFJQV10vV1YD8MaB/FTj4INzo+Yzn
         FdFR0NKi2cuh7pc3axK74/eYMniW9Gqq8DKgMVYZV3MzYgT0j2JJg/qI3qcsB0saashp
         7jeuJGkxHfEPh5BCu0kPKEQDIS7Uo/cRX68BRrEjxUpe56favQwmBxCaUl+eD/Gng6X2
         13YQoK5XkOFDmwmf+BxNXA6FlCTb8vr3Wrcwu4IVQ4hooMHE5PtlQcob04M+6hjGOJ9L
         7n5w==
X-Gm-Message-State: AOJu0YyLKfHrHeAWiZOmuTu5EktSXmFdCXwUL8B9PM5jvXmTb+0LtCBd
	xbZDM1nLMjiABmZQQWVSzROGY6HZDB0=
X-Google-Smtp-Source: AGHT+IHsLuz2yP+DLr1l3LAHJNofVqpdj+3qr9V+VXcf0rZX5bCoeLknAcYmDIAgg+yEvB5YVWisfrv0cgc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aa8a:0:b0:d80:eb4:9ca with SMTP id
 t10-20020a25aa8a000000b00d800eb409camr74309ybi.0.1696003595874; Fri, 29 Sep
 2023 09:06:35 -0700 (PDT)
Date: Fri, 29 Sep 2023 09:06:34 -0700
In-Reply-To: <ZRZeaP7W5SuereMX@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <ZRZeaP7W5SuereMX@infradead.org>
Message-ID: <ZRb2CljPvHlUErwM@google.com>
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Stevens <stevensd@chromium.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 28, 2023, Christoph Hellwig wrote:
> On Mon, Sep 11, 2023 at 11:16:30AM +0900, David Stevens wrote:
> > From: David Stevens <stevensd@chromium.org>
> > 
> > This patch series adds support for mapping VM_IO and VM_PFNMAP memory
> > that is backed by struct pages that aren't currently being refcounted
> > (e.g. tail pages of non-compound higher order allocations) into the
> > guest.
> > 
> > Our use case is virtio-gpu blob resources [1], which directly map host
> > graphics buffers into the guest as "vram" for the virtio-gpu device.
> > This feature currently does not work on systems using the amdgpu driver,
> > as that driver allocates non-compound higher order pages via
> > ttm_pool_alloc_page.
> > 
> > First, this series replaces the __gfn_to_pfn_memslot API with a more
> > extensible __kvm_faultin_pfn API. The updated API rearranges
> > __gfn_to_pfn_memslot's args into a struct and where possible packs the
> > bool arguments into a FOLL_ flags argument. The refactoring changes do
> > not change any behavior.
> 
> Instead of adding hacks to kvm you really should fix the driver / TTM
> to not do weird memory allocations.

I agree that the driver/TTM behavior is nasty, but from a KVM perspective the vast
majority of this series is long-overdue cleanups (at least, IMO).  All of those
cleanups were my requirement for adding support for the behavior David and friends
actually care about.

KVM needs to be aware of non-refcounted struct page memory no matter what; see
CVE-2021-22543 and, commit f8be156be163 ("KVM: do not allow mapping valid but
non-reference-counted pages").  I don't think it makes any sense whatsoever to
remove that code and assume every driver in existence will do the right thing.

With the cleanups done, playing nice with non-refcounted paged instead of outright
rejecting them is a wash in terms of lines of code, complexity, and ongoing
maintenance cost.
