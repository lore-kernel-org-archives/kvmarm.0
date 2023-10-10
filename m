Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0B99473
	for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 10:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51FED1FB;
	Tue, 10 Oct 2023 03:42:11 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1DFA53F762;
	Tue, 10 Oct 2023 03:41:28 -0700 (PDT)
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
Subject: [PATCH v2 0/3] arm64: perf: Add support for event counting threshold
Date: Tue, 10 Oct 2023 11:40:26 +0100
Message-Id: <20231010104048.1923484-1-james.clark@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

The change has been validated on the Arm FVP model:

  # Zero values, works as expected (as before).
  $ perf stat -e dtlb_walk/threshold=0,threshold_control=0/ -- true

    5962      dtlb_walk/threshold=0,threshold_control=0/

  # Threshold >= 255 causes count to be 0 because dtlb_walk doesn't
  # increase by more than 1 per cycle.
  $ perf stat -e dtlb_walk/threshold=255,threshold_control=5/ -- true

    0      dtlb_walk/threshold=255,threshold_control=5/
  
  # Keeping comparison as >= but lowering the threshold to 1 makes the
  # count return.
  $ perf stat -e dtlb_walk/threshold=1,threshold_control=5/ -- true

    6329      dtlb_walk/threshold=1,threshold_control=5/


James Clark (3):
  arm: perf: Include threshold control fields valid in PMEVTYPER mask
  arm64: perf: Add support for event counting threshold
  Documentation: arm64: Document the PMU event counting threshold
    feature

 Documentation/arch/arm64/perf.rst  | 58 ++++++++++++++++++++++++++
 arch/arm/include/asm/arm_pmuv3.h   |  3 ++
 arch/arm64/include/asm/arm_pmuv3.h |  4 ++
 arch/arm64/kvm/pmu-emul.c          |  1 +
 arch/arm64/kvm/sys_regs.c          |  1 +
 drivers/perf/arm_pmuv3.c           | 67 +++++++++++++++++++++++++++++-
 include/linux/perf/arm_pmuv3.h     |  4 +-
 7 files changed, 136 insertions(+), 2 deletions(-)


base-commit: 94f6f0550c625fab1f373bb86a6669b45e9748b3
-- 
2.34.1

