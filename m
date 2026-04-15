Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47F037BE8F
	for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 11:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776254183; cv=none; b=O8GSi54mQuYgU8BCni1mdm68h4yEos07ZwuUGJXCb1QZXyu0E+Z19fuBXZJobcF22/3PoBWA82YI3gbcNzUPqEvK5wsaQ7tHzlN6n34+sEmWW2mm1fZnG0/WqOVf2/DI0p63fa8HNlSvSSmvSIw0rh3Th4JWhI3LFbhL6iwCcuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776254183; c=relaxed/simple;
	bh=95h1WFfjE9r9Nnr95FG3E3hjnoiCWNmw/Z72krq0Lc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtwO0c3bfG0lgQooz73rOpl4ONAW5IjQceSr9OAl8R9RGpMbZiXeV7wclLwz9Xaoxhs3/fqdrf5FvTs5yvFYtV2Vs+lHW6fEiE3F8rgCsE9W6mzmn4Kp1669R1pmBLFEvmiPHno4j2587oO2+BXFOpxbpVel71DrgzA6cylPdio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NlvloMbh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NlvloMbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EB2C2BCB8;
	Wed, 15 Apr 2026 11:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776254183;
	bh=95h1WFfjE9r9Nnr95FG3E3hjnoiCWNmw/Z72krq0Lc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NlvloMbh71HOrIx33ML3sPYMmQfdjWm+Z918pZK3/zctPS3vUxiyPseEv++ycjJYf
	 ElXc7QRTjum5mMUjFcwCb+0jJrUDh4IER5VaWzeuYlgMK9ljY+/VFccqH3fEipl04r
	 0gpHyO1Ocjs0RZthEnfFSOEUdqqd1+SGhCX8XPhR/a8nPBNquNDm1yUU0fpRO8yXFA
	 edGGiWq4ceqAROrTWrS8CYX5dJhk87vZ4tXGHIK3xbkxF2P5VN/TlkDLq/vZ+ig1/5
	 hB1iy9LF9R/avJYbSKF+s1MATmmlNJsu6Z0P+53cSgk0oDNCDthEJUISrIx15gRHtq
	 jJ+YndfXiN9qQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wCyqz-0000000Bqsi-323k;
	Wed, 15 Apr 2026 11:56:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 13/18] KVM: arm64: selftests: Cleanup unused vars in GICv5 PPI selftest
Date: Wed, 15 Apr 2026 12:55:54 +0100
Message-ID: <20260415115559.2227718-14-maz@kernel.org>
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
index 3ce6cf37a629f..9ddd32c3665bd 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -20,8 +20,6 @@ struct vm_gic {
 	uint32_t gic_dev_type;
 };
 
-static uint64_t max_phys_size;
-
 #define GUEST_CMD_IRQ_CDIA	10
 #define GUEST_CMD_IRQ_DIEOI	11
 #define GUEST_CMD_IS_AWAKE	12
@@ -208,13 +206,9 @@ void run_tests(uint32_t gic_dev_type)
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

