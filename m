Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93DE23C17
	for <kvmarm@lists.linux.dev>; Fri, 28 Apr 2023 12:05:08 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7624F150C;
	Fri, 28 Apr 2023 05:05:52 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 844E53F5A1;
	Fri, 28 Apr 2023 05:05:07 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com,
	alexandru.elisei@arm.com,
	ricarkol@google.com
Subject: [kvm-unit-tests PATCH v5 17/29] lib/printf: Add support for printing wide strings
Date: Fri, 28 Apr 2023 13:03:53 +0100
Message-Id: <20230428120405.3770496-18-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit

This change adds support for wide strings (u16*) to printf()
variants. This feature is used by a future change.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
---
 lib/printf.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 100 insertions(+), 1 deletion(-)

diff --git a/lib/printf.c b/lib/printf.c
index d600199b..27041bb4 100644
--- a/lib/printf.c
+++ b/lib/printf.c
@@ -58,6 +58,102 @@ static void print_str(pstream_t *p, const char *s, strprops_t props)
 	}
 }
 
+/*
+ * Adapted from drivers/firmware/efi/libstub/vsprintf.c
+ */
+static u32 utf16_to_utf32(const u16 **s16)
+{
+	u16 c0, c1;
+
+	c0 = *(*s16)++;
+	/* not a surrogate */
+	if ((c0 & 0xf800) != 0xd800)
+		return c0;
+	/* invalid: low surrogate instead of high */
+	if (c0 & 0x0400)
+		return 0xfffd;
+	c1 = **s16;
+	/* invalid: missing low surrogate */
+	if ((c1 & 0xfc00) != 0xdc00)
+		return 0xfffd;
+	/* valid surrogate pair */
+	++(*s16);
+	return (0x10000 - (0xd800 << 10) - 0xdc00) + (c0 << 10) + c1;
+}
+
+/*
+ * Adapted from drivers/firmware/efi/libstub/vsprintf.c
+ */
+static size_t utf16s_utf8nlen(const u16 *s16, size_t maxlen)
+{
+	size_t len, clen;
+
+	for (len = 0; len < maxlen && *s16; len += clen) {
+		u16 c0 = *s16++;
+
+		/* First, get the length for a BMP character */
+		clen = 1 + (c0 >= 0x80) + (c0 >= 0x800);
+		if (len + clen > maxlen)
+			break;
+		/*
+		 * If this is a high surrogate, and we're already at maxlen, we
+		 * can't include the character if it's a valid surrogate pair.
+		 * Avoid accessing one extra word just to check if it's valid
+		 * or not.
+		 */
+		if ((c0 & 0xfc00) == 0xd800) {
+			if (len + clen == maxlen)
+				break;
+			if ((*s16 & 0xfc00) == 0xdc00) {
+				++s16;
+				++clen;
+			}
+		}
+	}
+
+	return len;
+}
+
+/*
+ * Adapted from drivers/firmware/efi/libstub/vsprintf.c
+ */
+static void print_wstring(pstream_t *p, const u16 *s, strprops_t props)
+{
+	const u16 *ws = (const u16 *)s;
+	size_t pos = 0, size = p->remain + 1, len = utf16s_utf8nlen(ws, props.precision);
+
+	while (len-- > 0) {
+		u32 c32 = utf16_to_utf32(&ws);
+		u8 *s8;
+		size_t clen;
+
+		if (c32 < 0x80) {
+			addchar(p, c32);
+			continue;
+		}
+
+		/* Number of trailing octets */
+		clen = 1 + (c32 >= 0x800) + (c32 >= 0x10000);
+
+		len -= clen;
+		s8 = (u8 *)(p->buffer - p->added + pos);
+
+		/* Avoid writing partial character */
+		addchar(p, '\0');
+		pos += clen;
+		if (pos >= size)
+			continue;
+
+		/* Set high bits of leading octet */
+		*s8 = (0xf00 >> 1) >> clen;
+		/* Write trailing octets in reverse order */
+		for (s8 += clen; clen; --clen, c32 >>= 6)
+			*s8-- = 0x80 | (c32 & 0x3f);
+		/* Set low bits of leading octet */
+		*s8 |= c32;
+	}
+}
+
 static char digits[16] = "0123456789abcdef";
 
 static void print_int(pstream_t *ps, long long n, int base, strprops_t props)
@@ -305,7 +401,10 @@ morefmt:
 			print_unsigned(&s, (unsigned long)va_arg(args, void *), 16, props);
 			break;
 		case 's':
-			print_str(&s, va_arg(args, const char *), props);
+			if (nlong)
+				print_wstring(&s, va_arg(args, const u16 *), props);
+			else
+				print_str(&s, va_arg(args, const char *), props);
 			break;
 		default:
 			addchar(&s, f);
-- 
2.25.1

