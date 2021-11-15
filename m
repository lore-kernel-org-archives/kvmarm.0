Return-Path: <SRS0=JhWI=QC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4439FC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 15 Nov 2021 16:55:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EEBD560174
	for <kvmarm@archiver.kernel.org>; Mon, 15 Nov 2021 16:55:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EEBD560174
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A330F4B1BD;
	Mon, 15 Nov 2021 11:55:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VgiG-zOoTFdO; Mon, 15 Nov 2021 11:55:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6ADD4B1D0;
	Mon, 15 Nov 2021 11:55:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5A424B150
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Nov 2021 11:55:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EMBQVbBxNuzA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Nov 2021 11:55:38 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F5E84B1E3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Nov 2021 11:55:38 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C735C1063;
 Mon, 15 Nov 2021 08:55:37 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 547953F766;
 Mon, 15 Nov 2021 08:55:36 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com
Subject: [PATCH kvmtool 7/9] util: Add cpulist_parse()
Date: Mon, 15 Nov 2021 16:57:03 +0000
Message-Id: <20211115165705.195736-8-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165705.195736-1-alexandru.elisei@arm.com>
References: <20211115165705.195736-1-alexandru.elisei@arm.com>
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

Add the function cpulist_parse(), which creates a cpumask_t from a
cpulist. The function will be necessary to parse the cpulist of CPUs
associated with a particular PMU.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile                |   1 +
 include/linux/bitmap.h  |  25 +++++
 include/linux/bitops.h  |   2 +
 include/linux/cpumask.h |   5 +
 include/linux/kernel.h  |   1 +
 util/bitmap.c           | 221 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 255 insertions(+)
 create mode 100644 util/bitmap.c

diff --git a/Makefile b/Makefile
index c7820e6a5200..3f65d6b0478d 100644
--- a/Makefile
+++ b/Makefile
@@ -88,6 +88,7 @@ OBJS	+= net/uip/buf.o
 OBJS	+= net/uip/csum.o
 OBJS	+= net/uip/dhcp.o
 OBJS	+= kvm-cmd.o
+OBJS	+= util/bitmap.o
 OBJS	+= util/init.o
 OBJS    += util/iovec.o
 OBJS	+= util/rbtree.o
diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 33b24520a576..3221d06d9200 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -17,4 +17,29 @@ static inline void bitmap_zero(unsigned long *dst, unsigned int nbits)
 	memset(dst, 0, len);
 }
 
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
+int bitmap_parselist(const char *buf, unsigned long *maskp, int nmaskbits);
+
 #endif /* KVM__BITMAP_H */
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 56448b71ebbf..d8df5515ceb8 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -9,6 +9,8 @@
 #define BITS_PER_BYTE           8
 #define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
 
+#define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
+
 static inline void set_bit(int nr, unsigned long *addr)
 {
 	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 36959885aeff..25c11b0361ec 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -30,4 +30,9 @@ static inline void cpumask_clear(cpumask_t *dstp)
 	bitmap_zero(cpumask_bits(dstp), NR_CPUS);
 }
 
+static inline int cpulist_parse(const char *buf, cpumask_t *dstp)
+{
+	return bitmap_parselist(buf, cpumask_bits(dstp), NR_CPUS);
+}
+
 #endif /* KVM__CPUMASK_H */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f3240e09a321..0b9079f9c0bc 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -8,6 +8,7 @@
 
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
+#define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
 
 #ifndef offsetof
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
diff --git a/util/bitmap.c b/util/bitmap.c
new file mode 100644
index 000000000000..eef23d0f1845
--- /dev/null
+++ b/util/bitmap.c
@@ -0,0 +1,221 @@
+/*
+ * Taken from Linux kernel version v5.15.
+ */
+#include <ctype.h>
+#include <limits.h>
+#include <stdlib.h>
+#include <strings.h>
+
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+#include <linux/err.h>
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
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
