Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387843563D9
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 08:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769071929; cv=none; b=Mjf12dJBAuFoCutcvwuVSTD89fXkOk+mHtl7cPke3UBBYOvh+ABBtvUvKdGveMe+uzEdG6VeSltwMNwRPFlWY4fW9ks8XiAhnE1jI4Ca9vS1dFKYFFtmtHiLMft7QQkM//LPrhWwWrdNFKkNZUMk9zaUkpcF1hqNZN2R0HbR4iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769071929; c=relaxed/simple;
	bh=7sUNNWOkM2GYuWXQM+354XXr/rWsRWU9V1EcCJXR7cU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Veczmt3//+2NXXSFcniJuS7MqeLBXhPZKPGn6CkJODc/rcG014BtYXtf5C1qzV36fPCEL3ke5XGGjAmN2Ug8QzLmgZjkDyo5vjdjaw0+9SlTrPoJcHtR3N+pvbQqI9AvLCdjXhF4rDQ3W7pk5RDxd4dni0M8xBzjUVl6XreqWsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gRLH/SRM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gRLH/SRM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CC6C116C6;
	Thu, 22 Jan 2026 08:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769071925;
	bh=7sUNNWOkM2GYuWXQM+354XXr/rWsRWU9V1EcCJXR7cU=;
	h=From:To:Cc:Subject:Date:From;
	b=gRLH/SRMvfeKTdiRyqiu7i2BQPRxYKkhBzru19BQhM9d+ZhBrCELKoPZlUk8v3SAC
	 CpMXo4lszJLE5FVzTJ07cJXfFcCzcxMZFFDm0u9EXVP38Exf0rk+8A4o58SeitwSDo
	 q/STKhbSNjgHXMhDZPf7fZ6E6/WnVWLugmg1AksiidqsP/jfnl8+rX/040OnzJY3VR
	 8EkVFTrJ+s/WJMsEwb9AELYdnmU1jW8xEqm4V+u1KjVR4zrR1LShBYPBECGE3j5Yrk
	 TFrX0lBp3+2oROkOnATDO3MM635/JjpAxjaEY8W4KR/43NhCX58L09sutp0HWd5kC0
	 UxRGDiR2N1K3A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1viqQ7-00000004byX-0v9c;
	Thu, 22 Jan 2026 08:52:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] KVM: arm64: Always populate FGT masks at boot time
Date: Thu, 22 Jan 2026 08:51:53 +0000
Message-ID: <20260122085153.535538-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, nathan@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We currently only populate the FGT masks if the underlying HW does
support FEAT_FGT. However, with the addition of the RES1 support for
system registers, this results in a lot of noise at boot time, as
reported by Nathan.

That's because even if FGT isn't supported, we still check for the
attribution of the bits to particular features, and not keeping the
masks up-to-date leads to (fairly harmess) warnings.

Given that we want these checks to be enforced even if the HW doesn't
support FGT, enable the generation of FGT masks unconditionally (this
is rather cheap anyway). Only the storage of the FGT configuration is
avoided, which will save a tiny bit of memory on these machines.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Fixes: c259d763e6b0 ("KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP() and co")
Link: https://lore.kernel.org/r/20260120211558.GA834868@ax162
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 75d49f83342a5..e5874effdf167 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2276,9 +2276,6 @@ int __init populate_nv_trap_config(void)
 	kvm_info("nv: %ld coarse grained trap handlers\n",
 		 ARRAY_SIZE(encoding_to_cgt));
 
-	if (!cpus_have_final_cap(ARM64_HAS_FGT))
-		goto check_mcb;
-
 	for (int i = 0; i < ARRAY_SIZE(encoding_to_fgt); i++) {
 		const struct encoding_to_trap_config *fgt = &encoding_to_fgt[i];
 		union trap_config tc;
@@ -2298,6 +2295,15 @@ int __init populate_nv_trap_config(void)
 			}
 
 			tc.val |= fgt->tc.val;
+
+			if (!aggregate_fgt(tc)) {
+				ret = -EINVAL;
+				print_nv_trap_error(fgt, "FGT bit is reserved", ret);
+			}
+
+			if (!cpus_have_final_cap(ARM64_HAS_FGT))
+				continue;
+
 			prev = xa_store(&sr_forward_xa, enc,
 					xa_mk_value(tc.val), GFP_KERNEL);
 
@@ -2305,11 +2311,6 @@ int __init populate_nv_trap_config(void)
 				ret = xa_err(prev);
 				print_nv_trap_error(fgt, "Failed FGT insertion", ret);
 			}
-
-			if (!aggregate_fgt(tc)) {
-				ret = -EINVAL;
-				print_nv_trap_error(fgt, "FGT bit is reserved", ret);
-			}
 		}
 	}
 
@@ -2325,7 +2326,6 @@ int __init populate_nv_trap_config(void)
 	kvm_info("nv: %ld fine grained trap handlers\n",
 		 ARRAY_SIZE(encoding_to_fgt));
 
-check_mcb:
 	for (int id = __MULTIPLE_CONTROL_BITS__; id < __COMPLEX_CONDITIONS__; id++) {
 		const enum cgt_group_id *cgids;
 
-- 
2.47.3

