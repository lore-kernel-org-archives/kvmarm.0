Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A1737CD4D
	for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 11:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776254183; cv=none; b=pm76kqg5Bg/cMfNVB5/m2T+Y0OiWzKb9sV16cJEoEYzAmj+HADsyxC2WvyyIuJdlONnsqkeceXun5OpqsTxdFuAG2O72bOEeu8iKaXkJJ6Hv7P7QE++xcEepNcDFsMlCO67hyMLx+EfKl2bZhC/yrOBKMFRxwI8buwoagxYEe20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776254183; c=relaxed/simple;
	bh=IHhFWg6GA5Gm7coKQ9f6giTOQmr8ZuVLC0KO5AkOn0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQG9gZs4yiLKupBq6Y8waKXxbbAfbfCFO4zUJ4agViZpH1XVbCm8kl4ZU3zR/93NJMOYQkVsrnAn0CrncTcGKisdRg2TZyQX1c3g94M9z3Vovhq/ALzV3PuYcz5kNxKtmxktAi0UNByJW3oducE+67nxylewIqANTQWB7LaHSm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=diDR/u42; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="diDR/u42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EA5C2BCB4;
	Wed, 15 Apr 2026 11:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776254183;
	bh=IHhFWg6GA5Gm7coKQ9f6giTOQmr8ZuVLC0KO5AkOn0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diDR/u42oANXLmDzPE7J8oQYS3aQXhwVCbIEvA3lC3clHEnmVtopEL7hrqBLIWyM6
	 zRO2/E0+SM8jx3EW23m5Et2h1HrSjRdIqLeUiOmx48bw3kb5HdrpIHw01SesnAOMd9
	 KYI3+nP+qU81Atg9Av0pn/St/aFeDvQr9LmZ7F1bwzI3JTTcWBj1V8VN09OcnOO/Kd
	 3mOjyJpbjob7o+ECvS25Dm8vipk6Eagu5gVpIRJAUrF/vW6t2Zkot8ROkXGV2g3LT3
	 AzYumGmeLBIPWTmmzwkJcn4x+8UgLHZc1h8jO6aYQ01aWxmRyocVqJjCxG9b58a55h
	 miFh32fT1aQVA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wCyqz-0000000Bqsi-2GSi;
	Wed, 15 Apr 2026 11:56:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 12/18] KVM: arm64: selftests: Add missing GIC CDEN to no-vgic-v5 selftest
Date: Wed, 15 Apr 2026 12:55:53 +0100
Message-ID: <20260415115559.2227718-13-maz@kernel.org>
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

The selftest mistakenly omitted the GIC CDEN instruction from the
testing. Add it in.

Fixes: ce29261ec648 ("KVM: arm64: selftests: Add no-vgic-v5 selftest")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/arm64/no-vgic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/arm64/no-vgic.c b/tools/testing/selftests/kvm/arm64/no-vgic.c
index b14686ef17d12..e09e3fac904f4 100644
--- a/tools/testing/selftests/kvm/arm64/no-vgic.c
+++ b/tools/testing/selftests/kvm/arm64/no-vgic.c
@@ -159,6 +159,7 @@ static void guest_code_gicv5(void)
 	check_gicv5_gic_op(CDAFF);
 	check_gicv5_gic_op(CDDI);
 	check_gicv5_gic_op(CDDIS);
+	check_gicv5_gic_op(CDEN);
 	check_gicv5_gic_op(CDEOI);
 	check_gicv5_gic_op(CDHM);
 	check_gicv5_gic_op(CDPEND);
-- 
2.47.3

