Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FAF6C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 27 Dec 2021 12:49:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2825849E18;
	Mon, 27 Dec 2021 07:49:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d1FiAvhRFH2s; Mon, 27 Dec 2021 07:49:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6441349E3B;
	Mon, 27 Dec 2021 07:49:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B5D340D0B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Dec 2021 07:49:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I1AigBWPLHEk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Dec 2021 07:49:02 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 04A2C41174
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Dec 2021 07:49:00 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 6676EB8102B;
 Mon, 27 Dec 2021 12:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA69C36AEB;
 Mon, 27 Dec 2021 12:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1640609338;
 bh=ffbdeZ5bQPyh8MTqynKoFo8gtfzkNyhGOr52LWv3kkA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=PvNMjf0hvJ7DNKX69BVUF9vI35GaPiULQwrldc0WNqJhLjhXYakaWJ603+ruZq7UX
 +zBr8aZvjqE7gwIhGv9VqS4RpT/9d2SDK8fOvozgZ3M/Xxrrriu9GgnQ2mrbXjcZlz
 mP/SIDuVL2eiTvq/BDEkL083Yb9734it3WNeLvewJE/BICAxCs/Gys5ztd0uO2tbmG
 0R8iVog71+mTB7nOLinA7K3CX4K7o5KsTvAfgHcfdn15V740PTG9XYj+Pc4Zm3HMBJ
 LoKwy20OLoGtlqfd891ouZdJ/IXJiHknPiCm/ruB1RLhadllUFyQm9RVoSFUNQ4h6T
 vSMwYSj6CJq8g==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1n1pQu-00EYBY-Az; Mon, 27 Dec 2021 12:48:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <drjones@redhat.com>
Subject: [PATCH v2 2/6] KVM: selftests: arm64: Introduce a variable default
 IPA size
Date: Mon, 27 Dec 2021 12:48:05 +0000
Message-Id: <20211227124809.1335409-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211227124809.1335409-1-maz@kernel.org>
References: <20211227124809.1335409-1-maz@kernel.org>
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
 tools/testing/selftests/kvm/lib/guest_modes.c | 30 +++++++++++++++++--
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 2d62edc49d67..7fa0a93d7526 100644
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
index c330f414ef96..5e3fdbd992fd 100644
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
-#ifdef __aarch64__
-	guest_mode_append(VM_MODE_P40V48_64K, true, true);
+#else
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
+		/*
+		 * Pick the first supported IPA size if the default
+		 * isn't available.
+		 */
+		for (i = 0; vm_mode_default == NUM_VM_MODES && i < NUM_VM_MODES; i++) {
+			if (guest_modes[i].supported && guest_modes[i].enabled)
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
