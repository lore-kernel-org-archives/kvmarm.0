Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B03E44A72C
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789386166; cv=none; b=ob5NP95ye2liaOknQHSKcqf/CFzJialzbOUV1phzFf58nggofIReHaV0hFp4fHLITLL0Vytw3wmgu55UCz0WAyQiXh5lD638nsnuih4O1Uk78TRCaIp7y9kTzLsry4aO8ud7OKcf1Zm9ouHMfM7k90j1+PouVtblYDk/bNLBbgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789386166; c=relaxed/simple;
	bh=0gFY16czEJJdVIZNruax1OboJIq4DgiNXWKP5yi8iWI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FlxohBNsGL2OESnmtc2jaeH8svOz0zvRKyU7tRAH40UskIITJAlJ3l0VysLcKrjWiWEQNnhzBOuOxeugSsCpCtDeBKwJp+d3nBZThSaenzfGkM4JzyqocEKXQLrQ6p+8d9jBjc7ruH5WJ3Z1sZuoAz6xI/t1W9NA9vOXMxAXtjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=KasQI7ws; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="KasQI7ws"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68EBfjsD084060
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 14 Sep 2026 20:41:55 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=sdoc/fNZ3/8mGQaouIvfU+D4x9tivmX8+zHcMnaA4Lw=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1789386115; v=1;
        b=KasQI7wsPlS7Dg95M5GXqi9WPs9GW4Pp12r2pPfTSSFQNbB0ZrWdbTcmWCo+2mG7
         MkSgdhCHg6WxiAT+zXs+0fh9hc+wWOYnNQbA/AiRyA+BIoGsuIlwJ+otlAhEv9z8
         dZ2MOBBSHfROKhW779+8bdcBj/iYjkvgPmCleEbZPJb6t1ZmMOg26R1BkKSBnC1L
         I3++om8cP1/Tj25PR03GKZa0Ox8D7DqH2VOc5doNniRI+AS6GERO63CZF0Dhgv+v
         u2Jtw2E0Zen9rLwSLGD+aO2afMi4ke6XXzx+OwRKShyT4Hg/qul2QgynXX4SxVYJ
         OYXdEp6ACx9LezOoAMwcvg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 14 Sep 2026 20:40:50 +0900
Subject: [PATCH v10 11/20] tools headers: Use u* types for bitfield helpers
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-hybrid-v10-11-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
References: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
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
        Steffen Eiden <seiden@linux.ibm.com>, Fuad Tabba <tabba@google.com>,
        Shannon Zhao <shannon.zhao@linaro.org>,
        Andrew Jones <drjones@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
        Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3005;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=0gFY16czEJJdVIZNruax1OboJIq4DgiNXWKP5yi8iWI=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ9byu0U3TFvWtF0yCX0cefXyDPHK6n9VBduVvl/pj09b/
 HTiTVfGjlIWBjEuBlkxRZaUot3cGtG1nwoT4ltg5rAygQxh4OIUgIlclGNkuNNe1tPrvPnYwlt8
 tzW/v7BPuvtwgfauPZPTw0RmSJ680sfwk9FTzEjkeHFzT7mw+uvo53WPLf03nF3hyzblnK30kdh
 KTgA=
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
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
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

