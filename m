Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4DA0C54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 04:26:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91D894B653;
	Tue, 20 Sep 2022 00:26:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qo9qVW7yuJBm; Tue, 20 Sep 2022 00:26:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CEC74B71F;
	Tue, 20 Sep 2022 00:26:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E0B84B636
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:26:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tdtDS3co5trq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 00:26:02 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E120D4B743
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:26:01 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 v5-20020a2583c5000000b006964324be8cso1093930ybm.14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 21:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=j8jJsNM7Za6z7+jNYScfL9f2PcUBqUH5VLVkcQEa6x0=;
 b=KOwoT35rBe7+VXJD2NWVVd1/9RIEIVCAVAzCNr0N4uEAt38rAuUp7Bh1mxLZ6ADjrZ
 xQR/38iGshUeKjZkTBHRUl134V+NC4kURQHpcl7s6/XIiEvnserl7mauTUx+M92dV0g/
 J1/lW97oLK3yxCkKz/Jo4EpPwqVhj5o5yjMzKXX+A7+LO2+oUOOJb4R8CvV40JBgiuJa
 Ar2p0Bois3+uthiH4SC46NZ5S+Ihf85y7y/2VyGV5rN6jWjK/Wn7dEqo0oERDhYLVEr0
 CNCqaW1emqaUTpFFSoIi7Yia9vF4DW6CjOxtE4on0ZYNE+Ta5okrvErVsCUoJ9tQm7ZX
 BUyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=j8jJsNM7Za6z7+jNYScfL9f2PcUBqUH5VLVkcQEa6x0=;
 b=kzah+fBvr6sJx/bh2K0djkgdrXGlg4hFwvbJjfwJbCMyjK9hb2JCZpD4R7tpV10mV8
 sTwd7IEuTp5roAi0QjhigHuzFeXwctIWfEfieyVpitDlY27w3L0Lr/MHi6lOxON2/iFm
 9tIrBXv6n1H0n+asoUPPPHqKJzY3YwH9otO9ouCeRgiJs4E4MSmY1+RdZK9H7xqrLEvp
 O1jW+BX5DWMSu/nGpw97d+IuvCkFK/nc2Z4zutzU+y7Dmi1AMkI0y/6YebAAM5xxTUx2
 FP3URy23fpPfv7HZQyMWMVHQwlTVHuttpm1QPchtBLXeoWoRrE8oSHCRV4Kjw3N7+Y7E
 da8A==
X-Gm-Message-State: ACrzQf0KaBhj5O4MBfPp666PP7cZBLpz+aX/Q6joQR3IfuoAXv5UvSBr
 yT6WlPsnGA5p7HvmW0rPY4eKoFAEbme9AA==
X-Google-Smtp-Source: AMsMyM4w/yrOiLwUkjgGdo3D9ByZRv6eijuZIyNcEp74bfOTUT36fpZGmyP+pOOJEigDqYuM5lEiqfvuVfqrSQ==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:9c01:0:b0:6af:4a89:26b3 with SMTP id
 c1-20020a259c01000000b006af4a8926b3mr18652078ybo.190.1663647961539; Mon, 19
 Sep 2022 21:26:01 -0700 (PDT)
Date: Tue, 20 Sep 2022 04:25:43 +0000
In-Reply-To: <20220920042551.3154283-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920042551.3154283-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920042551.3154283-6-ricarkol@google.com>
Subject: [PATCH v7 05/13] tools: Copy bitfield.h from the kernel sources
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
 Jakub Kicinski <kuba@kernel.org>, maz@kernel.org, bgardon@google.com,
 pbonzini@redhat.com, axelrasmussen@google.com, dmatlack@google.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Copy bitfield.h from include/linux/bitfield.h.  A subsequent change will
make use of some FIELD_{GET,PREP} macros defined in this header.

The header was copied as-is, no changes needed.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/include/linux/bitfield.h | 176 +++++++++++++++++++++++++++++++++
 1 file changed, 176 insertions(+)
 create mode 100644 tools/include/linux/bitfield.h

