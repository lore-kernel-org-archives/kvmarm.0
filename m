Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E25354EF
	for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 23:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X7eSqRib"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d9a5995aa42so1765951276.2
        for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 16:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696981209; x=1697586009; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cLHhlCA6SVyHFYWwV93GW9D+Ewl3smDZeYf93/ceN0Y=;
        b=X7eSqRibjudXD1YQfmcAxEoThREC9/3CqCl51hXcdWRPzwRIPCpRhAflV9w1xi46Ab
         em4x5ResmG1SfG/x8Iw9P44lk+TICq+ibwzYkwwCfrN7mkLVVXxVhAEZuwGMBozvT5CH
         vmFZRZ+d5x7Yck1rHA8CPB+6s4YxFnz8/QVyyMF9Wtw1p40/IyDeitn6FgHk7JAhs94q
         zWTDojEml5kVJHwWNKwci9i+K0mJjqQq3BhhyQfOq8dfTA0Y0ThBlJkwsrksXjvYhdfU
         K0NJLkLdyKTGzxnZa13U1QMiZPlcQTad1XCAaNAKZPn4QD+zx+zkC5NlPuBbGyfMmrl3
         ec9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696981209; x=1697586009;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cLHhlCA6SVyHFYWwV93GW9D+Ewl3smDZeYf93/ceN0Y=;
        b=jii0t32kWC9QFAFfZhRRzOGZQThrKTpFU25jZJRcPBMSkts+5+uR8+QrDckgWXCd4v
         qN2HNDfDSRbW/ammdM2ikcNLtEKKUkCIuKZFRerPParEggZFYnM9qU+B6XCWRSmTF3zw
         c3EhsCSiSfQT+Kmg659KnGcbxWs/Hr6MlnssAhiMHUsuyC1xzxA0xnP5lMRk7F9BT3c7
         muO/mFze1RtmxgXq1et2bqahWiHtKFjrj+AKapKIX30p8mMOFgp/8swKH5+2K564UKQg
         c4FThssRjVR7kPp0i4bcdnrbrX8TBwDqsuwwAmVBuPoGB9dhbduJ5zTeW8RRxun69Jej
         7EHQ==
X-Gm-Message-State: AOJu0Yye0oavl4DHWkqLRa8LLafcV/A52rOKegE1C2Kty1CcrfpfcAGk
	d3JoTfHq387jl7sqJvWg07+bcThzJ5k=
X-Google-Smtp-Source: AGHT+IEu6vz/xlJWvZL8I5SvgfFc5v5rUNmLRU3fOUbQ9vo/AgeOeVtzHLQG68iQTxM6YVfRHff9q0T4lYI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:13cc:b0:d91:8876:2040 with SMTP id
 y12-20020a05690213cc00b00d9188762040mr336788ybu.5.1696981209800; Tue, 10 Oct
 2023 16:40:09 -0700 (PDT)
Date: Tue, 10 Oct 2023 16:40:08 -0700
In-Reply-To: <CALzav=crDptzFeAoyLrAekp--mM3Y7mFcPMW5W3YdPctkS6YUQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-5-amoorthy@google.com>
 <CALzav=crDptzFeAoyLrAekp--mM3Y7mFcPMW5W3YdPctkS6YUQ@mail.gmail.com>
Message-ID: <ZSXg2CjvVb0ugikT@google.com>
Subject: Re: [PATCH v5 04/17] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Anish Moorthy <amoorthy@google.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 10, 2023, David Matlack wrote:
> On Fri, Sep 8, 2023 at 3:30=E2=80=AFPM Anish Moorthy <amoorthy@google.com=
> wrote:
> >
> > KVM_CAP_MEMORY_FAULT_INFO allows kvm_run to return useful information
> > besides a return value of -1 and errno of EFAULT when a vCPU fails an
> > access to guest memory which may be resolvable by userspace.
> >
> > Add documentation, updates to the KVM headers, and a helper function
> > (kvm_handle_guest_uaccess_fault()) for implementing the capability.
> >
> > Mark KVM_CAP_MEMORY_FAULT_INFO as available on arm64 and x86, even
> > though EFAULT annotation are currently totally absent. Picking a point
> > to declare the implementation "done" is difficult because
> >
> >   1. Annotations will be performed incrementally in subsequent commits
> >      across both core and arch-specific KVM.
> >   2. The initial series will very likely miss some cases which need
> >      annotation. Although these omissions are to be fixed in the future=
,
> >      userspace thus still needs to expect and be able to handle
> >      unannotated EFAULTs.
> >
> > Given these qualifications, just marking it available here seems the
> > least arbitrary thing to do.
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Anish Moorthy <amoorthy@google.com>
> > ---
> [...]
> > +::
> > +       union {
> > +               /* KVM_SPEC_EXIT_MEMORY_FAULT */
> > +               struct {
> > +                       __u64 flags;
> > +                       __u64 gpa;
> > +                       __u64 len; /* in bytes */
>=20
> I wonder if `gpa` and `len` should just be replaced with `gfn`.
>=20
> - We don't seem to care about returning an exact `gpa` out to
> userspace since this series just returns gpa =3D gfn * PAGE_SIZE out to
> userspace.
> - The len we return seems kind of arbitrary. PAGE_SIZE on x86 and
> vma_pagesize on ARM64. But at the end of the day we're not asking the
> kernel to fault in any specific length of mapping. We're just asking
> for gfn-to-pfn for a specific gfn.
> - I'm not sure userspace will want to do anything with this information.

Extending ABI is tricky.  E.g. if a use case comes along that needs/wants t=
o
return a range, then we'd need to add a flag and also update userspace to a=
ctually
do the right thing.

The page fault path doesn't need such information because hardware gives a =
very
precise faulting address.  But if we ever get to a point where KVM provides=
 info
for uaccess failures, then we'll likely want to provide the range.  E.g. if=
 a
uaccess splits a page, on x86, we'd either need to register our own excepti=
on
fixup and use custom uaccess macros (eww), or convice the world that extend=
ing
ex_handler_uaccess() and all of the uaccess macros that they need to provid=
e the
exact address that failed.

And for SNP and TDX, I believe the range will be used when the guest uses a
hardware-vendor-defined hypercall to request conversions between private an=
d
shared.  Or maybe the plan is to funnel those into KVM_HC_MAP_GPA_RANGE?
