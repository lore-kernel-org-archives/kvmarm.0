Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1D3134CE
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 17:15:55 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-589db0ba2e1so59124457b3.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 10:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692119754; x=1692724554;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h4pRofXYscuxJwlZlec+kz5JByk1VStjcQk6pNX8VCg=;
        b=0ULGW8lrz4LAfQvUr6zW2RUHxg7wnB8mbW6D5bd2rDtC7t6jWPtR/lVCZvnMtK039v
         Gg8JyKieoo8YzZWKJSwsneurYfUwDhsBEjHR8BDDFIcMNXvxQFl1SY6+8po7yWKtX3gK
         0M47n08PCbwSAAAHpnB5NZUa5PJ3jqM0sFJYHYCV1+uFsvROyNCULug2lOezvw4KSxiC
         SwvzuqKN0keYa4/1ydFK2xGN83du5F8hP7y28i8MbkevBr7RMbIjQF8iEl3lxI4AS4rj
         O6jyhFmalRm5sDGo51MDmx9Yc7ibOQgbEesKJpyN5wkexREqBNWTi2YgoIds/heBTaQl
         JrNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692119754; x=1692724554;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h4pRofXYscuxJwlZlec+kz5JByk1VStjcQk6pNX8VCg=;
        b=TueGaFYK7eCGMtW+VKQI189Fut0rSUlsC9zYFQ9Exj553UzimDcV+sNuf8RGFdiL50
         IbWv9OE9i+SIR0ppAMD/hURkePkzauME7fXp9LGRMVeBHsAeJXlIAGf56Fm3uIE436Pd
         fUhq+70KG3lG2vi1FlRohXDMqTBQPXpeS+yijSXgSOMEqM16gEjPnuwrbDUP/LNQRjV7
         PtG3vx2hCsPLyFgXyzgb3sYqR5gtTGpoHS4+fMa8Ms9WeBWpKd5yAtIXE8P1cp0MC+0P
         Xuzh9JmA+MxHVM0Gte/+kFQr180A1fn7ZsTl5tvutftQHt655BWLSzC0Ue93e7fzrlSA
         Gwqg==
X-Gm-Message-State: AOJu0YxO90PCCqmoE5vaAxubaihbdvhZmpPWljEqsljFhjq+L0mi6iVJ
	NZC1fpu6jP5iy8GlI+6RfAOgWjbItA4=
X-Google-Smtp-Source: AGHT+IEdTpAtlbhdDz4CSAmHfwiSyntmeRr/8GY1hRZWQcWfFLbFbn/FO7WCsNQ5MIITNcxj8ryCZ17c50c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:890e:0:b0:d08:95:76d with SMTP id
 e14-20020a25890e000000b00d080095076dmr40567ybl.6.1692119754466; Tue, 15 Aug
 2023 10:15:54 -0700 (PDT)
Date: Tue, 15 Aug 2023 17:15:53 +0000
In-Reply-To: <CAJHc60yp7X9Za=CJnJWqAbPuKznp91fYtnBOuQQCGtiXyQBqWw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com> <ZNq15SZ+53umvOfx@google.com>
 <CAJHc60wMueazp3Wm=b6-tnFPAyX0zeYuVQe9uPEJrpAm0azw2A@mail.gmail.com>
 <ZNrMTmppUfQhdsyY@google.com> <CAJHc60yp7X9Za=CJnJWqAbPuKznp91fYtnBOuQQCGtiXyQBqWw@mail.gmail.com>
Message-ID: <ZNuyyQsFCmDc7Gmb@google.com>
Subject: Re: [PATCH v9 00/14] KVM: arm64: Add support for FEAT_TLBIRANGE
From: Sean Christopherson <seanjc@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 15, 2023, Raghavendra Rao Ananta wrote:
> On Mon, Aug 14, 2023 at 5:52=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Mon, Aug 14, 2023, Raghavendra Rao Ananta wrote:
> > > On Mon, Aug 14, 2023 at 4:16=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > >
> > > > On Fri, Aug 11, 2023, Raghavendra Rao Ananta wrote:
> > > > > The series is based off of upstream v6.5-rc1.
> > > >
> > > > Lies!  :-)
> > > >
> > > > This is based off one of the kvmarm.git topic branches (I didn't bo=
ther to figure
> > > > out which one), not v6.5-rc1.
> > > >
> > > Sorry, what am I missing here? My git log is as follows:
> >
> > Hmm, not sure what's going on.  Maybe I misinterpreted why `git am` was=
 failing?
> > I assumed it was because there were objects in kvmarm that I didn't hav=
e locally,
> > and fetching kvmarm allowed am to complete, though with 3-way merges, w=
hich IIUC
> > shouldn't have been necessary if I was using the exact same base.  Or m=
aybe I
> > messed up and didn't actually reset to 6.5-rc1.
> >
> > > $ git log --oneline upstream_tlbi_range_v9
> > > 5025857507abe (upstream_tlbi_range_v9) KVM: arm64: Use TLBI
> > > range-based instructions for unmap
> > > 5c0291b99a8fc KVM: arm64: Invalidate the table entries upon a range
> > > 8c46b54d4aaec KVM: arm64: Flush only the memslot after write-protect
> > > 231abaeb7ffc2 KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range(=
)
> > > 5ec291b863309 KVM: arm64: Define kvm_tlb_flush_vmid_range()
> > > 5bcd7a085c34e KVM: arm64: Implement  __kvm_tlb_flush_vmid_range()
> > > ea08f9dff7e5b arm64: tlb: Implement __flush_s2_tlb_range_op()
> > > b3178687947c9 arm64: tlb: Refactor the core flush algorithm of __flus=
h_tlb_range
> > > a4850fa988eef KVM: Move kvm_arch_flush_remote_tlbs_memslot() to commo=
n code
> > > 306dc4e6afd37 KVM: Allow range-based TLB invalidation from common cod=
e
> > > d02785a0a1e01 KVM: Remove CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
> > > 136fa2d254537 KVM: arm64: Use kvm_arch_flush_remote_tlbs()
> > > e35c68a75170d KVM: Declare kvm_arch_flush_remote_tlbs() globally
> > > 5d592777b9bba KVM: Rename kvm_arch_flush_remote_tlb() to
> > > kvm_arch_flush_remote_tlbs()
> > > 06c2afb862f9d (tag: v6.5-rc1, tag: linux/v6.5-rc1) Linux 6.5-rc1
> > > c192ac7357683 MAINTAINERS 2: Electric Boogaloo
> > > f71f64210d698 Merge tag 'dma-mapping-6.5-2023-07-09' of
> > > git://git.infradead.org/users/hch/dma-mapping
> > > ...
> > >
> > > Isn't the commit, 06c2afb862f9d (06c2afb862f9d (tag: v6.5-rc1, tag:
> > > linux/v6.5-rc1) Linux 6.5-rc1) the 'base' commit?
> >
> > Ya, should be.
> >
> > Either way, even if this is PEBKAC on my end, using --base would be nic=
e, e.g.
> > then you can definitely say it's my fault ;-)
> >
> I'll consider this, and thanks for the confirmation.

Confirmed PEBKAC, I reset to v6.5-rc2, not rc1.  My apologies, and thanks f=
or being
gentle.
