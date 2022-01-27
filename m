Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2099C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 16:20:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BF9E4A11C;
	Thu, 27 Jan 2022 11:20:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cu34UvdUXcTV; Thu, 27 Jan 2022 11:20:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78FF149F56;
	Thu, 27 Jan 2022 11:20:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C903049F24
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:20:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id buycALdXTVuG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 11:20:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D336E4B10A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:20:41 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84F07113E;
 Thu, 27 Jan 2022 08:20:41 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4BDA03F766;
 Thu, 27 Jan 2022 08:20:38 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com, andre.przywara@arm.com
Subject: [PATCH v2 kvmtool 07/10] Add cpumask functions
Date: Thu, 27 Jan 2022 16:20:30 +0000
Message-Id: <20220127162033.54290-8-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127162033.54290-1-alexandru.elisei@arm.com>
References: <20220127162033.54290-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Add a handful of cpumask functions, some of which will be used when
dealing with different PMUs on heterogeneous systems.

The maximum number of CPUs in a system, NR_CPUS, which dictates the size of
the cpumask, has been taken from the Kconfig file for each architecture,
from Linux version 5.16.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile                         |   2 +
 arm/aarch32/include/asm/kernel.h |   8 +
 arm/aarch64/include/asm/kernel.h |   8 +
 include/linux/bitmap.h           |  71 +++++++++
 include/linux/bitops.h           |   2 +
 include/linux/bits.h             |   8 +
 include/linux/cpumask.h          |  62 ++++++++
 include/linux/find.h             |  30 ++++
 include/linux/kernel.h           |   6 +
 mips/include/asm/kernel.h        |   8 +
 powerpc/include/asm/kernel.h     |   8 +
 util/bitmap.c                    | 256 +++++++++++++++++++++++++++++++
 util/find.c                      |  40 +++++
 x86/include/asm/kernel.h         |   8 +
 14 files changed, 517 insertions(+)
 create mode 100644 arm/aarch32/include/asm/kernel.h
 create mode 100644 arm/aarch64/include/asm/kernel.h
 create mode 100644 include/linux/bitmap.h
 create mode 100644 include/linux/bits.h
 create mode 100644 include/linux/cpumask.h
 create mode 100644 include/linux/find.h
 create mode 100644 mips/include/asm/kernel.h
 create mode 100644 powerpc/include/asm/kernel.h
 create mode 100644 util/bitmap.c
 create mode 100644 util/find.c
 create mode 100644 x86/include/asm/kernel.h

diff --git a/Makefile b/Makefile
index 2fe5fb0fba62..8bc0bba80833 100644
--- a/Makefile
+++ b/Makefile
@@ -89,6 +89,8 @@ OBJS	+= net/uip/buf.o
 OBJS	+= net/uip/csum.o
 OBJS	+= net/uip/dhcp.o
 OBJS	+= kvm-cmd.o
+OBJS	+= util/bitmap.o
+OBJS	+= util/find.o
 OBJS	+= util/init.o
 OBJS    += util/iovec.o
 OBJS	+= util/rbtree.o
