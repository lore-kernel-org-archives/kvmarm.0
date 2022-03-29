Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39AE7C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 29 Mar 2022 01:13:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7BE24B1AF;
	Mon, 28 Mar 2022 21:13:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B-iRmmguuUnv; Mon, 28 Mar 2022 21:13:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78CFA4B1E7;
	Mon, 28 Mar 2022 21:13:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5BAD4B0B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 21:13:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0GGy730tY09T for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Mar 2022 21:13:12 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A5B234B159
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 21:13:12 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 m16-20020a928710000000b002c7be7653d1so8791973ild.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 18:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=jCZIg6oJ3kZxDitZcGMrdotQowBtH5W4mOx7XkPi7gU=;
 b=Rpxf+SKm7n/b4t3VELmOnIJrHiHu9/K+DxCrwRHVjDQj/uWXB71UY5WiD+Umx35Mrh
 qqQFiRV5kP7+fawlWj5HwEmzUjLavw9Yh35YkfGjLNOGttMBCIlL+XYWNjfWLaVWPK0s
 ziJksz3JbOiT28svnSSLBmBkKTLPFtvfWtJ+43pksOYA3zJu9hZMkMmaykbQR76+amaz
 f5+1YpQtLu08mKpkLlMfqrsdCD6eWO+dyr1se94TRSVdOZ7YLmZKeMGkdOv+G80CU/Lw
 VrwB9vhG4zghqgtr0CFB9wp/a9W3ETkNQWTk+eZLKkdbifoX7UXvhdZqWOszhizqTj8K
 Mdog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=jCZIg6oJ3kZxDitZcGMrdotQowBtH5W4mOx7XkPi7gU=;
 b=7zBdAVFMqvffPcMBWsdbCylQAxbWDlqV53IkB1EWo9cmEytqRzbExfHQrxe5KceMfY
 z5mfIxDHgZCbAwSQW53ScAxGqMr67lMOozRZJfkhG/6tL9XTI2rQHAhjEeDamldA9hys
 Gj0gUeROo/EC7mxDW2fjbBQWfO5kRI61h0u+913eTpag6BHzChAxt3Xwhj6gNLC0xYYA
 JGbTxwaN1ghOU61gVTASo62f6/4KNPmIQFu0884FkmKoC4gYfEqbhRpNetRHF7aPectD
 ai9D4vSRhc56W1MiN6OJ7Pr/N8l45z6t1p8Y5cqjeuCn9yWcEsDafTysQRk19nXPZMhV
 6ulw==
X-Gm-Message-State: AOAM530pA6JTodsxUX7HBhg66hKGZefd8+V6bXPzpY2FjajZVqwupJGu
 nA6+KTZLWfqz0VLqL5AQR+htNycDQW/Ic4MukHWla6fV1L5EXtJ/fVmxB78Xr3Pf9o0SM49bRey
 qoWcBLk8ZqClyyWZkv07KjspTpSH639dWMIHxoAQAI5wZgfdxD/6FmiCla6QtucAB8b10Kw==
X-Google-Smtp-Source: ABdhPJzMiIPF9aog40Q6g1bfGI90vVfRdEF42d1RPWK7+pYd+Ke9O4ykn+bVKN5P0qkUUR1AB+e5+faEfoA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:e60a:0:b0:646:3e9e:172f with
 SMTP id
 g10-20020a6be60a000000b006463e9e172fmr7910028ioh.1.1648516392132; Mon, 28 Mar
 2022 18:13:12 -0700 (PDT)
Date: Tue, 29 Mar 2022 01:13:01 +0000
In-Reply-To: <20220329011301.1166265-1-oupton@google.com>
Message-Id: <20220329011301.1166265-4-oupton@google.com>
Mime-Version: 1.0
References: <20220329011301.1166265-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH 3/3] KVM: arm64: Start trapping ID registers for 32 bit guests
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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
---
 arch/arm64/include/asm/kvm_emulate.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d62405ce3e6d..fe32b4c8b35b 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -75,14 +75,6 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
 
-	/*
-	 * TID3: trap feature register accesses that we virtualise.
-	 * For now this is conditional, since no AArch32 feature regs
-	 * are currently virtualised.
-	 */
-	if (!vcpu_el1_is_32bit(vcpu))
-		vcpu->arch.hcr_el2 |= HCR_TID3;
-
 	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
 	    vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 |= HCR_TID2;
-- 
2.35.1.1021.g381101b075-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
