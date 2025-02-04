Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EEA2036FB;
	Tue,  4 Feb 2025 11:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738666856; cv=none; b=gA+8AdyQc2gotwYEUvWxm1jYsVpBR6ADJZRpjFGOdcFdMSQYXZkNBUM6VRO6yGxgx6epi+nQnsuiFyv6c5rWDjPmIOr6MpmjKNV1FcB6p/LzUindX10qyT7km8R6YSTnLfn3E87T4NvSQvRTLEFlCOQNw/s6B08AKo6J9mHECrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738666856; c=relaxed/simple;
	bh=zUnsuDJ9SEtgVgV4nZafL+jOte8yEfS+p4rbkLAt0yE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mtzv/WiTkN+HRo5H3kGRavQwqXW41bbaAxer7dEMZiZBmNMSOIjmigMhX5aPwVywJ9rbjRcZPcbDB6yaxYyZxZr/EqV9il/KBppcr3p16xFbkz1dY/AKP4EFAYD238InSsv3rxFvPNw2ZZzocLWmHPyRLfIbxJK3WkbC/6RYPtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BXqJEl5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BXqJEl5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF1AC4CEE4;
	Tue,  4 Feb 2025 11:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738666856;
	bh=zUnsuDJ9SEtgVgV4nZafL+jOte8yEfS+p4rbkLAt0yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXqJEl5FE86KtnSgh6caDW6MvW+Dkj8aqvM0MH72GVd/g2sG3AXgAB7D6bXxPsgSM
	 I2fOukfFjK+NeZ2dMZawZ4eiMWdvZ06OPT7nTTQRC41M3+2UtxAR4iGQTuEekRLA4Q
	 oD48RW7FnAvA+E0L2BGvAXPQWoYZ3Oen8/eZQGB0bG2enbVV7WbxUoQqUCTW0JFqDV
	 vu9xeYJK9WN2uZCyipo7MVV25Zx9bhBIXsR4Y+SmcLp9DZrpMYLe17Xam1fDlQ4Js3
	 XbjoUTxTjak9bWl4BpSY5kf4cezCzjK2+dumNP2tWh4gFmQiFfe3IAUT84sPWaHjcT
	 RNMrOKspiTUxQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tfGfm-000OVe-7Y;
	Tue, 04 Feb 2025 11:00:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Dmytro Terletskyi <Dmytro_Terletskyi@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] KVM: arm64: timer: Always evaluate the need for a soft timer
Date: Tue,  4 Feb 2025 11:00:48 +0000
Message-Id: <20250204110050.150560-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250204110050.150560-1-maz@kernel.org>
References: <20250204110050.150560-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, r09922117@csie.ntu.edu.tw, Volodymyr_Babchuk@epam.com, Dmytro_Terletskyi@epam.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When updating the interrupt state for an emulated timer, we return
early and skip the setup of a soft timer that runs in parallel
with the guest.

While this is OK if we have set the interrupt pending, it is pretty
wrong if the guest moved CVAL into the future.  In that case,
no timer is armed and the guest can wait for a very long time
(it will take a full put/load cycle for the situation to resolve).

This is specially visible with EDK2 running at EL2, but still
using the EL1 virtual timer, which in that case is fully emulated.
Any key-press takes ages to be captured, as there is no UART
interrupt and EDK2 relies on polling from a timer...

The fix is simply to drop the early return. If the timer interrupt
is pending, we will still return early, and otherwise arm the soft
timer.

Fixes: 4d74ecfa6458b ("KVM: arm64: Don't arm a hrtimer for an already pending timer")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/arch_timer.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index d3d243366536c..035e43f5d4f9a 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -471,10 +471,8 @@ static void timer_emulate(struct arch_timer_context *ctx)
 
 	trace_kvm_timer_emulate(ctx, should_fire);
 
-	if (should_fire != ctx->irq.level) {
+	if (should_fire != ctx->irq.level)
 		kvm_timer_update_irq(ctx->vcpu, should_fire, ctx);
-		return;
-	}
 
 	kvm_timer_update_status(ctx, should_fire);
 
-- 
2.39.2

