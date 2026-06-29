Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19F233B2FD4;
	Mon, 29 Jun 2026 11:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782731913; cv=none; b=Oi1oybgmn4STFlSYmJteuF1L8X1FLfgFDN6QNwHCSXlzxUmUAvvLK/v2qFf7cD5I4M3dQjICi8RCBvLm5FfJuUyDN/DlliNT3R56NbTGU3ywT/Wi1t33NhoxGZn6FeK42ammnPoMHtZGF9oRSF7O3LdqwoQcdAd3hBhgiaZHAWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782731913; c=relaxed/simple;
	bh=bjTI/f/n56/Fet0evzkJ68kz+ryPn+5y70fPRs2V5wA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AM/AAtqKA78V9aK5dXQ97J2cIyaPFfOCqRP5G/AiuZk1SxDmNJBLvN08tTLBYcTwH7UjuINxwu6ohVmlwAN0G/p91CD0X0YK5PdUBmBC87vMrdbl93vXl6LS+KYC9e8HVK1u5wv8eSbtoZxIBLDmM1kCSDSLe2NR9JMat4zwrkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vcpBNJcT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vcpBNJcT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09E361655;
	Mon, 29 Jun 2026 04:18:26 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0DB273F905;
	Mon, 29 Jun 2026 04:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782731910; bh=bjTI/f/n56/Fet0evzkJ68kz+ryPn+5y70fPRs2V5wA=;
	h=From:To:Cc:Subject:Date:From;
	b=vcpBNJcTiDlNBeEnJYl9HwTNgevqUpNYYJUku/hZ9+hzbG7dPtCnZ2wDCHh9KoK7v
	 1BypgwHAtmUBqeHsQHb4KvwMQvJc7Nj1GLhfugu/17jMXIefZeB0rUd3WVAkXRiOyy
	 2xCBmvCFbvbjurkFasOoaZgJd5peEg+bpdWIZRCA=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>,
	James Morse <james.morse@arm.com>,
	Zeng Heng <zengheng4@huawei.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v2 00/13] KVM Dirty-bit cleaning hw accelerator (HACDBS)
Date: Mon, 29 Jun 2026 12:17:48 +0100
Message-ID: <20260629111820.1873540-1-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5680; i=leo.bras@arm.com; h=from:subject; bh=Jp5vKmq1QYgozZwl/v/dth/msI72XuhmrAqKkgXOajg=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLKcQuI5FsypOnXm/syrR2/fmb7t2Mu6fRJNlrtk5vQZF IcyXJ+5vaOUhUGMi0FWTJFF9tH8VTzfp2QcufJjAcwcViaQIQxcnAIwkYomRoYl1fV3CnN/Tl7L tOHa7NxmZ9ubS9gEXK5c0v+w7m82068fjAwnl9bqvFz6bdk57rtZ7NEXduzlPF8i8Zrh5/97Fb7 bTQ4xAgA=
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit


Disclaimer: While this patchset is buildable and testable on it's own,
it is not ready to be merged, as it depends on bits from another
patchset that will superseed the one in [0], and will enable HDBSS.
See note below on patches 1,2.

My expectation on sharing this earlier is to gather feedback on
implementation and testing methods, to make sure it's sure it's ready
when [0] becomes ready.

===

Create an arch-generic dirty-bit cleaning acceleration interface, which
compiles-out if the arch does not implement it, and creates no new API.
Using that, implement an arm64 accelerator based on HACDBS.

This implementation is able to accelerate the cleaning on both
dirty-bitmap and dirty-ring tracking mechanisms on KVM.

Patch 1 & 2 are here just to make this testable, as this patchset
depends on bits from HDBSS that are not upstream yet.

Patch 2 should be included in the HDBSS patchset, and patch 1
is a bunch of bits that I collected across other patches so this can
work. So few free to ignore them on review, as they should be reviewed
in the HDBSS patchset.

To be able to properly use HACDBS, it requires a PPI IRQ that triggers
either on error, or when processing is complete. It's called
HACDBSIRQ, and there is currently no upstream way of announcing it on
ACPI tables, so this patchset uses the suggested table/index in [1],
which at the moment is not merged.

Kernel v7.2-rc1 + this patchset builds properly, passing both kvm selftests
for dirty-bit tracking[2] and a qemu live migration test, with both
HW HACDBS enabled or disabled.

On terms of performance improvement, tests were done using
dirty_log_perf_test[3] to measure the time spent on the following ioctl:
a - KVM_GET_DIRTY_LOG,     using dirty-bitmap without manual protect
    command:    ./dirty_log_perf_test -m 3 -m 6 -m 12 -g
