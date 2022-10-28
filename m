Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5F123AD
	for <kvmarm@lists.linux.dev>; Fri, 28 Oct 2022 10:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF58C43140;
	Fri, 28 Oct 2022 10:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666954454;
	bh=K2X563RbVS1OM58x/YhfoVroBF5xoDrdh5uLOVn7/T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSvyu4Xnav/CNn9qCsKdCPtRdQgjPQQgMfKRgMIfBOYnJf9nRZR1T/ThsWNPHqXvT
	 qe2uni7rkZgTQPQXOiCt7bIT/r3u97JtpW6j2q7dcbgbDNu92WPbKh873zuwXn4iZl
	 LK70FJ5uJaDS0YjwofvwOM9xPqlA6SVeUH9Q5XboTINYTzK/HS8FLULLtNFn0aZ6f3
	 cWfq9aTzlC/BT+nTB5WLuFNVynBXCZeYOgFr6iV5NiGge4/6kSv8/MZz8QBLG6+Ywx
	 cf2JnyzkuUIpR3zGyTCcRl/P7tUiECc+a1p0ANG1C6u/thO6+AIPKP5CVhdffXccvL
	 ioLx9FLVZyJ0A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ooN08-002E4C-C7;
	Fri, 28 Oct 2022 11:54:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	<kvmarm@lists.cs.columbia.edu>,
	<kvmarm@lists.linux.dev>,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Ricardo Koller <ricarkol@google.com>,
	Reiji Watanabe <reijiw@google.com>
Subject: [PATCH v2 05/14] KVM: arm64: PMU: Narrow the overflow checking when required
Date: Fri, 28 Oct 2022 11:53:53 +0100
Message-ID: <20221028105402.2030192-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028105402.2030192-1-maz@kernel.org>
References: <20221028105402.2030192-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20221028105353.-8bof7JLHeYME3WLuZoI8gs50a2TSO8dkgDpJz7DVy8@z>

For 64bit counters that overflow on a 32bit boundary, make
sure we only check the bottom 32bit to generate a CHAIN event.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 3724acefc07b..39a04ae424d1 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -419,7 +419,8 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 		reg = lower_32_bits(reg);
 		__vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
 
-		if (reg) /* No overflow? move on */
+		/* No overflow? move on */
+		if (kvm_pmu_idx_has_64bit_overflow(vcpu, i) ? reg : lower_32_bits(reg))
 			continue;
 
 		/* Mark overflow */
-- 
2.34.1

