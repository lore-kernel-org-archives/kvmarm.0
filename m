Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEDC4F93B1;
	Mon, 21 Sep 2026 18:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790015976; cv=none; b=OYIAG+vhfWV6JJVJszEp5KX0nPM+Js5fG+ngUTfyEraiqsoW0akjfYtGHXIMrDGb1HTQpU6rM30V76i6AC+0S7EvUd8B3ZRichf28Na5V1wOw74BkDG3j9l64WsV6QGFhzONnoK1a0tY1wy7URojk5ZX/H37IAYcnhfqGTCBUog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790015976; c=relaxed/simple;
	bh=kyUIIXB2mn9lWlbzFMXJ3mvUOv6S8ZV4O1FOTn+ynX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pwkv6nx4XbkVwVAd9iGY6Aon7vYXInn+eXvjL8aVgqyI4bZCUmtlLj4k6A23trj+z5r/MogDbaD6eqLlPcspyc5g4/eJv5L2/zprybptDU1oJcCwgdZtqfGqAuFI5eEMiY0D0D6/O/qn9NfEVkM8dTOLntvn+gpNmJ1hynRjxKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jr8/IKpl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jr8/IKpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F8A1F000FF;
	Mon, 21 Sep 2026 18:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790015974;
	bh=3snj98fmjbtANq16+FRyVMqVPheby92j6W8WIjGOO5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jr8/IKplV+dmJmKP3CopP8NRnqIhbL8ZKCRP+bIIpuuEMVbmoILBjslfEmsTzXhgd
	 80Xid8Aiv7Dm/fZ9FXXOPbtLlcDFsJE9H6zQXmNr32c4X5+It5RqPvu3lJvXS0CovZ
	 C7zQtS0RH9NhGrErWzgjoNrAy9k/Xu2so61zDWM6vjMgb/xDEaGAmFxhIHLeAyssvd
	 1zlStONeGroUdQXq+7aSu7q9MtE+XSs2N1vlQc5uFQEMlpAg8qP1RONlU5UZOM2mQt
	 29hrOl0y2kFV0BFWJOteoBIwlIwbWMaf5lppsOL9vA8qv0wqmZ3FcN9SWfy6NK7plP
	 6zKnVwlD9BnOw==
Date: Mon, 21 Sep 2026 11:39:33 -0700
From: Oliver Upton <oupton@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Jack Thomson <jackabt@amazon.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Restore the VM's feature bitmap when
 kvm_setup_vcpu() fails
Message-ID: <arF55dt3_i4nxoSA@kernel.org>
References: <20260921063718.1604533-1-fuad.tabba@linux.dev>
 <arDYHSlFHm_XzGvN@kernel.org>
 <CA+EHjTz0-qS8RRhdT8XjAgWqKhgjjzbRsZ_jwTBVqM-8pXk7Vw@mail.gmail.com>
 <arEskPHpAPQf5SAb@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arEskPHpAPQf5SAb@gremlin>

Hey Lorenzo,

On Mon, Sep 21, 2026 at 02:34:12PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Sep 21, 2026 at 08:24:56AM +0100, Fuad Tabba wrote:
> > Hi Oliver,
> >
> > On Mon, 21 Sep 2026 00:09:17 -0700, Oliver Upton <oupton@kernel.org> wrote:
> > [...]
> > > > Nothing in the tree loads a vCPU whose init failed, so this is latent.
> > > > The upcoming series that enables KVM_PRE_FAULT_MEMORY for arm64 exposes
> > > > it: the generic kvm_vcpu_pre_fault_memory() calls vcpu_load() whether
> > > > or not the vCPU has been initialised.
> > >
> > > That's a bug, not a feature. We should require an initialized vcpu for
> > > the ioctl.
> >
> > That one is for Lorenzo then :) I'll reword the message so the stale
> > bitmap comes first and the pre-fault crash is just how it showed up.
> 
> In general this is the behaviour of _generic_ KVM code
> (kvm_vcpu_pre_fault_memory()), which itself does not require an initialised
> vCPU, and no other arch seems to requires that either in the arch-specific
> pre-fault code.
> 
> The actual pre-faulting implementation intentionally only targets the
> canonical MMU to fault in S2 page tables, which doesn't need initialisation
> to have taken place AFAICT.
> 
> However I could add:
> 
> 	if (!kvm_vcpu_initialized(vcpu))
> 		return -ENOEXEC;
> 
> To kvm_arch_vcpu_pre_fault_memory(), which would make this a requirement,
> though that would bring us out of line with other archs.

Actually, we need this enforcement to happen before the arch-generic
implementation calls vcpu_load(). So that would be some amount of
kvm_arch_* boilerplate added to the generic code to enforce this
requirement like we do on the other vCPU ioctls.

I'm not too worried about aligning this with other architectures; the
idea of a half-baked vCPU getting loaded is worrying.

> OTOH, I don't see why anybody would pre-fault BEFORE init, feels like
> something that should be done later on in VMM bring up right?
> 
> So I doubt doing this would really break any sane user.
> 
> Let me know if you want that change in the series and I can respin it.

Please do, thank you for addressing this.

Best,
Oliver
