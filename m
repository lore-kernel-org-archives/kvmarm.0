Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E301B274
	for <kvmarm@lists.linux.dev>; Thu,  2 Nov 2023 14:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OUvo3mzq"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-777719639adso59161785a.3
        for <kvmarm@lists.linux.dev>; Thu, 02 Nov 2023 07:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698937067; x=1699541867; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oO6y6W0Hx2JX7rhY2F9inSHXy5EHTr89TCOrnU0rbjw=;
        b=OUvo3mzqxfaAoOh7mkwn5Zy0ahatDbHLJYvcQypZVvFyal1EgtU/64YCzX5izmk5X/
         XYIN/OSTxAAeae2jYMdJt1bbg6ws5MfrVPCeGW9LOQdZ/04YyQ2zC0hwrA29DrKRY6aO
         jhmkCWYxQZKMkTkD+6c+sJE0OapE0FuKXsaLJc2kYOzo6zFKHptyRbTlsr2v1DinPaoC
         FDhvMSqnGWmYEvjPv0Jjk7eRm/xWi8gC++DNyEnlz+SzIioZkdQfcscDJOg4eTKoEMXn
         nOlv2cglIAvkgi3PJ4+2kkCmsOGEG4pgtKr56iFRslSO3a42pxkJ+wzt7mvRirALCMWR
         7GGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698937067; x=1699541867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oO6y6W0Hx2JX7rhY2F9inSHXy5EHTr89TCOrnU0rbjw=;
        b=tBUn1v54DgR2mZUVTr6Xydd0OQTC5zavbVykRe0hmMDtb//TO4ql6PvGwAlQh7Tpzr
         Q/KrzEP+o/L6PNphuOMoHJkUFBw+z2kvWwJPRQTlIYUT20KYd7mcE54yIUhO2DmhNefm
         MxQpkejvVHruZ16nAd91gG6mNTbcxAe1fPijIvltr0C3aLSloFWJ+7FQ9xRdU9iEazS4
         4fbHEBYrndH1VRlI2j3Pt8yi1Zv1mpx3PCzaL3tsDoVrDnxFBk4abOAlj9ge/dUo8nmY
         rqQNGTNyecfwZW/J4igLaCP/1TQDUcdUxZzIxOMVd39IIeVMTrc7JU+lkHL+O3H6S7+c
         A5dA==
X-Gm-Message-State: AOJu0YwHDk/O2eHirMkFrBSq8h8+26p/Kz1RTwyTkWXQxWOxapjrjsVf
	uMgNqGTkNG5Ri7MFL5xLuvyndeaX0FkmmkBzkF/jpQ==
X-Google-Smtp-Source: AGHT+IHH5fWOUl6XWE3cRbRkmtci3EQG11sJ5sTElOUO4i3o8jogptvsMwjY2tQIjVOiF2P5A518xtVBqTDVb2uPT1o=
X-Received: by 2002:a05:6214:252d:b0:66d:1b2f:3f64 with SMTP id
 gg13-20020a056214252d00b0066d1b2f3f64mr24532994qvb.31.1698937066885; Thu, 02
 Nov 2023 07:57:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-13-seanjc@google.com>
 <CA+EHjTyAU9XZ3OgqXjmAKh-BKsLrH_8QtnJihQxF4fhk8WPSYg@mail.gmail.com> <ZUO1Giju0GkUdF0o@google.com>
In-Reply-To: <ZUO1Giju0GkUdF0o@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 2 Nov 2023 14:57:10 +0000
Message-ID: <CA+EHjTwpVSyUC8oiii3EYU8pqEJ0D0NXA1EZt76wjfPBpk2rFA@mail.gmail.com>
Subject: Re: [PATCH v13 12/35] KVM: Prepare for handling only shared mappings
 in mmu_notifier events
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 2, 2023 at 2:41=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Nov 02, 2023, Fuad Tabba wrote:
> > Hi,
> >
> > On Fri, Oct 27, 2023 at 7:22=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > Add flags to "struct kvm_gfn_range" to let notifier events target onl=
y
> > > shared and only private mappings, and write up the existing mmu_notif=
ier
> > > events to be shared-only (private memory is never associated with a
> > > userspace virtual address, i.e. can't be reached via mmu_notifiers).
> > >
> > > Add two flags so that KVM can handle the three possibilities (shared,
> > > private, and shared+private) without needing something like a tri-sta=
te
> > > enum.
> > >
> > > Link: https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  include/linux/kvm_host.h | 2 ++
> > >  virt/kvm/kvm_main.c      | 7 +++++++
> > >  2 files changed, 9 insertions(+)
> > >
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index 96aa930536b1..89c1a991a3b8 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -263,6 +263,8 @@ struct kvm_gfn_range {
> > >         gfn_t start;
> > >         gfn_t end;
> > >         union kvm_mmu_notifier_arg arg;
> > > +       bool only_private;
> > > +       bool only_shared;
> >
> > If these flags aren't used in this patch series, should this patch be
> > moved to the other series?
>
> If *both* TDX and SNP need this patch, then I think it's probably worth a=
pplying
> it now to make their lives easier.  But if only one needs the support, th=
en I
> completely agree this should be punted to whichever series needs it (this=
 also
> came up in v11, but we didn't force the issue).
>
> Mike, Isaku?
>
> > Also, if shared+private is a possibility, doesn't the prefix "only_"
> > confuse things a bit? I.e., what is shared+private, is it when both
> > are 0 or when both are 1? I assume it's the former (both are 0), but
> > it might be clearer.
>
> Heh, I was hoping that "only_private && only_shared" would be obviously n=
onsensical.
>
> The only alternative I can think would be to add an enum, e.g.
>
>         enum {
>                 PROCESS_PRIVATE_AND_SHARED,
>                 PROCESS_ONLY_PRIVATE,
>                 PROCESS_ONLY_SHARED,
>         };
>
> because every other way of expressing the flags either results in more co=
nfusion
> or an unsafe default.  I.e. I want zapping only private or only shared to=
 require
> the caller to explicitly set a non-zero value, which is how I ended up wi=
th
> "only_{private,shared}" as opposed to "process_{private,shared}".

I don't have a strong opinion about this. Having an enum looks good to me.

Cheers,
/fuad
