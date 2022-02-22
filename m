Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B302FC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 11:02:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BD264C470;
	Wed, 23 Feb 2022 06:02:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HimnDcs2PfzF; Wed, 23 Feb 2022 06:02:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9533D4C49B;
	Wed, 23 Feb 2022 06:02:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D6C449E46
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 11:59:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OZ4Ni484Vk69 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 11:59:32 -0500 (EST)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2078E404B2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 11:59:32 -0500 (EST)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2d0a5824ec6so145942617b3.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 08:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=kA1uHTXTZgvCDEwUv0Venj02VbjFVl5MyBDxltrhOyc=;
 b=NP6fnietNid07WODom2crvgVApuYNwyBc+vaQeT9ELb0Wby0y027V1WoutortBDdER
 6VKH2m5g/hhqE8jP+GV8Z52SXKndZFpGpqKGnvqTJ6saOgO9yiXq/Sl8KOE48ShXSFrf
 Yd/GQs7iTARZWcbcAbs2DZcziHvlIf4ws8th2T86PRoxGLRCAo79SHT5a0UzBseydVww
 c/kdTBUTDmKW4WhBmbRdCfs4Sm1ZyK65IyLMvKPqQFMBa2uiSRCXXe8ja7vMgkYdHVOd
 FDQ7AFIgQCuxZCe7VWKGtZS0vLPpQ4mLhJFEH4IE0gr/JO65ZVTSGIb2gzhuMTjBEe1w
 9t+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=kA1uHTXTZgvCDEwUv0Venj02VbjFVl5MyBDxltrhOyc=;
 b=3E9OVJq+MO9btHhVQxtChV87kiUuZn6xLspJtgLGr8LBgaKyTSTb5Ajh0oE+IWZ4+l
 Y5pK0NV4ofkgtFMBe1/xpLevL8pqS8uTi1144jyb/0ns6lB1G+jpXX+ZjJxY5pw4lMpM
 l98vPCisDwyJ+L6dcLotRu0ABEVU4qnEFaqT1Vo++SROtHN5nLZtp4Pm5b5TJjqu9xRw
 9wDDPSYFHU6yLiMxY6toM7CmpwFr3qkD7hjOV2wpwh06MP4A3PXFCXPxH99Z9rsQ8ztb
 xyoMz9cvx+6Beu1l9V2KzkC0CBTdqJslcF4Aev4WQYIFYYW/IBJgWIv8ag5VEqoZKA/m
 XTBQ==
X-Gm-Message-State: AOAM532xNVXzoFWXf24Y5AjU70EqYXmMxOv947ub66cTOPD/DBOsuBSw
 RlXXa9etTG7XTuHkyB4E/UqKYXIdupqDAWvqyg==
X-Google-Smtp-Source: ABdhPJw2THd1z2iAbfih7pFjkHmBG5AlQKbmEqgBiWlGmwrM/dGUOKWBoivdDJ4o6t47SOdmT8K0alB2LRMYcbGgbA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5db7:1235:b3dd:cfcb])
 (user=kaleshsingh job=sendgmr) by 2002:a81:138a:0:b0:2d6:b391:90cd with SMTP
 id 132-20020a81138a000000b002d6b39190cdmr23404107ywt.480.1645549171601; Tue,
 22 Feb 2022 08:59:31 -0800 (PST)
Date: Tue, 22 Feb 2022 08:51:07 -0800
In-Reply-To: <20220222165212.2005066-1-kaleshsingh@google.com>
Message-Id: <20220222165212.2005066-7-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220222165212.2005066-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v2 6/9] KVM: arm64: Detect and handle hypervisor stack
 overflows
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Wed, 23 Feb 2022 06:02:29 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Kalesh Singh <kaleshsingh@google.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 Pasha Tatashin <pasha.tatashin@soleen.com>, surenb@google.com,
 Peter Collingbourne <pcc@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>
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

The hypervisor stacks (for both nVHE Hyp mode and nVHE protected mode)
are aligned to twice their size (PAGE_SIZE), meaning that any valid stack
address has PAGE_SHIFT bit as 0. This allows us to conveniently check for
overflow in the exception entry without corrupting any GPRs. We won't
recover from a stack overflow so panic the hypervisor.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/kvm/hyp/nvhe/host.S   | 16 ++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c |  5 +++++
 2 files changed, 21 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 3d613e721a75..78e4b612ac06 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -153,6 +153,10 @@ SYM_FUNC_END(__host_hvc)
 
 .macro invalid_host_el2_vect
 	.align 7
+
+	/* Test stack overflow without corrupting GPRs */
+	test_sp_overflow PAGE_SHIFT, .L__hyp_sp_overflow\@
+
 	/* If a guest is loaded, panic out of it. */
 	stp	x0, x1, [sp, #-16]!
 	get_loaded_vcpu x0, x1
@@ -165,6 +169,18 @@ SYM_FUNC_END(__host_hvc)
 	 * been partially clobbered by __host_enter.
 	 */
 	b	hyp_panic
+
+.L__hyp_sp_overflow\@:
+	/*
+	 * Reset SP to the top of the stack, to allow handling the hyp_panic.
+	 * This corrupts the stack but is ok, since we won't be attempting
+	 * any unwinding here.
+	 */
+	ldr_this_cpu	x0, kvm_init_params + NVHE_INIT_STACK_HYP_VA, x1
+	mov	sp, x0
+
+	bl	hyp_panic_bad_stack
+	ASM_BUG()
 .endm
 
 .macro invalid_host_el1_vect
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6410d21d8695..5a2e1ab79913 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -369,6 +369,11 @@ void __noreturn hyp_panic(void)
 	unreachable();
 }
 
+void __noreturn hyp_panic_bad_stack(void)
+{
+	hyp_panic();
+}
+
 asmlinkage void kvm_unexpected_el2_exception(void)
 {
 	return __kvm_unexpected_el2_exception();
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
