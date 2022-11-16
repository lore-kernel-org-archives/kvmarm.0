Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0471DC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 16 Nov 2022 17:04:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E7E94B885;
	Wed, 16 Nov 2022 12:04:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jgw49-A4NSWy; Wed, 16 Nov 2022 12:04:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10BD24B8DE;
	Wed, 16 Nov 2022 12:04:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5EC94B8B3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:04:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oTqV98s6dGPA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 12:04:03 -0500 (EST)
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com
 [209.85.208.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9867B4B8E4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:04:03 -0500 (EST)
Received: by mail-ed1-f73.google.com with SMTP id
 s15-20020a056402520f00b0046321fff42dso12724108edd.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 09:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=WEPKdueo5FNQNF9/fei3NEE3Fz8J5QrFmaxaGbrgW5I=;
 b=Ab4Emp8kcmWx1L3Px0dWAkM+bY8plvLmVdh7hgZZxbj6/F6TH6+43o8rGornSbrVIO
 ebkbJBZte8MqtfyIXQZBx7wj3hHV8ksl9YgKmL74XQ+KpJujBKO6fHIcHjg0IqV4MnKj
 5cfdyJyZJhgkzyHXh6y96fsIcMwEykmkIDhaultNtYPGW7lrfyDNDOTqM/Ln4gmmLAtR
 /HesmOGg8kCXIL/YfZepRrSUSW4QEg707ma+KwwParMrtUW8WvU0uFF+AbwnwvlOmGqM
 uMOhB42D32xrN6r73gzU1HAEb0363s0jkY5bPYQ3NV0hOex9Bwf+SWIgcl9sd0siuZqX
 VzpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=WEPKdueo5FNQNF9/fei3NEE3Fz8J5QrFmaxaGbrgW5I=;
 b=cZOcDq+8UR8jMRO1nAuz4Mv3ihidsFaulN1ihUk9epH+NeAJDtu5MwoP5QjCW339nt
 7Gnq5pXxxLpJzrnOGc77wAOt9+D6FL45fD4BFLROFdOmZ59HFhC8A3NG4d4L/DzkBanb
 aI8FQX51sZcgMOzXC77xsmCM56MdL9cgGRi407mLfvwLCm3OQIs5y1YEH9PQYlIBEzS3
 wyB6xLN/cut1Lbi5pbdxg/4at9sCwChN///YDwipu/8IcviUxF4ZXa/KD921txoYfHWQ
 wqwvyvdmw/FirOeAB8Yo8mU8Cz28TbwkfULPgG+OKaHLwOQEVh8BGesK6ZSKLHzF4zrQ
 i9oA==
X-Gm-Message-State: ANoB5plACE6YTFg0lk1yRz2twSIw+hD98CE2k7m7I11tCRjqNtOTyxmE
 lXP2ZD4IkV+cx7tp/jgeI9+qsbx80j7p
X-Google-Smtp-Source: AA0mqf7VNeZ3KzM1nTjxZISVikiNvvcNnJ0KNs4YdhCtWf+uPc3PxJ392kWTSIoZW/R5ANucY0mbzWDRNhqa
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a17:907:76b8:b0:7ae:6cdd:9bc9 with SMTP id
 jw24-20020a17090776b800b007ae6cdd9bc9mr17629578ejc.619.1668618242780; Wed, 16
 Nov 2022 09:04:02 -0800 (PST)
Date: Wed, 16 Nov 2022 17:03:33 +0000
In-Reply-To: <20221116170335.2341003-1-qperret@google.com>
Mime-Version: 1.0
References: <20221116170335.2341003-1-qperret@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221116170335.2341003-11-qperret@google.com>
Subject: [PATCH 10/12] KVM: arm64: Handle FFA_MEM_RECLAIM calls from the host
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

Intecept FFA_MEM_RECLAIM calls from the host and transition the host
stage-2 page-table entries from the SHARED_OWNED state back to the OWNED
state once EL3 has confirmed that the secure mapping has been reclaimed.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 80 ++++++++++++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index e6d85849c617..8f690b80af60 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -130,6 +130,23 @@ static void spmd_mem_share(struct arm_smccc_res *res, u32 len, u32 fraglen)
 			  res);
 }
 
