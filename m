Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D63D0C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 27 Dec 2021 12:49:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8888849E42;
	Mon, 27 Dec 2021 07:49:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eqqF-BopwJDG; Mon, 27 Dec 2021 07:49:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F92649E39;
	Mon, 27 Dec 2021 07:49:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57CB149B26
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Dec 2021 07:49:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8cOAEZ0OfdTP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Dec 2021 07:49:02 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4FB0340E3D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Dec 2021 07:49:01 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 52469B8102C;
 Mon, 27 Dec 2021 12:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058ECC36AEF;
 Mon, 27 Dec 2021 12:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1640609339;
 bh=JabW9dlW4Ga6PrjMR8Ww0FJREGSbrtgVVILsUf/lKtk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=N6a5KXyhiC1Myob8/tKk4hDRdN3DNb6tCCAwMyDT04Qhgj9FTRyMToYfSkg78QgLe
 nOI61w3v3HhL11bf/WOEbBkzVQUyybop3euOpcGegt+iwF3maASr0/Q3f7KSFxOSYG
 Xgidu21eF6/jAgYl2rK08doOb1Rm74A7T1U8QpNUT3dJnlgFwDnsgXAKKo2IaQY72G
 uc3Nk3xvCa5nC8mV4Oo+Eq5Xgx75yQQL5evr8ggdNGMYD7ci7ZP3kqLXC5gDDxBtkT
 qKZ2jbpbtPQkLC9xaFpjEhmxWt6gjj6iSDpX2dEuYyLa+fxO2Yh2KOIDfbdwclaUl2
 a2Js4joui1iYA==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1n1pQv-00EYBY-5q; Mon, 27 Dec 2021 12:48:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <drjones@redhat.com>
Subject: [PATCH v2 6/6] KVM: selftests: arm64: Add support for various modes
 with 16kB page size
Date: Mon, 27 Dec 2021 12:48:09 +0000
Message-Id: <20211227124809.1335409-7-maz@kernel.org>
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

The 16kB page size is not a popular choice, due to only a few CPUs
actually implementing support for it. However, it can lead to some
interesting performance improvements given the right uarch choices.

Add support for this page size for various PA/VA combinations.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/include/kvm_util.h   |  4 ++++
 .../selftests/kvm/lib/aarch64/processor.c        | 10 ++++++++++
 tools/testing/selftests/kvm/lib/guest_modes.c    |  4 ++++
 tools/testing/selftests/kvm/lib/kvm_util.c       | 16 ++++++++++++++++
 4 files changed, 34 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index fd1397fc7ad5..e1f27626bbdc 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -42,14 +42,18 @@ enum vm_guest_mode {
 	VM_MODE_P52V48_4K,
 	VM_MODE_P52V48_64K,
 	VM_MODE_P48V48_4K,
+	VM_MODE_P48V48_16K,
 	VM_MODE_P48V48_64K,
 	VM_MODE_P40V48_4K,
+	VM_MODE_P40V48_16K,
 	VM_MODE_P40V48_64K,
 	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
 	VM_MODE_P47V64_4K,
 	VM_MODE_P44V64_4K,
 	VM_MODE_P36V48_4K,
+	VM_MODE_P36V48_16K,
 	VM_MODE_P36V48_64K,
+	VM_MODE_P36V47_16K,
 	NUM_VM_MODES,
 };
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 70395c777ea4..9343d82519b4 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -252,6 +252,12 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init
 	case VM_MODE_P36V48_64K:
 		tcr_el1 |= 1ul << 14; /* TG0 = 64KB */
 		break;
+	case VM_MODE_P48V48_16K:
+	case VM_MODE_P40V48_16K:
+	case VM_MODE_P36V48_16K:
+	case VM_MODE_P36V47_16K:
+		tcr_el1 |= 2ul << 14; /* TG0 = 16KB */
+		break;
 	case VM_MODE_P48V48_4K:
 	case VM_MODE_P40V48_4K:
 	case VM_MODE_P36V48_4K:
@@ -267,15 +273,19 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init
 		tcr_el1 |= 6ul << 32; /* IPS = 52 bits */
 		break;
 	case VM_MODE_P48V48_4K:
+	case VM_MODE_P48V48_16K:
 	case VM_MODE_P48V48_64K:
 		tcr_el1 |= 5ul << 32; /* IPS = 48 bits */
 		break;
 	case VM_MODE_P40V48_4K:
+	case VM_MODE_P40V48_16K:
 	case VM_MODE_P40V48_64K:
 		tcr_el1 |= 2ul << 32; /* IPS = 40 bits */
 		break;
 	case VM_MODE_P36V48_4K:
+	case VM_MODE_P36V48_16K:
 	case VM_MODE_P36V48_64K:
