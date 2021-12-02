Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175C9C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Dec 2021 17:11:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8A5C4B20D;
	Thu,  2 Dec 2021 12:11:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QIyRxdzZpn+7; Thu,  2 Dec 2021 12:11:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E44E4B223;
	Thu,  2 Dec 2021 12:11:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B29874B21E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 12:11:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hyxwV3cFP2R1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Dec 2021 12:11:01 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E54D4B219
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 12:11:00 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 78CA4B82243;
 Thu,  2 Dec 2021 17:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBC4C53FD1;
 Thu,  2 Dec 2021 17:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638465058;
 bh=v3zl9mHxxg1HALqob7r/4qFX7wNgjAZhwam6ujRoXYI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=IhMSRBAC31b3M+uR2h6BUgD6dSBtG1h5jvckFUOwNENqL8n76zA2hnSIeclNfhBXb
 24N1A9Ss8+584XOuZociC2uOnIJKgUS3iu1JRhJ6efa7CFa730fK6cG9amcmggx8Jj
 61m41BMVHMmb2sf+Z4w9OHdYVQjndSjzbJ4ff2tApzu1ACjz2sCyeMTGLqzI69pcfZ
 MAGqo4U++zEp+70th2kq0jrDS2LQkN3ZHPMLNigLUZqWI5XXvHqwjySd5dtNAVBA+v
 Y7XHquVEX7OcGHW8DXWetBrRF2EzAlpbtXxwpTwn1KebzdtrbMB4muWCEgt3Y6tCJk
 gIeuZYCKTB3Qg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/3] KVM: arm64: Generate hyp_constants.h for the host
Date: Thu,  2 Dec 2021 17:10:47 +0000
Message-Id: <20211202171048.26924-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211202171048.26924-1-will@kernel.org>
References: <20211202171048.26924-1-will@kernel.org>
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel@lists.infradead.org
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

In order to avoid exposing hypervisor (EL2) data structures directly to
the host, generate hyp_constants.h to provide constants such as structure
sizes to the host without dragging in the definitions themselves.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/.gitignore          |  2 ++
 arch/arm64/kvm/Makefile            | 16 ++++++++++++++++
 arch/arm64/kvm/hyp/hyp-constants.c | 10 ++++++++++
 3 files changed, 28 insertions(+)
 create mode 100644 arch/arm64/kvm/.gitignore
 create mode 100644 arch/arm64/kvm/hyp/hyp-constants.c

diff --git a/arch/arm64/kvm/.gitignore b/arch/arm64/kvm/.gitignore
new file mode 100644
index 000000000000..6182aefb8302
--- /dev/null
+++ b/arch/arm64/kvm/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+hyp_constants.h
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 989bb5dad2c8..0b561752f8d8 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -25,3 +25,19 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o
+
+always-y := hyp_constants.h hyp-constants.s
+
+define rule_gen_hyp_constants
+	$(call filechk,offsets,__HYP_CONSTANTS_H__)
+endef
+
+CFLAGS_hyp-constants.o = -I $(srctree)/$(src)/hyp/include
+$(obj)/hyp-constants.s: $(src)/hyp/hyp-constants.c FORCE
+	$(call if_changed_dep,cc_s_c)
+
+$(obj)/hyp_constants.h: $(obj)/hyp-constants.s FORCE
+	$(call if_changed_rule,gen_hyp_constants)
+
+obj-kvm := $(addprefix $(obj)/, $(kvm-y))
+$(obj-kvm): $(obj)/hyp_constants.h
diff --git a/arch/arm64/kvm/hyp/hyp-constants.c b/arch/arm64/kvm/hyp/hyp-constants.c
new file mode 100644
index 000000000000..b3742a6691e8
--- /dev/null
+++ b/arch/arm64/kvm/hyp/hyp-constants.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/kbuild.h>
+#include <nvhe/memory.h>
+
+int main(void)
+{
+	DEFINE(STRUCT_HYP_PAGE_SIZE,	sizeof(struct hyp_page));
+	return 0;
+}
-- 
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
