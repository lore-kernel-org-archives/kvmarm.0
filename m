Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC57B40928A
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 11:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783682159; cv=none; b=FUSC6gToC12EMWpT2fmJQdtjgSGGcdQtX7ICn+jKvdzh69nTlFXYDZ7BNx1zyX0UykXZo8ANCWpIP5pvjy4QUDGqrFHLQJXkk/iBWnWsBj+GubNDuJYw6bONbgrQBpWwnKBvzhg3dFfe/wbZdcWWDb2qVkIBNs1cmUyK639Rwh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783682159; c=relaxed/simple;
	bh=9j2sLIskvz0/of69Ci4UihDwqz/h43AbZmJiJF/tu+M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aH20TvGZEmGcBquGGc8tmtiEfJcVar8nbA1iWJAG01NgDoHjK0PtNQnTT6YeV4V7Im5Ya67vM1BMYp198ngsGE6/SE/W32Si/9vk/JyKU+LsooAICe1cpwdnNDcIpoNYyE9dIRGdh62qnRjKZ/0LLUEmxmU3Ue6Y/PtIgx0r7nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=OFMBIb8J reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="OFMBIb8J"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66ABEvsG024946
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 10 Jul 2026 20:15:09 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=KyTrdU9HmcQb5NC0B5vuRBCCEn7dxaItsZiYGQoGCjU=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1783682109; v=1;
        b=OFMBIb8JieI4oSuqrXGBiBpeYAfFy4MIJ23xe91w02PKiYP6kJ/R8ZXZPXrPrCCn
         /JCos9aey4/4zJPJnAB9PAJBuUnR12NHylTtpMvyi40D2FGt/Ev2ryYVpRnCFPSl
         +UJi87NFaQH0n9kDseaLvlQXYJJ2JmAYrgHiqqBsRZlq14dgx4CNL6ip7PJoKZd3
         kW4sHliYUYjSaRKrtjhxNkUriGUO8zwNUgk10F9d8LGKvKnCV2WoQ41RxUZV+ONj
         NHxUdq1AEKvWZfO21DQ0DgPIZfSPhUZiHpXubNT5qomfW2paQkOn42M1v6zCO4c6
         p3TbP+Fo9w/7o+D4Ks9+1Q==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Fri, 10 Jul 2026 20:14:56 +0900
Subject: [PATCH v8 02/11] tools headers: Sync bitfield.h with the kernel
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-hybrid-v8-2-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
References: <20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.16-dev-925f5
X-Developer-Signature: v=1; a=openpgp-sha256; l=13915;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=9j2sLIskvz0/of69Ci4UihDwqz/h43AbZmJiJF/tu+M=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ1bAFZO2nIio678bqiZkfs7a3H1ZTtpwt9z7lVc/bLCrW
 ra9V621o5SFQYyLQVZMkSWlaDe3RnTtp8KE+BaYOaxMIEMYuDgFYCIX8hn+KR/puBv5e23OQ6sd
 vL/KmHWDD3cvW33s4K6fct6z1U/eZGX4n1C4qLn5k2/oRP2DiYoXLh+bGJu171Jl/paL2YmFHsU
 XOAE=
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

