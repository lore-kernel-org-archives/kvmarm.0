Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AC82F8E8E
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570119; cv=none; b=JIvb6wA4UgosFVmF1wLNc96ysreBPm0OqDP94Qe/VmS8ej7Z0HPcRMWf4G1NfarQZKVgMXazTVtxYo8AAHI7W5FAZIwIwH8YFOEREQNYVfC1SOvq7M2/WaaJTUVQDqDec0SjRcLeXtET+KDN0APakr/onDHyIIXIogyAgIpo+60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570119; c=relaxed/simple;
	bh=CuJhHJtQl9XXPTdLQ5DFeNv0bz50j2n0GnVOZo6Xs3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=dMSIl13RZxcTauvYu9YsPTl7wDrOIP9KypK6Ty93fuFkO5DgKT7j7YsUkZcSZ1sHDofwjh7ZP+bJ9tEz/lbKFL+FBLPHqhthr6gTbuUqNs65FxQ4l+JmlVRWz66fQL3XhS9XW3IVYnvT0Dgpj/VQdlEbVZVgbyKNmpKl7vgODh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PWT4ceLH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PWT4ceLH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=auaxCeauN5FRu8T5yqwMoXwguxD+0OITVntUuaq37ic=;
	b=PWT4ceLH5uyDDOowc3F8ykwt131QK+eGcLxG99pE17lt/h5ThTELUExiOjhssuhtZGhbxz
	yngVm2lXPeiaPDS6vtIFwBO8Kwpe+CADw+mmtMdKc3sx+/9LxyFEcUx9kW61U+cgeh076n
	WH0GmbHI56n6JPCkFZenxzUZEPV57fc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-142-uLQDbddgMZye66wB3cnBIg-1; Wed,
 16 Sep 2026 10:48:32 -0400
X-MC-Unique: uLQDbddgMZye66wB3cnBIg-1
X-Mimecast-MFC-AGG-ID: uLQDbddgMZye66wB3cnBIg_1789570110
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 572F718000A2;
	Wed, 16 Sep 2026 14:48:30 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B847419560AB;
	Wed, 16 Sep 2026 14:48:25 +0000 (UTC)
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
Subject: [PATCH v9 11/26] hw/arm/virt: Make sure virt_get_caches() keeps on reading CLIDR_EL1 as 0
Date: Wed, 16 Sep 2026 16:45:34 +0200
Message-ID: <20260916144721.751810-12-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: rWtGUGAvrNi0N5j4f7U1YtWPRpxA9_Q2t7S_K76thXQ_1789570110
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
---
 hw/arm/virt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 0871a35e11..6c87ac133a 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -342,6 +342,10 @@ unsigned int virt_get_caches(const VirtMachineState *vms, CPUCoreCaches *caches)
     ARMISARegisters *isar = &armcpu->isar;
     uint32_t clidr = GET_IDREG(isar, CLIDR);
 
+    if (kvm_enabled()) {
+        clidr = 0;
+    }
+
     for (int cache_level = 1; cache_level <= CLIDR_CTYPE_MAX_CACHE_LEVEL;
          cache_level++) {
         uint8_t ctype =
-- 
2.53.0

