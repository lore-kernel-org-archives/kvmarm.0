Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3D049B466;
	Tue, 22 Sep 2026 18:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790103174; cv=none; b=elWriGXDrwgjvitXuL+lVIT76jWKnfVFwSzNLDG+yXXr7Ua+W/LJWZ3NXf7nGFz0MqjTSG/gpjERlXroENw0v8oUVvyjeYBVr2fmIypa9IRl4n4UIJHGbqVd/wg3hFK8ok/8pDTajr81Vs2hJRHcuCchFXr/IvJBxjW25/Ww8Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790103174; c=relaxed/simple;
	bh=SKnjfd3Up2eiyVkP6CZIh4TLyINFI0j3BoHkSww6FSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LvbwKsWEsh5UALQC/OvljyQG4y/WhS5WOcSbrpuktxmhgu7J2tuCn8LnC2+zWaOhnOXMN6BRnx5j7BJXdu076j7C/NzFdlnzJzu96HmOVzYYp3YZK4dVaOO92yhEnBWsxe4feutC1Ugh3oyeqTi+QeM3VkrlDdfzjHkz1aPU60s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hMiZHKSa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hMiZHKSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B081F000FF;
	Tue, 22 Sep 2026 18:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790103168;
	bh=MXpVSnMgs3Z7izHUy03zYCf6znjQJnlKV3nqic4hNd8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hMiZHKSa7U2bacA1JtdlXZZKizxqaV55VvMSi9xha2q/7AZ+JiVih9cjUTQUctOl7
	 QAlEn6eljWYbWC+Fz4EXb9rmE5ojWeeBrSGbHLk4fDkR9lbzMqbH23B6hBcShNnyYz
	 /8clYd3RYb46IaI1HeC0/uWpcX3FhktX1Q9z22DTqUH9UV8WpXXcYdYiCrCNdx/BXh
	 xr1U9hzn+VpFq508+U8fd8gbqrNJdSOefDdl4iRccuM7WLEMiYhu5gnzPvZ2NzB31/
	 MiK9ENsSDmNW3uPiDtkVtsuHJpVogFYliYjrZk9qmhMIvjeFpebZmmpVkUYrfOEQ8l
	 lwtZHgf2NRE8A==
Date: Tue, 22 Sep 2026 19:52:39 +0100
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
Message-ID: <arLNQJ2ZbcZ6xivb@gremlin>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-1-787bd3bc7e3f@kernel.org>
 <arKxjsxuO1F5ExrY@kernel.org>
 <arK5n9HrbZMCOHOt@google.com>
 <arK5ynpRi7VbY7Ek@gremlin>
 <arK8seJVT9wYgVCP@google.com>
 <arK8-Hec3-5o4jYs@gremlin>
 <arLLnYvkXSFr6f6u@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arLLnYvkXSFr6f6u@google.com>

On Tue, Sep 22, 2026 at 11:40:29AM -0700, Sean Christopherson wrote:
> > > But look at it from an x86 perspective.  Pretty much everyone will look at this
> > > and expect:
> > >
> > >   bool kvm_arch_vcpu_allow_pre_fault_memory(struct kvm_vcpu *vcpu)
> > >   {
> > > 	return vcpu->kvm->arch.pre_fault_allowed;
> > >   }
> >
> > I'm not sure I really get your point here at all? :)
> >
> > Why would it matter what people who are too lazy to go check the implementation
> > assume about an arch hook?
>
> Because I don't hate the people that contribute to KVM, and want to make it as
> easy as possible for them to not make mistakes?

Haha well I think I misunderstood you here, I see the point that you might
assume some state like this rather than an explicit conditional, and the inline
comment suggested by Oliver makes things a bit clearer.

--
Cheers, Lorenzo
