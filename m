Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794286948;
	b=bzpuWyecQWDMd0YpD0U6/qj6lKoVZ4urQZt5+mfX0G7nJj4cKxL0I1Oei6GkVCPYisQo
	 PRgkunlPr48ZOpZHGqb1g+8z8FqB+lQ3i8RkkUZsBwRaKHFYu7flFaRO8gYJJuCRoiM5I
	 W41eloopjBRg5ia5fYqT/nHRiKCkFcRkcBrn8VKVBG4qelzYggRSlegwrafnSpMwtEeZ7
	 JGLpjoo9hTXZnJ4qmzIkYb4zQ10KWTaOvv8ZDSbK48mzdYNF6x3BJZiGlXzHdx4MoA6Vq
	 QlvrD5Vifmc9i3mEOl90X0uv0jTiXrBQkmZfCGj0DxMT3l9PwI7B1MpFPLFCAWsuhxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794286948;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=uCmKHaalBs1Mwi3hIIcbxr5U+8imaxCzGUPXqbL7HOI=;
	b=sJANJdMVyjAbpnyaPfJ/KqAMaEWJAaIGox43U/9i5AZJEqvNQocfvmKAo0KgP9CwMTSb
	 +CKRhAue1i9wlBjXvNlDA1cd9y5GgF/syWK6F0ddy3k9nu33EetN2g5dq/aibF9MMMk0p
	 UrtAtm1Qb+B8bKziBHAqi+UBQg83eBAQASm7nKZzJo2J8ua5AE8fIT+MCi+/3xbQj01cj
	 IJ3NEWF8ZV+/W3o7/S4c0vv6xD+GJAEiEsIDFoZObEka0TlX34s+DTaiUX0+jz3zwqukr
	 5phO4IzrooKQa5KKkn6JtTNufEJjUf0dbl6l2W96VLncFBmHiQsBjh3wGKowqzhXWWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=e109EgSK;
	arc=none smtp.remote-ip=209.85.218.69
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C071606F149
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 05:02:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C071606F149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=e109EgSK
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c4108bfb63dso99179766b.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 21:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286946; x=1794891746; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uCmKHaalBs1Mwi3hIIcbxr5U+8imaxCzGUPXqbL7HOI=;
        b=e109EgSKEh45O7bZbC+mG5Bvy+4Hwet+6I1cd+cl72ixAJKAwtGce+mDrTkhugNwiv
         hhVnZd8h2Zsn8fOp6JMQrnnLKq7YaxdJeyr8BzhQgpmboXC/IcTE4aQJIa3WPsQF8yIp
         tKcP/XH6lbFIzsNGXuL/VvxbyyzQIrsizazSGkv3mNdjZUk4aMR+h2vuQGNmPnyQg4uc
         VvlhpDse92f5CZqJHuXsyAYVOVnGiegMBlYHNjTRjLvRCAKPutFcv9TMRc9J+eo6evNL
         72OtJD2EQmC6ImSDBS9SC8oz7fWCjl4WpS4VQWOACRkCMg4+ozQcqkJCGPivy+52flNo
         3GkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286946; x=1794891746;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uCmKHaalBs1Mwi3hIIcbxr5U+8imaxCzGUPXqbL7HOI=;
        b=VFCS9ywr67yL/m7i1KJqNfSCLqpn+i0Mvf/pdvS5VgJ6pStYuqxLiDm12yVh4v0WfC
         OtWJzV0HcApNGjIK3IE9FdiJ5fUYbeEbBsh86Dl1GeLd8WL8KGWhuTvuIJ8w7pa+oZIF
         iBLemPd0rhFbPwmj7q/FKUtG2UP/CQyyYX7zR1cAasPnkd0rFHnyTooDnT/B+/4mZBqZ
         k5l8ghe8sGHtEwm7F0WXOTfQH7A9yJcKw8vhW0SaUvlSXyQ3oywYBfIHz+v29EEGntsu
         KnnVK+f36+cmgjJ2n4BER52grBsDaiNmgP0c4wDh6ne23S0bPY8KfDHxbw5jQi3ApT4h
         r3yQ==
X-Gm-Message-State: APuU4Z8tG/lmGpFLyETOG1rzzs+X2xaCaisG0EQmkRnyfLXKBZ9XDnRO
	2Cy5vMD0NN0GqgpGjtyN4DVTcM0uSfn9JppN1Rfh0LxFP6KENbEW/9jJEAJXOZlYD7vPsUA/fdx
	wLxKoLvBJvV0un4+ViQ==
