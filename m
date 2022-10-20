Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1070C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 05:42:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48DD64B90D;
	Thu, 20 Oct 2022 01:42:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ogUws5eC51zX; Thu, 20 Oct 2022 01:42:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B2A54B908;
	Thu, 20 Oct 2022 01:42:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DB644B900
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:42:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LZPAQL4n2u4x for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 01:42:28 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3AB8F49673
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:42:28 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 m66-20020a257145000000b006c23949ec98so6690538ybc.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 22:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=OtsUIATys8SkfvMgOGJq0e0j5nN53CM4H2CIbL5rRi0=;
 b=ZX+JU8/V1nRnIZUBPbKK0qGTCivJ3Y9kvTcZGWISj2umve+Lkc1zeEUrboyT0Inj7Y
 346h2aTSgGDQ76woN32t78HuTwfn28egkrPJcJ4zRgPNIdga8G0bBC3+GBsZiNMRzufB
 aL7kC2Uc2v79AmFgOrlg56nnJTlo5YnORZPdbS/hpakZlDVKuORnYIKxe3FKAy1g3xiK
 DkdHNol0fH/Ag+E+revtePM+AKUrVz+D6EtTvBr2kf8AedsI6W2nk6/QsuhbdmMxG5j1
 xbuN9wr6PpMOqgof1JPBF5A+cRj8YX+X4pxuECrOTMtLYHiDN+g7fJj2HzVHqMk3J4Ln
 nLLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=OtsUIATys8SkfvMgOGJq0e0j5nN53CM4H2CIbL5rRi0=;
 b=POtg9nJw4oWayEU/L8jZeezyeiHODK04IorH+p6D13Mi/g5sKlnwx606d1bcFGOp7s
 r/w+i3nc2y4Q/qyfQhpRvt0JIzAw2mqBbxbgcR8JuAcq/uGx7Fku/gPgxX7ybqP99/eQ
 w6ddxSTkZWqLVS58Ux1fn+XkH2E/QZ4RwfRHGGhB4AbL3o8X8lzIbpZQ13sX0yjeMLzt
 oPD1eVzaCJ06blBGfKDQMMmnK9gpWajFHx2Lp2ez0TbyHfWlyj114K2K7y81ekfN38uY
 nJJjvcpmmPhTzObs5uuRoC1vAmfpJDg00g24kY/XKpsitHgh069EP4a1QW421PGKU6Cc
 EPlQ==
X-Gm-Message-State: ACrzQf1V/Ff5YwSM9/Wqhw95ro2OQXAfeu7ecy7NzfvXOAA2FdFGyIbL
 tZLbnGFZwrgv+4/p/3w4f38GG/6+IF0=
X-Google-Smtp-Source: AMsMyM62d9qUBEI9Szy5XvNyeaXoCZg+BAERgrHl1ogyZK/rKzQd7G+6eh0cX2mqgOijUie19nTObinLjW4=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:e705:0:b0:6ca:6ae:e194 with SMTP id
 e5-20020a25e705000000b006ca06aee194mr4508847ybh.113.1666244547836; Wed, 19
 Oct 2022 22:42:27 -0700 (PDT)
Date: Wed, 19 Oct 2022 22:41:54 -0700
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-2-reijiw@google.com>
Subject: [PATCH v2 1/9] KVM: arm64: selftests: Use FIELD_GET() to extract ID
 register fields
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
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

Use FIELD_GET() macro to extract ID register fields for existing
aarch64 selftests code. No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c  | 3 ++-
 tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 3 ++-
 tools/testing/selftests/kvm/lib/aarch64/processor.c    | 7 ++++---
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c b/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
index 6f9c1f19c7f6..b6a5e8861b35 100644
--- a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
@@ -13,6 +13,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "test_util.h"
+#include <linux/bitfield.h>
 
 #define BAD_ID_REG_VAL	0x1badc0deul
 
@@ -145,7 +146,7 @@ static bool vcpu_aarch64_only(struct kvm_vcpu *vcpu)
 
 	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &val);
 
-	el0 = (val & ARM64_FEATURE_MASK(ID_AA64PFR0_EL0)) >> ID_AA64PFR0_EL0_SHIFT;
+	el0 = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0), val);
 	return el0 == ID_AA64PFR0_ELx_64BIT_ONLY;
 }
 
diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 947bd201435c..3808d3d75055 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -2,6 +2,7 @@
 #include <test_util.h>
 #include <kvm_util.h>
 #include <processor.h>
+#include <linux/bitfield.h>
 
 #define MDSCR_KDE	(1 << 13)
 #define MDSCR_MDE	(1 << 15)
@@ -284,7 +285,7 @@ static int debug_version(struct kvm_vcpu *vcpu)
 	uint64_t id_aa64dfr0;
 
 	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
-	return id_aa64dfr0 & 0xf;
+	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), id_aa64dfr0);
 }
 
 static void test_guest_debug_exceptions(void)
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 6f5551368944..7c96b931edd5 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -11,6 +11,7 @@
 #include "guest_modes.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include <linux/bitfield.h>
 
 #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN	0xac0000
 
@@ -486,9 +487,9 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
 	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
 	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, vcpu_fd));
 
-	*ps4k = ((val >> 28) & 0xf) != 0xf;
-	*ps64k = ((val >> 24) & 0xf) == 0;
-	*ps16k = ((val >> 20) & 0xf) != 0;
+	*ps4k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN4), val) != 0xf;
+	*ps64k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN64), val) == 0;
+	*ps16k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN16), val) != 0;
 
 	close(vcpu_fd);
 	close(vm_fd);
-- 
2.38.0.413.g74048e4d9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
