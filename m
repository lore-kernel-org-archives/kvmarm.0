Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2837C40FD98;
	Thu, 26 Mar 2026 15:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774539339; cv=none; b=d6XLrX9oUCjIcOzrssmYcwA+Lc5ixdVoc6x+p4lSTyGBbV1fmbjkC6WzJrxpkAuWI1bL0r3p9EdxG9cgk2zVImsOcWGaNusvnp8edQ3kyiWd5AdcEKgIdnHgWBG99sDSDBXpGtP1BqOK5nevPzibviC7B1QLJb9ks4jFIYs3iBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774539339; c=relaxed/simple;
	bh=OnkAaZ/jg85tiwhR94ci/DbNvsuSh0bKDG0rnVDTaYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCsUvyJ1GHOQtW+JP8BYP0Lz/WXtBdkdISbxl/ynsBnGRWaPSzFveCD/19+yF7gGfj9WU7aYAq/Yw3JFE8fh/NAFCXYjRn2oPpgwJ7wJvI4vb+0mUDcFT6JYzn+FwNCnShmNRPasfTNW7dQ6mF4Zj6jX4ONiTpOQun3VOFe7kCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WhxENzHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WhxENzHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084C1C2BCB0;
	Thu, 26 Mar 2026 15:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539339;
	bh=OnkAaZ/jg85tiwhR94ci/DbNvsuSh0bKDG0rnVDTaYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WhxENzHe5qoKXqeCszF5uMyrwI0ijAlY/QZU9qjz/XNdEMWTHabm0jwPQvAqdb20l
	 DP0l093GHxr2j27R/EmCKrUscLZqXITGKtN6iKage4vb1EJEfS4+4ZtC2Spj1WF0AC
	 trObve05YK0A0H/eYJ0XMH2GMLUmGOZHmqhP0G1dd4pinR1Y20qvYUUlTdQ5DcGsi7
	 yyumgIuQH2Rb2knSDQoVHYEKT2Ib0FhXh/fUlB4MJajtDf92gWdZQAovZASpkQJ4hh
	 KVlnOqzJuIjbu5JZANc0/IzWvoO4kx9UVmElOJuubXEQdhqVD5lkEj5NJ8PkAAYuQG
	 as9gYnKrZs9uQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w5mkD-000000060II-1AJt;
	Thu, 26 Mar 2026 15:35:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 14/15] KVM: arm64: Correctly plumb ID_AA64PFR2_EL1 into pkvm idreg handling
Date: Thu, 26 Mar 2026 15:35:29 +0000
Message-ID: <20260326153530.3981879-15-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326153530.3981879-1-maz@kernel.org>
References: <20260326153530.3981879-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

While we now compute ID_AA64PFR2_EL1 to a glorious 0, we never use
that data and instead return the 0 that corresponds to an allocated
idreg. Not a big deal, but we might as well be consistent.

Fixes: 5aefaf11f9af5 ("KVM: arm64: gic: Hide GICv5 for protected guests")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index b40fd01ebf329..be6f420388a14 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -439,7 +439,7 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	/* CRm=4 */
 	AARCH64(SYS_ID_AA64PFR0_EL1),
 	AARCH64(SYS_ID_AA64PFR1_EL1),
-	ID_UNALLOCATED(4,2),
+	AARCH64(SYS_ID_AA64PFR2_EL1),
 	ID_UNALLOCATED(4,3),
 	AARCH64(SYS_ID_AA64ZFR0_EL1),
 	ID_UNALLOCATED(4,5),
-- 
2.47.3

