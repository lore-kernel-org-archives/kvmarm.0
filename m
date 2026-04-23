Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1710F37D137;
	Thu, 23 Apr 2026 16:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776962186; cv=none; b=t8FPzr5idMpd9fa5/uE8+gg4qJPnIiU53rCiiaFQGjtiQQbNh4mrj/CIIxDpu5KAAlKYEJ6mSfaWVPn01gSdLAm7TNY5Mrp4BgQZGhiOrmE/FC234ZFAjDcf9gy8R9VnqtX+B3Yx+fOUCn6BCHdVjYGX3Ed5JpJmAYsONWzEJAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776962186; c=relaxed/simple;
	bh=+ds0NJEr0kE5UiInXg4j6EEFq+upi2AL/UPD2beEDHw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DOYGCknSoLFy7h1XAmfIJLBRbLiF2ko3aDt9ftE6RIyYxR+86hEhTHPUb6bz76TzExINd1gB59WAZElzgUa+PN0UPTEoJ+GUWm/wG+ZB0NOLQ9Te6koWFkPxryXYHa9emIlc59HIufqFop45kjwyclJ6MLqw2XK1D+SsiHdiJ2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MFxUlvEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MFxUlvEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6273C2BCAF;
	Thu, 23 Apr 2026 16:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776962185;
	bh=+ds0NJEr0kE5UiInXg4j6EEFq+upi2AL/UPD2beEDHw=;
	h=From:To:Cc:Subject:Date:From;
	b=MFxUlvEil3p0G4/+Srcn1Lcv8ULKuz5MdQjip3z4jyrMDZoevDjCng49TzOKH9Fv3
	 dEk69l7bhwQeudKNavjKtkNShhpMJB/1SFTf3Pz2vMxn3cSNznEVSMojHW7Gik4F02
	 02YCjdt2DFw4iJJZ7A663518tvdF2eITdNnqbyHexDiw4uFQ23Sfykof2EOXoXZUAI
	 Q/x/5W1MH58mW9ZPe9bkpTVQg+Vs2cbcnGGOqgF0MGDgW4d+yqDaB75QXgCksYYFyM
	 5hBzl2IILNqzK0InB6PGcPYQxnALhyALO7CYvHYN9YblK1EmxBZBODAJQjBnrGFjJq
	 c69nqIqmrVWpQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wFx2N-0000000E7YO-0aR6;
	Thu, 23 Apr 2026 16:36:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Wake-up from WFI when iqrchip is in userspace
Date: Thu, 23 Apr 2026 17:36:07 +0100
Message-ID: <20260423163607.486345-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It appears that there is nothing in the wake-up path that
evaluates whether the in-kernel interrupts are pending unless
we have a vgic.

This means that the userspace irqchip support has been broken for
about four years, and nobody noticed. It was also broken before
as we wouldn't wake-up on a PMU interrupt, but hey, who cares...

It is probably time to remove the feature altogether, because it
was a terrible idea 10 years ago, and it still is.

Fixes: b57de4ffd7c6d ("KVM: arm64: Simplify kvm_cpu_has_pending_timer()")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 176cbe8baad30..8bb2c7422cc8b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -824,6 +824,10 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
 	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF | HCR_VSE);
 
+	irq_lines |= (!irqchip_in_kernel(v->kvm) &&
+		      (kvm_timer_should_notify_user(v) ||
+		       kvm_pmu_should_notify_user(v)));
+
 	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
 		&& !kvm_arm_vcpu_stopped(v) && !v->arch.pause);
 }
-- 
2.47.3

