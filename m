Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7E023535B
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 18:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740594709; cv=none; b=fnCw05MLIweVXzjl/FYEteY+iig61DGkoN/lVwHA2XhH2XdDJXRQkHT1+Cpm+NDcDRHfs8l1TVirC/YoCdRdIVnF3A6whZQMeVx3o/18cLt6OaFBIHtssZ0QMCGmxeC65MRb1i91k1UnS/MVQnSrO7Uh8DaWJ0x+TDzPJpMX8+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740594709; c=relaxed/simple;
	bh=LuT7YV+ZviBUX2szwiifoDMkkoAYzA3CJn2r9kBDmhQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Xb+IjIFY70V68fzHwHcEUqM+iEJGcdd/DA0PDpSuWJB9/XPdUOAdrXUBMRSBishdNEp7EV2j9YRHQltUPq+ckhdnU1kBtpNlZdcYjn7dOykReZEt5BVWjcI+KZNWoclXGh4feWVaWcL098Wc8CsL1NH1BI+lLPOkJQ9hgQNE1X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=diMkGb0+; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="diMkGb0+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740594704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DCJw5GZkNA01tIfCSBttJ+HoDOu+nwstVV9jEwB65MA=;
	b=diMkGb0+Zt1olyMQVp9+4P6FlJwHcWqwmVGjSfoE0Dr0cqLu3c7kEFAm9Jzq8Nb/bOEhzH
	JgKW4QnMF76k8XYaFyfCHtL/wgqvM0JY5V+A+mdlchVkdrdsSeq17jLOSVnFidbM5mdtz8
	ENWZznZt0IlWTyQ9336FQUEownD8JLc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/4] KVM: arm64: Fixes/clarification for GICv4 vLPI injection
Date: Wed, 26 Feb 2025 10:31:20 -0800
Message-Id: <20250226183124.82094-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Small batch of fixes for vLPI injection issues that can happen when
userspace is being mean:

 - MSI interrupt sources could be mapped to non-MSI GSI routing entries.
   KVM doesn't account for the routing type and blindly attempts to map
   a vLPI.

 - KVM_IRQFD mappings could be installed before the ITS has been
   restored, leading to kvm_vgic_v4_set_forwarding() failing due to the
   missing guest translation

Prevent userspace from triggering a WARN() because of these issues and
gracefully fall back to software vLPI routing/injection should irqbypass
fail.

I've thrown in some documentation on the restore ordering necessary to get
GICv4 vLPI injection working correctly as well.

Marc, I'm planning to take these for 6.15.

Oliver Upton (4):
  KVM: arm64: vgic-v4: Only attempt vLPI mapping for actual MSIs
  KVM: arm64: vgic-v4: Only WARN for HW IRQ mismatch when unmapping vLPI
  KVM: arm64: vgic-v4: Fall back to software irqbypass if LPI not found
  KVM: arm64: Document ordering requirements for irqbypass

 Documentation/virt/kvm/devices/arm-vgic-its.rst |  5 ++++-
 arch/arm64/kvm/arm.c                            | 12 ++++++++++++
 arch/arm64/kvm/vgic/vgic-v4.c                   | 17 +++++++++++------
 3 files changed, 27 insertions(+), 7 deletions(-)


base-commit: 0ad2507d5d93f39619fc42372c347d6006b64319
-- 
2.39.5

