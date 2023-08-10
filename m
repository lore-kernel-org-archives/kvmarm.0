Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312DF22F02
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 22:20:15 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5867fe87d16so17851587b3.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 15:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691706015; x=1692310815;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tmBFxKohqxWGeEzlaaidWaFnJW/Oy/RvfXuIqafrWOM=;
        b=6JTyZrfrPMxEB4xAyKq26rEGx6dnOtJemt5mF01prNKQ3cUVfJruc7Fe7RGiRWwnTQ
         JNdckI2vLoo+gqpkJ4Y/rCI2rOTa5hAiAak/2PN2K2x99UdsCwMzOR99izlBg4yxVppk
         dQK8g/hJNDIeks6PwAz/oyY3lHetOC4GBoRbRmdSsLay+vWH0iHE9YncdP80LYWTblDI
         iYMvC5FUjVcDsM/OLHEHwIfhMK0QewWcYKuW2IlqTPX5Otlz706FwBUZ5hXu21vGQIT4
         uYlRsQgCaSIAFf7MMqxoS33uW0RGdAOE21lmj0iEkCe384OiQkcbcQF5CJ0cTVjotCgp
         pMJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691706015; x=1692310815;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tmBFxKohqxWGeEzlaaidWaFnJW/Oy/RvfXuIqafrWOM=;
        b=cUZ2DNwc3TRWTBEpf5k66FOtWLhwyGMMTC7TPp+GqAGiP4se6F/9sX4SiPkOLSUDsH
         nEc1ViSAhhIatbLX1dwvuTOE78Lp/rFDXNatV8wgbjXa/3nJPFpXJF+GwQfAt1+IBLnv
         t1SxbQ7IePUs8mL1ibxjq6aBty0nUkXlvaVaSEJIh1my640ctXhpvshKbCNX7KevZYO4
         RncroKddZmpnxrfLddKXsq4f23rSHZ709wksIWm5emSPY2/PzLdduAxAIPz6UZV1Er8q
         QFcrrYQ/a7npaMqbeYeZTbfCqtTBBaUzahTcRb4ZabffTzu1UNljCLZItN7OZbm3HtfN
         q8BA==
X-Gm-Message-State: AOJu0YyM/LZAzYI8jBBFAqLpG9R5a3fwGuvza/Rt+43nH57QZJZjm/fE
	/pdaFpLm/n6liqn+vXbRg/P3mIAJsac=
X-Google-Smtp-Source: AGHT+IFA+Eoa7k6dQo7jnaWMJsrKFJ33ryvAj3Q3LxXldo+rT6OtEr7lMPaA/JwDbq8aHQpRj3zalPzAYew=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:709:b0:57a:118a:f31 with SMTP id
 bs9-20020a05690c070900b0057a118a0f31mr4149ywb.7.1691706015047; Thu, 10 Aug
 2023 15:20:15 -0700 (PDT)
Date: Thu, 10 Aug 2023 15:20:13 -0700
In-Reply-To: <CAJHc60x=bhXS3PahuRPwRVdqN4LeX-PBdjdEeCEomhf2YAJ1mw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com> <20230808231330.3855936-3-rananta@google.com>
 <c33b0518-6e64-7acf-efa8-f404fce1ccac@redhat.com> <CAJHc60yCJANBQOizaoSPhEJH9e8a9C6n68x4qdVkOhVZiiWqkw@mail.gmail.com>
 <30e45ef3-309a-63de-e085-be1645c1be79@redhat.com> <CAJHc60x=bhXS3PahuRPwRVdqN4LeX-PBdjdEeCEomhf2YAJ1mw@mail.gmail.com>
Message-ID: <ZNVfsxdYKu9Nt+j+@google.com>
Subject: Re: [PATCH v8 02/14] KVM: Declare kvm_arch_flush_remote_tlbs() globally
From: Sean Christopherson <seanjc@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Shaoqin Huang <shahuang@redhat.com>, Gavin Shan <gshan@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
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

On Thu, Aug 10, 2023, Raghavendra Rao Ananta wrote:
> On Thu, Aug 10, 2023 at 5:26=E2=80=AFAM Shaoqin Huang <shahuang@redhat.co=
m> wrote:
> > On 8/10/23 00:38, Raghavendra Rao Ananta wrote:
> > >>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > >>> index e3f968b38ae97..ade5d4500c2ce 100644
> > >>> --- a/include/linux/kvm_host.h
> > >>> +++ b/include/linux/kvm_host.h
> > >>> @@ -1484,6 +1484,8 @@ static inline int kvm_arch_flush_remote_tlbs(=
struct kvm *kvm)
> > >>>    {
> > >>>        return -ENOTSUPP;
> > >>>    }
> > >>> +#else
> > >>> +int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> > >>>    #endif
> > >>>
> > >>>    #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
> > >>
> > >> Is the declaration inconsistent to that in arch/x86/include/asm/kvm_=
host.h?
> > >> In order to keep them consistent, I guess we need move kvm_arch_flus=
h_remote_tlbs()
> > >> from x86's header file to arch/x86/kvm/mmu/mmu.c and 'inline' needs =
to be dropped.
> > >>
> > > Unsure of the original intentions, I didn't want to disturb any
> > > existing arrangements. If more people agree to this refactoring, I'm
> > > happy to move.
> >
> > This is amazing to me. This change can be compiled without any error
> > even if the declaration inconsistent between the kvm_host.h and x86's
> > header file.
> >
> > I'm curious which option make it possible?
> >
> After doing some experiments, I think it works because of the order in
> which the inline-definition and the declaration are laid out. If the
> 'inline' part of the function comes first and then the declaration, we
> don't see any error. However if the positions were reversed, we would
> see an error. (I'm not sure what the technical reason for this is).
>=20
> Just to be safe, I can move the definition to arch/x86/kvm/mmu/mmu.c
> as a non-inline function.

No need, asm/kvm_host.h _must_ be included before the declaration, otherwis=
e the
declaration wouldn't be made because __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS woul=
dn't
be defined.  I.e. we won't run into issues where the non-static declaration=
 comes
before the static inline definition.

C99 explicitly covers this case:

  6.2.2 Linkages of identifiers

  ...

  If the declaration of a file scope identifier for an object or a function=
 contains the storage-
  class specifier static, the identifier has internal linkage.

  For an identifier declared with the storage-class specifier extern in a s=
cope in which a
  prior declaration of that identifier is visible if the prior declaration =
specifies internal or
  external linkage, the linkage of the identifier at the later declaration =
is the same as the
  linkage specified at the prior declaration. If no prior declaration is vi=
sible, or if the prior
  declaration specifies no linkage, then the identifier has external linkag=
e.

In short, because the "static inline" declared internal linkage first, it w=
ins.
