Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59E71642B
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 07:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080728; cv=none; b=i/F9I5wCxkIYC9vUm9Wh0MerkIyzia047UbuUs4N52X9EjOkpSF43Q54lfgVJViAWqp8dZJ/HjfbGm2mJwWMkVovsb5LdhM+wfXljCM1PvlwL8N0nPsz/HcWp1V2C1il7HILta7tmerH6OUEfrIi/9H36lbFJlyb/NeCtHb7GCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080728; c=relaxed/simple;
	bh=IN4KDvowCe3MO9rkYJNYvtUV5oiLR52aCvOB2p8kqH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=mUI5OSsgYqZ+URz598+VHX7KBMQxn/PU1utOq1BtpydzcQtLHuKq5BzU7YrY+fqA2cqmt/nUtEtpS7C7p+8hGVe5SxbzJk5b/4imX6zmjktjmSUHVV1q2U0/zRTNSrF7B6v8iGZgBpQKr5JvNkeJwGWZREn4dDilmgRhbBEYRCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r3qCMNbe; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r3qCMNbe"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706080725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r/ajjahsx2Nrd2/mL5O1tszPf4Vqor3QjjtEx7SCtlA=;
	b=r3qCMNbeX8fIkl46iwk53h9zb/5qgrTc4mDj2YhDzj87QhRfn2oLGrWXS4mVDj2hWJ6R5P
	i4ltH/23vENg9pkD25kcn707aVURKhvRJxxxyWyq8AyuuMGxz03pwd/AHPGh+UUvGkqJvH
	jJGfUqU12wM4BFdtNGiQQCKbySXNLGU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH 10/24] riscv: Add backtrace support
Date: Wed, 24 Jan 2024 08:18:26 +0100
Message-ID: <20240124071815.6898-36-andrew.jones@linux.dev>
In-Reply-To: <20240124071815.6898-26-andrew.jones@linux.dev>
References: <20240124071815.6898-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Enable stack unwinding, even when going through an exception, by
implementing backtrace() and pushing a frame pointer on the stack
in exception_vectors.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/stack.h |  3 +++
 lib/riscv/stack.c     | 32 ++++++++++++++++++++++++++++++++
 riscv/Makefile        |  1 +
 riscv/cstart.S        | 28 ++++++++++++++++++++++++++--
 4 files changed, 62 insertions(+), 2 deletions(-)
 create mode 100644 lib/riscv/stack.c

diff --git a/lib/riscv/asm/stack.h b/lib/riscv/asm/stack.h
index d081d0716d7b..f003ca37c913 100644
--- a/lib/riscv/asm/stack.h
+++ b/lib/riscv/asm/stack.h
@@ -6,4 +6,7 @@
 #error Do not directly include <asm/stack.h>. Just use <stack.h>.
 #endif
 
+#define HAVE_ARCH_BACKTRACE_FRAME
+#define HAVE_ARCH_BACKTRACE
+
 #endif
diff --git a/lib/riscv/stack.c b/lib/riscv/stack.c
new file mode 100644
index 000000000000..712a5478d547
--- /dev/null
+++ b/lib/riscv/stack.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <libcflat.h>
+#include <stack.h>
+
+int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
+{
+	static bool walking;
+	const unsigned long *fp = (unsigned long *)frame;
+	int depth;
+
+	if (walking) {
+		printf("RECURSIVE STACK WALK!!!\n");
+		return 0;
+	}
+	walking = true;
+
+	for (depth = 0; fp && depth < max_depth; ++depth) {
+		return_addrs[depth] = (void *)fp[-1];
+		if (return_addrs[depth] == 0)
+			break;
+		fp = (unsigned long *)fp[-2];
+	}
+
+	walking = false;
+	return depth;
+}
+
+int backtrace(const void **return_addrs, int max_depth)
+{
+	return backtrace_frame(__builtin_frame_address(0),
+			       return_addrs, max_depth);
+}
diff --git a/riscv/Makefile b/riscv/Makefile
index 1243be125c00..4a83f27f7df2 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -30,6 +30,7 @@ cflatobjs += lib/riscv/processor.o
 cflatobjs += lib/riscv/sbi.o
 cflatobjs += lib/riscv/setup.o
 cflatobjs += lib/riscv/smp.o
+cflatobjs += lib/riscv/stack.o
 ifeq ($(ARCH),riscv32)
 cflatobjs += lib/ldiv32.o
 endif
diff --git a/riscv/cstart.S b/riscv/cstart.S
index ac7858ef398f..9bdf2e3b17dd 100644
--- a/riscv/cstart.S
+++ b/riscv/cstart.S
@@ -17,6 +17,22 @@
 
 #define REG_L	__REG_SEL(ld, lw)
 #define REG_S	__REG_SEL(sd, sw)
+#define SZREG	__REG_SEL(8, 4)
+
+#define FP_SIZE 16
+
+.macro push_fp, ra=ra
+	addi	sp, sp, -FP_SIZE
+	REG_S	\ra, (FP_SIZE - SZREG)(sp)
+	REG_S	fp, (FP_SIZE - 2*SZREG)(sp)
+	addi	fp, sp, FP_SIZE
+.endm
+
+.macro pop_fp
+	REG_L	ra, (FP_SIZE - SZREG)(sp)
+	REG_L	fp, (FP_SIZE - 2*SZREG)(sp)
+	addi	sp, sp, FP_SIZE
+.endm
 
 .macro zero_range, tmp1, tmp2
 9998:	beq	\tmp1, \tmp2, 9997f
@@ -73,6 +89,7 @@ start:
 	li	a1, -8192
 	add	a1, sp, a1
 	zero_range a1, sp
+	mv	fp, zero			// Ensure fp starts out as zero
 
 	/* set up exception handling */
 	la	a1, exception_vectors
@@ -200,9 +217,16 @@ halt:
 .balign 4
 .global exception_vectors
 exception_vectors:
-	REG_S	a0, (-PT_SIZE + PT_ORIG_A0)(sp)
-	addi	a0, sp, -PT_SIZE
+	REG_S	a0, (-PT_SIZE - FP_SIZE + PT_ORIG_A0)(sp)
+	addi	a0, sp, -PT_SIZE - FP_SIZE
 	save_context
+	/*
+	 * Set a frame pointer "ra" which points to the last instruction.
+	 * Add 1 to it, because pretty_print_stacks.py subtracts 1.
+	 */
+	REG_L	a1, PT_EPC(a0)
+	addi	a1, a1, 1
+	push_fp	a1
 	mv	sp, a0
 	call	do_handle_exception
 	restore_context
-- 
2.43.0

