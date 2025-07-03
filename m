Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40D8A2E7BBF
	for <kvmarm@lists.linux.dev>; Thu,  3 Jul 2025 13:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751551090; cv=none; b=gj90ixnytDhORHHOcoWCqsSUh5IOtoxYw8RbQnHcDbecx1zqLL7Z+w9CY/c8iUZAgP6jvd1sHObZgrq3VNYkcstF7tL132hhd8vOfQe6mh2sDzkMDghCbmoU8ctWq+Hq0Vihj/jmkZdNQ6EJAX67W11f9qforqZwFTf/xY36IvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751551090; c=relaxed/simple;
	bh=eeopCVKDz3gHN66p6tv950nt1239hOeN8CC37RsxxVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdGSlG8t1ZzZM9FtUa4atYbPQ9gUcUvrREmeR+XI7zlE+Dg741012oBiNE2Dn2S7RRm/84jwgwcGaoePkCNnT4oaRNO6unLwNpkJIg8BiCTGliX5CAtnKkkLzDPGQkX0IwCW11QBfgbscBneAiCkkqnkBVhCXjkCe/fTeffXWAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 539CD1596;
	Thu,  3 Jul 2025 06:57:54 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 32AF13F63F;
	Thu,  3 Jul 2025 06:58:06 -0700 (PDT)
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
Subject: [PATCH 2/2] bitfield: Ensure the return value of type##_replace_bits() is checked
Date: Thu,  3 Jul 2025 14:57:29 +0100
Message-ID: <20250703135729.1807517-3-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250703135729.1807517-1-ben.horgan@arm.com>
References: <20250703135729.1807517-1-ben.horgan@arm.com>
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

Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 include/linux/bitfield.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 6d9a53db54b6..39333b80d22b 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -195,8 +195,8 @@ static __always_inline __##type type##_encode_bits(base v, base field)	\
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
-- 
2.43.0

