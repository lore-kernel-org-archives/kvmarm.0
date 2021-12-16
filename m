Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3ACC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 16 Dec 2021 12:31:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64A184B1FD;
	Thu, 16 Dec 2021 07:31:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mwadTektAoJx; Thu, 16 Dec 2021 07:31:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37C7C4B26D;
	Thu, 16 Dec 2021 07:31:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E28324B26C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 07:31:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JkQ9jsB17cgg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Dec 2021 07:31:43 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D41534B24E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 07:31:42 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 09EC1B82406;
 Thu, 16 Dec 2021 12:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07CBC36AE8;
 Thu, 16 Dec 2021 12:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639657900;
 bh=HYUAbUw8C+Pz0/hrxg9J3fIBm3qnXOcifD0oOb92RXc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Qhv44O6gI44kV7DCS3fZaSpbeBOS/SdgKixxNfXGcGzKmpXIaOBLTLmRl0cfKd4it
 Toqg82Jr/132h1VSJoAwzV+ORh+mwZmj5t9HRkqN3XjVhEDoDf7Or4dKE5kOn/vc5a
 nt+FzqexrnFrYjYwNVS8AIAcaa7/60yNPkWR1o4bgp3jmUy0NotJyWkytLKTcvm4vu
 c+2r+LGhoOYbOhOfaV/Ppu7kxd+FZv5otG1+CV2XY9aTWmLFhch1f72abjqXf39myI
 XWml5j6lwqBD6TKYB4Qg5t1/F41xW3TD72eCzBIJ3C620U6uIggAX6XSWe+7m64NJc
 dxdgyPsRkS4WA==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mxpv8-00CWIB-Rd; Thu, 16 Dec 2021 12:31:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <drjones@redhat.com>
Subject: [PATCH 4/5] KVM: selftests: arm64: Check for supported page sizes
Date: Thu, 16 Dec 2021 12:31:34 +0000
Message-Id: <20211216123135.754114-5-maz@kernel.org>
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

Just as arm64 implemenations don't necessary support all IPA
ranges, they don't  all support the same page sizes either. Fun.

Create a dummy VM to snapshot the page sizes supported by the
host, and filter the supported modes.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/lib/guest_modes.c | 51 ++++++++++++++++---
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index fadc99bac69c..8db9ea2c4032 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -5,7 +5,42 @@
 #include "guest_modes.h"
 
 #ifdef __aarch64__
+#include "processor.h"
 enum vm_guest_mode vm_mode_default;
+static void get_supported_psz(uint32_t ipa,
+			      bool *ps4k, bool *ps16k, bool *ps64k)
+{
+	struct kvm_vcpu_init preferred_init;
+	int kvm_fd, vm_fd, vcpu_fd, err;
+	uint64_t val;
+	struct kvm_one_reg reg = {
+		.id	= KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1),
+		.addr	= (uint64_t)&val,
+	};
+
+	kvm_fd = open_kvm_dev_path_or_exit();
+	vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, ipa);
+	TEST_ASSERT(vm_fd >= 0, "Can't create VM");
+
+	vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
+	TEST_ASSERT(vcpu_fd >= 0, "Can't create vcpu");
+
+	err = ioctl(vm_fd, KVM_ARM_PREFERRED_TARGET, &preferred_init);
+	TEST_ASSERT(err == 0, "Can't get target");
+	err = ioctl(vcpu_fd, KVM_ARM_VCPU_INIT, &preferred_init);
+	TEST_ASSERT(err == 0, "Can't get init vcpu");
+
+	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
+	TEST_ASSERT(err == 0, "Can't get MMFR0");
+
+	*ps4k = ((val >> 28) & 0xf) != 0xf;
+	*ps64k = ((val >> 24) & 0xf) == 0;
+	*ps16k = ((val >> 20) & 0xf) != 0;
+
+	close(vcpu_fd);
+	close(vm_fd);
+	close(kvm_fd);
+}
 #endif
 
 struct guest_mode guest_modes[NUM_VM_MODES];
@@ -18,20 +53,24 @@ void guest_modes_append_default(void)
 #ifdef __aarch64__
 	{
 		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
+		bool ps4k, ps16k, ps64k;
 		int i;
 
+		get_supported_psz(limit, &ps4k, &ps16k, &ps64k);
+
 		vm_mode_default = NUM_VM_MODES;
 
 		if (limit >= 52)
-			guest_mode_append(VM_MODE_P52V48_64K, true, true);
+			guest_mode_append(VM_MODE_P52V48_64K, ps64k, ps64k);
 		if (limit >= 48) {
-			guest_mode_append(VM_MODE_P48V48_4K, true, true);
-			guest_mode_append(VM_MODE_P48V48_64K, true, true);
+			guest_mode_append(VM_MODE_P48V48_4K, ps4k, ps4k);
+			guest_mode_append(VM_MODE_P48V48_64K, ps64k, ps64k);
 		}
 		if (limit >= 40) {
-			guest_mode_append(VM_MODE_P40V48_4K, true, true);
-			guest_mode_append(VM_MODE_P40V48_64K, true, true);
-			vm_mode_default = VM_MODE_P40V48_4K;
+			guest_mode_append(VM_MODE_P40V48_4K, ps4k, ps4k);
+			guest_mode_append(VM_MODE_P40V48_64K, ps64k, ps64k);
+			if (ps4k)
+				vm_mode_default = VM_MODE_P40V48_4K;
 		}
 
 		/* Pick the largest supported IPA size */
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
