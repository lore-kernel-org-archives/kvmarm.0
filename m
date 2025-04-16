Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133BD20CCFA
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 15:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744817219; cv=none; b=k1OguvcBWrPbtiT5sehMw5SBUxX6BhwceiLYgYWcO278q+UJVzv+zMMnd/234JtIvnbPNKRd+Z1cz6WmzYw07WJP2C5kMla/3b0pJr9920Rx/7J6bS3pG2fgyha3Heo3Rvpgk2Of/UbuDrmVVHTMnRdTYvc5dKMpzmwMACMj3RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744817219; c=relaxed/simple;
	bh=lw3AVtJbpuAwOe11LdCap/7mFJF4YAPAEl8JSKKuzOs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jVmoAub2ndglv5hbdfxpJoytj/7HvA5/OPhbpk7wZdpxelvtcsDTMsgg2u3/Jrl8FBv0ismAJzDZ06fzpcQXXA+6LoF96inhd9CtNz4Uxtg0/QokHgBnZ+8VLVfc+KT9qUw3PGhPapp7qye/mvyLM5sxaSNeQvVPWxMnljw3ZDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Om1sa76h; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Om1sa76h"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5e6eb748b17so5835216a12.3
        for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 08:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744817215; x=1745422015; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ySUALm4kAiEtFHHbP93/9gqyCVQ7SC9yKGUHGHBoiHU=;
        b=Om1sa76h2OIaNRrFtyFVrBX2158eyyCMUw+cLgoCQIBemR7FAqZg8gVTWruwAIwV2d
         v5Xc1+gUQ+d2tR3c0u2GT423IJBxOMsybpCUwa7CeVaULCBjeBMfPjDXNyPdUTQm+hdY
         EchhDheWgCxnNMYOqQa+4V0FcsYxN6+GvD519Lax0gCwJ/Ocw9N9sfsHRMnMXULQk10g
         6BCuKZDU7WPQJNIfFxJ/kvbOsKV2vWkCc8M8NebzOh/Y9/XGWxyS04O4F5N7fBzUwjKw
         3nX/onEF9jGU7DSYz4NKVUuuNQeiNdOC3bkdqCkYSSctSBb//IJID0mLemNegfKBzgYc
         BgeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744817215; x=1745422015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ySUALm4kAiEtFHHbP93/9gqyCVQ7SC9yKGUHGHBoiHU=;
        b=vbTUWKq4YYXXMwFKh4cPQcWBTxEv/9XfZMB3VWW/q6cMwGm3g4rUx8aOaIR3sDc/pQ
         g0YWF4HPIC6wVJyf/U424Yay/TJ52DTRO9cK/xjpPhoQ0Ex0+k7NTOiqDhoOc+YUXpz8
         XSbW/LrlCKNsrMgesMct9D3Ts9Mazz6dX/YgVClHjUxfWa5hhpR3FLYpZw2TCzjkcfp6
         b+BCQupX4p5pHaKORVWbtOIPIyUZtlBTD/X6+GMV+4aQx/LBafRIX7WlP2wgOv6VoQkr
         i9M5xhpN+JdXMiExYlOUmaONGSwaSTctCwFvNa31Ikt3gJrk9kx3v+zkjzzhXOATHoeC
         u+xg==
X-Forwarded-Encrypted: i=1; AJvYcCU5tEz2OAB87hEzfHtPxv6/wERjROPeeccGJJxXx/6LOyn9hgXqIPZnWOFFt1oIspI700FXurA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9bzXpzoWjGhG7wuR9BbZ+IyJj0ZziU8dUofF0EXqC7LDeRAfN
	XBSofevGWYmD7JFkbpBhfJUyT9uu0xdUGdqCWCvQAGkHBq4zhvB907nkBhZeSFYtgawGAQZuR9L
	n8NAD0A==
X-Google-Smtp-Source: AGHT+IFO6LqLQpchltIVKkcVMTkkcoAUlzOcNnFkY+QSrpAdIOkv/ajoQQVC0VjwY0/SmeO3qq2XvFKzCmMO
X-Received: from edb17.prod.google.com ([2002:a05:6402:2391:b0:5f4:b71f:15a6])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:26c8:b0:5f4:c619:2392
 with SMTP id 4fb4d7f45d1cf-5f4c6192660mr959365a12.1.1744817215420; Wed, 16
 Apr 2025 08:26:55 -0700 (PDT)
Date: Wed, 16 Apr 2025 15:26:42 +0000
In-Reply-To: <20250416152648.2982950-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250416152648.2982950-1-qperret@google.com>
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
Message-ID: <20250416152648.2982950-3-qperret@google.com>
Subject: [PATCH v2 2/7] KVM: arm64: Fix pKVM page-tracking comments
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <tabba@google.com>, 
	Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Most of the comments relating to pKVM page-tracking in nvhe/memory.h are
now either slightly outdated or outright wrong. Fix the comments.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/memory.h | 29 ++++++++++++++++--------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 34233d586060..178028172c0b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -8,20 +8,29 @@
 #include <linux/types.h>
 
 /*
- * Bits 0-1 are reserved to track the memory ownership state of each page:
- *   00: The page is owned exclusively by the page-table owner.
- *   01: The page is owned by the page-table owner, but is shared
- *       with another entity.
- *   10: The page is shared with, but not owned by the page-table owner.
- *   11: Reserved for future use (lending).
+ * Bits 0-1 are used to encode the memory ownership state of each page from the
+ * point of view of a pKVM "component" (host, hyp, guest, ... see enum
+ * pkvm_component_id):
+ *   00: The page is owned and exclusively accessible by the component;
+ *   01: The page is owned and accessible by the component, but is also
+ *       accessible by another component;
+ *   10: The page is accessible but not owned by the component;
+ * The storage of this state depends on the component: either in the
+ * hyp_vmemmap for the host state or in PTE software bits for the hypervisor
+ * and guests.
  */
 enum pkvm_page_state {
 	PKVM_PAGE_OWNED			= 0ULL,
 	PKVM_PAGE_SHARED_OWNED		= BIT(0),
 	PKVM_PAGE_SHARED_BORROWED	= BIT(1),
-	__PKVM_PAGE_RESERVED		= BIT(0) | BIT(1),
-
-	/* Meta-states which aren't encoded directly in the PTE's SW bits */
+	__PKVM_PAGE_RESERVED            = BIT(0) | BIT(1),
+
+	/*
+	 * 'Meta-states' are not stored directly in PTE SW bits for hyp and
+	 * guest states, but inferred from the context (e.g. invalid PTE
+	 * entries). For the host, meta-states are stored directly in the
+	 * struct hyp_page.
+	 */
 	PKVM_NOPAGE			= BIT(2),
 };
 #define PKVM_PAGE_META_STATES_MASK	(~__PKVM_PAGE_RESERVED)
@@ -44,7 +53,7 @@ struct hyp_page {
 	u16 refcount;
 	u8 order;
 
-	/* Host (non-meta) state. Guarded by the host stage-2 lock. */
+	/* Host state. Guarded by the host stage-2 lock. */
 	enum pkvm_page_state host_state : 8;
 
 	u32 host_share_guest_count;
-- 
2.49.0.604.gff1f9ca942-goog

