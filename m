Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793801459;
	b=IJJiaqq9mmu5bxDlr8Owg4+pWkFOwjkAePa13GerJYwbMm/T5nirwu91PrlIMC5JaHSD
	 TBM/6op/2GMjzwMU/igetW9D7MYp/1NtslSMNcFy8E7aPU9mHc4gsOmhUbXoMTdXOnsn9
	 9a5ITunMsHujf95VJT+l+qJPNt5ABiwkPb8xl+MhGAexWhrj/Jo9MZYoDMoYKUH6DpI2F
	 NyaMvRGYcotP3Aw66V1G0DAYPRVaAQdmzTpcLy1CUjROeqT8DrqYRTPy304QxEJ8+nMAT
	 Zv1FKlqkh2Aa9wVHe2decQJLoNH9w1WYxLCOKAsionKcDhFACPaY8rgzOt1ClwBVQgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793801459;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=bVcACiTZbNDhVU6xhENZ6o8aAhkqXOgSLVPaqMsdjow=;
	b=Cn0mBir7oIEgmU5GIo8YCnQa5ea803V2vDfxtRiHP1Xy9sE7gdmutfhmimSsdBXrFTAd
	 GxTypbWAPBsgO4nzvr/ogB9FE0kx0pTb4WDXcRgKEsL1DUHcwfHRk3L8/V9+bKq5lArEP
	 N1zsqCe/8/ckGgVE94N/7KhMs9bTlo6lvbsWMV/W3E/knwvscQa8qgXo5Q/OdZBJnzPjW
	 BznIB9ZYb1Np8fWCZMri/TmGSPvgt9UiQyvbiaiCiUISg5sHzfsbaPyXR8QRowgviSEtf
	 zcSaiWQxXR8Vp0qOJOzuLPFpz34gTfcsGzvtm9Ae6Upv6MVSzZURx23ruzeOlarG1Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=WULk1VAc;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB8A1606A326
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 14:10:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB8A1606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=WULk1VAc
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C13492247;
	Wed,  4 Nov 2026 06:10:53 -0800 (PST)
Received: from e143914.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C8EE3F628;
	Wed,  4 Nov 2026 06:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793801456; bh=sDhQxKPD1vSwIgQ2ErCUWBV8m6RtnHjEWH3mc/dFqzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WULk1VAc+HzOBfaTnepFre3WCClsuYTx9JkrYFxlufYmpigJKEj8cwoxge34L9nKc
	 SSd7nZLFd4dmbIGocT7OBeFFhvnXku+zHo4BXN766Ceqc0j6GajB4vi08PBW2hv+yt
	 2XevTCqECkAH3RgQMYSwvjv75HxW68Q2ydhOHW+k=
Date: Wed, 4 Nov 2026 14:10:45 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>, Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] KVM: arm64: selftests: Tests for protected VMs
Message-ID: <aus8xb_xT64WKHDu@e143914.arm.com>
References: <20261104084842.132944-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104084842.132944-1-fuad.tabba@linux.dev>

On Wed, Nov 04, 2026 at 08:48:26AM +0000, Fuad Tabba wrote:
> Hi folks,
> 
> This series adds selftests for protected VMs. A test skips on a host
> without pKVM, and so does any case where the host doesn't have the
> required feature, e.g., PtrAuth, SVE or hugetlb pages.
> 
> A couple of points:
> 
> - Each area gets its own test rather than cases folded into existing
>   tests such as psci_test, hypercalls, set_id_regs, etc. A protected
>   guest requires its own boot path, and has to share the ucall pool
>   before its first ucall. On top of that, a protected guest gets the
>   opposite result for many of those tests' checks.
> 
> - pkvm_exceptions skips its breakpoint, watchpoint and single-step cases
>   while a protected guest's ID_AA64DFR0_EL1.DebugVer is 0. pkvm_id_regs
>   reads the same field to choose between the hidden and the exposed
>   debug view. With the patch that adds self-hosted debug to protected
>   guests [1], both tests run the debug cases with no change.
> 
> The series is structured as follows:
> 
>   01:     external_aborts: an abort injected before a vCPU's first run.
>   02-04:  Generic selftest changes: creating a protected VM, the pKVM
>           function IDs and the ucall pool's address.
>   05-06:  Protected-VM library: boot trampoline and helpers.
>   07-16:  The tests, one per area.
> 
> Based on Linux 7.4-rc1 (6628e7d4c6b25).

Hi!

I started to also write some realm tests a bit, you can check it out
here:
	https://gitlab.arm.com/linux-arm/linux-jg/-/tree/cca-kselftest

