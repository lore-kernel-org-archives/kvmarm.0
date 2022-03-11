Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C2AC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:41:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69A7B40FAA;
	Fri, 11 Mar 2022 12:41:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qEENFcd9pFmb; Fri, 11 Mar 2022 12:41:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 276D8408B3;
	Fri, 11 Mar 2022 12:41:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC692408B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AsdxcW-ww3v0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:41:07 -0500 (EST)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E9F749EBE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:07 -0500 (EST)
Received: by mail-il1-f201.google.com with SMTP id
 m17-20020a923f11000000b002c10e8f4c44so5990078ila.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:41:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=7ZRBkS4U0RFhMHj2rsuxMbzaij5n0dyzv68dBdi/1V4=;
 b=agb3tdzKqOaqoSpS5U/p593tiHNWqqZJpCJfTx6gflLYyYPaiUx9HO1yB+3F8H6FmE
 cVmT3Q3SIyKv2ALdwrHb71MbMAovi69YILYjVnI8iH2bT94dX9eYTXj922gCmpI9Bz4G
 0ICO77FbsL3yb1LVQra6lGmL0ybIgUa5vLxMGVJUJGMWGQplz1gVTXf7+h9teAs/s7ly
 6VS2GxT/OsB7vGqrMOHEmHMZq2e9MRHJ64j7+VwGzT9A3Ct64Kb6KQFimn57Jg1ISLuX
 3I07mWDcVavQz4BZFLNYaY4e67ThPDC2U7U3teJaD5KtlB/2Wu3f/3S8JFbaA0GrCvh3
 sLQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=7ZRBkS4U0RFhMHj2rsuxMbzaij5n0dyzv68dBdi/1V4=;
 b=BBSz+IapA8tP/Rx+QsDmhLeup9gHnOkD7gsETVBjuuAhay40RZuARxZyctt2hCMojk
 o4YSv4FYMH/ZIv4DetyosQnKRqW80JnGaA+/YPmS8akuwTxMr9x8iT5D3mMPNXY437lF
 maGOvEdov7twahyhpCH5P0dYQa2/7gej9iZxdxjyVndHZU7kyOwxmI2yZwnEXqyXCCHp
 1BkCcAnOZ1p5GCz5Ut9+0I94TQ4es/kSXOmOS0UuRaMHrH/PO64xsH3LGL6aTpIPuBhk
 +UYK/3OmobWkF6+zqCbmL+Aj6t+T64dHSa5EEqWQJZAcsUY/FKITj7+OtGscFiLHZH7y
 Aa5g==
X-Gm-Message-State: AOAM531YlPD53pck5lLRATHHTKZdjXwvH8FVkx4ebEnFnDyOv9NDK/26
 qVZdJXEOlyUo6weJXyuDS3vk1a5mBmlSreuG3wcTU0NvGH0K2tlq3pPHAZFOFuOO8aCohcMKJlT
 q8Vd6eBpg7YabyUAMNpxfUlKndf0e/XRgYBWt2RKiXtFXHNbgcFyPlFILYZoZVcnYN861GQ==
X-Google-Smtp-Source: ABdhPJw9BiYukm5oFkfLFDSfcoF0YG+SBFyjRPDOEtEfu56g5hciDXgPevhVFTjypFLBz3WPqlZZ86y7cJg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5e:a80a:0:b0:645:b477:bc23 with
 SMTP id
 c10-20020a5ea80a000000b00645b477bc23mr8739969ioa.191.1647020467117; Fri, 11
 Mar 2022 09:41:07 -0800 (PST)
Date: Fri, 11 Mar 2022 17:39:52 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-7-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 06/15] KVM: arm64: Rename the KVM_REQ_SLEEP handler
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
 pshier@google.com, kvm-riscv@lists.infradead.org, atishp@atishpatra.org,
 pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com
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
index 3918d078fc4d..7c297ddc8177 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -594,7 +594,7 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 	}
 }
 
-static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_sleep(struct kvm_vcpu *vcpu)
 {
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
@@ -652,7 +652,7 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
-			vcpu_req_sleep(vcpu);
+			kvm_vcpu_sleep(vcpu);
 
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_reset_vcpu(vcpu);
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
