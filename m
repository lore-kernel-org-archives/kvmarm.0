Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC32E37D10F
	for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 11:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776254183; cv=none; b=JDX29i3yflw1CKhfbT/ZigMLcqrAXLYk2nS7J/0xRZKFBufwAOnxQDg6JwinDMC9sqUMmZjTkB3oS2opSMd53rEQPC40kBGM4K0SLMNNUVuIDNMFZUQypAsJR94la88Rdry2x5r8Mbmzhc0QIQps5ZvGncNdXKjPOYhNIwNWY3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776254183; c=relaxed/simple;
	bh=sB52Lk/iyzOu++m68c6uukcJ6VfiI7VFY+ooUkIlVy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYWIl2bGkd80MoNuEbzsYgtWiJAgDAK1OjBkIZvABwnj0LDz+9Rxp3zCEfYOuFsoClVGiHHDooVcqS/91rVIiV7fmT+EVGhLO12Ot5ZIXd5a4xtLXo32L5T7oqW3j4N8/3QGCoEybKh0MVx04lDE9L44icDkegsWcXfrIz4CAQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tjf4jJMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tjf4jJMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0545C19424;
	Wed, 15 Apr 2026 11:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776254183;
	bh=sB52Lk/iyzOu++m68c6uukcJ6VfiI7VFY+ooUkIlVy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjf4jJMnkj7a7JG2urSIAUTH8PsG6h9kbh2T1Sl7QR4mhnX1QMNh0D3+9adJm5mKm
	 +Bjr0hVgxgZ2qS/X9cHF6bXGQF4Jt5HbDDRM+LAJWwfrjNKWKl/FcYwJcdUvjfp6NT
	 U7gxHgdjWzTuKQmArxwzVrXaxLWkGWtGs85Unig7M3VjMlPBzk3wP9QvkiJaho/TZU
	 I+cGn+srl99khiJlpbSKMZ+jG1AtY/Bo+Srtkc1Pd3XZjFNlrkOhvsR+/Y6g1KLJQu
	 arLzNF8gNZoctMj4sYxGgNdwIrh85NPAyVMLDhtviXrB37OTlxx3FdiEa97Evi9qIS
	 fIyrzHk37xaRA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wCyqz-0000000Bqsi-3z0P;
	Wed, 15 Apr 2026 11:56:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 14/18] KVM: arm64: selftests: Improve error handling for GICv5 PPI selftest
Date: Wed, 15 Apr 2026 12:55:55 +0100
Message-ID: <20260415115559.2227718-15-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415115559.2227718-1-maz@kernel.org>
References: <20260415115559.2227718-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
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
index 9ddd32c3665bd..49c57ea72eaa9 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -129,6 +129,8 @@ static void test_vgic_v5_ppis(uint32_t gic_dev_type)
 
 	while (1) {
 		ret = run_vcpu(vcpus[0]);
+		if (ret)
+			break;
 
 		switch (get_ucall(vcpus[0], &uc)) {
 		case UCALL_SYNC:
@@ -144,7 +146,7 @@ static void test_vgic_v5_ppis(uint32_t gic_dev_type)
 				irq = FIELD_PREP(KVM_ARM_IRQ_NUM_MASK, 3);
 				irq |= KVM_ARM_IRQ_TYPE_PPI << KVM_ARM_IRQ_TYPE_SHIFT;
 
-				_kvm_irq_line(v.vm, irq, level);
+				kvm_irq_line(v.vm, irq, level);
 			} else if (uc.args[1] == GUEST_CMD_IS_AWAKE) {
 				pr_info("Guest skipping WFI due to pending IRQ\n");
 			} else if (uc.args[1] == GUEST_CMD_IRQ_CDIA) {
-- 
2.47.3

