Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53ACD134CE
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 17:11:16 +0000 (UTC)
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-40c72caec5cso17181cf.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 10:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692119475; x=1692724275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VjU1cPGHPErz26GfxK/V2Y6QQnaVBfBoHVJffwhAgeg=;
        b=OkID7iHXzv+hD+tKR8T6YOXxoIXliF3W34NUBxDaFcmljCtGa4UoyiTKJr8D/Tqe60
         twt1hBEnODfYIcEtDbVnm54kA0lIiilXkx9/J9jQrHX5X/XhOJQ7UdJ3uclpwKIqOirD
         Nz+BaBpxqO9GVtg0Nf9FtqfKgA5MSX6L6ZpkqwrGirkV/80R7EjnEy3vAejyJrvzENi/
         tBF0sSeWY68NphfTowZ3duiS82ZwwGD9DYGMlv24ihtwu4rin3c/EbsSxVYNJXnuceR1
         sl4g7UKfuObykb/yzYDT2NhA5VP8HNK+onSuMDL7WMvns54M1ica33zsia1c0sn9ISDX
         ebGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692119475; x=1692724275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VjU1cPGHPErz26GfxK/V2Y6QQnaVBfBoHVJffwhAgeg=;
        b=dX9732+9QQ3OY3kPA92iQ4ViSiIwSf3XxWMVXak5U9StlV3v7QZnf21bsMGJBUmlx0
         djBQWL6okqz8qJ8SOzcF5T4PBV2QMQF9ww+vOntjISOtm7QLhlPL4WVUoZtuSI2LePNJ
         IMknb9hr9bePzvj4P9rNAVpsj6nwXxroDQN8sN08KFXiJfGvw6GSd0Ht6aLKBl5A8B22
         f5FtPQum6wL0qI6gvKJC6gI30VqnAKn6U9WT8uk6j5aaF1XsRpGZPNqudL+9zFm3a55j
         AqCHK7foWFRemXFI2eVBr5y+Ghvv6fM4PzwTUqU8Pv5nYvW4iNpydsiy1u/2zcB1S8tY
         wocA==
X-Gm-Message-State: AOJu0Yy5t03iluqQTC20sC6t75lq4fLMsUbDjC53JHJ4kgKTsHAJYlSs
	P3z9yM2tslMWwIhaPJaeqWNZzWeR6k+QuSvmskC+ZQ==
X-Google-Smtp-Source: AGHT+IHxC6i5qwpObe1eDOWi/Od0g4GRgAk9jzOZ3XKeiC1SDm7VVZDyGLVzpXyK6cSH8wHoFhS6cxSCFQC9A0v0DV0=
X-Received: by 2002:a05:622a:198f:b0:40f:c60d:1c79 with SMTP id
 u15-20020a05622a198f00b0040fc60d1c79mr3382qtc.28.1692119474862; Tue, 15 Aug
 2023 10:11:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com> <ZNq15SZ+53umvOfx@google.com>
 <CAJHc60wMueazp3Wm=b6-tnFPAyX0zeYuVQe9uPEJrpAm0azw2A@mail.gmail.com> <ZNrMTmppUfQhdsyY@google.com>
In-Reply-To: <ZNrMTmppUfQhdsyY@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 15 Aug 2023 10:11:02 -0700
Message-ID: <CAJHc60yp7X9Za=CJnJWqAbPuKznp91fYtnBOuQQCGtiXyQBqWw@mail.gmail.com>
Subject: Re: [PATCH v9 00/14] KVM: arm64: Add support for FEAT_TLBIRANGE
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 14, 2023 at 5:52=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Aug 14, 2023, Raghavendra Rao Ananta wrote:
> > On Mon, Aug 14, 2023 at 4:16=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Fri, Aug 11, 2023, Raghavendra Rao Ananta wrote:
> > > > The series is based off of upstream v6.5-rc1.
> > >
> > > Lies!  :-)
> > >
> > > This is based off one of the kvmarm.git topic branches (I didn't both=
er to figure
> > > out which one), not v6.5-rc1.
> > >
> > Sorry, what am I missing here? My git log is as follows:
>
> Hmm, not sure what's going on.  Maybe I misinterpreted why `git am` was f=
ailing?
> I assumed it was because there were objects in kvmarm that I didn't have =
locally,
> and fetching kvmarm allowed am to complete, though with 3-way merges, whi=
ch IIUC
> shouldn't have been necessary if I was using the exact same base.  Or may=
be I
> messed up and didn't actually reset to 6.5-rc1.
>
> > $ git log --oneline upstream_tlbi_range_v9
> > 5025857507abe (upstream_tlbi_range_v9) KVM: arm64: Use TLBI
> > range-based instructions for unmap
> > 5c0291b99a8fc KVM: arm64: Invalidate the table entries upon a range
> > 8c46b54d4aaec KVM: arm64: Flush only the memslot after write-protect
> > 231abaeb7ffc2 KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
> > 5ec291b863309 KVM: arm64: Define kvm_tlb_flush_vmid_range()
> > 5bcd7a085c34e KVM: arm64: Implement  __kvm_tlb_flush_vmid_range()
> > ea08f9dff7e5b arm64: tlb: Implement __flush_s2_tlb_range_op()
> > b3178687947c9 arm64: tlb: Refactor the core flush algorithm of __flush_=
tlb_range
> > a4850fa988eef KVM: Move kvm_arch_flush_remote_tlbs_memslot() to common =
code
> > 306dc4e6afd37 KVM: Allow range-based TLB invalidation from common code
> > d02785a0a1e01 KVM: Remove CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
> > 136fa2d254537 KVM: arm64: Use kvm_arch_flush_remote_tlbs()
> > e35c68a75170d KVM: Declare kvm_arch_flush_remote_tlbs() globally
> > 5d592777b9bba KVM: Rename kvm_arch_flush_remote_tlb() to
> > kvm_arch_flush_remote_tlbs()
> > 06c2afb862f9d (tag: v6.5-rc1, tag: linux/v6.5-rc1) Linux 6.5-rc1
> > c192ac7357683 MAINTAINERS 2: Electric Boogaloo
> > f71f64210d698 Merge tag 'dma-mapping-6.5-2023-07-09' of
> > git://git.infradead.org/users/hch/dma-mapping
> > ...
> >
> > Isn't the commit, 06c2afb862f9d (06c2afb862f9d (tag: v6.5-rc1, tag:
> > linux/v6.5-rc1) Linux 6.5-rc1) the 'base' commit?
>
> Ya, should be.
>
> Either way, even if this is PEBKAC on my end, using --base would be nice,=
 e.g.
> then you can definitely say it's my fault ;-)
>
I'll consider this, and thanks for the confirmation.

- Raghavendra
> > > Please try to incorporate git format-patch's "--base" option into you=
r workflow,
> > > e.g. I do "git format-patch --base=3DHEAD~$nr" where $nr is the numbe=
r of patches
> > > I am posting.
> > >
> > > It's not foolproof, e.g. my approach doesn't help if I have a local p=
atch that
> > > I'm not posting, but 99% of the time it Just Works and eliminates any=
 ambuitity.
> > >
> > > You can also do "--base=3Dauto", but that only does the right thing i=
f your series
> > > has its upstream branch set to the base/tree that you want your patch=
es applied
> > > to (I use the upstream branch for a completely different purpose for =
my dev branches).
