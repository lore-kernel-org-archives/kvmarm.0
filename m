Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9135A2882B7
	for <kvmarm@lists.linux.dev>; Wed, 22 Apr 2026 10:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776852135; cv=none; b=EWEeJ3L/lUVuw0XHtLe1EW3komFQEtyUlo/m/Ys97LF+/YcXFqcAo7ymRHI17WT31sW/ULUTVSocGaNkB+2vtvlVKD5UZSmHQvR7zim07xvzPKVxV8QsKQnsMRrORQeGsIhFH/0DIWhH4OnVgi7ZomXobscaRxFCf9EX7ov10i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776852135; c=relaxed/simple;
	bh=CAENVGjFPxxWtImA7zgQfAthvhtq8a+aFK/+ljYO1Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M8tUKt9dTp7Ay1UYHCg2q6zHLqT73TsmY5iGWUHfLOderlH8FwR1hbih5t0D0rvOSWaVtAZZnutUV8rHO68JgLSoVaIVMpWMzS1UZyn+3BD8nTarEIyh+SeSS0wW+ywP4MH67UatPKMd+BUBaYx6ZqXqbTiHRJcPDzKg0g/c0ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJx2EcP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJx2EcP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D522C19425;
	Wed, 22 Apr 2026 10:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776852135;
	bh=CAENVGjFPxxWtImA7zgQfAthvhtq8a+aFK/+ljYO1Ug=;
	h=From:To:Cc:Subject:Date:From;
	b=GJx2EcP8+mnz9DvvkP1d5d+2fddC0Jtul303doqqShuQWhC+/LZ8TiMtDnGSDcxin
	 y1cc+iGhOQTMqMFdLY1/5WPqzThU1hWPFVd6jYw6AZH7Sy1VmB7BTLmtRiHZYgAiY/
	 Ukw8EE5RP/egZdweR5OC0WM+FjfMroHTvI6XqM9m/z/6O6EUQnWFMbbQs/Y2+yuRbw
	 U6ausK8qdtuocnYM1gbFFsAh/bHZB0A2GxebLxHeAUCnroPDgbu+X3Js3heczwnMW7
	 tQ+YeCC06Z+DjzdzcJG5Cj4RnRnYVEGCbrmUtDYuLU63+l8z5P7FXzi6X4NKgETTH6
	 pwUILU1gJETJw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wFUPM-0000000Dh6d-3tH4;
	Wed, 22 Apr 2026 10:02:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 0/4] KVM: arm64: Don't perform vgic-v2 lazy init on timer injection
Date: Wed, 22 Apr 2026 11:02:06 +0100
Message-ID: <20260422100210.3008156-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kartikey406@gmail.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is the second version of this series aiming at fixing issues
with vgic-v2 being initialised from non-preemptible context.

* From v1 [1]:

  - Repaint kvm_timer_irq_can_fire() to kvm_timer_enabled()

  - Drop duplicate kvm_timer_update_status() call

  - Force lazy init on the irqfd slow-path for SPIs

[1] https://lore.kernel.org/r/20260417124612.2770268-1-maz@kernel.org

Marc Zyngier (4):
  KVM: arm64: timer: Repaint kvm_timer_{should,irq_can}_fire() to
    kvm_timer_{pending,enabled}()
  KVM: arm64: timer: Kill the per-timer level cache
  KVM: arm64: vgic-v2: Force vgic init on injection outside the run loop
  KVM: arm64: vgic-v2: Don't init the vgic on in-kernel interrupt
    injection

 arch/arm64/kvm/arch_timer.c      | 59 +++++++++++++++-----------------
 arch/arm64/kvm/arm.c             |  7 ++++
 arch/arm64/kvm/vgic/vgic-irqfd.c |  6 ++++
 arch/arm64/kvm/vgic/vgic.c       |  6 ++--
 include/kvm/arm_arch_timer.h     |  5 ---
 5 files changed, 43 insertions(+), 40 deletions(-)

-- 
2.47.3

