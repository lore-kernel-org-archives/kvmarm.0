Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FBD81B
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 09:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEEAC433EF;
	Tue, 31 Jan 2023 09:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675158145;
	bh=xfH4X07JD136hpkodYH2sYgjnhcmppQC6xkM+e9e7P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQaaelSw7vp7vuKhDcG5pm9k7r+er+v7I7BUocxRbaTusUSSCfkggi6TCNKmaYgXZ
	 nvXKdn8QUV+9cOpCXUe9yrJj5oWSvGNIpEmvKfa1ZIpna3KheVRF6bTL7U1ZGvaYmp
	 /01jtlIB35KaQeKzUakUoRLl5OotK5mU3GjbWPmHTkKd4PZGmDSzoyL49EKIPfHoi5
	 UMaG52kRMCrCNOD+3uxN9NmekSrM/xt/df7ocWKdAIYzhBH4IikPnM+gYWJM40AN3X
	 wBdbEeBOXSB3DWDVopJjsCpLW83nfjv8BiqsJZbHDRro3Qu2/zRL3WhWQNa9gujZzJ
	 3/YyTBI7MVAsg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pMmtW-0067U2-Sw;
	Tue, 31 Jan 2023 09:25:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v8 34/69] KVM: arm64: nv: Hide RAS from nested guests
Date: Tue, 31 Jan 2023 09:24:29 +0000
Message-Id: <20230131092504.2880505-35-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We don't want to expose complicated features to guests until we have
a good grasp on the basic CPU emulation. So let's pretend that RAS,
doesn't exist in a nested guest. We already hide the feature bits,
let's now make sure VDISR_EL1 will UNDEF.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b117c43ba15e..93a0c10d8e0c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2440,6 +2440,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
 	EL2_REG(RVBAR_EL2, access_rw, reset_val, 0),
 	{ SYS_DESC(SYS_RMR_EL2), trap_undef },
+	{ SYS_DESC(SYS_VDISR_EL2), trap_undef },
 
 	EL2_REG(CONTEXTIDR_EL2, access_rw, reset_val, 0),
 	EL2_REG(TPIDR_EL2, access_rw, reset_val, 0),
-- 
2.34.1

