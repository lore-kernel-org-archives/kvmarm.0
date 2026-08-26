Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3E03546D6
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 09:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787737187; cv=none; b=Xharzxpwals3wQqrC7HdJRvyGNzm1v3dbWfcHjghlo9EUGN1q6e7SP7mlRY2Rf6tiWBma8GlzryVywL6UVt1B2lWdc7UYKS7pQ39O/o24k1eJ+28Li8yGt7GB5bFlmhCQlI6S5dGSDW4nofUc6nDlRfu+NuxLf38ATv4qnklgkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787737187; c=relaxed/simple;
	bh=iShpXbKGUeBYCpVXfhhlhYPryNvF6w03J5fu+gsY01o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ghyb/NPiYixzt7/sG8enF6ML7w5XXi4CPV89dIejPUeBmph3JKcPtTJf5fBBXVj0sgZp2/tGNQBAkegdDGx5rbjtHb/fHUTIFI4nfGThYzHFv+eVtwAqhNdeiErmUplp3RdzjoevqNLlzf2p9fYmA/yo/qo964GJWad+q+y0Q54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VsA/+12B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VsA/+12B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787737185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S9NW8uY0H3t/xMF0HVs8RIaDYTYa9wgmnjlDh5j8iNs=;
	b=VsA/+12BVA+Zx6buO+rhIhfzj8aZD/w9mxBogPm9Btocit3ecDkh+8ec7gSxYmIg9RSBwz
	d31DsierDIu7nUxkV9tuAMWX69zvxnDMNFyzNrK2CZOsc5T9v7rY/ucAe7qTaE2VBGRT2N
	9CGfNA48SMEBdIu491u823Vjmi6ZeV8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-107-WoproYHEMNCcFKubrG-GRA-1; Wed,
 26 Aug 2026 05:39:39 -0400
X-MC-Unique: WoproYHEMNCcFKubrG-GRA-1
X-Mimecast-MFC-AGG-ID: WoproYHEMNCcFKubrG-GRA_1787737176
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6A64180AEFB;
	Wed, 26 Aug 2026 09:39:36 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.93])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 745A11955F05;
	Wed, 26 Aug 2026 09:39:30 +0000 (UTC)
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
Subject: [RFC PATCH v8 15/20] target/arm/kvm: Ignore and trace unexpected writable reserved fields
Date: Wed, 26 Aug 2026 11:36:20 +0200
Message-ID: <20260826093747.1670077-16-eric.auger@redhat.com>
In-Reply-To: <20260826093747.1670077-1-eric.auger@redhat.com>
References: <20260826093747.1670077-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: o_kNeFYJGuXhiwcci3D7WqKz0sziwp4DQXg0LGQeO9A_1787737176
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

KVM currently reports some bits as writable whereas they are
RES0 or RAZ. The code easily allows to do some sanity checking
for such inconsistencies. Let's add a trace event when this is
encountered and skip the field

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/kvm.c        | 8 ++++++++
 target/arm/trace-events | 1 +
 2 files changed, 9 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 2557d7b0d9..8ec9bc51cd 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -433,6 +433,14 @@ decode_idreg_writemap(Object *obj, ARM64SysReg *reg)
         }
         lower = field->shift;
         upper = field->shift + field->length - 1;
+
+        /* Sanity check the field is not a reserved field */
+        if (strstr(field->name, "RES0") || strstr(field->name, "RES1") ||
+            strstr(field->name, "RAZ")) {
+            trace_unexpected_writable_reserved_field(reg->name, field->name,
+                                                     lower, upper);
+            continue;
+        }
         prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name, field->name);
         trace_decode_idreg_writemap(field->name, lower, upper, prop_name);
         object_property_add(obj, prop_name, "uint64",
diff --git a/target/arm/trace-events b/target/arm/trace-events
index d72ad6b671..e67730de6b 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -19,6 +19,7 @@ decode_idreg_writemap(const char* name, int lower, int upper, char *prop_name) "
 get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
 set_sysreg_prop(const char *name, uint64_t old, uint64_t mask, uint64_t field_value, uint64_t new) "%s old reg value=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new reg value=0x%"PRIx64
 nb_sysreg_props(const char *name, int count) "%s: %d SYSREG properties"
+unexpected_writable_reserved_field(const char *reg_name, const char *field_name, int lower, int upper) "Unexpected writable reserved field: %s.%s [%d,%d], skip it ..."
 
 # cpu.c
 arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
-- 
2.53.0

