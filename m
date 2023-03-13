Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BF42571
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 12:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24088C4339C;
	Mon, 13 Mar 2023 12:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678711734;
	bh=CMYI7NCjXkkq8RKyRgm82qexoeOMACscNwYRQyYIBGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QSn2+FAWlYC9p2zbv40Q9zTVKKIXe32rbGiEJq9r4XDds6l0KHRM5TUmCxq576ezT
	 XCpx6bESHcTWZoFPDGw8P93RJK6+z64Bount5aFktO2jrlzdySsKjjV9l3ZQG4Lylj
	 tcDHhPvkrbKPUFpK1OIX5VxCwuXPaE1/U1Lvq+1B2SQDjO9MH4n3Qhxr/eCvYBSbvV
	 iFUOeElbMf/oivQkEfSEtM4Bq7aeE6DkuovYZmTtNrtU2M3GW5Un6tmu0x30gLwhKJ
	 mc6Qt7Rcsm1Gz9MjO4x2DKXJYeh+21iB0qkM4BRTb6iESGsD9CbLPd4cEvbHC2ctkO
	 gOYk2l+zspeiQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pbhbg-00HEdE-0C;
	Mon, 13 Mar 2023 12:48:52 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>,
	Simon Veith <sveith@amazon.de>,
	Reiji Watanabe <reijiw@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	dwmw2@infradead.org
Subject: [PATCH v2 02/19] KVM: arm64: timers: Use a per-vcpu, per-timer accumulator for fractional ns
Date: Mon, 13 Mar 2023 12:48:20 +0000
Message-Id: <20230313124837.2264882-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313124837.2264882-1-maz@kernel.org>
References: <20230313124837.2264882-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Instead of accumulating the fractional ns value generated every time
we compute a ns delta in a global variable, use a per-vcpu, per-timer
variable. This keeps the fractional ns local to the timer instead of
contributing to any odd, unrelated timer.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c  | 2 +-
 include/kvm/arm_arch_timer.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index e1af4301b913..9515c645f03d 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -212,7 +212,7 @@ static u64 kvm_counter_compute_delta(struct arch_timer_context *timer_ctx,
 		ns = cyclecounter_cyc2ns(timecounter->cc,
 					 val - now,
 					 timecounter->mask,
-					 &timecounter->frac);
+					 &timer_ctx->ns_frac);
 		return ns;
 	}
 
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index c52a6e6839da..70d47c4adc6a 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -44,6 +44,7 @@ struct arch_timer_context {
 
 	/* Emulated Timer (may be unused) */
 	struct hrtimer			hrtimer;
+	u64				ns_frac;
 
 	/* Offset for this counter/timer */
 	struct arch_timer_offset	offset;
-- 
2.34.1

