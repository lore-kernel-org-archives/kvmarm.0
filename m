Received: from out-46.mta0.migadu.com (out-46.mta0.migadu.com [91.218.175.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78B015A9
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 05:49:51 +0000 (UTC)
Date: Mon, 17 Jul 2023 22:49:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689659389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W53G0tfjAcoafVNhqSK8+p1MBUpcZTTwnG2E5iFB4SI=;
	b=t1TSvYAZ8HkJVA12xzCIeuh09Dk4QODOBz4ODy0jzchKrFdlTE9Bth/wdLIKw8647z5Isw
	VzqaOC4PbkgmIvoqFtdSr3w0Kdw7Qch3/RxVBKnbXBTCZDyf4ede+uWB2twP/u/YwZxiR8
	YtF0Px1YaoFVVI4DtaW6dtKm2kXrXVU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Xiang Chen <chenxiang66@hisilicon.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.5, part #1
Message-ID: <ZLYn/RAovUs+U0r+@thinky-boi>
References: <ZLYnolPWJubKLZY8@thinky-boi>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLYnolPWJubKLZY8@thinky-boi>
X-Migadu-Flow: FLOW_OUT

+cc lists, because I'm an idiot.

On Mon, Jul 17, 2023 at 10:48:23PM -0700, Oliver Upton wrote:
> Hi Paolo,
> 
> Quite a pile of fixes for the first batch. The most noteworthy here is
> the BTI + pKVM finalization fixes, which address an early boot failure
> when using the split hypervisor on systems that support BTI and make the
> overall pKVM flow more robust to failures.
> 
> Otherwise, we have a respectable collection of one-offs described in the
> tag message.
> 
> Please pull.
> 
> --
> Thanks,
> Oliver
> 
> The following changes since commit 06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5:
> 
>   Linux 6.5-rc1 (2023-07-09 13:53:13 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.5-1
> 
> for you to fetch changes up to 9d2a55b403eea26cab7c831d8e1c00ef1e6a6850:
> 
>   KVM: arm64: Fix the name of sys_reg_desc related to PMU (2023-07-14 23:34:05 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.5, part #1
> 
>  - Avoid pKVM finalization if KVM initialization fails
> 
>  - Add missing BTI instructions in the hypervisor, fixing an early boot
>    failure on BTI systems
> 
>  - Handle MMU notifiers correctly for non hugepage-aligned memslots
> 
>  - Work around a bug in the architecture where hypervisor timer controls
>    have UNKNOWN behavior under nested virt.
> 
>  - Disable preemption in kvm_arch_hardware_enable(), fixing a kernel BUG
>    in cpu hotplug resulting from per-CPU accessor sanity checking.
> 
>  - Make WFI emulation on GICv4 systems robust w.r.t. preemption,
>    consistently requesting a doorbell interrupt on vcpu_put()
> 
>  - Uphold RES0 sysreg behavior when emulating older PMU versions
> 
>  - Avoid macro expansion when initializing PMU register names, ensuring
>    the tracepoints pretty-print the sysreg.
> 
> ----------------------------------------------------------------
> Marc Zyngier (3):
>       KVM: arm64: timers: Use CNTHCTL_EL2 when setting non-CNTKCTL_EL1 bits
>       KVM: arm64: Disable preemption in kvm_arch_hardware_enable()
>       KVM: arm64: vgic-v4: Make the doorbell request robust w.r.t preemption
> 
> Mostafa Saleh (1):
>       KVM: arm64: Add missing BTI instructions
> 
> Oliver Upton (2):
>       KVM: arm64: Correctly handle page aging notifiers for unaligned memslot
>       KVM: arm64: Correctly handle RES0 bits PMEVTYPER<n>_EL0.evtCount
> 
> Sudeep Holla (1):
>       KVM: arm64: Handle kvm_arm_init failure correctly in finalize_pkvm
> 
> Xiang Chen (1):
>       KVM: arm64: Fix the name of sys_reg_desc related to PMU
> 
>  arch/arm64/include/asm/kvm_host.h    |  2 ++
>  arch/arm64/include/asm/kvm_pgtable.h | 26 +++++++-------------
>  arch/arm64/include/asm/virt.h        |  1 +
>  arch/arm64/kvm/arch_timer.c          |  6 ++---
>  arch/arm64/kvm/arm.c                 | 28 ++++++++++++++++++---
>  arch/arm64/kvm/hyp/hyp-entry.S       |  8 ++++++
>  arch/arm64/kvm/hyp/nvhe/host.S       | 10 ++++++++
>  arch/arm64/kvm/hyp/nvhe/psci-relay.c |  2 +-
>  arch/arm64/kvm/hyp/pgtable.c         | 47 +++++++++++++++++++++++++++++-------
>  arch/arm64/kvm/mmu.c                 | 18 ++++++--------
>  arch/arm64/kvm/pkvm.c                |  2 +-
>  arch/arm64/kvm/sys_regs.c            | 42 ++++++++++++++++----------------
>  arch/arm64/kvm/vgic/vgic-v3.c        |  2 +-
>  arch/arm64/kvm/vgic/vgic-v4.c        |  7 ++++--
>  include/kvm/arm_vgic.h               |  2 +-
>  15 files changed, 133 insertions(+), 70 deletions(-)
