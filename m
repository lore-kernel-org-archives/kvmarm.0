Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC78DC43219
	for <kvmarm@archiver.kernel.org>; Wed, 16 Nov 2022 17:04:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FEB14B904;
	Wed, 16 Nov 2022 12:04:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U6WqxvtZsbdr; Wed, 16 Nov 2022 12:04:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D6724B905;
	Wed, 16 Nov 2022 12:04:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 839DA4B904
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:04:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w0TUezVtK4Ye for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 12:04:05 -0500 (EST)
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com
 [209.85.208.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 470FA4B8F4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:04:05 -0500 (EST)
Received: by mail-ed1-f73.google.com with SMTP id
 y18-20020a056402359200b004635f8b1bfbso12964337edc.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 09:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=UNHIEymVb+XSzDMRY7di2ZGqPLVkyCRzgk1tuxxw7oc=;
 b=ULXXfyFHyQ/ZzVkyLWpxN5DnlpcorBmr7G0YcKEPr2b2mJrX39TIEN9HZ6c0hZDTyx
 329LbDpAKIwekVtzcha75hsVu8Si4bfwJSXe0h7d+t4hQpqKu9yAKDCX0EnQbqn9YLgg
 2Ytm/pKNd6sLkdxUelG6cKU40fEj5vr55vNfLdGYzj9cGjcnS7iFPT6ZfNxCEM1kt0IL
 ngAYqkkEAFKLCS7zC2p+Hd94ACzVr4mUJK6MBaN9BBcH3DaZbgMK73RRoJAG3fXExPE6
 f+egV7/6COHJt96CMB21bc8wKQPQsqc0pI5ORROQnC8W2U5V53bGpF760O2bosKDghWD
 RQ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=UNHIEymVb+XSzDMRY7di2ZGqPLVkyCRzgk1tuxxw7oc=;
 b=RTlhCkewq24yYyI//R0Zscd55cCl2FA/SBzbg/TacGxLiUdLfhXchfclJUmHR158xC
 5M/Z5CsoFghfCMXOnjM5qOK/bdT3N2SsaKjFagxyGbIa7eJhi8oP9QCCEDlFhzhZM3Gc
 MnAUk23uEkVKCl9bZdXd2LPf5jH/MQfDYzu0fTrGGE/HhEWFqn+rPLJck7ZTm1IU6UKQ
 IDHybh1VInDzYMPfVdtucHXfh+oDyJC/RJaM2R7TkG3KTNi3SSdTAYMfTThxQeaYCu7m
 okEhGiQpOoKpI+oU7jwRNA101COUGQy1LUakMolw7dwlnefB8g5qfy0yOYmKeCjnJLum
 MdNg==
X-Gm-Message-State: ANoB5pnBSK31t8mrmImWMoP8FSHOV85hvaNXOCHi3/BKjDhHjbbNP4a+
 hq4Bcfrfh2fpbeO4/eDpm0BxdGpBhySi
X-Google-Smtp-Source: AA0mqf7bePVxvTek80mJF7MvMu/XjAXSSdk17HBMIgnsABCOlR0Jqni4M2Ms2XVeDVgnHMr7E43fgsMQt7X3
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a50:d790:0:b0:461:7fe6:9ea7 with SMTP id
 w16-20020a50d790000000b004617fe69ea7mr19716772edi.94.1668618244971; Wed, 16
 Nov 2022 09:04:04 -0800 (PST)
Date: Wed, 16 Nov 2022 17:03:34 +0000
In-Reply-To: <20221116170335.2341003-1-qperret@google.com>
Mime-Version: 1.0
References: <20221116170335.2341003-1-qperret@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221116170335.2341003-12-qperret@google.com>
Subject: [PATCH 11/12] KVM: arm64: Handle FFA_MEM_LEND calls from the host
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
 Andrew Walbran <qwandor@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

From: Will Deacon <will@kernel.org>

Handle FFA_MEM_LEND calls from the host by treating them identically to
FFA_MEM_SHARE calls for the purposes of the host stage-2 page-table, but
forwarding on the original request to EL3.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 8f690b80af60..84024cba12ff 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -122,10 +122,10 @@ static int spmd_unmap_ffa_buffers(void)
 	return res.a0 == FFA_SUCCESS ? FFA_RET_SUCCESS : res.a2;
 }
 
-static void spmd_mem_share(struct arm_smccc_res *res, u32 len, u32 fraglen)
+static void spmd_mem_xfer(struct arm_smccc_res *res, u64 func_id, u32 len,
+			  u32 fraglen)
 {
-	arm_smccc_1_1_smc(FFA_FN64_MEM_SHARE,
-			  len, fraglen,
+	arm_smccc_1_1_smc(func_id, len, fraglen,
 			  0, 0, 0, 0, 0,
 			  res);
 }
@@ -323,8 +323,9 @@ static int ffa_host_unshare_ranges(struct ffa_mem_region_addr_range *ranges,
 	return ret;
 }
 
-static void do_ffa_mem_share(struct arm_smccc_res *res,
-			     struct kvm_cpu_context *ctxt)
+static __always_inline void do_ffa_mem_xfer(const u64 func_id,
+					    struct arm_smccc_res *res,
+					    struct kvm_cpu_context *ctxt)
 {
 	DECLARE_REG(u32, len, ctxt, 1);
 	DECLARE_REG(u32, fraglen, ctxt, 2);
@@ -335,6 +336,9 @@ static void do_ffa_mem_share(struct arm_smccc_res *res,
 	int ret = 0;
 	u32 offset;
 
+	BUILD_BUG_ON(func_id != FFA_FN64_MEM_SHARE &&
+		     func_id != FFA_FN64_MEM_LEND);
+
 	if (addr_mbz || npages_mbz || fraglen > len ||
 	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
 		ret = FFA_RET_INVALID_PARAMETERS;
@@ -384,7 +388,7 @@ static void do_ffa_mem_share(struct arm_smccc_res *res,
 	if (ret)
 		goto out_unlock;
 
-	spmd_mem_share(res, len, fraglen);
+	spmd_mem_xfer(res, func_id, len, fraglen);
 	if (res->a0 != FFA_SUCCESS) {
 		WARN_ON(ffa_host_unshare_ranges(reg->constituents,
 						reg->addr_range_cnt));
@@ -535,13 +539,15 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
 		goto out_handled;
 	case FFA_MEM_SHARE:
 	case FFA_FN64_MEM_SHARE:
-		do_ffa_mem_share(&res, host_ctxt);
+		do_ffa_mem_xfer(FFA_FN64_MEM_SHARE, &res, host_ctxt);
 		goto out_handled;
 	case FFA_MEM_RECLAIM:
 		do_ffa_mem_reclaim(&res, host_ctxt);
 		goto out_handled;
 	case FFA_MEM_LEND:
 	case FFA_FN64_MEM_LEND:
+		do_ffa_mem_xfer(FFA_FN64_MEM_LEND, &res, host_ctxt);
+		goto out_handled;
 	case FFA_MEM_FRAG_TX:
 		break;
 	}
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
