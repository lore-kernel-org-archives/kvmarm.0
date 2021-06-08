Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18296C47082
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:11:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B9B9F61108
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:11:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9B9F61108
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E96040878;
	Tue,  8 Jun 2021 10:11:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rZfQFLw0kZSp; Tue,  8 Jun 2021 10:11:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2394A4081C;
	Tue,  8 Jun 2021 10:11:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C15594086A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:11:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HmObkk6Kz1jA for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 10:11:53 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2E054079A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:11:53 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 k16-20020ae9f1100000b02903aa0311ef7bso12070169qkg.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 07:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=OBCO8s7Q80TfIlYuHTY4iy7nv5Rn/TiuCTrWSGUfF4U=;
 b=MoN4dps2ZTiPTKGBh1DVK9lwFJTRIyDyKRLCpLXV0gGTuXNVM5oXgyybTxV78acvH9
 fmFH2/TjUq75AWlp90FL2RzjzX9DfTOaGv2hP4i8uDJkHZYYh77M36HhqKThDgAQZ2no
 BUvyK8pOBzafiWSLbVFaEOU7hgqrIti+8IY4k2O2OYD//GtCIV1N7lAPk3t7vxb4of3i
 /YgIbP82T1qX3gK2BySKmqvaFjzvirQXKrTxDrA1lmvzTL75VTaw/2y8GmIwIeYU65wZ
 /mv0qdGNjRaNHYaY3OaHbtt0bsiGXJSLGnhG31ewUUN5eppwZQZlHWfTCT7rHFB+vGY1
 Y3Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=OBCO8s7Q80TfIlYuHTY4iy7nv5Rn/TiuCTrWSGUfF4U=;
 b=kq359vNjcEwfS9ZLtsies6eMtLJ68Rx3+PkO2IiUN0RdYHCme0ef/wCPITj/Ti0NTj
 pJZ59n9RfOmAgcRknmGoblL3f873cSjwogF7ykTDrnTuZlmapCzuytMRWPzkq/p5HjZ6
 Sxw5ry87lzKmdkN6RkkT0l7bcy/iT0PIq0zCepdmluN3mUU43w/KyYWDAaTZIJZRpAK9
 w0+6LmRKjjJmPy6Q3qmaFqpEgcrW9un2Ku1ITseHk4vykJs70uJgKC4B2GqlQs28hfRu
 +WI7Pm8nfvAUhhw1OEybgzekcHJ6CDShAmRDvYAXriJ+0xZUHH1Ksb+7uOBDXdtjt5pQ
 XSOQ==
X-Gm-Message-State: AOAM533HqOdww2yqQ15exyBdGAzYZLCCMwI3A6PutZe7L6/RkVGRSd5w
 jmfjnS2HPknZtAaiBoL7anwcz0wdxUz/qVFgleikLmww02dsTYMML9uh1Zg7CyUgVV3fpQCtJWS
 4WxKW7Dj4KaO473M7OBCdwuGTLCW3a/OKzc0HY1gKgvpK0vf0E9axIosV0MrzNn2+OGM=
X-Google-Smtp-Source: ABdhPJxpGX73Z52hJxsj2Po6OlxesU18A3epNjEVGsZ9aSHXe5Ja52uB1RBv+GOJBxo8uI4KoiZL7yHnUA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:fa4a:: with SMTP id
 k10mr203538qvo.18.1623161513492; 
 Tue, 08 Jun 2021 07:11:53 -0700 (PDT)
Date: Tue,  8 Jun 2021 15:11:33 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-6-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 05/13] KVM: arm64: Restore mdcr_el2 from vcpu
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

On deactivating traps, restore the value of mdcr_el2 from the
vcpu context, rather than directly reading the hardware register.
Currently, the two values are the same, i.e., the hardware
register and the vcpu one. A future patch will be changing the
value of mdcr_el2 on activating traps, and this ensures that its
value will be restored.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f7af9688c1f7..430b5bae8761 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -73,7 +73,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 
 	___deactivate_traps(vcpu);
 
-	mdcr_el2 = read_sysreg(mdcr_el2);
+	mdcr_el2 = vcpu->arch.mdcr_el2;
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