Sync tools/include/linux/bitfield.h with include/linux/bitfield.h
changes since commit 590b949597b1 ("tools: Copy bitfield.h from the kernel
sources"). Preserve the tools-only linux/kernel.h include for endian
helpers; a follow-up selftest uses u64_replace_bits() from the
refreshed header.

Keep the synced native u*_..._bits() helpers on tools-local u* types,
while leaving endian helpers on __le* and __be*. This preserves the
tools convention that u64 is uint64_t and avoids printf format warnings
in selftests.

Add the supporting tools-side pieces required by the newer header:

  - tools/include/linux/typecheck.h for typecheck_pointer();
  - the auto compatibility macro in tools/compiler_types.h, guarded
    with !defined(__STDC_VERSION__) for pre-C99 tools builds and kept
    C-only so perf C++ sources keep the C++ auto keyword;
  - __ffs64() in tools/include/linux/bitops.h for non-constant-mask
    field helpers.

Assisted-by: Codex:gpt-5.5
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 tools/include/linux/bitfield.h       | 175 ++++++++++++++++++++++++++++++-----
 tools/include/linux/bitops.h         |  19 ++++
 tools/include/linux/compiler_types.h |  13 +++
 tools/include/linux/typecheck.h      |  34 +++++++
 4 files changed, 217 insertions(+), 24 deletions(-)

diff --git a/tools/include/linux/bitfield.h b/tools/include/linux/bitfield.h
index ddf81f24956b..b9a634b18881 100644
--- a/tools/include/linux/bitfield.h
+++ b/tools/include/linux/bitfield.h
@@ -8,7 +8,9 @@
 #define _LINUX_BITFIELD_H
 
 #include <linux/build_bug.h>
+#include <linux/compiler.h>
 #include <linux/kernel.h>
+#include <linux/typecheck.h>
 #include <asm/byteorder.h>
 
 /*
@@ -17,9 +19,13 @@
  * FIELD_{GET,PREP} macros take as first parameter shifted mask
  * from which they extract the base mask and shift amount.
  * Mask must be a compilation time constant.
+ * field_{get,prep} are variants that take a non-const mask.
  *
  * Example:
  *
+ *  #include <linux/bitfield.h>
+ *  #include <linux/bits.h>
+ *
  *  #define REG_FIELD_A  GENMASK(6, 0)
  *  #define REG_FIELD_B  BIT(7)
  *  #define REG_FIELD_C  GENMASK(15, 8)
@@ -36,8 +42,7 @@
  *	  FIELD_PREP(REG_FIELD_D, 0x40);
  *
  * Modify:
- *  reg &= ~REG_FIELD_C;
- *  reg |= FIELD_PREP(REG_FIELD_C, c);
+ *  FIELD_MODIFY(REG_FIELD_C, &reg, c);
  */
 
 #define __bf_shf(x) (__builtin_ffsll(x) - 1)
@@ -58,21 +63,42 @@
 
 #define __bf_cast_unsigned(type, x)	((__unsigned_scalar_typeof(type))(x))
 
-#define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)			\
+#define __BF_FIELD_CHECK_MASK(_mask, _val, _pfx)			\
 	({								\
 		BUILD_BUG_ON_MSG(!__builtin_constant_p(_mask),		\
 				 _pfx "mask is not constant");		\
 		BUILD_BUG_ON_MSG((_mask) == 0, _pfx "mask is zero");	\
 		BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?		\
-				 ~((_mask) >> __bf_shf(_mask)) & (_val) : 0, \
+				 ~((_mask) >> __bf_shf(_mask)) &	\
+					(0 + (_val)) : 0,		\
 				 _pfx "value too large for the field"); \
-		BUILD_BUG_ON_MSG(__bf_cast_unsigned(_mask, _mask) >	\
-				 __bf_cast_unsigned(_reg, ~0ull),	\
-				 _pfx "type of reg too small for mask"); \
 		__BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +			\
 					      (1ULL << __bf_shf(_mask))); \
 	})
 
