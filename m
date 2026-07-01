Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04C1413D66;
	Wed,  1 Jul 2026 10:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782902882; cv=none; b=IoYEvDO7L4E9ReqTbcph4+vvr1s9R05dnb5TZydist+AO1PlVXpfUfolZK8GLfMiw9VZH20b95jBCu0h+NDcmKC3JR67PJnsZNIxEkejavw3tQHoygeEIvvfXmxwawTCkXcWpsKmRcUgSeLcwHIQltFn7CulsOKtdjw+gE11jr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782902882; c=relaxed/simple;
	bh=k9oLV4IW1kmjddOXs4xgFjCS/8na5VnlDFUVzIfikXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=K2gzFOsMWV2CbigTGJgjhO3+G5D+FXBFjkL/WH6X7Aqlm2eBTgGaRYh5iw0SZLGKsaKAQijesEr3bQSQWheuJsmzSeSft/F9T3Nju66wTtnBg2zHTWBK2hyNRO8/yFl7Q08AgCz1AqAiLuq4ZOCDW7H4ZK3r7I0siXXEOYAbLzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tnOzSRO0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tnOzSRO0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C24C2247;
	Wed,  1 Jul 2026 03:47:55 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1B5C3F85F;
	Wed,  1 Jul 2026 03:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782902880; bh=k9oLV4IW1kmjddOXs4xgFjCS/8na5VnlDFUVzIfikXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnOzSRO03HoN3OjxZOBM4zT7QZXKnXvBpvE2UHcg5FHEnAP6Uw1P9kZGjvy4/BHWl
	 XsLX53rt40c/3Y76DfQ8exxQAa8Zn6lDLlVABiIFTtnUSxB2BpHI8pwOpELG0RrwoS
	 cJEkgFFdJuQwSs9X0ULTp+Zo7HMVTGwI3C0PQz4s=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Kees Cook <kees@kernel.org>,
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	James Morse <james.morse@arm.com>,
	Zeng Heng <zengheng4@huawei.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 06/13] KVM: arm64: dirty_bit: Add base FEAT_HACDBS cleaning routine
Date: Wed,  1 Jul 2026 11:47:52 +0100
Message-ID: <akTwWArtOWJ--fi4@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <akQTypBfpdqSMhm_@kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com> <20260629111820.1873540-7-leo.bras@arm.com> <akKtKH8O5hngLenm@kernel.org> <akPZ2bnh3k6ZZgYx@LeoBrasDK> <akQTypBfpdqSMhm_@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 30, 2026 at 12:06:50PM -0700, Oliver Upton wrote:
> On Tue, Jun 30, 2026 at 03:59:38PM +0100, Leonardo Bras wrote:
> > > > +	hcr_el2 = read_sysreg(HCR_EL2);
> > > > +	write_sysreg(hcr_el2 | HCR_EL2_VM, HCR_EL2);
> > > 
> > > sysreg_clear_set_hcr(). I'm pretty sure all the speculative AT errata
> > > depend on HCR_EL2.VM being set _after_ the stage-2 MMU has been loaded.
> > > 
> > 
> > So, move this to after __load_stage2()?
> > ok
> 
> Yes.
> 
> > > > +	__load_stage2(&kvm->arch.mmu);
> > > 
> > > Pretty sure you need an ISB here to ensure loading the MMU is ordered
> > > with enabling HACDBS.
> > >
> > 
> > does not __load_stage2() have an isb() here?
> > In any case, will add an isb() after sysreg_clear_set_hcr(), which should 
> > come after __load_stage2() IIUC.
> 
> No, __load_stage2() inserts an ISB only for hardware subject to the
> speculative AT errata. If an implementation has broken AT and HACDBS in
> the future then it gets an additional ISB. Oh well.
>

Makes sense.
 
> > > > +	hacdbs_start(hw_entries, size);
> > > > +
> > > > +	do {
> > > > +		wfi();
> > > > +	} while (this_cpu_read(hacdbs_pcp.status) == HACDBS_RUNNING);
> > > 
> > > This is exactly why I said you should just poll hardware instead. It is
> > > entirely possible that the IRQ arrives before you WFI.
> > 
> > It should be fine with WFIT, though, right?
> 
> Sure, but we shouldn't assume a functional WFxT even if we have HACDBS.
> Just rely on pre-existing kernel infrastructure to do the thing you want
> to.

Got it.

> 
> > I understand the reason in pooling, and even done some workaround in 
> > pooling for getting this to run in the model. 
> > 
> > Based on the previous reply, do you think I should only use polling for 
> > now, and implement the IRQ later?
> 
> Yes.
> 

Will do, then.

Thanks!
Leo

