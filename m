Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08BE1C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8C1C261267
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8C1C261267
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 417CA4B116;
	Thu, 23 Sep 2021 15:16:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 43S3EYOYxwBB; Thu, 23 Sep 2021 15:16:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87C414B11A;
	Thu, 23 Sep 2021 15:16:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B7F84B13A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zYe7tBuevuAI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 15:16:21 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3896B4B11A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:21 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 a23-20020a25ae17000000b005ad73346312so299290ybj.18
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 12:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=dkhhhARdJNItMKxiO8fcGRSgRnnWwiZ+q9GZvF1SajQ=;
 b=fSTmJxItQ0Esp6edjHZ8XsCfQWYHWKgn2MDQr6xhIU/ioCwoXCgLyZPcUWoOb7i8i7
 4X97ySbmn8RyA0zkhhXz1njQPPCykyZyalZLQqQsLLyUfNrazWj5Dr/dSCDZDipWFeOZ
 afxmhjQ8lo8oLO+HlThsMGn6g+hmC8AIP7jl/E0d/fAu91N/vJpQGLIcwRf31aCSFfMV
 M62AMOTGVsRa7mldVqkgUXLTCcXTgx6GLJxJyIn8jno3AmK6Ovp9nbjAzJNkxpXr7P4z
 VpoCpRzO1LByDRPW3pWWB8Iv1Z2XMpaXrJETCelkEsp9RdY4DYRFtPYrOjSQz+C1ZD16
 vZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=dkhhhARdJNItMKxiO8fcGRSgRnnWwiZ+q9GZvF1SajQ=;
 b=Hv0zCqY+XeZlNlGhTm8NaWtUZHDH9ZOGWzNhV/UxOxKin67w7YMVjtvpywgJKa3XWW
 vEZl1WB4HdIbBee5pHmMtlX8ScAHG13or9xFgig7Epmdow70N3ZZPLeXfBeS0XAafwRQ
 AwMLSsPVDJLT5ZzTtjbyD+EipoO9RCqd+3dX+tGIEj7ubXHnVn8YwYjHU7zoyQjJ7iew
 BG9/N93OL9r6LWn7tjoKeTdstquuEN7LgJWGNc2ohDFDWLxw8TzK6uxo1kS/uWyjJFhK
 rHFwEjlSkS4PAO65Ua6oZ7pagFYVHCy0LN7dIJWGQmh3YlzoZBI2kPkPGZCmRYKGELfg
 exrw==
X-Gm-Message-State: AOAM532NjFsrQI4pcIpsrp4a9ODdjvYufeHqegettuCIgPqDVXu8B71u
 jZ6D5wv50HfQgjcsSgYgNXH7D2NRZZVaixLZ8B9upEzv8iUYUL0G/qGFa6hj9y9hdLhxjrIGuyb
 JmM7uK5Plj5rhA0LSlhQatj/LZQ4cXU8hij/W8ptUrqjfm9u4z1wCmwHZfUkhTwhiwy96Yg==
X-Google-Smtp-Source: ABdhPJx9mCky5M8FDvxeXJD6cDUieD2bDPTUWqI3NhMeXKbuooMw9pu1tjzha9gnLbeS3TGZ0fVM66DuUw0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:61c8:: with SMTP id
 v191mr7593036ybb.472.1632424580561; 
 Thu, 23 Sep 2021 12:16:20 -0700 (PDT)
Date: Thu, 23 Sep 2021 19:16:03 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-5-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 04/11] KVM: arm64: Rename the KVM_REQ_SLEEP handler
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>
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
---
 arch/arm64/kvm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fe102cd2e518..3d4acd354f94 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -649,7 +649,7 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 	}
 }
 
-static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_sleep(struct kvm_vcpu *vcpu)
 {
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
@@ -679,7 +679,7 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
-			vcpu_req_sleep(vcpu);
+			kvm_vcpu_sleep(vcpu);
 
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_reset_vcpu(vcpu);
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
