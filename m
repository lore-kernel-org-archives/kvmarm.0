Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B55684A48
	for <kvmarm@lists.linux.dev>; Tue,  2 Apr 2024 13:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712064472; cv=none; b=kwAfVwd616WvOgPpq0Ve9+/HIaq4s1iCAe/T5tyQg5BABOQWrQabmoG5iXSzpia3SEBAUhGy0QPI04iPPTWXCfUR3uO+6AQHyBNzxyBhQdjbTvtnkyVi6RtBXVvizmnkZp3/A4g5W/D0ATNuTioXSF13rReqdovctIm5JoWnkDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712064472; c=relaxed/simple;
	bh=8WoQMDX9PjkTiMoh/bKUl2t9/+IvRh90KSbDPkuMtJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=auBddqyzj3Xnjj0/vWTah0sg65dyO23gyRGMvon1/rjZPPogjs0fA2Xau/qTq6rTNIlCQ39FbnxGueq/vlMC2XjtGnFp83DBsqnPOO7MsQWN+VatsYnFF13Do6W3U2LrnVoucRSjEJDKw9YmBNHaoUNQiGHauPWMuO023fn6nXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TUZ2p55q; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TUZ2p55q"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712064467;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rQ983P7mdXMBoWSGPXJK87yDU4col+MjJS8LnJtNt14=;
	b=TUZ2p55qyp9/0VuxsP91G18OPfEQAwxbN/e3f5WdKJ1xSwcjqF6j3CLwhyOPSy1Jymu9GH
	H7t2hWErBjf9JDdv3DZ5HbvjSfQS8LTaYP92mRdNZRjENHQgfPhBKa3jwFf2U5U1iy/L4L
	3+fwFn0fdYofMnYzLxzPl2nfw50dTTc=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/3] arm64: Prepare for LPA2
Date: Tue,  2 Apr 2024 15:27:41 +0200
Message-ID: <20240402132739.201939-6-andrew.jones@linux.dev>
In-Reply-To: <20240402132739.201939-5-andrew.jones@linux.dev>
References: <20240402132739.201939-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When checking for supported granules also check for the values
which indicate support when LPA2 is implemented.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm64/asm/processor.h | 49 +++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 1c73ba32725a..bab9c26c2c9e 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -110,31 +110,36 @@ static inline unsigned long get_id_aa64mmfr0_el1(void)
 #define ID_AA64MMFR0_TGRAN64_SHIFT	24
 #define ID_AA64MMFR0_TGRAN16_SHIFT	20
 
-#define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
-#define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
-#define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
+#define ID_AA64MMFR0_TGRAN4_SUPPORTED(r)			\
+({								\
+	u64 __v = ((r) >> ID_AA64MMFR0_TGRAN4_SHIFT) & 0xf;	\
+	(__v) == 0 || (__v) == 1;				\
+})
+
+#define ID_AA64MMFR0_TGRAN64_SUPPORTED(r)			\
+({								\
+	u64 __v = ((r) >> ID_AA64MMFR0_TGRAN64_SHIFT) & 0xf;	\
+	(__v) == 0;						\
+})
+
+#define ID_AA64MMFR0_TGRAN16_SUPPORTED(r)			\
+({								\
+	u64 __v = ((r) >> ID_AA64MMFR0_TGRAN16_SHIFT) & 0xf;	\
+	(__v) == 1 || (__v) == 2;				\
+})
 
 static inline bool system_supports_granule(size_t granule)
 {
-	u32 shift;
-	u32 val;
-	u64 mmfr0;
-
-	if (granule == SZ_4K) {
-		shift = ID_AA64MMFR0_TGRAN4_SHIFT;
-		val = ID_AA64MMFR0_TGRAN4_SUPPORTED;
-	} else if (granule == SZ_16K) {
-		shift = ID_AA64MMFR0_TGRAN16_SHIFT;
-		val = ID_AA64MMFR0_TGRAN16_SUPPORTED;
-	} else {
-		assert(granule == SZ_64K);
-		shift = ID_AA64MMFR0_TGRAN64_SHIFT;
-		val = ID_AA64MMFR0_TGRAN64_SUPPORTED;
-	}
-
-	mmfr0 = get_id_aa64mmfr0_el1();
-
-	return ((mmfr0 >> shift) & 0xf) == val;
+	u64 mmfr0 = get_id_aa64mmfr0_el1();
+
+	if (granule == SZ_4K)
+		return ID_AA64MMFR0_TGRAN4_SUPPORTED(mmfr0);
+
+	if (granule == SZ_16K)
+		return ID_AA64MMFR0_TGRAN16_SUPPORTED(mmfr0);
+
+	assert(granule == SZ_64K);
+	return ID_AA64MMFR0_TGRAN64_SUPPORTED(mmfr0);
 }
 
 #endif /* !__ASSEMBLY__ */
-- 
2.44.0

