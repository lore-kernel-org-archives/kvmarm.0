Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F377B23537B
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 18:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740594714; cv=none; b=BAwntO7ZCevbY/svhQH8BwR1Gjh3Xovmlf42POhwL1fOQVl/5ikYf9Ny7TuUme9TyVFlpAVdVx3D0dVvfmgcIJCpJmVK+vS1udJs/jkX6c8B+c7MWIvhUu/0Zpdl9wkjA2zVLnRkCW+B3egB7OFvqCj8qu801+BTSsE1G0n2DTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740594714; c=relaxed/simple;
	bh=+UBLu55IaV+OphTJkJ8+4uHu9d+ODF7McAW363s8hKw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cTU8nkyBpZj8Gtedh8PU4bc6PWBeOZOk5oqATo6q5/Le7kj7LhA3BYAu2jaCD57WdVW5DULrla8WIQlI7QSOWWCaLZe/7+5A1haM+S0RnOkyXA07nEx7jA++6LQNtMVhhEC068xWi7TuW4XWyIiBUuYKl+mIV8y+9lTbi+gCMy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tkgPxskk; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tkgPxskk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740594711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wc0x3FobnOlqUDk8/XiBRKuNKuGDN2bTCY7cq1UmxY0=;
	b=tkgPxskkpQ2+rWSGjgF0cXBSEUGAwk7XW/gYldJTEXzDwW4Gswm7aFxlQoW4KYUD0UFwh9
	7Y8p3HB2ZFo2n8bOiZLd1pHadeBQqdZLcq9c1Ob6XiXYZEp34wL81/Awc/mC7e2mEicFR4
	Af1nZL5lwcHefHqNIBC5dnl16plQm6c=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 4/4] KVM: arm64: Document ordering requirements for irqbypass
Date: Wed, 26 Feb 2025 10:31:24 -0800
Message-Id: <20250226183124.82094-5-oliver.upton@linux.dev>
In-Reply-To: <20250226183124.82094-1-oliver.upton@linux.dev>
References: <20250226183124.82094-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

One of the not-so-obvious requirements for restoring a VM is ensuring
that the vITS has been restored _before_ creating any irqbypass mappings.
This is because KVM needs to get the guest translation for MSIs to
correctly assemble the vLPI mapping getting installed in the physical
ITS.

Document the restore ordering requirements necessary for GICv4 vLPI
injection to work.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Documentation/virt/kvm/devices/arm-vgic-its.rst | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-its.rst b/Documentation/virt/kvm/devices/arm-vgic-its.rst
index e053124f77c4..f0171aff1126 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-its.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-its.rst
@@ -126,7 +126,8 @@ KVM_DEV_ARM_VGIC_GRP_ITS_REGS
 ITS Restore Sequence:
 ---------------------
 
-The following ordering must be followed when restoring the GIC and the ITS:
+The following ordering must be followed when restoring the GIC, ITS, and
+KVM_IRQFD assignments:
 
 a) restore all guest memory and create vcpus
 b) restore all redistributors
@@ -139,6 +140,8 @@ d) restore the ITS in the following order:
      3. Load the ITS table data (KVM_DEV_ARM_ITS_RESTORE_TABLES)
      4. Restore GITS_CTLR
 
+e) restore KVM_IRQFD assignments for MSIs
+
 Then vcpus can be started.
 
 ITS Table ABI REV0:
-- 
2.39.5