X-Received: from ejpc8.prod.google.com ([2002:a17:906:54c8:b0:c3f:c35a:7704])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3d0d:b0:c49:a571:c4f9 with SMTP id a640c23a62f3a-c50494b4c4fmr100815566b.13.1794286946299;
 Mon, 09 Nov 2026 21:02:26 -0800 (PST)
Date: Tue, 10 Nov 2026 05:02:02 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-20-tarunsahu@google.com>
Subject: [PATCH v4 19/19] kho: Add KUnit test for the feature header helpers
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a KUnit test suite in lib/tests/kho_feature_kunit.c covering
the Kexec HandOver feature header declared in
include/linux/kho/abi/feature.h.

The suite contains three focused test cases:
- kho_ser_hdr_zero_flags_test: verifies zero-feature header
  initialization, payload sizing, and empty feature queries.
- kho_ser_hdr_set_get_test: verifies DECLARE_KHO_SER structure sizing,
  header initialization, payload pointer resolution, and 1-bit
  feature flag setting and retrieval across flags entry boundaries,
  including out-of-range queries.
- kho_ser_hdr_validate_test: verifies __kho_ser_validate rejecting
  unsupported required feature flags while ignoring optional flags.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 MAINTAINERS                   |   1 +
 lib/Kconfig.debug             |  13 +++
 lib/tests/Makefile            |   1 +
 lib/tests/kho_feature_kunit.c | 184 ++++++++++++++++++++++++++++++++++
 4 files changed, 199 insertions(+)
 create mode 100644 lib/tests/kho_feature_kunit.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 1572f6c905aa..0b50de45140f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14786,6 +14786,7 @@ F:	include/linux/kho/
 F:	include/linux/kho_block.h
 F:	kernel/liveupdate/kexec_handover*
 F:	lib/test_kho.c
+F:	lib/tests/kho_feature_kunit.c
 F:	tools/testing/selftests/kho/
 
 KEYS-ENCRYPTED
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2d22638ec13a..3d74d32b181d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2967,6 +2967,19 @@ config DIMLIB_KUNIT_TEST
 	  For more information on KUnit and unit tests in general please refer
 	  to the KUnit documentation in Documentation/dev-tools/kunit/.
 
+config KHO_FEATURE_KUNIT_TEST
+	tristate "KUnit test for the Kexec HandOver feature header helpers" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This option enables the KUnit test suite for the Kexec HandOver
+	  feature header helpers defined in include/linux/kho/abi/feature.h.
+	  It checks the feature flag encoding, the flags array sizing, the
+	  feature bit helpers, and header validation rules.
+
+	  The helpers are self-contained, so the test does not depend on
+	  CONFIG_KEXEC_HANDOVER and can also run under UML.
+
 	  If unsure, say N.
 
 config CMDLINE_KUNIT_TEST
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index df0537e1b91f..f22a4552f755 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_KFIFO_KUNIT_TEST) += kfifo_kunit.o
 obj-$(CONFIG_TEST_LIST_SORT) += test_list_sort.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
 obj-$(CONFIG_LIVEUPDATE_TEST) += liveupdate.o
+obj-$(CONFIG_KHO_FEATURE_KUNIT_TEST) += kho_feature_kunit.o
 
 CFLAGS_longest_symbol_kunit.o += $(call cc-disable-warning, missing-prototypes)
 obj-$(CONFIG_LONGEST_SYM_KUNIT_TEST) += longest_symbol_kunit.o
