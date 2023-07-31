Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01591E508
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 21:42:19 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1bba7a32a40so38428445ad.0
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 14:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690839739; x=1691444539;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AU1Eyv4/z0dADLWEV1nEcRpLxJELbihGWkSyugO3ex8=;
        b=zHV044O9XwNQjgOLB3AfcpUidtjFsHSm7411oU0FzT/hBIi1OVCl2irlR0nDqKL8Cv
         hr4KfnJvAQ8KZYVTxOCRf7feP1xd884smGeXDTwo1Mxw39juIFwqargVifxiYkX3oNFO
         jGZAeL3BraA/GHqzFzm8zichi53qOSusN9afNCtFEmHZFTDQ5+1SlvbReoCXw9xfn3Sq
         Nxy3SDA+osZfzK8FprhkAlPfPKaV+dJMo4N5DxnhbU6aEOE2yJsGxe0D1EjnOIUEkic5
         iFCs47k5rbIbFAbkVkjH6/FwH8n0Jz0vylbUDue6VIQodFOLNkamKR23aV4KPT1WaTb8
         1QIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690839739; x=1691444539;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AU1Eyv4/z0dADLWEV1nEcRpLxJELbihGWkSyugO3ex8=;
        b=QnKd3sm6AqX3f6sfpMYR6vy552cG2CD7ECpT+OEHtq0sOxF1x28TeMKNWVi44HBS1k
         f+dUP5U6w7r4khxuUuKGLXxCTozTuiUnJX9wAicgU/ZS8xuBXblQOmrNHiY/E3G82JcW
         O1ThgpUM4zA7wZS+DMf+FHcS+BBSy+ldXs7mb1nsnvUqItyRWOXPRX1TUDa5TS1tpXBf
         jZprn2N5RH47duwcgJbdib1+9SdVxxvet/nHACkRDc4r1XNckitZoetRm2PdJ76OOpPc
         B4gRYivARI6uLcZwduAZaKDZw2cPnZxvgXYeX2mo7/eeS5nqS9UfD5Zt3jh9tywbuqGv
         zIrA==
X-Gm-Message-State: ABy/qLaf2kp59RJ8WNaas6dNtcVbNAhZf/6RwR28l3CFmp7AiKPD5VK2
	ie1nxgk54z/KaeIZHvB8StW1VUj42t4=
X-Google-Smtp-Source: APBJJlGvM6eC2793heXvfSouAIwfR2kqtZard40LOvURGFRGLCXd0Mte19jhWawRDx9GHaLxbY3CRW2x+Q4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dac4:b0:1bb:91c9:d334 with SMTP id
 q4-20020a170902dac400b001bb91c9d334mr42299plx.0.1690839739050; Mon, 31 Jul
 2023 14:42:19 -0700 (PDT)
Date: Mon, 31 Jul 2023 14:42:17 -0700
In-Reply-To: <CAJHc60wtc2Usei3hKj1ykVRvBZFFCBOHMi9HCxnNvGK2dPFApA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-2-rananta@google.com>
 <87v8e5r6s6.wl-maz@kernel.org> <CAJHc60wtc2Usei3hKj1ykVRvBZFFCBOHMi9HCxnNvGK2dPFApA@mail.gmail.com>
Message-ID: <ZMgqueePlmKvgUId@google.com>
Subject: Re: [PATCH v7 01/12] KVM: Rename kvm_arch_flush_remote_tlb() to kvm_arch_flush_remote_tlbs()
From: Sean Christopherson <seanjc@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Gavin Shan <gshan@redhat.com>, 
	"Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 31, 2023, Raghavendra Rao Ananta wrote:
> On Thu, Jul 27, 2023 at 3:24=E2=80=AFAM Marc Zyngier <maz@kernel.org> wro=
te:
> >
> > On Sat, 22 Jul 2023 03:22:40 +0100,
> > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > >
> > > From: David Matlack <dmatlack@google.com>
> > >
> > > Rename kvm_arch_flush_remote_tlb() and the associated macro
> > > __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB to kvm_arch_flush_remote_tlbs() and
> > > __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS respectively.
> > >
> > > Making the name plural matches kvm_flush_remote_tlbs() and makes it m=
ore
> > > clear that this function can affect more than one remote TLB.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> > > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > > ---
> > >  arch/mips/include/asm/kvm_host.h | 4 ++--
> > >  arch/mips/kvm/mips.c             | 2 +-
> > >  arch/x86/include/asm/kvm_host.h  | 4 ++--
> > >  include/linux/kvm_host.h         | 4 ++--
> > >  virt/kvm/kvm_main.c              | 2 +-
> > >  5 files changed, 8 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm=
/kvm_host.h
> > > index 04cedf9f8811..9b0ad8f3bf32 100644
> > > --- a/arch/mips/include/asm/kvm_host.h
> > > +++ b/arch/mips/include/asm/kvm_host.h
> > > @@ -896,7 +896,7 @@ static inline void kvm_arch_sched_in(struct kvm_v=
cpu *vcpu, int cpu) {}
> > >  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
> > >  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {=
}
> > >
> > > -#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
> > > -int kvm_arch_flush_remote_tlb(struct kvm *kvm);
> > > +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> > > +int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> >
> > How about making this prototype global? I don't see a point in having
> > it per-architecture, specially as you are adding arm64 to that mix in
> > the following patch.
> >
> We can make it global, but I'm not sure what was the intention of the
> original author. My guess is that he was following the same style that
> we have for some of the other kvm_arch_*() functions
> (kvm_arch_free_vm() for example)?

Heh, KVM has a *lot* of code that was written with questionable style.  I a=
gree
with Marc, I can't think of a single reason not to have the definition in c=
ommon
code.  Declaring the function doesn't preclude a "static inline" implementa=
tion,
and we could even keep the prototype under an #ifdef, e.g.=20

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9d3ac7720da9..5ac64f933547 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1484,6 +1484,8 @@ static inline int kvm_arch_flush_remote_tlb(struct kv=
m *kvm)
 {
        return -ENOTSUPP;
 }
+#else
+int kvm_arch_flush_remote_tlb(struct kvm *kvm);
 #endif
=20
 #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA

