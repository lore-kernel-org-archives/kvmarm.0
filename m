Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41B7212B0C
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 20:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750279660; cv=none; b=URYj3amqSy06OajQJO7w5za7VgKZfo1J348dv/X6f+tO83/inWaPBFw7tf/prX0hUmbEao87/OVwH34e2iSvDiI9oF7tnEjpOeelFuMuxlqquhqBIhApi63gRrnSyZSwBkl1SGMaI6F+jCLICo3G1um7foX2lg9bO8uJcyHRPhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750279660; c=relaxed/simple;
	bh=MSg8wk9eVlKwpP07atFTFTL1LzBt6yhgrDLcbqqKcT8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FI8KWGViOCVCVGFUlrusibVey8rhb6hCMY1cC13GcioO8RYq4lyUtGaRFC9SaY0GzoCR07jGN4EFyOdTyXJq1acpHGdukp0cw5ddJP+iDukUS7cYElHSuFJazpC7u5sB+qNM3eeAVW3EzqBcy+L7kb7m/fuwVaheRY5kxA21sNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ygMN+EWz; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ygMN+EWz"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748f30d56d1so21974b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 13:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750279658; x=1750884458; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I5t8P7O8Q2d0gJsfuLHKOR+WvGfRlegvudtjyvE+c7E=;
        b=ygMN+EWzUfPKP7wCudFDUXXLr43Ql84c8mmymVnV1zUtAEs1X6UzhLeO41D8SlUHgv
         JPW4MUgKnDFBW0LqwSxUjWDv+koZIdiqoaxEyE8KSuLfBMDc0VXLqGykehRMc0Svg08i
         eGUchTlvuRNqslsNdRLlnprExyhEAUT8PTrYcAYumcu1YU3ef4RuxHVAo/11yCTG1Lcn
         sgqmBsUarDdyM7T/r1o5DDjynpMcjsm1o59uLVsnVzmVm0i1Yw65H4T4YEANImBTlRc+
         UUbpeCZuWUboFvbPKM2qpFakqSSepny/Jq1pqYmsV/YvmHGflsa8o+hkNHZ7D3SldS5O
         8w9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750279658; x=1750884458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I5t8P7O8Q2d0gJsfuLHKOR+WvGfRlegvudtjyvE+c7E=;
        b=ANpm2GbuZAfz20lGxBsIxYtIvv9Pzp9DUSN7e2sgdgjTRZdza/nwKQA4S19kZckDwT
         RY6eJcOthIgXvpiNoagI5iSwGn9ZOZSccWA8verG7MmJAC9x2GRar1QQSYR97LMu9CKz
         sUgKRdQnnBKv+uPPovlndLgDcrIQZsORiMhFCQ/Y1Dcon5eNV9fNDl+x7UnQ2h4kNBUY
         DtjaFm+C81vEKFJzLF1ZHtK8UBg5tneC6XVeltQ3aQgpshPZcVUQPDVevieYbsP9APpa
         QeLTCVY1TqLq9frp61q83uke2lrYI/w5p1R29YxApKHI02J4NAJSa7my6te804ObeIzL
         ZrwA==
X-Forwarded-Encrypted: i=1; AJvYcCV782HTv4iF0C+p5tPkRB8iQZiz3JQaFZrEUUqitZiYK3gs8jyX93JMYbqEcKlSCW8cBT9jdqs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwNDYq96OwShH/TqQQzKtDAb5Vq5qZo/rjyaDl0WSxNwA8pPbsf
	m9spL8bajYRAO8rbUCvD+wj8tOfc64a/XIe6b3/DeDPlOSUukMHRX6Kq9UO+fEp+MD6kcWHrcb3
	aWjyurA==
