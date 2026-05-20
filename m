Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31243955C4
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 10:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779271330; cv=none; b=N6QQfLH9RSoE7brQStYKh/2ngYCCNWbp0c6ku8Dg7OyYRMXsVdJJoI2aDiMvZD0XajdfZ+mTeXLLL7ALD9Ax+d7L9DxI+bNbew73D75h235PF4zPV1pzZyUbwMSeqepmTxio4xmO6YMT8AfSGtthxt3j517NTrau2/KX/j9dC+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779271330; c=relaxed/simple;
	bh=NKWeBsBC3Q19ocUCLZpJ6Vj+ZvAvJl2uCOdhpse1xWg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G1Hg65rwt4W4gbmePYpB9ftQr5MdAc/uVbX3B8oob4+7XqYhDarflJbH9LEEyEa03fB/Iblv2THTLszvIiTNwfGVl31RIyIPSmOpm+Xe7/NonN23sAM6EqQuldJOxP+xU5HhfbokVWPsUs98t9zn77cOHepdqo6R/AKjahNxnIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aXkNCgHZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXkNCgHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852841F00893;
	Wed, 20 May 2026 10:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779271327;
	bh=ql9CCInuhftdsL7kbkDRka7hNjPyDsFIQiL7p3/R69k=;
	h=From:To:Cc:Subject:Date;
	b=aXkNCgHZPAiDzUZuAzHp8Dj1bjjcJX0fJKAaw3dSD5e49uPeOuW1p3ji1kr2vSnJ6
	 wF6n0neH3ovP32ME7vc7tlZcxqJSld3t5+aoA/SCfbVHeXxjY8WFP8znKjVjwyW/cR
	 7FIWKtS2rhhm1Iw9Fx/yxq3zbSXqSJFL16Lrn/2c1nHRHfOnpxx0VkHvqaVldtVE5W
	 aOcbb3GxKHC+mHG5koR2Z6rZjYOcahZva3dWuzpc7MU50tLnyBAfStmHWy5pD5ReZr
	 cRfqMvWpk+uYklGDQ33qSh8/6/wR571eP9JA1H+yfPXdpL3odsGbJgJMDPxAfNu+B2
	 zBDY1z43NLZiw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPdkb-00000004Jio-1MxN;
	Wed, 20 May 2026 10:02:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 0/6] KVM: arm64: Don't perform vgic-v2 lazy init on timer injection
Date: Wed, 20 May 2026 11:01:54 +0100
Message-ID: <20260520100200.543845-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kartikey406@gmail.com, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is the third version of this series aiming at fixing issues with
vgic-v2 being initialised from non-preemptible context.

* From v2 [2]:

  - Remove the PMU's irq level cache which was hidding in plain sight

  - Simplify the userspace notification of interrupt level update

  - Additional comment clarification in patch #1

  - Collected RB, with thanks

* From v1 [1]:

  - Repaint kvm_timer_irq_can_fire() to kvm_timer_enabled()

  - Drop duplicate kvm_timer_update_status() call

  - Force lazy init on the irqfd slow-path for SPIs

[1] https://lore.kernel.org/r/20260417124612.2770268-1-maz@kernel.org
[2] https://lore.kernel.org/r/20260422100210.3008156-1-maz@kernel.org

Marc Zyngier (6):
  KVM: arm64: timer: Repaint kvm_timer_{should,irq_can}_fire() to
    kvm_timer_{pending,enabled}()
  KVM: arm64: Simplify userspace notification of interrupt state
  KVM: arm64: timer: Kill the per-timer irq level cache
  KVM: arm64: pmu: Kill the PMU interrupt level cache
  KVM: arm64: vgic-v2: Force vgic init on injection outside the run loop
  KVM: arm64: vgic-v2: Don't init the vgic on in-kernel interrupt
    injection

 arch/arm64/kvm/arch_timer.c      | 106 ++++++++++++++-----------------
 arch/arm64/kvm/arm.c             |  39 ++++++++----
 arch/arm64/kvm/pmu-emul.c        |  31 +++------
 arch/arm64/kvm/vgic/vgic-irqfd.c |   6 ++
 arch/arm64/kvm/vgic/vgic.c       |   6 +-
 include/kvm/arm_arch_timer.h     |   7 +-
 include/kvm/arm_pmu.h            |   5 +-
 7 files changed, 94 insertions(+), 106 deletions(-)

-- 
2.47.3

