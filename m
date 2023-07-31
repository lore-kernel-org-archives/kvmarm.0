Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B705D18B18
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 17:31:05 +0000 (UTC)
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3460770afe2so5605ab.1
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 10:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690824664; x=1691429464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q03jsirrcpz9THZTEToDjGsCufQsuiDSytShuzuhytQ=;
        b=sORGvbtJhHxz53qrI/C6oraxYpTnjnsD8fulzoT4dhIBDQX2BnR3JuUM9pXznh0fVK
         0Q++QS9YBd6xZyRFZ45krv0aqCEokBCpd/ksYBupaCA6A92A58scXFedQYlh0k/k4C5r
         zId0p3PvqEPnRt5OU/Hwn5/TEFX9vZSKdXDZpHTqROf6CdWFvh35L9PfPXiugBLjPSJg
         4xk332WGEOIjrUYIWqdFinZaga1dIOvxx0x/8JSRVskIc3FfZSLuGYh/O8Eto/p3IxhW
         UYrRZcZL2C+X0esJUx4cUe1XLN8KMhWEmZW1V/Lb6UhZ7IMDvhGKObCAe9xtsJhQgGWN
         hRLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690824664; x=1691429464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q03jsirrcpz9THZTEToDjGsCufQsuiDSytShuzuhytQ=;
        b=gv3McIN/ubb81hiybrJ9RBxr53UkF4KCEdin90qbjGvx9MuE4Ukw688UaqoGfHLuON
         BwUazVTISKvauxg+DynYCDic/UG4R6EamQWNltYcPfeFTBSTFKTvWqgSEkCkoUY2HilP
         mAcYWhFNVcdFP82FoBs0FchOjmvaG4WP87Gneom3pzH6AuQz+rYzK6QuL2bREJ9RErIl
         +zscGhADn0vq7NVT0LmWJaHbWrhnsIPcnbDkokDWOnMxLy5LkEpXTvnLeDeJZMD74vvb
         WI7H1f1eA7iE3Binhy5pVaA2FwIq/xaZEG5JobN1vGXoM3aP/rYaO0dU5DAclM7eYGxg
         dsyA==
X-Gm-Message-State: ABy/qLaneh9WPBgbMglj96XbdxHbxscVpcX+wNKqYJLJ/gGd62LbCUE6
	+zE1yrQXTrCwdmCP40q0g8+7pN7kUYQAi7NueKB/AQ==
X-Google-Smtp-Source: APBJJlHmjmYpt26t014ApaGi4Ojnes96IDMRRl/L7/toNT1PsolsYi/piLtNCaMzdPalSPaMz0fip/Zr0n5KeG8QyVE=
X-Received: by 2002:a05:6e02:1a09:b0:349:290:74e3 with SMTP id
 s9-20020a056e021a0900b00349029074e3mr505815ild.23.1690824664464; Mon, 31 Jul
 2023 10:31:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-6-rananta@google.com>
 <87sf99r5gz.wl-maz@kernel.org>
In-Reply-To: <87sf99r5gz.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 31 Jul 2023 10:30:53 -0700
Message-ID: <CAJHc60xiGyV69a68UBabnzRK0NNycWWQ1kt=ZjJGmC2qzmadAg@mail.gmail.com>
Subject: Re: [PATCH v7 05/12] KVM: Move kvm_arch_flush_remote_tlbs_memslot()
 to common code
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Gavin Shan <gshan@redhat.com>, Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 27, 2023 at 3:53=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Sat, 22 Jul 2023 03:22:44 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > From: David Matlack <dmatlack@google.com>
> >
> > Move kvm_arch_flush_remote_tlbs_memslot() to common code and drop
> > "arch_" from the name. kvm_arch_flush_remote_tlbs_memslot() is just a
> > range-based TLB invalidation where the range is defined by the memslot.
> > Now that kvm_flush_remote_tlbs_range() can be called from common code w=
e
> > can just use that and drop a bunch of duplicate code from the arch
> > directories.
> >
> > Note this adds a lockdep assertion for slots_lock being held when
> > calling kvm_flush_remote_tlbs_memslot(), which was previously only
> > asserted on x86. MIPS has calls to kvm_flush_remote_tlbs_memslot(),
> > but they all hold the slots_lock, so the lockdep assertion continues to
> > hold true.
> >
> > Also drop the CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT ifdef gating
> > kvm_flush_remote_tlbs_memslot(), since it is no longer necessary.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > ---
> >  arch/arm64/kvm/arm.c     |  6 ------
> >  arch/mips/kvm/mips.c     | 10 ++--------
> >  arch/riscv/kvm/mmu.c     |  6 ------
> >  arch/x86/kvm/mmu/mmu.c   | 16 +---------------
> >  arch/x86/kvm/x86.c       |  2 +-
> >  include/linux/kvm_host.h |  7 +++----
> >  virt/kvm/kvm_main.c      | 18 ++++++++++++++++--
> >  7 files changed, 23 insertions(+), 42 deletions(-)
> >
>
> [...]
>
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 804470fccac7..58213cc4b9b9 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -379,6 +379,20 @@ void kvm_flush_remote_tlbs_range(struct kvm *kvm, =
gfn_t gfn, u64 pages)
> >       kvm_flush_remote_tlbs(kvm);
> >  }
> >
> > +void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
> > +                                const struct kvm_memory_slot *memslot)
> > +{
> > +     /*
> > +      * All current use cases for flushing the TLBs for a specific mem=
slot
> > +      * related to dirty logging, and many do the TLB flush out of mmu=
_lock.
>
> I appreciate this is a copy paste of an existing comment, but I can't
> parse it. My command of the English language is notoriously
> approximate, but it feels that something is missing in the first
> sentence, such as a verb.
>
No, you are right. The sentence is broken, probably a missing "are" at
the end of the first line. I'll fix it.

- Raghavendra
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
