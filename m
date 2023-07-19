Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A4A3C25
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 03:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689736773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dNuP0S8j2h8BafNzuABN2bIJwDP+NuHdEUk3/vlTbfk=;
	b=CGZfvH5UXof1Jfrpr5MOO7D/Hx0vadC4+mf6YWGVFOi5sPIsyuXmlU0DDi1BUgUihiC1l8
	9gmnBLu9FMBHpddXqkyBPVyqvSlRa0rB02279n92R2rQQFxfUJNfWt2akswGTYC+MoYW8+
	q7LdfRaXZEofW3cC7smCLKHpmMfUShI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-ev3or5ugOQeAMYD7QiyreA-1; Tue, 18 Jul 2023 23:19:28 -0400
X-MC-Unique: ev3or5ugOQeAMYD7QiyreA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33E05101156F;
	Wed, 19 Jul 2023 03:19:28 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 277CC4CD0F5;
	Wed, 19 Jul 2023 03:19:28 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: andrew.jones@linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 1/2] arm64: Replace the SCTLR_EL1 filed definition by _BITUL()
Date: Tue, 18 Jul 2023 23:19:25 -0400
Message-Id: <20230719031926.752931-2-shahuang@redhat.com>
In-Reply-To: <20230719031926.752931-1-shahuang@redhat.com>
References: <20230719031926.752931-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10

Currently the SCTLR_EL1_* is defined by (1 << x), all of them can be
replaced by the _BITUL() macro to make the format consistent with the
SCTLR_EL1_RES1 definition.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 lib/arm64/asm/sysreg.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index 18c4ed3..c7f529d 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -80,14 +80,14 @@ asm(
 #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
 
 /* System Control Register (SCTLR_EL1) bits */
-#define SCTLR_EL1_EE	(1 << 25)
-#define SCTLR_EL1_WXN	(1 << 19)
-#define SCTLR_EL1_I	(1 << 12)
-#define SCTLR_EL1_SA0	(1 << 4)
-#define SCTLR_EL1_SA	(1 << 3)
-#define SCTLR_EL1_C	(1 << 2)
-#define SCTLR_EL1_A	(1 << 1)
-#define SCTLR_EL1_M	(1 << 0)
+#define SCTLR_EL1_EE		_BITUL(25)
+#define SCTLR_EL1_WXN		_BITUL(19)
+#define SCTLR_EL1_I		_BITUL(12)
+#define SCTLR_EL1_SA0		_BITUL(4)
+#define SCTLR_EL1_SA		_BITUL(3)
+#define SCTLR_EL1_C		_BITUL(2)
+#define SCTLR_EL1_A		_BITUL(1)
+#define SCTLR_EL1_M		_BITUL(0)
 
 #define SCTLR_EL1_RES1	(_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
 			 _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))
-- 
2.39.1

