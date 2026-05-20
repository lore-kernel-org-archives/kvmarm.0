Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71B13BF685
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 09:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268817; cv=none; b=TH4WYZe3aE43qkXNo5IHKfnpGkkVycvDuRm2y3HvEOAWuBgABxv46h3Ab9ICpe2OJwKVeFZyqT5nLZNsno5CbYf/ONNLlw24zT457aSd61BZY6LBBtbwBriQukujbAObscgr98x9qO6qtDRO9400zhcb1uz2EPx31k2KE0xqiG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268817; c=relaxed/simple;
	bh=7d/hsUzmlKkWAN2CmctMNJzarWeRMq8LyqkxKhc2YhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViXwAfvcjTPwJf6SX6kL+kkXx3WTPkwm5yVUuYDOuy7Ks63PD5ziq1jAbUs9L0aKvTD4N1OyrThMhlJVJx4AxjhKdRhZqdCf1JrVIoiJDfUZe1biakHo6xr3dwZhYszhyXlqgVYINQuROQnvhZVxWd7eOail1Qfj3GNKz7ZLlp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wkg4zVqI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wkg4zVqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70261F0089A;
	Wed, 20 May 2026 09:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268814;
	bh=m2UP4oEFhHFvYNaDQ1RBxMdab/kp2FfRq8HctTWxTnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wkg4zVqILB+Pkp2Zhk+T+wByBZtsYuRPm44HzAq5pO02+XqHuzJY0VmVBKdPbXX9e
	 IU0WRqDomb6/bCTSkhQ3zF8FNY2sAeWS7BpS1Su/PaFpSy3qoh7K3J/ICJODQASluH
	 QjI4iN6nd+CoB5A7JJWGpFVE9QMRjO81zXbAxLPDN4zMepDgApNKAtsUBe2PUIt6We
	 Zw6A4P9tnKcjCHLUmYvj5S/bkSbMdJfD7JtySASTzzSC2dmqc716BPIKaJbWK2dNbC
	 xkbaEESY0yObA4VrBaGMDVFNL85dU8wbq5mlJAz4WWtFi0LlWor1tA4X60wTpZeHLR
	 R42TD3eUWf4mA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPd64-00000004IaV-3uY6;
	Wed, 20 May 2026 09:20:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH v2 13/18] KVM: arm64: selftests: Cleanup unused vars in GICv5 PPI selftest
Date: Wed, 20 May 2026 10:19:44 +0100
Message-ID: <20260520091949.542365-14-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520091949.542365-1-maz@kernel.org>
References: <20260520091949.542365-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Sascha Bischoff <sascha.bischoff@arm.com>

Clean up a set of unused variables around the size of the guest's PA
space as they are completely irrelevant for GICv5 when only
considering PPIs.

Fixes: 0a9f38bf612b ("KVM: arm64: selftests: Introduce a minimal GICv5 PPI selftest")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/selftests/kvm/arm64/vgic_v5.c
index d785b660d8476..a8707120de0d8 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -20,8 +20,6 @@ struct vm_gic {
 	u32 gic_dev_type;
 };
 
-static u64 max_phys_size;
-
 #define GUEST_CMD_IRQ_CDIA	10
 #define GUEST_CMD_IRQ_DIEOI	11
 #define GUEST_CMD_IS_AWAKE	12
@@ -208,13 +206,9 @@ void run_tests(u32 gic_dev_type)
 int main(int ac, char **av)
 {
 	int ret;
-	int pa_bits;
 
 	test_disable_default_vgic();
 
-	pa_bits = vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
-	max_phys_size = 1ULL << pa_bits;
-
 	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V5);
 	if (ret) {
 		pr_info("No GICv5 support; Not running GIC_v5 tests.\n");
-- 
2.47.3

