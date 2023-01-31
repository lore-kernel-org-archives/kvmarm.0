Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AC1808
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 09:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F488C433A1;
	Tue, 31 Jan 2023 09:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675158162;
	bh=h1J6OM3LavEJHyI9EDArAeIgKAt25X6tuhGyuMdntGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMXT0eNAcMcouv79m9l0sidh0hY/YEhh6SR+OViOmkA+w2oDhDYdlCXg/cSb0xJiI
	 iQPQvxspCZSxjoim3dyVisBznrcjXqn7fMsbvK++mQnrq56KurpeMY83fLT0w+Akqd
	 DSpccikrNmm9u/3wvFqIjE2ZTCMJCZDq9yNAX0AHl+SYfn8AHLMF7j6Qx7HVz2ybcz
	 9VoZ/wz/wbhgIOQkak4XKdBaM4NYIrkf0XWUf9GTzNYWbPLFiV8arEtQ9vsmXsciEc
	 0kkXXMDVqcLVKYtVvgsqoFT7OVIuMV4LQ4cXSCW4QBWLsi6j0X66mghHUIjdV/IyYK
	 Gd4GHIZkD5ASQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pMmtU-0067U2-Nq;
	Tue, 31 Jan 2023 09:25:36 +0000
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
Subject: [PATCH v8 26/69] KVM: arm64: nv: Respect virtual HCR_EL2.TVM and TRVM settings
Date: Tue, 31 Jan 2023 09:24:21 +0000
Message-Id: <20230131092504.2880505-27-maz@kernel.org>
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

From: Jintack Lim <jintack.lim@linaro.org>

Forward the EL1 virtual memory register traps to the virtual EL2 if they
are not coming from the virtual EL2 and the virtual HCR_EL2.TVM or TRVM
bit is set.

This is for recursive nested virtualization.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 58c0c0eed28b..35ed217e39d8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -420,6 +420,13 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	if (el12_reg(p) && forward_nv_traps(vcpu))
 		return false;
 
+	if (!el12_reg(p)) {
+		u64 bit = p->is_write ? HCR_TVM : HCR_TRVM;
+
+		if (forward_traps(vcpu, bit))
+			return false;
+	}
+
 	/* We don't expect TRVM on the host */
 	BUG_ON(!vcpu_is_el2(vcpu) && !p->is_write);
 
-- 
2.34.1

