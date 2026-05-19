Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF8C3932CE;
	Tue, 19 May 2026 21:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779226272; cv=none; b=ACAE2U03HCNMp0vSRTubI68s0GP3vOHE2rjChff7+uv/Xzd9IVnJjdaSld1xjvaLfu3UspIHwZWvkMFoTCP7bccidlbtAMNKjszgm/M1zMzlmsnVMV5BS3X5BG4Ryu7h+/EaEjoNOu6ArNat5UoTgiM0XuXHNx14kGcELkN7XIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779226272; c=relaxed/simple;
	bh=cu5DFJ3DfHfxIobQ9ABwo+jUYPyi7yRiQw28mmLFfAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uwP/ygq1SFyg1HkLrJPMdb71kzVdDpWkaKBeAyBGe450PB2Jr/C7CXqWoYvWQFpP5O5O2dQzpfgmxm+iHiyNCCB/QGT9nTf+YKbWXyFv5i+FHJoj2sNJfRs9WZzXumUJX2vTY5S8k+bGB2xvNodICz9WoXJgPmktd8HAxnePaFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BTSu6W0V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BTSu6W0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40361F000E9;
	Tue, 19 May 2026 21:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779226271;
	bh=OKY7V5FfRET17/kEDTnFckQsQH4e38JTxTched89wOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BTSu6W0V0CE+Pk6MwecLeB32KlRvGGqEk3KDHMPev64BOWUPU1oD+HV4AOjVmQ5f3
	 vwjwshgRZnNAPkzjE7PHPCYK+IbmM5aICH21f9HqoBX3RUHplMC6nLDHBEhucbKJkH
	 0IBqIpXnMnuDf8M+vbZMcKdt1Vc9MOY0T7Pt5cdhcmpf333SrVjnxC5Alh3tCSihSc
	 Jf7aYXOiEgT4i3LgITMQiXaj+m1d37WMEw/BeLMyYL2pHp5eK53vERKh480lo3Yo0w
	 gVIcrzALlRdSJPBmZH29j/2oGpzhSxSTB269+IcHBlViScKdSuuTV0wg/wwU38Ts7Z
	 g6zbPZzlnHZ5g==
Date: Tue, 19 May 2026 14:31:09 -0700
From: Oliver Upton <oupton@kernel.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>
Subject: Re: [PATCH v3 0/9] KVM: arm64: selftests: Basic nested guest support
Message-ID: <agzWnS2gzzhEHEG6@kernel.org>
References: <20260516183003.799058-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260516183003.799058-1-weilin.chang@arm.com>

Hi Wei-Lin,

Thank you very much for the series.

I haven't had time to read through much of this yet, but I noticed
Itaru's comment about leaving stage-1 translation disabled for the L2.

Since selftests expects things like atomics to work we will definitely
need the stage-1 MMU to be enabled w/ Normal mappings (this was broken
in the past [*]). I wonder if we can (ab)use the pre-existing stage-1
tables that the selftests library creates on behalf of the L1. After all,
L1 and L2 are both effectively in the same virtual address space.

[*] https://lore.kernel.org/kvmarm/20250405001042.1470552-1-rananta@google.com/

Thanks,
Oliver

On Sat, May 16, 2026 at 07:29:54PM +0100, Wei-Lin Chang wrote:
> Hi,
> 
> This is v3 of adding basic support for running nested guests (L2) in
> kselftest. This time a framework for enabling stage-2 in the guest is
> added, including the s2_mmu struct, s2 translation control setup, and
> a stage-2 page table generator. Similar to L2 vCPU management, all
> stage-2 work is done in the guest instead of userspace.
> 
> An additional shadow_stage2 test is added which leverages the framework
> to run L2 with stage-2 enabled.
> 
> * Changes from v2 [1]:
> 
>   - Update vm_paddr_t to gpa_t, vm_vaddr_t to gva_t.
> 
>   - Added framework for enabling stage-2 in the guest.
> 
>   - Added shadow_stage2 test.
> 
> Thanks!
> 
> [1]: https://lore.kernel.org/kvmarm/20260412142216.3806482-1-weilin.chang@arm.com/
> 
> Wei-Lin Chang (9):
>   KVM: arm64: selftests: Add GPR save/restore functions for NV
>   KVM: arm64: selftests: Add helpers for guest hypervisors
>   KVM: arm64: selftests: Add hello_nested basic NV selftest
>   KVM: arm64: selftests: Enhance hello_nested test
>   KVM: arm64: selftests: Add shadow_stage2 test
>   KVM: arm64: selftests: shadow_stage2: Allocate L2 stack from dedicated
>     pool
>   KVM: arm64: selftests: shadow_stage2: Check supported stage-2 granule
>     size
>   KVM: arm64: selftests: Add infrastructure for using stage-2 in guest
>   KVM: arm64: selftests: shadow_stage2: Turn on stage-2 translation for
>     the nested guest
> 
>  tools/testing/selftests/kvm/Makefile.kvm      |   5 +
>  .../selftests/kvm/arm64/hello_nested.c        | 134 +++++++++
>  .../selftests/kvm/arm64/shadow_stage2.c       | 165 +++++++++++
>  .../selftests/kvm/include/arm64/nested.h      |  85 ++++++
>  tools/testing/selftests/kvm/lib/arm64/entry.S | 137 +++++++++
>  .../selftests/kvm/lib/arm64/hyp-entry.S       |  77 +++++
>  .../testing/selftests/kvm/lib/arm64/nested.c  | 264 ++++++++++++++++++
>  7 files changed, 867 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/arm64/hello_nested.c
>  create mode 100644 tools/testing/selftests/kvm/arm64/shadow_stage2.c
>  create mode 100644 tools/testing/selftests/kvm/include/arm64/nested.h
>  create mode 100644 tools/testing/selftests/kvm/lib/arm64/entry.S
>  create mode 100644 tools/testing/selftests/kvm/lib/arm64/hyp-entry.S
>  create mode 100644 tools/testing/selftests/kvm/lib/arm64/nested.c
> 
> -- 
> 2.43.0
> 
> 
