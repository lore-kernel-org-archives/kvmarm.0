Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6FCC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jan 2022 21:05:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A76154B121;
	Mon, 10 Jan 2022 16:05:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HyAp+vSeugEk; Mon, 10 Jan 2022 16:05:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE1C74B0B9;
	Mon, 10 Jan 2022 16:05:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84EA04B0B4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 16:05:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 686O2OoJfw2r for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 16:05:06 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7710D4B0B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 16:05:06 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 d92-20020a17090a6f6500b001b35ac5f393so10310764pjk.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 13:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=vBy+mErr/Ri6TNTRhXUfpamv23OXSo9DbZDSg0SsleA=;
 b=j4wxxxti3g07KeR5JHvFJjSWeBtiIqEnlJZMlLN+QAnslR8j6tBWxo5GU+hia2wTGw
 W4jmM4Uh7jDA0RFkEjTe29a6Xs+Im3R7Oeir+9fg4a5+fcwiPsflg7OKLwo/qOOfKE2g
 skORzCFyO2ZQiMpz5MIDa1Cvo7YG4v/3cVutqX1mm6lkfEQZTD0NSXrpDN145MyFPWhj
 MAf0jDXO36ivf9Dm/Hhz8vXmZ4A7ai5SiRUy52hLcycYaMgnorvd/x90eWjdPGjL4UlU
 Q1vCcaJMoMfzLf/JS/Co/U0KZcX4Dnt+zug3KcIOu++dR9VgtyZWhGIJqgFyhQznpNUx
 C2Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=vBy+mErr/Ri6TNTRhXUfpamv23OXSo9DbZDSg0SsleA=;
 b=d9gsRCeT2QvANS098AjFrQYP0PcbIDCr1hR63yXNLB8CEoWqO3XuuU/ZjcjYITEsHE
 FcuOS3QALUQvDLHe/elnhZREQgPDQ8HwMXdxrsUO35jCvTu33YQnLLrnRjNsUZvIRDkW
 OeohO52hiG8hIq9zPzORb+aPsMvizmFCm6bKkiqO2TIBQJ1xQsdv1l0aS/PMUZh23pot
 VWsJ8oiOt1EgN3nIL9ZA3IofVwC0Bnjcrj8eXf9NsGH82Uala0LYwpqM9M6zyU4S7B01
 X5o7quBgt+3HZc9es8I7QLSxXUU3sxOyeg6K0MLvcBPlR+/caCmOhN1jmQ6wWgZMPcsR
 diMQ==
X-Gm-Message-State: AOAM533pnTHlXiPZ1KwPv83k6ok1Rcjunqs2qCei8HjdiRDm385vFfQH
 GXKPmJToSRL1ek/HVelylsTy3XlKeAdW/Lxaig==
X-Google-Smtp-Source: ABdhPJyA6eTvWUsrJk2S/OyaiGDE/FsFt0ITd8LARBlVorREgJZxAx6nOm6HJvMjiBTPntB3YG6byKs1bXRAzVy7wA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by
 2002:a05:6a00:1819:b0:4ba:eaa6:d1b8 with
 SMTP id y25-20020a056a00181900b004baeaa6d1b8mr1349363pfa.78.1641848705619;
 Mon, 10 Jan 2022 13:05:05 -0800 (PST)
Date: Mon, 10 Jan 2022 21:04:41 +0000
In-Reply-To: <20220110210441.2074798-1-jingzhangos@google.com>
Message-Id: <20220110210441.2074798-4-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220110210441.2074798-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [RFC PATCH 3/3] KVM: selftests: Add vgic initialization for dirty log
 perf test for ARM
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, 
 David Matlack <dmatlack@google.com>, Oliver Upton <oupton@google.com>, 
 Reiji Watanabe <reijiw@google.com>
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
2.34.1.575.g55b058a8bb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