b - KVM_CLEAR_DIRTY_LOG,   using dirty-bitmap with manual protect
    command:    ./dirty_log_perf_test -m 3 -m 6 -m 12
c - KVM_RESET_DIRTY_RINGS, using dirty-ring, using 4096 entries/vcpu.
    command:    ./dirty_log_perf_test -m 3 -m 6 -m 12 -d 4096

Tests ran in the model show that runtime was reduced by:
-(a) 82.19% (0.16% stdev) for 1GB memory, and
     82.45% (0.02% stdev) for 3GB memory
-(b) 81.74% (0.19% stdev) for 1GB memory, and
     82.40% (0.38% stdev) for 3GB memory
-(b) 70.90% (0.18% stdev) for 1GB memory, and
     70.92% (0.01% stdev) for 3GB memory

Above numbers already take into account the improvements in S2
hugepage-splitting that is implemented by [4].

Please let me know of any question :)

Thanks for reviewing!
Leo


Changes since v1:
- Improvements on splitting with manual protect, skipping when cleaning
  pages from the same level-2 entry. (new patch)
- Got the correct concept of chunk_size and thus:
  - Corrected it to a reasonable chunk to do page splitting before
    rescheduling, considering new improvements from [4].
  - TTWL is not based in chunk size, so fix it in LAST_LEVEL
- Minor fixes, removing debugging traces
v1 Link: https://lore.kernel.org/all/20260430111424.3479613-2-leo.bras@arm.com/


[0]: https://lore.kernel.org/all/20260225040421.2683931-1-zhengtian10@huawei.com/
[1]: https://github.com/tianocore/edk2/issues/12409
[2]: dirty_log_test && dirty_log_perf_test
[3]: using this patchset to enable dirty-ring on dirty_log_perf_test:
     https://lore.kernel.org/all/20260629105950.1790259-1-leo.bras@arm.com/
[4]: https://lore.kernel.org/all/20260618131447.764085-1-leo.bras@arm.com/

Leonardo Bras (13):
  KVM: arm64: HDBSS bits
  KVM: arm64: Enable eager hugepage splitting if HDBSS is available
  arm64/cpufeature: Add system-wide FEAT_HACDBS detection
  arm64/sysreg: Add HACDBS consumer and base registers
  KVM: arm64: Detect (via ACPI) and initialize HACDBSIRQ
  KVM: arm64: dirty_bit: Add base FEAT_HACDBS cleaning routine
  kvm: Add arch-generic interface for hw-accelerated dirty-bitmap
    cleaning
  KVM: arm64: Add hardware-accelerated dirty-bitmap cleaning routine
  KVM: arm64: Dirty-bitmap: avoid splitting previously split blocks
  kvm/dirty_ring: Introduce get_memslot and move helpers to header
  kvm/dirty_ring: Add arch-generic interface for hw-accelerated
    dirty-ring cleaning
  KVM: arm64: Add hardware-accelerated dirty-ring cleaning routine
  KVM: arm64: Enable KVM_HW_DIRTY_BIT

 arch/arm64/include/asm/acpi.h          |   3 +
 arch/arm64/include/asm/cpufeature.h    |  10 +
 arch/arm64/include/asm/kvm_dirty_bit.h |  67 ++++
 arch/arm64/include/asm/kvm_pgtable.h   |   3 +
 include/acpi/actbl2.h                  |   1 +
 include/linux/kvm_dirty_bit.h          |  34 ++
 include/linux/kvm_dirty_ring.h         |  12 +
 include/linux/kvm_host.h               |   3 +
 arch/arm64/kernel/cpufeature.c         |  20 ++
 arch/arm64/kvm/arm.c                   |   5 +
 arch/arm64/kvm/dirty_bit.c             | 411 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c           |  15 +-
 arch/arm64/kvm/mmu.c                   |  12 +-
 virt/kvm/dirty_ring.c                  |  34 +-
 virt/kvm/kvm_main.c                    |  13 +-
 arch/arm64/kvm/Kconfig                 |   1 +
 arch/arm64/kvm/Makefile                |   2 +-
 arch/arm64/tools/cpucaps               |   2 +
 arch/arm64/tools/sysreg                |  30 ++
 virt/kvm/Kconfig                       |   3 +
 20 files changed, 659 insertions(+), 22 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_dirty_bit.h
 create mode 100644 include/linux/kvm_dirty_bit.h
 create mode 100644 arch/arm64/kvm/dirty_bit.c


base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
2.54.0

