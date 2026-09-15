Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78DC448D88E
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 15:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789487006; cv=none; b=FpcggpjmdYAt3BoZoCKgrVLNZtjiRA9finO5x2OJMEeO5esFrwxndlo4aSX+uYg0Jy7tJ5hxvrPxY+2TwvXpIo+oEpnYanMhVjErLOfZajUL/fAiwRSvhUV5Qp/cG5XSlCe0R1KKXRd4IRCbOoNSLkQDJJQwrYiymeeBMH/+9HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789487006; c=relaxed/simple;
	bh=dGCyRyad+R3eTVvMaV3UbHKKwBABsVheRnTDSo9R3QI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AcUooiHHjWDFCdGNT1JOZ8gVNHYCBGmziKUs535pER8jxKbNA1NInKoByquL/irkIutjrhP1DcV3WzQ+xs+bcfWm2O6WLjb5UhluFxH6bxW4i5O5c35c6K1zRUgJYg0H/nSGGIY0Wx9UAreCos+0HVNq1oZsNfGcq4uEZq7kJ7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=crRRscH3; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="crRRscH3"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23BDA1570;
	Tue, 15 Sep 2026 08:43:19 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 235873F882;
	Tue, 15 Sep 2026 08:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789487002; bh=dGCyRyad+R3eTVvMaV3UbHKKwBABsVheRnTDSo9R3QI=;
	h=From:To:Cc:Subject:Date:From;
	b=crRRscH3OrO9Zfmax7p89GH6tKP3LypEq486sailvOhs1x+pILaPsAFgFoEhZt/3z
	 RSBFwRy/1/4FbN0cUHwn4EvBnFTJz0NNAryNGTEo+zmtf7t3yTdELLaK0RDF8XG3jt
	 bVZN6VKKjSvpdnX+tdrJSVjZpcxoaVQ2+Ej9uwSQ=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wang Han <wanghan@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v6 0/7] KVM: arm64: nv: Implement nested stage-2 reverse map
Date: Tue, 15 Sep 2026 16:42:58 +0100
Message-ID: <20260915154305.3852871-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is v6 of optimizing the shadow s2 mmu unmapping during MMU
notifiers.

This version fixes a few issues, and adds Marc's space optimization
for kvm_guest_s2_mapping [1]. Please see the changelog for the details.

Tested by booting L3, and running in-kernel targetted tests described
in [2]. v5 got some tested-by's from Itaru and Wang (thanks), I didn't
carry them over since some bugs fixed in v6 are non-obvious. Some
retest would be much appreciated!

Series based on v7.3-rc3 + Marc's nested mmu lifecycle fixes [3].

* Changes from v5 [4]:

  - Align the addresses down to the mapping size when recording the
    guest s2 mappings. s2fd->fault_ipa isn't necessarily PAGE_SIZE aligned.

  - Record guest s2 mappings even when page table maps return -EAGAIN.
    kvm_pgtable_stage2_map() can create mappings while returning -EAGAIN.
    For example, a 2M block map (A) could race with a 4K page map (B):
    1. (A) maps the 2M block in kvm_pgtable_visitor_cb()
    2. (B) breaks that block into a table and maps 4K
    3. (A) reloads and finds the table after kvm_pgtable_visitor_cb(),
       then descends into it.
    4. (A) maps some 4K, but before it finishes reads entry mapped by (B).
    5. (A) returns -EAGAIN although it had mapped a few pages.
    In this case, we don't know what subrange is mapped, just track the whole
    requested mapping range.

  - Don't remove tracked mappings from the interval trees if they only
    partially overlap the removal range. Because of the previous bullet point
    we can have a 4K shadow mapping tracked as a 2M range in the interval
    trees. It would be wrong to remove the 2M range when a guest TLBI doesn't
    touch the 4K mapped.

  - Check mmu->pgt during mmu unmap notifier, as it could race against
    MMU teardown.

  - Make guest_s2_tracking_destroy() canonical mmu only. We simply don't
    need to detach the nodes from the nested mmus' trees. Freeing them
    during canonical mmu's teardown is enough.

Thanks!

[1]: https://lore.kernel.org/kvmarm/86h5jv7qrd.wl-maz@kernel.org/
[2]: https://lore.kernel.org/kvmarm/gerjpm62a2gszzggc6vuai22bf3prfquvfsp7ueumps7vz2ev3@odlmovaklg2b/
[3]: https://lore.kernel.org/kvmarm/20260911162203.1919330-1-maz@kernel.org/
[4]: https://lore.kernel.org/kvmarm/20260810205038.118843-1-weilin.chang@arm.com/

Marc Zyngier (1):
  KVM: arm64: nv: Drop kvm_s2_mmu pointer from kvm_guest_s2_mapping

Wei-Lin Chang (6):
  KVM: arm64: Use a variable for the canonical IPA in kvm_s2_fault_map()
  KVM: arm64: nv: Introduce guest stage-2 tracking structures
  KVM: arm64: nv: Track guest stage-2 mapping creation
  KVM: arm64: nv: Track guest stage-2 mapping removal
  KVM: arm64: nv: Avoid full shadow stage-2 unmap
  KVM: arm64: Refactor kvm_unmap_gfn_range() with common variables

 arch/arm64/include/asm/kvm_host.h   |  31 +++++-
 arch/arm64/include/asm/kvm_nested.h |   7 ++
 arch/arm64/kvm/mmu.c                | 109 +++++++++++++++++++---
 arch/arm64/kvm/nested.c             | 140 +++++++++++++++++++++++++++-
 4 files changed, 269 insertions(+), 18 deletions(-)

-- 
2.43.0

