Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E82223328
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 08:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767945781; cv=none; b=QnZnhOx+MSURjlZbR13yfkl9p37q7fLFuhuM/73KoLOZJpYU3DVHXcb7xMCpc7T7xO93cev4nkKZA9Y4qLBnBs53ZKKS4yABsyN2knORNPDYFoHOBMXLhc3nkjR2jVOdrfOPVk4QWEKntOmCjsI8L4V5SjQP+/ahhfcLVYE6wHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767945781; c=relaxed/simple;
	bh=9+mjLlGeV6omI+NIjSwWUFWPZdcbxeVeXG2q1Uox3bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qqkUkjMNHR5lkcYW3Jjs85E9AqSOY74L7Iy5UYoRMrZ6V+BZgfnL02+VtvRmHFXOeBX5ew6T6t9zm0mS/Jo7k6DmS6wm9tc9XjsDP5BJ9tNOVE4dHEBxHNg4Ij+BQvfiMiI6+yHHbTEywumE+8jsiiSEuCSpcEfUTF4TxEScmfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=IA2b+j6d; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="IA2b+j6d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Vj
	b+8F5dXms766UBf5RrIFwa6GnmPohIbLDUXuV3xwk=; b=IA2b+j6df2B+FLJ+m7
	ZvphKJsjHUccBDZbG5LK1k+ESAtpp63tsfBxU2T1RCaR4eAZ42B6S48YGMEfAx4s
	oS/LJXR4EZgK2ttX+ogvE2/yrC3qpsRx+/4xR7iBDzymUCrf3U3iuvnRlz+BaPST
	386g0N77FJF6NTKhMMnpArGAc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDXXksVtmBpNHXMEg--.30S2;
	Fri, 09 Jan 2026 16:02:30 +0800 (CST)
From: Dongxu Sun <sundongxu1024@163.com>
To: maz@kernel.org,
	oupton@kernel.org,
	yuzenghui@huawei.com
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	sundongxu1024@163.com
Subject: [PATCH v2] KVM: arm64: Remove unused vcpu_{clear,set}_wfx_traps()
Date: Fri,  9 Jan 2026 16:02:26 +0800
Message-ID: <20260109080226.761107-1-sundongxu1024@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXXksVtmBpNHXMEg--.30S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WrW8XF13Kr1rCF1xAr1DJrb_yoW8Xr1UpF
	sxCwn3W3yrKryUJ34UWwna93yjvwn8K34SqFy7Kr1FgF1qyFy5GrZYkry5AFZ8XFyvvayx
	ZFy7tF1DAw1jy3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRj2NtUUUUU=
X-CM-SenderInfo: xvxqv05qj03iqqsuqiywtou0bp/xtbC0BclsmlgthfNegAA3P

Function vcpu_{clear,set}_wfx_traps() are unused since
commit 0b5afe05377d7 ("KVM: arm64: Add early_param to
control WFx trapping").
Remove it.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Dongxu Sun <sundongxu1024@163.com>
---
v2 -> v1: Update subject and commit message.
v1: https://lore.kernel.org/all/20260109025837.754242-1-sundongxu1024@163.com

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