diff --git a/arm/aarch32/include/asm/kernel.h b/arm/aarch32/include/asm/kernel.h
new file mode 100644
index 000000000000..61296094deb1
--- /dev/null
+++ b/arm/aarch32/include/asm/kernel.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ASM_KERNEL_H
+#define __ASM_KERNEL_H
+
+#define NR_CPUS	32
+
+#endif /* __ASM_KERNEL_H */
diff --git a/arm/aarch64/include/asm/kernel.h b/arm/aarch64/include/asm/kernel.h
new file mode 100644
index 000000000000..a2a8d9ed4059
--- /dev/null
+++ b/arm/aarch64/include/asm/kernel.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ASM_KERNEL_H
+#define __ASM_KERNEL_H
+
+#define NR_CPUS	4096
+
+#endif /* __ASM_KERNEL_H */
diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
new file mode 100644
index 000000000000..2b36e9f42cb8
--- /dev/null
+++ b/include/linux/bitmap.h
@@ -0,0 +1,71 @@
+#ifndef KVM__BITMAP_H
+#define KVM__BITMAP_H
+
+#include <stdbool.h>
+#include <string.h>
+
+#include "linux/bitops.h"
+
+#define DECLARE_BITMAP(name,bits) \
+	unsigned long name[BITS_TO_LONGS(bits)]
+
+#define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) & (BITS_PER_LONG - 1)))
+#define BITMAP_LAST_WORD_MASK(nbits) (~0UL >> (-(nbits) & (BITS_PER_LONG - 1)))
+
+static inline void bitmap_zero(unsigned long *dst, unsigned int nbits)
+{
+	unsigned int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
+	memset(dst, 0, len);
+}
+
+#ifdef __LITTLE_ENDIAN
+#define BITMAP_MEM_ALIGNMENT 8
+#else
+#define BITMAP_MEM_ALIGNMENT (8 * sizeof(unsigned long))
+#endif
+#define BITMAP_MEM_MASK (BITMAP_MEM_ALIGNMENT - 1)
+
+void __bitmap_set(unsigned long *map, unsigned int start, int len);
+
+static inline void bitmap_set(unsigned long *map, unsigned int start,
+		unsigned int nbits)
+{
+	if (__builtin_constant_p(nbits) && nbits == 1)
+		set_bit(start, map);
+	else if (__builtin_constant_p(start & BITMAP_MEM_MASK) &&
+		 IS_ALIGNED(start, BITMAP_MEM_ALIGNMENT) &&
+		 __builtin_constant_p(nbits & BITMAP_MEM_MASK) &&
+		 IS_ALIGNED(nbits, BITMAP_MEM_ALIGNMENT))
+		memset((char *)map + start / 8, 0xff, nbits / 8);
+	else
+		__bitmap_set(map, start, nbits);
+}
+
+bool __bitmap_and(unsigned long *dst, const unsigned long *src1,
+		  const unsigned long *src2, unsigned int nbits);
+
+static inline bool bitmap_and(unsigned long *dst, const unsigned long *src1,
+			      const unsigned long *src2, unsigned int nbits)
+{
+	if (nbits >= 0 && nbits <= BITS_PER_LONG)
+		return (*dst = *src1 & *src2 & BITMAP_LAST_WORD_MASK(nbits)) != 0;
+
+	return __bitmap_and(dst, src1, src2, nbits);
+}
+
+int bitmap_parselist(const char *buf, unsigned long *maskp, int nmaskbits);
+
+bool __bitmap_subset(const unsigned long *bitmap1, const unsigned long *bitmap2,
+		     unsigned int nbits);
+
+static inline bool bitmap_subset(const unsigned long *src1,
+				 const unsigned long *src2, unsigned int nbits)
+{
+	if (nbits >= 0 && nbits <= BITS_PER_LONG)
+		return !((*src1 & ~(*src2)) & BITMAP_LAST_WORD_MASK(nbits));
+
+	return __bitmap_subset(src1, src2, nbits);
+}
+
+
+#endif /* KVM__BITMAP_H */
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 3d31f0acf48e..ae33922f5743 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -11,6 +11,8 @@
 #define BITS_PER_BYTE           8
 #define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
 
