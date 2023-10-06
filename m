Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072FC1CA93
	for <kvmarm@lists.linux.dev>; Fri,  6 Oct 2023 12:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nkHFSmnL"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-d862533ea85so2420760276.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Oct 2023 05:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696596459; x=1697201259; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kE5lcMpcuRWxeOB9S6L9Si7YaWv5hLYl1VeNlBZzT/8=;
        b=nkHFSmnLcrYptqsudVHa5sl0sqnX3A86TxJwlhN3sgm5x/VaW0W6glcTs69BTSRZIU
         pj3SmYWCdAjIDZmPeRWYz+566hcx1nq1wljtU8/0lMNhHOqhulFxQ/0MG0xW9JfXro/M
         UyMMGo+N3aPVq4UJOmWqC0UccrdV3Sz7J6MNo7OdygHsmhN7Gnc3/t08RiG3FE1jKd2w
         L+CvbGibOySB0RgzrJdQBKwH0H+KaSjev+ubk+5Hzy8bWFCFML62LI5u4T2FTngW+51X
         8O2a0pmy81zb9gg++marAlgo50QUpE1Gm7vYH7hHaUspJXZSVXY7fSW52gQnwIZ8Flih
         ui2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696596459; x=1697201259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kE5lcMpcuRWxeOB9S6L9Si7YaWv5hLYl1VeNlBZzT/8=;
        b=Q5jCP0Htp3K16KOnHISmYri8s9dDMruhC8ou87wAikGzw+Twp+4nMxs6vhmo2D7mFD
         iGpbwlXE3n2LxzlW/Nc8799O/oYoXhG9CKqgbegPoIy2yg7dWtitLNOcUwk58mP9HMYB
         i0XhjMohYMJuvYLhhPfib4LJ0pfiapkot2dQQ5SGSbNOCuyPcxOf3JV+tUfL+bo0r3LO
         v/mrTmRpueISVGD3m9bvhJ91z678RogMjbx6Qq0MIRtjvn55d3w4a0WngD9P6eRVTpvn
         gZqLVDyhhAv1du8dhGdRb246RX5Ar09Nh8Nj64Ya+VHXqI7j80cJQiMtOpeDU+A29pL6
         d5Fw==
X-Gm-Message-State: AOJu0YwoSEY+AKxXzDhxGwzNR8liEUiGlKtT0OFDSeEqj4yPjSQH/jM+
	B9bu2NLtf0WK33oMXlzhsOCAyqV4BU7ndvtasBQZLQ==
X-Google-Smtp-Source: AGHT+IGILgsJf+f8eayHVHqX0rISrGr9tP06v0nLvKR1oTcr5riaw9zUWCGoAJpDUWeKMDK50UY6pLVZ+E+8O7Aw+dY=
X-Received: by 2002:a5b:807:0:b0:d47:8db3:8bcf with SMTP id
 x7-20020a5b0807000000b00d478db38bcfmr7283393ybp.49.1696596458614; Fri, 06 Oct
 2023 05:47:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CA+EHjTwTgEVtea7wgef5G6EEgFa0so_GbNXTMZNKyFE=ucyV0g@mail.gmail.com>
 <ZR99K_ZuWXEtfDuR@google.com>
In-Reply-To: <ZR99K_ZuWXEtfDuR@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 6 Oct 2023 13:47:01 +0100
Message-ID: <CA+EHjTyDPEY7B_a8GC7RS8gzfoT2q9kJqJPuHB58ZXQ_61NGkQ@mail.gmail.com>
Subject: Re: [RFC PATCH v12 11/33] KVM: Introduce per-page memory attributes
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, KVM <kvm@vger.kernel.org>, 
	"moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" <linux-arm-kernel@lists.infradead.org>, KVMARM <kvmarm@lists.linux.dev>, 
	LinuxMIPS <linux-mips@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, 
	open list <linux-kernel@vger.kernel.org>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sean,

On Fri, Oct 6, 2023 at 4:21=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Oct 05, 2023, Fuad Tabba wrote:
> > Hi Sean,
> >
> > On Tue, Oct 3, 2023 at 9:51=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > > Like I said, pKVM doesn't need a userspace ABI for managing PRIVATE=
/SHARED,
> > > > just a way of tracking in the host kernel of what is shared (as opp=
osed to
> > > > the hypervisor, which already has the knowledge). The solution coul=
d simply
> > > > be that pKVM does not enable KVM_GENERIC_MEMORY_ATTRIBUTES, has its=
 own
> > > > tracking of the status of the guest pages, and only selects KVM_PRI=
VATE_MEM.
> > >
> > > At the risk of overstepping my bounds, I think that effectively givin=
g the guest
> > > full control over what is shared vs. private is a mistake.  It more o=
r less locks
> > > pKVM into a single model, and even within that model, dealing with er=
rors and/or
> > > misbehaving guests becomes unnecessarily problematic.
> > >
> > > Using KVM_SET_MEMORY_ATTRIBUTES may not provide value *today*, e.g. t=
he userspace
> > > side of pKVM could simply "reflect" all conversion hypercalls, and te=
rminate the
> > > VM on errors.  But the cost is very minimal, e.g. a single extra ioct=
l() per
> > > converion, and the upside is that pKVM won't be stuck if a use case c=
omes along
> > > that wants to go beyond "all conversion requests either immediately s=
ucceed or
> > > terminate the guest".
> >
> > Now that I understand the purpose of KVM_SET_MEMORY_ATTRIBUTES, I
> > agree. However, pKVM needs to track at the host kernel (i.e., EL1)
> > whether guest memory is shared or private.
>
> Why does EL1 need it's own view/opinion?  E.g. is it to avoid a accessing=
 data
> that is still private according to EL2 (on behalf of the guest)?
>
> Assuming that's the case, why can't EL1 wait until it gets confirmation f=
rom EL2
> that the data is fully shared before doing whatever it is that needs to b=
e done?
>
> Ah, is the problem that whether or not .mmap() is allowed keys off of the=
 state
> of the memory attributes?  If that's so, then yeah, an internal flag in a=
ttributes
> is probably the way to go.  It doesn't need to be a "host kernel private"=
 flag
> though, e.g. an IN_FLUX flag to capture that the attributes aren't fully =
realized
> might be more intuitive for readers, and might have utility for other att=
ributes
> in the future too.

Yes, it's because of mmap. I think that an IN_FLUX flag might work
here. I'll have a go at it and see how it turns out.

Thanks,
/fuad

>
> > One approach would be to add another flag to the attributes that
> > tracks the host kernel view. The way KVM_SET_MEMORY_ATTRIBUTES is
> > implemented now, userspace can zero it, so in that case, that
> > operation would need to be masked to avoid that.
> >
> > Another approach would be to have a pKVM-specific xarray (or similar)
> > to do the tracking, but since there is a structure that's already
> > doing something similar (i.e.,the attributes array), it seems like it
> > would be unnecessary overhead.
> >
> > Do you have any ideas or preferences?
> >
> > Cheers,
> > /fuad