It's WIP/prototype, but it may be good to have some sharing, if
possible.
For example I also added a 'pre-boot' stub, which looks like your
pvm-entry.S:

	https://gitlab.arm.com/linux-arm/linux-jg/-/commit/cd3ae35d89974b02b7051a0c45cc68b4df8f9d3e

However I extracted the registers needed for the stub like this:

	https://gitlab.arm.com/linux-arm/linux-jg/-/commit/f559d5b61fa1a37e2d7b23704bd367e079cf8eae

This is because the current Realm branch I'm working on top of rejects
writes to those system registers (TCR_EL1, CPACR_EL1 etc). Which is why
I had to modify these functions, along with __aarch64_vcpu_add() and
some others.

I'm not sure how much there is to gain by sharing overall, but good to
bring it up early!

Thanks,
Joey

> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20261102093950.2922035-1-fuad.tabba@linux.dev/
> 
> Fuad Tabba (16):
>   KVM: arm64: selftests: Inject an abort before a vCPU's first run
>   KVM: selftests: Allow arm64 tests to create protected VMs
>   tools: arm-smccc: Add the pKVM memory sharing function IDs
>   KVM: selftests: Export the ucall pool's guest physical address
>   KVM: arm64: selftests: Add protected-VM boot trampoline
>   KVM: arm64: selftests: Add protected-VM library helpers
>   KVM: arm64: selftests: Add pkvm_host_abi host-interface test
>   KVM: arm64: selftests: Add pkvm_psci multi-vCPU PSCI test
>   KVM: arm64: selftests: Add pkvm_mem_share hypercall test
>   KVM: arm64: selftests: Add pkvm_smccc hypercall test
>   KVM: arm64: selftests: Add pkvm_id_regs register and trap test
>   KVM: arm64: selftests: Add pkvm_vcpu_regs register-state test
>   KVM: arm64: selftests: Add pkvm_irq interrupt test
>   KVM: arm64: selftests: Add pkvm_isolation host-access test
>   KVM: arm64: selftests: Add pkvm_lifecycle teardown test
>   KVM: arm64: selftests: Add pkvm_exceptions debug and SError test
> 
>  tools/include/linux/arm-smccc.h               |  22 +
>  tools/testing/selftests/kvm/Makefile.kvm      |  12 +
>  .../selftests/kvm/arm64/external_aborts.c     |  21 +
>  .../selftests/kvm/arm64/pkvm_exceptions.c     | 261 ++++++++
>  .../selftests/kvm/arm64/pkvm_host_abi.c       | 428 ++++++++++++
>  .../selftests/kvm/arm64/pkvm_id_regs.c        | 306 +++++++++
>  tools/testing/selftests/kvm/arm64/pkvm_irq.c  | 268 ++++++++
>  .../selftests/kvm/arm64/pkvm_isolation.c      | 225 +++++++
>  .../selftests/kvm/arm64/pkvm_lifecycle.c      | 110 +++
>  .../selftests/kvm/arm64/pkvm_mem_share.c      | 394 +++++++++++
>  tools/testing/selftests/kvm/arm64/pkvm_psci.c | 632 ++++++++++++++++++
>  .../testing/selftests/kvm/arm64/pkvm_smccc.c  | 117 ++++
>  .../selftests/kvm/arm64/pkvm_vcpu_regs.c      | 221 ++++++
>  .../selftests/kvm/include/arm64/pkvm.h        |  74 ++
>  .../selftests/kvm/include/ucall_common.h      |   1 +
>  tools/testing/selftests/kvm/lib/arm64/pkvm.c  | 245 +++++++
>  .../selftests/kvm/lib/arm64/pvm-entry.S       |  58 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c    |   5 +-
>  .../testing/selftests/kvm/lib/ucall_common.c  |   9 +-
>  19 files changed, 3406 insertions(+), 3 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_exceptions.c
>  create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_host_abi.c
>  create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_id_regs.c
>  create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_irq.c
>  create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_isolation.c
>  create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_lifecycle.c
>  create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_mem_share.c
>  create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_psci.c
>  create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_smccc.c
>  create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_vcpu_regs.c
>  create mode 100644 tools/testing/selftests/kvm/include/arm64/pkvm.h
>  create mode 100644 tools/testing/selftests/kvm/lib/arm64/pkvm.c
>  create mode 100644 tools/testing/selftests/kvm/lib/arm64/pvm-entry.S
> 
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> -- 
> 2.47.3
> 
