Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04E1354E8
	for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 22:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wue7V3oA"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-32799639a2aso5995339f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 15:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696978753; x=1697583553; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2nacyxABp1UL03gZHXlkGoDpYi4y+fBMtTei3+pcLfc=;
        b=wue7V3oAtAFcxXUuxM3h9KEea1C3pryfB+7hxP6MvVUDz1rkx73e3NxLVpfmmsLV0k
         Wl8RzNaiDwhQLb6lb1eYyNW4JOrRD05k2ebmCQVdJRVKQaUadHIC/2r3O0rYatSlTrmn
         2fkTlXvtuPjpVJntxZIIYUolIJ6Ce28UJjQ3Lysc+PDs8oZosd/LYlPVSevwJRJiYzyA
         +khS+FxzotYb21jtMsPiSe8+IK2ao3Ze5F1ByWRYi86gg8wywBacnuWdz2Y5yST63CIB
         qmW7D06JVnNcrqSveHFhVW3dFBM6O4BGqFqNz0+Ip9Oy2eAD16pFr/I+MKYEh6JA8h8t
         wy1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696978753; x=1697583553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2nacyxABp1UL03gZHXlkGoDpYi4y+fBMtTei3+pcLfc=;
        b=YdXsw7tTDQ08VoeSaFgTSfn2pN/8XVvqXrR4G+bxsS7TpPxkj7K0nbBUOtw0dTrHTn
         bGr6AJlRyEwN4tNOqIguGMbBQbuKqvcqBmM1grgEhU/1Kij3tdzFATuMTDGI8VhLgmty
         UNB9Shc/9Ot/3ys7ujDTY55xv3JdU0Z6bd4RgxOZldG3NdfU/IaT1seNCBc17Tgb6qPf
         32jwATypWnF1qXMTYQvCnQ3x6DTIRJQjW2/8q1GR+t0KSoVHZEpY425v44Z/RudA94M4
         9fJsFVcuPyIiYB+DYBW+ZEoN3jK1Il7ocsFmJs+8Qh7FFbTLmeOn1PONupPjokFdozXC
         gzHw==
X-Gm-Message-State: AOJu0YzUg4KiAwP7q2aMEPvLav6XAUQGqELz3lWSIDcJtakd/7qebBUD
	kDJs/1Mw0Kln6Tfr6I8OlmMtci1H4MZNv5SyUzOAhA==
X-Google-Smtp-Source: AGHT+IFH+SOajooUfNwv0nZc5mlpLm234ee1vlA7EQQjes00sGcgpxOTQ+PCLWi4VGGu6ePaHkbbxNCMiY0cEJ/uN34=
X-Received: by 2002:adf:e852:0:b0:315:9e1b:4ea6 with SMTP id
 d18-20020adfe852000000b003159e1b4ea6mr16525699wrn.58.1696978752971; Tue, 10
 Oct 2023 15:59:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-5-amoorthy@google.com>
In-Reply-To: <20230908222905.1321305-5-amoorthy@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 10 Oct 2023 15:58:43 -0700
Message-ID: <CALzav=crDptzFeAoyLrAekp--mM3Y7mFcPMW5W3YdPctkS6YUQ@mail.gmail.com>
Subject: Re: [PATCH v5 04/17] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To: Anish Moorthy <amoorthy@google.com>
Cc: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 8, 2023 at 3:30=E2=80=AFPM Anish Moorthy <amoorthy@google.com> =
wrote:
>
> KVM_CAP_MEMORY_FAULT_INFO allows kvm_run to return useful information
> besides a return value of -1 and errno of EFAULT when a vCPU fails an
> access to guest memory which may be resolvable by userspace.
>
> Add documentation, updates to the KVM headers, and a helper function
> (kvm_handle_guest_uaccess_fault()) for implementing the capability.
>
> Mark KVM_CAP_MEMORY_FAULT_INFO as available on arm64 and x86, even
> though EFAULT annotation are currently totally absent. Picking a point
> to declare the implementation "done" is difficult because
>
>   1. Annotations will be performed incrementally in subsequent commits
>      across both core and arch-specific KVM.
>   2. The initial series will very likely miss some cases which need
>      annotation. Although these omissions are to be fixed in the future,
>      userspace thus still needs to expect and be able to handle
>      unannotated EFAULTs.
>
> Given these qualifications, just marking it available here seems the
> least arbitrary thing to do.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
[...]
> +::
> +       union {
> +               /* KVM_SPEC_EXIT_MEMORY_FAULT */
> +               struct {
> +                       __u64 flags;
> +                       __u64 gpa;
> +                       __u64 len; /* in bytes */

I wonder if `gpa` and `len` should just be replaced with `gfn`.

- We don't seem to care about returning an exact `gpa` out to
userspace since this series just returns gpa =3D gfn * PAGE_SIZE out to
userspace.
- The len we return seems kind of arbitrary. PAGE_SIZE on x86 and
vma_pagesize on ARM64. But at the end of the day we're not asking the
kernel to fault in any specific length of mapping. We're just asking
for gfn-to-pfn for a specific gfn.
- I'm not sure userspace will want to do anything with this information.
