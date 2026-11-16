Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794852025;
	b=bIOAb5Omox9kPUrkGzrBiw8nURoEQjBLmENuAoJvetG+O90wgoABxSy0mfn5a/5b0gNa
	 6T2ZzvPNQQKy4sAvn1YcVUwFL7U7+YBeRJXxfubWtmsOsqGXk/fvuRUgep/JgvTux9ofj
	 HnsNZ+QvPOJFjVmAr7r6E5EBCetmJXZxmpNoc0GKpKx43Igkmm4ez5kzqNDTLzMG1KCZ7
	 rM3j1BrIz4/6VpNtl/+C2cFVv5ssIl3moy9gT5f3k2UZn26iDwvnP5fMQybaO/z30BqNS
	 qKK3d9+2NjDPSVGiunWPJ6PWZqN8kbzb2zqgkN4/NH09PIzXh2qvbShTfv1YXKfc3IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794852025;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=998chmVGlgR1Bb+7q8aQ3gIGlPWLeXhmy31lb6kqaW0=;
	b=mXnLQSjXddje4Ef9kWbePALy/J/NKaJPp1zGQewJt0EwdOUEL1hEkBTCOcqB1D832i0I
	 vYzJPW4bN5DFgMSFI2o9XjGTR33jlHn1VynB2pGSA44cEzpw92bBd9FmK9oFCDt8z0lif
	 pAwearKHbV9oPsGWHV0ulB1yyQ3DgNEvgxOj0Z9WgcbHBHpsimYGlt99YJtQU452kWeEp
	 iK6MaGCA2wZSruZk0gnFhM7R4bsg+WtYp7VMXMQGIM1YMRTm6xd5eK0MP3PuM57OFuCcb
	 nKI82DZgnCpmLaf/HPsn83ztu++OM4hjUAbHF1eq0cxuYmwxF3NGo1E4qANrxH8/s9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MRhsWgX6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E9F606A880;
	Mon, 16 Nov 2026 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MRhsWgX6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3621F000C4;
	Mon, 16 Nov 2026 18:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794852025;
	bh=998chmVGlgR1Bb+7q8aQ3gIGlPWLeXhmy31lb6kqaW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MRhsWgX6xG9y5Aw2OHN9dSkXFKCRUEt5ffarsOOX3lad5iSqAee5yjkz4gYRb2RCF
	 Nmlc61bqE9Mr1vXZf071UVmvKwoilnHVll4/pBDUwRN1ujUs6Y+1UJygk4ZFlekYRG
	 fbbgZeU6szqDGGrOCRD3op3iK81T4BTTXmud68Y1EwVrHAmHdtCBzyfrW2AEMnXhTx
	 o0mBEyeyNntThPlirFtI5oXjP9an26dDzsTYSEAhs97W9J8m7b3EC5vWzaKeExRj0G
	 axRj2Szojv7D9iifOwG1rLWvVgFg9bbcWqTJy9julo2Ax63nniNCLov1qzHbSOLMle
	 20Sx5aWxLosyg==
Date: Mon, 16 Nov 2026 18:00:19 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 03/28] KVM: arm64: Add CONFIG_KVM_ARM_SPE Kconfig
 option
Message-ID: <avtEpYOSGrZ7BcKE@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-4-alexandru.elisei@arm.com>
 <atDa-BSF3RMzJSdE@gremlin>
 <avSi9WPLhMLrnogk@raptor>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avSi9WPLhMLrnogk@raptor>

On Wed, Nov 11, 2026 at 05:16:37PM +0000, Alexandru Elisei wrote:
> Hi,
>
> On Thu, Oct 15, 2026 at 03:15:18PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Sep 03, 2026 at 05:05:58PM +0100, Alexandru Elisei wrote:
> > > Add a new configuration option that will be used for KVM SPE emulation.
> > > CONFIG_KVM_ARM_SPE depends on the SPE driver being loaded because:
> > >
> > > 1. The SPE driver maintains a cpumask of physical CPUs that support SPE,
> > >    and that will be used by KVM to emulate SPE on heterogeneous systems.
> >
> > I guess e.g. big.LITTLE?
>
> That's the marketing term for it, yes.
>
> >
> > >
> > > 2. KVM will rely on the SPE driver enabling the SPE interrupt at the GIC
> > >    level.
> > >
> > > The option will become user selectable after SPE support in KVM is
> > > implemented.
> > >
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >
> > With nit addressed the redundant dependency removed (both noted below),
> > LGTM and:
> >
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> > > ---
> > >  arch/arm64/kvm/Kconfig | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > > index 449154f9a485..fece4c02b97c 100644
> > > --- a/arch/arm64/kvm/Kconfig
> > > +++ b/arch/arm64/kvm/Kconfig
> > > @@ -103,5 +103,14 @@ config PKVM_STACKTRACE
> > >  	  If unsure, or not using protected nVHE (pKVM), say N.
> > >
> > >  endif # NVHE_EL2_DEBUG
> > > +
> > > +config KVM_ARM_SPE
> >
> > NIT: Nothing else in the file has the _ARM_ prefix, so is that redundant
> > here?
>
> I add the capability KVM_CAP_ARM_SPE later, so I would rather keep the config
> name KVM_ARM_SPE so the two align?

Ack that's fine.

>
> >
> > > +	bool
> > > +	depends on KVM && ARM_SPE_PMU
> >
> > I think KVM should be removed here, this is within an 'if KVM' block
> > already, and nothing else here depends on it either so not a convention.
>
> Removed the explicit dependency on KVM.

Thanks!

>
> Thanks,
> Alex
>
> >
> > > +	default n
> > > +	help
> > > +	  Adds support for Statistical Profiling Extension (SPE) in virtual
> > > +	  machines.
> > > +
> > >  endif # KVM
> > >  endif # VIRTUALIZATION
> > > --
> > > 2.43.0
> > >
> > >
> >
> > --
> > Cheers, Lorenzo

--
Cheers, Lorenzo
