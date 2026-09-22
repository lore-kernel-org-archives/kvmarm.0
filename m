Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C072E8DEC;
	Tue, 22 Sep 2026 12:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081538; cv=none; b=g328Iw13v5aLX9z/Wr2c2cdSZsW2i7XosqPpNf9/d0MaTt0mEjwOnEglqFtbuVKERKEmx0Q+CAYI/0kiJY1c2Ijh3XftYaRPFfeZ4wKFn41vCQazmYIWtqb5zln0tXzvG1Q6tjOATrBL77ooTGdMtbbXf5hTTl9N9t5U1Kgt0N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081538; c=relaxed/simple;
	bh=dKFwer8asIo2ww6qdmBz5IYEoRE1svuaIGly3239UFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QQsujB7Kr6ooA0U7/EL6pMgNvWZE5KPZIh9TZ5r5SUOnyuI9uqOF3PkCud+qTstDcLTRiJ2RQymPU6MlK7QiBtZ3NoRFIumCVOGZRYaur6vL28LdQB/RHMojtqvAQTUrFf3094fiWUo1uirdD7vwMLpje7Zvi+vIqaBVsnoXWnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ScPnuTaA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ScPnuTaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7401F000FF;
	Tue, 22 Sep 2026 12:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790081536;
	bh=zwXB7IJjlaB8/LFgWGY2W9SyVRX56trli9CAewYqEk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ScPnuTaAx+eHTBSVHGS81l0qJF871mpilRUw6iIOhoIedfp2tpP2WU8Dh5G37I61R
	 XAz51OaoK7pxeDsk48QlwqEDREYfvLbwKcyFXf4YyE9n1tNZNiNyTq29RD+skOcX5y
	 GHmYmvcfgUPm9Dp2mwY4PUGp+inda2N5/bJoBgZ2fKH7CoF+Kh46/NFwQCGYNkz1kv
	 9zRitwCSfYrfMsfvybQRxZOYESPsv3ev+RfpqEutx8cppFTaMFohlNIiuBsERqKJ8o
	 Ui/vSKE1Ia74snqxS7sBefQi9n+pE89jtO4VfAo86yH0XD6Ehb2Qpx239KVoVNcSQ3
	 mgN3kKjvYDm3g==
Date: Tue, 22 Sep 2026 13:52:07 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sean Christopherson <seanjc@google.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Leo Soares Passos <Leo.Bras@arm.com>
Subject: Re: [PATCH v2 00/13] KVM: arm64: Add KVM_PRE_FAULT_MEMORY support
Message-ID: <arJ1BDEzY5CANjjB@gremlin>
References: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
 <yq5abj9p38vq.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5abj9p38vq.fsf@kernel.org>

On Tue, Sep 22, 2026 at 03:28:33PM +0530, Aneesh Kumar K.V wrote:
> > This is because pKVM instantiates vCPUs upon run,
> >
>
> Can pKVM instantiate the hyp vCPU during pre-faulting ?

It would be an unusual and unexpected thing to do - suddenly a pre-fault
operation is initialising a vCPU explicitly for pKVM.

A caller is not going to reasonably expect this and might treat a failure to
pre-alloc as fine to carry on whereas in fact it was a failure to initailised a
pKVM vCPU.

It'd also require significant changes to how pKVM is set up, right now it's
hardcoded to be done unconditionally at run via kvm_arch_vcpu_run_pid_change()
-> pkvm_create_hyp_vcpu(), so all that would have to change and be checked and
tested and... that'd be really out of scope I think :)

And pre-faulting really makes most sense BEFORE you run a VM. It doesn't make so
much sense mid-run.

But more fundamentally, the stage 2 page tables, as I understand it, are owned
by pKVM and so aren't really available to be pre-faulted.

Maybe unprotected-under-pKVM VMs but then it's questionable as to how useful
that would be given that it would be confusing to users vs. how it works for
other VMs.

So in general, no I don't think it's a good idea.

And even if we wanted to pursue some version of this, it's _definitely_ out
of scope for the initial pre-faulting bring-up series.

>
>
> > but pre-faulting is  typically performed before a vCPU is run.  It would be confusing and
> > inconsistent to error out on non-running vCPUs but to pre-fault running
> > ones.
>
>
> I use KVM pre-faulting when transitioning pages from shared to private

You mean you'd prefer to use? Or you are using it on another arch?

> with CoCo guest. This ensures that a trusted device can DMA to private
> memory before the guest accesses it.

Hm what do you mean by private memory?

I see:

#ifndef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
{
	return false;
}
#endif

And only x86 selects KVM_GENERIC_MEMORY_ATTRIBUTES?

Do you mean something else?

Or are you saying we should match x86? I don't think we have the same
semantics as them, I don't think there's an equivalent for us, and of
course no private memory in the sense of the predicate above.

In any case I think anything wanting to add additional functionality to
pre-faulting would have to be a follow-up anyway.

>
> -aneesh

--
Cheers, Lorenzo
