Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC0E11FFC59
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 05:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784008093; cv=none; b=e1UJO6mHDN+y/eFOh4reIJBi4ILzh3INBNvLN0ZdisLukQDM8PjENNe7O0t0M5Mg9L+XuoNubY/lJ7r30Jik8QV0RkdObxzkE0lBSaaveCUYR+9NMKQumoiTyumvXZ+gmdRluhRQedUj5nsXHO+7LExMv5NP0cWwQ1TnO0XvEz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784008093; c=relaxed/simple;
	bh=LnW4ts9Lwbe3BPXxuqMwhfTHqufwNRGWcggpm0tvBew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VW6frKDQ+GUtgOieIXLwacqjK01dCmN2bapEdU2+/qgTjeV2D6/ptlCJdVzs9V/M0Noh7PlChhhkHLoZ1AeuduklcxnxqK+uzWESDSMvlbZ/R4V005WyKuRzilbLYE2THSXvCZRdgMf0ouEguyUaB1TW233aTQBhfZU2DlLndOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QkBjiN/M; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QkBjiN/M"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F4161570;
	Mon, 13 Jul 2026 22:48:06 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4776E3F7D8;
	Mon, 13 Jul 2026 22:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784008090; bh=LnW4ts9Lwbe3BPXxuqMwhfTHqufwNRGWcggpm0tvBew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QkBjiN/MvkBffP/FzGvlZqOgTYAlnIXETK3uWmobYyBHaVLT0R47JIZ55AA68T0My
	 ESgPLI8Yl/40kJ+jQs7FjrimUBDULfv0uFCr0Q7sHtNnPJTqc1TwVa5FW05TekZbDs
	 05Ai63DX98GIXiCBZY0DkcquX50aTkmTd1vAcIOQ=
Date: Tue, 14 Jul 2026 06:47:54 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 0/5] KVM: arm64: nv: Implement nested stage-2 reverse
 map
Message-ID: <ytl6idu3chd7hg5xsgbqwdh24gdckinngirflls7o2st3moyw2@m5jeouveqw6n>
References: <20260510145338.322962-1-weilin.chang@arm.com>
 <alVweBtKt_4jH1q3@sm-arm-grace07>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alVweBtKt_4jH1q3@sm-arm-grace07>

On Tue, Jul 14, 2026 at 08:10:48AM +0900, Itaru Kitayama wrote:
> On Sun, May 10, 2026 at 03:53:33PM +0100, Wei-Lin Chang wrote:
> > Hi,
> > 
> > This is v3 of optimizing the shadow s2 mmu unmapping during MMU
> > notifiers.
> > 
> > Two new preparatory patches are added, one reduces a hole in kvm_s2_mmu
> > and another refactors the code a bit during s2 faults. Other changes are
> > listed below.
> > 
> > * Changes from v2 [1]:
> > 
> >   - Removed "polluted" teminology.
> > 
> >   - Use xa_{mk, to}_value() when storing and retriving values from maple
> >     trees.
> > 
> >   - Avoid using the 63rd bit in maple tree values so that xa_{mk, to}_value()
> >     does not lose us a bit.
> > 
> >   - Added reverse map removal during TLBI handling.
> > 
> >   - Other suggested refactorings.
> > 
> > Thanks!
> 
> Hi Wei-Lin
> As this series is no longer cleanly applied on top of the recent kvmarm/fixes,
> I wonder if you could update the series; I can wait if you're in the
> works of preparing v4. I am planning to test this series on HW with your
> proposed nested virtualization KVM selftests.

Hey Itaru,

Sorry for the delay. I have been working on something else in parallel
hence I haven't updated this series for a while. Yes I am almost done
preparing v4, it should be posted sometime this week.

Thanks for your feedback and testing!

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Itaru.
> 
> > 
> > [1]: https://lore.kernel.org/kvmarm/20260411125024.3735989-1-weilin.chang@arm.com/
> > 
> > Wei-Lin Chang (5):
> >   KVM: arm64: Use a variable for the canonical GPA in kvm_s2_fault_map()
> >   KVM: arm64: Move shadow_pt_debugfs_dentry to reduce holes in
> >     kvm_s2_mmu
> >   KVM: arm64: nv: Avoid full shadow s2 unmap
> >   KVM: arm64: nv: Remove reverse map entries during TLBI handling
> >   KVM: arm64: nv: Create nested IPA direct map to speed up reverse map
> >     removal
> > 
> >  arch/arm64/include/asm/kvm_host.h   |  17 +-
> >  arch/arm64/include/asm/kvm_nested.h |   6 +
> >  arch/arm64/kvm/mmu.c                |  43 +++--
> >  arch/arm64/kvm/nested.c             | 238 +++++++++++++++++++++++++++-
> >  arch/arm64/kvm/sys_regs.c           |   3 +
> >  5 files changed, 290 insertions(+), 17 deletions(-)
> > 
> > -- 
> > 2.43.0
> > 
