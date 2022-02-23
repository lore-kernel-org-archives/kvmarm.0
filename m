Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 675E2C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 04:19:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 203C54C369;
	Tue, 22 Feb 2022 23:19:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RNYX7VCrMqCg; Tue, 22 Feb 2022 23:19:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A8C04C3CE;
	Tue, 22 Feb 2022 23:19:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B5004C3E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w-SYDpNFP8l1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 23:19:19 -0500 (EST)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17C2F4C3EF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:17 -0500 (EST)
Received: by mail-il1-f201.google.com with SMTP id
 k5-20020a926f05000000b002be190db91cso11818638ilc.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 20:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=JyyyRU0Fb1h464jAcK6L7YZrRrm3og/rpFqGL6PF6iw=;
 b=bte3DLwmCbFrLIy8MAHoqmeLXkr2nx9dpQc8pX1REmlId81Kfp2wHiRVIjVzU597f3
 OJWSrDNi3Ibv3zKu2v6y+t8f+8TChmx2PeacGOBDpz56PvyeY42pBs8N4oMUhiZ+3y0Y
 9eLuBdhmX9YJGsIMj8YwVy83BSBhATRf19xNZuME2TdDtoVgm5SZlLGzmTpsG6Qx2RIN
 1PLCmR7bwhfPh6iC1DqpcYs7VaAeB5THDDu/mgUX08myQcPsUd9su1YOy1GYITH97p0u
 iEjt2sPDhWbnmuecOuJ3UJYPZZL3ddmic9VW5o0gSZaGdnWBHz6CCIQTcxN1tJj1MK9+
 kLWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=JyyyRU0Fb1h464jAcK6L7YZrRrm3og/rpFqGL6PF6iw=;
 b=2CQIO+qHhbsBdXCtPa3TNUxKu6DMAHfIgiiCsDPVHWY1adHriQByjZynniJG0t8Ii8
 /XoTiX3RiabgXyyvMUsYBZcG6yz9jOkr8SlPN3ZhTYyzBMaugwSxCmqNqQCZiUB57uN7
 +ZzilnouMQc6Jl9GV5EeXgoPS4AQIhyFrjbc6eBm7QZsSQsCtCLaRM0d6BWA449THpy8
 DmT3SCggHjQ2+c7RA7siTj/LhVdBJeVr2tjlsbP+5aXkGKkz284hfv7m2UwbPJnataE4
 MJForQxCm8Hw8vGfuzlwEAQY3pn+NPNyyZ6d3Un+qL7p7ure0b6/I7za+j1zA610xgON
 1pNg==
X-Gm-Message-State: AOAM533IDYu/r2FUUQ3ouvbEfkmg62ck4BveRU0Zi9RDx/RtE3FNA28M
 IJP6KpCt4vqLjipdQYgFsvcgccLUDZZWD9WL9Uw2pdWCsg4hCXc/hyRKt+6+LS/e3peXvbbJPrU
 9jZJiyEmX9Ib/SNhqpI25rFFMCfcIcSoGjuVpHyAYjpDW8OejsiwjKmqxXU069G0wMx21Zw==
X-Google-Smtp-Source: ABdhPJwjmsCO0/IWwha83kfQibq2v271bQNKm/fd9EQafKh+WjR98I1C7Cjw6nAxPvE1KhM8csV18OawS1E=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:7c12:0:b0:2be:155d:13fd with
 SMTP id
 x18-20020a927c12000000b002be155d13fdmr22504603ilc.162.1645589956441; Tue, 22
 Feb 2022 20:19:16 -0800 (PST)
Date: Wed, 23 Feb 2022 04:18:32 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-8-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 07/19] KVM: arm64: Rename the KVM_REQ_SLEEP handler
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Atish Patra <atishp@atishpatra.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>
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

The naming of the kvm_req_sleep function is confusing: the function
itself sleeps the vCPU, it does not request such an event. Rename the
function to make its purpose more clear.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b4987b891f38..6af680675810 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -665,7 +665,7 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 	}
 }
 
-static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_sleep(struct kvm_vcpu *vcpu)
 {
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
@@ -723,7 +723,7 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
-			vcpu_req_sleep(vcpu);
+			kvm_vcpu_sleep(vcpu);
 
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_reset_vcpu(vcpu);
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
