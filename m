Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E827018C0B
	for <kvmarm@lists.linux.dev>; Wed,  9 Aug 2023 16:39:02 +0000 (UTC)
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-407db3e9669so311631cf.1
        for <kvmarm@lists.linux.dev>; Wed, 09 Aug 2023 09:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691599141; x=1692203941;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rAabttuUSlISLQ9kur95AJErnuBmKPlF1t5IPI4xLW8=;
        b=QK/Md6pLtQcnNYaG7FaNR8YGO5V1BDDGTN1QNcb5t4M8hyK/g2UzsOCkQFbfYrRiBB
         G0kclZmDhOUC4jPYSDgzil3jq7z68Wq4Y/XsBYF1MGe9Iir+sC7RphbJoMfImBbhq2T/
         pEhwFheHJqKkE6YRXMAxkXUnF8lSNA2TqIGy9iPTw7Y7ze+v2ZO6wVbfvsq9lZ13AZGe
         qcvfeTRsEBx541O+obhMMtIFxCFLknFX2bE3VoAPa0QB2Ao3Loe9vbjMaWTez52X0ZNb
         c1pWu8dZp76+bEISHoUz6Gcb1Dks1IYF1WyX0qZyE1sqGI1eUsOyDxlWzYy0GZ7RrbKU
         pVQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691599141; x=1692203941;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rAabttuUSlISLQ9kur95AJErnuBmKPlF1t5IPI4xLW8=;
        b=EthPLYtZqXunVRD8vRncXtntheD3v/7vsIpJc/WHw6qwxtloosAFjXqR2IgKcHO0tG
         M80DdaDt+7WoetG4oz6G7BJl9g27hsCQenEhexVrp+PlHDlLO6w37itdIC2kLGAgLsfv
         JphYxhOtT3+KTmyZn7CL1KW2ZweAkWhMMHCNAYxS0JWs+61V/wePMu/5WqiF3Qq6QQxa
         BCwyOFgQACyRUJMabMCiWxDVVlLSPheZL5lWSGtSBLhBrn09Up0hAP5t6HwOTJRUIaCK
         gFAJfV1JX6uj1oY0r2h53pn2aAcFMY3KFcME5B2BoQaOFCeSMrKWbBEyAUK4xEW7HHi7
         KnHg==
X-Gm-Message-State: AOJu0Yx0gW3oSS9dpc3J5frbKGJ9o/nWsnG4tGtNSv9oBWdXqTkmzz0Y
	J2uNLBHPhM84amHH/t7WsAGfikKIVCBFukK/q9RCQA==
X-Google-Smtp-Source: AGHT+IFIKXrr2ilFq3pewZHyAMJbe1zJNw2R6kC9Ag8lwIUUWtSfseAhG7bbTMLUN+5Rf6sXibPKOvlrXvIKI8OeOqU=
X-Received: by 2002:a05:622a:206:b0:3ef:302c:319e with SMTP id
 b6-20020a05622a020600b003ef302c319emr161886qtx.8.1691599141628; Wed, 09 Aug
 2023 09:39:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com> <20230808231330.3855936-3-rananta@google.com>
 <c33b0518-6e64-7acf-efa8-f404fce1ccac@redhat.com>
In-Reply-To: <c33b0518-6e64-7acf-efa8-f404fce1ccac@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 9 Aug 2023 09:38:49 -0700
Message-ID: <CAJHc60yCJANBQOizaoSPhEJH9e8a9C6n68x4qdVkOhVZiiWqkw@mail.gmail.com>
Subject: Re: [PATCH v8 02/14] KVM: Declare kvm_arch_flush_remote_tlbs() globally
To: Gavin Shan <gshan@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, David Matlack <dmatlack@google.com>, 
	Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Gavin,

On Tue, Aug 8, 2023 at 9:00=E2=80=AFPM Gavin Shan <gshan@redhat.com> wrote:
>
>
> On 8/9/23 09:13, Raghavendra Rao Ananta wrote:
> > There's no reason for the architectures to declare
> > kvm_arch_flush_remote_tlbs() in their own headers. Hence to
> > avoid this duplication, make the declaration global, leaving
> > the architectures to define only __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> > as needed.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >   arch/mips/include/asm/kvm_host.h | 1 -
> >   include/linux/kvm_host.h         | 2 ++
> >   2 files changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/k=
vm_host.h
> > index 9b0ad8f3bf327..54a85f1d4f2c8 100644
> > --- a/arch/mips/include/asm/kvm_host.h
> > +++ b/arch/mips/include/asm/kvm_host.h
> > @@ -897,6 +897,5 @@ static inline void kvm_arch_vcpu_blocking(struct kv=
m_vcpu *vcpu) {}
> >   static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> >
> >   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> > -int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> >
> >   #endif /* __MIPS_KVM_HOST_H__ */
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index e3f968b38ae97..ade5d4500c2ce 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1484,6 +1484,8 @@ static inline int kvm_arch_flush_remote_tlbs(stru=
ct kvm *kvm)
> >   {
> >       return -ENOTSUPP;
> >   }
> > +#else
> > +int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> >   #endif
> >
> >   #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
>
> Is the declaration inconsistent to that in arch/x86/include/asm/kvm_host.=
h?
> In order to keep them consistent, I guess we need move kvm_arch_flush_rem=
ote_tlbs()
> from x86's header file to arch/x86/kvm/mmu/mmu.c and 'inline' needs to be=
 dropped.
>
Unsure of the original intentions, I didn't want to disturb any
existing arrangements. If more people agree to this refactoring, I'm
happy to move.

Thank you.
Raghavendra
> Thanks,
> Gavin
>
