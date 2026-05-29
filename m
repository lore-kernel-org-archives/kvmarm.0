Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 150552E7635
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 13:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780061947; cv=none; b=lMK96LEvctf9wdP0VSydAlETAf+MDX6DCyLKd5Vyw9LVr1iP0LIaM7aP/HvUBBZr6qNdMbWpFCuGpe9Qj3k9rKIyhhWjg+6KQwupBmlNnex/iIWnnZ3OYP7iq1j/guusFh8TT2rqxH9BozFt1KUEVGu5e3kjAHpzhpGJ66cj82A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780061947; c=relaxed/simple;
	bh=7cmIIs9xR7uMqTm+Z6aD9663vI48NGNNoR+rAVutfCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KIaMkXYv0lqF+40iEkmuHZNwwyOJLKNfLOSon+dyIp3qqEJZsqbxozKu96PNr8EjruzRDKmGV22Xdts84AhZu2U6BeHzjcJKtVXLTEM2Hi2YMLZ+A8uhBEdgZwM+qIQn77bPiaFM6bHMdVBSO8F0fZjR2J4k58TOgU+tOeSkv3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZwbvlGL/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZwbvlGL/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73C9B2247;
	Fri, 29 May 2026 06:39:00 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F3D7F3F905;
	Fri, 29 May 2026 06:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780061945; bh=7cmIIs9xR7uMqTm+Z6aD9663vI48NGNNoR+rAVutfCA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZwbvlGL/hw4kBlp8VXC/2kqCg+mD3sjTb8MNl4B2Mmd580f1ntfEzvd3wiaQ1GZma
	 pYPyZ4BhPO8swphi0VYXozIPeakgqpXWh+EoOPe6y3keeqDqsf7bZAYzoUSTxY/tRD
	 CH2Xfcsp92lhz6kO+eCyS+TXMplYbiCu6zkDsy34=
Date: Fri, 29 May 2026 14:38:53 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
Subject: Re: [PATCH v3 0/9] KVM: arm64: selftests: Basic nested guest support
Message-ID: <ioz7qsirq2v665bqbjin5ekwss46pfg2sfmndkvail2athbo75@cgt7zikhtx6r>
References: <20260516183003.799058-1-weilin.chang@arm.com>
 <agzWnS2gzzhEHEG6@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agzWnS2gzzhEHEG6@kernel.org>

Hi Oliver,

On Tue, May 19, 2026 at 02:31:09PM -0700, Oliver Upton wrote:
> Hi Wei-Lin,
> 
> Thank you very much for the series.
> 
> I haven't had time to read through much of this yet, but I noticed
> Itaru's comment about leaving stage-1 translation disabled for the L2.
> 
> Since selftests expects things like atomics to work we will definitely
> need the stage-1 MMU to be enabled w/ Normal mappings (this was broken
> in the past [*]). I wonder if we can (ab)use the pre-existing stage-1
> tables that the selftests library creates on behalf of the L1. After all,
> L1 and L2 are both effectively in the same virtual address space.
> 
> [*] https://lore.kernel.org/kvmarm/20250405001042.1470552-1-rananta@google.com/

Thanks for the pointer, I see, only inner/outer shareable, write-back
normal memory guarantees atomics to work. Interestingly, treating the
atomic instruction as a NOP is one of the permitted outcomes if other
memory attributes are used...

However, the L2s in this series aren't using atomic instructions, and
right now for the current organization of this series, the L1 guest
hypervisor infrastructure is in lib/ for future NV selftests to share L2
creation code, but L2 code are entirely per selftest. This means other
selftest L2s can reuse the L1 stage-1 tables themselves if the implicit
memory attributes that comes from MMU being off is not desired.

Sorry if that sounded defensive, I am not opposed to always reusing the
L1 stage-1 tables in L2, just wanted to make sure the point gets across.

Always reusing L1 stage-1 tables in L2 allows L2 access to lib/ (which
should be helpful for testing recursive NV), and L1-L2 code sharing
intra-selftest. OTOH things are a bit simpler with MMU off in this case
with testing the shadow stage2.

What do you think?

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Oliver
> 
> On Sat, May 16, 2026 at 07:29:54PM +0100, Wei-Lin Chang wrote:
> > Hi,
> > 
> > This is v3 of adding basic support for running nested guests (L2) in
> > kselftest. This time a framework for enabling stage-2 in the guest is
> > added, including the s2_mmu struct, s2 translation control setup, and
> > a stage-2 page table generator. Similar to L2 vCPU management, all
> > stage-2 work is done in the guest instead of userspace.
> > 
> > An additional shadow_stage2 test is added which leverages the framework
> > to run L2 with stage-2 enabled.
> > 
> > * Changes from v2 [1]:
> > 
> >   - Update vm_paddr_t to gpa_t, vm_vaddr_t to gva_t.
> > 
> >   - Added framework for enabling stage-2 in the guest.
> > 
> >   - Added shadow_stage2 test.
> > 
> > Thanks!
> > 
> > [1]: https://lore.kernel.org/kvmarm/20260412142216.3806482-1-weilin.chang@arm.com/
> > 
> > Wei-Lin Chang (9):
> >   KVM: arm64: selftests: Add GPR save/restore functions for NV
> >   KVM: arm64: selftests: Add helpers for guest hypervisors
> >   KVM: arm64: selftests: Add hello_nested basic NV selftest
> >   KVM: arm64: selftests: Enhance hello_nested test
> >   KVM: arm64: selftests: Add shadow_stage2 test
> >   KVM: arm64: selftests: shadow_stage2: Allocate L2 stack from dedicated
> >     pool
> >   KVM: arm64: selftests: shadow_stage2: Check supported stage-2 granule
> >     size
> >   KVM: arm64: selftests: Add infrastructure for using stage-2 in guest
> >   KVM: arm64: selftests: shadow_stage2: Turn on stage-2 translation for
> >     the nested guest
> > 
> >  tools/testing/selftests/kvm/Makefile.kvm      |   5 +
> >  .../selftests/kvm/arm64/hello_nested.c        | 134 +++++++++
> >  .../selftests/kvm/arm64/shadow_stage2.c       | 165 +++++++++++
> >  .../selftests/kvm/include/arm64/nested.h      |  85 ++++++
> >  tools/testing/selftests/kvm/lib/arm64/entry.S | 137 +++++++++
> >  .../selftests/kvm/lib/arm64/hyp-entry.S       |  77 +++++
> >  .../testing/selftests/kvm/lib/arm64/nested.c  | 264 ++++++++++++++++++
> >  7 files changed, 867 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/arm64/hello_nested.c
> >  create mode 100644 tools/testing/selftests/kvm/arm64/shadow_stage2.c
> >  create mode 100644 tools/testing/selftests/kvm/include/arm64/nested.h
> >  create mode 100644 tools/testing/selftests/kvm/lib/arm64/entry.S
> >  create mode 100644 tools/testing/selftests/kvm/lib/arm64/hyp-entry.S
> >  create mode 100644 tools/testing/selftests/kvm/lib/arm64/nested.c
> > 
> > -- 
> > 2.43.0
> > 
> > 
