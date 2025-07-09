Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8625A289E38
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 09:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752053910; cv=none; b=l8NqjwsCaJjAtFk71qv+P5Wm0y2cINpQln9gRVTh1cZncvki+07oZGJWp8RlEvHFl7yu+0ymtX424Cs/ZXr62bRkDXZT8ORVuPBZoqNlJPwyrEnVvUpthMAtgiOCQPo1X9JFp+fg2q44Yzh0iney/vdgnU8BTVRHXAqqQ9+pKFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752053910; c=relaxed/simple;
	bh=Db9e+iXLe/WttAm6uqRxgVXYTlbnGiDEOFfbnzWYtmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/lJqPM/X9Y05P94sVz0CAUE9oh2JZAT6djsCeVjO8640sQy82aW7m3gB07F0esUCa0yD2wkCvqu6ygkwheHDZr0YyiQb55eWEFWCmLC6pcM3t89+Q0p0pDE7RI+8OyQsnOPQ2/aox+0bGp089SiQ1IvjU68KM3fSnh7zw2LZIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62BCC153B;
	Wed,  9 Jul 2025 02:38:17 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 067563F738;
	Wed,  9 Jul 2025 02:38:26 -0700 (PDT)
From: Ben Horgan <ben.horgan@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	linux-kernel@vger.kernel.org
Cc: james.morse@arm.com,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v2 2/2] bitfield: Ensure the return values of helper functions are checked
Date: Wed,  9 Jul 2025 10:38:08 +0100
Message-ID: <20250709093808.920284-3-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250709093808.920284-1-ben.horgan@arm.com>
References: <20250709093808.920284-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As type##_replace_bits() has no side effects it is only useful if its
return value is checked. Add __must_check to enforce this usage. To have
the bits replaced in-place typep##_replace_bits() can be used instead.

Although, type_##_get_bits() and type_##_encode_bits() are harder to misuse
they are still only useful if the return value is checked. For
consistency, also add __must_check to these.

Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 include/linux/bitfield.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 6d9a53db54b6..5355f8f806a9 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -189,14 +189,14 @@ static __always_inline u64 field_mask(u64 field)
 }
 #define field_max(field)	((typeof(field))field_mask(field))
 #define ____MAKE_OP(type,base,to,from)					\
-static __always_inline __##type type##_encode_bits(base v, base field)	\
+static __always_inline __##type __must_check type##_encode_bits(base v, base field)	\
 {									\
 	if (__builtin_constant_p(v) && (v & ~field_mask(field)))	\
 		__field_overflow();					\
 	return to((v & field_mask(field)) * field_multiplier(field));	\
 }									\
-static __always_inline __##type type##_replace_bits(__##type old,	\
-					base val, base field)		\
+static __always_inline __##type __must_check type##_replace_bits(__##type old,	\
+							base val, base field)	\
 {									\
 	return (old & ~to(field)) | type##_encode_bits(val, field);	\
 }									\
@@ -205,7 +205,7 @@ static __always_inline void type##p_replace_bits(__##type *p,		\
 {									\
 	*p = (*p & ~to(field)) | type##_encode_bits(val, field);	\
 }									\
-static __always_inline base type##_get_bits(__##type v, base field)	\
+static __always_inline base __must_check type##_get_bits(__##type v, base field)	\
 {									\
 	return (from(v) & field)/field_multiplier(field);		\
 }
-- 
2.43.0

