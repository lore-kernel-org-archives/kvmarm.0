Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F9114F9FB;
	Sun, 22 Feb 2026 14:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771769407; cv=none; b=WJ4AbwwTavlI53cgVTVI+fUg+3w++p0Rka4ZMpa3Q06UwlKpb0pmzyUsxA0G72fiNOKUA0XS9BHuCldCI63rNWMP+/o4T74qe7cz4dpRko5Oek5e9UP6eqJxg972i8FSxbO83vbZ8uSeiRMCvR01BnSydmUXcRtx+r/thyJKYb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771769407; c=relaxed/simple;
	bh=GzGBdumzFByqwyBN2Z2Udld9QqwV3INwp0JJWAxH/Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q3Ml0Yt/EiBporiaIvz7kgw99+RFrMBAavWTrtuof+lMR+idvHnYrlGJJhhwVHEOW6hyJaJM04CuOGxQWZ+d3MwCXGxRoFvY9BUhmNqftUVDjoGIKUX524gske7IvUg8KiyWZkz4QVb+zRvuTR1wjZA16IuOJ4S+5zMUrxJq68c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cWooMs2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cWooMs2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94F2C116D0;
	Sun, 22 Feb 2026 14:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771769406;
	bh=GzGBdumzFByqwyBN2Z2Udld9QqwV3INwp0JJWAxH/Tg=;
	h=From:To:Cc:Subject:Date:From;
	b=cWooMs2NiwU5gR6QCG+4GrymmX9RweYEt6BspOKQQC5RXmiice7ZQyj1ZGNBFZrpi
	 mJvPfILRDAZHdGQxEli2QzPfO8G2Ze9kvWkMbOpzRLzMLRCJL7f7/y7rvFQKqbU827
	 kEiAA6RgRVTAbJ1fDssSg0dmFbgvCacuua1m6MziU30eKXkzgTnJFkQNRysWIMPYiE
	 2ORx+XP30qFHwwIlbH0kX334539xDAYXh/y7JxwyG+Oy/OksEeaHrck8aO00RRKpx4
	 378mVmCWd1zn+I3ApCYTUW4W/L0g4wntaekz2/Bwxt360L32Xypy9c2HpuI3z8EYhk
	 9HqWSvZwaKa7w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vuA9s-0000000CmBl-1WA5;
	Sun, 22 Feb 2026 14:10:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Fix protected mode handling of pages larger than 4kB
Date: Sun, 22 Feb 2026 14:10:00 +0000
Message-ID: <20260222141000.3084258-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, qperret@google.com, will@kernel.org, tabba@google.com, vdonnefort@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since 3669ddd8fa8b5 ("KVM: arm64: Add a range to pkvm_mappings"),
pKVM tracks the memory that has been mapped into a guest in a
side data structure. Crucially, it uses it to find out whether
a page has already been mapped, and therefore refuses to map it
twice. So far, so good.

However, this very patch completely breaks non-4kB page support,
with guests being unable to boot. The most obvious symptom is that
we take the same fault repeatedly, and not making forward progress.
A quick investigation shows that this is because of the above
rejection code.

As it turns out, there are multiple issues at play:

- while the HPFAR_EL2 register gives you the faulting IPA minus
  the bottom 12 bits, it will still give you the extra bits that
  are part of the page offset for anything larger than 4kB,
  even for a level-3 mapping

- pkvm_kvm_pgtable_stage2_map() assumes that the address passed
  as a parameter is aligned to the size of the intended mapping

- the faulting address is only aligned for a non-page mapping

When the planets are suitably aligned (pun intended), the guest
faults a page by accessing it past the bottom 4kB, and extra bits
get set in the HPFAR_EL2 register. If this results in a page mapping
(which is likely with large granule sizes), nothing aligns it further
down, and pkvm_mapping_iter_first() finds an intersection that
doesn't really exist. We assume this is a spurious fault and return
-EAGAIN. And again.

This doesn't hit outside of the protected code, as the page table
code always aligns the IPA down to a page boundary, hiding the issue
for everyone else.

Fix it by always forcing the alignment on vma_pagesize, irrespective
of the value of vma_pagesize.

Fixes: 3669ddd8fa8b5 ("KVM: arm64: Add a range to pkvm_mappings")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/mmu.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8c5d259810b2f..aa587f2e28264 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1753,14 +1753,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	/*
-	 * Both the canonical IPA and fault IPA must be hugepage-aligned to
-	 * ensure we find the right PFN and lay down the mapping in the right
-	 * place.
+	 * Both the canonical IPA and fault IPA must be aligned to the
+	 * mapping size to ensure we find the right PFN and lay down the
+	 * mapping in the right place.
 	 */
-	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE) {
-		fault_ipa &= ~(vma_pagesize - 1);
-		ipa &= ~(vma_pagesize - 1);
-	}
+	fault_ipa &= ~(vma_pagesize - 1);
+	ipa &= ~(vma_pagesize - 1);
 
 	gfn = ipa >> PAGE_SHIFT;
 	mte_allowed = kvm_vma_mte_allowed(vma);
-- 
2.47.3

