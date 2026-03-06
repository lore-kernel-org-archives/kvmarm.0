Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7D351A6821
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807228; cv=none; b=GNfr29uqJEtMBIHITBbAbsVDCpgIzEQ/8nQjKJG5TqncTbAe2d9uYDV3W8IW1o3Y7kJ3AHBOCAFIsXImJJhAnMtStNVya6qr7CoddaysDwvxPJql9EpvAwp2FPRRwcjVVdZBiORc1hXJky3VmVoGWGq5xmE4choCNDhSky41qKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807228; c=relaxed/simple;
	bh=ZH+tVu4PgK3LvC5LiqefRuPslQlCg+CgWH7cAaXA8Ls=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K+ggYxyTXtQh08kVjLFS94m9KUsUc1PckWN5Yi+0xoPRsVnJs7d47xgOAJYmihQhJnuBm/XgbR+TcwcKXlLVaBDWAj/Yue5wTupF3NSoQLTQaLOLcCKY4NnZ92o9GElarEYx80/qOSkCgB6Kv9Q0zR1Fzgua7cisIaTAihTOgCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1441A1516;
	Fri,  6 Mar 2026 06:27:00 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 73DE93F73B;
	Fri,  6 Mar 2026 06:27:05 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: joey.gouly@arm.com,
	andrew.jones@linux.dev,
	alexandru.elisei@arm.com,
	Marc Zyngier <maz@kernel.org>
Subject: [kvm-unit-tests PATCH v1 1/5] arm64: add thread_info helpers
Date: Fri,  6 Mar 2026 14:26:52 +0000
Message-Id: <20260306142656.2775185-2-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260306142656.2775185-1-joey.gouly@arm.com>
References: <20260306142656.2775185-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add helpers for getting the stack address of a thread and freeing a thread.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm/asm/thread_info.h | 11 +++++++++++
 lib/arm64/processor.c     |  5 +++++
 2 files changed, 16 insertions(+)

diff --git a/lib/arm/asm/thread_info.h b/lib/arm/asm/thread_info.h
index be5a060b..70fbb1c0 100644
--- a/lib/arm/asm/thread_info.h
+++ b/lib/arm/asm/thread_info.h
@@ -44,6 +44,11 @@ static inline void *thread_stack_alloc(void)
 	return sp + THREAD_START_SP;
 }
 
+static inline void thread_stack_free(void* sp)
+{
+	free(sp - THREAD_START_SP);
+}
+
 #define TIF_USER_MODE		(1U << 0)
 
 struct thread_info {
@@ -71,7 +76,13 @@ static inline struct thread_info *current_thread_info(void)
 	return thread_info_sp(current_stack_pointer);
 }
 
+static inline void* thread_info_stack_start(struct thread_info *ti)
+{
+	return (void*)((u64)ti + THREAD_START_SP);
+}
+
 extern void thread_info_init(struct thread_info *ti, unsigned int flags);
+extern void thread_info_free(struct thread_info *ti);
 
 #endif /* !__ASSEMBLER__ */
 #endif /* _ASMARM_THREAD_INFO_H_ */
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index f9fea519..7d3d93bf 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -246,6 +246,11 @@ void thread_info_init(struct thread_info *ti, unsigned int flags)
 	vector_handlers_default_init(ti->vector_handlers);
 }
 
+void thread_info_free(struct thread_info* ti)
+{
+	thread_stack_free(thread_info_stack_start(ti));
+}
+
 void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr)
 {
 	sp_usr &= (~15UL); /* stack ptr needs 16-byte alignment */
-- 
2.25.1

