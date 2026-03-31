Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383093A6B99
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 19:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774985079; cv=none; b=iW02BvW/XxPwhvW9auPN1Xumt3a28SCi5/mDVaUbSTDY3Lhkm7FBy7qI5sQT0NlY0akNqNPpn4WUoPLp1fsFkPSwYdaQUDWC88Kc82KSjzDZMEZY53A5i0tsicxnCpYhcxDt9rBCI/6n9+Cj1vjTfVLV34DtyMi8fDLtRR1PnSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774985079; c=relaxed/simple;
	bh=Vlvq4dWngbHl7LTYF8a9wczf6DlxhM4X0LWpoPJbuYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NdbJ04gkpP3LZtzgHfo6xsd3GZQvk7KSqioAurSfWnaNCZf9LBRqSx6dET9yji5QICtRxrRoQ8uIi3iqi2H/ba1cVcaQPtkREEtIG8fpUVu6V+5F3xfSvxetyrvmZoTH9x2oFLG4zF2ykQMBr7FoAd6vffHVWOzQsQYaEoWH+tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lOhKmUbG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOhKmUbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10E2C2BCB0;
	Tue, 31 Mar 2026 19:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774985078;
	bh=Vlvq4dWngbHl7LTYF8a9wczf6DlxhM4X0LWpoPJbuYQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lOhKmUbG2mxRA4pZdyB0G0h2YPyBXS5l2w1TvzcJa2VYbRu4lY/6aiCc/VV4CVGtR
	 LfD+uzqtYK+KJnS5YwgBnlIzvk6u/rTBK+P1zSrK2evLMe38gsmA0iAgQtkjczI66f
	 IloyFPslOdAUitKTlHKkoGtvvXAyQh/qrYC2CAzlf95/DMMhPN9a/qiAszkkj99vHJ
	 3y0LciEYuSPx0Dqbn/MLwZWRIfHQG8rEPbFzLPFovsWU6Nf12kVsi10JmKCCM7m4cF
	 Rni1ddnsisv3NsdpqjuBqMq22L6wgT7Ok2cfPBE/pMmPygG21SCa5KJZ+GfbkO6cyD
	 laK/v2IkMeDtg==
Date: Tue, 31 Mar 2026 20:24:32 +0100
From: Will Deacon <will@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v5 11/38] KVM: arm64: Split teardown hypercall into two
 phases
Message-ID: <acwfcFytYX7eHAUZ@willie-the-truck>
References: <20260330144841.26181-1-will@kernel.org>
 <20260330144841.26181-12-will@kernel.org>
 <0cf948e9-be64-4c75-97f8-a560442eb5d2@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cf948e9-be64-4c75-97f8-a560442eb5d2@sirena.org.uk>

On Tue, Mar 31, 2026 at 08:15:40PM +0100, Mark Brown wrote:
> On Mon, Mar 30, 2026 at 03:48:12PM +0100, Will Deacon wrote:
> > In preparation for reclaiming protected guest VM pages from the host
> > during teardown, split the current 'pkvm_teardown_vm' hypercall into
> > separate 'start' and 'finalise' calls.
> > 
> > The 'pkvm_start_teardown_vm' hypercall puts the VM into a new 'is_dying'
> > state, which is a point of no return past which no vCPU of the pVM is
> > allowed to run any more.  Once in this new state,
> > 'pkvm_finalize_teardown_vm' can be used to reclaim meta-data and
> > page-table pages from the VM. A subsequent patch will add support for
> > reclaiming the individual guest memory pages.
> 
> We've started seeing WARN_ON()s generated in -next on N1DSP when running
> kvm-unit-tests under pKVM:
> 
> 1821 23:03:59.721620  <4>[   17.558270] ------------[ cut here ]------------
> 1822 23:03:59.725053  <4>[   17.558274] WARNING: arch/arm64/kvm/pkvm.c:373 at __pkvm_pgtable_stage2_unshare+0xbc/0xfc, CPU#3: qemu-system-aar/390

Aha! That's probably the thing I tried to fix today. Please can you try
these patches on top?

https://lore.kernel.org/r/20260331155056.28220-1-will@kernel.org

Thanks,

Will
