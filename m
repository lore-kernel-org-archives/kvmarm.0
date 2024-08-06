Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EAD176FA5
	for <kvmarm@lists.linux.dev>; Wed,  7 Aug 2024 00:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722988808; cv=none; b=c3LdHC0OvtKlbnAhX+wr3So+hcVZgwIRMsnZ1CX7fqlPa9YHFw3LKBDRrvZMZXoZaF94URZc/13dwe2/WmfdEHzDu+mtdlOHQZglLMm9Afh74LEVgpaungAHvfT/Kj06WdFcIeaodGgVuSwk27sT+OtOczKh4PkhNPcYHpCD3Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722988808; c=relaxed/simple;
	bh=UHgIWVKvGfmyugfK+5SUX8pCsbKk968BZK+Jt1c65xc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jyl3pwp7/jaF/FuZBkhHuBIjnOQntWlgK1Jj1+zXlpMBFhDRxauNA9uljknbVx9g9sMHyLbLydd5B1sa/ciszBzfKE5C4Y4zBvQRW25YV41MFdJgchyVS80Ap0mUpq1fvJHUjUQTvtOKfgzwLMWXRayNpTSreIhdtR5DaGox0Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=112gqB5g; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="112gqB5g"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a242496897so974770a12.2
        for <kvmarm@lists.linux.dev>; Tue, 06 Aug 2024 17:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722988806; x=1723593606; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Q2NRiav7MDRT7LLYySbofxe/7oFalUeoZKG+LR63fQ=;
        b=112gqB5gbfLbOtE5F1rMt5rLyxXcNaUARV9FwhMYPYvYTr2XXMC0UFfjDZ1rcjy3sq
         QWPpQe+32fqrymVpfv/SOlct+vMQdC3+j+xXNSHSQjftB/wjvnBDUQ8s3knQnhk6IfF0
         SGywsrck16+EGwBKcGORmX1I+MUfrUgw323CMd11c7ufKpO3f5fmpXEuth5Me6n6nGWk
         HjnMfKaXKSwOusZO0mqpUvWgZxKAwim+0BjI8kH+hiyyDku+lZwY6mexVe/lPPoNz/F0
         e/Os5bEgnXSWXk/HxDQHwVz74LLeloIxstLcP42nRY/f+4LMDM/rzzkuzLssfSvf6Q2A
         XVvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722988806; x=1723593606;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Q2NRiav7MDRT7LLYySbofxe/7oFalUeoZKG+LR63fQ=;
        b=WiLak9Kt2S62apVkljzEeA0ePyGHlAvE+A4/4AwZD/uTzZwL/aDAFG/ufRz1Jgcj3N
         gvREG0mEIxY6obq4WFHHZnfX4dS0O5FR9cU85Ix4bZrrGghF5ZUS9hofDOcuQfnU+sOU
         WA9xnLSQt1W7v1bCXO60Ytj+GxEYQxgAFnFJh6utNBbZDGPGFsdNrgn5eTNBd8elT7kY
         GXrfyLH+Sl4QbIrWLkxr/MbfsJdBFZNU2AouuzBBYEFILtNQaSo+AVquqWwbVygMqC/a
         tAWi/lxEWSbvx26uEZIDtcEtmQ4a1U1yzfCDiDHKxSExsBibJeC1Mu8K+KauSB+9Vg7k
         Qb1Q==
X-Forwarded-Encrypted: i=1; AJvYcCU5DwrPvK/IPuUTcoHsjpfxF7MwiDUqQ9q15sEAuCLVziJ4dMyIAphHpM86JfiZnLjgumUMMHdMR0Xl8lz+uj7LbCCrA88x
X-Gm-Message-State: AOJu0Yxca1gTgwKkX6UC/MaU+aTY1yS7/14dkuvY/FbGk14roBB67K9m
	gtaknQn4F1febjCxTBccrzaejwNj14RyUngWPuUnSuacJLijqhz2tdo4Ox3TG0PDr6RgtH91q9e
	2/Q==
X-Google-Smtp-Source: AGHT+IHvS0fM2LOTssx0eAi+ioCPUdUHmTfVhIBg5USnscLvdfSuqB0Ekxw+gGimmHjT/noSv8q+S+cCN3A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6904:0:b0:7a0:cd17:c701 with SMTP id
 41be03b00d2f7-7b74a9d0286mr33925a12.10.1722988805874; Tue, 06 Aug 2024
 17:00:05 -0700 (PDT)
Date: Tue, 6 Aug 2024 16:59:03 -0700
In-Reply-To: <ZrKqrCnNpNQ_K_qi@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240802200136.329973-1-seanjc@google.com> <20240802200136.329973-3-seanjc@google.com>
 <ZrKqrCnNpNQ_K_qi@linux.dev>
Message-ID: <ZrK4x4LLz1wlwGQN@google.com>
Subject: Re: [PATCH 2/2] KVM: Protect vCPU's "last run PID" with rwlock, not RCU
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Steve Rutherford <srutherford@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 06, 2024, Oliver Upton wrote:
> On Fri, Aug 02, 2024 at 01:01:36PM -0700, Sean Christopherson wrote:
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index a33f5996ca9f..7199cb014806 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1115,7 +1115,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
> >  void kvm_arm_halt_guest(struct kvm *kvm);
> >  void kvm_arm_resume_guest(struct kvm *kvm);
> >  
> > -#define vcpu_has_run_once(vcpu)	!!rcu_access_pointer((vcpu)->pid)
> > +#define vcpu_has_run_once(vcpu)	(!!READ_ONCE((vcpu)->pid))
> >  
> >  #ifndef __KVM_NVHE_HYPERVISOR__
> >  #define kvm_call_hyp_nvhe(f, ...)						\
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 689e8be873a7..d6f4e8b2b44c 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -342,7 +342,8 @@ struct kvm_vcpu {
> >  #ifndef __KVM_HAVE_ARCH_WQP
> >  	struct rcuwait wait;
> >  #endif
> > -	struct pid __rcu *pid;
> > +	struct pid *pid;
> > +	rwlock_t pid_lock;
> >  	int sigset_active;
> >  	sigset_t sigset;
> >  	unsigned int halt_poll_ns;
> 
> Adding yet another lock is never exciting, but this looks fine.

Heh, my feelings too.  Maybe that's why I didn't post this for two years.

> Can you nest this lock inside of the vcpu->mutex acquisition in
> kvm_vm_ioctl_create_vcpu() so lockdep gets the picture?

I don't think that's necessary.  Commit 42a90008f890 ("KVM: Ensure lockdep knows
about kvm->lock vs. vcpu->mutex ordering rule") added the lock+unlock in
kvm_vm_ioctl_create_vcpu() purely because actually taking vcpu->mutex inside
kvm->lock is rare, i.e. lockdep would be unable to detect issues except for very
specific VM types hitting very specific flows.

But for this lock, every arch is guaranteed to take the lock on the first KVM_RUN,
as "oldpid" is '0' and guaranteed to mismatch task_pid(current).  So I don't think
we go out of our way to alert lockdep.

> > @@ -4466,7 +4469,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
> >  		r = -EINVAL;
> >  		if (arg)
> >  			goto out;
> > -		oldpid = rcu_access_pointer(vcpu->pid);
> > +		oldpid = vcpu->pid;
> 
> It'd be good to add a comment here about how this is guarded by the
> vcpu->mutex, as Steve points out.

Roger that.
