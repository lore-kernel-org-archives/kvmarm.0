Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6FAFC04FDE
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 00:17:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 819AC4B93D;
	Mon, 12 Dec 2022 19:17:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E+YO-o6-0Ngt; Mon, 12 Dec 2022 19:17:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0043F4B960;
	Mon, 12 Dec 2022 19:17:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 739EF4B6C8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zNB6Ap5zo7kv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 19:17:15 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEAE84B93D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:14 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 mg21-20020a17090b371500b00219767e0175so854963pjb.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 16:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=8EoQ5xUEc1FhkDzFjTM8ar5jGOrCyi+Uxx/y/QqNxRU=;
 b=ipDKG2JVkVU4OEFWDzPMjQvpwLjKrvLtAsE0Q12Ig0QpxJrg8GZmiIm/+azC7Rsqa2
 1pdKNzn7q+j8SVvNFFE1MwcgltFtLpVT1j20hR2QXC2Javgns9JomPzKxX8az0MVR8Lr
 xwxNQ4L+57LcZAeNwj6COf48lC0gORWpzAAh4EHs1sxnOZZrp+oLMfA4c+3AeRny/IkJ
 jwTjCm1aa2Xqxkk8MuRjUDMVdOpUJRa/4/CvkiRx5C364j7RnnRN0GmaWDsiuRVgQoLD
 8mXK/UHXSQfeZuLkyN4NIw4jy3LAgiOHXlbk3sYihSHK7Kz3E1BePP1k4h5mJdMfm87Z
 NXaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=8EoQ5xUEc1FhkDzFjTM8ar5jGOrCyi+Uxx/y/QqNxRU=;
 b=1ezaRd+i+FgogKqo1ak5y5LKYN/D7K30yAI4kD28FTDznNZn3Irz86dCGMKieXgaC+
 YiIw6dX0kxa8K5M3ZxSbgR5wmmIMqc/PNFHeWXLtY4MxnJ5qgv65eHwBhZ5p0b/7RRBe
 ebA6HdbnJegy1oMwmOCGkLUfWM9ICqz583Zvo4GiN/At7TrTPsrcvhoMrxzs/nfTWhPb
 /g+AcWIEwkUBs3zSGCloA/2Et54RbJpS3vtNezgbvhZmeP/0gO6G1c39kY1AHm5eYAWX
 FY6OwZ2AnVb/8hDCh14+bAraZec17Z9Vw2RNl5uKyEj3JZC4DA7eaMlhj8/J13xYH2b+
 aMkw==
X-Gm-Message-State: ANoB5pk+6HvOdXnvLGB5VAo/1al54a5MQHTF47YipAVdhqggXvXNSHFM
 YKu9DLx2s8jpWg6RtJUDrxf3isLgaok=
X-Google-Smtp-Source: AA0mqf41e8RRAh+qKfNTJDDY/qqZQdHGGB0nRmZ6p6Bfn39lpFfpCEPh+Tpnh5gE0AblUZ/3qOhiatioU1w=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:bc86:b0:189:6ab:a97c with SMTP id
 bb6-20020a170902bc8600b0018906aba97cmr77809422plb.39.1670890633860; Mon, 12
 Dec 2022 16:17:13 -0800 (PST)
Date: Tue, 13 Dec 2022 00:16:49 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-11-seanjc@google.com>
Subject: [PATCH 10/14] KVM: selftests: Include lib.mk before consuming $(CC)
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
 Tom Rix <trix@redhat.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Include lib.mk before consuming $(CC) and document that lib.mk overwrites
$(CC) unless make was invoked with -e or $(CC) was specified after make
(which apparently makes the environment override the Makefile?!?!).
Including lib.mk after using it for probing, e.g. for -no-pie, can lead
to weirdness.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 6594ed51eeea..2487db21b177 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -182,6 +182,11 @@ TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH_DIR))
 TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH_DIR))
 LIBKVM += $(LIBKVM_$(ARCH_DIR))
 
+# lib.mak defines $(OUTPUT), prepends $(OUTPUT)/ to $(TEST_GEN_PROGS), and most
+# importantly defines, i.e. overwrites, $(CC) (unless `make -e` or `make CC=`,
+# which causes the environment variable to override the makefile).
+include ../lib.mk
+
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
 LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
@@ -207,10 +212,6 @@ pgste-option = $(call try-run, echo 'int main(void) { return 0; }' | \
 LDLIBS += -ldl
 LDFLAGS += -pthread $(no-pie-option) $(pgste-option)
 
-# After inclusion, $(OUTPUT) is defined and
-# $(TEST_GEN_PROGS) starts with $(OUTPUT)/
-include ../lib.mk
-
 LIBKVM_C := $(filter %.c,$(LIBKVM))
 LIBKVM_S := $(filter %.S,$(LIBKVM))
 LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
