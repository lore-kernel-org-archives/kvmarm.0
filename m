Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A592459E0
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 21:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752095682; cv=none; b=bcUQX/JwffHV0cPbsfUgMruVQ6K8p1EbEM8R9mEUvH8jpPzpbdKE4k9wpbHEm0bVLukdw85X35wopkUc283p9TrRIpxO5yKWeJHpr/ZIBEqVZjPU7rKDtKH+oD1/drEtYbAwUVpGsXbqR6rlz5fjCL+IAgZ/DsgyQvXwVvXvpS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752095682; c=relaxed/simple;
	bh=IZ9rKwuY1EZI8ALKF+ef02e0GZwWxqUQPI4YkLWWRhs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kwpYUQuCovqrDcWj5Ow4M8tw/eLqqnRL3L+Uk8Ety3bPMfp87f+G0LIGYAChNE9q/RZF5PR/Mnxj7tFcp5VpG5s1wbim3O2Vr/Tr8GUguYrvX82rbEM4GiZLYQBL2PGW+nzN5CTSglfVaWDQHNFemh7AW/6cIov04BRGXwpzZ9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aoIEmqGG; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aoIEmqGG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752095679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wGPnF0nbI2y2qT0LV0cxxWHG8MM6SL3+1YP5lvmU1EM=;
	b=aoIEmqGGHT4LpsodmpQMQQyNj19mamtNl8JPDHgDxyB9S9C9OaWLG4SE5XUHZylGK/Mc4r
	Xjv1ukOObAbsDprAEAl56Tb2xWbeE0D+yi5+B6Pc9U0I93gHK+u4YwQuUokn1y0o92BrWs
	hpVkuYdt4Q4zkFIL5+sWdiQgDtzSiVk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 6/6] Documentation: KVM: arm64: Describe VGICv3 registers writable pre-init
Date: Wed,  9 Jul 2025 14:14:17 -0700
Message-Id: <20250709211417.2074487-7-oliver.upton@linux.dev>
In-Reply-To: <20250709211417.2074487-1-oliver.upton@linux.dev>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
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

