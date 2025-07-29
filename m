Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63E3286888
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753802578; cv=none; b=rvisTGFB+rkbQQU+0l5KgK8nQgoK9bt+cfs08j+MutZ0lxy9h+IeE1PxjRAHCSzBlUVp90bOAHdhIZIpaCjvp3vccxkxVPLH/zTEhmuuA95R/k+V7Iqxnvvld8pCvPG3B89NptUTVMFeXbLU7HvwaDvUjO+mQaZuVConxDKBp48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753802578; c=relaxed/simple;
	bh=hseLBQTrEFB4f6fju4juY96z7OxzUECRpgGZJB3QsOQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=A0b+JhGEMiZ6bSXKYiqndTl9HUTo1QmFHJzHokyQtS/18RdC7AHbHbUTRot1hL9Y2uUECzB9Wh9cY8PNavagOS4exygtXlt35oJs24aqmAnrUxezBf5WnXzAu3vXXU3XNb2YzoEMzlHOPd7QMp3JwblqFjKrRv9NVC6BtrmFxfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RY59qb/6; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RY59qb/6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753802573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PJjx0QYTwr2JaB/Ge91SELT0olAPYlfXk5Hk+cKdnso=;
	b=RY59qb/6MADi+e1J93VX1+8a0tYkXCCOoulvd88zSpRGRS9q94o6yCMfPVYvIQMVKeFVd+
	xQNdGmVsQw5ceJNY15w2jRf/vFoZOHFdBKsbTwoP7UDcKyp6VCNFMnhGH3VrJTzEQr8I98
	1iV/e3DzEQ6LTyLaOyzM+p2PkaYUPu4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] Documentation: KVM: Use unordered list for pre-init VGIC registers
Date: Tue, 29 Jul 2025 08:22:42 -0700
Message-Id: <20250729152242.3232229-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The intent was to create a single column table, however the markup used
was actually for a header which led to docs build failures:

  Sphinx parallel build error:
  docutils.utils.SystemMessage: Documentation/virt/kvm/devices/arm-vgic-v3.rst:128: (SEVERE/4) Unexpected section title or transition.

Fix the issue by converting the attempted table to an unordered list.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20250729142217.0d4e64cd@canb.auug.org.au/
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Documentation/virt/kvm/devices/arm-vgic-v3.rst | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
index 72c4534b10a8..ff02102f7141 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
@@ -125,11 +125,8 @@ Groups:
     Userspace is allowed to write the following register fields prior to
     initialization of the VGIC:
 
-      =====================
-      GICD_IIDR.Revision
-      GICD_TYPER2.nASSGIcap
-      =====================
-
+      * GICD_IIDR.Revision
+      * GICD_TYPER2.nASSGIcap
 
     GICD_IIDR.Revision is updated when the KVM implementation is changed in a
     way directly observable by the guest or userspace.  Userspace should read

base-commit: 18ec25dd0e97653cdb576bb1750c31acf2513ea7
-- 
2.39.5

