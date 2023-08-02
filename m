Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F5E8BE7
	for <kvmarm@lists.linux.dev>; Wed,  2 Aug 2023 15:07:29 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d1efa597303so1859748276.0
        for <kvmarm@lists.linux.dev>; Wed, 02 Aug 2023 08:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690988848; x=1691593648;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ODlQqQRL7j+ioqTq3MDMk7BwHCUeRlM+arLr48y6tNA=;
        b=SlPCrS1xmbnWErc1CKgkJPNCNs7mvtB7anzE5xNQkivhTRzEbUhgWQnPMVMtb3VXh+
         ZBtkHFgVBWyYK9aJXUFag88OyruHvsTDz0sROofPxloDejTDL0u7WLbUzdd0bjeB+jSN
         oTfyPlrZyq9uO50GbK472SiCDM3EoN7lghNrsmGgmy5MZ0QBWWSW/G3ysfDRPCvjzTil
         jIk0DCPgZI/Khn3fRGwbxbnH3v6fhL+esA/xOgDvjtUUcvHxo0iNIh9aXl4CxUkdcmD8
         fJBSw5TBqO8FHGk7VqWk7U50HciveTvD2sCx9Bd9M88m/E0/TJ8dDqT/2Fi+tjLdynkA
         hc8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690988848; x=1691593648;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ODlQqQRL7j+ioqTq3MDMk7BwHCUeRlM+arLr48y6tNA=;
        b=SASRk8b8ZSUSTkaZsPeIc+fHArGUgr/4/FSmMtbNJwg4/oRVyfjnLMDHIM3BiTTZ66
         2qpv+RMNQfieD1IcUmuTxHtKsLimG8pt67Os2bGHsc7prxDlMLugV0EgsNbLtcesS9Yd
         iLwysRDF/UPP3X3s+Rw8DC5jBmMWI1jS1BOnweghEyk0rUCc64TvIR5Y2+Y2BsqpNuC9
         HjXYuwMV0zTR9KZqzuOpyLbJRsDE5ieKmZJpYHdJCQW2Zy/fBPwMLOvqWWiB3qWEqI9j
         tRbz4Fdiv/mmYMOVLlKRrzol+Gd7eAWzz5uVD139x/COt6BPKsaW8Th4x743ZJYUVzpK
         qw6Q==
X-Gm-Message-State: ABy/qLb9sCM6ppPpf9SgnQ7mA1lngY/7Wfvg9nn2zg4pO8Uipf19k2uw
	8K7xXq5XRp/scdueAYw+4UYNGVqBJg==
X-Google-Smtp-Source: APBJJlG54cyvOOilnqyHEvE3EGA71yo6JZSxh2bIK8O8x7AqakXp9rNt0p+eKxoE0w7ySnwaeqPwqs6mJg==
X-Received: from elver.muc.corp.google.com ([2a00:79e0:9c:201:5f73:1fc0:c9fd:f203])
 (user=elver job=sendgmr) by 2002:a25:dfc3:0:b0:d15:53b5:509f with SMTP id
 w186-20020a25dfc3000000b00d1553b5509fmr197192ybg.2.1690988848424; Wed, 02 Aug
 2023 08:07:28 -0700 (PDT)
Date: Wed,  2 Aug 2023 17:06:37 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230802150712.3583252-1-elver@google.com>
Subject: [PATCH 1/3] Compiler attributes: Introduce the __preserve_most
 function attribute
From: Marco Elver <elver@google.com>
To: elver@google.com, Andrew Morton <akpm@linux-foundation.org>, 
	Kees Cook <keescook@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nathan Chancellor <nathan@kernel.org>, Tom Rix <trix@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com, 
	linux-toolchains@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

[1]: "On X86-64 and AArch64 targets, this attribute changes the calling
convention of a function. The preserve_most calling convention attempts
to make the code in the caller as unintrusive as possible. This
convention behaves identically to the C calling convention on how
arguments and return values are passed, but it uses a different set of
caller/callee-saved registers. This alleviates the burden of saving and
recovering a large register set before and after the call in the
caller."

[1] https://clang.llvm.org/docs/AttributeReference.html#preserve-most

Use of this attribute results in better code generation for calls to
very rarely called functions, such as error-reporting functions, or
rarely executed slow paths.

Introduce the attribute to compiler_attributes.h.

Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/compiler_attributes.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index 00efa35c350f..615a63ecfcf6 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -321,6 +321,17 @@
 # define __pass_object_size(type)
 #endif
 
+/*
+ * Optional: not supported by gcc.
+ *
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#preserve-most
+ */
+#if __has_attribute(__preserve_most__)
+# define __preserve_most __attribute__((__preserve_most__))
+#else
+# define __preserve_most
+#endif
+
 /*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-pure-function-attribute
  */
-- 
2.41.0.585.gd2178a4bd4-goog

