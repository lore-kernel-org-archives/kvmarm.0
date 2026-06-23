Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6CE438886F
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 14:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782224734; cv=none; b=mptBy0hnpUEyd1A9TTCfqXkQOiSbwVCtdU+pCaYPkTf2ft4GU5NO5E7xjwAiVcVALKJaoH/2pgqQ+k36hot2a9AXh92T4bbrv0EsRk7RiEcZxh33e1A3t1mpXnx4HBOkcoZfn+eM58YRII3CP/qIBiO1VfAspEXGoGZ8sQSFLY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782224734; c=relaxed/simple;
	bh=8l579QzwifHqIylgwlzSwwRSPuALvfSk4I4hKWN5ClY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMm0lzgVs1B1ek8oBvhqFTJnuVmNepoDBrjvWzJX0CUrpTikm4E6hV+4rEo+sX9ZNB5+hd/dy6gFNmAAlayxMQxPNreUMZAC6UkYtINlzcykJLJzt5QZH/dWX+vQhxVUkJHWIdDorpd7Wgm0ZWvMdbxKU8PiCNLA5nt3aVYhJVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RrYOia/E; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RrYOia/E"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FC7E244C;
	Tue, 23 Jun 2026 07:25:26 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B3603F632;
	Tue, 23 Jun 2026 07:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782224731; bh=8l579QzwifHqIylgwlzSwwRSPuALvfSk4I4hKWN5ClY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrYOia/Eyt+n2Yawt4WsHI1PoYwuLZnwyyNCz6lkO8yyo5MLIGyXTTZoz6JpyTrDw
	 mI9BBDm8cbwtNTmIgyaHD1cPx6UYDdrrkrXvWW7ZSUH9TFkrxfbtlpFxBmCc8Y2e7k
	 DDT+rLstWSHB9IHuHWtqXi3hJ2mLXoFJJzBzwATE=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 1/3] KVM: arm64: nv: Print nested mmu info in kvm_ptdump_guest_show()
Date: Tue, 23 Jun 2026 15:24:41 +0100
Message-ID: <20260623142443.648972-2-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623142443.648972-1-weilin.chang@arm.com>
References: <20260623142443.648972-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prepare for creating per nested mmu ptdump file, extend
kvm_ptdump_guest_show() so that it differentiates canonical and nested
mmus. If the mmu is nested and valid, print VTCR, VTTBR, s2 enabled
information in addition to the ptdump.

Also switch to a lock guard for mmu_lock.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/ptdump.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index c9140e22abcf..2a6afe67646a 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -155,9 +155,16 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
 		.seq		= m,
 	};
 
-	write_lock(&kvm->mmu_lock);
+	guard(write_lock)(&kvm->mmu_lock);
+	if (kvm_is_nested_s2_mmu(kvm, mmu)) {
+		if (!kvm_s2_mmu_valid(mmu)) {
+			seq_puts(m, "invalid nested mmu\n");
+			return 0;
+		}
+		seq_printf(m, "0x%016llx 0x%016llx %d\n", mmu->tlb_vttbr,
+			   mmu->tlb_vtcr, mmu->nested_stage2_enabled ? 1 : 0);
+	}
 	ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
-	write_unlock(&kvm->mmu_lock);
 
 	return ret;
 }
-- 
2.43.0

