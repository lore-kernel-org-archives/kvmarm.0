Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B05A273EB
	for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 17:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SXEDHdvl"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3296b3f03e5so4126975f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 10:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697476062; x=1698080862; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+zQrYEvXnLCHkkOB8VHblH7XpBcPGsp++uxmjtzIDQ=;
        b=SXEDHdvl+NijqeZZrBG1BikgjOcKQ/bKLBM9WyaA/10gJastPKrMBglcSgXS48mMLH
         pItLBmRUEmKS4bDIHjh889km6hfvXakGbmwX5aP8+xW2USllpQcjejr4HfPNHqxgPd6y
         ZlTLhdf12K+UmBKDx/g48hcfSaEy9+sJbxRqKZsVG6936U1fqKfNUSY5mMennaSAIjkZ
         E0WaiCVl99nEgYWU4bbTbVJtUSUdZwo3Kw4gxs4v4j8V5msGE2uWpMvrVYjts4JkpDio
         73ay31yW8T8degf/KoU8kbHDA5rBNlQk6tObYwbIJGYTymftBnb/+gV3Iy80T6Li8jFW
         WAiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697476062; x=1698080862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0+zQrYEvXnLCHkkOB8VHblH7XpBcPGsp++uxmjtzIDQ=;
        b=X8s7hp4jS9+aBQsoHuaR/nn6xnXcDK7Hn28tJaqmXMH5FfFe+2drtNCHSi3LCtfNdd
         okAsjnk7o6oS+h2FXb/Q0Peicm9j0+Hhb0apm6oKL/lxjujxN4JcvUSl2a6FBGsQlKzV
         hSgeHoD2k27u3HTUEuZuFTkrweG+U2f+ayaYrjPL6KVEyvQqwNdtj02b1ncdlvhjgv0W
         lOrFES1MzlA2yVDiaTTTunp6AB/1e9ZSXmURS5vBC39BQTTGEQcq4B2cuZhQquQzRbOF
         Gzcj1a+1n3w7U1ON6JG3LF4zelT8axakDErP59Jqbwe27MpjiU9lEEIurCb6FDKvn9Oc
         OfSQ==
X-Gm-Message-State: AOJu0YzxYiql9FTAGPxlKJbChdyiR75kNP1dQg/P9keS+gw0jicR2Kd3
	lRz1xK45JREAorzdyWXOsAUanOB07Gc+9IP9ac9xmw==
X-Google-Smtp-Source: AGHT+IFK6RKBNEvODd5aHPnTEVKQvQycQVUxoXfxKTVAtpxKSS6i088tsqV/S0xtwtYtI9wGd7+5xo/c/eRvSQ8KRHg=
X-Received: by 2002:a5d:5247:0:b0:32d:9585:8680 with SMTP id
 k7-20020a5d5247000000b0032d95858680mr36710wrc.4.1697476062129; Mon, 16 Oct
 2023 10:07:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-5-amoorthy@google.com>
 <CALzav=crDptzFeAoyLrAekp--mM3Y7mFcPMW5W3YdPctkS6YUQ@mail.gmail.com> <ZSXg2CjvVb0ugikT@google.com>
In-Reply-To: <ZSXg2CjvVb0ugikT@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 16 Oct 2023 10:07:12 -0700
Message-ID: <CALzav=fX+cCXQBXhxvRx0KZvHP=GdbP88Kvk9pnx=Ndsf9awEw@mail.gmail.com>
Subject: Re: [PATCH v5 04/17] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To: Sean Christopherson <seanjc@google.com>
Cc: Anish Moorthy <amoorthy@google.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 10, 2023 at 4:40=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Oct 10, 2023, David Matlack wrote:
> > On Fri, Sep 8, 2023 at 3:30=E2=80=AFPM Anish Moorthy <amoorthy@google.c=
om> wrote:
> > >
> > > +::
> > > +       union {
> > > +               /* KVM_SPEC_EXIT_MEMORY_FAULT */
> > > +               struct {
> > > +                       __u64 flags;
> > > +                       __u64 gpa;
> > > +                       __u64 len; /* in bytes */
> >
> > I wonder if `gpa` and `len` should just be replaced with `gfn`.
> >
> > - We don't seem to care about returning an exact `gpa` out to
> > userspace since this series just returns gpa =3D gfn * PAGE_SIZE out to
> > userspace.
> > - The len we return seems kind of arbitrary. PAGE_SIZE on x86 and
> > vma_pagesize on ARM64. But at the end of the day we're not asking the
> > kernel to fault in any specific length of mapping. We're just asking
> > for gfn-to-pfn for a specific gfn.
> > - I'm not sure userspace will want to do anything with this information=
.
>
> Extending ABI is tricky.  E.g. if a use case comes along that needs/wants=
 to
> return a range, then we'd need to add a flag and also update userspace to=
 actually
> do the right thing.
>
> The page fault path doesn't need such information because hardware gives =
a very
> precise faulting address.  But if we ever get to a point where KVM provid=
es info
> for uaccess failures, then we'll likely want to provide the range.  E.g. =
if a
> uaccess splits a page, on x86, we'd either need to register our own excep=
tion
> fixup and use custom uaccess macros (eww), or convice the world that exte=
nding
> ex_handler_uaccess() and all of the uaccess macros that they need to prov=
ide the
> exact address that failed.

I wonder if userspace might need a precise fault address in some
situations? e.g. If KVM returns -HWPOISON for an access that spans a
page boundary, userspace won't know which is poisoned. Maybe SNP/TDX
need precise fault addresses as well? I don't know enough about how
SNP and TDX plan to use this UAPI.


>
> And for SNP and TDX, I believe the range will be used when the guest uses=
 a
> hardware-vendor-defined hypercall to request conversions between private =
and
> shared.  Or maybe the plan is to funnel those into KVM_HC_MAP_GPA_RANGE?
