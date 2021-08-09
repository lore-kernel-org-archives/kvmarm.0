Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA1CC432BE
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 243656101D
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 243656101D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B962F4B125;
	Mon,  9 Aug 2021 11:25:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ORkdTy94ii9M; Mon,  9 Aug 2021 11:25:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E1C14B104;
	Mon,  9 Aug 2021 11:25:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87151404F8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WmtWyexdBY32 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:25:20 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F5644B0FB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:20 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 a17-20020a0cefd10000b0290341c3c56ff4so12563484qvt.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=3dBIi1YzqMEm+UlYWRCSS5kKhcRIzlI2kVO6oR1gAJY=;
 b=pwqfES+b/309iPvlv8E1ftMhSnhlZy8mcMABvDRuAotG2budtPOdgJb73oPI6/MSGD
 ILhOvPTq8aIdf06m1VIM0yJOfipj9IDRQygTQK0MXZQ78+f+s6FJNc4eruv9GBpHUATi
 3DPVRIxc+WjDdgR385vu2hDXy4mP0G3jEB7NeE0p5xd7Tsw9AwVodm/pABL8JAkqLUJm
 Dedj5LkITe1ybQH+GMWWBsZx05lk6S7Iqa2v9OVbbFvui/pxn7ZMcFeqJTXh1zGzeV7/
 wCMz42JxwEpefj4CSksac16Vm16+9iQ0mxJgbtQYa+MRG8v10SN4Entl6tuQ2OhQ2q3X
 lIXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=3dBIi1YzqMEm+UlYWRCSS5kKhcRIzlI2kVO6oR1gAJY=;
 b=rlU70VrKS98yyFw+OVxTUoVYdn0xDo9EwZ5oWe69Ur9rO1cccLq9612Etk/K9fklK6
 vo7/6pqu82BRROgCYj4X4qO9Y7L3KpLiFLmOmxcZCyr5q04+3BsoHP3+95DwktZTiWYG
 HJqEDVHMaon4Pb2H4BHL5RPkfCEbMvMmDLl3vGaAjxALInd3hV1QhgGl0TiK6+DsUAOF
 Cv6G3DDzy2GEilrursI0VileM357ieSX4foz9Me+luNPIhV7hyP7shOlrQy4pchxrnTs
 x2dF1Vfisgnvoa+8flOOLRcdDtnx+Q/nkJU6Z0Migy2W88Q8mepxTEaZC5bVNA5L2T0K
 Q25A==
X-Gm-Message-State: AOAM5312dbFBXEoHGGVMsHoyuwxd2gMMw18o7fYZ8FoxCUzRMw4O3pQC
 oh4a4XYVA33OlpQUs1RBukGmP93So4wX
X-Google-Smtp-Source: ABdhPJwTAF1XYWSKb67BxPuZMFA3SIWFIr0NEvX9FTJFVSSti+daWMWMqdeklw8++yGxusAYBtawMwClTWQ8
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:a05:6214:d4b:: with SMTP id
 11mr12803043qvr.44.1628522719790; Mon, 09 Aug 2021 08:25:19 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:40 +0100
In-Reply-To: <20210809152448.1810400-1-qperret@google.com>
Message-Id: <20210809152448.1810400-14-qperret@google.com>
Mime-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 13/21] KVM: arm64: Expose host stage-2 manipulation helpers
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Cc: qwandor@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
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

We will need to manipulate the host stage-2 page-table from outside
mem_protect.c soon. Introduce two functions allowing this, and make
them usable to users of mem_protect.h.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 18 +++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 87b1690c439f..0849ee8fa260 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -49,6 +49,8 @@ extern struct host_kvm host_kvm;
 int __pkvm_prot_finalize(void);
 int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end);
 
+int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
+int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id);
 int kvm_host_prepare_stage2(void *pgt_pool_base);
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 6fed6772c673..f95a5a4aa09c 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -273,6 +273,22 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 	return 0;
 }
 
+int host_stage2_idmap_locked(phys_addr_t addr, u64 size,
+			     enum kvm_pgtable_prot prot)
+{
+	hyp_assert_lock_held(&host_kvm.lock);
+
+	return host_stage2_try(__host_stage2_idmap, addr, addr + size, prot);
+}
+
+int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
+{
+	hyp_assert_lock_held(&host_kvm.lock);
+
+	return host_stage2_try(kvm_pgtable_stage2_set_owner, &host_kvm.pgt,
+			       addr, size, &host_s2_pool, owner_id);
+}
+
 static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
 {
 	/*
@@ -309,7 +325,7 @@ static int host_stage2_idmap(u64 addr)
 	if (ret)
 		goto unlock;
 
-	ret = host_stage2_try(__host_stage2_idmap, range.start, range.end, prot);
+	ret = host_stage2_idmap_locked(range.start, range.end - range.start, prot);
 unlock:
 	hyp_spin_unlock(&host_kvm.lock);
 
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
