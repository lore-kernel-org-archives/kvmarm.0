Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CA8390200;
	Fri, 27 Mar 2026 11:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611389; cv=none; b=NvpbnpfgMD3mShF5qXHS/lu/TXitM4Kuscru3wWyOTpW8ASHb1HBQVeXM8IJjVmwuInO9SDmUmmiGmbTsglL6Pz3rs31eYNXiY8qNoVfNVngABMiAtStYIdHPl7NAgRVo+O308S4xH/U7bRKkw+JoibGbIKVI2q/LoHgHeTDgXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611389; c=relaxed/simple;
	bh=mw/ote3jncKQHaloT0cPobEmS1MkiecE/Mak5sizrCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AaVv3lXoizf+cFLDRGOsc6rhCYTCq40mcFKor9+lHlxYd8UcS1fEGFw0wZYDVdchCdyj/TvN2UBqqngQSM8bNRiB4ops4ixQ9GKkxlpbafNXAmAUtbcD69/Pv/RMc4iv8YJ1mHij4Qmx6wQLX6o/TI3Sm2MfsDwtgKS/wu+cI7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ELMREghp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ELMREghp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DDBC2BCB0;
	Fri, 27 Mar 2026 11:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611389;
	bh=mw/ote3jncKQHaloT0cPobEmS1MkiecE/Mak5sizrCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELMREghpzJwPnjJeWDcju2tK/yLMRR+/4RhMhlBC8wMCRqbr2Kpdy/C8VqQpYbirQ
	 kAftfrq5Njx+dwTJN85kaSmS37Q33aYwJ+Va4nKp1iDkCFOiVA7uiGY7Xe95Zk8RSl
	 0BNLa49DXw+9OGjfMLB4GLQdPTQgusTesTdfnyiozHTZe5A8r7MsQu+VtUWhT5L79y
	 d0a/XJR6RLDvUVPhE6C9kaT7At8hfeHNw2CQFFzPKK+RcwiZzKNdomTrAB9bhX8D7b
	 phKb+W/H7MuqMnGf6+3c6sQrtXKh80VjLU3btGPAGQP38ebt5rFmzriJnzYM/I3C5g
	 Z2mnJn65Ch5Sw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UJ-00000006K4a-0j10;
	Fri, 27 Mar 2026 11:36:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH v2 21/30] KVM: arm64: Kill topup_memcache from kvm_s2_fault
Date: Fri, 27 Mar 2026 11:36:09 +0000
Message-ID: <20260327113618.4051534-22-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327113618.4051534-1-maz@kernel.org>
References: <20260327113618.4051534-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The topup_memcache field can be easily replaced by the equivalent
conditions, and the resulting code is not much worse.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e8bda71e862b2..5b05caecdbd92 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1712,7 +1712,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 
 struct kvm_s2_fault {
 	bool writable;
-	bool topup_memcache;
 	bool mte_allowed;
 	bool is_vma_cacheable;
 	bool s2_force_noncacheable;
@@ -1983,9 +1982,8 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 		.logging_active = logging_active,
 		.force_pte = logging_active,
 		.prot = KVM_PGTABLE_PROT_R,
-		.topup_memcache = !perm_fault || (logging_active && kvm_is_write_fault(s2fd->vcpu)),
 	};
-	void *memcache;
+	void *memcache = NULL;
 	int ret;
 
 	/*
@@ -1994,9 +1992,11 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	 * only exception to this is when dirty logging is enabled at runtime
 	 * and a write fault needs to collapse a block entry into a table.
 	 */
-	ret = prepare_mmu_memcache(s2fd->vcpu, fault.topup_memcache, &memcache);
-	if (ret)
-		return ret;
+	if (!perm_fault || (logging_active && kvm_is_write_fault(s2fd->vcpu))) {
+		ret = prepare_mmu_memcache(s2fd->vcpu, true, &memcache);
+		if (ret)
+			return ret;
+	}
 
 	/*
 	 * Let's check if we will get back a huge page backed by hugetlbfs, or
-- 
2.47.3

