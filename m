Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99ACFC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  3 May 2022 06:02:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55F464B215;
	Tue,  3 May 2022 02:02:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cu0Jcr3b541j; Tue,  3 May 2022 02:02:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FC0E4B216;
	Tue,  3 May 2022 02:02:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 757374B296
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 02:02:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ykZOI1ZR4ucz for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 02:02:18 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6EFC94B218
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 02:02:17 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 s185-20020a632cc2000000b003c18e076a2bso6002759pgs.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 23:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=szYmrqPYm2+NRRnt6PLMcdW9lpIQNg8jUIBDaOx8F6c=;
 b=V0Ff2JHN/1ixKrZ4eXGKn+a1zJeLIYlGYLahoOCZr8dElnZtvoleLd1AUljKq2Go9d
 rH4xnD+d0QINZ8krn4kU/t4Al1gAUsxZeaOoqF4H59F5jNmYCo6PfQ/j996ln7nA7iu8
 pcY1n42K41AdqbRiqGlMilri6fmVwnRuNxSSChGk4LLAFC+zWHSxjezK72kFqeIKYTCR
 qEjEjFBkaHLm853u2Nu+XOemUA5hy7bvcgJzwKdVriGETjug41pMjNR07Ya9twKoO51H
 4xtYqUYCWtZr+UavK1Se7ZAlRTGAHQ3RkVEeWKw8se1PuhyA07Pf+d7OgRKMC7GNtttW
 Ntug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=szYmrqPYm2+NRRnt6PLMcdW9lpIQNg8jUIBDaOx8F6c=;
 b=67pMZ8p5tC0B2sFfgsZj+Cvrd+10sZ0d69WiCoOkKKVTqXVL6PYrB63nhQHHf8prez
 tkLZ7/B6hPADbLi5P0j5ZbPZHx6uFh+x1SYify/3iR3CSotmex/yPaCGzupU2LWC2bDb
 v6iSYFgWLyMOdXbFxquwZAUlPNC7xNWJNkQ1OMqlP/ck+YvapkJx6k9B20RZUG+7K+mW
 fIrj0QlMxYScqBQ9MHosJ5aCey4r7X1YjQkVwIBlV8Amp4YXYbU/qpLywouHCy8nRw9d
 a4lrQhgcZLt4iF4qVKu5YHXt6lcdF/bzwOG1qZvoznoY4mQSylxD4EcvZKUqmfFERe7Z
 dauA==
X-Gm-Message-State: AOAM533CuFjKlyvyY7PJ5Bx5ErVICyCQAeS9HFqSDoPY8KhgCiZlHpO6
 3fXDEhaBIrT6pHxBFVpWWy8q5GFy/D3XBId8k9qQWhbSNrKK2bUF3IKCXeXCrV9lEdVdbvNeCce
 JK90vZwOSdFDSrgj23tiHfKgxjJk/Kxi6HM/R/J7/RAMqvcuybdocWN6BQWp05zlUU0waiA==
X-Google-Smtp-Source: ABdhPJzb2TkawwG87rw4pGRJ8PwWuWWZ0LiwEjnIjgPb3w5iW4PoKAlHdEQUIZdxC52BhyeVWcl2kMFzdMo=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a05:6a00:1496:b0:50d:9f76:ec7b with SMTP id
 v22-20020a056a00149600b0050d9f76ec7bmr14700869pfu.58.1651557736423; Mon, 02
 May 2022 23:02:16 -0700 (PDT)
Date: Tue,  3 May 2022 06:02:03 +0000
In-Reply-To: <20220503060205.2823727-1-oupton@google.com>
Message-Id: <20220503060205.2823727-6-oupton@google.com>
Mime-Version: 1.0
References: <20220503060205.2823727-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4 5/7] KVM: arm64: Start trapping ID registers for 32 bit
 guests
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

To date KVM has not trapped ID register accesses from AArch32, meaning
that guests get an unconstrained view of what hardware supports. This
can be a serious problem because we try to base the guest's feature
registers on values that are safe system-wide. Furthermore, KVM does not
implement the latest ISA in the PMU and Debug architecture, so we
constrain these fields to supported values.

Since KVM now correctly handles CP15 and CP10 register traps, we no
longer need to clear HCR_EL2.TID3 for 32 bit guests and will instead
emulate reads with their safe values.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_arm.h     | 3 ++-
 arch/arm64/include/asm/kvm_emulate.h | 7 -------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1767ded83888..b5de102928d8 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -80,11 +80,12 @@
  * FMO:		Override CPSR.F and enable signaling with VF
  * SWIO:	Turn set/way invalidates into set/way clean+invalidate
  * PTW:		Take a stage2 fault if a stage1 walk steps in device memory
+ * TID3:	Trap EL1 reads of group 3 ID registers
  */
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
 			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
-			 HCR_FMO | HCR_IMO | HCR_PTW )
+			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3 )
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
 #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f71358271b71..07812680fcaf 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -87,13 +87,6 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 
 	if (vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
-	else
-		/*
-		 * TID3: trap feature register accesses that we virtualise.
-		 * For now this is conditional, since no AArch32 feature regs
-		 * are currently virtualised.
-		 */
-		vcpu->arch.hcr_el2 |= HCR_TID3;
 
 	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
 	    vcpu_el1_is_32bit(vcpu))
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
