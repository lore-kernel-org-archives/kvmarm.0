Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F533C24
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 03:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689736773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jw3hUbCwpEEZZOwhQ/mpq6ERCYwJxt0NIjdJOrCrevI=;
	b=Dp+zvtXYULlBaUaJFvdpdwL9BF80bkvtv59sx2wui5gnQ1gf7MVhfNf9eDN0KAhNyJVGeK
	zGXQUQjCM8Q/TdBk7PvBQHD+fBsSVD7j9NRoWFvlEB3ZPXGrgA2kDKu4AwmF1kpcmUmsqL
	Z227F0czgo4qoU66Hnt8+g9o6mXPG2I=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-qRwGKdReMFeNvPqK9IguCg-1; Tue, 18 Jul 2023 23:19:28 -0400
X-MC-Unique: qRwGKdReMFeNvPqK9IguCg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55F063C01B86;
	Wed, 19 Jul 2023 03:19:28 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 494714CD0F8;
	Wed, 19 Jul 2023 03:19:28 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: andrew.jones@linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 2/2] arm64: Define name for the bits used in SCTLR_EL1_RES1
Date: Tue, 18 Jul 2023 23:19:26 -0400
Message-Id: <20230719031926.752931-3-shahuang@redhat.com>
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

Currently some fields in SCTLR_EL1 don't define a name and directly used
in the SCTLR_EL1_RES1, that's not good now since these fields have been
functional and have a name.

According to the ARM DDI 0487J.a, define the name related to these
fields.

Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 lib/arm64/asm/sysreg.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index c7f529d..9c68698 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -80,17 +80,26 @@ asm(
 #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
 
 /* System Control Register (SCTLR_EL1) bits */
+#define SCTLR_EL1_LSMAOE	_BITUL(29)
+#define SCTLR_EL1_NTLSMD	_BITUL(28)
 #define SCTLR_EL1_EE		_BITUL(25)
+#define SCTLR_EL1_SPAN		_BITUL(23)
+#define SCTLR_EL1_EIS		_BITUL(22)
+#define SCTLR_EL1_TSCXT		_BITUL(20)
 #define SCTLR_EL1_WXN		_BITUL(19)
 #define SCTLR_EL1_I		_BITUL(12)
+#define SCTLR_EL1_EOS		_BITUL(11)
+#define SCTLR_EL1_SED		_BITUL(8)
+#define SCTLR_EL1_ITD		_BITUL(7)
 #define SCTLR_EL1_SA0		_BITUL(4)
 #define SCTLR_EL1_SA		_BITUL(3)
 #define SCTLR_EL1_C		_BITUL(2)
 #define SCTLR_EL1_A		_BITUL(1)
 #define SCTLR_EL1_M		_BITUL(0)
 
-#define SCTLR_EL1_RES1	(_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
-			 _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))
+#define SCTLR_EL1_RES1	(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
+			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
+			 SCTLR_EL1_NTLSMD | SCTLR_EL1_LSMAOE)
 #define INIT_SCTLR_EL1_MMU_OFF	\
 			SCTLR_EL1_RES1
 
-- 
2.39.1

