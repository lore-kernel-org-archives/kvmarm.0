Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792604940;
	b=5MYeDBnr66VhNvUJebn7cagtAhnUBozqAzWkXJOmSFFh7pPTe0Z4uGFUd15rFZiy1E57
	 hsa6nM2FI3Rfu2cFjxEZ2NQ98P8xVekIIDS6kVp+X2d6yQQWVemOcQuZ7hT43CldJyq0k
	 tI2vpVgFGTopHpCc2uPjR76FCHM88PNFx57gi3A5UVZFQfOQJ0ff8zZKanRAjWgFNCNgs
	 ul4V95Cq8UOCuRDvPu0ZAaA2ZSeMYD0bKMA38kPm+DONwVQ1EalaTe010rd6GtrlJB1Tt
	 6bW1S1jQfvS2/bcyRof5nyjidk+IA0fDeGmzG7W+I0IhJ5HGxifprkc72pP7U3E7y6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792604940;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=u21UTFmux6GWpsHxQyjMm4C7qQp2KgUxiXBHFByAtzM=;
	b=buiLR5NFlnkXA80POdFBajmioG4FgHSQpAHANt/MRd9QUkb79G8lFFBoF1FgtV7rzvZ+
	 mkdP1HP9gJeBMEVmWwI+N6l7kBO4K69HxxZjcAVi4Dc6MVIHXKKlWX4oX8ie/5S9G5X/7
	 a1e06abncBUzmv5dGFjfdoErj1Npnn6rchwlj0skiGBhuiUuUVXCz7dW6CddM/oQ/lKlb
	 IEoV2uck299amg2X/16oqAoT5JRyAhFeGPgJibtYKryN82AzHzurKDg4GPf5jBxGmk5S5
	 +iCJUrtUwLPXx3uiMbXpczV+/Wx5g8nrIq4hvWbSGEMhsHB/BliAgTitEyz90XCYPeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=jLO2LuVO;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF94606A31A;
	Wed, 21 Oct 2026 17:48:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDF94606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=jLO2LuVO
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55CF516F8;
	Wed, 21 Oct 2026 10:48:54 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 356E33F7B4;
	Wed, 21 Oct 2026 10:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792604937; bh=bEa9giIeZfDBMDwMUgTW8YTFn1UnEm9XoYsTu1CX0h8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jLO2LuVONwtdmLRHFnELMpS1lxH3gZTntDBxAbGW9KjLlWgiBvkDKAp5Nw1YJcZxO
	 lipPGRVxkc03dKFZUrIiHwM2M4wUyIatvCJAj5t3jkuQCxVl/GRwS4d4Pc/G49ZX0C
	 argPPnBs8MRvzm4HMuckndnnPQaxYrK4eORDIYaI=
Date: Wed, 21 Oct 2026 18:48:51 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, will@kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
	gshan@redhat.com, joey.gouly@arm.com, tabba@google.com,
	yuzenghui@huawei.com, linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
	lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com
Subject: Re: [PATCH v19 5/7] firmware: arm_rmm: Activate the RMM
Message-ID: <atj7A1CV4paW3htS@arm.com>
References: <a11aba04-eaaa-43fd-988b-a2581b1b2fdb@arm.com>
 <araketG70TIKeNuf@arm.com>
 <12e83d88-de4c-4230-aac2-1796123320ad@arm.com>
 <70d47475-e26e-40e1-b409-b0c16aecb8c0@arm.com>
 <195cdfe4-a55a-453f-9c34-620738eca244@arm.com>
 <arqrZ_Auk9BYOopa@arm.com>
 <0f68dcff-1dfe-4515-9912-515ca6457674@arm.com>
 <arudWVBPXcnUvYNh@arm.com>
 <5d487949-9195-442f-97af-acb9e3fdfb0d@arm.com>
 <86ld7ryvm8.wl-maz@kernel.org>
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
In-Reply-To: <86ld7ryvm8.wl-maz@kernel.org>

On Wed, Oct 21, 2026 at 03:30:07PM +0100, Marc Zyngier wrote:
> On Wed, 21 Oct 2026 10:58:13 +0100,
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> > 
> > On 29/09/2026 12:15, Catalin Marinas wrote:
> > > On Mon, Sep 28, 2026 at 07:28:20PM +0100, Suzuki K Poulose wrote:
> > >> On 28/09/2026 19:01, Catalin Marinas wrote:
> > >>> possible, to defer the RMM activation until the first user (still do the
> > >>> RMI probing as an initcall). If we run on RME-capable hardware and
> > >>> firmware but don't care about realms or TSM, we still get the normal OS
> > >>> functionality.
> > >> 
> > >> Would you prefer this in the first drop of the RMM ? Or is this
> > >> something we could add as a separate series ?
> > > 
> > > I think we could add the deferring as a separate patch, maybe together
> > > with the KVM bits. An advantage of keeping it here if we merge this
> > > first is that we still exercise the activation path without full realm
> > > support or TSM. Otherwise a lot of this would be dead code until the
> > > other series arrive. Either way, do it as as separate patch on top of
> > > this series.
> > > 
> > 
> > I have been looking at the "on-demand" activation support and came
> > across the following design decision.
> > 
> > * We have KVM_CAP_ARM_RME which advertises that KVM can create Realm VMs
> >   to the userspace. A VMM could check this before it creates a Realm VM
> >   using KVM_CREATE_VM with type=RealmVM.
> > 
> > 
> > Now, we could delay the RMM activation as late as the KVM_CREATE_VM and
> > kick it off while we initialise the kvm as part of kvm_arch_init_vm().
> > But if that fails, we would fail the KVM_CREATE_VM.
> > 
> > The question is, what should KVM_CAP_ARM_RME indicate ?  We could
> > initially enable the cap based on the presence of RMM (but not
> > activated). However, should we turn the KVM_CAP_ARM_RME=off when we
> > fail to activate the RMM ? Is that senisble ? (i.e., runtime
> > disabling a cap).
> 
> I think this sets a bad precedent. If activation can fail, KVM end-up
> not delivering on the promise that it makes, and that's not great.
> 
> My take is that the least surprising behaviour is best. If you have
> bought into the CCA kool-aid by enabling it on the kernel command
> line, that's not by accident. You expect your VMs to reliably be
> created when KVM tells you that CCA is available.
> 
> So KVM_CAP_ARM_RME should indicate whether the RMM has been
> successfully activated, and nothing else.

Tying activation to kvm-arm.mode=rmm works for me, roughly similar to
kvm-arm.mode=protected. It's still an eager activation (just
conditional) and KVM_CAP_ARM_RME then only reports whether activation
succeeded. We lose kexec/hibernation but that's fine, it was explicitly
requested on the command line.

There's also the case of a host-only PCIe TSM (without realms). IIUC
(grep'ing FIRME spec) on an RME system IDE key programming goes via the
RMM, so this would need the RMM activated even without KVM. Not sure it
makes sense without realms, so I think we can ignore it until there's a
concrete use case (and add one more hook to activate the RMM).

-- 
Catalin
