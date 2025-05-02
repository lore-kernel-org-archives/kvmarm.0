Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DAB201000
	for <kvmarm@lists.linux.dev>; Fri,  2 May 2025 20:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746219535; cv=none; b=TzlvL0ROQlqhOYCMqg9KW1Zg/2dqI0j1UN2W6zbdwgADsGTAkDGo5LIy1MMRcxdDBk5gjYaCcAGLsUiUNXncF7zu5erEUsOs3LZaTDJJafI4mUAEzMiEpQrZidttCXIJq1mxiMzPM0wxO2B70XiZ06pXJvwQrW2APGmHrzDXXUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746219535; c=relaxed/simple;
	bh=FMuOYXuNARVPGbLdZKzdZACnsi/D3uRXcBJ+KxMLSJw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=anLfFWtO8hDzAxLvfNrLg2JCWqbeBFTVjkqzYkmjh/ZDPADKjgkeQMAh53RhdU05H2V9f9WtgQwHmI3RUqQJPruJ1JDX/enNB5CVfNxo4CRGAxEkdrn7Um3QkVU7cINHHoYY0BbH8zr2WO/3hOUjYzm9C48OnhSJ1h9oNxCdJOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pTQjjmxy; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pTQjjmxy"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30a204efeaeso1902259a91.0
        for <kvmarm@lists.linux.dev>; Fri, 02 May 2025 13:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746219533; x=1746824333; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z141FLEwqm2f5UKeV3GY2SvtY7oSxEMFO78Y0lhO4Mo=;
        b=pTQjjmxy/IU032SAxUrMOW1IreItVm/mUF86psWfzTZH0EbG6KXIcu3+6EQGdtvcJ7
         lRDg1D2UbAUk0sew/FxZ+x+GeEAmOrltkoHqa8UU5PPVbHjCqE1jnphD6xYcDlt0vTqF
         i8UOI8lIsU1ou9tHbUTUOV5113NqMZgxVYD6a+inZMirTqU0LOqCMHbdZyShBcV60BMo
         OFVwKhHX1Gqyvao5i2FIC22Cn6PEcR/0QkNspHTD7MWrTNfg6Gk40rqELrve7RD7qHvN
         E5yDU7Ou8vmbRnDuE2VWWkngOv536F9vrmWSnfaOXl+3FzjtJmSNFWwT/ZAqr1vzjKQb
         atRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746219533; x=1746824333;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z141FLEwqm2f5UKeV3GY2SvtY7oSxEMFO78Y0lhO4Mo=;
        b=cblZWfMPKwuuxgyI48zx9xb1t9Af9ZNzxJIaQAeb1Q6QlItpFI7nQL4h9XEYNEoIL2
         RUaVJvXNsHeGPIdM4H/PpSKScNbQIBMmQNdicIFHMRWruNZkJeoHuOctyl3AXXzxgjQ/
         LCQ97qENHeMO3DWyoegKCe7ytmoAYy1OTDVeIeE0H5eblDVO0ec1AyQ1Q+52Xhjg6vl6
         597slUS7fPOwvSR9zgAQj3lQTpgQExCSjpq548SYJ8LViMpsKJtlJNCU/2rzDneTWH1X
         CzEL8eg/xDGOP+TJNFbniSLZzlw09T8o5vO/soEGAI4YuZUG6cvxuH0koFmiAhq9ZPnQ
         pi3w==
X-Forwarded-Encrypted: i=1; AJvYcCV0niK/Gjn9x6+/+xvmmsuskUZrJVzt88ZOqk9AjVXufbin0iF3iWP+qxS4VZ4EgcpqRa9KpKY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwY40D7UbmJjLsAA9rJIVY2M0CfGRTBqYiqcLdBd6eqFXQeVjwC
	PpkUyChM4oVLMBp0snmI08EQ5kTriuB5eh1km86uwfE2sfIWVY7SXcjSHaNCbCmE8LUOtuhXcbg
	Dgw==
X-Google-Smtp-Source: AGHT+IGm3fjnbZdZ0P5dTXEIDYUNeozyMh591wQHnGgOaKhf2rgPLaUDWxwxyDC2IuE6wOX5aAwhTk5qwaY=
X-Received: from pjff8.prod.google.com ([2002:a17:90b:5628:b0:2ff:8471:8e53])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f8c:b0:305:5f32:d9f0
 with SMTP id 98e67ed59e1d1-30a4e5c5e9dmr6320303a91.19.1746219533227; Fri, 02
 May 2025 13:58:53 -0700 (PDT)
Date: Fri, 2 May 2025 13:58:51 -0700
In-Reply-To: <864iy4ivro.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250430203013.366479-1-mlevitsk@redhat.com> <20250430203013.366479-3-mlevitsk@redhat.com>
 <864iy4ivro.wl-maz@kernel.org>
Message-ID: <aBUyC5kgTipXud-7@google.com>
Subject: Re: [PATCH v4 2/5] arm64: KVM: use mutex_trylock_nest_lock when
 locking all vCPUs
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Kunkun Jiang <jiangkunkun@huawei.com>, 
	Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Borislav Petkov <bp@alien8.de>, Albert Ou <aou@eecs.berkeley.edu>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Alexander Potapenko <glider@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Andre Przywara <andre.przywara@arm.com>, x86@kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, kvm-riscv@lists.infradead.org, 
	Atish Patra <atishp@atishpatra.org>, Ingo Molnar <mingo@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, kvmarm@lists.linux.dev, 
	Will Deacon <will@kernel.org>, Keisuke Nishimura <keisuke.nishimura@inria.fr>, 
	Sebastian Ott <sebott@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Shusen Li <lishusen2@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, May 01, 2025, Marc Zyngier wrote:
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 69782df3617f..834f08dfa24c 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1368,6 +1368,40 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Try to lock all of the VM's vCPUs.
> > + * Assumes that the kvm->lock is held.
> 
> Assuming is not enough. These assertions have caught a number of bugs,
> and I'm not prepared to drop them.
> 
> > + */
> > +int kvm_trylock_all_vcpus(struct kvm *kvm)
> > +{
> > +	struct kvm_vcpu *vcpu;
> > +	unsigned long i, j;
> > +
> > +	kvm_for_each_vcpu(i, vcpu, kvm)
> > +		if (!mutex_trylock_nest_lock(&vcpu->mutex, &kvm->lock))
> > +			goto out_unlock;
> > +	return 0;
> > +
> > +out_unlock:
> > +	kvm_for_each_vcpu(j, vcpu, kvm) {
> > +		if (i == j)
> > +			break;
> > +		mutex_unlock(&vcpu->mutex);
> > +	}
> > +	return -EINTR;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_trylock_all_vcpus);
> > +
> > +void kvm_unlock_all_vcpus(struct kvm *kvm)
> > +{
> > +	struct kvm_vcpu *vcpu;
> > +	unsigned long i;
> > +
> > +	kvm_for_each_vcpu(i, vcpu, kvm)
> > +		mutex_unlock(&vcpu->mutex);
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_unlock_all_vcpus);
> 
> I don't mind you not including the assertions in these helpers, 

I do :-)  I see no reason not to add assertions here, if locking all vCPUs is
a hot path, we've probably got bigger problems.
