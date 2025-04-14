Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAFB279903
	for <kvmarm@lists.linux.dev>; Mon, 14 Apr 2025 16:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744648844; cv=none; b=IFr+LJRQM9jWmqo0k99d2X6barqy3eMnsqzVmXiUKBAi0qwV7+sklhFDpM9s9i7msEgh70JZ7qB3H1gqdEE6n8Oj4GGcVY+efRBtRehZ9lYi9zKwsPGsYf0hwTqurnllZO3PubOe65OpRf4EfKM8j7xHFV2husNRoNO76ZZ7ZtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744648844; c=relaxed/simple;
	bh=1LrbRAjnOq2egfyW1xHrR43w/+OOTzg+gpmSeKsgB9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=ZdYy5pMIxQ2Y32/qcUrzTKup8PjomBT0Ec8QfycO0rT8VUQtBjOlCn7LaasStg2rN31l1OUn9nsZ8ctz7OyyVhC1J9fe6X8HYaAf6jqj6O2qf3/h6yIoFZLXCZXfWhK9/vDjStTW9dFPLOcnJtx1mYzUPCNfOa57GHz1hDpy6qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SCjIbEL3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SCjIbEL3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744648842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g9wxNH81JIH2IEDZg20aj6k00TZH42Y7fo7oUdlKPTI=;
	b=SCjIbEL3Yev18H9LUVr2tkWzuNTJslVA/DUxQKnJhtCYaYnAhu/vhpc4gLFRKrejhgx6Kr
	KYq8/mpERfqZeWRsYMaXzp9YUk3QlMH9MZXWK58oUiQU1oHOQD3i6fQN4r7KvFka9a0Sro
	VSWUFVz1TZm6mo907RYGIwoXiB7FkkI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-498-AgPxKZf3N3er18B2CtWUSw-1; Mon,
 14 Apr 2025 12:40:38 -0400
X-MC-Unique: AgPxKZf3N3er18B2CtWUSw-1
X-Mimecast-MFC-AGG-ID: AgPxKZf3N3er18B2CtWUSw_1744648836
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA5F41956065;
	Mon, 14 Apr 2025 16:40:35 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.67.24.14])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A9EA8180B487;
	Mon, 14 Apr 2025 16:40:20 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	sebott@redhat.com,
	shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Cc: agraf@csgraf.de,
	shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v3 05/10] arm/cpu: accessors for writable id registers
Date: Mon, 14 Apr 2025 18:38:44 +0200
Message-ID: <20250414163849.321857-6-cohuck@redhat.com>
In-Reply-To: <20250414163849.321857-1-cohuck@redhat.com>
References: <20250414163849.321857-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Also add conversion between the different indices.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index bbee7ff2414a..775a8aebc5d3 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -876,6 +876,13 @@ typedef struct IdRegMap {
     uint64_t regs[NR_ID_REGS];
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
@@ -923,6 +930,17 @@ typedef struct IdRegMap {
         i_->idregs[REG ## _EL1_IDX];                                    \
     })
 
+#define GET_IDREG_WRITABLE(MAP, REG)                                  \
+    ({                                                                \
+    const IdRegMap *m_ = (MAP);                                       \
+    int index = ARM_FEATURE_ID_RANGE_IDX((sysreg >> 14) & 0x0000c000, \
+                                         (sysreg >> 11) & 0x00003800, \
+                                         (sysreg >> 7) & 0x00000780,  \
+                                         (sysreg >> 3) & 0x00000078,  \
+                                         sysreg & 0x00000007);        \
+    m_->regs[index];                                                  \
+    })
+
 /**
  * ARMCPU:
  * @env: #CPUARMState
-- 
2.49.0

