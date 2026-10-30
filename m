Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793386632;
	b=spfO6qChtDhB7Z4r3W0X+b8fApsT43c7AkndzusQMGVMtiFg/YGFKAR5g1R+ROKj/t72
	 RDAFXOV0SNwnBKzAwJU4CzB9XSU1h/aRULFTx19DaCpIh9ZLryJTRAxRhKbZZo485SSRy
	 vjW2nmUlfcTD4JID6XNTD7zlejBrjslwJ1bOPj2lpi1edat+vMSt4He4W7MlVmQMz6tDZ
	 O+iAaM8+z8N6xofy6ZynTZ0FWLw/karfJtVSK/PxEnu79HW3Lmu51eSSXh2wrl1vy8qbq
	 /af3kChVRMmBh+rtt6gZt6clsvAju1iZhEEjlHH/2M5HvI1V6kDNgUGBvd5+RbXI3GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793386632;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=AqsM43MOtFOSSZV0EEwrjw089w0rw12SYsGwf7bUH9w=;
	b=lFo7jgH5On7nw8i3jAeW6cTUNt+ZrQBr2z/Ii+534kAYxAsbc1U31Ak+xIa4woBJvWCi
	 r8HYnufCxPysXvBs9zssqBXVDFcRU4yKMIZx1IGqOiohVwy2Nxc4z7bbbmexikj26vZri
	 UD84FN+CST2xNT60VduQey4cFHGegy/KH3EfKaNF4INcIVMPEFjKF9LkGhYPsJfs6bB2G
	 Lyq5y70K/FfpgA0QZ/r9cE3Oq84XPccFqG7jAdrBz9UDaapScfNrv7PRPKkbBMaYYBfxD
	 Swnltxc1Oi87a162q+wD+pK3xDm1xIH8GBv/ZtjE1VpWRh9IS4np+/3Hb9sdPMIzttA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IvZg2Ts6;
	arc=none smtp.remote-ip=209.85.216.71
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6130606A31E
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 18:57:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6130606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IvZg2Ts6
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ab1e771632so1661902a91.1
        for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 11:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793386631; x=1793991431; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AqsM43MOtFOSSZV0EEwrjw089w0rw12SYsGwf7bUH9w=;
        b=IvZg2Ts6Cm17FpnE69Qvvi5exfUbH1yk5N+FFocSRBGRJI7WsYLi0Ad8TbWSspp++v
         XLsRXI6Oo8o5SiKwJR/mi3mKtVDorImHXkggWiFndhCdOifTuGGy7siJi34PvLJWVu93
         U2I6CAG/d6CDm6KQBjdfgOEj5JyCEcI4+j1os4uwttUJedZAZAHGpp+ZHqfUrAnvF0/q
         rKCDJFJNMCe0oDL/ba4F1iv3kXDkOsU/VQyVJj+ct+ivp8kOEdTUhLaz9R2+EgO6xiuM
         /cbH0hSUSLlAoegKMTFdyqL+dM9lVXgOMbMP4YslbxMBYGnu5ZZlOs0PncC+fyaGeygl
         OkoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793386631; x=1793991431;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AqsM43MOtFOSSZV0EEwrjw089w0rw12SYsGwf7bUH9w=;
        b=UAy2SGReFNab73+lqasFzB3H3gYcu/7BIYSySqEEQ77HsjjHKEkYT48Z28uefV609e
         FVy5TDZfDzFOyxXT+nNbO27O5AUR41kIWy7h222BV1EMcp/7e25LArHsBk1fwqHuhDt3
         THjA/yWeL21zMsuxIyWq/NCoHD8ZBuq4s4h/J7gu9WNxoOKUHip/7LLfKwu7CzjiZOIv
         YL8wM2Hym77uqKCSLkyOU2nug/lEqTY5ixdTkWBe0Ol/vB9UQGL933VHh759gGQ+yIiV
         4pmcf3IO2hczIaARA09WaIPqf4pejO2fOjdLlIy4Qy04Bl2bi5Sn+F0ggf6JMVKy9nYh
         TJbw==
