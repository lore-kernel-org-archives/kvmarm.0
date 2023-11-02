Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76342D611
	for <kvmarm@lists.linux.dev>; Thu,  2 Nov 2023 14:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tRZssyH7"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5b1ff96d5b9so14872617b3.1
        for <kvmarm@lists.linux.dev>; Thu, 02 Nov 2023 07:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698936092; x=1699540892; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xhBeRDHIuw2MhHJCiZzpmIP+VopsidfcOzvL++iqJMc=;
        b=tRZssyH7do9XHOpSodvAE2DfXNI8tn2/mEIpe9kl+1xrkIKsXIW+hi/VbKCPvusFdN
         7Yey6o2GoueYpNZ9mnD2ZLl/OGrnhYSC5AoW83fXjxh6LboUr4vfz2MfMr7lYgerWLxk
         uhfIaTbVVoi9bz8xOcJTFeWGNZtku8R92TvdESjai0v+gWVTzzWYVJ1dAX3KaMKX5anl
         O7Tsj/Gjpl4Gbr2bLZdbSWEkZ9BZGKNwLeBEr7qGEdiNP/ZR9eKJFuHJzy9hBZtepuAX
         NfuTVL/hIJuwkkuisezHG/Zw75sDoF2TG/cCeqCtm5ess21WgZDbjmWWsh/9nYos4KX2
         t43w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698936092; x=1699540892;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xhBeRDHIuw2MhHJCiZzpmIP+VopsidfcOzvL++iqJMc=;
        b=MWCSdDv/q+eitKkgFycNnh0pGzDaYMjAyQqS0Euypy5yC5eV0Z4iZyQsQV+aHobS28
         Dlz2zLJCcilFiaDK5A6D/gyYPr+JM54x7EMjeQsFLo5O4KrmwxdPOR/DyppZ3hrgNrpx
         TD5Wt12UmrtLRo43j+oRsfJByZRfuAUrpqIQhpNMd12X7c62tvoQNGnCO5cNqopqFLse
         iLpe8HVboAzMf8XgQFIHPWAIKJgwmkBnHTH3fBvCHPu5T/b5ospf3DIm5GEHvZ2AnRY8
         e2hJcnRbmk+ZtgcmfxzukbXi4EWt1HMgSNkJ9bz3Vd5V62073PITOGN649U+1V2vKVv0
         Z5gA==
X-Gm-Message-State: AOJu0YynFydMX/MsJD7zJ3OPh5pK8JpOUzWRrSHrRiPOFDap/K9iQBZW
	dOcUMOsvgdJICjxNCWbWy5Cbki1S8lQ=
X-Google-Smtp-Source: AGHT+IGookYXrYm1A+ma3WZO34BPnkwMLXQzWy+6HX4P/l5wwOteWAD0NK2vYdNE8zwnCUE9EMm+eRT161A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2fce:0:b0:d9a:f3dc:7d19 with SMTP id
 v197-20020a252fce000000b00d9af3dc7d19mr331431ybv.11.1698936092597; Thu, 02
 Nov 2023 07:41:32 -0700 (PDT)
Date: Thu, 2 Nov 2023 07:41:30 -0700
In-Reply-To: <CA+EHjTyAU9XZ3OgqXjmAKh-BKsLrH_8QtnJihQxF4fhk8WPSYg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-13-seanjc@google.com>
 <CA+EHjTyAU9XZ3OgqXjmAKh-BKsLrH_8QtnJihQxF4fhk8WPSYg@mail.gmail.com>
Message-ID: <ZUO1Giju0GkUdF0o@google.com>
Subject: Re: [PATCH v13 12/35] KVM: Prepare for handling only shared mappings
 in mmu_notifier events
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
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
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 02, 2023, Fuad Tabba wrote:
> Hi,
>=20
> On Fri, Oct 27, 2023 at 7:22=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > Add flags to "struct kvm_gfn_range" to let notifier events target only
> > shared and only private mappings, and write up the existing mmu_notifie=
r
> > events to be shared-only (private memory is never associated with a
> > userspace virtual address, i.e. can't be reached via mmu_notifiers).
> >
> > Add two flags so that KVM can handle the three possibilities (shared,
> > private, and shared+private) without needing something like a tri-state
> > enum.
> >
> > Link: https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  include/linux/kvm_host.h | 2 ++
> >  virt/kvm/kvm_main.c      | 7 +++++++
> >  2 files changed, 9 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 96aa930536b1..89c1a991a3b8 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -263,6 +263,8 @@ struct kvm_gfn_range {
> >         gfn_t start;
> >         gfn_t end;
> >         union kvm_mmu_notifier_arg arg;
> > +       bool only_private;
> > +       bool only_shared;
>=20
> If these flags aren't used in this patch series, should this patch be
> moved to the other series?

If *both* TDX and SNP need this patch, then I think it's probably worth app=
lying
it now to make their lives easier.  But if only one needs the support, then=
 I
completely agree this should be punted to whichever series needs it (this a=
lso
came up in v11, but we didn't force the issue).

Mike, Isaku?

> Also, if shared+private is a possibility, doesn't the prefix "only_"
> confuse things a bit? I.e., what is shared+private, is it when both
> are 0 or when both are 1? I assume it's the former (both are 0), but
> it might be clearer.

Heh, I was hoping that "only_private && only_shared" would be obviously non=
sensical.

The only alternative I can think would be to add an enum, e.g.

	enum {
		PROCESS_PRIVATE_AND_SHARED,
		PROCESS_ONLY_PRIVATE,
		PROCESS_ONLY_SHARED,
	};

because every other way of expressing the flags either results in more conf=
usion
or an unsafe default.  I.e. I want zapping only private or only shared to r=
equire
the caller to explicitly set a non-zero value, which is how I ended up with
"only_{private,shared}" as opposed to "process_{private,shared}".
