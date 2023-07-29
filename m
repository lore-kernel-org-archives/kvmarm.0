Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56173392
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:36:56 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1bbf8cb6143so2057545ad.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591016; x=1691195816;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zoZLLV8R20eg7tJsXNLPRDCKR5FXoU0sMSGBAwU17tY=;
        b=gIJR6odFc5Hkpq4A6lJmUlgjcsTQKzLGNi55/3FcYE6gNkohE3tIICG8rorU9SEQW3
         oOkGp1PPhmT+o9bMhPParO5kjuxQRODz0VLEoEDaRrgeg9fdD6yguME2pxdCbVcgqcy0
         Q5gXksV/eBoBtZC7Fos9LKlKvAH3fk3Qhg3jH8HCaQvCJCMaigY/KEuz4oXnHwI+521M
         7JHK9qVb7H5bJgBtud2neE88tCRUlq1YmGMfeL98sp72VUccTOClUY++GrP5b47yyZD/
         bk3cIlaxWDIns4poXsSY8AP4w11SWrcvvvLnoTPOQDcz0uoeh+rbUaoQw5w/XoBRkqUG
         vMQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591016; x=1691195816;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zoZLLV8R20eg7tJsXNLPRDCKR5FXoU0sMSGBAwU17tY=;
        b=TDAYp43Bu/4/X2oWCu8u2REIzVTLN6nyvR6SzmxQvNgGXUON6B2JV+tNnAgC5qaaX8
         5O6VCyLbEyL8tGMx64iSs7iEiZWhC/vn8HUYZ29Eq/Wbb8xqmERG87ad6lzjf12pXIjv
         sDeyy7EKHa2lEaQj8BGc1yBYCIvZrshlDHXIWaX1NnfSdSImFC2rhIAxpFno6l0GyOR6
         BW2/bZkJYahEGiGk3S86j2JoIw6B90JPJd3YIzP83sKh65gBGxo4SOxownGu+9RPw0p8
         b0L59pnarFQkFi9cbDtjbgHJg2tRfLufa3cCUKbU8gON/ZHr/4rVQs2obOAM4YLIIRKd
         36MQ==
X-Gm-Message-State: ABy/qLaonwkh7MWh8ULi6vT6kXRaoDx8FrGokqcqOwHg4zCuyHJzN+K9
	Z/h1z+aOw6pTZFRPaMN91R0eZx3lM0Q=
X-Google-Smtp-Source: APBJJlGnKNgEBanM0pNB6kivwAILTcmV3SgQ6dkzSb0RKOpFIQB854F/xZNKDJ2RHCN/IfjUaRuBeXIma2E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2309:b0:1b3:bfa6:d064 with SMTP id
 d9-20020a170903230900b001b3bfa6d064mr12998plh.1.1690591015774; Fri, 28 Jul
 2023 17:36:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:14 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-6-seanjc@google.com>
Subject: [PATCH v4 05/34] KVM: selftests: Add guest_snprintf() to KVM selftests
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Aaron Lewis <aaronlewis@google.com>

Add a local version of guest_snprintf() for use in the guest.

Having a local copy allows the guest access to string formatting
options without dependencies on LIBC.  LIBC is problematic because
it heavily relies on both AVX-512 instructions and a TLS, neither of
which are guaranteed to be set up in the guest.

The file guest_sprintf.c was lifted from arch/x86/boot/printf.c and
adapted to work in the guest, including the addition of buffer length.
I.e. s/sprintf/snprintf/

The functions where prefixed with "guest_" to allow guests to
explicitly call them.

A string formatted by this function is expected to succeed or die.  If
something goes wrong during the formatting process a GUEST_ASSERT()
will be thrown.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Link: https://lore.kernel.org/all/mtdi6smhur5rqffvpu7qux7mptonw223y2653x2nwzvgm72nlo@zyc4w3kwl3rg
[sean: add a link to the discussion of other options]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/test_util.h |   3 +
 .../testing/selftests/kvm/lib/guest_sprintf.c | 307 ++++++++++++++++++
 3 files changed, 311 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/lib/guest_sprintf.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index f6c14ab476ac..f65889f5a083 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -23,6 +23,7 @@ LIBKVM += lib/guest_modes.c
 LIBKVM += lib/io.c
 LIBKVM += lib/kvm_util.c
 LIBKVM += lib/memstress.c
+LIBKVM += lib/guest_sprintf.c
 LIBKVM += lib/rbtree.c
 LIBKVM += lib/sparsebit.c
 LIBKVM += lib/test_util.c
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index a4bea44f990c..7a5907da1719 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -185,4 +185,7 @@ static inline uint32_t atoi_non_negative(const char *name, const char *num_str)
 	return num;
 }
 
