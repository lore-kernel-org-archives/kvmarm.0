Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A82184F
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 07:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690184413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lI2MO6Jb3XyVogqmu+UMDZ8RMmOzM0JwpxQZPWVPeJU=;
	b=FmMOHi+7tRIBX/s4RWaGqujLoEj4whNQL5wb8lv8omvZXLK+r1Fp021KFGutcz+xju12Iz
	ZUJ1xgCyhk+HvBKzi7ySeEHSGy4uxprqj+QqvThhyHxeJ+97eGXTmqhyI4cwh3T06rLZeJ
	/V9A8/h9D0hqkl4o3lXri9eQBXvJyq4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-AFWEylP-MbmUiWRLbT-jzw-1; Mon, 24 Jul 2023 03:40:08 -0400
X-MC-Unique: AFWEylP-MbmUiWRLbT-jzw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24E07800B35;
	Mon, 24 Jul 2023 07:40:08 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 17287200BA63;
	Mon, 24 Jul 2023 07:40:08 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: andrew.jones@linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 2/2] arm64: Define name for these bits used in SCTLR_EL1
Date: Mon, 24 Jul 2023 03:39:48 -0400
Message-Id: <20230724073949.1297331-3-shahuang@redhat.com>
In-Reply-To: <20230724073949.1297331-1-shahuang@redhat.com>
References: <20230724073949.1297331-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4

Currently some fields in SCTLR_EL1 don't define a name and directly used
in the SCTLR_EL1_RES1, that's not good now since these fields have been
functional and have a name.

Delete the SCTLR_EL1_RES1 since these bits are not RES1 if the related
feature has been implemented, it's wired to define these bits as RES1.
So simply delete the SCTLR_EL1_RES1 and unwind its definition to
INIT_SCTLR_MMU_OFF.

According to the ARM DDI 0487J.a, define the name related to these
fields.

Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 lib/arm64/asm/sysreg.h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index 09ef5f5..6cae8b8 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -80,18 +80,26 @@ asm(
 #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
 
 /* System Control Register (SCTLR_EL1) bits */
+#define SCTLR_EL1_LSMAOE	_BITULL(29)
+#define SCTLR_EL1_NTLSMD	_BITULL(28)
 #define SCTLR_EL1_EE		_BITULL(25)
+#define SCTLR_EL1_SPAN		_BITULL(23)
+#define SCTLR_EL1_EIS		_BITULL(22)
+#define SCTLR_EL1_TSCXT		_BITULL(20)
 #define SCTLR_EL1_WXN		_BITULL(19)
 #define SCTLR_EL1_I		_BITULL(12)
+#define SCTLR_EL1_EOS		_BITULL(11)
+#define SCTLR_EL1_SED		_BITULL(8)
+#define SCTLR_EL1_ITD		_BITULL(7)
 #define SCTLR_EL1_SA0		_BITULL(4)
 #define SCTLR_EL1_SA		_BITULL(3)
 #define SCTLR_EL1_C		_BITULL(2)
 #define SCTLR_EL1_A		_BITULL(1)
 #define SCTLR_EL1_M		_BITULL(0)
 
-#define SCTLR_EL1_RES1	(_BITULL(7) | _BITULL(8) | _BITULL(11) | _BITULL(20) | \
-			 _BITULL(22) | _BITULL(23) | _BITULL(28) | _BITULL(29))
 #define INIT_SCTLR_EL1_MMU_OFF	\
-			SCTLR_EL1_RES1
+			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
+			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
+			 SCTLR_EL1_NTLSMD | SCTLR_EL1_LSMAOE)
 
 #endif /* _ASMARM64_SYSREG_H_ */
-- 
2.39.1

