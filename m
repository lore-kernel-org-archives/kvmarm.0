Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F32B3EE1D3;
	Tue, 22 Sep 2026 17:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098254; cv=none; b=TKw4mEvY70r5z8DW76RREzyN8QqB/0PRWRrTyE6vfsIJiLqgs7HfXwkUHCbRf54kr2CRLDUKNyH0lZzFVEdGkRKtIgm3xKxD13Y746VdU/pV2yS6/zXVsgV3B5DAZtI4Mk1Cm3dAZFj81tY7L3AEmnNgA80z3k2iTFy0gmt+r80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098254; c=relaxed/simple;
	bh=IBxGkB5cDASI8ZxcpjUpGkEX5oFSjLp/w06QTHH1gEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WwvQJxBkSkTJHSyV/ZDqX7TYz6mPbOxBRmb1ugUVnE6SPxfwVpIkWjysgtdqlU9HmQCbgkhq3TsUBrMQcfMorxcg0il9Ra1/C5L/1bTAHkdWz3BLyQpH1UwLQtNv370NhDOWMHRB4gx3pPRqgXfH111BDCjSRLLaLNNfanouO2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZgGHB/yZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZgGHB/yZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D761F000FF;
	Tue, 22 Sep 2026 17:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790098249;
	bh=z89Njd5NsuesblLEylAwbrCoulRmCPRaUnG1Sas+cvM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZgGHB/yZACcQBRo+7Rh9XBI681UXZdzOLpud99DOLErktuYlCA2xae/SJbAl6zeRi
	 UO1UhKPWJ5MRpYsFspcGRCgW/lqx24xt8COjWfWUuvwGFvCoVrKmEddhD6IWV7xBkV
	 D59YmNU1PHhX4UrZJ5+1lwt1D92IyGTLLT6ESuVKkuma4PxEKwHyA+NuM+ZX2ADgxV
	 FlH04SJZZ9t7OgTySL1sQGFtg8kz1BBfBBIqDfKqb+gzDjeaSJbvftSCjx/pCA8Ior
	 sk1DDFsEgM06G1mj9MhGgDUq4SiiqQsqCNWIbg5Mv3btg+0d4T9h1r+gSpqwYJwlcV
	 uVpBeCzIAaGdQ==
Date: Tue, 22 Sep 2026 18:30:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 01/14] KVM: Allow architectures to disallow pre-fault
Message-ID: <arK5ynpRi7VbY7Ek@gremlin>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-1-787bd3bc7e3f@kernel.org>
 <arKxjsxuO1F5ExrY@kernel.org>
 <arK5n9HrbZMCOHOt@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arK5n9HrbZMCOHOt@google.com>

On Tue, Sep 22, 2026 at 10:23:43AM -0700, Sean Christopherson wrote:
> On Tue, Sep 22, 2026, Oliver Upton wrote:
> > Hi Lorenzo,
> >
> > On Tue, Sep 22, 2026 at 03:17:55PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > +bool __weak kvm_arch_vcpu_allow_pre_fault_memory(struct kvm_vcpu *vcpu)
> > > +{
> > > +	return true;
> > > +}
> > > +
> > >  void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
> > >  {
> > >  	int nr_vcpus, start, i, idx, yielded;
> > > @@ -4365,6 +4370,9 @@ static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> > >  	    range->gpa + range->size <= range->gpa)
> > >  		return -EINVAL;
> > >
> > > +	if (!kvm_arch_vcpu_allow_pre_fault_memory(vcpu))
> > > +		return -ENOEXEC;
> > > +
> >
> > nit: it'd be better to let the arch hook return an error of its choosing
> > but in reality this is only going to be used by arm64.
>
> Heh, except x86 already has something similar.
>
> 	if (!vcpu->kvm->arch.pre_fault_allowed)
> 		return -EOPNOTSUPP;
>
> As does s390:
>
> 	if (kvm_is_ucontrol(vcpu->kvm))
> 		return -EINVAL;

Yeah but they're all for different reasons I think :)

>
> I also don't like that this is subtly about avoiding vcpu_load(); it will be all
> too easy to overlook that detail in the future.

Well you see there's a problem here...

>
> Rather than have kvm_arch_vcpu_allow_pre_fault_memory(), what if we add a more
> generic kvm_is_vcpu_loadable()?  That way we don't need to worry as much about
> the return value, the connection to vcpu_load() is obvious, and we don't need to
> add another pre-check if future (or cleaned-up existing?) ioctls want to do
> vcpu_load() in common code.

...this is exactly what I started out with.

But then you are in a pickle, because _really_ you need to do that check in
vcpu_load(). Which is a void function. Which is called by every single
architecture all over the place.

So you'd have actually no way of signalling the error back.

Of course those places are arch code and you could say 'arches should know
better and if they call it it's fine not to call the arch 'can you load'
function.

But you're still stuck with the problem of where exactly you put this check.

So then do you put that check in a wrapper around it?

Instead you can make the predicate 'don't prefault on a not-yet-initialised
vCPU' which is pretty sensible I think, have a specific place to put it and
all's well with the world.

(And adding that makes sense in the pre-fault series too...)

>
> I'd also be tempted to say it can be a macro, not a __weak function.  E.g.

Yeah it can be many things but why would you want a macro if you could possibly
avoid it? :)

Macros make the already-basically-pretend C type system into something even
worse.

Also it seems the convention for 'arches might not specify this' is the __weak
route AFAICT.

>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 27fe0cd5b2d7..99613df254cf 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1533,6 +1533,7 @@ static inline bool __vcpu_has_feature(const struct kvm_arch *ka, int feature)
>  #define vcpu_has_feature(v, f)	__vcpu_has_feature(&(v)->kvm->arch, (f))
>
>  #define kvm_vcpu_initialized(v) vcpu_get_flag(v, VCPU_INITIALIZED)
> +#define kvm_is_vcpu_loadable kvm_vcpu_initialized
>
>  int kvm_trng_call(struct kvm_vcpu *vcpu);
>  #ifdef CONFIG_KVM
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3dd04605f2e5..02401b080507 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1053,6 +1053,9 @@ int kvm_trylock_all_vcpus(struct kvm *kvm);
>  int kvm_lock_all_vcpus(struct kvm *kvm);
>  void kvm_unlock_all_vcpus(struct kvm *kvm);
>
> +#ifndef kvm_is_vcpu_loadable
> +#define kvm_is_vcpu_loadable(v) true
> +#endif
>  void vcpu_load(struct kvm_vcpu *vcpu);
>  void vcpu_put(struct kvm_vcpu *vcpu);

--
Cheers, Lorenzo
