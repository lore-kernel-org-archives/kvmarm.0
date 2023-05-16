Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F278B29103
	for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 19:14:14 +0000 (UTC)
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6ab1942ea59so28765a34.0
        for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 12:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684264454; x=1686856454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XPvU4GCpDRUjtoRqRZA6QpZocRSHyFeHeKs9Xzsz5SE=;
        b=UjF3qIkYbDoLOOcWkR1rwVW/qTBqj/aXk2y85s6vzRnKGAlQKwJPAJNv8dR+ZTmfxy
         rswxC5ujj5GkNX/SavhJFN0H7tkbr8ecbJe+Z/UcApo/hexFw75jfOk6EkqaWt6zSE6y
         LZLRZ6jTqKhdUKrwepK8JUQL8aZHXnc7pFQu3IAthKKHSGgN71CHe4HyHoKALyVwua2R
         Wix/jKKncCLEi6ekKZRL8MkNwaoDD0U49GtS9K5GihSO+yB4MzM6JOJGMspZhgaHbOOm
         BJBcfw1XOj2UgWn2/Szq3ZBzdrC6hwAbNKJcjTtN7ibVfk+69BPbpMOU4gasMxCax8io
         x6jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684264454; x=1686856454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XPvU4GCpDRUjtoRqRZA6QpZocRSHyFeHeKs9Xzsz5SE=;
        b=FlUpr8CbcJ26SEl+7tf5JW/Mf7MPLFwgyH0aZeYqCs5rMTFD0hmZzhe1CsA/XrXUZn
         q5Gj32eiRu1tbvPyJfj4yapW2sCUzU/CrI7xA9a7lzXZkuWBqWARWcgKuqJ+ID/YE8eI
         L8KInWyHLg3a32zZhJ6fPEJc48jNfsYzlHxRt/MuaemTD/QKykWXbTKMaTPo64AdTp7t
         /oHPjWQ+QST6Ln6wzsQvDj9wmShP3EHXM85M3N0tNZiXhr6430Xu57AT5lleeWjxTmaL
         urSB6dZC1+84XpROi5gGXz+0jb8+f5FEMFLFdW3nyg+9jIwP4wsJhBsZ9m/ZHIGUP9DU
         4Q5w==
X-Gm-Message-State: AC+VfDyQ0MzyFstPYzfaNRVIgd3Xz9S2jrhXHf7WxfhdysGvyGFLjndm
	sS3ngfPSusIeMDwty/lMMBIbnixxiI7k60tC1u/FkjrkejtZeGQyXUY=
X-Google-Smtp-Source: ACHHUZ5ceWiUmfFJLjs+TLJrYt45xeTB53hPSxiwg22yyF9LukggkV0CssCRkcDsSIcgQYsvVkk9ejd9e41yOmDwFpg=
X-Received: by 2002:a05:6870:b79a:b0:199:d0fa:ee1a with SMTP id
 ed26-20020a056870b79a00b00199d0faee1amr4374967oab.31.1684264453899; Tue, 16
 May 2023 12:14:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230503171618.2020461-1-jingzhangos@google.com>
 <20230503171618.2020461-2-jingzhangos@google.com> <861qjgmf2t.wl-maz@kernel.org>
In-Reply-To: <861qjgmf2t.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 16 May 2023 12:14:03 -0700
Message-ID: <CAAdAUtgEi_4pH+t-kJRjykJg-o2ccHcSVuQ_rn9+-_bbEu8obQ@mail.gmail.com>
Subject: Re: [PATCH v8 1/6] KVM: arm64: Move CPU ID feature registers
 emulation into a separate file
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Oliver Upton <oupton@google.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Tue, May 16, 2023 at 9:11=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Wed, 03 May 2023 18:16:13 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Create a new file id_regs.c for CPU ID feature registers emulation code=
,
> > which are moved from sys_regs.c and tweak sys_regs code accordingly.
> >
> > No functional change intended.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/Makefile   |   2 +-
> >  arch/arm64/kvm/id_regs.c  | 460 +++++++++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/sys_regs.c | 464 ++++----------------------------------
> >  arch/arm64/kvm/sys_regs.h |  19 ++
> >  4 files changed, 519 insertions(+), 426 deletions(-)
> >  create mode 100644 arch/arm64/kvm/id_regs.c
> >
> > diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> > index c0c050e53157..a6a315fcd81e 100644
> > --- a/arch/arm64/kvm/Makefile
> > +++ b/arch/arm64/kvm/Makefile
> > @@ -13,7 +13,7 @@ obj-$(CONFIG_KVM) +=3D hyp/
> >  kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
> >        inject_fault.o va_layout.o handle_exit.o \
> >        guest.o debug.o reset.o sys_regs.o stacktrace.o \
> > -      vgic-sys-reg-v3.o fpsimd.o pkvm.o \
> > +      vgic-sys-reg-v3.o fpsimd.o pkvm.o id_regs.o \
> >        arch_timer.o trng.o vmid.o emulate-nested.o nested.o \
> >        vgic/vgic.o vgic/vgic-init.o \
> >        vgic/vgic-irqfd.o vgic/vgic-v2.o \
> > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > new file mode 100644
> > index 000000000000..96b4c43a5100
> > --- /dev/null
> > +++ b/arch/arm64/kvm/id_regs.c
> > @@ -0,0 +1,460 @@
>
> [...]
>
> I really wonder why we move this to another file. It only creates
> noise, and doesn't add much. Yes, the file is big. But now you need to
> expose all the internal machinery that was private until now.
>
> If you look at the global diffstat, this is "only" another 200
> lines. I don't think this is worth the churn.
Yes, the global diff is not that big as in the first patch series now.
Will do all the changes in the same file in the next version.
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
