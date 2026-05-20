Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600723BFE20
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 09:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268817; cv=none; b=EJzMKeoRdcFBmLmBTbckCzIRLDjjM6JmU1TSpEK746ClQ8o84BCO4GCmSmAU4KscgKi1+/ItbiOK5UWSBTGO5x3kE/cvpFevKiRLcsSoa/mRHbYw7cKKOv9wztYbld4X7t52MmF9uDMaB4DDPfgfD4fqyXuDtjkjADEqnGcXMTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268817; c=relaxed/simple;
	bh=rRhz56yIoRfzm5lLrNbTpKXQobUyeg4eP1h1LUt2eq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEq9RNZmBPAnU+mj5MTAck0ZCbUUEcDmVa9hrmfadirHrRgIi+lPp5GmRlhLQOICu78X7OtUVWvDqV8+8TTT1LqZr45flYDmXZS1+Q+sqqD5MWAyXKTccPqzwmaGaFH3FMvOJCU5JwqouO/m43hTbhFdhmiWlrNxnixRtdG6Ik0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M8uW/XzS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M8uW/XzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383761F0089B;
	Wed, 20 May 2026 09:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268815;
	bh=02qnO6q+Y2WyzRZ55saENhptxHHaPB8mtl4fEi4I0kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8uW/XzSvbnK2eY1XJNbp8dQ8hAmyed5meicw52xAMVS1dvBuD/aYpbXKYI9/s8lO
	 pjugGCFR8NFnATvFURdBLDd3Dh0Gk4L70Vp3PPNQnndpOGo6OOpZ1NgAQmhbWZtnQU
	 xhbNG9Bx82nYL1cIJ/95E1PoG3DOwzvn4pdZ03wi/3+3v4KBvy+OXeOffsxkkqZb8y
	 cp5DrR4s8Hv4wxbD8bqAdbNdSmvUv6U02ob7VDUeJB4ytfJvVqU2PvwiNKGzWGv0nB
	 FfUGQ12E2R4JEaLG6lPwd84b+vBuSIGP99ATAtBs0RrhQMhiITlmslg0i99iMLIhHh
	 baymaWCsaSw2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPd65-00000004IaV-2OOx;
	Wed, 20 May 2026 09:20:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH v2 16/18] Documentation: KVM: Clarify that PMU_V3_IRQ IntID requirements for GICv5
Date: Wed, 20 May 2026 10:19:47 +0100
Message-ID: <20260520091949.542365-17-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520091949.542365-1-maz@kernel.org>
References: <20260520091949.542365-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
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

