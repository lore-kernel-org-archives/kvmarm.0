Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B932810784
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 08:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC43C433C8;
	Fri, 28 Jul 2023 08:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690534049;
	bh=QjU09/ztCkP8Hqos+fcG049ytIrT3fHu8hzu5/go5vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0MVAUNUorzwuXItM/Siiq2IW+RpENxiGoyb4rYL2fwUzWB3Ac5vLM4ftw1rnz0Xe
	 NIvaArMmefzJzMYx8t7SS4Htrh+yvZ9LmAR0VkL6utPEhmQNarx71zabWHTl8OzuwP
	 /1bhh2hWRswuFVcbBbI41HL2cck39Rp122l+wVvOn4s0im02i0+dEWwvicL2jnKw9d
	 CY/SNCHf15BpPh+WXW6IYriyweklbsCAF859YARTLVBpZUWxwqrxsZyay86KJitYXq
	 s7ZeIL8l6/TSKQfMiWCHj/9+CPvC2YJp9Qnt6ULRcTq9c3PEQ01amdrHUEwks9hC1o
	 BO8DV4/dGgEZQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qPIrO-0000EO-9i;
	Fri, 28 Jul 2023 09:30:06 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 24/26] KVM: arm64: nv: Expose FGT to nested guests
Date: Fri, 28 Jul 2023 09:29:50 +0100
Message-Id: <20230728082952.959212-25-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230728082952.959212-1-maz@kernel.org>
References: <20230728082952.959212-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we have FGT support, expose the feature to NV guests.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 7f80f385d9e8..3facd8918ae3 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -71,8 +71,9 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
 		break;
 
 	case SYS_ID_AA64MMFR0_EL1:
-		/* Hide ECV, FGT, ExS, Secure Memory */
-		val &= ~(GENMASK_ULL(63, 43)		|
+		/* Hide ECV, ExS, Secure Memory */
+		val &= ~(NV_FTR(MMFR0, ECV)		|
+			 NV_FTR(MMFR0, EXS)		|
 			 NV_FTR(MMFR0, TGRAN4_2)	|
 			 NV_FTR(MMFR0, TGRAN16_2)	|
 			 NV_FTR(MMFR0, TGRAN64_2)	|
-- 
2.34.1

