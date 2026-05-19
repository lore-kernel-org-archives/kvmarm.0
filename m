Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0402A285CAE
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 13:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779197466; cv=none; b=n7ixMPPB220c6HE9Ct7p6rYnKxTuEqK/o8H12kryPs59yA/uSZKvHZ58es48Qf9RH/9pFSaJX1enzTiI08BB2aunxx1weFRmhX7dcFmtK/1q9VO52fOr6o2CszRm4ckvRciJWnZzVgcLF32TyPPzZyOIliuyIVeLcpdmdSsWZ2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779197466; c=relaxed/simple;
	bh=jboTdsYIzxNLvjM7lmrcsbMhhyoczQfOtluc40LSclE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Eg4ASfzw1JbINzcIFOboW0vfMDVZyYHNN6gjhzHTBzvo0Bg/GCKhSawOh0nYb+qlmkrwATl+AokkbaAAo/pxCrbAXz/C5wtjilJsbP809QRGsrXAnapSWZEggsw37uR9/NqqmlIMxJ4TmGC05RoWv6gwzgiSFeRw3eiCgCPmvCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UgdorFcV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UgdorFcV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779197464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=16khiiboxEtagPZ7yiPX8BOR+daPNKuEG2RYsB0whyg=;
	b=UgdorFcVWg7gNsqWejXPr/dhUEfVD0VqVHHTmNfvewruWdK36JSa9NjNMheXIX0CHUPMcv
	2Ke8cSQZIpc/4f5Pe1kL39OibeFrCNwbzKdZr7itKl38wlLmL0rWUT/mRZavh8jC/AXwir
	SPbl4kSTakNTQ5eChisXCMXcdX+jWoo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-138-pV_ITPC0P8CtW3NVtGMRNA-1; Tue,
 19 May 2026 09:31:00 -0400
X-MC-Unique: pV_ITPC0P8CtW3NVtGMRNA-1
X-Mimecast-MFC-AGG-ID: pV_ITPC0P8CtW3NVtGMRNA_1779197454
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F5411956065;
	Tue, 19 May 2026 13:30:54 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.49.207])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7FE1E180034E;
	Tue, 19 May 2026 13:30:48 +0000 (UTC)
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
	philmd@linaro.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v5 15/18] target/arm/kvm: Ignore some writable bits that shouldn't be
Date: Tue, 19 May 2026 15:27:29 +0200
Message-ID: <20260519132905.145643-16-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-1-eric.auger@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: qZOzC7K5nqVisnDJzDRur2tED7FXyxdNG2EtAV3Vv74_1779197454
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

KVM currently reports some bits as writable whereas they are
RES0 or RAZ. This is detected because the code attempts to
match those bits against a named field and this later does not
exist in target/arm/cpu-idregs.h.inc.

Let's silence warnings until those bits get fixed in the kernel.

This was observed with v7.1-rc4 kernel.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/kvm.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 6373a66bbd..1688cc2106 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -405,6 +405,19 @@ static void get_sysreg_prop(Object *obj, Visitor *v,
     trace_get_sysreg_prop(name, value);
 }
 
+static bool ignore_unnamed_writable_field(ARM64SysReg *reg, int i)
+{
+    if ((!strcmp(reg->name, "ID_ISAR0_EL1") && i >= 28 && i <= 31) || /* RES0 */
+        (!strcmp(reg->name, "ID_ISAR5_EL1") && i >= 20 && i <= 23) || /* RES0 */
+        (!strcmp(reg->name, "MVFR2_EL1") && i >= 8 && i <= 31) || /* RES0 */
+        (!strcmp(reg->name, "ID_PFR2_EL1") && i >= 12 && i <= 31) || /* RES0 */
+        (!strcmp(reg->name, "ID_MMFR5_EL1") && i >= 8 && i <= 31) || /* RES0 */
+        (!strcmp(reg->name, "ID_AA64FPFR0_EL1") && i >= 2 && i <= 7)) { /* RAZ */
+        return true;
+    }
+    return false;
+}
+
 /*
  * decode_idreg_writemap: Generate props for writable fields
  *
@@ -426,10 +439,12 @@ decode_idreg_writemap(Object *obj, int index, uint64_t map, ARM64SysReg *reg)
         uint64_t mask;
 
         if (!field) {
-            warn_report("%s bit %d of %s is writable but no named field "
-                        "in target/arm/cpu-idregs.h.inc",
-                        __func__, i, reg->name);
-            warn_report("%s is target/arm/cpu-idregs.h.inc?", __func__);
+            if (!ignore_unnamed_writable_field(reg, i)) {
+                warn_report("%s bit %d of %s is writable but no named field "
+                            "in target/arm/cpu-idregs.h.inc",
+                            __func__, i, reg->name);
+                warn_report("%s is target/arm/cpu-idregs.h.inc?", __func__);
+            }
             map =  map & ~BIT_ULL(i);
             i = ctz64(map);
             continue;
-- 
2.53.0