X-Forwarded-Encrypted: i=1; AKwUvBwFXXaWQ4X19/WI/pWiCg60gWruiq8Vn0HEzUUJD8beOSB/lxr68NNszincXB3tP94BwjGcwn8=@lists.linux.dev
X-Gm-Message-State: AFq9FYK1AMt8a/xQEi5pLAlmm6SCJr+j60q4748ZFxDDFSV6KOp3DVwt
	BO1EFpefc4HarFzK3ZvZjrZCMPGLw1Q/LiW6HmjkQr4+NEwWroqwU67tn2PrW1lNhoxZlQHw6Hg
	Q1U03kA==
X-Received: from pjbbo5.prod.google.com ([2002:a17:90b:905:b0:3ac:24b3:3484])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c2c6:b0:3ac:b3c7:de04
 with SMTP id 98e67ed59e1d1-3ae897aa752mr1800362a91.34.1793386630946; Fri, 30
 Oct 2026 11:57:10 -0700 (PDT)
Date: Fri, 30 Oct 2026 11:57:10 -0700
In-Reply-To: <auStM0rbFol79h5o@li-fbf77acc-29ba-11b2-a85c-e8e934f50a46.ibm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261028190259.1819571-1-seanjc@google.com> <20261028190259.1819571-4-seanjc@google.com>
 <auStM0rbFol79h5o@li-fbf77acc-29ba-11b2-a85c-e8e934f50a46.ibm.com>
Message-ID: <auTohixp3V5-vNsB@google.com>
Subject: Re: [PATCH 3/7] KVM: PPC: Explicitly force IPIs when directly kicking vCPUs
From: Sean Christopherson <seanjc@google.com>
To: Gautam Menghani <gautam@linux.ibm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Atish Patra <atish.patra@linux.dev>, 
	Alexandre Ghiti <alex@ghiti.fr>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Stefan Teodorescu <fane@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 30, 2026, Gautam Menghani wrote:
> On Wed, Oct 28, 2026 at 12:02:55PM -0700, Sean Christopherson wrote:
> > Explicitly force an IPI when invoking kvm_vcpu_kick() directly instead of
> > relying on kvm_arch_vcpu_should_kick() to unconditionally return 1/true.
> > This will allow dropping kvm_arch_vcpu_should_kick() in favor of
> > kvm_request_needs_ipi().
> > 
> > No functional change intended (1 || 1 == true).
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/powerpc/include/asm/kvm_ppc.h | 13 ++++++++++++-
> >  arch/powerpc/kvm/book3s.c          |  4 ++--
> >  arch/powerpc/kvm/book3s_pr.c       |  2 +-
> >  arch/powerpc/kvm/booke.c           |  6 +++---
> >  arch/powerpc/kvm/e500_emulate.c    |  2 +-
> >  arch/powerpc/kvm/powerpc.c         |  2 +-
> >  6 files changed, 20 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
> > index 169ea6a7fbad..bbe7378ad0ef 100644
> > --- a/arch/powerpc/include/asm/kvm_ppc.h
> > +++ b/arch/powerpc/include/asm/kvm_ppc.h
> > @@ -30,6 +30,17 @@
> >  #endif
> >  #include <asm/inst.h>
> >  
> > +/*
> > + * TODO: For unknown reasons, KVM PPC has historically ignored vcpu->mode when
> > + *       determining if kicking a vCPU needs an IPI.  Either document why that
> > + *       behavior is necessary, or drop this helper and the @force param from
> > + *       __kvm_vcpu_kick().
> > + */
> > +static inline void kvmppc_vcpu_kick(struct kvm_vcpu *vcpu)
> > +{
> > +	__kvm_vcpu_kick(vcpu, false, true);
> > +}
> > +
> 
> AFAICS, there is no reason for PPC to always return 1. I was looking at
> the old patches on mailing list and found this - https://lore.kernel.org/kvm/0FEE585F-5E21-47F2-A3F0-AD0DE05EBB43@suse.de
> 
> ```
> How about we return 1 for kvm_arch_vcpu_in_guest_mode() on !x86 always, just
> like it's done today basically? Then we can worry about needless IPIs later
> and don't regress from the respective current kick implementations.
> ```

FWIW, I found that as well, but there are a metric ton of kvm_vcpu_kick() calls
that have been added since then, and they scared me.

> However, I'll do some testing and get back by mid next week to make sure
> there are no suprises.

Thanks!  If we can drop the PPC behavior, that would be wonderful!  Though if
we do that, it should be for 7.5 in a follow-up (this series really should go
into 7.4 due to the SNP issue).