+#define __BF_FIELD_CHECK_REG(mask, reg, pfx)				\
+	BUILD_BUG_ON_MSG(__bf_cast_unsigned(mask, mask) >		\
+			 __bf_cast_unsigned(reg, ~0ull),		\
+			 pfx "type of reg too small for mask")
+
+#define __BF_FIELD_CHECK(mask, reg, val, pfx)				\
+	({								\
+		__BF_FIELD_CHECK_MASK(mask, val, pfx);			\
+		__BF_FIELD_CHECK_REG(mask, reg, pfx);			\
+	})
+
+#define __FIELD_PREP(mask, val, pfx)					\
+	({								\
+		__BF_FIELD_CHECK_MASK(mask, val, pfx);			\
+		((typeof(mask))(val) << __bf_shf(mask)) & (mask);	\
+	})
+
+#define __FIELD_GET(mask, reg, pfx)					\
+	({								\
+		__BF_FIELD_CHECK_MASK(mask, 0U, pfx);			\
+		(typeof(mask))(((reg) & (mask)) >> __bf_shf(mask));	\
+	})
+
 /**
  * FIELD_MAX() - produce the maximum value representable by a field
  * @_mask: shifted mask defining the field's length and position
@@ -109,10 +135,36 @@
  */
 #define FIELD_PREP(_mask, _val)						\
 	({								\
-		__BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");	\
-		((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask);	\
+		__BF_FIELD_CHECK_REG(_mask, 0ULL, "FIELD_PREP: ");	\
+		__FIELD_PREP(_mask, _val, "FIELD_PREP: ");		\
 	})
 
+#define __BF_CHECK_POW2(n)	BUILD_BUG_ON_ZERO(((n) & ((n) - 1)) != 0)
+
+/**
+ * FIELD_PREP_CONST() - prepare a constant bitfield element
+ * @_mask: shifted mask defining the field's length and position
+ * @_val:  value to put in the field
+ *
+ * FIELD_PREP_CONST() masks and shifts up the value.  The result should
+ * be combined with other fields of the bitfield using logical OR.
+ *
+ * Unlike FIELD_PREP() this is a constant expression and can therefore
+ * be used in initializers. Error checking is less comfortable for this
+ * version, and non-constant masks cannot be used.
+ */
+#define FIELD_PREP_CONST(_mask, _val)					\
+	(								\
+		/* mask must be non-zero */				\
+		BUILD_BUG_ON_ZERO((_mask) == 0) +			\
+		/* check if value fits */				\
+		BUILD_BUG_ON_ZERO(~((_mask) >> __bf_shf(_mask)) & (_val)) + \
+		/* check if mask is contiguous */			\
+		__BF_CHECK_POW2((_mask) + (1ULL << __bf_shf(_mask))) +	\
+		/* and create the value */				\
+		(((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask))	\
+	)
+
 /**
  * FIELD_GET() - extract a bitfield element
  * @_mask: shifted mask defining the field's length and position
@@ -123,8 +175,25 @@
  */
 #define FIELD_GET(_mask, _reg)						\
 	({								\
-		__BF_FIELD_CHECK(_mask, _reg, 0U, "FIELD_GET: ");	\
-		(typeof(_mask))(((_reg) & (_mask)) >> __bf_shf(_mask));	\
+		__BF_FIELD_CHECK_REG(_mask, _reg, "FIELD_GET: ");	\
+		__FIELD_GET(_mask, _reg, "FIELD_GET: ");		\
+	})
+
+/**
+ * FIELD_MODIFY() - modify a bitfield element
+ * @_mask: shifted mask defining the field's length and position
+ * @_reg_p: pointer to the memory that should be updated
+ * @_val: value to store in the bitfield
+ *
+ * FIELD_MODIFY() modifies the set of bits in @_reg_p specified by @_mask,
+ * by replacing them with the bitfield value passed in as @_val.
+ */
+#define FIELD_MODIFY(_mask, _reg_p, _val)						\
+	({										\
+		typecheck_pointer(_reg_p);						\
+		__BF_FIELD_CHECK(_mask, *(_reg_p), _val, "FIELD_MODIFY: ");		\
+		*(_reg_p) &= ~(_mask);							\
+		*(_reg_p) |= (((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask));	\
 	})
 
 extern void __compiletime_error("value doesn't fit into mask")
@@ -142,36 +211,94 @@ static __always_inline u64 field_mask(u64 field)
 	return field / field_multiplier(field);
 }
 #define field_max(field)	((typeof(field))field_mask(field))
-#define ____MAKE_OP(type,base,to,from)					\
-static __always_inline __##type type##_encode_bits(base v, base field)	\
+#define ____MAKE_OP(name,type,base,to,from)				\
+static __always_inline type __must_check name##_encode_bits(base v, base field)	\
 {									\
 	if (__builtin_constant_p(v) && (v & ~field_mask(field)))	\
 		__field_overflow();					\
 	return to((v & field_mask(field)) * field_multiplier(field));	\
 }									\
-static __always_inline __##type type##_replace_bits(__##type old,	\
-					base val, base field)		\
+static __always_inline type __must_check name##_replace_bits(type old,	\
+							base val, base field)	\
 {									\
-	return (old & ~to(field)) | type##_encode_bits(val, field);	\
+	return (old & ~to(field)) | name##_encode_bits(val, field);	\
 }									\
-static __always_inline void type##p_replace_bits(__##type *p,		\
+static __always_inline void name##p_replace_bits(type *p,		\
 					base val, base field)		\
 {									\
-	*p = (*p & ~to(field)) | type##_encode_bits(val, field);	\
+	*p = (*p & ~to(field)) | name##_encode_bits(val, field);	\
 }									\
