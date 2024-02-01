Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAB38527B
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 19:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706815533; cv=none; b=U781K5at92u+xoDSVmSOqyDA50Sxml4724TwUIy6FdTJA6iorbKYdXt1S6IP7fXIsGmHECwQApaadZ2Qb2ry8j/t2AZ3sFATsEFfc3M8exI+/OHciDyMu4XnKqr+Pd2XZUPyO33zYy3w3up6cORo4ev6kvco1a9UaYGfpJW2Mp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706815533; c=relaxed/simple;
	bh=bvbCut5oOWOl+iOeVLTeOOig5dbdTfqbdQOGLCL2GfQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OlQvHJCMjDCGbtdnXg3tvDLnmBAQ433iOBO0ERUC38ChuzvLOOGStfH/0akllPVy6CYIDDsXbyKbsBGeX0soP9xD4hZiJ99sQR0OTftvHE62nkBQHEjVPeM+UQ5m8Jqbsyb+uNnN7Gv+Em5rV2Qyn0RO5LvahZc1+l9nDansHZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CFW0GX+q; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CFW0GX+q"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-214d79d4a3cso756695fac.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 11:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706815531; x=1707420331; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ubal1OrVwa84Y35GoSFEWShJgB/F1V74QFj/kiIz0Io=;
        b=CFW0GX+ql7ypQySrlra+1Oh+ooyTPA7+2/Tyo5upO1hZn8Wce5ayRrVXbBIfuMPAe7
         a+uRdrCKfTI1p+8Fmp6KY9VWQ7QuyKDh5aMnUw+QijXwBtsbNPZVHpVwoB8srIha34U3
         PG7pyE3WcFWPTZPmSqmoLIkI3JpdQgA1IP+teoXdgiqhpTBupE62EmJ5YKuuEnggc0e+
         j5nGqKjtSVlpGpa2jy1sxeOPdsJYzYpDApwTT+AwG3BCAvigo7iFx4fAXE9Xu2q5UrEy
         n93su1K+w979nsI0KMbpY4ev90ShTXFMSiCqskRfxPDlWXcg8t+mODrhx0ZHwvRika6b
         iZZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706815531; x=1707420331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ubal1OrVwa84Y35GoSFEWShJgB/F1V74QFj/kiIz0Io=;
        b=lHkBTD4mqMEgvNta1bYPp+yU5uOo1MWS2+nf0CcsZ+VDnLUXGCI2I04CUU3oV3UpPv
         f95Aktgp4XOH54tiw71oZdIpnjbV3hbekPrBP18EnoOklc50CVT7o55ur0oKkwTO3N47
         FdjNY3GIDKzCSW3k2wR5DesiWp72mOk1Jz06q8BE/1P5MY/Ae0s3ooT1r8eoxHJUbutX
         4E41GwSRzgzV6b48qNj1Zsg8DQu5+mRDMqlcU44tugn/aKIN7+H7Q1MxjzLWEB/WAvPz
         /KNtb5XdtJAvzkvjtYrySgldcosJj3eeBc0EHHzbdk5Ce3TJYm2p+LBcgkxGFVxSdsDj
         hkhw==
X-Gm-Message-State: AOJu0YyubmugezkfJ9baBLIfYic5sFF1RY0A4BvnRpNA0Ai//z5AO1Y/
	30YPgTm6piwU6vSJhCTJ1U8Ow986mtxvLuJ0Ky48xQQh2ljXbFn4fxnYYtTmYVwqWyTndNOJ3Fj
	M36QJ4CwUO13raG3JQs6sAbuvWzrH/avAUor4
X-Google-Smtp-Source: AGHT+IEmwK+hYVU5DGWRUAShOp5HV+LvB3R9bXJfvSEQJSjfQucoVuwPxZXFT8CL269XTs7i07H8EV8dXI8or3Sh96E=
X-Received: by 2002:a05:6871:5224:b0:206:862e:1b86 with SMTP id
 ht36-20020a056871522400b00206862e1b86mr6145413oac.31.1706815531449; Thu, 01
 Feb 2024 11:25:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-7-amoorthy@google.com>
 <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com>
 <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
 <CADrL8HXSzm_C9UwUb8-H_c6-TRgpkKLE+qeXfyN-X_rHGj2vuw@mail.gmail.com>
 <ZbrxiSNV7e1C6LO-@linux.dev> <ZbvGoz67L3gtnHhI@google.com>
In-Reply-To: <ZbvGoz67L3gtnHhI@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 1 Feb 2024 11:24:54 -0800
Message-ID: <CAF7b7mpAt9Dr2jqU6uH=e9gno282BwtHcU7cSSrdBWz7adAW1A@mail.gmail.com>
Subject: Re: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2024 at 4:26=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> On that note, I think we need to drop the patch that causes
> read-faults in RO memslots to go through fast GUP. KVM didn't do that
> for a good reason[1].

Thanks a ton for catching this James! That's some informative reading,
and a good reminder to be extra careful messing with stuff I don't
quite understand.

On Thu, Feb 1, 2024 at 8:28=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Feb 01, 2024, Oliver Upton wrote:
> > On Wed, Jan 31, 2024 at 04:26:08PM -0800, James Houghton wrote:
> > > On Wed, Jan 31, 2024 at 2:00=E2=80=AFPM Anish Moorthy <amoorthy@googl=
e.com> wrote:
> >
> > [...]
> >
> > > On that note, I think we need to drop the patch that causes
> > > read-faults in RO memslots to go through fast GUP. KVM didn't do that
> > > for a good reason[1].
> > >
> > > That would break KVM_EXIT_ON_MISSING for RO memslots, so I think that
> > > the right way to implement KVM_EXIT_ON_MISSING is to have
> > > hva_to_pfn_slow pass FOLL_NOFAULT, at least for the RO memslot case.
> > > We still get the win we're looking for: don't grab the userfaultfd
> > > locks.
> >
> > Is there even a legitimate use case that warrants optimizing faults on
> > RO memslots? My expectation is that the VMM uses these to back things
> > like guest ROM, or at least that's what QEMU does. In that case I'd
> > expect faults to be exceedingly rare, and if the VMM actually cared it
> > could just pre-populate the primary mapping.
> >
> > I understand why we would want to support KVM_EXIT_ON_MISSING for the
> > sake of completeness of the UAPI, but it'd be surprising if this
> > mattered in the context of post-copy.
>
> Yeah, I let's just make KVM_EXIT_ON_MISSING mutually exclusive with
> KVM_MEM_READONLY.  KVM (oviously) honors the primary MMU protections, so =
userspace
> can (and does) map read-only memory into the guest without READONLY.  As =
Oliver
> pointed out, making the *memslot* RO is intended for use cases where user=
space
> wants writes to be treated like emulated MMIO.
>
> We can always add support in the future in the extremely unlikely event s=
omeone
> comes along with a legitimate reason for KVM_EXIT_ON_MISSING to play nice=
 with
> KVM_MEM_READONLY.

Gotcha, I'll go ahead and make the flags incompatible for the next
version. Thanks for the tidbit on how RO memslots are used Oliver- I
didn't know that we expect faults on these to be so rare.
