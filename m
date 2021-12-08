Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23526C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 19:33:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD0E34B150;
	Wed,  8 Dec 2021 14:33:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XKhxXF4GTiE3; Wed,  8 Dec 2021 14:33:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17D794B137;
	Wed,  8 Dec 2021 14:33:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EFCA4B10E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 14:33:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KsHKY7CLDyyn for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 14:33:02 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B34874B10B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 14:33:02 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id
 r2-20020adfe682000000b00198af042b0dso654458wrm.23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Dec 2021 11:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Q0YfZNgWo6o4+Fu8dkShTOfK6wostrwH35kX4SjCrg4=;
 b=aRG6t0Zr2tDK8U7C6QtNIaqp61Yclsls13jT727Opn01zK4I2hLCeRLLDTx+iKkOVr
 HMTSG/FAMDfrHB/OcrfqoS4O5gPQLPZQtBjLejUvevkMyj3X6y1FwWkBIawkyHpt9Mkr
 Lw3gHyan/bLkw/NhJ8FoZmxqjjLTj3ux7r5I1kCfiMuR3n23nEnPLz7MAN5isvTQT4I9
 CP3yfmo+tqm2LXTu9fuRXwfuAQsYbB5D8P9h3QMp1M26tExUCZuLtSKWALZ1LBMCnS5z
 z5ZNmF+FXOL9j+oNnuT6NqXoCFAuFHSs5N0Kl+UB7RO6J6Ul17iMr20gTbPEOkfbnUJ9
 6Qkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Q0YfZNgWo6o4+Fu8dkShTOfK6wostrwH35kX4SjCrg4=;
 b=Ojx8IXVmErEMr5SbrlwBjcG3YDaeMDEz/BIFK0eeiYQrybTBiXQuqZ3jQT5/aD/e5N
 Bsc7gdCQS2w1Jkbkve+2ZmWUgYeX8488j80QKo/HytwFZYZvlnoU3SOOo6yJkEGaRJgP
 txsVo6MymFrgW9Q1qeCGctaR3PFFZPFz7Jg+bk4qtccRduw9XPOtshm/DrCUyPojSrCt
 XEyUmWMOqTGTDZDe6P+NnucfTNhbw2mrBKuosMHwi2JxMKwdf/rvi5OqNUp7wZ7LUJLT
 /kj94lFbnP3ODij3J3RDdpDfg2Ok5OY+S1Su1li8I7nDiZ7xdRQ7/6+523bUN5VOc+PW
 tOtw==
X-Gm-Message-State: AOAM532eE0fc8lyckwK2CetvrNndjsimM+7Id9Q5kxqgohS88r9nqZan
 WMsflibkYjvKh/6zXyQNgXgpDQjHFINhTfcIFxHljX4HE0yolMtDevupy90C3OwAqLtYYmYMgKU
 2p0fDlsVQbCq5W8I41Ck67d8hNt4ADUp6OtdQKw/kQz0f2zeoGSdeuXm71T78HAuCsG4=
X-Google-Smtp-Source: ABdhPJwpASZMPMew9uRaM69Wni+PtSX9DDd5dHsseQ8rzfrW67TrwXhc+Nd3atqYLsWPzyZwW5AHsryCSw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:4e91:: with SMTP id
 f17mr749715wmq.195.1638991981715; Wed, 08 Dec 2021 11:33:01 -0800 (PST)
Date: Wed,  8 Dec 2021 19:32:56 +0000
In-Reply-To: <20211208193257.667613-1-tabba@google.com>
Message-Id: <20211208193257.667613-2-tabba@google.com>
Mime-Version: 1.0
References: <20211208193257.667613-1-tabba@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 1/2] KVM: arm64: Fix comment for kvm_reset_vcpu()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, will@kernel.org
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

The comment for kvm_reset_vcpu() refers to the sysreg table as
being the table above, probably because of the code extracted at
commit f4672752c321ea36 ("arm64: KVM: virtual CPU reset").

Fix the comment to remove the potentially confusing reference.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/reset.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 426bd7fbc3fd..2bbfeadeb6ae 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -193,10 +193,9 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
  * kvm_reset_vcpu - sets core registers and sys_regs to reset value
  * @vcpu: The VCPU pointer
  *
- * This function finds the right table above and sets the registers on
- * the virtual CPU struct to their architecturally defined reset
- * values, except for registers whose reset is deferred until
- * kvm_arm_vcpu_finalize().
+ * This function sets the registers on the virtual CPU struct to their
+ * architecturally defined reset values, except for registers whose reset is
+ * deferred until kvm_arm_vcpu_finalize().
  *
  * Note: This function can be called from two paths: The KVM_ARM_VCPU_INIT
  * ioctl or as part of handling a request issued by another VCPU in the PSCI
-- 
2.34.1.400.ga245620fadb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