+	case VM_MODE_P36V47_16K:
 		tcr_el1 |= 1ul << 32; /* IPS = 36 bits */
 		break;
 	default:
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index 240f2d2e2d23..da315d3373a3 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -29,17 +29,21 @@ void guest_modes_append_default(void)
 			guest_mode_append(VM_MODE_P52V48_64K, ps64k, ps64k);
 		if (limit >= 48) {
 			guest_mode_append(VM_MODE_P48V48_4K, ps4k, ps4k);
+			guest_mode_append(VM_MODE_P48V48_16K, ps16k, ps16k);
 			guest_mode_append(VM_MODE_P48V48_64K, ps64k, ps64k);
 		}
 		if (limit >= 40) {
 			guest_mode_append(VM_MODE_P40V48_4K, ps4k, ps4k);
+			guest_mode_append(VM_MODE_P40V48_16K, ps16k, ps16k);
 			guest_mode_append(VM_MODE_P40V48_64K, ps64k, ps64k);
 			if (ps4k)
 				vm_mode_default = VM_MODE_P40V48_4K;
 		}
 		if (limit >= 36) {
 			guest_mode_append(VM_MODE_P36V48_4K, ps4k, ps4k);
+			guest_mode_append(VM_MODE_P36V48_16K, ps16k, ps16k);
 			guest_mode_append(VM_MODE_P36V48_64K, ps64k, ps64k);
+			guest_mode_append(VM_MODE_P36V47_16K, ps16k, ps16k);
 		}
 
 		/*
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9da71e27cd84..658a964ad641 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -166,14 +166,18 @@ const char *vm_guest_mode_string(uint32_t i)
 		[VM_MODE_P52V48_4K]	= "PA-bits:52,  VA-bits:48,  4K pages",
 		[VM_MODE_P52V48_64K]	= "PA-bits:52,  VA-bits:48, 64K pages",
 		[VM_MODE_P48V48_4K]	= "PA-bits:48,  VA-bits:48,  4K pages",
+		[VM_MODE_P48V48_16K]	= "PA-bits:48,  VA-bits:48, 16K pages",
 		[VM_MODE_P48V48_64K]	= "PA-bits:48,  VA-bits:48, 64K pages",
 		[VM_MODE_P40V48_4K]	= "PA-bits:40,  VA-bits:48,  4K pages",
+		[VM_MODE_P40V48_16K]	= "PA-bits:40,  VA-bits:48, 16K pages",
 		[VM_MODE_P40V48_64K]	= "PA-bits:40,  VA-bits:48, 64K pages",
 		[VM_MODE_PXXV48_4K]	= "PA-bits:ANY, VA-bits:48,  4K pages",
 		[VM_MODE_P47V64_4K]	= "PA-bits:47,  VA-bits:64,  4K pages",
 		[VM_MODE_P44V64_4K]	= "PA-bits:44,  VA-bits:64,  4K pages",
 		[VM_MODE_P36V48_4K]	= "PA-bits:36,  VA-bits:48,  4K pages",
+		[VM_MODE_P36V48_16K]	= "PA-bits:36,  VA-bits:48, 16K pages",
 		[VM_MODE_P36V48_64K]	= "PA-bits:36,  VA-bits:48, 64K pages",
+		[VM_MODE_P36V47_16K]	= "PA-bits:36,  VA-bits:47, 16K pages",
 	};
 	_Static_assert(sizeof(strings)/sizeof(char *) == NUM_VM_MODES,
 		       "Missing new mode strings?");
@@ -187,14 +191,18 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 	[VM_MODE_P52V48_4K]	= { 52, 48,  0x1000, 12 },
 	[VM_MODE_P52V48_64K]	= { 52, 48, 0x10000, 16 },
 	[VM_MODE_P48V48_4K]	= { 48, 48,  0x1000, 12 },
+	[VM_MODE_P48V48_16K]	= { 48, 48,  0x4000, 14 },
 	[VM_MODE_P48V48_64K]	= { 48, 48, 0x10000, 16 },
 	[VM_MODE_P40V48_4K]	= { 40, 48,  0x1000, 12 },
+	[VM_MODE_P40V48_16K]	= { 40, 48,  0x4000, 14 },
 	[VM_MODE_P40V48_64K]	= { 40, 48, 0x10000, 16 },
 	[VM_MODE_PXXV48_4K]	= {  0,  0,  0x1000, 12 },
 	[VM_MODE_P47V64_4K]	= { 47, 64,  0x1000, 12 },
 	[VM_MODE_P44V64_4K]	= { 44, 64,  0x1000, 12 },
 	[VM_MODE_P36V48_4K]	= { 36, 48,  0x1000, 12 },
+	[VM_MODE_P36V48_16K]	= { 36, 48,  0x4000, 14 },
 	[VM_MODE_P36V48_64K]	= { 36, 48, 0x10000, 16 },
+	[VM_MODE_P36V47_16K]	= { 36, 47,  0x4000, 14 },
 };
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
@@ -263,6 +271,14 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 	case VM_MODE_P36V48_64K:
 		vm->pgtable_levels = 3;
 		break;
+	case VM_MODE_P48V48_16K:
+	case VM_MODE_P40V48_16K:
+	case VM_MODE_P36V48_16K:
+		vm->pgtable_levels = 4;
+		break;
+	case VM_MODE_P36V47_16K:
+		vm->pgtable_levels = 3;
+		break;
 	case VM_MODE_PXXV48_4K:
 #ifdef __x86_64__
 		kvm_get_cpu_address_width(&vm->pa_bits, &vm->va_bits);
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
