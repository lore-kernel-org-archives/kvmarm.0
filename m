Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD231A5B90
	for <kvmarm@lists.linux.dev>; Sun,  3 May 2026 07:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777793812; cv=none; b=K04O1rfl7Ch+zJVt0d0SEG6q3B13Q4F/BIHmgv95+3lQ2sXSKqkujnlAbW4ZIQcJEevSLLF1eppzXIDOtDVfzVB9+rhAHLc6XnmtAUBN1DtWcpE9m24Of5ivdHHX/JXetw2iyYYJBcZwTmo8pxR36pBCTmKLoP/VqxI9HuuNeb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777793812; c=relaxed/simple;
	bh=0yUI9Kgjzm+s6mOjKym1/+0yfqUPPLYb+tsBH81CK4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=h6jh8HucQ4P7FBfWFF8VLtTMboBOTWWCx1k036syPM2Lxm7UMKJSFIEtT9KCTE9RidrUQcGiPnCf/lZ5m5o8rWMyZDU4bBFT+8ufmQwad3Vwey3cj+LOcoM0FhJP5QD4Jbg7P/5lEvZ4mu6/Z8qoTStfHpOQgt5P90oOp9wrRhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CDw3sc7F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CDw3sc7F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777793809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=557ybO8Fo2cuy3bEAfcP6Q/Qbo00s1S/okkhzC4QXa4=;
	b=CDw3sc7FXqg4qvv5d2TpswXiigTNhk7+Qhh7dVQFQfPDVedbOd07Q6f7+IbyIQu7+rwuvQ
	SGyQ2/Wxjsmq7YxHZo/+VylAYXbPZqqS7aQ9yJtgLoQqYfest8JwWs7yUfm06IULS7NLgS
	E3A5QBpDLtQLH48lCP3aJApqYXzK21M=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-504-ljsCbmcJOf-NUPTUsfrLfA-1; Sun,
 03 May 2026 03:36:46 -0400
X-MC-Unique: ljsCbmcJOf-NUPTUsfrLfA-1
X-Mimecast-MFC-AGG-ID: ljsCbmcJOf-NUPTUsfrLfA_1777793805
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF25619560B4;
	Sun,  3 May 2026 07:36:44 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.25])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AAF7B1800345;
	Sun,  3 May 2026 07:36:39 +0000 (UTC)
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
Subject: [PATCH v4 09/17] arm/cpu: accessors for writable id registers
Date: Sun,  3 May 2026 09:33:29 +0200
Message-ID: <20260503073541.790215-10-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-1-eric.auger@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 9_rHmynOTggUmvJbnnb7pP3OWMPnfRzUvXffCDyMv7s_1777793805
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Cornelia Huck <cohuck@redhat.com>

Introduce ARM_FEATURE_ID_RANGE_IDX macro that converts opcodes
into the index used to access the 3 * 8 * 8 feature id array.

KVM_ARM_GET_REG_WRITABLE_MASKS populates writable masks with
that indexing.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/cpu.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 2aa22360d2..0ac0fd13cf 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -886,6 +886,13 @@ typedef struct IdRegMap {
     uint64_t regs[NR_ID_REG_MASKS]; /* writable masks for registers */
 } IdRegMap;
 
+#define ARM_FEATURE_ID_RANGE_IDX(op0, op1, crn, crm, op2)               \
+        ({                                                              \
+                __u64 __op1 = (op1) & 3;                                \
+                __op1 -= (__op1 == 3);                                  \
+                (__op1 << 6 | ((crm) & 7) << 3 | (op2));                \
+        })
+
 /* REG is ID_XXX */
 #define FIELD_DP64_IDREG(ISAR, REG, FIELD, VALUE)                       \
     ({                                                                  \
-- 
2.53.0

