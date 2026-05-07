Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1443AF672
	for <kvmarm@lists.linux.dev>; Thu,  7 May 2026 13:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778160792; cv=none; b=Ok6vlOyCSFM8ho67j0FWZjFyN9FAeKQmm3cqs5gRo7IXaAH2kxshlFhoBHV/Jv3ajq5QxP0Ae47lsqJhby4ViwAbo6PUAPp/tmrA/U++xJcYRCuzC3Ncpf6Y2+Qxq4JoYOdjoPDhpQkZuk7Qf28l3pEQKF0wXZ5DK6ZEbfcWXyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778160792; c=relaxed/simple;
	bh=M+1Z5REvYdFiksjsEk2h6OHeRbUmh7UMafjJOefnKoU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qfbujFWyQTy6YErRzg3/m1s7OfYSkT/161ES6bNAjbS2gXGbHLpqD70QeogeCx3ahVJof0DaFkiOJSRveQuYML4PC2Qmv7abkI34eAVtIh6Ue9mS0UuKdtGNJ4vU1QGocxuOO3SiqaPBO7GbyfuVJK5sAi6o+xSJc4/E66+em8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CcBKTuGc; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CcBKTuGc"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ba054e0304so14288635ad.0
        for <kvmarm@lists.linux.dev>; Thu, 07 May 2026 06:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778160787; x=1778765587; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lAslfbD1ot428d19C5gk7U0ODS9evh/h4+t//ujFJsg=;
        b=CcBKTuGczE5zeq2siVNweiiMP4vMhzaGUU3oS1Xv+OQuZVny6ieBeWCOlhoIjMUYt8
         aX5XTr3FeQ14JwMbsgn9lXcZrQZpkMmPQEMpSHO0VSuailsoUZIeMw/zuUkAPgxq33ME
         GpvTA6Y3VKn1deXDKvR+5h/48xu/NuAbtmhAUJXOY2iAmx5E9AW1PTM5Z90dpB1F7T0y
         zZMMg98+W3Jxteikx7rxaIhSRmSewzgIfaHTChskPgpQ04S/uiEA5mosc1/ebmBS0VJe
         GlwTBABitAB80F94uGRSOFcwMEHz1Y4DDUxvlKN7dzxNy6EDgJWlTYUMwvt+pU+UbNPh
         sqFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778160787; x=1778765587;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lAslfbD1ot428d19C5gk7U0ODS9evh/h4+t//ujFJsg=;
        b=o2XCHGeVvmIHI4jKzhhbhckrVJSYwCsX5BRVuERipS/JhDTVJEFHuzbS6kJeEdo/Uj
         Y0cfU0dEnRXsJZ88MKZI51iBVzJJvS0qebtCMQkc+r597qpZz+WiV6c45aHKE6nrfYyn
         wHloP43MTAbwcN2wpkMIJsz+gisrUYUEAFBQPtvk7GKqojQEvw6lieaU1Kueuu7TQg8v
         MnipdOY+12rW9d7Q3Zbigw4wZQ2B1Qkn66sOL9vj6tc7XumCrk0fZTz3YJ5dfiYWfIJn
         5ZYbtywClTuZ8LJZFsiP56lK1AnWjeu+BYVIk/RSwz2oHWI9YdfykxpVDJP55eH0HwP5
         gmgg==
X-Forwarded-Encrypted: i=1; AFNElJ8PRtOZP6PU8PEqFjlYHjKJomVzzgH15kDscanrpjFmVzsbFCtGDvrYwGb2EjbcDcrtdVEIOtM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwAiQHIxBoQzcVYme+dX8BfB93VV0nMmWs2qOTYiZveFbE3RAva
	+EDgxUe9cQX5Cxq6Vsa0xrB6xtibTuuiA2PFYjX7fiIBZpUeXy0JdW1UyAQLMq+14s9vQpNVxJ9
	aQ60gEQ==
