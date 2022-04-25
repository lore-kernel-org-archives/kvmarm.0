Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 216B4C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 23:53:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F6274B10A;
	Mon, 25 Apr 2022 19:53:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SFor8Tg9sNbH; Mon, 25 Apr 2022 19:53:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0467A4B187;
	Mon, 25 Apr 2022 19:53:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C91049EC3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 19:53:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iV-17KhdpzlP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 19:53:47 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F10664B08E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 19:53:46 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 u9-20020a25b7c9000000b0064636cb9078so7116040ybj.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 16:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=7I/ymirdAiT7TDA2OEpHDGEYZgcTkJFO31W7cy5XbpM=;
 b=GIEXDRW1lPHYxJDlewu1cQeA6Q+QhOYQG/Xg8+PRoE5TU9K+EszCSi+GS/y1yYdqKQ
 k/hrOFfkpq5XjEnBTx1gg0IKP9CD+wqs+KYV8IBKykKdf6qgUHxeHd55YceasrVFn9mw
 o9HKcPVnYwI3o4aMI2OPjArD2rckzGSvUFmrO9xNvkgk8klD1nMq/kohI2CdazTjq5Jf
 Ak0UhNEI4w4AqZKNdd5wNvgAXTUDy724YE2e5d8zmzpUkKbcZxng8IF+DponlhaL7c8x
 LL6EDVRikFw7s5dE77bM9YkXLHYb5Nfbwh93Bes5BL+1D2/4yHIP4wXj4e8Sme3DIay7
 twfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=7I/ymirdAiT7TDA2OEpHDGEYZgcTkJFO31W7cy5XbpM=;
 b=Y+uJCmHxCpE1ZD/688hyUahaVL8szIiITe3BdqvoR7tXzIZYWRIkIiwOBFEBIQHuQe
 9ML+fy04vKrp8JGDqFpqwW0P8M1FV8EY5E+7lhJklg9YAmN+cZNd0xAAOYc1B4sBDfDy
 Kj/MjAUVn+O8G9xzXXkms5fJnQ/kfsPFi/81xbj9SoGl8DtW4BtCGQhpfLgM9KLbpG8g
 NUCsippxRO34NUeIu+hq6b6ch1q3gQm3K3ZB0YA2KsUNUmJjb4gvUajbWpsSdroHRIWx
 UNg9x0zSCZBbHvr35m/qKupMFW9MwbGtFlhv4S5SBLXUWiv9JRtPLA2VHY3FTGeP/8Sc
 Rzpw==
X-Gm-Message-State: AOAM532448qV9lqhSppDVA13K3CoWjQRWkkoN7sftBRRUU8H6UFf59o4
 RucBHiks66te57ujQKN0ug61bKSliA+PjCcgt/tBjaYolG6esAYiDxg1i5SvuinwdZuASE4itot
 7pANEmSbaa6yQSeIj/4F/aVHxKFWvrwDpTjf2XF9HGbNezIuudnMPAUVxYNHje8THx5Kf+g==
X-Google-Smtp-Source: ABdhPJyjGc04tDLhhnCLskCP5jrH+A6ez9JfIN9/o5bxHFb6wiRVScPynPJ1gA3GO95ctuwxRLPE7a7ohO0=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a25:240c:0:b0:645:d54e:830f with SMTP id
 k12-20020a25240c000000b00645d54e830fmr16918344ybk.34.1650930826367; Mon, 25
 Apr 2022 16:53:46 -0700 (PDT)
Date: Mon, 25 Apr 2022 23:53:38 +0000
In-Reply-To: <20220425235342.3210912-1-oupton@google.com>
Message-Id: <20220425235342.3210912-2-oupton@google.com>
Mime-Version: 1.0
References: <20220425235342.3210912-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v3 1/5] KVM: arm64: Return a bool from emulate_cp()
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
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
