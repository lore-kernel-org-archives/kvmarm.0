Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8D018A92A
	for <kvmarm@lists.linux.dev>; Tue, 15 Oct 2024 08:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728980610; cv=none; b=aDuwwDv9pG4VryXXpIONA1CgQkph9fcctXgWHT4za3Rf+eocSvXUvyYxwCZrLPbTiddykNAH9slryl21Za/nETNRyLV/ZgU5lB/TwtlcrVh5ud6JXbPLWgXArqn6pBr/6/YV/AYPOzazRngKPp63y4gnWAZjt1gdwHk1lhZrh3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728980610; c=relaxed/simple;
	bh=TcUpj8cdiDXa7ysP5+g5oFITNE9bZZSTXSvG2uq/HKM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tkJPBbPOgnvmju82MtNYX6TZdIooKafwVj1EAqYT97xjy0gGjd5Frk13v8LEhr1QTGaxWXruAdPqnP1bswBH6uhzcnEYgKRgKoR/8H3MS8SjYNW307A9cOIKGNCo+sDkzU/eYAW2LHxhX8wTZDrQIAOkmsYkUu9MFVokQ98+698=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A1vYRcl5; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A1vYRcl5"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5c93e9e701fso36206a12.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Oct 2024 01:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728980605; x=1729585405; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PkyvNAig1uCzvboS3rJMdr/mecgnL3ht2ii3VTtWIN4=;
        b=A1vYRcl5jjkJuT05NR37WMBZWQfB25nwQXRagzvE9q/YSuviXOTCebNUUpjUZR6AMU
         6T2qWgw315sbE51JIyNCj8HFDIqlmKFgfIfc/S87B2i4bMqVUjp3Vt+8hYY1GZ9mQBmJ
         0Ge9uskiQclECYeGg12wvfWPvmKS5B1h7vxrtEDTvxWCnIaOXpsu563wfd2fbzWtYEQD
         UrOVn59FpTnd/+QoElHzV3LEFl4+x44ZECN3f2X3MltG04cBNs5QLJSqDWUT5cO09tCe
         ToY/PWQdYtE6GXOnuqUFav+0W6dpY0M+AECZ87CyOb/hVEszf5GaZi6it/xnZSL9aG6f
         jhoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728980605; x=1729585405;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PkyvNAig1uCzvboS3rJMdr/mecgnL3ht2ii3VTtWIN4=;
        b=SdV6FIb6S+T9yiufgq4KSeZ6El8Va6yUr1bGfbUrmGYqukUlUvbY6rWa0P+hXqBmOo
         UX/4LbAVxTpEebYxANayzd0edLui/JQSHrD1g1nyiYLL97W8NJmCAO8ugz6U/L/ATn83
         lgrS1O2uuEy3cVusfJAarsfOCFv1xm8C50Itijy3wQ/3MLd85orJ5yUaZWgYB4grmrJK
         TnCcvMJnNIMW8S2uf6TLKHCuXZGXT/5MF7Lrq/ORCWAAQvx5iHIzYM/7SyoPrTnHGyGM
         ap3RFr89hMxIstozNd3SJQaZlknS6ruBeWOYOkATWLAKSOR1hxn6GbYDhBVvDgs8Rcjg
         GlDQ==
X-Gm-Message-State: AOJu0YwI+8KTeB4+KfEdzp+D0btTYgybyS8xvk8Aj7cESLu8jT53OkhG
	WC1YBYOi+1WotSyKG/cG0XdG5QrWqFKQo7/Z6S7ipMFHBn63Q48tY+ZqqjuHw5g1wOCfJb/COy9
	liYMzWJ75UukgWb/u5C432NkyZ5BywzKfqTl7
X-Google-Smtp-Source: AGHT+IGgVM3ntpdEtU080MKky4vUNihGF1HsblESzeUZQTxUj4VB76uigRH0/Nw4V1k5e5UDaP4DKumraSZc1iFLN/E=
X-Received: by 2002:a05:6402:4316:b0:5c8:82b3:9933 with SMTP id
 4fb4d7f45d1cf-5c95c5ee78amr675056a12.7.1728980604701; Tue, 15 Oct 2024
 01:23:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241014102413.4092725-1-tabba@google.com> <20241014102413.4092725-2-tabba@google.com>
 <Zw4byVfZngXV19ni@linux.dev>
In-Reply-To: <Zw4byVfZngXV19ni@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 15 Oct 2024 09:22:47 +0100
Message-ID: <CA+EHjTwLE+zpSKMMaRDNbuuBmvMJZZAFoha7hpiRuNhwgP60Ww@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] KVM: arm64: Move pkvm_vcpu_init_traps() to init_pkvm_hyp_vcpu()
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Tue, 15 Oct 2024 at 08:37, Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Mon, Oct 14, 2024 at 11:24:09AM +0100, Fuad Tabba wrote:
> > Move pkvm_vcpu_init_traps() to the initialization of the
> > hypervisor's vcpu state in init_pkvm_hyp_vcpu(), and remove the
> > associated hypercall.
> >
> > In protected mode, traps need to be initialized whenever a VCPU
> > is initialized anyway, and not only for protected VMs. This also
> > saves an unnecessary hypercall.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h               | 1 -
> >  arch/arm64/kvm/arm.c                           | 8 --------
> >  arch/arm64/kvm/hyp/include/nvhe/trap_handler.h | 2 --
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c             | 8 --------
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c                 | 4 +++-
> >  5 files changed, 3 insertions(+), 20 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index b36a3b6cc011..7f7866d2bfc2 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -76,7 +76,6 @@ enum __kvm_host_smccc_func {
> >       __KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
> >       __KVM_HOST_SMCCC_FUNC___vgic_v3_save_vmcr_aprs,
> >       __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
> > -     __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_init_traps,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index a0d01c46e408..ece934bb4531 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -856,14 +856,6 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
> >               static_branch_inc(&userspace_irqchip_in_use);
> >       }
> >
> > -     /*
> > -      * Initialize traps for protected VMs.
> > -      * NOTE: Move to run in EL2 directly, rather than via a hypercall, once
> > -      * the code is in place for first run initialization at EL2.
> > -      */
> > -     if (kvm_vm_is_protected(kvm))
> > -             kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
> > -
>
> Can we instead get rid of this hypercall by implementing the one-time
> late initialization as the comment suggests?

I'm not sure I understand. I thought this is what I'm doing in this patch...

> It'd be great if the feature configuration for non-protected and
> protected VMs is done in a similar way, and that is userspace changes to
> the ID registers before KVM_RUN.
>
> So we need this sort of 'late' initialization for that behavior to work.

I think this is related to me now quite understanding the first
comment, and by extension not sure I quite get this one.

Sorry about that :)
/fuad

>
> --
> Thanks,
> Oliver
