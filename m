Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6B330E83A
	for <kvmarm@lists.linux.dev>; Sun,  3 May 2026 07:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777793839; cv=none; b=KBmK8DsJUPYLe7RdCFwemm7HsIQvxygD4W1vKH7nOgNwWsZOYRoxuf2r0/W3Ci/t/3pinmdM8sp2O1ugRRJWtEiynagN4Gqd18Dgi7RiRPqUgb8f89OrobfCzF07buXNxUJyEmqcPQ5iqiAswKI+WrK/GjabwsKaoTnWhen48aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777793839; c=relaxed/simple;
	bh=UpiiJIvHg9KPBg6qr//rBF6BL8Etn+Y3DZXF0qwwl90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=QgPhGjuVToQ7cDWnJenHWLkbR3kOpFa03/MozQVnr0cntu4XwlXypTGhN8YPcVz7Cy8j4mQ2d7JsyK5bmmCE+1tK1N0YqK5zsr2oV8bE1TG9y5PkgTuXlCtuQFCkOzzXWts2/lwb1zCdwp8ypjSl8IqxLnLrJDjnlNGZMhmpQAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SfytYyt1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SfytYyt1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777793837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wMHufetHYJa4Ixy40r/OFgQsMVkW7F89Hja91OVyjGc=;
	b=SfytYyt1FRJc2TPT4DyRZ3jWMM/8MeEAknScSnmS1uEKQrkQvtjtkw3I8KQbljUpNq1PBB
	WHRJtWBDrVta3eCfocm9x6U1vcUxSZxNc0O3Z/yWt1XcxuYm0m0x2OCUVRDqd6YgubJFdk
	CeyBZo0QQlCHI3ZlnOcccTD56rdYYoU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-307-5lerwPEpOJC3Mmgt6Vcbuw-1; Sun,
 03 May 2026 03:37:14 -0400
X-MC-Unique: 5lerwPEpOJC3Mmgt6Vcbuw-1
X-Mimecast-MFC-AGG-ID: 5lerwPEpOJC3Mmgt6Vcbuw_1777793832
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD9F51800352;
	Sun,  3 May 2026 07:37:12 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.25])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D62A61800480;
	Sun,  3 May 2026 07:37:07 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	cohuck@redhat.com,
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
Subject: [PATCH v4 14/17] target/arm/kvm: Special case ID_AA64ISAR0_EL1 RES0 [24, 27] bits
Date: Sun,  3 May 2026 09:33:34 +0200
Message-ID: <20260503073541.790215-15-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-1-eric.auger@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: tejPe4rMnfol0Pz_GupzUKRvnaKwtOIhLevu4CFnf1w_1777793832
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

RES0 [24, 27] bits seem to be reported as writable by the kernel.
This corresponds to former TME field that was turned to RES0 after
FEAT_TME removal from the architecture.

See kernel commit d65bf6e317e7b ("KVM: arm64: Remove all traces
of FEAT_TME") for additional info. However the kernel still exposes
it at writable. Until this gets fixed, Let's ignore those bits.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/kvm.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index f3aecef35c..18373b0936 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -430,10 +430,13 @@ decode_idreg_writemap(Object *obj, int index, uint64_t map, ARM64SysReg *reg)
         char *prop_name;
 
         if (!field) {
-            warn_report("%s bit %d of %s is writable but no named field "
-                        "in target/arm/cpu-sysreg-properties.c",
-                        __func__, i, reg->name);
-            warn_report("%s is target/arm/cpu-sysreg-properties.c up to date?", __func__);
+            if (strcmp(reg->name, "ID_AA64ISAR0_EL1") || i < 24 || i > 27) {
+                warn_report("%s bit %d of %s is writable but no named field "
+                            "in target/arm/cpu-sysreg-properties.c",
+                            __func__, i, reg->name);
+                warn_report("%s is target/arm/cpu-sysreg-properties.c up to date?",
+                            __func__);
+            }
             map =  map & ~BIT_ULL(i);
             i = ctz64(map);
             continue;
-- 
2.53.0

