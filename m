Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1267376A06
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 17:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653688; cv=none; b=sYqUiumC7NHYpelF15pyChjZgFNIcMtmDFRswAGn2L2dBr/tPgp9Cfawa2xrN1bcHADVjWuII+/pvSdo59BdKq46C9ZfimF9ulaiboHyqIFHvL2yzS5KBJvNja50wkVzPZhRS0BzQ/ks9H6JfgUHy094f7RR9NdyvrOIK82WEvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653688; c=relaxed/simple;
	bh=BSJjw28BHrNdyglSqv0O9vheTUWp+6PdUG7Ubmcelaw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TDlilv7Lsfo8gRWwpJZ115upmrD/K/At9O9o+1tzbu6cR+mO0dp2EUMzdgrNCL36hQ4NIS1dntckPc9g/G1sYJkzOL/eAQhfEi+POuRvJRRHc6snPWNFZrK/tU2kUDF5/BUo0XyiWQLJQleb+bVzaYrEZrmvXfMAsfXFj5SDlXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b1RMtAfb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b1RMtAfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574B61F00A3A;
	Tue, 21 Jul 2026 17:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784653686;
	bh=H7XWeEuCN6rH5IyC1gkDtve0NaKkni2h3YomSvKG9wQ=;
	h=From:To:Cc:Subject:Date;
	b=b1RMtAfbk8W+IThhGs+jkNBSAmMCo1OnaSllxQPwuvHNuEDgxZHloU0v9Pyhmk1HR
	 hS5EzXdRMFXdaymWz3pFlplhpOev71x9nn+gJbt6SV1dINOv5RiybJlTIVfd5n3iqt
	 CxsnyYVsRaYWh4Umq5RDGyiHBIOQ2yx7fkyRZXvJOcq4ywIawyUU/CQTpr0aih3//2
	 f5SNjlXy2JK3oXEc46woHRK8p+gyEOpiZBTpQ2CH5N703/dP73p4GaHCOzvDyY46Nn
	 O4MNrIqN+trfHFMtXmxqZOcviPmeaSMYVmN7MLKUlPaA3d8PxIIXnzcIWHnYnHQH/X
	 zcWvfLypdJMmA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmDwq-00000007J9p-0mu5;
	Tue, 21 Jul 2026 17:08:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 0/6] KVM: arm64: Make ICH_VTR_EL2 accesses an inlined literal
Date: Tue, 21 Jul 2026 18:07:48 +0100
Message-ID: <20260721170754.3150521-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

I'm reposting this early as there were so many issues to the original
posting that I decided to deviate from my own rules... Bite me.

This is the second version of this series I initially sent as [1],
which aims at removing the large number of traps that ICH_VTR_EL2
generates in NV environments, leading to pointless overheads.

By moving from a sysreg access to a patched constant, running an L3
workload with a a healthy amount of IO results in a 5% reduction of
wall-clock time from a baseline without this series.

* From v1 [1]:

  - Move the "broken SEIS" detection to an erratum, something it
    should always have been, so that vgic_broken_seis() doesn't have
    to use non-noinstr function calls (sashiko)

  - Drop WARN_ON() in the patch function (sashiko)

  - Switch from this_cpu_has_cap() to cpus_have_cap() (shashiko)

  - Reorganise the patches so that some of the code movements are less
    surprising to our favourite Artificial Idiot

  - Simplify __vgic_v3_get_config() to only return the MMIO attribute
    as a boolean, dropping all form of GICv5 support which made little
    sense

[1] https://lore.kernel.org/r/20260720132220.2143486-1-maz@kernel.org

Marc Zyngier (6):
  KVM: arm64: vgic-v3: Make vtr_to_* helpers use architectural field
    symbols
  KVM: arm64: Move GICv3 broken SEIS implementation detection to a CPU
    errrata
  KVM: arm64: Add a helper providing an inlined literal value for
    ICH_VTR_EL2
  KVM: arm64: Convert most ICH_VTR_EL2 accesses to inlined literal value
  KVM: arm64: vgic-v3: Simplify initial GICv3 configuration sampling
  KVM: arm64: vgic-v3: Kill kvm_vgic_global_state.ich_vtr_el2

 arch/arm64/include/asm/kvm_asm.h |  2 +-
 arch/arm64/kernel/cpu_errata.c   | 17 +++++-
 arch/arm64/kernel/image-vars.h   |  1 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c  | 43 +++++----------
 arch/arm64/kvm/nested.c          |  3 +-
 arch/arm64/kvm/vgic-sys-reg-v3.c |  8 +--
 arch/arm64/kvm/vgic/vgic-v3.c    | 93 +++++++++++++++++++++-----------
 arch/arm64/kvm/vgic/vgic-v5.c    |  5 +-
 arch/arm64/kvm/vgic/vgic.h       | 19 ++++++-
 arch/arm64/tools/cpucaps         |  1 +
 include/kvm/arm_vgic.h           |  2 -
 11 files changed, 118 insertions(+), 76 deletions(-)

-- 
2.47.3

