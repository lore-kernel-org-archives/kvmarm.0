Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E0E5C32793
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 23:47:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58EF14C5CC;
	Tue, 23 Aug 2022 19:47:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MrrtnXO8dFkO; Tue, 23 Aug 2022 19:47:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAFE44C5DE;
	Tue, 23 Aug 2022 19:47:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 769684C54A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:47:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 77DS5MXkzzfo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Aug 2022 19:47:42 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03EB64C626
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:47:41 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-335420c7bfeso264225147b3.16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 16:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=dyfVzihgdrPZo+RUO/1k2wAAJxTtqNUzgk2YW9ijkrg=;
 b=S9gMZipyUmUXtocgwik95pVW6kzVKy+nh0T6VxigN/sLYo5kcmdYz0eN3oSkaubnnJ
 T5OWWG7NSXIJQ/wIeroTpsvsy2uNkY50zU8G9aNTeQ0cCNv1sRKOq+7HsRRl8vj4J7f3
 NzXVBhRUtVDqMMwLsZs8EM6M+drme/J1v427cRnFktqHD50Ntj93ScipvpNAL6kWP1Ux
 MYUIu1WH5csXeqeGPr7HHdnNg5khaCby1l07MtUw98Czr3DipPAYYmzVEeWfCTfMHwDi
 vbikKjAuRGBebLhucKPZVNY8KemE0SJVbuCLdXQuXvDtk9uA66KHQNbxLNkt6+t4Za+l
 9Tbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=dyfVzihgdrPZo+RUO/1k2wAAJxTtqNUzgk2YW9ijkrg=;
 b=bovbfWvDVzNqlmbxtG8OuH6ACH2Z9uXK9Y2dss/RKDy+/weUa8TtmLbPjNrjD8gkPi
 npfjwri7qbGrq2ky0m3raZ8yVsJfS74dRF1vambfn7mxZKA6P9EC3KsbNmpWB41Ggstz
 nYyUlSPZJzX4zh2LHDxXyq9lpcoTLKrjth/DeYqEpVJTnG55Hkgaw3KeDY4V7z52P/BC
 PW2gv6YDLeEHa5mLcE6Jnualu56GcdN3+la3/8WO75ZxnnwLhdTFf8koWdja6EgssXMq
 9BRlR5olClQKZwrkQtDTXqkJipqE1Fi3TaFRlDn6TaUHQtRqPPN3UqJwjptaBDT47PAd
 ZSkQ==
X-Gm-Message-State: ACgBeo3/Yj32LPTBNjbOFFvUrKHy4weGqLEQQHspYGV/rVNMQVCxeJsR
 CXSzdkrQbGTNakaLw8KESp7AUwXs0fSzHQ==
X-Google-Smtp-Source: AA6agR66JbaOrhLKjAtuq2u27ylmhcDzBWhw2nDqJzZ51NFhHaCArIQfihvQ0qstlWx4ZMyCkzfy8sl3Qgx8Kw==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:1e02:0:b0:335:9996:fa88 with SMTP id
 e2-20020a811e02000000b003359996fa88mr28304425ywe.105.1661298461628; Tue, 23
 Aug 2022 16:47:41 -0700 (PDT)
Date: Tue, 23 Aug 2022 23:47:19 +0000
In-Reply-To: <20220823234727.621535-1-ricarkol@google.com>
Message-Id: <20220823234727.621535-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20220823234727.621535-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v5 05/13] tools: Copy bitfield.h from the kernel sources
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc: Jakub Kicinski <kuba@kernel.org>,
 Arnaldo Carvalho de Melo <acme@redhat.com>, dmatclack@google.com,
 maz@kernel.org, bgardon@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com
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
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
