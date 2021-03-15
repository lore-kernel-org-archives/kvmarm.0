Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A7BEC433E6
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:23:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 098E864F4B
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:23:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 098E864F4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4F994B118;
	Mon, 15 Mar 2021 10:23:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DuRABfhTeaJO; Mon, 15 Mar 2021 10:23:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF2444B1F8;
	Mon, 15 Mar 2021 10:23:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82BD64B1CF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:23:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UC1BCe8LwgBy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:23:32 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAF504B1F8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:23:32 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id b78so24581624qkg.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=PMsVSD0++GY2qOx+MwUz6CjmTO3n8ucGBLRZRh18jcs=;
 b=fJYmR8juXZugMW9ISFDTSmEhEb+CcMDPgEYazlZpToUJCOpckN6j4uluHy1DJffA4Q
 CKTTa8B72YTkWW0788VC1Yv5dyMsqZUUcdJIRtNX2n8hyqszqxQq021ZUnArAsGepFM9
 BdfTvvfFnwstWzKDhDglQr59VkrQc2zqwg7sanU0XOoXlAvqXw8nMm9DDkd2RqXCz0qc
 zYAbQ1pzraXS1HM0uGKxHmBWfnA56eQibK7XPqDwGlJqG5xi2pH429tcl58a4FiKo7hR
 VK7PTeI1esapUUCAPAadWPMaLzMGh5OheADNIkS5TzNd+gPqP+/+7zHuQgbeeGRWnCHV
 Dy1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=PMsVSD0++GY2qOx+MwUz6CjmTO3n8ucGBLRZRh18jcs=;
 b=nbgS26//7yZ58yZuSIuSVGs5Hy8TNyqjeXjs8M7MWffeWagNhHi7p0UWtL4gVIiNzs
 SCcLdj9xmsxtOK7cZuL9uefXFqkZyuLigGmI3iPnfz/lQWsEOm/MXdx1izwXR/GulAI4
 lr3QuxX3Mcqi39I7drye7vkITNEFChdfFOqZeJ3miBje6vyqQtbLwoedNJ6deofM+QS9
 lc67px6nPPZeyllPQ36Xuu3O9GzUAIRmryVcgHZH3p0BIhoJDUOX1sFjBQqdM+Qmfn7f
 OW69uAixrU+YKs9xWc65RIvSHXYPk5tuNLe/aIeDuV0kvowWEAAzJeHkojkLcATVDiiU
 Iutw==
X-Gm-Message-State: AOAM531+z4jWtQqg3w/kxd7ei24FDQEwCaVLx0wBoHwsCMSk+NxEnC9u
 SxcIA384NxQfpKazssCrndDAHDHQqcF7o40KWMPF+NTnN/odFfR+XzsfxdCdfK+iR3vCw4A0bJ3
 /ny+U6d1KQurCby6+SWAeJYt5JbbyyyNsW8X2j20RnhLWeRlriR0/5+oPvDLlFEcBS9fXbQ==
X-Google-Smtp-Source: ABdhPJxy7Gz4Sd9qlty3qsnh2D5C3P5+aAQGZk2lPf7pLmKgCjMRc6otN3yLejNagSe6KjitfoP3HuriUZo=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a05:6214:10c7:: with SMTP id
 r7mr5749683qvs.3.1615818212395; Mon, 15 Mar 2021 07:23:32 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:23:11 +0000
Message-Id: <20210315142311.1848485-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH] KVM: arm64: Update comment for parameter rename
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org
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

The first parameter of __hyp_do_panic() was changed, so update the
comment that's intended to explain the significance of passing zero.
This hunk previously got lost in the merge.

Fixes: c4b000c3928d ("KVM: arm64: Fix nVHE hyp panic host context restore")
Signed-off-by: Andrew Scull <ascull@google.com>
---

Applied on 5.12-rc3. The backports of the original patch contained this
hunk, and it's mainly cosmetic anyway, so no further action is needed.

---
 arch/arm64/kvm/hyp/nvhe/host.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 5d94584840cc..c419648c1d3f 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -152,7 +152,7 @@ SYM_FUNC_END(__hyp_do_panic)
 
 .macro invalid_host_el1_vect
 	.align 7
-	mov	x0, xzr		/* restore_host = false */
+	mov	x0, xzr		/* host_ctxt = NULL */
 	mrs	x1, spsr_el2
 	mrs	x2, elr_el2
 	mrs	x3, par_el1
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
