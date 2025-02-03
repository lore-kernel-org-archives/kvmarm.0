Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FF67D07D
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 23:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738624755; cv=none; b=pno1I5fP3bewd5QLyoIzFvkoDqwoRhoyitQl++FRd2LxdDCruP3x9vYwxOMmeU2sawOWtyz7ly2kSE1HZ2r/z/6ZjqADWs7GcVkGz8xZ034aSBObaJ5J1zLv65YG3IghMR7LRY5yDay/WNyIBkGTFE6242+dqerueeRpuummuZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738624755; c=relaxed/simple;
	bh=Ig4aI1lduZ5GHIVvXm/8TWYwIggL/qtvv+UiO8KmmNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B2YTmKFbDylhEIOxuXfYzSn9XItXuyZzL6TEMu5HvV9Myc1bFsu85lFvVKuY5dTqzEzPUKnhuLstC0rLWHmJ+cN/15Q29OCjv9VEdfehVCY2fwC8P5lQRARw9xrzgayz48wkea2mNrCPFRvvuirjsXKpYqrPgkkZhgpnGhpd8q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nkDIi8Qe; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nkDIi8Qe"
Date: Mon, 3 Feb 2025 15:19:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738624752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ifjGUGvJkZYFo5L1bDL9tJSz13ntSb3dYeATt2mrijo=;
	b=nkDIi8QemCzBZF8njMmkcisysylZn7FnuZHeo3M2nQqj6RzgOPaW92LEWdN0FyTrlkb86o
	cyEcFMhlDLKhOnrgzBt1i+mbCGCj0GM+j/T3Y0Sv/KmOfL06xkHRLgXwPyujRdjtQQBSX4
	+aE36IGv4bVky5Dp65wUTsi4/WdF1jI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mark Brown <broonie@kernel.org>, uJap072421@linux.dev
Cc: Quentin Perret <qperret@google.com>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/18] KVM: arm64: Introduce __pkvm_vcpu_{load,put}()
Message-ID: <Z6FO04PZtY8fsJhq@linux.dev>
References: <20241218194059.3670226-1-qperret@google.com>
 <20241218194059.3670226-10-qperret@google.com>
 <5ca7588c-7bf2-4352-8661-e4a56a9cd9aa@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ca7588c-7bf2-4352-8661-e4a56a9cd9aa@sirena.org.uk>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 03, 2025 at 07:50:44PM +0000, Mark Brown wrote:
> On Wed, Dec 18, 2024 at 07:40:50PM +0000, Quentin Perret wrote:
> > From: Marc Zyngier <maz@kernel.org>
> > 
> > Rather than look-up the hyp vCPU on every run hypercall at EL2,
> > introduce a per-CPU 'loaded_hyp_vcpu' tracking variable which is updated
> > by a pair of load/put hypercalls called directly from
> > kvm_arch_vcpu_{load,put}() when pKVM is enabled.
> 
> Current mainline crashes when running the arch_timer_edge_cases selftest
> in pKVM mode on a LibreTech Le Potato board, with a bisection pointing
> at this change.  The system dies like this:
> 
> # selftests: kvm: arch_timer_edge_cases
> [  130.599140] kvm [4518]: nVHE hyp panic at: [<ffff800081102b58>] __kvm_nvhe___vgic_v3_restore_vmcr_aprs+0x8/0x84!
> [  130.603685] kvm [4518]: Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE_STACKTRACE
> [  130.611962] kvm [4518]: Hyp Offset: 0xfffeca95ed000000
> [  130.617053] Kernel panic - not syncing: HYP panic:

Thanks, fix posted here [*], although as a consequence this machine will
stop running KVM in protected mode (which was never meant to work in the
first place).

[*]: https://lore.kernel.org/kvmarm/20250203231543.233511-1-oliver.upton@linux.dev/

-- 
Thanks,
Oliver
