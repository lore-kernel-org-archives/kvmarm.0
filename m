Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 422AD4B540C
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 10:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789553327; cv=none; b=qm9X2darNwM3xOra5b4hIL29mvGogMItajpuktt0LUdZtFTLBpRxGzNgqYZ6NBIRAm2m2HRjINbTA1oCmcqRXG9KlVrVDxODe98JlcKzYUbtUOTmfauuVD69ovhZcY6B8Kr0yC5PfjlLyvCeqHdt1OeXzWLCWt0XqbQKJgXjQaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789553327; c=relaxed/simple;
	bh=rPfrOTQ5oZS8SrKWqKFay5mhp8ATUr37rXa+UxcnFjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E7/lW8KcvjOZHEcu/+8614ap36bLMH9gvwru21xYPY0mS0PWhWLW77JnePKVbWChCORBKE10IYy+pL/VAHoAxMa0NuiFj4zrlNfNd0a2JBm0MKK11EXtzYq1K437Pn025kCG0UcQdAU5iTFOHfLAzUpNJZBiGDKCaMqWO1kG/oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=D7hym+Dt; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="D7hym+Dt"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55C3E152B;
	Wed, 16 Sep 2026 03:08:35 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8CB703F882;
	Wed, 16 Sep 2026 03:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789553318; bh=rPfrOTQ5oZS8SrKWqKFay5mhp8ATUr37rXa+UxcnFjs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D7hym+DtzqOo1Lr7h7LCEXYfKJE1jeuk5emATCzKr2bqhDmADUufXJ+d6DdYLD6ZX
	 kP7jHOHxQ8ipABjdpHZ93BmcpJwE/+ampQmPsJu8PSzl8XA8IaA6PZA2he2ngzb25A
	 e7yzrgQfJO8DmzYwcaWMcV0nLb+BL+bfIv4eHDeA=
Date: Wed, 16 Sep 2026 11:08:28 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>, 
	Itaru Kitayama <itaru.kitayama@fujitsu.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Wang Han <wanghan@linux.alibaba.com>, Shuai Xue <xueshuai@linux.alibaba.com>, 
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH v6 0/7] KVM: arm64: nv: Implement nested stage-2 reverse
 map
Message-ID: <pstlgffmaummwvxp6ldpel2y7ozubq77eqgrr7px2czc3f4qzn@nvmeyljx2anj>
References: <20260915154305.3852871-1-weilin.chang@arm.com>
 <aqoh27cSs5gMHeAL@sm-arm-grace07>
 <86mrth65ii.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86mrth65ii.wl-maz@kernel.org>

On Wed, Sep 16, 2026 at 08:04:53AM +0100, Marc Zyngier wrote:
> On Wed, 16 Sep 2026 05:58:03 +0100,
> Itaru Kitayama <itaru.kitayama@fujitsu.com> wrote:
> > 
> > Hi Wei-Lin,
> > 
> > On Tue, Sep 15, 2026 at 04:42:58PM +0100, Wei-Lin Chang wrote:
> > > Hi,
> > > 
> > > This is v6 of optimizing the shadow s2 mmu unmapping during MMU
> > > notifiers.
> > > 
> > > This version fixes a few issues, and adds Marc's space optimization
> > > for kvm_guest_s2_mapping [1]. Please see the changelog for the details.
> > > 
> > > Tested by booting L3, and running in-kernel targetted tests described
> > > in [2]. v5 got some tested-by's from Itaru and Wang (thanks), I didn't
> > > carry them over since some bugs fixed in v6 are non-obvious. Some
> > > retest would be much appreciated!
> > > 
> > > Series based on v7.3-rc3 + Marc's nested mmu lifecycle fixes [3].
> > 
> > Observed on QEMU (accel tcg) only, but I saw:
> > 
> > [ 1812.052752] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1630
> > [ 1812.052896] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 596, name: shadow_stage2
> > 
> > The kernel is built on top of Marc's fix and your version six series, but
> > the fix for debugfs will be posted later?
> > 
> > Your hello_nested and shadow_stage2 ran without an issue.
> > 
> > Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
> 
> So you have established that there is a critical locking bug, make
> sure you don't communicate any information to help narrow where that
> bug is, and yet give your Tested-by: tag?
> 
> What is the point? I'm baffled.
> 
> Can you at least provide an indication of what you did to get there as
> well as the full backtrace?

It is certainly the known shadow ptdump sleeping-in-atomic problem [1]
reported by Itaru, and not a problem of the reverse map series.

I have the fix for that, will send it shortly.

Thanks,
Wei-Lin Chang

[1]: https://lore.kernel.org/kvmarm/aiuF0KSvvv-ZozI1@sm-arm-grace07/

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
