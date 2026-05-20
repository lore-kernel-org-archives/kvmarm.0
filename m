Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B949F3BF692
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 09:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268818; cv=none; b=sceqrTeUx1Rjyfmv4p4seIHsoRO3c4pHhxyBDQCm4UJDxhb3bigBg7sl2QT5Wa75WMY2Oqygpyx9HLua1Ss2G0mQFCMawA0T5Ic9rRCfTJzQA1bGdLAJzvtQ52YUVRrFXFwcm5I6DoR7Nh/eVK2XG5WJtj125Ad0ndff96+uHq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268818; c=relaxed/simple;
	bh=Xl5fstrD5Mrd5446uyAbEtY9jJ9h0lKhCMMsTIFQhxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnra5o3sHbmD9KhqUFkb0IgZRz8iKeRXu1N2HLlWiqG6TOnWF5cCnAM2qEpBv1HLwZXqGo1EYR9oHv/H++FrFJ6DiFNerTMK1sRm0ghouiukc9QT9YiZfdH2YvJlyLYTK3AtlJUQOfv6BtxQAqLG3DSz2Q8c5qIRdBsR5cMUnvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M4Eydw2M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M4Eydw2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC8E1F0089D;
	Wed, 20 May 2026 09:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268814;
	bh=qdQpPp2MoHg9tBaiDFbCeeRZQ0f811blbdA5CVHPU1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M4Eydw2MHLQ6nnrbpkxYc0S/zlpd3CST5tGg8K0HwIEb2TErQyr6VChgzYagjBLiS
	 e8OgriXWXarVffWOi6mlyR/AxBjna4IPc6YnXmODegrxtzlfjwiTsbJpO0tomMn2zI
	 VIcnY1pSdljTD6xcRoJlIgb/NwRp0TKNshUISk2rIDs/pJpCIhbcpLJAbqMC2fV2kl
	 WbgFGNLNOKmEEAmeT+QGc1jp883/iq0JBeIWTODgZpwyFfqHccITUNp/wh+4DI+1Qz
	 REpj3o+BHe7v7Y3RueyUXo8RafMGE+iMStdQh63VRwJhUHonOY71Hrq2TnVQJFTyVK
	 RUKZXDTAAHBKQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPd65-00000004IaV-0Xgc;
	Wed, 20 May 2026 09:20:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH v2 14/18] KVM: arm64: selftests: Improve error handling for GICv5 PPI selftest
Date: Wed, 20 May 2026 10:19:45 +0100
Message-ID: <20260520091949.542365-15-maz@kernel.org>
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

Cases where the KVM_RUN ioctl returned an error were wrongly reported
as incorrect ucalls. Furthermore, potential failures when calling
KVM_IRQ_LINE were being hidden.

Improve the error handling to correctly propagate the error in both
cases.

Fixes: 0a9f38bf612b ("KVM: arm64: selftests: Introduce a minimal GICv5 PPI selftest")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/selftests/kvm/arm64/vgic_v5.c
index a8707120de0d8..96cfd6bb32f6f 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -129,6 +129,8 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 
 	while (1) {
 		ret = run_vcpu(vcpus[0]);
+		if (ret)
+			break;
 
 		switch (get_ucall(vcpus[0], &uc)) {
 		case UCALL_SYNC:
@@ -144,7 +146,7 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 				irq = FIELD_PREP(KVM_ARM_IRQ_NUM_MASK, 3);
 				irq |= KVM_ARM_IRQ_TYPE_PPI << KVM_ARM_IRQ_TYPE_SHIFT;
 
-				_kvm_irq_line(v.vm, irq, level);
+				kvm_irq_line(v.vm, irq, level);
 			} else if (uc.args[1] == GUEST_CMD_IS_AWAKE) {
 				pr_info("Guest skipping WFI due to pending IRQ\n");
 			} else if (uc.args[1] == GUEST_CMD_IRQ_CDIA) {
-- 
2.47.3

