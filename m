Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EDB3C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 15:58:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 932D26101E
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 15:58:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 932D26101E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 480A34B0D6;
	Fri,  8 Oct 2021 11:58:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id isr13m7wkkoz; Fri,  8 Oct 2021 11:58:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38E574B129;
	Fri,  8 Oct 2021 11:58:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 569214B121
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 11:58:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id djv33mc6xXJb for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 11:58:44 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 864674B11E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 11:58:43 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 o90-20020a0c85e3000000b0038310a20003so9088719qva.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 08:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=25eLjj7S096UhlQv84j+y5ZsIz1F9KN7hX8cPXIiaYA=;
 b=gpL6FgtFQU7IFWTRpKU8iOgdAAyOqI+HTrp/lkYRtI4LxWgISzc4xTuEPeQm5RcPbG
 xcgafVhz5W4y1PzQCXSXCjYS3csvKTlIQ9pG5sjM6O9NeJl4cn4HRqh5sEjM3V/24D41
 n3Jeb14r6NMI62TasyQ7i22EDfUktAHHz95Yu9hsKR1Kz+I7mG5mdI4CRmOy1pNMTJ6/
 lplVCqNArbM8Jf/bD4SGENALBYfA3TN2IyMUZLSnsY1i3iIkQwk+G44eOOvRMOWjDISp
 HonpJQ3lRqZsMA5AzS5wSZ0USyfco97qJ5lhhQJm2w7gsd1VBy3awB/zPL22GrpB7FJr
 8lDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=25eLjj7S096UhlQv84j+y5ZsIz1F9KN7hX8cPXIiaYA=;
 b=ggjMGl7l2XnMee68m5/HY1tbXzhQdFfWee/AQr6DTgfNdj8ITmDmswLxbweTk3JTcS
 idfrRafGNhCGoYpz/gP2/RilczHNytbFKqxY+Cq/vCYn2MGApNH/YKbfsCHD9hsMYE00
 FkspZLXdQEF2ZYQmCSRVjHlM0N0s5+tJQdGDjQhGzFhMmUioozTf8y2QbNr5+eKBMi5G
 dPUHMNSoO9nsOL9v010rVpE//L/o6Es2S0bjKLWHyX5vRlJfnIe5gV6smqGdZHiFJime
 MNYEdH/HmIQrv/xnG1X8Ju7e9Eh9zVye+4sJa4aqNx1nxe7NU53GBRN8vdEFbdld8lCr
 ZBVw==
X-Gm-Message-State: AOAM532/yTFHE5e3UaF4umYnsBORlvgwNY4VGkdtIRmGCK4A2L2/K1uo
 uRN3QM8gi6GwprgP3mZUpSRvNJLJ3cCVJoy1kHoQQrdXDtA44U9vi6bSSB5AjRkhZ5g+fsd5tJu
 MxrrtXeALM0WDZn03ufgWFXbmPUae9bDfc+8aurdQ3UfDCIp/SWJLOsoWIs3Fz7GZl7g=
X-Google-Smtp-Source: ABdhPJyTaPc1iTgeWbqlhkYbN2AuKF/xf0Z1BKI6rgM6DA5R+mBinWpvIBC9He9rng/3K6DLqjd+qp1oBg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ac8:7955:: with SMTP id
 r21mr12500188qtt.6.1633708723038; 
 Fri, 08 Oct 2021 08:58:43 -0700 (PDT)
Date: Fri,  8 Oct 2021 16:58:25 +0100
In-Reply-To: <20211008155832.1415010-1-tabba@google.com>
Message-Id: <20211008155832.1415010-5-tabba@google.com>
Mime-Version: 1.0
References: <20211008155832.1415010-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v7 04/11] KVM: arm64: Pass struct kvm to per-EC handlers
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

We need struct kvm to check for protected VMs to be able to pick
the right handlers for them in subsequent patches.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 4 ++--
 arch/arm64/kvm/hyp/nvhe/switch.c        | 2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 1e4177322be7..481399bf9b94 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -403,7 +403,7 @@ static bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 typedef bool (*exit_handler_fn)(struct kvm_vcpu *, u64 *);
 
-static const exit_handler_fn *kvm_get_exit_handler_array(void);
+static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm);
 
 /*
  * Allow the hypervisor to handle the exit with an exit handler if it has one.
@@ -413,7 +413,7 @@ static const exit_handler_fn *kvm_get_exit_handler_array(void);
  */
 static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	const exit_handler_fn *handlers = kvm_get_exit_handler_array();
+	const exit_handler_fn *handlers = kvm_get_exit_handler_array(kern_hyp_va(vcpu->kvm));
 	exit_handler_fn fn;
 
 	fn = handlers[kvm_vcpu_trap_get_class(vcpu)];
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 4f3992a1aabd..8c9a0464be00 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -169,7 +169,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
-static const exit_handler_fn *kvm_get_exit_handler_array(void)
+static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 {
 	return hyp_exit_handlers;
 }
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 9aedc8afc8b9..f6fb97accf65 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -107,7 +107,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
-static const exit_handler_fn *kvm_get_exit_handler_array(void)
+static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 {
 	return hyp_exit_handlers;
 }
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