+#define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
+
 static inline void set_bit(int nr, unsigned long *addr)
 {
 	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
diff --git a/include/linux/bits.h b/include/linux/bits.h
new file mode 100644
index 000000000000..b6b1c2c3f96d
--- /dev/null
+++ b/include/linux/bits.h
@@ -0,0 +1,8 @@
+#ifndef KVM__BITS_H_
+#define KVM__BITS_H_
+
+#define GENMASK(h, l) \
+	((~0UL - (1UL << (l)) + 1) & \
+	 (~0UL >> (BITS_PER_LONG - 1 - (h))))
+
+#endif /* KVM__BITS_H */
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
new file mode 100644
index 000000000000..19aff92bdb5b
--- /dev/null
+++ b/include/linux/cpumask.h
@@ -0,0 +1,62 @@
+#ifndef KVM__CPUMASK_H
+#define KVM__CPUMASK_H
+
+#include <stdbool.h>
+
+#include "linux/bitmap.h"
+#include "linux/find.h"
+#include "linux/kernel.h"
+
+typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
+
+#define cpumask_bits(maskp)	((maskp)->bits)
+
+static inline void cpumask_set_cpu(int cpu, cpumask_t *dstp)
+{
+	set_bit(cpu, cpumask_bits(dstp));
+}
+
+static inline void cpumask_clear_cpu(int cpu, cpumask_t *dstp)
+{
+	clear_bit(cpu, cpumask_bits(dstp));
+}
+
+static inline bool cpumask_test_cpu(int cpu, const cpumask_t *cpumask)
+{
+	return test_bit(cpu, cpumask_bits((cpumask)));
+}
+
+static inline void cpumask_clear(cpumask_t *dstp)
+{
+	bitmap_zero(cpumask_bits(dstp), NR_CPUS);
+}
+
+static inline bool cpumask_and(cpumask_t *dstp, cpumask_t *src1p,
+			       cpumask_t *src2p)
+{
+	return bitmap_and(cpumask_bits(dstp), cpumask_bits(src1p),
+			  cpumask_bits(src2p), NR_CPUS);
+}
+
+static inline unsigned int cpumask_next(int n, const struct cpumask *srcp)
+{
+	return find_next_bit(cpumask_bits(srcp), NR_CPUS, n + 1);
+}
+
+#define for_each_cpu(cpu, maskp)			\
+	for ((cpu) = -1;				\
+	     (cpu) = cpumask_next((cpu), (maskp)),	\
+	     (cpu) < NR_CPUS;)
+
+static inline int cpulist_parse(const char *buf, cpumask_t *dstp)
+{
+	return bitmap_parselist(buf, cpumask_bits(dstp), NR_CPUS);
+}
+
+static inline bool cpumask_subset(const  cpumask_t *src1p,
+				  const  cpumask_t *src2p)
+{
+	return bitmap_subset(cpumask_bits(src1p), cpumask_bits(src2p), NR_CPUS);
+}
+
+#endif /* KVM__CPUMASK_H */
diff --git a/include/linux/find.h b/include/linux/find.h
new file mode 100644
index 000000000000..29c0d67bcd30
--- /dev/null
+++ b/include/linux/find.h
@@ -0,0 +1,30 @@
+#ifndef KVM__FIND_H
+#define KVM__FIND_H
+
+#include <stddef.h>
+
+#include "linux/bitops.h"
+#include "linux/bits.h"
+
+unsigned long _find_next_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long nbits,
+		unsigned long start, unsigned long invert);
+
+static inline
+unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
+			    unsigned long offset)
+{
+	if (size >= 0 && size <= BITS_PER_LONG) {
+		unsigned long val;
+
+		if (offset >= size)
+			return size;
+
+		val = *addr & GENMASK(size - 1, offset);
+		return val ? (unsigned long)__builtin_ctzl(val) : size;
+	}
+
+	return _find_next_bit(addr, NULL, size, offset, 0);
+}
+
+#endif /* KVM__FIND_H */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f2bff5f12b61..6c22f1c06f6d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -2,10 +2,16 @@
 #ifndef KVM__LINUX_KERNEL_H_
 #define KVM__LINUX_KERNEL_H_
 
