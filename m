Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69EF3563E8;
	Mon, 21 Sep 2026 13:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789997660; cv=none; b=DZ0wKarNyTRibEuc7t0tDCvCNy1M6disUt2QHKp+vBjkv27uz1BF/D8+evSrthp4qWyRDqO0NIz9gHgxtuKmlY0uRlooXsqZnkUFeKY/wJCcvkdOpEjr3xIGSTbSF4LLWV/ZxzTBIsMka9lhJbJ+7HDxl3MdQ73NSvvL2xV0BMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789997660; c=relaxed/simple;
	bh=xNPRhyk8xeBSHcVUlKVyeOqQArGPqBYlssEAVbabYyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C6Tiy1VISr2rci4Hu3A09Gy9GbM3IIqjDO8PZwQPozaG3iyj2dzW7KOCvlNHqyOEgw8hvBdxEaGrj16qvRq8crS4sYAFTbCRTMuCVUGcyErqSm11lObyICw2NFz5RP/egLP6kL0xvkd3KPfXbC02KXGb1mxG8NW6MnJxNl42hfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SSXwlK38; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SSXwlK38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FBC1F000FF;
	Mon, 21 Sep 2026 13:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789997658;
	bh=uPds00CPuo0sl2ypaQ/wdQWyadF9e46X9vKuCNW/M40=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SSXwlK38kiauqEhRh8+Pr0Ahx3wVZ6QcaM1Mm03CqCH91GgKLTwH/LxcxFLbVO4Zi
	 Fb8yRSey5wxIspybcq4fckdmq9+PkSFg47BLm9udssp5v+0jTutqSdQ1Akk4Wfohhe
	 loJGZ8Qi53PPffCB8DpvFsyTYwJzHKXWhRERxkSC+mxrUP/6UO1z3uiRBI005jZEm3
	 P5rNM/uZNUWZ7zbgwG2kg7GtfmM3sckK3Ow+5DrF+KDUDHOlW+K0dSUM4uQfASGmz8
	 59D6eS5pQyGD09iMfU48lSzvSyaQ8HBd2clEYyVbp+U8zlpMzqusbkFieywHlPkOf5
	 wTaBuLxz097tQ==
Date: Mon, 21 Sep 2026 14:34:12 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Jack Thomson <jackabt@amazon.com>, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Restore the VM's feature bitmap when
 kvm_setup_vcpu() fails
Message-ID: <arEskPHpAPQf5SAb@gremlin>
References: <20260921063718.1604533-1-fuad.tabba@linux.dev>
 <arDYHSlFHm_XzGvN@kernel.org>
 <CA+EHjTz0-qS8RRhdT8XjAgWqKhgjjzbRsZ_jwTBVqM-8pXk7Vw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTz0-qS8RRhdT8XjAgWqKhgjjzbRsZ_jwTBVqM-8pXk7Vw@mail.gmail.com>

On Mon, Sep 21, 2026 at 08:24:56AM +0100, Fuad Tabba wrote:
> Hi Oliver,
>
> On Mon, 21 Sep 2026 00:09:17 -0700, Oliver Upton <oupton@kernel.org> wrote:
> [...]
> > > Nothing in the tree loads a vCPU whose init failed, so this is latent.
> > > The upcoming series that enables KVM_PRE_FAULT_MEMORY for arm64 exposes
> > > it: the generic kvm_vcpu_pre_fault_memory() calls vcpu_load() whether
> > > or not the vCPU has been initialised.
> >
> > That's a bug, not a feature. We should require an initialized vcpu for
> > the ioctl.
>
> That one is for Lorenzo then :) I'll reword the message so the stale
> bitmap comes first and the pre-fault crash is just how it showed up.

In general this is the behaviour of _generic_ KVM code
(kvm_vcpu_pre_fault_memory()), which itself does not require an initialised
vCPU, and no other arch seems to requires that either in the arch-specific
pre-fault code.

The actual pre-faulting implementation intentionally only targets the
canonical MMU to fault in S2 page tables, which doesn't need initialisation
to have taken place AFAICT.

However I could add:

	if (!kvm_vcpu_initialized(vcpu))
		return -ENOEXEC;

To kvm_arch_vcpu_pre_fault_memory(), which would make this a requirement,
though that would bring us out of line with other archs.

OTOH, I don't see why anybody would pre-fault BEFORE init, feels like
something that should be done later on in VMM bring up right?

So I doubt doing this would really break any sane user.

Let me know if you want that change in the series and I can respin it.

--
Cheers, Lorenzo
