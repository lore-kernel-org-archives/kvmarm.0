Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57830EC5
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 01:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2QjxaAcU"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d81c39acfd9so630752276.0
        for <kvmarm@lists.linux.dev>; Wed, 04 Oct 2023 18:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696470734; x=1697075534; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=acQKbJZD+RcbWw3BnnpBc5Z7IgVcU3OSCyBSABN5PtQ=;
        b=2QjxaAcUNWXjrEwtvjiUmwnG0wmHzv4V3bbrYwA4/RKfyv4KaiBnYgOhwLiB2TBoeh
         6o5HPALCZ8GWYYYjdwB68MYx1P1VQvqvCQ30ocLh1nlCwHaN4pewJabbvEHpFaRzzLhZ
         DRhSiwiLUXWM2TqpLOrBM1db391c3QbikMuEM74Y1azC7wYaDytITHAImyKO23VnIHer
         sQjEIEi2KkZkHOaC6VaUaoqMGFE7fbRXa3hrHM4hnuHew80Ug2qEDkacT2NvfURpVrpa
         QMDw67UjbhhiDdRWklR1C8n0edkbV8PDhOwDtx89531/ArrkXIxO2cckQQvjSlEw+56W
         4o/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696470734; x=1697075534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=acQKbJZD+RcbWw3BnnpBc5Z7IgVcU3OSCyBSABN5PtQ=;
        b=HFMrFzyUybzJvOpfrH1ZWXlhRNSMvjhAdGN9FjJBBfud/lxeELeLvtpQM9oeaOjCmh
         dLvQSQRtXGlydKDFc8kvGJNokN9NTE8kHL3n8TasbfXYyqDklzNhJ6VowvTfdPfFMKH+
         idGrI5RFisl8idxqg8Eha9MetboQGbMqsYipMAiD3o7phGgX+EMCzB+Z9DxUWJBLFY+E
         YE80ylNJCHSC0eKluXO7oF/uTOLbG4IZqwOSYB/RkDapL6QhO7hnPXpwbqDaTSzCALbG
         5t7mZFgwahanbwnmfdGdupyQdeoXFNsvgCns+hToD7P2DujRc/CYRejldtY94ygJGdr2
         D/Yw==
X-Gm-Message-State: AOJu0YySqL+z0xQmaHpjCNEgZUaU9utQDRiOVcLVf3e7tojfYjzMj5HN
	Vw2X8/iTueZqZW+bR2WBNjidkyXNq1A=
X-Google-Smtp-Source: AGHT+IEyC/8z97IOmWK7ZeU1qdb5G7XIAtLDmWxMyLS8OggYv8wqS/qg9vyIFhJjSFP18hZDQ3v1opASl/8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:fe0a:0:b0:d78:215f:ba5f with SMTP id
 k10-20020a25fe0a000000b00d78215fba5fmr66372ybe.9.1696470734238; Wed, 04 Oct
 2023 18:52:14 -0700 (PDT)
Date: Wed, 4 Oct 2023 18:52:12 -0700
In-Reply-To: <20230908222905.1321305-12-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-12-amoorthy@google.com>
Message-ID: <ZR4WzE1JOvq_0dhE@google.com>
Subject: Re: [PATCH v5 11/17] KVM: x86: Enable KVM_CAP_USERFAULT_ON_MISSING
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 08, 2023, Anish Moorthy wrote:
> The relevant __gfn_to_pfn_memslot() calls in __kvm_faultin_pfn()
> already use MEMSLOT_ACCESS_NONATOMIC_MAY_UPGRADE.

--verbose

> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 2 +-
>  arch/x86/kvm/Kconfig           | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index c2eaacb6dc63..a74d721a18f6 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7788,7 +7788,7 @@ error/annotated fault.
>  7.35 KVM_CAP_USERFAULT_ON_MISSING
>  ---------------------------------
>  
> -:Architectures: None
> +:Architectures: x86
>  :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
>  
>  The presence of this capability indicates that userspace may set the
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index ed90f148140d..11d956f17a9d 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -49,6 +49,7 @@ config KVM
>  	select INTERVAL_TREE
>  	select HAVE_KVM_PM_NOTIFIER if PM
>  	select KVM_GENERIC_HARDWARE_ENABLING
> +        select HAVE_KVM_USERFAULT_ON_MISSING


Hmm, I vote to squash this patch with

  KVM: x86: Annotate -EFAULTs from kvm_handle_error_pfn()

or rather, squash that code into this patch.  Ditto for the ARM patches.

Since we're making KVM_EXIT_MEMORY_FAULT informational-only for flows that KVM
isn't committing to supporting, I think it makes sense to enable the arch specific
paths that *need* to return KVM_EXIT_MEMORY_FAULT at the same time as the feature
that adds the requirement.

E.g. without HAVE_KVM_USERFAULT_ON_MISSING support, per the contract we are creating,
it would be totally fine for KVM to not use KVM_EXIT_MEMORY_FAULT for the page
fault paths.  And that obviously has to be the case since KVM_CAP_MEMORY_FAULT_INFO
is introduced before the arch code is enabled.

But as of this path, KVM *must* return KVM_EXIT_MEMORY_FAULT, so we should make
it impossible to do a straight revert of that dependency.  That should also help
with the changelogs, e.g. it'll give you a prompt for why only kvm_handle_error_pfn()
is getting treatment.
