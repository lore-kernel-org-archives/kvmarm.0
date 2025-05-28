Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D269728B514
	for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 15:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748447328; cv=none; b=eChjKUnThFdUfDjGfGo4aimo8/7FlNxiEtoOEFq4eIxKmuTU2EUbp0F5cwZhlRUDj785XqlB7PAXwLnONowYbHQY6+lsMdVcfD22XoN9QxdPQhvxo+kNe8zQeKUzxFBCURFn1E3xmN9WqueDzlHE1OmUw6whA0hY5AHBM3I8orw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748447328; c=relaxed/simple;
	bh=WIlV51wEuAd2rtYOVeO8B1eFmuqdgn/T2swun7fdn7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D3WazzE2vUSH3mmYJEet8AbM1bbYdv9Zc2qPNThHg/P8gSOQGYack2YteKjOZ0Mt/MAs7po+SER4lfiWHTjeMQkQq/T9iy4neHxXwbwBo5ukXaasmrHKcfMQ34xuAs6YuFW6z3mrvae8u8mmlixgMCsoLsh0gWWauURIBqgfuhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TbtcJakv; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TbtcJakv"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e7da20d35ddso3198912276.1
        for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 08:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748447326; x=1749052126; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qJhBrTcV/2KTHPEGx8A5eIEZm9bF8mIMQSTTxnrKh3w=;
        b=TbtcJakvMZw35WS9MJtTuVCuNakCnOJ8LFrapaHXraBmZDCRYX+uaGWb6f4USIJLVr
         3WWB+QaNAgUSh/uXGas+In4TkDQYspM2TLkz9+eMLGRKAsZMniHjdfYCa0cit4qjInMP
         dEXDGPlwCaUWM8P9bk0wnbKJ8suYlvBJyIG7ks+nsHynAvXXzDgef7MEOVRB1Ncfydvg
         Oz9+XZ4MUGVwi3Q0ial+Ud6r02eqss1vqfJx5iFGpz0vA7Vpb/FEwtLMHS8G2mxoqTt4
         prYW/4cltRmKCFUFMthxOW2RJau9u8HMnHAR+I91Mh9m94N6DF6PEqLyaLqim/hhj3vf
         GgSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748447326; x=1749052126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qJhBrTcV/2KTHPEGx8A5eIEZm9bF8mIMQSTTxnrKh3w=;
        b=f9F64ab/XsJV15oqDzNGWEufIz6/wymEPjoWkzlVkAhdyROBwL2oYxGvbBPP9lI5+W
         wc6q6i6/gWKr35UWtJ44OPa63sf4MpMu8L+b/Bhdjj1wmx9gCFUFRRskJLt03mQAb20J
         hIcvi/N5EtWJCAzpfIFCzKDjBveYcf1I0e8Q2yeef0DP9RMwTXmBwFpOuOIfDk1HaiUQ
         nDjCjJ93d9xwn8lAmw+lr5Zou8FU3c2ukxABGry/5LaSfKQS6jwyBMRh3KnHeTl5CPhh
         yV9WYeFyeEiBfmPaoMCaGh00ZQH3+ORmU6oKn7yrI42V1Xb2QqWe04tEqV4cJe1E/NvF
         +8XA==
X-Forwarded-Encrypted: i=1; AJvYcCU5AGewdrk2C25bDIaBKE8QcFD2cw+W/73X4DCwq1r9auwGEM4sDyv7Ai9WS9QUg1CVdi49dWg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8vimIfRUMijEUEtPwyVkcu2POaeY4VUYdoB8UnnKsZOcjt2dm
	b2z+GPJR13ArFwHX5LeLM2puTerF+yv+84k4cfjXtgvZPKcymGA5/3Ik1htXLxRgTh4+SnaFbxK
	fYwf9Yr9lc6JKF2ILtHkr8P+bLZKl1Mt9iZ7hwzgi
X-Gm-Gg: ASbGncuvokN8cP4TnZWMo8dkpNO4eHjL7N6GrFvCu7YwCbixUS8WWmwaxGltavpjxCF
	qpcbN+JCDUCsyEnTjnvuCF5ZNBCSIsuWnmYdC/WVbdOByEg7mZt9AsuVRYCAnkD13aZ6gqQ3e46
	SxSkv0snxJDujL6nLeekIQlP1kHspr3wqvd/ccBYETI8PZcoKxJL4FO2RETv/IJiccAkwmXILTA
	hp7bQ==
X-Google-Smtp-Source: AGHT+IELfFCth5Pbkc2q+fs3hGfuRfgdVh0Gdule7jkxxm4LWUKEs85HrAmHhTzH2guxXlvKX1XFjzs03oe3LxVeaz0=
X-Received: by 2002:a05:690c:c02:b0:6fb:9280:5bf4 with SMTP id
 00721157ae682-70e2da69ba1mr219329397b3.30.1748447325426; Wed, 28 May 2025
 08:48:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com> <aBqlkz1bqhu-9toV@google.com>
