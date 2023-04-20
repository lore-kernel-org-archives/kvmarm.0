Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0516617C9
	for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 02:13:09 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1a652700c36so265245ad.0
        for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 19:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681956789; x=1684548789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j3mfY1x+gF/1P1SV5MF/1QshXYyOurUnvNxF9n5huIU=;
        b=3MVPFD/cqk5XTZrmHEVcAVMpV/Y7QawbyBzDzxNaLFtCq2pf42OHih1gcM5zFexrAD
         VIi0L+poaGd8q7UyJL0FujPTvymtAieNzFdlJrIBGS6D2D/RZmBYLTP+s0tn/Z8a495J
         J7kfqtt2E3ZqlqZwdTlgKp6q1aAl+ygmx5aFrCUhd6wTY5RzNrNS5DEiRtx8G6854Cqg
         N7JePQFiutxIzwFliy0kTUHvBSklQ/vpKmRYUlmKAgfAdGsQS64nKdSYW6vI8jhXAmoY
         udRjjvt/SUZRtzNc97T8fO9BrtA4GDcaBZrrkXD/uJcp5h873yYCDXLnT4M+GjzAabf+
         M+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681956789; x=1684548789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j3mfY1x+gF/1P1SV5MF/1QshXYyOurUnvNxF9n5huIU=;
        b=hpTWWSVjGr8LpcC1uFnvGt1jA7dcDKHYZ3ogts2dFYvoZ9j1T/s8z18Q109jjxNTl8
         0n9wSHfXiMsLEcAseS/R8BjJIBsj8/56uYzStJN1jtreILyJmqQclCMK9TY0oQg5ENOE
         Oi7yLSL+iTwBk16weXX3mF0Bg1OhhbmvuLPlCSYZTvnGCafW/KTq1RAKmXqoYllROZOU
         LTf0YlEFLXqba81wQvJ7cFabsQ1lDjvH7vU+2NkmLvxQE1RYizMdyX2aQExatGaZWg1A
         QkAfWGV7GIn8LC8K8LBn1B8jYxqa6trEKTvH7AWuunbLf4Xg7ozPHtRhe9lVwuVfCVcH
         UYlg==
X-Gm-Message-State: AAQBX9fkOp2Yvdwbu4Dr08mSBjaisPOevy6vITofsh8V8fCEDnMK233f
	uJWqf7TFFekxlX0zMwQuR4MKOw==
X-Google-Smtp-Source: AKy350YmZ9FCjXaXJs440gj9/oyG4q157BweH7jdiFAbmU46Ga8I0nAgzsKweQOdMmdBbqjFbov9cQ==
X-Received: by 2002:a17:903:192:b0:1a6:760c:af3d with SMTP id z18-20020a170903019200b001a6760caf3dmr141041plg.16.1681956789231;
        Wed, 19 Apr 2023 19:13:09 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id 3-20020a170902c10300b001a194df5a58sm108537pli.167.2023.04.19.19.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 19:13:07 -0700 (PDT)
Date: Wed, 19 Apr 2023 19:13:02 -0700
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Raghavendra Rao Anata <rananta@google.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v1 1/2] KVM: arm64: Acquire mp_state_lock in
 kvm_arch_vcpu_ioctl_vcpu_init()
Message-ID: <20230420021302.iyl3pqo3lg6lpabv@google.com>
References: <20230419021852.2981107-1-reijiw@google.com>
 <20230419021852.2981107-2-reijiw@google.com>
 <87cz405or6.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cz405or6.wl-maz@kernel.org>

Hi Marc,

On Wed, Apr 19, 2023 at 08:12:45AM +0100, Marc Zyngier wrote:
> On Wed, 19 Apr 2023 03:18:51 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> > kvm_arch_vcpu_ioctl_vcpu_init() doesn't acquire mp_state_lock
> > when setting the mp_state to KVM_MP_STATE_RUNNABLE. Fix the
> > code to acquire the lock.
> > 
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/arm.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index fbafcbbcc463..388aa4f18f21 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1244,8 +1244,11 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
> >  	 */
> >  	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
> >  		kvm_arm_vcpu_power_off(vcpu);
> > -	else
> > +	else {
> > +		spin_lock(&vcpu->arch.mp_state_lock);
> >  		WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
> > +		spin_unlock(&vcpu->arch.mp_state_lock);
> > +	}
> >  
> >  	return 0;
> >  }
> 
> I'm not entirely convinced that this fixes anything. What does the
> lock hazard against given that the write is atomic? But maybe a

It appears that kvm_psci_vcpu_on() expects the vCPU's mp_state
to not be changed by holding the lock.  Although I don't think this
code practically causes any real issues now, I am a little concerned
about leaving one instance that updates mpstate without acquiring the
lock, in terms of future maintenance, as holding the lock won't prevent
mp_state from being updated.

What do you think ?

> slightly more readable of this would be to expand the critical section
> this way:
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 4ec888fdd4f7..bb21d0c25de7 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1246,11 +1246,15 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
>  	/*
>  	 * Handle the "start in power-off" case.
>  	 */
> +	spin_lock(&vcpu->arch.mp_state_lock);
> +
>  	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
> -		kvm_arm_vcpu_power_off(vcpu);
> +		__kvm_arm_vcpu_power_off(vcpu);
>  	else
>  		WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
>  
> +	spin_unlock(&vcpu->arch.mp_state_lock);
> +
>  	return 0;
>  }
> 
> Thoughts?

Yes, it looks better!

Thank you,
Reiji
