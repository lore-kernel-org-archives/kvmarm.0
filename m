Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A9E385D9E
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 12:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782821485; cv=none; b=U4s8JeN8pDVTiULTTp3rq1RNYeqRpQT2aVsjKeP/NlRhRyNpE+wTGzPodokCdAy+xpO1A3+TBiQx7jHuTT3g37aesSHC+9OhU7Xrdp2HGOMD+rWPZSzt+qmjiYAIC0flW5KjKLLAiHPgiybSIaBJX0mPjy2pqHDP1ZVrZoO+zvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782821485; c=relaxed/simple;
	bh=fKXhVZd2KbcgtEAsulIof9g1rmwAW3Kz/yvYpw76Jns=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DJyqrbSDjfXudGu8chk2XOn4QiCyx5EXjt68ovJhquHzAFVLTmLzAW+CAtnTJ3zsRKfQiDfSqQovIGdjfIYAwI8vyOXMC9RSUk4fQ1fc76d+Dlr8OdJ44I4kY/prjTsXnPjkrbJURMDMpkOfK0DBWyC4OhVNGRKtE6uXQzwkevM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XmdA4OyG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XmdA4OyG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7736E175A;
	Tue, 30 Jun 2026 05:11:18 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B9C233F905;
	Tue, 30 Jun 2026 05:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782821482; bh=fKXhVZd2KbcgtEAsulIof9g1rmwAW3Kz/yvYpw76Jns=;
	h=From:To:Cc:Subject:Date:From;
	b=XmdA4OyG03dXigKmUsdRuMpu5OSF8Mmw5WpWNxYworu6arKNkHMlFBlI4BeCOXgXe
	 GJlTe2zyDRow7+ubJbjFBXGZqcdWvxPA7mcm3FSILAcwAsNb6AvD6D+I/twY6iN8Xk
	 qb8h00UcGoMoHQJmNceCIAP4n9mXfCXur4Ljbwh8=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Sebastian Ene <sebastianene@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v2 0/6] KVM: arm64: ptdump: Shadow ptdump fixes
Date: Tue, 30 Jun 2026 13:09:59 +0100
Message-ID: <20260630121005.1130996-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is v2 of fixing shadow ptdump debugfs files. Unfortunately I couldn't make
per mmu ptdump files work after all, mainly because there isn't a clean way to
locate the specific nested mmu for each ptdump file as the nested mmus could be
freed when the file gets opened. Therefore in this series a single file
"shadow_page_tables" is created that dumps all valid mmus' page table
information.

An advantage of this is that this new ptdump file have a lifetime identical to
other ptdump files i.e. stage2_page_tables, ipa_range, etc., hence avoiding the
dentry UAF found last time [1].

With this all ptdump files are only removed when the last kvm reference gets
dropped and kvm_destroy_vm_debugfs() is called, in their open(), show()
functions the nested mmu array and mmu->pgt are checked with mmu_lock held to
prevent UAF.

Patch 1-2: Undo previous shadow ptdump implementation.
Patch 3:   Fix a mmu->pgt UAF that happens when ptdump files are read after
           mmu->pgt is freed.
Patch 4-5: Preparation for the shadow page table dump file.
Patch 6:   Implementation of the shadow page table dump file.

The fixes are tested with CONFIG_PROVE_LOCKING,
CONFIG_DEBUG_ATOMIC_SLEEP, and CONFIG_KASAN.

Thanks!

* Changes from v1 ([2]):

  - Move from per mmu ptdump files to one file that will dump all shadow page
    tables.

[1]: https://lore.kernel.org/kvmarm/ajty6I7ZqodP4ous@sm-arm-grace07/
[2]: https://lore.kernel.org/kvmarm/20260623142443.648972-1-weilin.chang@arm.com/

Wei-Lin Chang (6):
  KVM: arm64: ptdump: Remove shadow ptdump files
  KVM: arm64: ptdump: Undo making the ptdump code mmu aware
  KVM: arm64: ptdump: Fix UAF when mmu->pgt is freed
  KVM: arm64: ptdump: Factor out initialization of
    kvm_ptdump_guest_state
  KVM: arm64: ptdump: Extract kvm_ptdump_guest_open() from canonical
    ptdump path
  KVM: arm64: ptdump: Introduce the shadow ptdump file

 arch/arm64/include/asm/kvm_host.h |   5 +-
 arch/arm64/include/asm/kvm_mmu.h  |   4 -
 arch/arm64/kvm/nested.c           |  18 +--
 arch/arm64/kvm/ptdump.c           | 185 ++++++++++++++++++++----------
 4 files changed, 135 insertions(+), 77 deletions(-)

-- 
2.43.0

