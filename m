Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9554371CF8
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639518; cv=none; b=N3x+7HFKj6NJgY84Aj7S65RFqDJsZbkoqL6K0OZTJJDmU0J0ER8/zkEsp3aOkg5p7c+iaK2Qq9KyY8HCpC6pwoVYAL+K9ouoGm289KmZzKjm9kykHtUXUnlCS8b7OLJyw9o5Xb0SXLuM7Xv8nkL+UzX91aYjgHuR5RqWXeJPRHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639518; c=relaxed/simple;
	bh=iOAviTymXHrZRSFX9nD4ePJcJbgTS/GhkCqVibjwUrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=DPBInljPVX50XdYNMUFrUAUJbs7gP/aftSBaulv9+vJCTaO9eqFlb7d8sTMOX1VPqtM0rC3rMFzrPQxVzPJuhPmjPh8RZnXr43dHGkoVcgKM0QGukNzD/NJwxIJytOBsOkD/Cw/U8HviyIBqWvMlcED93GG6muQBOCl2T3zudTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EsPzLuXh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EsPzLuXh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vbBNwYmdqWnLEJ+d5lcNwGr8+ZO1ZyY8BY+i6F3iv7s=;
	b=EsPzLuXhyUs3hgvtKAJfLhvIF9zkFTEVTyBoMjwGnAW9CTMu6OtHG7XcGvgkRRmkfqzRqu
	fXMExeVAoUo5Ev0BwdhuIBn4eUg7tjkYwttm2sH3MyylQvc0TOOA7+ypmO0AfpwP8mVi41
	xfSTsYtCdnC7KcMb3Ur3MoUl0KpCCoc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-uB2iRn8UPheDRXe62kqzeA-1; Sat,
 10 Oct 2026 13:38:32 +0000
X-MC-Unique: uB2iRn8UPheDRXe62kqzeA-1
X-Mimecast-MFC-AGG-ID: uB2iRn8UPheDRXe62kqzeA_1791639511
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E877C1953955;
	Sat, 10 Oct 2026 13:38:30 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 773C330000E5;
	Sat, 10 Oct 2026 13:38:26 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	shaju.abraham@nutanix.com,
	khushit.shah@nutanix.com,
	yangjinqian1@huawei.com,
	cohuck@redhat.com,
	richard.henderson@linaro.org,
	sebott@redhat.com,
	skolothumtho@nvidia.com,
	philmd@oss.qualcomm.com
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v10 11/26] hw/arm/virt: Make sure virt_get_caches() keeps on reading CLIDR_EL1 as 0
Date: Sat, 10 Oct 2026 15:36:15 +0200
Message-ID: <20261010133725.642498-12-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: c9AIRXGyFj9VNovFAfnpcdD815eJ3xFhtR5mc3fNrtg_1791639511
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

In KVM mode, virt_get_caches() currently gets a zero value for the
CLIDR_EL1 register. This is due to the fact CLIDR is never read from
host. This is a bug.

Soon we will initialize all writable isar.idreg[] from host and this
includes CLIDR_EL1. However we cannot directly fix the initialization,
first because it would change the way the guest is exposed caches in
DT/ACPI descriptions and because some host values would be rejected
by the current QEMU code, expecially in the case host has a unified
L1 cache which is currently not supported and triggers the following
errod: "Unified type is not implemented at level 1" error.

So this issue will be fixed separately.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Khushit Shah <khushit.shah@nutanix.com>

---

v9 -> v10
- add a comment explaining why we oveeride the clidr value
---
 hw/arm/virt.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 9d192515d8..f9a7beb584 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -338,6 +338,17 @@ unsigned int virt_get_caches(const VirtMachineState *vms, CPUCoreCaches *caches)
     ARMISARegisters *isar = &armcpu->isar;
     uint32_t clidr = GET_IDREG(isar, CLIDR);
 
+    /*
+     * Commit f669de70011 ("hw/arm/virt: add cache hierarchy to device tree")
+     * read the CLIDR value from the isar array but in KVM mode, this index
+     * was never initialized from host. Now we want to initialize all ID
+     * registers * from host and until this gets fixed, we need to override
+     * clidr to 0 to keep the compatibility.
+     */
+    if (kvm_enabled()) {
+        clidr = 0;
+    }
+
     for (int cache_level = 1; cache_level <= CLIDR_CTYPE_MAX_CACHE_LEVEL;
          cache_level++) {
         uint8_t ctype =
-- 
2.53.0

