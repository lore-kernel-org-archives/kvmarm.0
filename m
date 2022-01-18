Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15F9C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jan 2022 01:57:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AA6849E49;
	Mon, 17 Jan 2022 20:57:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NUv2r9jV+Ftk; Mon, 17 Jan 2022 20:57:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1564149F2A;
	Mon, 17 Jan 2022 20:57:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CCEF49E44
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 20:57:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5CHLj9kKD0d8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jan 2022 20:57:13 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD74749DF6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 20:57:12 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 d9-20020a62f809000000b004bb5ffee9b3so7202188pfh.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 17:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=mvimdalggRqv44+8DxSjpX0UJ7y65xJ7W9TGgiRekLQ=;
 b=AiNhonZ8w18AjTZDIERNhgzwKTJ7KI9+QJJd8eVZ97usyEfyImywldUVzLovaShH9S
 cLGIp0JfORuBbqRrDQbnT8FEtXaKIml5rY0QTX1c3EsLUO1u1lusYyOq6/fGFppMM1//
 aMwpKmSOqoGv//5rZZjp+PvOE9ATF7D2w1i5j/1B1kIeL+BxfVCHYeJZm8XKHz56xqbV
 rTigTGzw72EsIWpvKlFSWwdzmOeSxzJ3UTPMbpRY8v00WHB1Iw74Xq6c0G1rYfZNMenY
 43HurKrjCLaAFTZl6EzVTXc58H9IJkNCVSaKrl3M7BJdjavfNTeXC6nyEIxAsJu5lIxx
 fctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=mvimdalggRqv44+8DxSjpX0UJ7y65xJ7W9TGgiRekLQ=;
 b=YaZosYTzile5bBc+/bToaUdE9UjcQV12uZEWcCs4AAJ1k1RmGwQY3PH6WaR6O3ofzB
 Yzv14SPomKmtF7D03QTyodnZ32iSNvUWx2KIpRfhsgbP/1jmmF0v4txSD2wRYlW0Yb09
 0rmLNy6fKdURqLFe/tC4F8incxq+0cPj99SRbqey7+TWcnj/eTE1hFbXcsjAB86FqpFC
 Vr8OTJGf2VkIu40QkacJvlAD2f+yZIC1hY1rwEl2Ta8f97Gqlma7s3zUtYaBzI8DSpcr
 i4qifx9hHzikkxtgq52UnlGii45RZUQ+PmdAlbKJugZYrRh31fR8ZFp0tXiZNaD91cVm
 mLWA==
X-Gm-Message-State: AOAM5313lngfXWPlxjJicgxaq1xAPWSDINIrgkhj/lAtjUsJB1cF5r4E
 /BrTDtYjXo4l3lhx/smIuqH8c0k07w28odTV3g==
X-Google-Smtp-Source: ABdhPJy3MfvyC98SST6vF79hK6xhszFOokBw22k4x5+KH+epIuRlSbBOdJSPcTvn8fxkwxwF8De41dpAJAhSSAm4Fw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:4d84:: with SMTP id
 oj4mr1115111pjb.0.1642471031804;
 Mon, 17 Jan 2022 17:57:11 -0800 (PST)
Date: Tue, 18 Jan 2022 01:57:03 +0000
In-Reply-To: <20220118015703.3630552-1-jingzhangos@google.com>
Message-Id: <20220118015703.3630552-4-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220118015703.3630552-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 3/3] KVM: selftests: Add vgic initialization for dirty log
 perf test for ARM
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, 
 David Matlack <dmatlack@google.com>, Oliver Upton <oupton@google.com>, 
 Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
 Raghavendra Rao Ananta <rananta@google.com>
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

For ARM64, if no vgic is setup before the dirty log perf test, the
userspace irqchip would be used, which would affect the dirty log perf
test result.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 1954b964d1cf..b501338d9430 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -18,6 +18,12 @@
 #include "test_util.h"
 #include "perf_test_util.h"
 #include "guest_modes.h"
+#ifdef __aarch64__
+#include "aarch64/vgic.h"
+
+#define GICD_BASE_GPA			0x8000000ULL
+#define GICR_BASE_GPA			0x80A0000ULL
+#endif
 
 /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
 #define TEST_HOST_LOOP_N		2UL
@@ -200,6 +206,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		vm_enable_cap(vm, &cap);
 	}
 
+#ifdef __aarch64__
+	vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+#endif
+
 	/* Start the iterations */
 	iteration = 0;
 	host_quit = false;
-- 
2.34.1.703.g22d0c6ccf7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
