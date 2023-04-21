Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E09A379
	for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 03:27:26 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1a652700c36so404475ad.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 20:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682047646; x=1684639646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c+iWliMmJZEtXgWOh0UHnuG4gBuoaGaej7xxMmyc3O4=;
        b=m3qK4dAlRbSQLQP8E9iBcnpbxqqk1LOFfr8sFysQIyq681Pc57ssOJHlWbQGrE79q0
         vUPIJ3+oRAzOKPcd0CeDHWphJwY3YChSycgwy5Zi0eyrRGbOaOn/K/YjmtH8JTg6WSEC
         88+VIvhTI23hiIFj++R7SXDpMGJkaa41FVvVwAH+jDUbvFvHC6ACR/9YGzwS6Z21qPXT
         OmkSejU9hG0Bm4svYxDQjalMw78od203TYfcb0VxmEOGM9EFvBfQddriLVQ6GEfB310K
         QAzuhREHhxJWQKp+MaNEcO/5rpzk+Qhl4rSLVysB1yHpBa3H+8nT/UeTQyohmU/PJWux
         +mqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682047646; x=1684639646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c+iWliMmJZEtXgWOh0UHnuG4gBuoaGaej7xxMmyc3O4=;
        b=CiA1voYOQfaB3zBtdTe+P0+DPyu+NnPmOb7qBjUA54hduVM+xfKpkEx78mgMOnqRy9
         fFFrTI0un5DhKl6DZqGBR+O7qNazVuQdlMT6k8EWqXOeU6uRaSPJe9uhPavxoD40Yz51
         L4VKcP+wSI50tDhc/wjM5Nnvrh/OahqLw7td6RU+K4ygCF8HnKNKlVs4+U6TZLXY1sr5
         VXgroHksDqj/dq66GojSdCmonkhZovQPMeBimdtOwOCgH3QppLENJGPd+PxEEBpzwAuU
         +aGi4AcRvFH4VBUUYggm3MabWgwYejo2VAH3KocqAHXVcHoYNYPU/ygDLhuML66vcmSc
         ORdQ==
X-Gm-Message-State: AAQBX9ckzUHKE4DFVLTxuA+/nBywwj/AOazAVxhqVSRp8BiP5MIrwrSQ
	EpINm+SU17sxwiPUKXmo7eSE0a83EXK9ePjfNjhC/A==
X-Google-Smtp-Source: AKy350Y0V3oR05OlOu9Ym/IEUsvWMzCAWltkwOvQWPTggbKuhXr6pJ7P/dof0FeWwGEsy6fXviKi3Rd9yRQakaBjSYg=
X-Received: by 2002:a17:902:7205:b0:1a9:343c:76e5 with SMTP id
 ba5-20020a170902720500b001a9343c76e5mr146872plb.18.1682047645947; Thu, 20 Apr
 2023 20:27:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230419021852.2981107-1-reijiw@google.com> <20230419021852.2981107-2-reijiw@google.com>
 <87cz405or6.wl-maz@kernel.org> <20230420021302.iyl3pqo3lg6lpabv@google.com> <86y1mnj7dg.wl-maz@kernel.org>
In-Reply-To: <86y1mnj7dg.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 20 Apr 2023 20:27:09 -0700
Message-ID: <CAAeT=FxAqWJ01MH748Usvhq5Js6QJnDA-4x3t=4WHTQ+7bXcDw@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] KVM: arm64: Acquire mp_state_lock in kvm_arch_vcpu_ioctl_vcpu_init()
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ricardo Koller <ricarkol@google.com>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 20, 2023 at 1:16=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Thu, 20 Apr 2023 03:13:02 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Wed, Apr 19, 2023 at 08:12:45AM +0100, Marc Zyngier wrote:
> > > On Wed, 19 Apr 2023 03:18:51 +0100,
> > > Reiji Watanabe <reijiw@google.com> wrote:
> > > > kvm_arch_vcpu_ioctl_vcpu_init() doesn't acquire mp_state_lock
> > > > when setting the mp_state to KVM_MP_STATE_RUNNABLE. Fix the
> > > > code to acquire the lock.
> > > >
> > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > > ---
> > > >  arch/arm64/kvm/arm.c | 5 ++++-
> > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > index fbafcbbcc463..388aa4f18f21 100644
> > > > --- a/arch/arm64/kvm/arm.c
> > > > +++ b/arch/arm64/kvm/arm.c
> > > > @@ -1244,8 +1244,11 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(str=
uct kvm_vcpu *vcpu,
> > > >    */
> > > >   if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
> > > >           kvm_arm_vcpu_power_off(vcpu);
> > > > - else
> > > > + else {
> > > > +         spin_lock(&vcpu->arch.mp_state_lock);
> > > >           WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUN=
NABLE);
> > > > +         spin_unlock(&vcpu->arch.mp_state_lock);
> > > > + }
> > > >
> > > >   return 0;
> > > >  }
> > >
> > > I'm not entirely convinced that this fixes anything. What does the
> > > lock hazard against given that the write is atomic? But maybe a
> >
> > It appears that kvm_psci_vcpu_on() expects the vCPU's mp_state
> > to not be changed by holding the lock.  Although I don't think this
> > code practically causes any real issues now, I am a little concerned
> > about leaving one instance that updates mpstate without acquiring the
> > lock, in terms of future maintenance, as holding the lock won't prevent
> > mp_state from being updated.
> >
> > What do you think ?
>
> Right, fair enough. It is probably better to take the lock and not
> have to think of this sort of things... I'm becoming more lazy by the
> minute!
>
> >
> > > slightly more readable of this would be to expand the critical sectio=
n
> > > this way:
> > >
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 4ec888fdd4f7..bb21d0c25de7 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -1246,11 +1246,15 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(stru=
ct kvm_vcpu *vcpu,
> > >     /*
> > >      * Handle the "start in power-off" case.
> > >      */
> > > +   spin_lock(&vcpu->arch.mp_state_lock);
> > > +
> > >     if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
> > > -           kvm_arm_vcpu_power_off(vcpu);
> > > +           __kvm_arm_vcpu_power_off(vcpu);
> > >     else
> > >             WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUN=
NABLE);
> > >
> > > +   spin_unlock(&vcpu->arch.mp_state_lock);
> > > +
> > >     return 0;
> > >  }
> > >
> > > Thoughts?
> >
> > Yes, it looks better!
>
> Cool. I've applied this change to your patch, applied the series to
> the lock inversion branch, and remerged the branch in -next.
>
> We're getting there! ;-)

Thank you, Marc!
Reiji