X-Google-Smtp-Source: AGHT+IFsMlePwDY6qmxFMx2/AM9b76jDzDiB1mAOtEb6xvvscl9w6SK2u5TQJ/MjXtylS7QVbS8ovVI8RZ8=
X-Received: from pfbgh9.prod.google.com ([2002:a05:6a00:6389:b0:747:b682:5cc0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b8b:b0:736:5e28:cfba
 with SMTP id d2e1a72fcca58-7489cfc3944mr25334965b3a.18.1750279658241; Wed, 18
 Jun 2025 13:47:38 -0700 (PDT)
Date: Wed, 18 Jun 2025 13:47:36 -0700
In-Reply-To: <aFMaxi5LDr4HHbMR@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
 <20250618042424.330664-4-jthoughton@google.com> <aFMaxi5LDr4HHbMR@linux.dev>
Message-ID: <aFMl6DOcKfH6ampb@google.com>
Subject: Re: [PATCH v3 03/15] KVM: arm64: x86: Require "struct kvm_page_fault"
 for memory fault exits
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 18, 2025, Oliver Upton wrote:
> On Wed, Jun 18, 2025 at 04:24:12AM +0000, James Houghton wrote:
> > +#ifdef CONFIG_KVM_GENERIC_PAGE_FAULT
> > +
> > +#define KVM_ASSERT_TYPE_IS(type_t, x)					\
> > +do {									\
> > +	type_t __maybe_unused tmp;					\
> > +									\
> > +	BUILD_BUG_ON(!__types_ok(tmp, x) || !__typecheck(tmp, x));	\
> > +} while (0)
> > +
> >  static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
> > -						 gpa_t gpa, gpa_t size,
> > -						 bool is_write, bool is_exec,
> > -						 bool is_private)
> > +						 struct kvm_page_fault *fault)
> >  {
> > +	KVM_ASSERT_TYPE_IS(gfn_t, fault->gfn);
> > +	KVM_ASSERT_TYPE_IS(bool, fault->exec);
> > +	KVM_ASSERT_TYPE_IS(bool, fault->write);
> > +	KVM_ASSERT_TYPE_IS(bool, fault->is_private);
> > +	KVM_ASSERT_TYPE_IS(struct kvm_memory_slot *, fault->slot);
> > +
> >  	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> > -	vcpu->run->memory_fault.gpa = gpa;
> > -	vcpu->run->memory_fault.size = size;
> > +	vcpu->run->memory_fault.gpa = fault->gfn << PAGE_SHIFT;
> > +	vcpu->run->memory_fault.size = PAGE_SIZE;
> >  
> >  	/* RWX flags are not (yet) defined or communicated to userspace. */
> >  	vcpu->run->memory_fault.flags = 0;
> > -	if (is_private)
> > +	if (fault->is_private)
> >  		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
> >  }
> > +#endif
> 
> This *is not* the right direction of travel for arm64. Stage-2 aborts /
> EPT violations / etc. are extremely architecture-specific events.

Yes and no.  100% agreed there are arch/vendor specific aspects of stage-2 faults,
but there are most definitely commonalites as well.

> What I would like to see on arm64 is that for every "KVM_EXIT_MEMORY_FAULT"
> we provide as much syndrome information as possible. That could imply
> some combination of a sanitised view of ESR_EL2 and, where it is
> unambiguous, common fault flags that have shared definitions with x86.

Me confused, this is what the above does?  "struct kvm_page_fault" is arch
specific, e.g. x86 has a whole pile of stuff in there beyond gfn, exec, write,
is_private, and slot.

The approach is non-standard, but I think my justification/reasoning for having
the structure be arch-defined still holds:

 : Rather than define a common kvm_page_fault and kvm_arch_page_fault child,
 : simply assert that the handful of required fields are provided by the
 : arch-defined structure.  Unlike vCPU and VMs, the number of common fields
 : is expected to be small, and letting arch code fully define the structure
 : allows for maximum flexibility with respect to const, layout, etc.

If we could use anonymous struct field, i.e. could embed a kvm_arch_page_fault
without having to bounce through an "arch" field, I would vote for the approach.
Sadly, AFAIK, we can't yet use those in the kernel.

> This could incur some minor code duplication, but even then we can share
> helpers for the software bits (like userfault).

Again, that is what is proposed here.

> FEAT_MTE_PERM is a very good example for this. There exists a "Tag"
> permission at stage-2 which is unrelated to any of the 'normal'
> read/write permissions. There's also the MostlyReadOnly permission from
> FEAT_THE which grants write permission to a specific set of instructions.
> 
> I don't want to paper over these nuances and will happily maintain an
> arm64-specific flavor of "kvm_prepare_memory_fault_exit()"

Nothing prevents arm64 (or any arch) from wrapping kvm_prepare_memory_fault_exit()
and/or taking action after it's invoked.  That's not an accident; the "prepare
exit" helpers (x86 has a few more) were specifically designed to not be used as
the "return" to userspace.  E.g. this one returns "void" instead of -EFAULT
specifically so that the callers isn't "required" to ignore the return if the
caller wants to populate (or change, but hopefully that's never the case) fields
after calling kvm_prepare_memory_fault_exit), and so that arch can return an
entirely different error code, e.g. -EHWPOISON when appropriate.

And it's not just kvm_prepare_memory_fault_exit() that I want to use kvm_page_fault;
kvm_faultin_pfn() is another case where having a common "struct kvm_page_fault"
would clean up some ugly/annoying boilerplate.
