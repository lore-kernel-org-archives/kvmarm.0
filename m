Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C6B41CB5F;
	Wed,  8 Jul 2026 16:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783527199; cv=none; b=CN5sdgE/bKc4Xol6JBLWIdMuU50lEzPX4wI+MZwImYJlN4Zb5JZN2ywNlbP8j3ByGg29PlUAUjJr0c6dNRpIl2ODF8Q10Z+PFpLPaqLOtAHpg2J/9VcS4G3j5/OC+GaM8cHsGwsOywED8+B7Rxkql5y9wMiN9v3vwoVQ5O3Ov1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783527199; c=relaxed/simple;
	bh=9ggp97/tHTaJdHj8n9/QKZROiz9ApVfJN6VLyx5YqKE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XDU6wRbdPZzcqPunRhLPYIAwJ0VzN5P7YmB+6ymJNzMsd30U5i8Cq2lwUz3pQ+i+D1PI2Qy0RQPebINiNzR8PzHwo6Ny6xe8yEVMXldwk11KP0+v/QO+mnYFTRU6INZcr44vYtAGWOcqNT1IdTYNhCk7sQtJs6zyxAvci44zrmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QuQ5rORC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QuQ5rORC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE901F000E9;
	Wed,  8 Jul 2026 16:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783527197;
	bh=yfr5Zf8QzEAmiPLqkiJdK20n52r9vrdmIA+s+Q3YgkU=;
	h=From:To:Cc:Subject:Date;
	b=QuQ5rORC2BJ+4iEkH95ElRXMac4sTZeDwlFIMs+c0EAVRrSNbJYdKVLCHsNma0q6G
	 crVKepBLgdIkmXpEXN1JkEoCjaXRu4Uvle7DTy/sB+Ep6l+cW1XCpw9J2sLT5VCFAS
	 CHLaOrUcfWitOSCaBkg67qi8ENFWWLbE0nOrEwZfm3pM/rMdza7glLLhpUwY4I9O4v
	 z/zgtpBgf28mkZt1GvcVa3881rb9e0XjU9iEFHJ+UsPaHiFG8y/iQubf/4pH+GdbeH
	 ElSQmDLINOMKkO6hHkCEh86k6Wgb4gc82Q3E544abnmfapLTrPUgjnEAzrFrL+4OZa
	 R9trNpAQZXiAQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1whUtf-00000002uOx-1Kbd;
	Wed, 08 Jul 2026 16:13:15 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Sebastian Ene <sebastianene@google.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Will Deacon <will@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 7.2, take #2
Date: Wed,  8 Jul 2026 17:12:42 +0100
Message-ID: <20260708161242.1912769-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, fuad.tabba@linux.dev, broonie@kernel.org, smostafa@google.com, oupton@kernel.org, sebastianene@google.com, sudeep.holla@kernel.org, vdonnefort@google.com, weilin.chang@arm.com, will@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's the second drop of KVM/arm64 fixes for 7.2. This time around,
we have a locking issue in kvm_io_bus_get_dev(), which is only used by
arm64, a few S2 page table fixes, a set of FFA proxy fixes for pKVM,
and finally a very esoteric fix for emulation of sign-extended loads
from MMIO. Not only this is rather niche, it dates back to day one of
KVM support for 32bit ARM...

Note that this is on top of the kvmarm-fixes-7.2-1 tag pull request
posted at [1] about 12 days ago.

Please pull,

	M.

[1] https://lore.kernel.org/all/20260626133526.817232-1-maz@kernel.org

The following changes since commit d098bb75d14fde2f12155f1a95ec0168160867ce:

  KVM: arm64: account pKVM reclaim against the VM mm (2026-06-22 10:48:08 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-7.2-2

for you to fetch changes up to 8d187d4b33c262c0f3e44842553521151d8629e8:

  KVM: arm64: Fix propagation of TLBI level in kvm_pgtable_stage2_relax_perms() (2026-07-07 17:43:39 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 7.2, take #2

- Move locking for kvm_io_bus_get_dev() into the caller, ensuring
  race-free checks that the returned object is of the correct type

- Fix initialisation of the page-table walk level when relaxing
  permissions

- Correctly update the XN attribute when relaxing permissions

- Fix the sign extension of loads from emulated MMIO regions

- Assorted collection of fixes for pKVM's FFA proxy, together with a
  couple of FFA driver adjustments

----------------------------------------------------------------
Fuad Tabba (2):
      KVM: arm64: Fix sign-extension of MMIO loads
      KVM: arm64: selftests: Add MMIO sign-extending load test

Marc Zyngier (2):
      KVM: Move kvm_io_bus_get_dev() locking responsibilities to callers
      KVM: arm64: Fix propagation of TLBI level in kvm_pgtable_stage2_relax_perms()

Mostafa Saleh (3):
      KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()
      KVM: arm64: Ensure FFA ranges are page aligned
      firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()

Oliver Upton (2):
      KVM: arm64: Ensure level is always initialized when relaxing perms
      KVM: arm64: Only update XN attr when requested during S2 relaxation

Sebastian Ene (3):
      KVM: arm64: Validate the offset to the mem access descriptor
      KVM: arm64: Zero out the stack initialized data in the FFA handler
      firmware: arm_ffa: Fix Endpoint Memory Access Descriptor offset calculation

 arch/arm64/kvm/hyp/nvhe/ffa.c                     |  44 ++--
 arch/arm64/kvm/hyp/pgtable.c                      |  15 +-
 arch/arm64/kvm/mmio.c                             |   7 +-
 arch/arm64/kvm/vgic/vgic-its.c                    |   2 +
 drivers/firmware/arm_ffa/driver.c                 |  25 ++-
 include/linux/arm_ffa.h                           |   9 +-
 tools/testing/selftests/kvm/Makefile.kvm          |   1 +
 tools/testing/selftests/kvm/arm64/mmio_sign_ext.c | 255 ++++++++++++++++++++++
 virt/kvm/kvm_main.c                               |  16 +-
 9 files changed, 331 insertions(+), 43 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/mmio_sign_ext.c
