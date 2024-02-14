Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1ED535CC
	for <kvmarm@lists.linux.dev>; Wed, 14 Feb 2024 13:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707916714; cv=none; b=dbV7q9C7B7YqnBkcaRwTfxVMpvIMj1A8XPLwMSROh3AjksVdj6G7DHYRUylE8ZxGWiRjVEAfnoOxayRCgOG4uKMY1ehkIQXWmnwF6NgN8PvTTMvHnF+WHB5hgTTtwZJtjmX3bmeOgozaZaG81hW7/QwUzfcDqTHCqUrC+sidIk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707916714; c=relaxed/simple;
	bh=e8O8ZVOLKTFpznJo1DX6Qs4uI6A5fN19r7dzF8iVEH8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fP6NzUoJfrLPBGrHhZ5TjKehBwzLRjQOa5tAdTksMkSjEVTASNC7PpaZF4wAh8UUE1fP7Jvey51aTh7hbxlgpzqNjljHw0JBAXnmMwXery+luXHrDSOnVsBFSQBkNUQbzaUIaxB229VxOJr825u/L5nu+1CWNQx1jy2XbDe232s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VkGTNSR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VkGTNSR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E775C43390;
	Wed, 14 Feb 2024 13:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707916714;
	bh=e8O8ZVOLKTFpznJo1DX6Qs4uI6A5fN19r7dzF8iVEH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkGTNSR9pF126lusjGCffn3MRdWL0XAkCsCWMBJJpuQbSnHyjrNsiAkKOv1o19pop
	 2cierHbOrRkZ2JG3Rnps63jQs9A/Kr0ubmO2rfYs7Z8LXKLktID+ishQjmAh/G2AIz
	 B9GywzQkW6zcwiCmiULO02JUe7mCS6sASfcGTS7sUIFvFio930iV9UxIrScXhXakq1
	 66DSSbYfUKREFz3e+gj62Nxyasz8zsxMs8m6uJRIWIU9vviORLDbCfPyS63zdJ5IPj
	 p677J/SJmAa/aI2wybGcI6ApM5Uqrk4NVFGx6bFW44Vv01bofyy+pCkX94fPZxJmxW
	 6kEzhPciMK5zQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1raF9k-00394l-5r;
	Wed, 14 Feb 2024 13:18:32 +0000
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
Subject: [PATCH v4 08/26] KVM: arm64: Unify HDFG[WR]TR_GROUP FGT identifiers
Date: Wed, 14 Feb 2024 13:18:09 +0000
Message-Id: <20240214131827.2856277-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240214131827.2856277-1-maz@kernel.org>
References: <20240214131827.2856277-1-maz@kernel.org>
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

There is no reason to have separate FGT group identifiers for
the debug fine grain trapping. The sole requirement is to provide
the *names* so that the SR_FGF() macro can do its magic of picking
the correct bit definition.

So let's alias HDFGWTR_GROUP and HDFGRTR_GROUP.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 7a4a886adb9d..8a1cfcf553a2 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1010,7 +1010,7 @@ enum fgt_group_id {
 	__NO_FGT_GROUP__,
 	HFGxTR_GROUP,
 	HDFGRTR_GROUP,
-	HDFGWTR_GROUP,
+	HDFGWTR_GROUP = HDFGRTR_GROUP,
 	HFGITR_GROUP,
 	HAFGRTR_GROUP,
 
@@ -1938,7 +1938,6 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 		break;
 
 	case HDFGRTR_GROUP:
-	case HDFGWTR_GROUP:
 		if (is_read)
 			val = __vcpu_sys_reg(vcpu, HDFGRTR_EL2);
 		else
-- 
2.39.2

