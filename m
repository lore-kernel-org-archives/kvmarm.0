Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D8E35F167
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 17:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775062823; cv=none; b=JDfdjwYoCw7TF3Qqw+Qr11NDeDHBJdESr7VLS7YoCw9XLUzCGMuQRe0tC2RY/xaEX6h4E3e0ynYp2bnn/zgn5Kv1AHXL18XmkcPSxK6kUAr0GvO9+DalG2UApruDqLCuJPFB8UE0RO8LglZs8SQvEhcpD7c4HOy/UWacXcewfGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775062823; c=relaxed/simple;
	bh=YiVdKnvqD5vCATf23tC4OrdiTH65zsHAKoYXAEDSv9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l7cdP1+4WwY0TmQdTg7TvUWEhI38umQ12NfEdfuYnN90Otts6dQ9HZ9w8+v4HFpNhUE5EYC6r83cs64GCXRzHc7UHj0gCbVVgPQJw+S+rJVdS9XMDFn1/mcJjox99/xnS7YWAhOIgjRnk8H8HynnOsQAtOvMNlJ0QWp7F9BVkL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mcIps+yd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mcIps+yd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19595C4CEF7;
	Wed,  1 Apr 2026 17:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775062823;
	bh=YiVdKnvqD5vCATf23tC4OrdiTH65zsHAKoYXAEDSv9g=;
	h=From:To:Cc:Subject:Date:From;
	b=mcIps+ydayXq3ikkHk6pOXKdzfdMX6ggx/tE9jWoMxYqiBrTHMlVKytOBQQTw7JmE
	 biVbkmQBpVZFvLg5fBr5J9VZbylIneI96ebwUgvhay3eyMOd585dt58hu0Du8wbX+I
	 fKtLTceSMPOQQKJXBOQNGXCtN1TUCYKrQZi+uFlB80H1YiqjI1DlJb4u3mzSn2tOgG
	 R3LwUAqqi1zRJMCDdpGyoTJWzQjDS2mPULD24gotWUivxlZgUcHYm8SanAiK/uy+Ud
	 JfoAjW/jlYRrb56ArSes4cV6ubBJ2uZ/L1H+Mre7QzKJl4lE7AXk648xYmOMcUe8ne
	 TUr/8pKFpqoOA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7yvU-00000007xNF-39m5;
	Wed, 01 Apr 2026 17:00:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH] KVM: arm64: Advertise ID_AA64PFR2_EL1.GCIE
Date: Wed,  1 Apr 2026 18:00:17 +0100
Message-ID: <20260401170017.369529-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As we are missing ID_AA64PFR2_EL1.GCIE from the kernel feature set,
userspace cannot write ID_AA64PFR2_EL1 with GCIE set, even if we are
on a GICv5 host.

Add the required field description.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 32c2dbcc0c641..5bca6e064ca72 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -327,6 +327,7 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr2[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1_FPMR_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1_MTEFAR_SHIFT, 4, ID_AA64PFR2_EL1_MTEFAR_NI),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1_MTESTOREONLY_SHIFT, 4, ID_AA64PFR2_EL1_MTESTOREONLY_NI),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1_GCIE_SHIFT, 4, ID_AA64PFR2_EL1_GCIE_NI),
 	ARM64_FTR_END,
 };
 
-- 
2.47.3

