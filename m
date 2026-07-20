Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767172288D5
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 05:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784525950; cv=none; b=CTotk0dd7I1gNPh/r38RfADDForgw8Wagz8gRgVyHEHpyzvlnw7IlTiRSQYVw0wxh9E4NTIx9Mz2VUjOtLsRiwfZU1HuIcWJEOGL9KxEal/uNcC4NFGKi7hVHHys8N+UiKYeiW90z0vdvCss19ygVl+PgTae4dWSSmQOgeXDhxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784525950; c=relaxed/simple;
	bh=N/y16fl48YztPTKgFTuZ9+7HYNROEUxLYFOVWXFM1KA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rTpyJOmfPobrytWx8C/zmow7WAiBTGX3GXop3SYh36YJEmj33naEMQqRxN/9tbK8JLUeteMghtf8TXGp7G7trOrm3MVj96js86lpJDoGAR5C78mkkiJquaP28a7Fljj6jWCZkvEMz48wkV8DsIoQNFiHRm9/du41kdBtkTmk/lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=sKrvylHv reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="sKrvylHv"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66K5c7op075973
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 20 Jul 2026 14:38:27 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=ditAkCCrXh+YkXADVfso0W9S/4JCyLrDicaPFc0dzLo=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1784525907; v=1;
        b=sKrvylHvOFrgFgsKcvVyGlVdk09KMkw2VoCaXwweA310Gkwg6SDz0I+BSvv7csa1
         aFmYwRJ/DELX5kni8QcgyNDgx3vhgbQUgWfKCwT4DRxfIW7wAWYl5hs/8bqlka24
         3M6b89oyqlKw+ed4fRP9z7tlENma4BO6c2x9y5KbBAwYi+XINfUwHy59xyYPxEWb
         Icx6+7UkMxMPrWsirsMPDi5GhRSebEumzfHNukXNGV7ih/A6XmQycXtPagI71FXi
         tSgpMufa/27qnQtj8rHgcUOZW+FDFKbZH38ufixIaqO+ZGlSBGrKtrwcsUI5KcWw
         jbuASudKIvN21KjbOt4lHg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 20 Jul 2026 14:38:01 +0900
Subject: [PATCH v9 07/16] tools headers: Use u* types for bitfield helpers
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hybrid-v9-7-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
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
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Eiden <seiden@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.16-dev-925f5
X-Developer-Signature: v=1; a=openpgp-sha256; l=2957;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=N/y16fl48YztPTKgFTuZ9+7HYNROEUxLYFOVWXFM1KA=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ1bsFnfRCQ82B4gwHfVaf47LffbMy1bMIt93yv4+e9Osn
 2Na5NuqjlIWBjEuBlkxRZaUot3cGtG1nwoT4ltg5rAygQxh4OIUgInkmjD84fp1vzpN7O/LY7dP
 HG1+/Cap1KRykVpGQOevAuG1pe03bBgZ5ijOjGteWHfAdo4295xfndOerrzrn6MXzbBqx2H3b8y
 rWQA=
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

Commit 9486aa387716 ("perf tools: Fix 64 bit integer format strings")
defined the tools-local u64 as uint64_t so that PRI*64 format macros
match its underlying C type. On architectures where uint64_t and __u64
are distinct types, however, ____MAKE_OP() still gives the u64_*
helpers an __u64 interface.

Teach ____MAKE_OP() to accept the helper name and storage type
separately. Keep endian helpers on __le* and __be*, and generate the
native helpers using the tools-local u* types.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 tools/include/linux/bitfield.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/include/linux/bitfield.h b/tools/include/linux/bitfield.h
index ddf81f24956b..1c633343d576 100644
--- a/tools/include/linux/bitfield.h
+++ b/tools/include/linux/bitfield.h
@@ -142,32 +142,32 @@ static __always_inline u64 field_mask(u64 field)
 	return field / field_multiplier(field);
 }
 #define field_max(field)	((typeof(field))field_mask(field))
-#define ____MAKE_OP(type,base,to,from)					\
-static __always_inline __##type type##_encode_bits(base v, base field)	\
+#define ____MAKE_OP(name,type,base,to,from)				\
+static __always_inline type name##_encode_bits(base v, base field)	\
 {									\
 	if (__builtin_constant_p(v) && (v & ~field_mask(field)))	\
 		__field_overflow();					\
 	return to((v & field_mask(field)) * field_multiplier(field));	\
 }									\
-static __always_inline __##type type##_replace_bits(__##type old,	\
-					base val, base field)		\
+static __always_inline type name##_replace_bits(type old,		\
+						base val, base field)	\
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
+static __always_inline base name##_get_bits(type v, base field)	\
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

-- 
2.55.0

