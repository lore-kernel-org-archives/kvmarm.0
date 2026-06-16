Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9A0317142
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 13:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781616512; cv=none; b=OletkdLO658GaJoEzH+Mz7pIIlQzULLuoRIuiiOtVKXEko/shlnYFjMgmsDVQZo1XKggzIISQhYteRHfJ+y1ImpxK7roifdRLXgW5GrRq2+wc9N4JWbK/QxV6EB02wWphz2MUXjBWuohdjitBxAbcCLDV6Qz8LuQdVFP7WnZbMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781616512; c=relaxed/simple;
	bh=a4JnAf8Nyc3n5PD3cRjZF6e/rNA12ETz8tSAp/shZnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=CNWFzHy53xyEgAMLVqTFWtDJurFBPn7rr8/A/kQifob8r02Anl1j8FJ+OA/C2AFw7rqrJEl/u8YxmKxvR4jYt/h2jNEC0dEW7ElxeEUBGKVeSXMKd1JsHvSzATBu6A5lLJMaswMLd8hzvIfV2VQaRoYS3d6XMc317D8bdE+j2jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dPp4++cs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dPp4++cs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781616510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iiWgOdy0RqtOoE1IxywPHeIoO2TxlI32Vfz46laKIp8=;
	b=dPp4++csYMf3L9JvIrKPuhsdNH0NIBWJGafi497wc2wAtCEpLcufAvdt1ZL+9txjVznNPu
	OwRyi2yiH1GZbgQyYwE3YW0rfW16zoWNd3PFNsI9xXxyUePGGc/yte8iXoxyb/8rR8pjCm
	EHVhPSaIE3cHjGk9zKFWJViT4C2S0DY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-YeTqhneFPiKxH7fZYx_9jQ-1; Tue,
 16 Jun 2026 09:28:27 -0400
X-MC-Unique: YeTqhneFPiKxH7fZYx_9jQ-1
X-Mimecast-MFC-AGG-ID: YeTqhneFPiKxH7fZYx_9jQ_1781616505
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B9A31956052;
	Tue, 16 Jun 2026 13:28:25 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.30])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0762D3000203;
	Tue, 16 Jun 2026 13:28:18 +0000 (UTC)
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
Subject: [RFC PATCH v6 16/17] target/arm/kvm: Ignore and trace unexpected writable reserved fields
Date: Tue, 16 Jun 2026 15:17:03 +0200
Message-ID: <20260616132625.1732031-17-eric.auger@redhat.com>
In-Reply-To: <20260616132625.1732031-1-eric.auger@redhat.com>
References: <20260616132625.1732031-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: nsywxj4CC8O8f7nKf1cqNoe-d6fhexpKDEA6Nx380xQ_1781616505
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
index 54392f3077..90e069f582 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -434,6 +434,14 @@ decode_idreg_writemap(Object *obj, ARM64SysReg *reg)
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

