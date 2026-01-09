Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033C220C461
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 02:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767927554; cv=none; b=FEUjeGy/NkiA7rqp7m6aTrTKxRftM1SvuWCBJsY2VO6COS1UAblIYHcyKf697jnBg3RYGgu0cS5S9Uk8iLFH67Lb+BH6E7HN12LqiVv7eGNtWDSsFKcoq64vJzExDjmpyl1nc97f1SINumTiN+tlQ1jKTlhPHPpyV6cdrLub4Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767927554; c=relaxed/simple;
	bh=PXu+8ulWfCO+LM8h9TKMT3vH6hJ5APK9iOWLR6PoVgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b7Vdo/PdthWAbYd749IHSShiFCzzbkNRLwHb0dmi54/rukH3Rtrbigg2Kku4qSWJlAXfiVG6stcFuXfvJPn63C/MF035Qju0rdbDB2yNfpdhm66xU5OH+S5HPUqQ7S74QTgtI8EFtHHaFv8zkjqvHAYQke5nCRCmHBF/yBsPqHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=iCnBIoqh; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="iCnBIoqh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=lo
	gLArlX7d3QTVIZ0ZdE29pdLadPZUhVFSbuJlr2Y/s=; b=iCnBIoqhcnhRa/rtDw
	TyKk2twWVarzdlxiQnfd54idZ+Hoxnom67WjqzzcM9+2NGGNUcgzu5DCm06t2A3Q
	ew848I2ccSgBavI3aOz6wI8VivgGS0qiDZ1blerLq2siq7IXVsaEUxjcUE7ZvjXH
	mv8V5M62tx6n7lwPsW3HgL4KU=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDXrunfbmBpFNwMKw--.28S2;
	Fri, 09 Jan 2026 10:58:42 +0800 (CST)
From: Dongxu Sun <sundongxu1024@163.com>
To: maz@kernel.org,
	oupton@kernel.org
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	sundongxu1024@163.com
Subject: [PATCH] KVM: arm64: remove unused vcpu_{clear,set}_wfx_traps()
Date: Fri,  9 Jan 2026 10:58:37 +0800
Message-ID: <20260109025837.754242-1-sundongxu1024@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgDXrunfbmBpFNwMKw--.28S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Xry7Kw48WrW5CryDJF43Wrg_yoW8JF1rpF
	n3uwn3W3yrGryUJ34UWrnI93yYv3s8K34SqFy7Kr1FgF1qyFy5JrZYkry5AFZ8XFyvvayx
	ZFy7tF1DAw4UAFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRFoGdUUUUU=
X-CM-SenderInfo: xvxqv05qj03iqqsuqiywtou0bp/xtbC8QJG02lgbuKQMQAA3C

Function vcpu_{clear,set}_wfx_traps() are unused since
commit 0b5afe05377d7 ("KVM: arm64: Add early_param to control WFx trapping")
Remove it.

Signed-off-by: Dongxu Sun <sundongxu1024@163.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index c9eab316398e..55d34192a8de 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -119,22 +119,6 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
 	return (unsigned long *)&vcpu->arch.hcr_el2;
 }
 
-static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.hcr_el2 &= ~HCR_TWE;
-	if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
-	    vcpu->kvm->arch.vgic.nassgireq)
-		vcpu->arch.hcr_el2 &= ~HCR_TWI;
-	else
-		vcpu->arch.hcr_el2 |= HCR_TWI;
-}
-
-static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.hcr_el2 |= HCR_TWE;
-	vcpu->arch.hcr_el2 |= HCR_TWI;
-}
-
 static inline unsigned long vcpu_get_vsesr(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.vsesr_el2;
-- 
2.43.0

