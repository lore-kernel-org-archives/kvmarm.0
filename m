Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCAC30C35F;
	Sat, 19 Sep 2026 18:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789842979; cv=none; b=NSp9MckaVuQadKEzIylfTx9wm+FGOtc3NzNoznUtvbN11lM0GLA4lnqTr+aQnSZAMHmpjKIFExv77xIMfOvEomz6Op+SiVRkQBkk60sQCmb5KtDwx6oLsCaFqFpWUHeRgkbiS99e6lZXB0pJhNtaOE4DfqMz49PatbnmVzh41+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789842979; c=relaxed/simple;
	bh=hCo2pZtmoPJecO1D2Wh1r0QRR9FPOXCuGWEogFvw6Mo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=scXMyzRiq8cf7kgzbWoSSfcIsoFHg1F/FSDR9agIokcyNcLA7UEmU9qx0R5D5yNf63yxtdpW+WCbp3VXqkknufjQO01HCBr6vYlD0coS/QHtTo5TGhD7e1npCep6V2PEdmVONal6LJV27XnD4V6Jgloghe3bj8ksQO9T9CD0ZFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RuZGTp7Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RuZGTp7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BDD1F000FF;
	Sat, 19 Sep 2026 18:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789842978;
	bh=GtjH5GaHbdy/dzwtgEaK5zRKcSSFxLPn+4OR5BHpbyc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RuZGTp7ZSb57vSwDD3EswVj0UWtSRkQbQpWJW8S3Ih0b60DdBhgn2RxbAsJ8290Qq
	 2QT6sy+VMd57E/tT6QZ09jFfXdHlz8IiHBg3CDjmXpO782yzp4hXW6cyvSQjOlJoAT
	 j4sVa6ys0pukZ6BVum8PRaCdP1gQtw8wIdTXg6/uLoJ820dEo/75VMWVE9wPfn0o1M
	 WpbLgnNW82jIDVmjt6QBXZloCORLwJ9St8a0dhGIVT9/rnN6AEZVAYtup0ubjEh7BN
	 kW+01akXZd6APv++pHCf2mkRcBchbWZGeJ6NP3WrSFCWpNrZG3fjBVGqu1Giam2YSb
	 q1B0TfDruJJkA==
Date: Sat, 19 Sep 2026 11:36:17 -0700
From: Oliver Upton <oupton@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Sean Christopherson <seanjc@google.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.3, round #1
Message-ID: <aq7WIW052XXHJWlL@kernel.org>
References: <aq7ViMljbhjibseX@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq7ViMljbhjibseX@kernel.org>

On Sat, Sep 19, 2026 at 11:33:45AM -0700, Oliver Upton wrote:
> Hi Paolo,
> 
> Here's the first pile of fixes for 7.3.
> 
> The diff is definitely on the larger end, although this is mostly
> explained by the inclusion of a selftest for the ITS table changes
> which are quite tricky. Also worth noting that this selftest mixed poorly
> in next with Sean's PPC selftest prefix due to the library changes [*].
> 
> Otherwise, the most noteworthy change here is definitely the pKVM patches
> to unmap the EL2 hypervisor's stack pages from the host, for obvious
> reasons...
> 
> Details on the rest of it can be found in the tag. Please expect at
> least one more pull for 7.3, there's some additional changes that are
> still brewing.
> 
> Please pull.

Haven't caffeinated enough yet.

Just in case it wasn't clear, this is a
conflict with 7.4 material and based on the conversation I expect Sean
to work around it.

[*]: https://lore.kernel.org/linux-next/aqqap3DngKznNrSA@sirena.org.uk/

