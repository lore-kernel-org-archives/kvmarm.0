Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 072EAC433F5
	for <kvmarm@archiver.kernel.org>; Sat,  9 Apr 2022 18:46:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A86154B164;
	Sat,  9 Apr 2022 14:46:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ND7iL9IidnJI; Sat,  9 Apr 2022 14:46:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A2724B1D0;
	Sat,  9 Apr 2022 14:46:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E7DF49E44
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id waxbr9QjcIVi for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Apr 2022 14:46:04 -0400 (EDT)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11D1E4B131
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:03 -0400 (EDT)
Received: by mail-io1-f73.google.com with SMTP id
 g16-20020a05660226d000b00638d8e1828bso7622684ioo.13
 for <kvmarm@lists.cs.columbia.edu>; Sat, 09 Apr 2022 11:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Jf/XMEAggTsJuRalDXg2pQgOXNV7XNpBSuo5Apmz4Aw=;
 b=lEIcMr9UB+V2bpTOF8EQ+5KiBkTiHljW9KBJ+syKK2UZL9ii5LwlJjVuKAfSz5WeEG
 kyawmh0g5aofmsREkqHPn5huvgnhS47w8v/nDJIZU7+UvbvTIEORc5l8e/uSAP0yM9LH
 9KGVzOzulx7xyqxGFVVfp1C0c2XLLoGP/dsFCHDZ13QpYaNa3O5D9pYCW6lII1Tzge6l
 0SJ2qoTARMT3w3UI+r//DlEGmrsEW24wtzkoL/NQlMy/qJhwCLI0KaMghN6iLFSJY4Hl
 XnuVNhxOslVqYyJFhVNNKz8Mdrlp1qsQlEL/+6IiF3YirJBoNhkFz0U+lFdcxA7RBOJM
 0BLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Jf/XMEAggTsJuRalDXg2pQgOXNV7XNpBSuo5Apmz4Aw=;
 b=XUut6ueglRFm9UDVkKMQ2+nFfDR4T5LXJMuSC2GRG8t9IrppyoTFXt7xusvDHNisRY
 byCbpdvO3pJK7vhIehA5WKf7yE3H7HrJkJMwZ4rKArUbJVJFiaUY6AzrFZOX3BdftVaF
 qkbUXdtnDFzKJN+69iSb+fLGD8meoMtAveRgMfAomfA+6eYJc/jXJRS5Y1os9EfQTFxF
 sg7TTCUdQwSdpH2KOOGfcKG9fHr12jtEZjhyz3mJaNBhul3vCEw4156tLd4zmc6jvXsX
 Ev4tzcnduWmuZfXDOtcKPs28MqYZVcoNCpo3EDySmAL93keWuTQx6XIUtVsXH2sM7ZTg
 jKZw==
X-Gm-Message-State: AOAM533cJqvM4QqXlM7WtoV+mEqGmuvb/dRDCWu1P/Bb+8YjVtizpgfP
 bw5vfX3E1cD5Hs1/WhG7QMZRpCDpdmHQNIOJ5w7nPdk9PARuR7JKVFsqbVex06NzmjQpCFzItT0
 hJJwM4iLyxFn5zZkhiFc/QeUB0ZWqZeArRW+sNTPUf2PdrIhUfSBl3CSGQ2S3rB7Wb+j1qg==
X-Google-Smtp-Source: ABdhPJzJYn0CBfHqpbPKvsa8E7anxVCn5cEcl/xGZyo6ANeP6L2odlV4tB+CsnkIAte6yP8lp/XGUTRqlN8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:160d:b0:2c9:eef2:3a28
 with SMTP id
 t13-20020a056e02160d00b002c9eef23a28mr10295558ilu.306.1649529963316; Sat, 09
 Apr 2022 11:46:03 -0700 (PDT)
Date: Sat,  9 Apr 2022 18:45:40 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-5-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 04/13] KVM: arm64: Rename the KVM_REQ_SLEEP handler
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
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
