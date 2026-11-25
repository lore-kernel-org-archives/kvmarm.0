Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621156;
	b=4Tq77GNtFCBF3atJX5lWAdS3cQnDCw1UZ77y0vmN0MaHB9VmMUD0zg7G92VTdkqutovq
	 F26cGVhaEukNUP5ZqpSKfb9dn+Y679xAZpgB9TpRTeRyElwGyRHCS6s8K6MzjeFbu6O82
	 SlqMuGyEtT2zfPGV3yWYyRw+c4F4O/AmCt5TfX13FmXGH1Nr7MvOLYcitZNOwQ2D+nRxl
	 wmNpkln6NvnAp3SDY0r9U8SlSdPQyPlKaapeVFqt8203XQi8AY6CQOOspZtdnbOYoIQMp
	 n/cu3WtMZKbifGdrAVXik95g6+fuwdlSPg2jpxwyTDGDpl39EU6D9DKE65I64kNNEFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621156;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=ASDf1J7RYZd7g9hJRy/O98JcZzUemVt8EFMNXdnVhMI=;
	b=RtQEnmPqvzgBz3tvdcMJNP8ytdBAP80cs5YypLJd+fQGeihH5dxss9aArmccHqTSFN+7
	 N0RtEkWRaSbDXe3E/T6BpKD/0bo1YNr4KZT+vlQnKL2i+hi3oeL5k6Gfl7sb4PqbKTuBp
	 MJm5X994WeW1tuMK9QTYzYUW1YCy6njcjIBouOp6e1RyNDVXQg4F+4Oex4zpTYE7GSg6A
	 7xiryTgMnvWcm3HXsoEaLWY+IxYwRxPpbFll3JAlrlRbf1oA/P4LKLsFQqWBjR54Pm4hu
	 qz096WkpHha/3mmntMFYu6qMDqIWmD2N40lIi5S1u0rxu+1eyF3Pgmix0ktqthjD6zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ehIwP+JJ;
	arc=none smtp.remote-ip=95.215.58.1
Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAC1606A321
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:39:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AAAC1606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ehIwP+JJ
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=GsIUcTgG0fusfC+sbkYRATmQcjkhxzCYvdARKzPZoIs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795621153; v=1; x=1796225953;
 b=ehIwP+JJOsCyEKZjpEyKVfA4w7o0B5Lu5ND7tTroCYw66i4tgrkHGYJbCWTzxF33G7jFIELi
 zbgAwds3iV4CfT88xffhhxNGWtLiMS9F/ZdhHg/cx36/rGfB0j9b+c13mh+xbqTUWyzkhWijOm5
 03fixlon4buawCSifRxBa3vk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 47b5237eae5c5d30;
	Wed, 25 Nov 2026 15:39:13 +0000
X-Mizu-Trace-ID: 47b5237eae5c5d30
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/20] KVM: arm64: Support debug, SVE, MOPS, PIE/POE, FPMR and more in protected VMs
Date: Wed, 25 Nov 2026 15:38:51 +0000
Message-ID: <20261125153911.106793-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Changes since v1 [1]:
  - Replaced the #ifdef around the feature map check with a WARN_ON().
    (Oliver)
  - Added two fixes, for ptrauth and MTE_frac.
  - Added a patch advertising GICv3 to protected VMs on GICv5 hosts with
    legacy support.
  - Small fixes and tidying up.
  - Rebased on 7.4-rc3.

With most of the groundwork merged, it's time to bring protected VMs up
to the features we support for them in Android.

  01-02:  Fixes for ptrauth and MTE_frac.
  03:     Self-hosted debug.
  04-07:  SVE, with EL2 owning a protected vCPU's SVE state.
  08-11:  Compute a protected vCPU's fine-grained traps at EL2.
  12-20:  Advertise TCR2, SCTLR2, S1PIE, S1POE, MOPS, FPMR and the
          features EL2 already handles for non-protected guests.

Tested on QEMU, in hVHE and nVHE, and on FVP for S1POE, GICv5 in legacy
mode and the fields QEMU doesn't model (CLRBHB, RPRFM, ECBHB, LSFE,
LSUI, HAFT, ETS3 and F16MM). v2 of the pKVM selftests series [2] covers
debug, SVE, MOPS, PIE, POE and FPMR.

Based on Linux 7.4-rc3 (aebb727447640).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261109083205.806619-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20261109084854.840576-1-fuad.tabba@linux.dev/

Fuad Tabba (20):
  KVM: arm64: Only allow ptrauth for a pVM on a system with full ptrauth
  KVM: arm64: Don't advertise the host's MTE_frac to protected VMs
  KVM: arm64: Add support for self-hosted debug in protected guests
  KVM: arm64: Remove redundant kern_hyp_va() calls from the pKVM FP sync
  KVM: arm64: Allocate a protected vCPU's SVE state at EL2
  KVM: arm64: Advertise ID_AA64ZFR0_EL1 to protected VMs
  KVM: arm64: Allow protected VMs to use SVE
  KVM: arm64: Move the VM's FGU initialisation into config.c
  KVM: arm64: Report an incomplete feature map with WARN_ON()
  KVM: arm64: Advertise the GICv3 CPU interface to protected VMs on
    GICv5
  KVM: arm64: Compute a protected vCPU's fine-grained traps at EL2
  KVM: arm64: Advertise TCR2, SCTLR2, S1PIE and S1POE to protected VMs
  KVM: arm64: Advertise MOPS to protected VMs
  KVM: arm64: Advertise FPMR to protected VMs
  KVM: arm64: Advertise HBC, CLRBHB, RPRFM, CSSC and LUT to protected
    VMs
  KVM: arm64: Advertise FAMINMAX, LSFE, LSUI and FPRCVT to protected VMs
  KVM: arm64: Advertise AFP and RPRES to protected VMs
  KVM: arm64: Advertise ECBHB, TIDCP1, TTST and LVA to protected VMs
  KVM: arm64: Advertise FP8 and F16MM to protected VMs
  KVM: arm64: Advertise ECV, HAFT and ETS3 to protected VMs

 Documentation/virt/kvm/arm/pkvm.rst     |  13 +-
 arch/arm64/include/asm/kvm_host.h       |   2 +-
 arch/arm64/include/asm/kvm_hyp.h        |   6 +
 arch/arm64/include/asm/kvm_pkvm.h       |  12 +-
 arch/arm64/kvm/arm.c                    |  11 +
 arch/arm64/kvm/config.c                 |  24 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |   2 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h  |   1 +
 arch/arm64/kvm/hyp/nvhe/Makefile        |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |   6 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  51 ++--
 arch/arm64/kvm/hyp/nvhe/switch.c        |   1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c      | 350 ++++++++++++++++++++++--
 arch/arm64/kvm/reset.c                  |   2 +
 arch/arm64/kvm/sys_regs.c               |  17 +-
 15 files changed, 423 insertions(+), 79 deletions(-)


base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.47.3