-static __always_inline base type##_get_bits(__##type v, base field)	\
+static __always_inline base __must_check name##_get_bits(type v, base field)	\
 {									\
 	return (from(v) & field)/field_multiplier(field);		\
 }
-#define __MAKE_OP(size)							\
-	____MAKE_OP(le##size,u##size,cpu_to_le##size,le##size##_to_cpu)	\
-	____MAKE_OP(be##size,u##size,cpu_to_be##size,be##size##_to_cpu)	\
-	____MAKE_OP(u##size,u##size,,)
-____MAKE_OP(u8,u8,,)
+#define __MAKE_OP(size)									\
+	____MAKE_OP(le##size,__le##size,u##size,cpu_to_le##size,le##size##_to_cpu)	\
+	____MAKE_OP(be##size,__be##size,u##size,cpu_to_be##size,be##size##_to_cpu)	\
+	____MAKE_OP(u##size,u##size,u##size,,)
+____MAKE_OP(u8,u8,u8,,)
 __MAKE_OP(16)
 __MAKE_OP(32)
 __MAKE_OP(64)
 #undef __MAKE_OP
 #undef ____MAKE_OP
 
+#define __field_prep(mask, val)						\
+	({								\
+		auto __mask = (mask);					\
+		typeof(__mask) __val = (val);				\
+		unsigned int __shift = BITS_PER_TYPE(__mask) <= 32 ?	\
+				       __ffs(__mask) : __ffs64(__mask);	\
+		(__val << __shift) & __mask;				\
+	})
+
+#define __field_get(mask, reg)						\
+	({								\
+		auto __mask = (mask);					\
+		typeof(__mask) __reg =  (reg);				\
+		unsigned int __shift = BITS_PER_TYPE(__mask) <= 32 ?	\
+				       __ffs(__mask) : __ffs64(__mask);	\
+		(__reg & __mask) >> __shift;				\
+	})
+
+/**
+ * field_prep() - prepare a bitfield element
+ * @mask: shifted mask defining the field's length and position, must be
+ *        non-zero
+ * @val:  value to put in the field
+ *
+ * Return: field value masked and shifted to its final destination
+ *
+ * field_prep() masks and shifts up the value.  The result should be
+ * combined with other fields of the bitfield using logical OR.
+ * Unlike FIELD_PREP(), @mask is not limited to a compile-time constant.
+ * Typical usage patterns are a value stored in a table, or calculated by
+ * shifting a constant by a variable number of bits.
+ * If you want to ensure that @mask is a compile-time constant, please use
+ * FIELD_PREP() directly instead.
+ */
+#define field_prep(mask, val)						\
+	(__builtin_constant_p(mask) ? __FIELD_PREP(mask, val, "field_prep: ") \
+				    : __field_prep(mask, val))
+
+/**
+ * field_get() - extract a bitfield element
+ * @mask: shifted mask defining the field's length and position, must be
+ *        non-zero
+ * @reg:  value of entire bitfield
+ *
+ * Return: extracted field value
+ *
+ * field_get() extracts the field specified by @mask from the
+ * bitfield passed in as @reg by masking and shifting it down.
+ * Unlike FIELD_GET(), @mask is not limited to a compile-time constant.
+ * Typical usage patterns are a value stored in a table, or calculated by
+ * shifting a constant by a variable number of bits.
+ * If you want to ensure that @mask is a compile-time constant, please use
+ * FIELD_GET() directly instead.
+ */
+#define field_get(mask, reg)						\
+	(__builtin_constant_p(mask) ? __FIELD_GET(mask, reg, "field_get: ") \
+				    : __field_get(mask, reg))
+
 #endif
diff --git a/tools/include/linux/bitops.h b/tools/include/linux/bitops.h
index b4e4cd071f8c..0dfd61a7a35d 100644
--- a/tools/include/linux/bitops.h
+++ b/tools/include/linux/bitops.h
@@ -100,4 +100,23 @@ static __always_inline __s64 sign_extend64(__u64 value, int index)
 	return (__s64)(value << shift) >> shift;
 }
 
+/**
+ * __ffs64 - find first set bit in a 64 bit word
+ * @word: The 64 bit word
+ *
+ * On 64 bit arches this is a synonym for __ffs
+ * The result is not defined if no bits are set, so check that @word
+ * is non-zero before calling this.
+ */
+static inline __attribute_const__ unsigned int __ffs64(u64 word)
+{
+#if BITS_PER_LONG == 32
+	if (((u32)word) == 0UL)
+		return __ffs((u32)(word >> 32)) + 32;
+#elif BITS_PER_LONG != 64
+#error BITS_PER_LONG not 32 or 64
+#endif
+	return __ffs((unsigned long)word);
+}
+
 #endif
diff --git a/tools/include/linux/compiler_types.h b/tools/include/linux/compiler_types.h
index b3adbf5682f0..287a1a26cb05 100644
--- a/tools/include/linux/compiler_types.h
+++ b/tools/include/linux/compiler_types.h
@@ -13,6 +13,19 @@
 #define __has_builtin(x) (0)
 #endif
 
+/*
+ * C23 introduces "auto" as a standard way to define type-inferred
+ * variables, but "auto" has been a (useless) keyword even since K&R C,
+ * so it has always been "namespace reserved."
+ *
+ * Until at some future time we require C23 support, we need the gcc
+ * extension __auto_type, but there is no reason to put that elsewhere
+ * in the source code.
+ */
+#if !defined(__cplusplus) && (!defined(__STDC_VERSION__) || __STDC_VERSION__ < 202311L)
+# define auto __auto_type
+#endif
+
 #include <linux/compiler-context-analysis.h>
 
 /* Compiler specific macros. */
diff --git a/tools/include/linux/typecheck.h b/tools/include/linux/typecheck.h
new file mode 100644
index 000000000000..46b15e2aaefb
--- /dev/null
+++ b/tools/include/linux/typecheck.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef TYPECHECK_H_INCLUDED
+#define TYPECHECK_H_INCLUDED
+
+/*
+ * Check at compile time that something is of a particular type.
+ * Always evaluates to 1 so you may use it easily in comparisons.
+ */
+#define typecheck(type,x) \
+({	type __dummy; \
+	typeof(x) __dummy2; \
+	(void)(&__dummy == &__dummy2); \
+	1; \
+})
+
+/*
+ * Check at compile time that 'function' is a certain type, or is a pointer
+ * to that type (needs to use typedef for the function type.)
+ */
+#define typecheck_fn(type,function) \
+({	typeof(type) __tmp = function; \
+	(void)__tmp; \
+})
+
+/*
+ * Check at compile time that something is a pointer type.
+ */
+#define typecheck_pointer(x) \
+({	typeof(x) __dummy; \
+	(void)sizeof(*__dummy); \
+	1; \
+})
+
+#endif		/* TYPECHECK_H_INCLUDED */

-- 
2.55.0