> Thanks,
> Oliver
> 
> The following changes since commit fd73f4a6659897191fa0d40695fe370925dd3780:
> 
>   Linux 7.3-rc3 (2026-09-13 14:38:02 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags/kvmarm-fixes-7.3-1
> 
> for you to fetch changes up to 6b1bca1b1ab77f60a62087337bfe6e2f0efb9e6d:
> 
>   KVM: arm64: Fix AArch32 DBGBXVR<n> handling (2026-09-19 11:14:22 -0700)
> 
> ----------------------------------------------------------------
> KVM/arm64 changes for 7.3, take #2
> 
>  - Invalidate the ITS translation cache when the guest changes the
>    base address of the ITS tables (Fuad Tabba)
> 
>  - Skip saving ITS devices with device IDs that are out-of-bounds
>    rather than failing the entire ITS save ioctl (Fuad Tabba)
> 
>  - Close race between VM teardown and invalidations of nested MMUs
>    when handling MMU operations that are allowed to block
>    (Lorenzo Stoakes)
> 
>  - Various fixes for the handling of the host's untrusted SVE
>    configuration in pKVM (Fuad Tabba)
> 
>  - Make sure that empty SMCCC ranges based at 0 are rejected by the
>    kvm_smccc_set_filter() (Karl Mehltretter)
> 
>  - Revoke the host mapping for pKVM's private stack pages, along
>    with a new sanity check that all mappings in the hyp's private
>    VA range have been correctly marked as hyp-owned (Fuad Tabba)
> 
>  - Lifetime fixes for the array of shadow stage-2 MMUs, ensuring that
>    concurrent vCPU initialization cannot relocate in-use MMUs. Defer
>    the freeing of shadow stage-2 MMUs to the point that no other users
>    (e.g. MMU notifier) could reference them (Marc Zyngier)
> 
>  - Drop useless WARN when rejecting an unsupported ioctl for pKVM
>    (Fuad Tabba)
> 
>  - Fix the steal_time selftest to install correctly-sized mappings for
>    non-4K hosts (Sebastian Ott)
> 
>  - Correct mapping of fine-grained trap for GCSPOPX instruction
>    (Mark Brown)
> 
>  - Fix KVM_BUG_ON() due to missing handling of DBGBXVR<n> from 32-bit
>    guests (Karl Mehltretter)
> 
> ----------------------------------------------------------------
> Fuad Tabba (13):
>       KVM: arm64: vgic-its: Free the caches when GITS_BASER changes
>       Revert "KVM: arm64: vgic-its: Don't save collections the table cannot hold"
>       KVM: arm64: vgic-its: Skip unreachable devices instead of failing the save
>       KVM: arm64: selftests: Add ITS table save tests
>       KVM: arm64: Validate the SVE vector length in pkvm_vcpu_init_sve()
>       KVM: arm64: Do not clear VM-wide SVE feature on vCPU init failure
>       KVM: arm64: Key unpin_host_sve_state() on the state it unpins
>       KVM: arm64: Derive GUEST_HAS_SVE from the SVE feature bit at EL2
>       KVM: arm64: Transfer the hyp stack pages out of the host stage-2
>       KVM: arm64: Match hyp text by physical address in fix_host_ownership()
>       KVM: arm64: Move the private VA allocation cursor to __io_map_next
>       KVM: arm64: Check every private mapping is hyp-owned at pKVM init
>       KVM: arm64: Don't WARN on an unknown VM ioctl in protected mode
> 
> Karl Mehltretter (3):
>       KVM: arm64: Return -EINVAL for an empty SMCCC filter range at base 0
>       KVM: arm64: selftests: Test empty SMCCC filter range at base 0
>       KVM: arm64: Fix AArch32 DBGBXVR<n> handling
> 
> Lorenzo Stoakes (ARM) (2):
>       KVM: arm64: Fix spurious warning for benign stage 2 teardown race
>       KVM: arm64: nv: Fix null ptr deref on nested wp/unmap, teardown race
> 
> Marc Zyngier (2):
>       KVM: arm64: nv: Fix life cycle of the nested_mmus array
>       KVM: arm64: nv: Delay freeing of shadow S2 structures until VM destruction
> 
> Mark Brown (1):
>       KVM: arm64: Fix FGT mapping for HFGITR_EL2.nGCSEPP
> 
> Sebastian Ott (1):
>       KVM: selftests: fix steal_time for arm64 with host page size > 4K
> 
>  arch/arm64/include/asm/kvm_host.h                 |   2 +-
>  arch/arm64/include/asm/kvm_nested.h               |   3 +-
>  arch/arm64/include/asm/kvm_pkvm.h                 |   3 +-
>  arch/arm64/kvm/arm.c                              |   8 +-
>  arch/arm64/kvm/emulate-nested.c                   |   2 +-
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h     |   2 +
>  arch/arm64/kvm/hyp/include/nvhe/mm.h              |   1 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c             |  20 +
>  arch/arm64/kvm/hyp/nvhe/mm.c                      |  79 +++-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                    |  29 +-
>  arch/arm64/kvm/hyp/nvhe/setup.c                   |  16 +-
>  arch/arm64/kvm/hypercalls.c                       |   3 +-
>  arch/arm64/kvm/mmu.c                              |  15 +-
>  arch/arm64/kvm/nested.c                           | 111 +++---
>  arch/arm64/kvm/sys_regs.c                         |   1 +
>  arch/arm64/kvm/vgic/vgic-its.c                    |  46 ++-
>  tools/testing/selftests/kvm/Makefile.kvm          |   1 +
>  tools/testing/selftests/kvm/arm64/smccc_filter.c  |   4 +
>  tools/testing/selftests/kvm/arm64/vgic_its_save.c | 441 ++++++++++++++++++++++
>  tools/testing/selftests/kvm/steal_time.c          |  30 +-
>  20 files changed, 700 insertions(+), 117 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/arm64/vgic_its_save.c