diff --git a/tools/include/linux/bitfield.h b/tools/include/linux/bitfield.h
new file mode 100644
index 000000000000..6093fa6db260
--- /dev/null
+++ b/tools/include/linux/bitfield.h
@@ -0,0 +1,176 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2014 Felix Fietkau <nbd@nbd.name>
+ * Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
+ */
+
+#ifndef _LINUX_BITFIELD_H
+#define _LINUX_BITFIELD_H
+
+#include <linux/build_bug.h>
+#include <asm/byteorder.h>
+
+/*
+ * Bitfield access macros
+ *
+ * FIELD_{GET,PREP} macros take as first parameter shifted mask
+ * from which they extract the base mask and shift amount.
+ * Mask must be a compilation time constant.
+ *
+ * Example:
+ *
+ *  #define REG_FIELD_A  GENMASK(6, 0)
+ *  #define REG_FIELD_B  BIT(7)
+ *  #define REG_FIELD_C  GENMASK(15, 8)
+ *  #define REG_FIELD_D  GENMASK(31, 16)
+ *
+ * Get:
+ *  a = FIELD_GET(REG_FIELD_A, reg);
+ *  b = FIELD_GET(REG_FIELD_B, reg);
+ *
+ * Set:
+ *  reg = FIELD_PREP(REG_FIELD_A, 1) |
+ *	  FIELD_PREP(REG_FIELD_B, 0) |
+ *	  FIELD_PREP(REG_FIELD_C, c) |
+ *	  FIELD_PREP(REG_FIELD_D, 0x40);
+ *
+ * Modify:
+ *  reg &= ~REG_FIELD_C;
+ *  reg |= FIELD_PREP(REG_FIELD_C, c);
+ */
+
+#define __bf_shf(x) (__builtin_ffsll(x) - 1)
+
+#define __scalar_type_to_unsigned_cases(type)				\
+		unsigned type:	(unsigned type)0,			\
+		signed type:	(unsigned type)0
+
+#define __unsigned_scalar_typeof(x) typeof(				\
+		_Generic((x),						\
+			char:	(unsigned char)0,			\
+			__scalar_type_to_unsigned_cases(char),		\
+			__scalar_type_to_unsigned_cases(short),		\
+			__scalar_type_to_unsigned_cases(int),		\
+			__scalar_type_to_unsigned_cases(long),		\
+			__scalar_type_to_unsigned_cases(long long),	\
+			default: (x)))
+
+#define __bf_cast_unsigned(type, x)	((__unsigned_scalar_typeof(type))(x))
+
+#define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)			\
+	({								\
+		BUILD_BUG_ON_MSG(!__builtin_constant_p(_mask),		\
+				 _pfx "mask is not constant");		\
+		BUILD_BUG_ON_MSG((_mask) == 0, _pfx "mask is zero");	\
+		BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?		\
+				 ~((_mask) >> __bf_shf(_mask)) & (_val) : 0, \
+				 _pfx "value too large for the field"); \
+		BUILD_BUG_ON_MSG(__bf_cast_unsigned(_mask, _mask) >	\
+				 __bf_cast_unsigned(_reg, ~0ull),	\
+				 _pfx "type of reg too small for mask"); \
+		__BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +			\
+					      (1ULL << __bf_shf(_mask))); \
+	})
+
+/**
+ * FIELD_MAX() - produce the maximum value representable by a field
+ * @_mask: shifted mask defining the field's length and position
+ *
+ * FIELD_MAX() returns the maximum value that can be held in the field
+ * specified by @_mask.
+ */
+#define FIELD_MAX(_mask)						\
+	({								\
+		__BF_FIELD_CHECK(_mask, 0ULL, 0ULL, "FIELD_MAX: ");	\
+		(typeof(_mask))((_mask) >> __bf_shf(_mask));		\
+	})
+
+/**
+ * FIELD_FIT() - check if value fits in the field
+ * @_mask: shifted mask defining the field's length and position
+ * @_val:  value to test against the field
+ *
+ * Return: true if @_val can fit inside @_mask, false if @_val is too big.
+ */
+#define FIELD_FIT(_mask, _val)						\
+	({								\
+		__BF_FIELD_CHECK(_mask, 0ULL, 0ULL, "FIELD_FIT: ");	\
+		!((((typeof(_mask))_val) << __bf_shf(_mask)) & ~(_mask)); \
+	})
+
+/**
+ * FIELD_PREP() - prepare a bitfield element
+ * @_mask: shifted mask defining the field's length and position
+ * @_val:  value to put in the field
+ *
+ * FIELD_PREP() masks and shifts up the value.  The result should
+ * be combined with other fields of the bitfield using logical OR.
+ */
+#define FIELD_PREP(_mask, _val)						\
+	({								\
+		__BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");	\
+		((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask);	\
+	})
+
+/**
+ * FIELD_GET() - extract a bitfield element
+ * @_mask: shifted mask defining the field's length and position
+ * @_reg:  value of entire bitfield
+ *
+ * FIELD_GET() extracts the field specified by @_mask from the
+ * bitfield passed in as @_reg by masking and shifting it down.
+ */
+#define FIELD_GET(_mask, _reg)						\
+	({								\
+		__BF_FIELD_CHECK(_mask, _reg, 0U, "FIELD_GET: ");	\
+		(typeof(_mask))(((_reg) & (_mask)) >> __bf_shf(_mask));	\
+	})
+
+extern void __compiletime_error("value doesn't fit into mask")
+__field_overflow(void);
+extern void __compiletime_error("bad bitfield mask")
+__bad_mask(void);
+static __always_inline u64 field_multiplier(u64 field)
+{
+	if ((field | (field - 1)) & ((field | (field - 1)) + 1))
+		__bad_mask();
+	return field & -field;
+}
+static __always_inline u64 field_mask(u64 field)
+{
+	return field / field_multiplier(field);
+}
+#define field_max(field)	((typeof(field))field_mask(field))
+#define ____MAKE_OP(type,base,to,from)					\
+static __always_inline __##type type##_encode_bits(base v, base field)	\
+{									\
+	if (__builtin_constant_p(v) && (v & ~field_mask(field)))	\
+		__field_overflow();					\
+	return to((v & field_mask(field)) * field_multiplier(field));	\
+}									\
+static __always_inline __##type type##_replace_bits(__##type old,	\
+					base val, base field)		\
+{									\
+	return (old & ~to(field)) | type##_encode_bits(val, field);	\
+}									\
+static __always_inline void type##p_replace_bits(__##type *p,		\
+					base val, base field)		\
+{									\
+	*p = (*p & ~to(field)) | type##_encode_bits(val, field);	\
+}									\
+static __always_inline base type##_get_bits(__##type v, base field)	\
+{									\
+	return (from(v) & field)/field_multiplier(field);		\
+}
+#define __MAKE_OP(size)							\
+	____MAKE_OP(le##size,u##size,cpu_to_le##size,le##size##_to_cpu)	\
+	____MAKE_OP(be##size,u##size,cpu_to_be##size,be##size##_to_cpu)	\
+	____MAKE_OP(u##size,u##size,,)
+____MAKE_OP(u8,u8,,)
+__MAKE_OP(16)
+__MAKE_OP(32)
+__MAKE_OP(64)
+#undef __MAKE_OP
+#undef ____MAKE_OP
+
+#endif
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
