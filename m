Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D84317C9B
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 17:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714583230; cv=none; b=KUvnjVS+5JUu6uvmfXhyAXs/XwprA4aBPhFflJjIzt162XOyQ7oSiClSv8UxGlhv3b4Brk3Yd5dUkGGZsctMEIUpELDMyR5IninFXiOKSylyBF0A2zOteRFRM2UDwz1KOq7WLKJKfj5BnPcZaSSD/lrWRnm35iXUxqE8ZMWJz6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714583230; c=relaxed/simple;
	bh=9XDHQSTzNL7F1T24qR+e/rqisRboUGTN0vS//tQrnFg=;
	h=From:To:Cc:Subject:MIME-Version:Content-Disposition:Content-Type:
	 Message-Id:Date; b=qkRJUMzDd0QgHmOF42/fWWtQ9ruCVmG4MANo4sPnFCrINyTzf5yAom4qujLs3gzGKS+oJytja4fZEZMqxl0IbbNr4FQ7Nnwi3zdqnJVN8v8w0xp08dgF9RGGH/qUL8zEqrSozReOCJ5w3U5uMPBQC6mJ1//ynwm+tFT1M1cFGbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=NXm4aOS0; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="NXm4aOS0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=v2vVbfkVI1a5rCFnVuGB28K8O3O/kRv+ENqhurcfUik=; b=NXm4aOS0yxKRy3O5L7sKB4RabH
	pGhmBSLVQaOnFzn3cZx3syrQfxT8vozhvbPkAlPBC92KVix9aD0z08gi1QDhzowhOGczMBIQ+COm1
	dlBb7Ng4p+Y5O+idNCaqjoMac8uaOZ4oqbg+DIZ8qBxQrLE9wjmgjJ0pQV27Tdb6RJg/vYWlx+8Rb
	yjWp4Foi7j6aAT3nf9Zwc+lufLSfSG2J7E5r0qH0SQRO0J3vIZE4RwuUxLBkcw7k+uvIrBMXZn9wq
	LXA+i0fdzS2RJsVg9YLsM3QN5xCh5TUkt8APqQvZv78H3hLPy8AiGv2XDQKkiuGBP0p2ejJDm+bWn
	ZPlHfZLw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42176 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1s2DPu-0006SW-10;
	Wed, 01 May 2024 18:06:50 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1s2DPv-00AhaA-Ra; Wed, 01 May 2024 18:06:51 +0100
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH RFC] KVM: arm64: allow ID_MMFR4_EL1 to be writable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1s2DPv-00AhaA-Ra@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 01 May 2024 18:06:51 +0100

Between 5.4 and 5.15, the guests view of HPDS, CnP, XNX and AC2
changed their value on the same Neoverse N1 r3p1 hardware which makes
migrating between these kernels on the host problematical.

We already permit changing HPDS in AA64MMFR1_EL1 and CnP in
AA64MMFR2_EL1. We also allow LSM as we allow that in AA64MMFR2_EL1,
so this patch includes support for that even though it isn't required.

Discussing with Marc Zygnier, AC2 should also be fine to be writable,
even though we don't inject an UNDEF if the guest accesses those
registers.

The only questionable one is XNX, execute-never control distinction,
which is also in AA64MMFR1_EL1 but we don't allow to be changed there.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 arch/arm64/kvm/sys_regs.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0cc289b17665..f306b38ec341 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2116,6 +2116,16 @@ static unsigned int hidden_user_visibility(const struct kvm_vcpu *vcpu,
 	.val = mask,				\
 }
 
+/* sys_reg_desc initialiser for writable AA32 ID registers */
+#define AA32_ID_WRITABLE(name, mask) {		\
+	ID_DESC(name),				\
+	.set_user = set_id_reg,			\
+	.visibility = aa32_id_visibility,	\
+	.reset = kvm_read_sanitised_id_reg,	\
+	.val = mask,				\
+}
+
+
 /*
  * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
  * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
@@ -2270,7 +2280,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	AA32_ID_SANITISED(ID_ISAR3_EL1),
 	AA32_ID_SANITISED(ID_ISAR4_EL1),
 	AA32_ID_SANITISED(ID_ISAR5_EL1),
-	AA32_ID_SANITISED(ID_MMFR4_EL1),
+	AA32_ID_WRITABLE(ID_MMFR4_EL1, ID_MMFR4_EL1_LSM |
+				       ID_MMFR4_EL1_HPDS |
+				       ID_MMFR4_EL1_CnP |
+				       ID_MMFR4_EL1_XNX |
+				       ID_MMFR4_EL1_AC2),
 	AA32_ID_SANITISED(ID_ISAR6_EL1),
 
 	/* CRm=3 */
-- 
2.30.2