diff --git a/lib/tests/kho_feature_kunit.c b/lib/tests/kho_feature_kunit.c
new file mode 100644
index 000000000000..db36895d53f5
--- /dev/null
+++ b/lib/tests/kho_feature_kunit.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for the Kexec HandOver feature header helpers
+ * in include/linux/kho/abi/feature.h.
+ *
+ * Copyright (c) 2026, Google LLC.
+ * Tarun Sahu <tarunsahu@google.com>
+ */
+
+#include <kunit/test.h>
+#include <linux/kho/abi/feature.h>
+#include <linux/module.h>
+
+struct test_kho_payload {
+	u64 val;
+};
+
+enum test_kho_req_feat {
+	TEST_KHO_REQ_0 = 0,
+	TEST_KHO_REQ_63 = 63,
+	TEST_KHO_REQ_64 = 64,
+	TEST_KHO_REQ_69 = 69,
+	TEST_KHO_NR_REQUIRED = 70,
+};
+
+enum test_kho_opt_feat {
+	TEST_KHO_OPT_0 = 0,
+	TEST_KHO_OPT_63 = 63,
+	TEST_KHO_OPT_64 = 64,
+	TEST_KHO_OPT_69 = 69,
+	TEST_KHO_NR_OPTIONAL = 70,
+};
+
+DECLARE_KHO_SER(test_kho_payload, 8, TEST_KHO_NR_REQUIRED, TEST_KHO_NR_OPTIONAL);
+
+struct test_kho_zero {
+	u64 val;
+};
+
+DECLARE_KHO_SER(test_kho_zero, 8, 0, 0);
+
+static void kho_ser_hdr_zero_flags_test(struct kunit *test)
+{
+	DECLARE_KHO_SER_HDR(test_kho_zero, *fhdr);
+	const DECLARE_KHO_SER_HDR(test_kho_zero, *const_fhdr);
+	u8 buf[kho_ser_size(test_kho_zero)] __aligned(8);
+	struct test_kho_zero *p;
+
+	KUNIT_EXPECT_EQ(test, sizeof(struct kho_ser_hdr), 8UL);
+	KUNIT_EXPECT_EQ(test, sizeof(*fhdr), sizeof(struct kho_ser_hdr));
+	KUNIT_EXPECT_EQ(test, kho_ser_size(test_kho_zero), 16UL);
+
+	fhdr = (void *)buf;
+	kho_ser_init(fhdr, test_kho_zero);
+	KUNIT_EXPECT_EQ(test, fhdr->size, 16U);
+	KUNIT_EXPECT_EQ(test, fhdr->nr_required, 0U);
+	KUNIT_EXPECT_EQ(test, fhdr->nr_optional, 0U);
+	KUNIT_EXPECT_EQ(test, kho_ser_hdr_size(fhdr), 8UL);
+
+	const_fhdr = fhdr;
+	KUNIT_EXPECT_EQ(test, const_fhdr->size, 16U);
+
+	p = kho_ser_payload(fhdr, test_kho_zero);
+	KUNIT_EXPECT_PTR_EQ(test, p, (void *)(buf + 8));
+
+	p = kho_ser_payload(const_fhdr, test_kho_zero);
+	KUNIT_EXPECT_PTR_EQ(test, p, (void *)(buf + 8));
+
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_required(fhdr, 0));
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_optional(fhdr, 0));
+	KUNIT_EXPECT_EQ(test, kho_ser_validate(fhdr, test_kho_zero), 0);
+	KUNIT_EXPECT_EQ(test, kho_ser_validate(const_fhdr, test_kho_zero), 0);
+}
+
+static void kho_ser_hdr_set_get_test(struct kunit *test)
+{
+	DECLARE_KHO_SER_HDR(test_kho_payload, *fhdr);
+	const DECLARE_KHO_SER_HDR(test_kho_payload, *const_fhdr);
+	u8 buf[kho_ser_size(test_kho_payload)] __aligned(8);
+	struct test_kho_payload *p;
+
+	KUNIT_EXPECT_EQ(test, kho_ser_size(test_kho_payload), 40UL);
+
+	fhdr = (void *)buf;
+	kho_ser_init(fhdr, test_kho_payload);
+	KUNIT_EXPECT_EQ(test, fhdr->size, 40U);
+	KUNIT_EXPECT_EQ(test, fhdr->nr_required, 70U);
+	KUNIT_EXPECT_EQ(test, fhdr->nr_optional, 70U);
+	KUNIT_EXPECT_EQ(test, kho_ser_hdr_size(fhdr), 32UL);
+
+	const_fhdr = fhdr;
+	KUNIT_EXPECT_EQ(test, const_fhdr->size, 40U);
+	KUNIT_EXPECT_EQ(test, const_fhdr->nr_required, 70U);
+	KUNIT_EXPECT_EQ(test, const_fhdr->nr_optional, 70U);
+
+	p = kho_ser_payload(fhdr, test_kho_payload);
+	KUNIT_EXPECT_PTR_EQ(test, p, (void *)(buf + 32));
+
+	p = kho_ser_payload(const_fhdr, test_kho_payload);
+	KUNIT_EXPECT_PTR_EQ(test, p, (void *)(buf + 32));
+
+	kho_ser_set_required(fhdr, TEST_KHO_REQ_0);
+	kho_ser_set_required(fhdr, TEST_KHO_REQ_63);
+	kho_ser_set_required(fhdr, TEST_KHO_REQ_64);
+	kho_ser_set_required(fhdr, TEST_KHO_REQ_69);
+
+	KUNIT_EXPECT_TRUE(test, kho_ser_has_required(fhdr, TEST_KHO_REQ_0));
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_required(fhdr, 1));
+	KUNIT_EXPECT_TRUE(test, kho_ser_has_required(fhdr, TEST_KHO_REQ_63));
+	KUNIT_EXPECT_TRUE(test, kho_ser_has_required(fhdr, TEST_KHO_REQ_64));
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_required(fhdr, 65));
+	KUNIT_EXPECT_TRUE(test, kho_ser_has_required(fhdr, TEST_KHO_REQ_69));
+
+	KUNIT_EXPECT_TRUE(test, !!(fhdr->flags[0] & (1ULL << 0)));
+	KUNIT_EXPECT_TRUE(test, !!(fhdr->flags[0] & (1ULL << 63)));
+	KUNIT_EXPECT_TRUE(test, !!(fhdr->flags[1] & (1ULL << 0)));
+	KUNIT_EXPECT_TRUE(test, !!(fhdr->flags[1] & (1ULL << 5)));
+
+	kho_ser_set_optional(fhdr, TEST_KHO_OPT_0);
+	kho_ser_set_optional(fhdr, TEST_KHO_OPT_63);
+	kho_ser_set_optional(fhdr, TEST_KHO_OPT_64);
+	kho_ser_set_optional(fhdr, TEST_KHO_OPT_69);
+
+	KUNIT_EXPECT_TRUE(test, kho_ser_has_optional(fhdr, TEST_KHO_OPT_0));
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_optional(fhdr, 1));
+	KUNIT_EXPECT_TRUE(test, kho_ser_has_optional(fhdr, TEST_KHO_OPT_63));
+	KUNIT_EXPECT_TRUE(test, kho_ser_has_optional(fhdr, TEST_KHO_OPT_64));
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_optional(fhdr, 65));
+	KUNIT_EXPECT_TRUE(test, kho_ser_has_optional(fhdr, TEST_KHO_OPT_69));
+
+	KUNIT_EXPECT_TRUE(test, !!(fhdr->flags[1] & (1ULL << 6)));
+	KUNIT_EXPECT_TRUE(test, !!(fhdr->flags[2] & (1ULL << 5)));
+	KUNIT_EXPECT_TRUE(test, !!(fhdr->flags[2] & (1ULL << 6)));
+	KUNIT_EXPECT_TRUE(test, !!(fhdr->flags[2] & (1ULL << 11)));
+
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_required(fhdr, 70));
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_required(fhdr, 100));
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_optional(fhdr, 70));
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_optional(fhdr, 100));
+}
+
+static void kho_ser_hdr_validate_test(struct kunit *test)
+{
+	u8 buf[sizeof(struct kho_ser_hdr) + sizeof(u64) * 2] __aligned(8);
+	struct kho_ser_hdr *fhdr = (void *)buf;
+
+	__kho_ser_init(fhdr, 0, 4, 10);
+	KUNIT_EXPECT_EQ(test, __kho_ser_validate(fhdr, 4), 0);
+	KUNIT_EXPECT_EQ(test, __kho_ser_validate(fhdr, 2), 0);
+
+	kho_ser_set_optional(fhdr, 0);
+	kho_ser_set_optional(fhdr, 9);
+	KUNIT_EXPECT_EQ(test, __kho_ser_validate(fhdr, 2), 0);
+
+	kho_ser_set_required(fhdr, 0);
+	kho_ser_set_required(fhdr, 1);
+	KUNIT_EXPECT_EQ(test, __kho_ser_validate(fhdr, 2), 0);
+
+	kho_ser_set_required(fhdr, 2);
+	KUNIT_EXPECT_EQ(test, __kho_ser_validate(fhdr, 2), -EOPNOTSUPP);
+
+	kho_ser_clear_required(fhdr, 2);
+	KUNIT_EXPECT_EQ(test, __kho_ser_validate(fhdr, 2), 0);
+
+	kho_ser_set_required(fhdr, 3);
+	KUNIT_EXPECT_EQ(test, __kho_ser_validate(fhdr, 2), -EOPNOTSUPP);
+}
+
+static struct kunit_case kho_feature_test_cases[] = {
+	KUNIT_CASE(kho_ser_hdr_zero_flags_test),
+	KUNIT_CASE(kho_ser_hdr_set_get_test),
+	KUNIT_CASE(kho_ser_hdr_validate_test),
+	{}
+};
+
+static struct kunit_suite kho_feature_test_suite = {
+	.name = "kho_feature",
+	.test_cases = kho_feature_test_cases,
+};
+
+kunit_test_suite(kho_feature_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for the Kexec HandOver feature header helpers");
+MODULE_LICENSE("GPL");
-- 
2.56.0.506.g506a7eabc5-goog

