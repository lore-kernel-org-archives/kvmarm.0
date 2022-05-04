Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44533C4332F
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 03:25:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD7EC4B0DE;
	Tue,  3 May 2022 23:25:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i+0ukwfA8CXs; Tue,  3 May 2022 23:25:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E68AB4B1E0;
	Tue,  3 May 2022 23:25:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55EA64B0DE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:25:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OeTaETz2T4LA for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 23:25:02 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 75DC24B216
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:25:01 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 16-20020a630010000000b003c5e4be54b2so107874pga.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 20:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=zKCKCgAwM5oT8CgO5VNyRlj8I6pySWAhtN3tpf4n6dA=;
 b=ZM4FeKDUCZJiRyb6P789sMyqQSdZxP9XlE+XolrTRJung6jURrvaZ4TkCOnYGXplWq
 pivLdmaf4E5Z3zW+JY2SABmk/EOjm8hMWmuvKJVfiiGdB7KLHJDAJtHrlmN86QnZTqaz
 l0GNTroDwFS/uemQ9HeUoMAESGig2H42S+rLP9tOzEabemDBnqW9mEDfxrIqb6gDCu4Z
 0P0BsGmF0zmkiOpJVOM8fR6uaDViEBbGGd7tcr/zne9m8oLreGewDVc/ADcEmTvP3EO5
 hSXxOqRot+NCfGhNbQk0PT1eMb8gEXcXn1nt7AWnFAzDhdTznxulALBdDtim9UytX31t
 6YQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=zKCKCgAwM5oT8CgO5VNyRlj8I6pySWAhtN3tpf4n6dA=;
 b=M3P//ilfifyFjbIQPMAPQFBZ+q3RFyFwdaVShQeITWXj82OklR9Wec9FFFHamdvS1B
 +GmzG8U64Sf+GDUoXM2ATU8emkcDmNMg9OsGdu6GXbu1Ov0NYS59V41IA1cUL7KYpgGb
 garjzPBR9zsH+dcEpLrrDZn4/NBKocc9lAdI1OabHPfEziuFJGEO7j/euA2VoGm7i8Dy
 6q0ks1uMlofjcl9Ys5C++FycStqq84R31gqQB+xVYRI60ZnqniUoEA9glO7Y4n9ZRMW5
 j8+ldvhUzxTg7Wc13o37xqpZQsEcG80eKl3jiWVQ9lqeDyymlw+VlYVmC8sRVEkTwo55
 nqnQ==
X-Gm-Message-State: AOAM531z+aFe6VRf92rz0Dg0kPuKh+cZ6ORaZX2xvkRJFPhdgSXhApQA
 5ntJBB/6jecFx3PlRZmt7eCXdjmeqNlQBxUvbXyrdAsbC9UMzkJA9fMUUAZg0l1mtIRH5szRJd0
 HvPs8RUTCd2sGg3x3FQRv090Gb6DZMGdUMsF+vGfOT3ua2lQBN/IUC4NwQtfsHx2YU5xeRQ==
X-Google-Smtp-Source: ABdhPJzP/+HQx4zfHUjvoSoNur8GO2K6JD7rMAYer4k1x860wsfHvr/21vl0vtL9uuPVV77+Bqvb3zMQemE=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a05:6a00:1312:b0:4e1:58c4:ddfd with SMTP id
 j18-20020a056a00131200b004e158c4ddfdmr19149872pfu.65.1651634700423; Tue, 03
 May 2022 20:25:00 -0700 (PDT)
Date: Wed,  4 May 2022 03:24:38 +0000
In-Reply-To: <20220504032446.4133305-1-oupton@google.com>
Message-Id: <20220504032446.4133305-5-oupton@google.com>
Mime-Version: 1.0
References: <20220504032446.4133305-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 04/12] KVM: arm64: Rename the KVM_REQ_SLEEP handler
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
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
index 29e107457c4d..77b8b870c0fc 100644
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
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
