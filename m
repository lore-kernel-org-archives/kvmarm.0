Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48740C6FA8A
	for <kvmarm@archiver.kernel.org>; Tue, 13 Sep 2022 09:45:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8EEE4BC3F;
	Tue, 13 Sep 2022 05:45:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oTNy4dXweqp9; Tue, 13 Sep 2022 05:45:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B61594BBB6;
	Tue, 13 Sep 2022 05:45:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB0C54BBE1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 05:45:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0u-D4kPrCsn7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2022 05:45:01 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 787AD4BBB2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 05:45:01 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663062300;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=V+RWoL1wzjJGeI+4GkZqTh7LiWlA393Xc2eG5qmGIME=;
 b=sGjZR6oSYqK+gKGoH63m+llr/Y7xpJkHl9Zwn4HsW9cW7OFGcBMEHSmWVo9jRLmo9qHSfm
 BsznyW9armHwNjAkAuDQ3Wf/0slYDzAEES0z+PHaFTTvFJwS5QaWftc1BZBZlsV+vmTs17
 jwqvytRaLTzTFaJgFPxpc1kpzSbLgdk=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: [PATCH v3 3/7] KVM: arm64: Drop raz parameter from read_id_reg()
Date: Tue, 13 Sep 2022 09:44:36 +0000
Message-Id: <20220913094441.3957645-4-oliver.upton@linux.dev>
In-Reply-To: <20220913094441.3957645-1-oliver.upton@linux.dev>
References: <20220913094441.3957645-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.cs.columbia.edu,
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

There is no longer a need for caller-specified RAZ visibility. Hoist the
call to sysreg_visible_as_raz() into read_id_reg() and drop the
parameter.

No functional change intended.

Suggested-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 26210f3a0b27..0e20a311ea20 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1063,13 +1063,12 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 }
 
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(const struct kvm_vcpu *vcpu,
-		struct sys_reg_desc const *r, bool raz)
+static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
 {
 	u32 id = reg_to_encoding(r);
 	u64 val;
 
-	if (raz)
+	if (sysreg_visible_as_raz(vcpu, r))
 		return 0;
 
 	val = read_sanitised_ftr_reg(id);
@@ -1157,12 +1156,10 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	bool raz = sysreg_visible_as_raz(vcpu, r);
-
 	if (p->is_write)
 		return write_to_read_only(vcpu, p, r);
 
-	p->regval = read_id_reg(vcpu, r, raz);
+	p->regval = read_id_reg(vcpu, r);
 	return true;
 }
 
@@ -1199,7 +1196,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	/* We can only differ with CSV[23], and anything else is an error */
-	val ^= read_id_reg(vcpu, rd, false);
+	val ^= read_id_reg(vcpu, rd);
 	val &= ~((0xFUL << ID_AA64PFR0_CSV2_SHIFT) |
 		 (0xFUL << ID_AA64PFR0_CSV3_SHIFT));
 	if (val)
@@ -1221,19 +1218,15 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 *val)
 {
-	bool raz = sysreg_visible_as_raz(vcpu, rd);
-
-	*val = read_id_reg(vcpu, rd, raz);
+	*val = read_id_reg(vcpu, rd);
 	return 0;
 }
 
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 val)
 {
-	bool raz = sysreg_visible_as_raz(vcpu, rd);
-
 	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(vcpu, rd, raz))
+	if (val != read_id_reg(vcpu, rd))
 		return -EINVAL;
 
 	return 0;
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
