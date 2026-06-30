Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB0B3DEAFB;
	Tue, 30 Jun 2026 19:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782846415; cv=none; b=TuFwVCjfjFP+b2XHQhRJxuWVfxFrAhx2YTtllS6N89uP//f9eFYJPYEoKWlajnW2/t/ixGP12+MWlSXShp7a4KDGxZh5tlVptKIxVwZHydDxdgzc2StMm/CgFntYmppx+ImsWb649bOrDrrqnJoRT9gi1tK9hXhCc06awQlaLaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782846415; c=relaxed/simple;
	bh=eH8z233B8fiqG+G4DTda5LWEIBJmPQrwo++4S94eLLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kFIGJ/9jRQYJn7DOwpgsyw5rto0ugkkhzMg02vDzMoG4oaDSbD0lfHb08NIbPv34FTeMSAGtsrw7KuD40e5CaVBP/1zF9wW9jF7rpFaG7S2+CTpJXwoXpbY7LdN2wspmL0JoXnR4+SlFW+ZaE4k9Dd0XPlzOpE97arKPdY5IDK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vez6WZId; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vez6WZId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFA81F00A3A;
	Tue, 30 Jun 2026 19:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782846411;
	bh=78nmj35MJpTYomr+d5kVLOz9zHKnBfeYnuTEJWKrcq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vez6WZIdrP+D1qdx0lVOHuMp529mOYXTgxnyttOVMyVcgYtli9Y2qQEvUke0+1SZD
	 zdWtIoU15DilOZtDzWQDjjNbcbldA5ixvjv6TDKNL+m35AfGngVzsoYXxZaBRIEoEb
	 hlPZI8vPlRTeHZBXVDFz7yhcQA1rIlSGa909tExWCaM1PwpsQ3kHWIeC03R6vo1gsX
	 axv/N4ZjZokMcublGhG5KtecarYcKJfDA9ZYxYBwZ8/4o38fm5YG50CW7SE1x4uMoZ
	 0tgQJX3qmolw5C70WHqHyK3B5BIJHGqJFCo2vRa1NvLqeZHOn8clLnuW7/2j+l4X5a
	 J/YkT4MwSzK7g==
Date: Tue, 30 Jun 2026 12:06:50 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>, Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Kees Cook <kees@kernel.org>,
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	James Morse <james.morse@arm.com>, Zeng Heng <zengheng4@huawei.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Thomas Huth <thuth@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>, Mark Brown <broonie@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>, Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v2 06/13] KVM: arm64: dirty_bit: Add base FEAT_HACDBS
 cleaning routine
Message-ID: <akQTypBfpdqSMhm_@kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com>
 <20260629111820.1873540-7-leo.bras@arm.com>
 <akKtKH8O5hngLenm@kernel.org>
 <akPZ2bnh3k6ZZgYx@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPZ2bnh3k6ZZgYx@LeoBrasDK>

On Tue, Jun 30, 2026 at 03:59:38PM +0100, Leonardo Bras wrote:
> > > +	hcr_el2 = read_sysreg(HCR_EL2);
> > > +	write_sysreg(hcr_el2 | HCR_EL2_VM, HCR_EL2);
> > 
> > sysreg_clear_set_hcr(). I'm pretty sure all the speculative AT errata
> > depend on HCR_EL2.VM being set _after_ the stage-2 MMU has been loaded.
> > 
> 
> So, move this to after __load_stage2()?
> ok

Yes.

> > > +	__load_stage2(&kvm->arch.mmu);
> > 
> > Pretty sure you need an ISB here to ensure loading the MMU is ordered
> > with enabling HACDBS.
> >
> 
> does not __load_stage2() have an isb() here?
> In any case, will add an isb() after sysreg_clear_set_hcr(), which should 
> come after __load_stage2() IIUC.

No, __load_stage2() inserts an ISB only for hardware subject to the
speculative AT errata. If an implementation has broken AT and HACDBS in
the future then it gets an additional ISB. Oh well.

> > > +	hacdbs_start(hw_entries, size);
> > > +
> > > +	do {
> > > +		wfi();
> > > +	} while (this_cpu_read(hacdbs_pcp.status) == HACDBS_RUNNING);
> > 
> > This is exactly why I said you should just poll hardware instead. It is
> > entirely possible that the IRQ arrives before you WFI.
> 
> It should be fine with WFIT, though, right?

Sure, but we shouldn't assume a functional WFxT even if we have HACDBS.
Just rely on pre-existing kernel infrastructure to do the thing you want
to.

> I understand the reason in pooling, and even done some workaround in 
> pooling for getting this to run in the model. 
> 
> Based on the previous reply, do you think I should only use polling for 
> now, and implement the IRQ later?

Yes.

Thanks,
Oliver
