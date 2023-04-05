Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC806ABC
	for <kvmarm@lists.linux.dev>; Wed,  5 Apr 2023 15:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B2FC433D2;
	Wed,  5 Apr 2023 15:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680709262;
	bh=H4ZPPuw9ENZrxHpUu14yMy4L+2lAlUmeVTn4NNvf+Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZUPC+pyl2rtEsiQF8NjK5PXvlVZPtQ5DUdhO82B6GgGTWjLLL9SVJZAELk73iyz74
	 pZfxZ62KLt2F2FL3uOqRYU/nEDrm9A/3qmdIctg2BzIGpfuxvi/A1SoJ49ecmp9AaT
	 5fdo19w7dXoWbggZeTT8JSJKPJS7VM1Xj7lipsyifQgu1Y02fBeQ6nN0jvSbIhnR+C
	 lGwccZXXeNUQYBtNVgGFNZXyiyamlGQGPpSoNfDYFYdohU1zF+2VOKbmiehO3hBS1X
	 kclNhokeEoj0sv0ATVMOMaEgDEzeRVLwp+0bUYIJTu+/PVUOz6BRhkGLdy+lUiEQOO
	 RqoJEPuWcORgA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pk5FR-0062PV-Ns;
	Wed, 05 Apr 2023 16:40:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v9 24/50] KVM: arm64: nv: Hide RAS from nested guests
Date: Wed,  5 Apr 2023 16:39:42 +0100
Message-Id: <20230405154008.3552854-25-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230405154008.3552854-1-maz@kernel.org>
References: <20230405154008.3552854-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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
index 0c868c9af8d9..42d67f74b54a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2444,6 +2444,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
 	EL2_REG(RVBAR_EL2, access_rw, reset_val, 0),
 	{ SYS_DESC(SYS_RMR_EL2), trap_undef },
+	{ SYS_DESC(SYS_VDISR_EL2), trap_undef },
 
 	EL2_REG(CONTEXTIDR_EL2, access_rw, reset_val, 0),
 	EL2_REG(TPIDR_EL2, access_rw, reset_val, 0),
-- 
2.34.1