+int guest_vsnprintf(char *buf, int n, const char *fmt, va_list args);
+int guest_snprintf(char *buf, int n, const char *fmt, ...);
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/guest_sprintf.c b/tools/testing/selftests/kvm/lib/guest_sprintf.c
new file mode 100644
index 000000000000..c4a69d8aeb68
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/guest_sprintf.c
@@ -0,0 +1,307 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "test_util.h"
+#include "kvm_util.h"
+#include "ucall_common.h"
+
+#define APPEND_BUFFER_SAFE(str, end, v) \
+do {					\
+	GUEST_ASSERT(str < end);	\
+	*str++ = (v);			\
+} while (0)
+
+static int isdigit(int ch)
+{
+	return (ch >= '0') && (ch <= '9');
+}
+
+static int skip_atoi(const char **s)
+{
+	int i = 0;
+
+	while (isdigit(**s))
+		i = i * 10 + *((*s)++) - '0';
+	return i;
+}
+
+#define ZEROPAD	1		/* pad with zero */
+#define SIGN	2		/* unsigned/signed long */
+#define PLUS	4		/* show plus */
+#define SPACE	8		/* space if plus */
+#define LEFT	16		/* left justified */
+#define SMALL	32		/* Must be 32 == 0x20 */
+#define SPECIAL	64		/* 0x */
+
+#define __do_div(n, base)				\
+({							\
+	int __res;					\
+							\
+	__res = ((uint64_t) n) % (uint32_t) base;	\
+	n = ((uint64_t) n) / (uint32_t) base;		\
+	__res;						\
+})
+
+static char *number(char *str, const char *end, long num, int base, int size,
+		    int precision, int type)
+{
+	/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
+	static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
+
+	char tmp[66];
+	char c, sign, locase;
+	int i;
+
+	/*
+	 * locase = 0 or 0x20. ORing digits or letters with 'locase'
+	 * produces same digits or (maybe lowercased) letters
+	 */
+	locase = (type & SMALL);
+	if (type & LEFT)
+		type &= ~ZEROPAD;
+	if (base < 2 || base > 16)
+		return NULL;
+	c = (type & ZEROPAD) ? '0' : ' ';
+	sign = 0;
+	if (type & SIGN) {
+		if (num < 0) {
+			sign = '-';
+			num = -num;
+			size--;
+		} else if (type & PLUS) {
+			sign = '+';
+			size--;
+		} else if (type & SPACE) {
+			sign = ' ';
+			size--;
+		}
+	}
+	if (type & SPECIAL) {
+		if (base == 16)
+			size -= 2;
+		else if (base == 8)
+			size--;
+	}
+	i = 0;
+	if (num == 0)
+		tmp[i++] = '0';
+	else
+		while (num != 0)
+			tmp[i++] = (digits[__do_div(num, base)] | locase);
+	if (i > precision)
+		precision = i;
+	size -= precision;
+	if (!(type & (ZEROPAD + LEFT)))
+		while (size-- > 0)
+			APPEND_BUFFER_SAFE(str, end, ' ');
+	if (sign)
+		APPEND_BUFFER_SAFE(str, end, sign);
+	if (type & SPECIAL) {
+		if (base == 8)
+			APPEND_BUFFER_SAFE(str, end, '0');
+		else if (base == 16) {
+			APPEND_BUFFER_SAFE(str, end, '0');
+			APPEND_BUFFER_SAFE(str, end, 'x');
+		}
+	}
+	if (!(type & LEFT))
+		while (size-- > 0)
+			APPEND_BUFFER_SAFE(str, end, c);
+	while (i < precision--)
+		APPEND_BUFFER_SAFE(str, end, '0');
+	while (i-- > 0)
+		APPEND_BUFFER_SAFE(str, end, tmp[i]);
+	while (size-- > 0)
+		APPEND_BUFFER_SAFE(str, end, ' ');
+
+	return str;
+}
+
+int guest_vsnprintf(char *buf, int n, const char *fmt, va_list args)
+{
+	char *str, *end;
+	const char *s;
+	uint64_t num;
+	int i, base;
+	int len;
+
+	int flags;		/* flags to number() */
+
+	int field_width;	/* width of output field */
+	int precision;		/*
+				 * min. # of digits for integers; max
+				 * number of chars for from string
+				 */
+	int qualifier;		/* 'h', 'l', or 'L' for integer fields */
+
+	end = buf + n;
+	GUEST_ASSERT(buf < end);
+	GUEST_ASSERT(n > 0);
+
+	for (str = buf; *fmt; ++fmt) {
+		if (*fmt != '%') {
+			APPEND_BUFFER_SAFE(str, end, *fmt);
+			continue;
+		}
+
+		/* process flags */
+		flags = 0;
+repeat:
+		++fmt;		/* this also skips first '%' */
+		switch (*fmt) {
+		case '-':
+			flags |= LEFT;
+			goto repeat;
+		case '+':
+			flags |= PLUS;
+			goto repeat;
+		case ' ':
+			flags |= SPACE;
+			goto repeat;
+		case '#':
+			flags |= SPECIAL;
+			goto repeat;
+		case '0':
+			flags |= ZEROPAD;
+			goto repeat;
+		}
+
+		/* get field width */
+		field_width = -1;
+		if (isdigit(*fmt))
+			field_width = skip_atoi(&fmt);
+		else if (*fmt == '*') {
+			++fmt;
+			/* it's the next argument */
+			field_width = va_arg(args, int);
+			if (field_width < 0) {
+				field_width = -field_width;
+				flags |= LEFT;
+			}
+		}
+
+		/* get the precision */
+		precision = -1;
+		if (*fmt == '.') {
+			++fmt;
+			if (isdigit(*fmt))
+				precision = skip_atoi(&fmt);
+			else if (*fmt == '*') {
+				++fmt;
+				/* it's the next argument */
+				precision = va_arg(args, int);
+			}
+			if (precision < 0)
+				precision = 0;
+		}
+
+		/* get the conversion qualifier */
+		qualifier = -1;
+		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L') {
+			qualifier = *fmt;
+			++fmt;
+		}
+
+		/* default base */
+		base = 10;
+
+		switch (*fmt) {
+		case 'c':
+			if (!(flags & LEFT))
+				while (--field_width > 0)
+					APPEND_BUFFER_SAFE(str, end, ' ');
+			APPEND_BUFFER_SAFE(str, end,
+					    (uint8_t)va_arg(args, int));
+			while (--field_width > 0)
+				APPEND_BUFFER_SAFE(str, end, ' ');
+			continue;
+
+		case 's':
+			s = va_arg(args, char *);
+			len = strnlen(s, precision);
+
+			if (!(flags & LEFT))
+				while (len < field_width--)
+					APPEND_BUFFER_SAFE(str, end, ' ');
+			for (i = 0; i < len; ++i)
+				APPEND_BUFFER_SAFE(str, end, *s++);
+			while (len < field_width--)
+				APPEND_BUFFER_SAFE(str, end, ' ');
+			continue;
+
+		case 'p':
+			if (field_width == -1) {
+				field_width = 2 * sizeof(void *);
+				flags |= SPECIAL | SMALL | ZEROPAD;
+			}
+			str = number(str, end,
+				     (uint64_t)va_arg(args, void *), 16,
+				     field_width, precision, flags);
+			continue;
+
+		case 'n':
+			if (qualifier == 'l') {
+				long *ip = va_arg(args, long *);
+				*ip = (str - buf);
+			} else {
+				int *ip = va_arg(args, int *);
+				*ip = (str - buf);
+			}
+			continue;
+
+		case '%':
+			APPEND_BUFFER_SAFE(str, end, '%');
+			continue;
+
+		/* integer number formats - set up the flags and "break" */
+		case 'o':
+			base = 8;
+			break;
+
+		case 'x':
+			flags |= SMALL;
+		case 'X':
+			base = 16;
+			break;
+
+		case 'd':
+		case 'i':
+			flags |= SIGN;
+		case 'u':
+			break;
+
+		default:
+			APPEND_BUFFER_SAFE(str, end, '%');
+			if (*fmt)
+				APPEND_BUFFER_SAFE(str, end, *fmt);
+			else
+				--fmt;
+			continue;
+		}
+		if (qualifier == 'l')
+			num = va_arg(args, uint64_t);
+		else if (qualifier == 'h') {
+			num = (uint16_t)va_arg(args, int);
+			if (flags & SIGN)
+				num = (int16_t)num;
+		} else if (flags & SIGN)
+			num = va_arg(args, int);
+		else
+			num = va_arg(args, uint32_t);
+		str = number(str, end, num, base, field_width, precision, flags);
+	}
+
+	GUEST_ASSERT(str < end);
+	*str = '\0';
+	return str - buf;
+}
+
+int guest_snprintf(char *buf, int n, const char *fmt, ...)
+{
+	va_list va;
+	int len;
+
+	va_start(va, fmt);
+	len = guest_vsnprintf(buf, n, fmt, va);
+	va_end(va);
+
+	return len;
+}
-- 
2.41.0.487.g6d72f3e995-goog