X-Received: from pluo3.prod.google.com ([2002:a17:903:4b03:b0:2b4:62bc:c2a9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2ad0:b0:2ba:b6a:41bf
 with SMTP id d9443c01a7336-2babc858e7fmr28026925ad.3.1778160786506; Thu, 07
 May 2026 06:33:06 -0700 (PDT)
Date: Thu, 7 May 2026 06:33:05 -0700
In-Reply-To: <afxROjBUVzeQQNfg@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260506105053.107404-1-alexandru.elisei@arm.com>
 <afs3wp7xBUf2jYK4@google.com> <afxROjBUVzeQQNfg@raptor>
Message-ID: <afyUkaQ1wtivyH8W@google.com>
Subject: Re: [RFC PATCH] KVM: arm64: Align KVM_EXIT_MEMORY_FAULT error codes
 with documentation
From: Sean Christopherson <seanjc@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	tabba@google.com, David.Hildenbrand@arm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, May 07, 2026, Alexandru Elisei wrote:
> Hi Sean,
> 
> (Resending this because I managed to mess up the headers, sorry for the
> duplicate).
> 
> Thanks for the explanations!
> 
> On Wed, May 06, 2026 at 05:44:50AM -0700, Sean Christopherson wrote:
> > On Wed, May 06, 2026, Alexandru Elisei wrote:
> > > The documentation for KVM_EXIT_MEMORY_FAULT states:
> > > 
> > > 'Note!  KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in that
> > > it accompanies a return code of '-1', not '0'!  errno will always be set to
> > > EFAULT or EHWPOISON when KVM exits with KVM_EXIT_MEMORY_FAULT, userspace
> > > should assume kvm_run.exit_reason is stale/undefined for all other error
> > > numbers'.
> > > 
> > > where a return code of '-1' is special because according to man 2 ioctl:
> > > 
> > > 'On error, -1 is returned, and errno is set to indicate the error'.
> > > 
> > > Putting the two together means that the ioctl KVM_RUN must 1) complete with
> > > an error and 2) that error must must be either EFAULT or EHWPOISON for
> > > userspace to detect a KVM_EXIT_MEMORY_FAULT VCPU exit.
> > 
> > Yes and no.  The key escape valve we (very deliberately) gave ourselves is this:
> > 
> >   userspace should assume kvm_run.exit_reason is stale/undefined for all other
> >   error numbers.
> > 
> > As arm64 already does, that clause allows KVM to "speculatively" set exit_reason
> > to KVM_EXIT_MEMORY_FAULT.  Which is by design.  The userspace flow is intended
> > to be "if KVM_RUN returns EFAULT or EHWPOISON, then check for KVM_EXIT_MEMORY_FAULT
> > to see if KVM provided more information about why the EFAULT/EHWPOISON error was
> > returned".
> 
> Hm... In general, "speculatively" populating exit_reason with
> KVM_EXIT_MEMORY_FAULT when userspace is not intended to use that information
> looks a bit dubious to me.

Oh, for sure, it's not exactly ideal.

> Why do the work if userspace is not supposed to use the information?

Because not filling kvm_run when KVM is supposed to (per KVM's contract with
userspace) would be a bug, whereas unnecessarily filling kvm_run is "just" wasted
cycles (and not very many of them).  x86 also has multiple flows where it fills
kvm_run "speculatively", e.g. in low(ish) level helpers where it's not known if
KVM will actually exit to userspace.

Overall, for code like this, IMO it's also yields less complex KVM code, though
I suppose it can also end up being more confusing for readers.

> Regarding gmem_abort(). As I see it, if today someone writes userspace that
> relies on any of the undocumented error codes propagated from kvm_gmem_get_pfn()
> to handle KVM_EXIT_MEMORY_FAULT, that means that KVM can never use those error
> codes for any other exit_reason in the future, because that userspace will
> break.

Hmm, if we wanted to defend against that, we could scribble kvm_run.exit_reason
on the way out of KVM_RUN, e.g.

diff --git virt/kvm/kvm_main.c virt/kvm/kvm_main.c
index 89489996fbc1..76801d103dd9 100644
--- virt/kvm/kvm_main.c
+++ virt/kvm/kvm_main.c
@@ -4475,6 +4475,10 @@ static long kvm_vcpu_ioctl(struct file *filp,
                 */
                rseq_virt_userspace_exit();
 
+               if (vcpu->run->exit_reason == KVM_EXIT_MEMORY_FAULT &&
+                   r && r != -EFAULT && r != EHWPOISON)
+                       vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
+
                trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
                break;
        }

I don't know that I'm convinced that level of paranoia is worth it though.

> I'm sure this was all carefully considered when designing the interface, I was
> just curious how this particular problem has been solved.

Heh, I like to think we carefully considered the interface, but thinking of every
possible way userspace can be silly is hard :-)
