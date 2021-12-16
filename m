Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C562C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 16 Dec 2021 12:31:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 070A94B24E;
	Thu, 16 Dec 2021 07:31:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b9kEgP7pcgfS; Thu, 16 Dec 2021 07:31:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A649E4B25F;
	Thu, 16 Dec 2021 07:31:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96DE84B24D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 07:31:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p6BfRN6QdNy7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Dec 2021 07:31:41 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97DE14B1D5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 07:31:41 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 211A561DCB;
 Thu, 16 Dec 2021 12:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E44C36AE4;
 Thu, 16 Dec 2021 12:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639657900;
 bh=kBOiO5yeoWnB+tkXGY+eu1N5qdNCnGtoe3lJ3h1k9ww=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=I5h2h/+UnYA/I3ORTb4wfkIw42D/HcvLRVMjTf1tKNA1XhWVY9YQEJtPSe03wZieo
 jG3WEpxBRwf5sBov7HxERfUJt6R+ruRrZQbrRHmqW/IThySX99sppmn5JEmabe/Q2G
 OjxvnYkMBlbPal33RpMUzaPpefC3Q3ijDh2qof4Gh5u1Jo07nWtDxHSJ3zMeFqWMPq
 PwwtA2SGKTQW04D7IJYqOCUXZ2RGIOaVcFkEjwdNesaJdxHDLV9jcSPrcJltborrAH
 d/4OzbHCMPIksSkpnyTpRAXlUi+/1wKe1Vth+v+Oo4GnpGYiWMPDcNCYZjDY0fZiv0
 rpfac1Z7CE9eA==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mxpv8-00CWIB-Kx; Thu, 16 Dec 2021 12:31:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <drjones@redhat.com>
Subject: [PATCH 3/5] KVM: selftests: arm64: Introduce a variable default IPA
 size
Date: Thu, 16 Dec 2021 12:31:33 +0000
Message-Id: <20211216123135.754114-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211216123135.754114-1-maz@kernel.org>
References: <20211216123135.754114-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

Contrary to popular belief, there is no such thing as a default
IPA size on arm64. Anything goes, and implementations are the
usual Wild West.

The selftest infrastructure default to 40bit IPA, which obviously
doesn't work for some systems out there.

Turn VM_MODE_DEFAULT from a constant into a variable, and let
guest_modes_append_default() populate it, depending on what
the HW can do. In order to preserve the current behaviour, we
still pick 40bits IPA as the default if it is available, and
the largest supported IPA space otherwise.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  4 ++-
 tools/testing/selftests/kvm/lib/guest_modes.c | 28 +++++++++++++++++--
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index c74241ddf8b1..d2ba830a1faf 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -53,7 +53,9 @@ enum vm_guest_mode {
 
 #if defined(__aarch64__)
 
-#define VM_MODE_DEFAULT			VM_MODE_P40V48_4K
+extern enum vm_guest_mode vm_mode_default;
+
+#define VM_MODE_DEFAULT			vm_mode_default
 #define MIN_PAGE_SHIFT			12U
 #define ptes_per_page(page_size)	((page_size) / 8)
 
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index c330f414ef96..fadc99bac69c 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -4,22 +4,46 @@
  */
 #include "guest_modes.h"
 
+#ifdef __aarch64__
+enum vm_guest_mode vm_mode_default;
+#endif
+
 struct guest_mode guest_modes[NUM_VM_MODES];
 
 void guest_modes_append_default(void)
 {
+#ifndef __aarch64__
 	guest_mode_append(VM_MODE_DEFAULT, true, true);
-
+#endif
 #ifdef __aarch64__
-	guest_mode_append(VM_MODE_P40V48_64K, true, true);
 	{
 		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
+		int i;
+
+		vm_mode_default = NUM_VM_MODES;
+
 		if (limit >= 52)
 			guest_mode_append(VM_MODE_P52V48_64K, true, true);
 		if (limit >= 48) {
 			guest_mode_append(VM_MODE_P48V48_4K, true, true);
 			guest_mode_append(VM_MODE_P48V48_64K, true, true);
 		}
+		if (limit >= 40) {
+			guest_mode_append(VM_MODE_P40V48_4K, true, true);
+			guest_mode_append(VM_MODE_P40V48_64K, true, true);
+			vm_mode_default = VM_MODE_P40V48_4K;
+		}
+
+		/* Pick the largest supported IPA size */
+		for (i = 0;
+		     vm_mode_default == NUM_VM_MODES && i < NUM_VM_MODES;
+		     i++) {
+			if (guest_modes[i].supported)
+				vm_mode_default = i;
+		}
+
+		TEST_ASSERT(vm_mode_default != NUM_VM_MODES,
+			    "No supported mode!");
 	}
 #endif
 #ifdef __s390x__
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
