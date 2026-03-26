Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F78840B6E4;
	Thu, 26 Mar 2026 15:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774539338; cv=none; b=OwNDtYi0/16n6d8cOV7bYaWiEDDBCnu3FWcaNm1P3yye/Hd+Jmq4k/dPLViLAGcnWcgOMOZuEX2I6GQltUFkNplCJFYyinAyQf851ZEfyBTKfixzd8+jFWGscySPoWZh8GNVT4a3HrVOW6ufBh7IbZKJHZxyMPjjYMNJBdlm7Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774539338; c=relaxed/simple;
	bh=X2z8X6rHDBS/ktebmAl20fvzse7Qj/XBiyUddzvLCrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwIwi4AkmfxJ8M70B9S20bAPr8T5Omz9xbTw5z5q9EycVrNK7v+oYtRq3zOpqpfh3/koGL8zLsT6ti0R3j4W/Y8f/na00T8CO4QZWEdb/0KubosJsWzCVO82QuLZq0mqAHF+ecJtXCz+w8cBBV/KB8ofrQ3avGm0rwbrcM1guA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UK98II3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UK98II3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821A3C2BCB0;
	Thu, 26 Mar 2026 15:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539338;
	bh=X2z8X6rHDBS/ktebmAl20fvzse7Qj/XBiyUddzvLCrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UK98II3EpKXhME17ddEr7eGlZV+vBC8M+crQBDRlwl6gqnAzfRbq92io3BqfZDOX8
	 JEMCRspC2uA/2f27pUJQzO9UnxUXUSprsnaB2jfvyiSqYxK55KHFAdZpX4HhoW4AlX
	 SU90DrJzMFfRMkAzQvX0X3Yn6QeEky+wUdiW4UIeOaURgsnfOs5Y8CGZ/d7BnDko58
	 27Efo1OOFIKGxLyNq5n2W1sgvc5J44ZkGW3b4ObGEKENeLMcPvyyYn/HTsdxw0NUKR
	 udod/3sNfHrFDsDw+S0IfuSD3HZqnaJHXOTAJQQX0gHienIEueOHvcSBTL9XCpgJUQ
	 wntOhpw1MWY6Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w5mkC-000000060II-3TUj;
	Thu, 26 Mar 2026 15:35:36 +0000
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
Subject: [PATCH 12/15] KVM: arm64: Remove evaluation of timer state in kvm_cpu_has_pending_timer()
Date: Thu, 26 Mar 2026 15:35:27 +0000
Message-ID: <20260326153530.3981879-13-maz@kernel.org>
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

The vgic-v5 code added some evaluations of the timers in a helper funtion
(kvm_cpu_has_pending_timer()) that is called to determine whether
the vcpu can wake-up.

But looking at the timer there is wrong:

- we want to see timers that are signalling an interrupt to the
  vcpu, and not just that have a pending interrupt

- we already have kvm_arch_vcpu_runnable() that evaluates the
  state of interrupts

- kvm_cpu_has_pending_timer() really is about WFIT, as the timeout
  does not generate an interrupt, and is therefore distinct from
  the point above

As a consequence, revert these changes.

Fixes: 9491c63b6cd7b ("KVM: arm64: gic-v5: Enlighten arch timer for GICv5")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 37279f8748695..6608c47d1f628 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -402,11 +402,7 @@ static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
-
-	return kvm_timer_should_fire(vtimer) || kvm_timer_should_fire(ptimer) ||
-	       (vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) == 0);
+	return vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) == 0;
 }
 
 /*
-- 
2.47.3