+#include "asm/kernel.h"
+
+#define __round_mask(x, y)	((__typeof__(x))((y)-1))
+#define round_down(x, y)	((x) & ~__round_mask(x, y))
+
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
+#define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
 
 #ifndef offsetof
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
diff --git a/mips/include/asm/kernel.h b/mips/include/asm/kernel.h
new file mode 100644
index 000000000000..cbceffd02acd
--- /dev/null
+++ b/mips/include/asm/kernel.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ASM_KERNEL_H
+#define __ASM_KERNEL_H
+
+#define NR_CPUS	256
+
+#endif /* __ASM_KERNEL_H */
diff --git a/powerpc/include/asm/kernel.h b/powerpc/include/asm/kernel.h
new file mode 100644
index 000000000000..7b4fe88efd65
--- /dev/null
+++ b/powerpc/include/asm/kernel.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ASM_KERNEL_H
+#define __ASM_KERNEL_H
+
+#define NR_CPUS	2048
+
+#endif /* __ASM_KERNEL_H */
diff --git a/util/bitmap.c b/util/bitmap.c
new file mode 100644
index 000000000000..8bae1c91499d
--- /dev/null
+++ b/util/bitmap.c
@@ -0,0 +1,256 @@
+/*
+ * Taken from Linux kernel version v5.15.
+ */
+#include <ctype.h>
+#include <limits.h>
+#include <stdlib.h>
+#include <strings.h>
+
+#include "linux/bitmap.h"
+#include "linux/bitops.h"
+#include "linux/err.h"
+
+/*
+ * Region 9-38:4/10 describes the following bitmap structure:
+ * 0	   9  12    18			38	     N
+ * .........****......****......****..................
+ *	    ^  ^     ^			 ^	     ^
+ *      start  off   group_len	       end	 nbits
+ */
+struct region {
+	unsigned int start;
+	unsigned int off;
+	unsigned int group_len;
+	unsigned int end;
+	unsigned int nbits;
+};
+
+void __bitmap_set(unsigned long *map, unsigned int start, int len)
+{
+	unsigned long *p = map + BIT_WORD(start);
+	const unsigned int size = start + len;
+	int bits_to_set = BITS_PER_LONG - (start % BITS_PER_LONG);
+	unsigned long mask_to_set = BITMAP_FIRST_WORD_MASK(start);
+
+	while (len - bits_to_set >= 0) {
+		*p |= mask_to_set;
+		len -= bits_to_set;
+		bits_to_set = BITS_PER_LONG;
+		mask_to_set = ~0UL;
+		p++;
+	}
+	if (len) {
+		mask_to_set &= BITMAP_LAST_WORD_MASK(size);
+		*p |= mask_to_set;
+	}
+}
+
+static void bitmap_set_region(const struct region *r, unsigned long *bitmap)
+{
+	unsigned int start;
+
+	for (start = r->start; start <= r->end; start += r->group_len)
+		bitmap_set(bitmap, start, min(r->end - start + 1, r->off));
+}
+
+static inline bool __end_of_region(char c)
+{
+	return isspace(c) || c == ',';
+}
+
+static inline bool end_of_str(char c)
+{
+	return c == '\0' || c == '\n';
+}
+
+static inline bool end_of_region(char c)
+{
+	return __end_of_region(c) || end_of_str(c);
+}
+
+/*
+ * The format allows commas and whitespaces at the beginning
+ * of the region.
+ */
+static const char *bitmap_find_region(const char *str)
+{
+	while (__end_of_region(*str))
+		str++;
+
+	return end_of_str(*str) ? NULL : str;
+}
+
+static int bitmap_check_region(const struct region *r)
+{
+	if (r->start > r->end || r->group_len == 0 || r->off > r->group_len)
+		return -EINVAL;
+
+	if (r->end >= r->nbits)
+		return -ERANGE;
+
+	return 0;
+}
+
+static const char *bitmap_getnum(const char *str, unsigned int *num,
+				 unsigned int lastbit)
+{
+	unsigned long long n;
+	char *endptr;
+
+	if (str[0] == 'N') {
+		*num = lastbit;
+		return str + 1;
+	}
+
+	n = strtoll(str, &endptr, 10);
+	/* No digits found. */
+	if (n == 0 && endptr == str)
+		return ERR_PTR(-EINVAL);
+	/* Check for overflows and negative numbers. */
+	if (n == ULLONG_MAX || n != (unsigned long)n || n != (unsigned int)n)
+		return ERR_PTR(-EOVERFLOW);
+
+	*num = n;
+	return endptr;
+}
+
+static const char *bitmap_parse_region(const char *str, struct region *r)
+{
+	unsigned int lastbit = r->nbits - 1;
+
+	if (!strncasecmp(str, "all", 3)) {
+		r->start = 0;
+		r->end = lastbit;
+		str += 3;
+
+		goto check_pattern;
+	}
+
+	str = bitmap_getnum(str, &r->start, lastbit);
+	if (IS_ERR(str))
+		return str;
+
+	if (end_of_region(*str))
+		goto no_end;
+
+	if (*str != '-')
+		return ERR_PTR(-EINVAL);
+
+	str = bitmap_getnum(str + 1, &r->end, lastbit);
+	if (IS_ERR(str))
+		return str;
+
+check_pattern:
+	if (end_of_region(*str))
+		goto no_pattern;
+
+	if (*str != ':')
+		return ERR_PTR(-EINVAL);
+
+	str = bitmap_getnum(str + 1, &r->off, lastbit);
+	if (IS_ERR(str))
+		return str;
+
+	if (*str != '/')
+		return ERR_PTR(-EINVAL);
+
+	return bitmap_getnum(str + 1, &r->group_len, lastbit);
+
+no_end:
+	r->end = r->start;
+no_pattern:
+	r->off = r->end + 1;
+	r->group_len = r->end + 1;
+
+	return end_of_str(*str) ? NULL : str;
+}
+
+/**
+ * bitmap_parselist - convert list format ASCII string to bitmap
+ * @buf: read user string from this buffer; must be terminated
+ *    with a \0 or \n.
+ * @maskp: write resulting mask here
+ * @nmaskbits: number of bits in mask to be written
+ *
+ * Input format is a comma-separated list of decimal numbers and
+ * ranges.  Consecutively set bits are shown as two hyphen-separated
+ * decimal numbers, the smallest and largest bit numbers set in
+ * the range.
+ * Optionally each range can be postfixed to denote that only parts of it
+ * should be set. The range will divided to groups of specific size.
+ * From each group will be used only defined amount of bits.
+ * Syntax: range:used_size/group_size
+ * Example: 0-1023:2/256 ==> 0,1,256,257,512,513,768,769
+ * The value 'N' can be used as a dynamically substituted token for the
+ * maximum allowed value; i.e (nmaskbits - 1).  Keep in mind that it is
+ * dynamic, so if system changes cause the bitmap width to change, such
+ * as more cores in a CPU list, then any ranges using N will also change.
+ *
+ * Returns: 0 on success, -errno on invalid input strings. Error values:
+ *
+ *   - ``-EINVAL``: wrong region format
+ *   - ``-EINVAL``: invalid character in string
+ *   - ``-ERANGE``: bit number specified too large for mask
+ *   - ``-EOVERFLOW``: integer overflow in the input parameters
+ */
+int bitmap_parselist(const char *buf, unsigned long *maskp, int nmaskbits)
+{
+	struct region r;
+	long ret;
+
+	r.nbits = nmaskbits;
+	bitmap_zero(maskp, r.nbits);
+
+	while (buf) {
+		buf = bitmap_find_region(buf);
+		if (buf == NULL)
+			return 0;
+
+		buf = bitmap_parse_region(buf, &r);
+		if (IS_ERR(buf))
+			return PTR_ERR(buf);
+
+		ret = bitmap_check_region(&r);
+		if (ret)
+			return ret;
+
+		bitmap_set_region(&r, maskp);
+	}
+
+	return 0;
+}
+
+bool __bitmap_and(unsigned long *dst, const unsigned long *src1,
+		  const unsigned long *src2, unsigned int nbits)
+{
+	unsigned int lim = nbits / BITS_PER_LONG;
+	unsigned long result = 0;
+	unsigned int k;
+
+	for (k = 0; k < lim; k++)
+		result |= (dst[k] = src1[k] & src2[k]);
+
+	if (nbits % BITS_PER_LONG) {
+		result |= (dst[k] = src1[k] & src2[k] &
+			   BITMAP_LAST_WORD_MASK(nbits));
+	}
+
+	return result != 0;
+}
+
+bool __bitmap_subset(const unsigned long *bitmap1, const unsigned long *bitmap2,
+		     unsigned int nbits)
+{
+	unsigned int k, lim = nbits / BITS_PER_LONG;
+
+	for (k = 0; k < lim; k++)
+		if (bitmap1[k] & ~bitmap2[k])
+			return false;
+
+	if (nbits % BITS_PER_LONG) {
+		if ((bitmap1[k] & ~bitmap2[k]) & BITMAP_LAST_WORD_MASK(nbits))
+			return false;
+	}
+
+	return true;
+}
diff --git a/util/find.c b/util/find.c
new file mode 100644
index 000000000000..a438f2388e00
--- /dev/null
+++ b/util/find.c
@@ -0,0 +1,40 @@
+/*
+ * Taken from Linux kernel version v5.16.
+ */
+#include "linux/bitmap.h"
+#include "linux/find.h"
+#include "linux/kernel.h"
+
+unsigned long _find_next_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long nbits,
+		unsigned long start, unsigned long invert)
+{
+	unsigned long tmp, mask;
+
+	if (start >= nbits)
+		return nbits;
+
+	tmp = addr1[start / BITS_PER_LONG];
+	if (addr2)
+		tmp &= addr2[start / BITS_PER_LONG];
+	tmp ^= invert;
+
+	/* Handle 1st word. */
+	mask = BITMAP_FIRST_WORD_MASK(start);
+	tmp &= mask;
+
+	start = round_down(start, BITS_PER_LONG);
+
+	while (!tmp) {
+		start += BITS_PER_LONG;
+		if (start >= nbits)
+			return nbits;
+
+		tmp = addr1[start / BITS_PER_LONG];
+		if (addr2)
+			tmp &= addr2[start / BITS_PER_LONG];
+		tmp ^= invert;
+	}
+
+	return min(start + __builtin_ctzl(tmp), nbits);
+}
diff --git a/x86/include/asm/kernel.h b/x86/include/asm/kernel.h
new file mode 100644
index 000000000000..87fad2a0300a
--- /dev/null
+++ b/x86/include/asm/kernel.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _ASM_KERNEL_H
+#define _ASM_KERNEL_H
+
+#define NR_CPUS	8196
+
+#endif /* _ASM_KERNEL_H */
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