+static void spmd_mem_reclaim(struct arm_smccc_res *res, u32 handle_lo,
+			     u32 handle_hi, u32 flags)
+{
+	arm_smccc_1_1_smc(FFA_MEM_RECLAIM,
+			  handle_lo, handle_hi, flags,
+			  0, 0, 0, 0,
+			  res);
+}
+
+static void spmd_retrieve_req(struct arm_smccc_res *res, u32 len)
+{
+	arm_smccc_1_1_smc(FFA_FN64_MEM_RETRIEVE_REQ,
+			  len, len,
+			  0, 0, 0, 0, 0,
+			  res);
+}
+
 static void do_ffa_rxtx_map(struct arm_smccc_res *res,
 			    struct kvm_cpu_context *ctxt)
 {
@@ -381,6 +398,65 @@ static void do_ffa_mem_share(struct arm_smccc_res *res,
 	return;
 }
 
+static void do_ffa_mem_reclaim(struct arm_smccc_res *res,
+			       struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, handle_lo, ctxt, 1);
+	DECLARE_REG(u32, handle_hi, ctxt, 2);
+	DECLARE_REG(u32, flags, ctxt, 3);
+	struct ffa_composite_mem_region *reg;
+	struct ffa_mem_region *buf;
+	int ret = 0;
+	u32 offset;
+	u64 handle;
+
+	handle = PACK_HANDLE(handle_lo, handle_hi);
+
+	hyp_spin_lock(&host_buffers.lock);
+
+	buf = hyp_buffers.tx;
+	*buf = (struct ffa_mem_region) {
+		.sender_id	= HOST_FFA_ID,
+		.handle		= handle,
+	};
+
+	spmd_retrieve_req(res, sizeof(*buf));
+	buf = hyp_buffers.rx;
+	if (res->a0 != FFA_MEM_RETRIEVE_RESP)
+		goto out_unlock;
+
+	/* Check for fragmentation */
+	if (res->a1 != res->a2) {
+		ret = FFA_RET_ABORTED;
+		goto out_unlock;
+	}
+
+	offset = buf->ep_mem_access[0].composite_off;
+	/*
+	 * We can trust the SPMD to get this right, but let's at least
+	 * check that we end up with something that doesn't look _completely_
+	 * bogus.
+	 */
+	if (WARN_ON(offset > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)) {
+		ret = FFA_RET_ABORTED;
+		goto out_unlock;
+	}
+
+	reg = (void *)buf + offset;
+	spmd_mem_reclaim(res, handle_lo, handle_hi, flags);
+	if (res->a0 != FFA_SUCCESS)
+		goto out_unlock;
+
+	/* If the SPMD was happy, then we should be too. */
+	WARN_ON(ffa_host_unshare_ranges(reg->constituents,
+					reg->addr_range_cnt));
+out_unlock:
+	hyp_spin_unlock(&host_buffers.lock);
+
+	if (ret)
+		ffa_to_smccc_res(res, ret);
+}
+
 static bool ffa_call_unsupported(u64 func_id)
 {
 	switch (func_id) {
@@ -461,9 +537,11 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
 	case FFA_FN64_MEM_SHARE:
 		do_ffa_mem_share(&res, host_ctxt);
 		goto out_handled;
+	case FFA_MEM_RECLAIM:
+		do_ffa_mem_reclaim(&res, host_ctxt);
+		goto out_handled;
 	case FFA_MEM_LEND:
 	case FFA_FN64_MEM_LEND:
-	case FFA_MEM_RECLAIM:
 	case FFA_MEM_FRAG_TX:
 		break;
 	}
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
