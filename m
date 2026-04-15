Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556D637C110
	for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 11:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776254184; cv=none; b=SbVdNqUKHDeA9DeENF4zBTZJXugMw7jYb+C95F9HUN5JlU0OgLEtfYsLLkuX6pAUQQU8HNqeURcntQndVmifAdiEAcGoFUlp2GDBtStnFcgPvahpqDWhdXqB/SOJpeCwKreXV3/QgSeIZqyALMZcHvawwBwQqK8Php+JIOU+EhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776254184; c=relaxed/simple;
	bh=rRhz56yIoRfzm5lLrNbTpKXQobUyeg4eP1h1LUt2eq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rntnN28bN3+Fnv7reUL3RbfRkjiNZfo3ug2yDxO/8s5GMFdwRXgmwtQIbGmUe14RVsl6/LhnN+noQLZaUeRJEywKYer9UJIZr7nRTa2ivZba8B2iTCCq2yvSsIWwUfoa483WPO3lCsdc5Fqj89+cA4lkkPLLlkl6OFqtfYYVA+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rywnk2Kp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rywnk2Kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316DDC2BCB3;
	Wed, 15 Apr 2026 11:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776254184;
	bh=rRhz56yIoRfzm5lLrNbTpKXQobUyeg4eP1h1LUt2eq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rywnk2Kp62odGRynhLhGFWi4bKCBQBgNwc3krmVwU5+fWGNbJFLU5L5e4+11oU66U
	 VlzTDtfQZf5IcVXwdS2S+2Fw50gCToyrTUkrfZJAS5JxH0OpKFFRSCX+ARJF6c1AVU
	 o8y7TL5YAoyQLpFWPvCrHays5DY4RozaQ4QqaEAWOTZ08cNpeio1xg+UmokRzpejjA
	 vi0RaH/6FtZha3U9TPkpiPHSuz6fExWmnkreOxtUHB/fwrz+sPjVh2Mq5tVI/XW/BN
	 9vULtXrPbOcRHmSNkHs0Lm52EBaNS9PZQabJgk4ngCJWErbfp/AYonSA/8uXkP7IIO
	 JXeCvLvyaWAww==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wCyr0-0000000Bqsi-1ZS1;
	Wed, 15 Apr 2026 11:56:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 16/18] Documentation: KVM: Clarify that PMU_V3_IRQ IntID requirements for GICv5
Date: Wed, 15 Apr 2026 12:55:57 +0100
Message-ID: <20260415115559.2227718-17-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415115559.2227718-1-maz@kernel.org>
References: <20260415115559.2227718-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Sascha Bischoff <sascha.bischoff@arm.com>

When running a GICv5-based guest, the PMU must use PPI 23. This,
however, must be communicated via the
KVM_ARM_VCPU_PMU_V3_CTRL->KVM_ARM_VCPU_PMU_V3_IRQ ioctl as a full
GICv5-style Interrupt ID. That is, 0x20000017. Optionally, the whole
ioctl can be skipped for GICv5.

This was previously not clearly documented, so bump the documentation
accordingly.

Fixes: 7c31c06e2d2d ("KVM: arm64: gic-v5: Mandate architected PPI for PMU emulation on GICv5")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/devices/vcpu.rst | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 5e38058200105..66e714f2fcfa7 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -37,8 +37,11 @@ Returns:
 A value describing the PMUv3 (Performance Monitor Unit v3) overflow interrupt
 number for this vcpu. This interrupt could be a PPI or SPI, but the interrupt
 type must be same for each vcpu. As a PPI, the interrupt number is the same for
-all vcpus, while as an SPI it must be a separate number per vcpu. For
-GICv5-based guests, the architected PPI (23) must be used.
+all vcpus, while as an SPI it must be a separate number per vcpu.
+
+For GICv5-based guests, the architected PPI (23) must be used, and must be
+communicated as the full GICv5-style Interrupt ID, i.e., 0x20000017. This ioctl
+can be omitted altogether for a GICv5-based guest.
 
 1.2 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_INIT
 ---------------------------------------
-- 
2.47.3

