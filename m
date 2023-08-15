Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD3E2C9E
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 18:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A1FC43397;
	Tue, 15 Aug 2023 18:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692125216;
	bh=M5ur1yOezQPg2ZDbwLihFfqMKwUxIyGScvJphV2dVlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFUQiSCqP5126NVjKk6/hiYAXneIt6Vwkkzd6pUFdx7/gHmo8t/u7WyBybe7o5AEB
	 ZWYRqo6W6+VIjrMvyQwxG7bKAqnGdcO8H8TaCXnZG0e8026bxQgnF3iMko/M34FI+T
	 g2gaBSFtinvoGU/yLlyXc3L6SIEXxbMIvspOt6ErD/8e8JY6yKyzFIz7l+kLAraTsZ
	 eLyfEpBEhVVOCagFgORMSXzO03eqQw2tIrxlA2gTeAZqzfbUvE9l0tkLolqMNx8oZt
	 I/O1wtttZUi3A35VAaf1intH24uKU+3kuvV7FW5AZ8ohdKlSZUqzKSgGSagwIT9jDC
	 QJWZFyC/PZ/9A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qVywp-0055Sd-IT;
	Tue, 15 Aug 2023 19:39:19 +0100
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
	Jing Zhang <jingzhangos@google.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v4 16/28] KVM: arm64: nv: Expose FEAT_EVT to nested guests
Date: Tue, 15 Aug 2023 19:38:50 +0100
Message-Id: <20230815183903.2735724-17-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230815183903.2735724-1-maz@kernel.org>
References: <20230815183903.2735724-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, jingzhangos@google.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we properly implement FEAT_EVT (as we correctly forward
traps), expose it to guests.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 315354d27978..7f80f385d9e8 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -124,8 +124,7 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
 		break;
 
 	case SYS_ID_AA64MMFR2_EL1:
-		val &= ~(NV_FTR(MMFR2, EVT)	|
-			 NV_FTR(MMFR2, BBM)	|
+		val &= ~(NV_FTR(MMFR2, BBM)	|
 			 NV_FTR(MMFR2, TTL)	|
 			 GENMASK_ULL(47, 44)	|
 			 NV_FTR(MMFR2, ST)	|
-- 
2.34.1

