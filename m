Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840D340BFC
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954739; cv=none; b=bZuc2tOFcCLLmDvWvmh76h9/kI3ZPg3EwPdqrlk2JJUSBxDbB4Te42809VzdDzMOTQBOI0+qk9zM+CBabiy2GB7a6kUvvzV8G51AwhzLJcg1fvSvmkCg0WvgJC4kiBiTUPBv2QwNbjy5TR83ishRzTqPh75Q+ElvOYb0IIf3yk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954739; c=relaxed/simple;
	bh=9hBAKOyTHCZPgqJHCSVdY4FgU2Ta6tAXYL5A56zPx+U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h63dSbWKXh2ZXENCCChSYExkNPvdutRInv9YIkDTXhCYWJ1U0GQisHH9JScTCEQJxyGcBm8vRMnGwMdd+J7Fbycy1wnA4VL35XypkjaIh8wOT2J7Y6GusK7qydlgk7vS1lTzHj4Oq0Uc2ABaYvMFjSMMMbJmCjwnZTb8nR10GS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D6chHDD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D6chHDD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABFDC433B2;
	Mon, 22 Jan 2024 20:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954739;
	bh=9hBAKOyTHCZPgqJHCSVdY4FgU2Ta6tAXYL5A56zPx+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6chHDD0HHfPsADIMkrk+CFu0p85afbp8Zal0EjRSZJTVLHQcFlPELGx5TlXz2SHD
	 4TnwRih4GlGXRp5T+SZ089c0A1/Gvzku69KXCE39mb23Sl7P+y1ZiDIhQhvQjcG7ia
	 wwa/6bfkclic0fboyWiDFB8ZR7FZ8ua4K14rVTJhUSx/jA9wa9gBiqpRJqW7CwNGs2
	 mzeqdxke4yHoiPdXfOvDrj0hb+26BS2YxsUoPKxfAKUsgYGWs4jb1jKWaIJaMWo1Wt
	 2UU0PTQsgY4fU0rYmvG/6UPoxiYGjIJH45x4OC0UTvYssiDv/YOaCVe0CIfVg22NV5
	 vGmrM88HX/nvA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0kz-00DjkQ-G6;
	Mon, 22 Jan 2024 20:18:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 10/25] KVM: arm64: nv: Turn encoding ranges into discrete XArray stores
Date: Mon, 22 Jan 2024 20:18:37 +0000
Message-Id: <20240122201852.262057-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122201852.262057-1-maz@kernel.org>
References: <20240122201852.262057-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to be able to store different values for member of an
encoding range, replace xa_store_range() calls with discrete
xa_store() calls and an encoding iterator.

We end-up using a bit more memory, but we gain some flexibility
that we will make use of shortly.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index ef46c2e45307..59622636b723 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1757,6 +1757,28 @@ static __init void print_nv_trap_error(const struct encoding_to_trap_config *tc,
 		err);
 }
 
+static u32 encoding_next(u32 encoding)
+{
+	u8 op0, op1, crn, crm, op2;
+
+	op0 = sys_reg_Op0(encoding);
+	op1 = sys_reg_Op1(encoding);
+	crn = sys_reg_CRn(encoding);
+	crm = sys_reg_CRm(encoding);
+	op2 = sys_reg_Op2(encoding);
+
+	if (op2 < Op2_mask)
+		return sys_reg(op0, op1, crn, crm, op2 + 1);
+	if (crm < CRm_mask)
+		return sys_reg(op0, op1, crn, crm + 1, 0);
+	if (crn < CRn_mask)
+		return sys_reg(op0, op1, crn + 1, 0, 0);
+	if (op1 < Op1_mask)
+		return sys_reg(op0, op1 + 1, 0, 0, 0);
+
+	return sys_reg(op0 + 1, 0, 0, 0, 0);
+}
+
 int __init populate_nv_trap_config(void)
 {
 	int ret = 0;
@@ -1775,13 +1797,8 @@ int __init populate_nv_trap_config(void)
 			ret = -EINVAL;
 		}
 
-		if (cgt->encoding != cgt->end) {
-			prev = xa_store_range(&sr_forward_xa,
-					      cgt->encoding, cgt->end,
-					      xa_mk_value(cgt->tc.val),
-					      GFP_KERNEL);
-		} else {
-			prev = xa_store(&sr_forward_xa, cgt->encoding,
+		for (u32 enc = cgt->encoding; enc <= cgt->end; enc = encoding_next(enc)) {
+			prev = xa_store(&sr_forward_xa, enc,
 					xa_mk_value(cgt->tc.val), GFP_KERNEL);
 			if (prev && !xa_is_err(prev)) {
 				ret = -EINVAL;
-- 
2.39.2

