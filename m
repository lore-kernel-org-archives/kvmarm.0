Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D74383A4F2F
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774880655; cv=none; b=P2eyem1gcK4NFqCTbVEnfJ1qrwN4SK2PgqEkPq9izV++x0aXItmuhvw7vQC12l0CTY7CE9VxF9oR4u+vJuOmMMfK1jUKGnZDjVqYXz9JiIKKzVxDqnAdMUDDnEOY09/M/kpW0+zwsbZ3xuNdBSCgw1mfPmnd2me0zbdH+/2PSFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774880655; c=relaxed/simple;
	bh=v9TjnqFdk60+C8t/qKNrelNzJG6zoK6/zHQBa6IwvdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qfMCAYjKztMgIiYyRxxYjtyktpJJutNTlgx1OtEpSHhss6slBXx6Dt5W6njd1FqYq3uRczVjRnkQtPz/sHggyi6GPltK5DVcjiI7k0Xpu4B2eG4JixrIK/JNVjZvPdgQfYf6nlsnYWN00kIt+PUP4Ixpy5koxIQvJWiX4W3o3WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BX1ZmAao; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BX1ZmAao"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 67B741D15;
	Mon, 30 Mar 2026 07:24:07 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A35DD3F915;
	Mon, 30 Mar 2026 07:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774880653; bh=v9TjnqFdk60+C8t/qKNrelNzJG6zoK6/zHQBa6IwvdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BX1ZmAaoSL4Huo2adkdq7fo0Co0dS9tWwDjBh2NRe0BFZKstjwFqJdcjJHiWL3AJc
	 Zcn3VpqXWYgSm3SlROqfNu8hMA0AfTZYjzWyPvfAgE79BJb3Y4AmZE5gQY3RCZNkWw
	 wu+CMxyWdG3ee/CTwdpl50kfYbveRtmHU/qxPyLs=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev,
	will@kernel.org
Cc: kvm@vger.kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	aneesh.kumar@kernel.org,
	linux-kernel@vger.kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v7 01/17] headers: Update linux/const.h from linux sources
Date: Mon, 30 Mar 2026 15:23:18 +0100
Message-ID: <20260330142334.3309961-2-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260330142334.3309961-1-suzuki.poulose@arm.com>
References: <20260330142334.3309961-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Building kvmtool from scratch gives me the following errors with buildroot:

In file included from include/kvm/pci.h:7,
                 from include/kvm/vfio.h:6,
                 from include/kvm/kvm-config.h:5,
                 from include/kvm/kvm.h:6,
                 from builtin-version.c:4:
include/linux/virtio_pci.h:323:20: warning: implicit declaration of function ‘__KERNEL_DIV_ROUND_UP’ [-Wimplicit-function-declaration]
  323 | #define MAX_CAP_ID __KERNEL_DIV_ROUND_UP(VIRTIO_DEV_PARTS_CAP + 1, 64)
      |                    ^~~~~~~~~~~~~~~~~~~~~
include/linux/virtio_pci.h:326:24: note: in expansion of macro ‘MAX_CAP_ID’
  326 |  __le64 supported_caps[MAX_CAP_ID];
      |                        ^~~~~~~~~~
include/linux/virtio_pci.h:326:9: error: variably modified ‘supported_caps’ at file scope
  326 |  __le64 supported_caps[MAX_CAP_ID];

We inherit linux/virtio_pci.h from the kernel sources and won't be good to fix
it by including linux/kernel.h. Instead, pick up up uapi/linux/const.h from the
kernel tree. This also removes the ifdefery linux/kernel.h

To prevent a build warning for redefinition, update the headers from v6.19,
remove the hack from linux.kernel.h in one shot. This was also discussed in
the Link, in another context.

Cc: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/all/20250211114018.GB8965@willie-the-truck/
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 include/linux/const.h  | 53 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/kernel.h |  3 ---
 2 files changed, 53 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/const.h

diff --git a/include/linux/const.h b/include/linux/const.h
new file mode 100644
index 00000000..b8f629ef
--- /dev/null
+++ b/include/linux/const.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* const.h: Macros for dealing with constants.  */
+
+#ifndef _UAPI_LINUX_CONST_H
+#define _UAPI_LINUX_CONST_H
+
+/* Some constant macros are used in both assembler and
+ * C code.  Therefore we cannot annotate them always with
+ * 'UL' and other type specifiers unilaterally.  We
+ * use the following macros to deal with this.
+ *
+ * Similarly, _AT() will cast an expression with a type in C, but
+ * leave it unchanged in asm.
+ */
+
+#ifdef __ASSEMBLY__
+#define _AC(X,Y)	X
+#define _AT(T,X)	X
+#else
+#define __AC(X,Y)	(X##Y)
+#define _AC(X,Y)	__AC(X,Y)
+#define _AT(T,X)	((T)(X))
+#endif
+
+#define _UL(x)		(_AC(x, UL))
+#define _ULL(x)		(_AC(x, ULL))
+
+#define _BITUL(x)	(_UL(1) << (x))
+#define _BITULL(x)	(_ULL(1) << (x))
+
+#if !defined(__ASSEMBLY__)
+/*
+ * Missing asm support
+ *
+ * __BIT128() would not work in the asm code, as it shifts an
+ * 'unsigned __int128' data type as direct representation of
+ * 128 bit constants is not supported in the gcc compiler, as
+ * they get silently truncated.
+ *
+ * TODO: Please revisit this implementation when gcc compiler
+ * starts representing 128 bit constants directly like long
+ * and unsigned long etc. Subsequently drop the comment for
+ * GENMASK_U128() which would then start supporting asm code.
+ */
+#define _BIT128(x)	((unsigned __int128)(1) << (x))
+#endif
+
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+
+#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+
+#endif /* _UAPI_LINUX_CONST_H */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index df42d63a..6c22f1c0 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -8,9 +8,6 @@
 #define round_down(x, y)	((x) & ~__round_mask(x, y))
 
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
-#ifndef __KERNEL_DIV_ROUND_UP
-#define __KERNEL_DIV_ROUND_UP(n,d)	DIV_ROUND_UP(n,d)
-#endif
 
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
-- 
2.43.0

