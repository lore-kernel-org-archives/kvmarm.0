Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AF71F560B
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 06:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753338515; cv=none; b=qt/9zyHtm302xY/Pls1DQyxuWyYv9Fe8sQdUaZ8QvDJr49d2DM4lZ1y0xErWr4+LYhBz50XYDgXmvxOAbsWK8/9jMZFEsSPUT2A5PLKM9o9d0bfCfuf7F/MPnEAIGa6tJMx/0+HUATz2CS9yoG4QA0UX6ngAFHnVNwCIQ8tXSlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753338515; c=relaxed/simple;
	bh=IZ9rKwuY1EZI8ALKF+ef02e0GZwWxqUQPI4YkLWWRhs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XNKgZhx0fxEitfTOL7ii+FRBkeFhyeAfk+3Li39OV7F93TQ5/94cd7YqG5xePVqgNNdWUYAo0ynkrMz9ewl7qx1w9gqbQJdRsiOnNVkanikw3kI22zC1ycVcqM4HGq/+kOxzPh/Gs9SAzNydWXBNKUstU3MtdowBw5hrJh2sPR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VXeyVDlQ; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VXeyVDlQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753338511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wGPnF0nbI2y2qT0LV0cxxWHG8MM6SL3+1YP5lvmU1EM=;
	b=VXeyVDlQb6QPz8b5S1Yh4ZxgVbE1IJzsjLylYuFK5kRrg/yivM3S9bIclIup8OaKPFuO2t
	HyG5O7zLi0MDb7/5m3Wt+8pJS738CoG90WJOscFbLF2ZM4A/IeIspAhGJMdWcr4zEXkRG2
	Ak3dZeLbscjI/rT94q0JuGkiou+O6zQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eauger@redhat.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v5 6/6] Documentation: KVM: arm64: Describe VGICv3 registers writable pre-init
Date: Wed, 23 Jul 2025 23:28:05 -0700
Message-Id: <20250724062805.2658919-7-oliver.upton@linux.dev>
In-Reply-To: <20250724062805.2658919-1-oliver.upton@linux.dev>
References: <20250724062805.2658919-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM allows userspace to control GICD_IIDR.Revision and
GICD_TYPER2.nASSGIcap prior to initialization for the sake of
provisioning the guest-visible feature set. Document the userspace
expectations surrounding accesses to these registers.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Documentation/virt/kvm/devices/arm-vgic-v3.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
index e860498b1e35..c7a1cd22d814 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
@@ -78,6 +78,8 @@ Groups:
     -ENXIO   The group or attribute is unknown/unsupported for this device
              or hardware support is missing.
     -EFAULT  Invalid user pointer for attr->addr.
+    -EBUSY   Attempt to write a register that is read-only after
+             initialization
     =======  =============================================================
 
 
@@ -120,6 +122,15 @@ Groups:
     Note that distributor fields are not banked, but return the same value
     regardless of the mpidr used to access the register.
 
+    Userspace is allowed to write the following register fields prior to
+    initialization of the VGIC:
+
+      =====================
+      GICD_IIDR.Revision
+      GICD_TYPER2.nASSGIcap
+      =====================
+
+
     GICD_IIDR.Revision is updated when the KVM implementation is changed in a
     way directly observable by the guest or userspace.  Userspace should read
     GICD_IIDR from KVM and write back the read value to confirm its expected
@@ -128,6 +139,12 @@ Groups:
     behavior.
 
 
+    GICD_TYPER2.nASSGIcap allows userspace to control the support of SGIs
+    without an active state. At VGIC creation the field resets to the
+    maximum capability of the system. Userspace is expected to read the field
+    to determine the supported value(s) before writing to the field.
+
+
     The GICD_STATUSR and GICR_STATUSR registers are architecturally defined such
     that a write of a clear bit has no effect, whereas a write with a set bit
     clears that value.  To allow userspace to freely set the values of these two
-- 
2.39.5