In-Reply-To: <aBqlkz1bqhu-9toV@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 28 May 2025 11:48:09 -0400
X-Gm-Features: AX0GCFuLPsZ5TxH5z7efpKpwgvPpjgQZqJBp0wjKrKAAM8LNrge9ZlG7omP9Ut0
Message-ID: <CADrL8HXjLjVyFiFee9Q58TQ9zBfXiO+VG=25Rw4UD+fbDmxQFg@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] KVM: Introduce KVM Userfault
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 6, 2025 at 8:13=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Jan 09, 2025, James Houghton wrote:
> >   KVM: Add KVM_MEM_USERFAULT memslot flag and bitmap
> >   KVM: Add KVM_MEMORY_EXIT_FLAG_USERFAULT
> >   KVM: Allow late setting of KVM_MEM_USERFAULT on guest_memfd memslot
> >   KVM: Advertise KVM_CAP_USERFAULT in KVM_CHECK_EXTENSION
> >   KVM: x86/mmu: Add support for KVM_MEM_USERFAULT
> >   KVM: arm64: Add support for KVM_MEM_USERFAULT
> >   KVM: selftests: Fix vm_mem_region_set_flags docstring
> >   KVM: selftests: Fix prefault_mem logic
> >   KVM: selftests: Add va_start/end into uffd_desc
> >   KVM: selftests: Add KVM Userfault mode to demand_paging_test
> >   KVM: selftests: Inform set_memory_region_test of KVM_MEM_USERFAULT
> >   KVM: selftests: Add KVM_MEM_USERFAULT + guest_memfd toggle tests
> >   KVM: Documentation: Add KVM_CAP_USERFAULT and KVM_MEM_USERFAULT
> >     details
> >
> >  Documentation/virt/kvm/api.rst                |  33 +++-
> >  arch/arm64/kvm/Kconfig                        |   1 +
> >  arch/arm64/kvm/mmu.c                          |  26 +++-
> >  arch/x86/kvm/Kconfig                          |   1 +
> >  arch/x86/kvm/mmu/mmu.c                        |  27 +++-
> >  arch/x86/kvm/mmu/mmu_internal.h               |  20 ++-
> >  arch/x86/kvm/x86.c                            |  36 +++--
> >  include/linux/kvm_host.h                      |  19 ++-
> >  include/uapi/linux/kvm.h                      |   6 +-
> >  .../selftests/kvm/demand_paging_test.c        | 145 ++++++++++++++++--
> >  .../testing/selftests/kvm/include/kvm_util.h  |   5 +
> >  .../selftests/kvm/include/userfaultfd_util.h  |   2 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c    |  42 ++++-
> >  .../selftests/kvm/lib/userfaultfd_util.c      |   2 +
> >  .../selftests/kvm/set_memory_region_test.c    |  33 ++++
> >  virt/kvm/Kconfig                              |   3 +
> >  virt/kvm/kvm_main.c                           |  54 ++++++-
> >  17 files changed, 419 insertions(+), 36 deletions(-)
>
> I didn't look at the selftests changes, but nothing in this series scares=
 me.  We
> bikeshedded most of this death this in the "exit on missing" series, so f=
or me at
> least, the only real question is whether or not we want to add the uAPI. =
 AFAIK,
> this is best proposal for post-copy guest_memfd support (and not just bec=
ause it's
> the only proposal :-D).

The only thing that I want to call out again is that this UAPI works
great for when we are going from userfault --> !userfault. That is, it
works well for postcopy (both for guest_memfd and for standard
memslots where userfaultfd scalability is a concern).

But there is another use case worth bringing up: unmapping pages that
the VMM is emulating as poisoned.

Normally this can be handled by mm (e.g. with UFFDIO_POISON), but for
4K poison within a HugeTLB-backed memslot (if the HugeTLB page remains
mapped in userspace), KVM Userfault is the only option (if we don't
want to punch holes in memslots). This leaves us with three problems:

1. If using KVM Userfault to emulate poison, we are stuck with small
pages in stage 2 for the entire memslot.
2. We must unmap everything when toggling on KVM Userfault just to
unmap a single page.
3. If KVM Userfault is already enabled, we have no choice but to
toggle KVM Userfault off and on again to unmap the newly poisoned
pages (i.e., there is no ioctl to scan the bitmap and unmap
newly-userfault pages).

All of these are non-issues if we emulate poison by removing memslots,
and I think that's possible. But if that proves too slow, we'd need to
be a little bit more clever with hugepage recovery and with unmapping
newly-userfault pages, both of which I think can be solved by adding
some kind of bitmap re-scan ioctl. We can do that later if the need
arises.

> So... yes?

Thanks Sean!

> Attached are a variation on the series using the common "struct kvm_page_=
fault"
> idea.  The documentation change could be squashed with the final enableme=
nt patch.
>
> Compile tested only.  I would not be the least bit surprised if I complet=
ely
> butchered something.

Looks good! The new selftests work just fine.
