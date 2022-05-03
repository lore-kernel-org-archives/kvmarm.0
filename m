Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A55C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  3 May 2022 06:02:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C783E4B1CB;
	Tue,  3 May 2022 02:02:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9kBDbzTv10FX; Tue,  3 May 2022 02:02:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD9804B20A;
	Tue,  3 May 2022 02:02:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 577434B17B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 02:02:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tiWU4wtg4Gp2 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 02:02:11 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 392D84B1A9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 02:02:11 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 64-20020a630843000000b0039d909676d5so7974938pgi.16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 23:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=t8sqG9N3bDSFcIV4nihap+Y9twMBMAx1j91yk1oqLR8=;
 b=fDfjA+1/0+LcqwDGcxHKZd8ionRfBRzNlkOTN7GRUfD8g3bhg8pDQ5uyFL8oq7q6Na
 EoyIu/iVkG0pujF0nu4inS7G6gI1qyWrLNt7VR+u977NM57eXHKDfc+HHstuIZ/YOlTO
 GDC+ESrL/7lSn7TicirueSi7FRTx9SrqRNpNOXTXE81cHJxUvheeDwap8zbAEewVk7Xw
 S2PH5S+5ZjTC3WxCod8/AhC56Ae2bRRJVtADxwVKVzmvIc3DU+qMsrZBlBycKcX9nxTb
 E7GoavZ31OG/uySeQKncbOYShr/2vP/MMsRpnPaocTB96ijBYhHMvKQGff29TkVMYTkX
 vPuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=t8sqG9N3bDSFcIV4nihap+Y9twMBMAx1j91yk1oqLR8=;
 b=Vm4dmKlRLyPbP6TXmPp3MWTIlV7MR5688IU/WNdbg5xx7UnOL1pjLVYBmj3bK2gKDP
 Yyhqb50aGLeMiSRK3HzgvAVRjZrvPOw53PvQ1KKAYJxvH9lxhZFexOWX2re64Ld+jCTY
 w59XGSFAB5ZqAxCF2bHFpvj27ZSe4iT5+9/sLmZ1fmxqkDkyY/0oTUlJTw/zd+za3R8a
 DLLUaPyKH+J+8hUsIk2QXDBieqbuSa0DQRVZ2yJNwfYb2NDvdt04F/r52KKIaHoC1lSN
 p4un56s9KCy2+9O03oUTiSx5QW3w5qZSFHBjfxr4TriLqcVym1JIhdNMhLkJptkLjze1
 xq4A==
X-Gm-Message-State: AOAM530mdr0aBtcmIvL7E+6oJhWJQst6yvFPenyId5bz1an8b3cHhEe6
 hnQsiWcDlTeTO2bRTMLsfbbtLjbBIXCtmNul1wwmhl8/28LKoNYf1uDrQZTZqQoIlSB7gJOlcVA
 hZo9I2/D6iHg9I1PzGJaInKW/npW3XgCMmTKckrN0YynszQekpFz/m0OheX11A+wceDS9Fw==
X-Google-Smtp-Source: ABdhPJz/UUNAbn5Z/ZnAPcvJcY0XAWJIASeAIpwVIjQ/WB9rW/6OA1St42zCrG6ilBD1/lLbFfGTrlWn5xg=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a63:6c42:0:b0:3ab:7c9c:1faf with SMTP id
 h63-20020a636c42000000b003ab7c9c1fafmr12960528pgc.518.1651557730161; Mon, 02
 May 2022 23:02:10 -0700 (PDT)
Date: Tue,  3 May 2022 06:01:59 +0000
In-Reply-To: <20220503060205.2823727-1-oupton@google.com>
Message-Id: <20220503060205.2823727-2-oupton@google.com>
Mime-Version: 1.0
References: <20220503060205.2823727-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4 1/7] KVM: arm64: Return a bool from emulate_cp()
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

KVM indicates success/failure in several ways, but generally an integer
is used when conditionally bouncing to userspace is involved. That is
not the case from emulate_cp(); just use a bool instead.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/sys_regs.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7b45c040cc27..36895c163eae 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2246,27 +2246,27 @@ static void perform_access(struct kvm_vcpu *vcpu,
  * @table: array of trap descriptors
  * @num: size of the trap descriptor array
  *
- * Return 0 if the access has been handled, and -1 if not.
+ * Return true if the access has been handled, false if not.
  */
-static int emulate_cp(struct kvm_vcpu *vcpu,
-		      struct sys_reg_params *params,
-		      const struct sys_reg_desc *table,
-		      size_t num)
+static bool emulate_cp(struct kvm_vcpu *vcpu,
+		       struct sys_reg_params *params,
+		       const struct sys_reg_desc *table,
+		       size_t num)
 {
 	const struct sys_reg_desc *r;
 
 	if (!table)
-		return -1;	/* Not handled */
+		return false;	/* Not handled */
 
 	r = find_reg(params, table, num);
 
 	if (r) {
 		perform_access(vcpu, params, r);
-		return 0;
+		return true;
 	}
 
 	/* Not handled */
-	return -1;
+	return false;
 }
 
 static void unhandled_cp_access(struct kvm_vcpu *vcpu,
@@ -2330,7 +2330,7 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 	 * potential register operation in the case of a read and return
 	 * with success.
 	 */
-	if (!emulate_cp(vcpu, &params, global, nr_global)) {
+	if (emulate_cp(vcpu, &params, global, nr_global)) {
 		/* Split up the value between registers for the read side */
 		if (!params.is_write) {
 			vcpu_set_reg(vcpu, Rt, lower_32_bits(params.regval));
@@ -2365,7 +2365,7 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 	params.Op1 = (esr >> 14) & 0x7;
 	params.Op2 = (esr >> 17) & 0x7;
 
-	if (!emulate_cp(vcpu, &params, global, nr_global)) {
+	if (emulate_cp(vcpu, &params, global, nr_global)) {
 		if (!params.is_write)
 			vcpu_set_reg(vcpu, Rt, params.regval);
 		return 1;
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
