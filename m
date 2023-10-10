Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636E424C7A
	for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 14:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B99E1FB;
	Tue, 10 Oct 2023 07:16:52 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CFC033F762;
	Tue, 10 Oct 2023 07:16:08 -0700 (PDT)
From: James Clark <james.clark@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	suzuki.poulose@arm.com
Cc: James Clark <james.clark@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Russell King <linux@armlinux.org.uk>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Zaid Al-Bassam <zalbassam@google.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Reiji Watanabe <reijiw@google.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v3 0/3] arm64: perf: Add support for event counting threshold
Date: Tue, 10 Oct 2023 15:15:40 +0100
Message-Id: <20231010141551.2262059-1-james.clark@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v2:

  * Split threshold_control attribute into two, threshold_compare and
    threshold_count so that it's easier to use
  * Add some notes to the first commit message and the cover letter
    about the behavior in KVM
  * Update the docs commit with regards to the split attribute
 
Changes since v1:

  * Fix build on aarch32 by disabling FEAT_PMUv3_TH and splitting event
    type mask between the platforms
  * Change armv8pmu_write_evtype() to take unsigned long instead of u64
    so it isn't unnecessarily wide on aarch32
  * Add UL suffix to aarch64 event type mask definition

----

FEAT_PMUv3_TH (Armv8.8) is a new feature that allows conditional
counting of PMU events depending on how much the event increments on
a single cycle. Two new config fields for perf_event_open have been
added, and a PMU cap file for reading the max_threshold. See the second
commit message and the docs in the last commit for more details.

The feature is not currently supported on KVM guests, and PMMIR is set
to read as zero, so it's not advertised as available. But it can be
added at a later time. Writes to PMEVTYPER.TC and TH from guests are
ignored.

The change has been validated on the Arm FVP model:

  # Zero values, works as expected (as before).
  $ perf stat -e dtlb_walk/threshold=0,threshold_compare=0/ -- true

    5962      dtlb_walk/threshold=0,threshold_compare=0/

  # Threshold >= 255 causes count to be 0 because dtlb_walk doesn't
  # increase by more than 1 per cycle.
  $ perf stat -e dtlb_walk/threshold=255,threshold_compare=2/ -- true

    0      dtlb_walk/threshold=255,threshold_compare=2/
  
  # Keeping comparison as >= but lowering the threshold to 1 makes the
  # count return.
  $ perf stat -e dtlb_walk/threshold=1,threshold_compare=2/ -- true

    6329      dtlb_walk/threshold=1,threshold_compare=2/

James Clark (3):
  arm: perf: Include threshold control fields valid in PMEVTYPER mask
  arm64: perf: Add support for event counting threshold
  Documentation: arm64: Document the PMU event counting threshold
    feature

 Documentation/arch/arm64/perf.rst  | 56 +++++++++++++++++++++
 arch/arm/include/asm/arm_pmuv3.h   |  3 ++
 arch/arm64/include/asm/arm_pmuv3.h |  4 ++
 arch/arm64/kvm/pmu-emul.c          |  1 +
 arch/arm64/kvm/sys_regs.c          |  1 +
 drivers/perf/arm_pmuv3.c           | 79 +++++++++++++++++++++++++++++-
 include/linux/perf/arm_pmuv3.h     |  4 +-
 7 files changed, 146 insertions(+), 2 deletions(-)


base-commit: 94f6f0550c625fab1f373bb86a6669b45e9748b3
-- 
2.34.1

