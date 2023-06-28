Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D9210EE
	for <kvmarm@lists.linux.dev>; Wed, 28 Jun 2023 00:14:32 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1b80ddce748so17201455ad.3
        for <kvmarm@lists.linux.dev>; Tue, 27 Jun 2023 17:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687911272; x=1690503272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6VV0a8wWSD+atLlwpNamgRCyPytqoIWQ0GwWykCu/xw=;
        b=NEeG+Fd2oONFSZHMZgXZhQp48FPLe6z5vzWUJT+7cLVPJw9QNYox443LEIecTTX6TY
         ZeSSkSBXZTr2GSr0HNmb1SMiXQ88aHJ0NzFurU2/qJV02TXrwPM7fQwNtV4pOqlT+GAJ
         YPsOYn9t38ODKHcu0AL3ETYaFz44K24gxqh5OYI4/CpebE3uMZxRg57MVBOU2wefkeDU
         kXbmfbOUkAqDHNEgKLoMbw0X6VwAlPrW87J58l1bnMbxb2T7WILnemY848zXungiaZmm
         RAgkA50YAlhNVIPGtgDLGIfvXl5BtwhzhLVR+2Wd05jsfiflATyFkLOBt6TvEpNS72YF
         YmMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687911272; x=1690503272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6VV0a8wWSD+atLlwpNamgRCyPytqoIWQ0GwWykCu/xw=;
        b=l21Ae6XLeS/Rpkca1L0z9SZesgdsWmnRmtyotjNyhbBWZ8YzwZ/5ZSl8+SgekdQt6F
         Ne/3kEYIsIFEYAcbxgpHIUMfY7IVTtrfmxux415tqIeex5HhLId7BGig7D45zxXBlBiv
         dxfeNkjDx54kP6QW+4aJEPXnFBFj0H6snA6Y6LUMqcnylwIEvknnUkjLK+PBn06YitlW
         6DyXvFy357X5PyHc9M9NSjELQXHg5/+jo3dv1JvNwbSnQ+3j9HGjxDYQLIDlszldusJd
         ORyRrXw+xEAVYcRZQ1qyL84mWUhraCB12f3ebZ5qd6Vk0o+F0koekelfG4dOuyXbfaLh
         WsiQ==
X-Gm-Message-State: AC+VfDw9j9vcLfTATygTX+7+Kz2Zq8gza/Es19EKwQFDZRSu7Y4wh6pV
	YdQR8aqElvAP6L8183rA47jD+7qmKks=
X-Google-Smtp-Source: ACHHUZ4uh9514t9KV5Y1JchPqaxRN1mR8gdhBr5xLxQvVkgRsCUbt497+YuIruLuWl9Z4WyPUxJEgA==
X-Received: by 2002:a17:903:32d0:b0:1b1:b2fa:1903 with SMTP id i16-20020a17090332d000b001b1b2fa1903mr7562183plr.41.1687911271722;
        Tue, 27 Jun 2023 17:14:31 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id jd4-20020a170903260400b001b1920cffdasm343796plb.204.2023.06.27.17.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 17:14:31 -0700 (PDT)
From: Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v3 2/6] lib/stack: print base addresses on relocation setups
Date: Wed, 28 Jun 2023 00:13:51 +0000
Message-Id: <20230628001356.2706-4-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230628001356.2706-1-namit@vmware.com>
References: <20230628001356.2706-1-namit@vmware.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nadav Amit <namit@vmware.com>

Making sense from dumped stacks when running EFI tests is very hard due
to the relocation. Fix it by adjusting the address back to the original
address.

Introduce CONFIG_RELOC, which would be set on arm64 and on EFI configs.

Suggested-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nadav Amit <namit@vmware.com>

---
v2->v3:
* Mark PowerPC as relocatable as well [Andrew]
* Fixing incorrect Makefile [Andrew]

v1->v2:
* Introduce CONFIG_RELOC to support ARM64 [Andrew]
---
 Makefile                |  2 +-
 arm/Makefile.arm64      |  1 +
 lib/stack.c             | 31 +++++++++++++++++++++++++++++--
 powerpc/Makefile.common |  1 +
 4 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 307bc29..ae79059 100644
--- a/Makefile
+++ b/Makefile
@@ -40,7 +40,7 @@ OBJDIRS += $(LIBFDT_objdir)
 
 # EFI App
 ifeq ($(CONFIG_EFI),y)
-EFI_CFLAGS := -DCONFIG_EFI
+EFI_CFLAGS := -DCONFIG_EFI -DCONFIG_RELOC
 # The following CFLAGS and LDFLAGS come from:
 #   - GNU-EFI/Makefile.defaults
 #   - GNU-EFI/apps/Makefile
diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index eada7f9..85b3348 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -12,6 +12,7 @@ CFLAGS += -mstrict-align
 
 mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
 CFLAGS += $(mno_outline_atomics)
+CFLAGS += -DCONFIG_RELOC
 
 define arch_elf_check =
 	$(if $(shell ! $(READELF) -rW $(1) >&/dev/null && echo "nok"),
diff --git a/lib/stack.c b/lib/stack.c
index bdb23fd..dd6bfa8 100644
--- a/lib/stack.c
+++ b/lib/stack.c
@@ -6,13 +6,38 @@
  */
 
 #include <libcflat.h>
+#include <stdbool.h>
 #include <stack.h>
 
 #define MAX_DEPTH 20
 
+#ifdef CONFIG_RELOC
+extern char _text, _etext;
+
+static bool base_address(const void *rebased_addr, unsigned long *addr)
+{
+	unsigned long ra = (unsigned long)rebased_addr;
+	unsigned long start = (unsigned long)&_text;
+	unsigned long end = (unsigned long)&_etext;
+
+	if (ra < start || ra >= end)
+		return false;
+
+	*addr = ra - start;
+	return true;
+}
+#else
+static bool base_address(const void *rebased_addr, unsigned long *addr)
+{
+	*addr = (unsigned long)rebased_addr;
+	return true;
+}
+#endif
+
 static void print_stack(const void **return_addrs, int depth,
 			bool top_is_return_address)
 {
+	unsigned long addr;
 	int i = 0;
 
 	printf("\tSTACK:");
@@ -20,12 +45,14 @@ static void print_stack(const void **return_addrs, int depth,
 	/* @addr indicates a non-return address, as expected by the stack
 	 * pretty printer script. */
 	if (depth > 0 && !top_is_return_address) {
-		printf(" @%lx", (unsigned long) return_addrs[0]);
+		if (base_address(return_addrs[0], &addr))
+			printf(" @%lx", addr);
 		i++;
 	}
 
 	for (; i < depth; i++) {
-		printf(" %lx", (unsigned long) return_addrs[i]);
+		if (base_address(return_addrs[i], &addr))
+			printf(" %lx", addr);
 	}
 	printf("\n");
 }
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 8ce0034..c2e976e 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -24,6 +24,7 @@ CFLAGS += -ffreestanding
 CFLAGS += -O2 -msoft-float -mno-altivec $(mabi_no_altivec)
 CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
 CFLAGS += -Wa,-mregnames
+CFLAGS += -DCONFIG_RELOC
 
 # We want to keep intermediate files
 .PRECIOUS: %.o
-- 
2.34.1

