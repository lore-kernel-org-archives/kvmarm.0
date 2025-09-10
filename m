Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DC82EFD84
	for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 20:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757535922; cv=none; b=FR/XRzNlQCqvtT0d02hxIy/qFMiq56zEL8nbYi5d7kbpKOI4ISSrlD/aMQHEIFRDuwwMSWVkXOC8TFaHEQ1KQfCxFKzwlAbrXWjLs6pSrFjZgCx6gMnFBBirl6Q48yjlVOhCPnOhxm4U/UDC5JFeoRn95WXhdsyxKDJ8ueJhn/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757535922; c=relaxed/simple;
	bh=p3VkcWlO3QI4zWzgjfxWR08XJP8TTbdCL2Wl8WEyMKM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cO9K7M4O4M25h+Ze5SiWHVWl2MjB/+xu+9hNrkIife4redqese2BNItwMD07qScDtS+2NtPENhn5Hl2iEXxMlV1dpbENZV7a3F9bHY9wmT5LwWNWZRj4zB8lmNo1FgEcmjS4XkeYyaH1I99+SBIWE/p9wUDoy6z5Z/svBMOVQDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AjH0iceW; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AjH0iceW"
Date: Wed, 10 Sep 2025 13:25:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757535918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=7NUSh4J/FGzjUVpP0QMaih3K/9q6SmF3s0V6r2pV6bQ=;
	b=AjH0iceW0rwJ8+46ZfNEZGaoTmLdjfFIUCnqTmGtEGkW/o705QXz1zwdppcvwbtLPbvTp1
	g4MxLCYrKbwkCZ4t1FU5QTt9De/zP5T12gay7Ga4K3beof9JmcOrk/cNuo+7jgFqWaF5QK
	fBJXYtP/FBItObslHvtt4H3eNTPsiPg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 changes for 6.17, round #3
Message-ID: <aMHepH8Md9gSu2ix@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Paolo,

This is most likely the final set of KVM/arm64 fixes for 6.17.

Of note, I reverted a couple of fixes we took in 6.17 for RCU stalls when
destroying a stage-2 page table. There appears to be some nasty refcounting /
UAF issues lurking in those patches and the band-aid we tried to apply didn't
hold.

Besides that, random pile of fixes, many involving the usual suspects: nested
and the vgic.

Please pull.

Thanks,
Oliver

The following changes since commit b320789d6883cc00ac78ce83bccbfe7ed58afcf0:

  Linux 6.17-rc4 (2025-08-31 15:33:07 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags/kvmarm-fixes-6.17-2

for you to fetch changes up to e6157256ee1a6a500da42556e059d4dec2ade871:

  Revert "KVM: arm64: Split kvm_pgtable_stage2_destroy()" (2025-09-10 11:11:22 -0700)

----------------------------------------------------------------
KVM/arm64 changes for 6.17, round #3

 - Invalidate nested MMUs upon freeing the PGD to avoid WARNs when
   visiting from an MMU notifier

 - Fixes to the TLB match process and TLB invalidation range for
   managing the VCNR pseudo-TLB

 - Prevent SPE from erroneously profiling guests due to UNKNOWN reset
   values in PMSCR_EL1

 - Fix save/restore of host MDCR_EL2 to account for eagerly programming
   at vcpu_load() on VHE systems

 - Correct lock ordering when dealing with VGIC LPIs, avoiding scenarios
   where an xarray's spinlock was nested with a *raw* spinlock

 - Permit stage-2 read permission aborts which are possible in the case
   of NV depending on the guest hypervisor's stage-2 translation

 - Call raw_spin_unlock() instead of the internal spinlock API

 - Fix parameter ordering when assigning VBAR_EL1

----------------------------------------------------------------
Alexandru Elisei (2):
      KVM: arm64: Initialize PMSCR_EL1 when in VHE
      KVM: arm64: VHE: Save and restore host MDCR_EL2 value correctly

Alok Tiwari (1):
      KVM: arm64: vgic: fix incorrect spinlock API usage

Dongha Lee (1):
      KVM: arm64: nv: Fix incorrect VNCR invalidation range calculation

Fuad Tabba (1):
      KVM: arm64: Fix parameter ordering for VBAR_EL1 assignment

Geonha Lee (1):
      KVM: arm64: nv: fix VNCR TLB ASID match logic for non-Global entries

Marc Zyngier (1):
      KVM: arm64: Mark freed S2 MMUs as invalid

Oliver Upton (8):
      KVM: arm64: vgic: Drop stale comment on IRQ active state
      KVM: arm64: vgic-v3: Use bare refcount for VGIC LPIs
      KVM: arm64: Spin off release helper from vgic_put_irq()
      KVM: arm64: vgic-v3: Erase LPIs from xarray outside of raw spinlocks
      KVM: arm64: vgic-v3: Don't require IRQs be disabled for LPI xarray lock
      KVM: arm64: vgic-v3: Indicate vgic_put_irq() may take LPI xarray lock
      Revert "KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables"
      Revert "KVM: arm64: Split kvm_pgtable_stage2_destroy()"

Wei-Lin Chang (1):
      KVM: arm64: Remove stage 2 read fault check

 arch/arm64/include/asm/kvm_host.h       |  1 +
 arch/arm64/include/asm/kvm_pgtable.h    | 30 -------------
 arch/arm64/include/asm/kvm_pkvm.h       |  4 +-
 arch/arm64/kvm/arm.c                    |  4 +-
 arch/arm64/kvm/debug.c                  | 13 ++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  5 ---
 arch/arm64/kvm/hyp/nvhe/switch.c        |  6 +++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c      |  2 +-
 arch/arm64/kvm/hyp/pgtable.c            | 25 ++---------
 arch/arm64/kvm/mmu.c                    | 45 +++----------------
 arch/arm64/kvm/nested.c                 |  6 +--
 arch/arm64/kvm/pkvm.c                   | 11 +----
 arch/arm64/kvm/vgic/vgic-debug.c        |  2 +-
 arch/arm64/kvm/vgic/vgic-init.c         |  6 +--
 arch/arm64/kvm/vgic/vgic-its.c          | 15 +++----
 arch/arm64/kvm/vgic/vgic-v4.c           |  2 +-
 arch/arm64/kvm/vgic/vgic.c              | 80 ++++++++++++++++++++++++---------
 arch/arm64/kvm/vgic/vgic.h              |  8 ++--
 include/kvm/arm_vgic.h                  |  9 ++--
 19 files changed, 120 insertions(+), 154 deletions(-)
