Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4966FC07E9D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:48:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 001D261006
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:48:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 001D261006
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A70054A00B;
	Mon, 19 Jul 2021 06:48:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HKk-HWPlhxm2; Mon, 19 Jul 2021 06:48:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8020B4B0BB;
	Mon, 19 Jul 2021 06:48:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB50049F92
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:48:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NBuM7cYxTQ9b for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 06:48:15 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC0044B0DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:48:13 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 g13-20020a05600c4ecdb0290242a8f4cf9cso1437618wmq.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 03:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xCrkHvgx5Vjp7sEk2L8Nl84wrwMoF/axMUKdY9pah24=;
 b=pDxR+oOIO361IE8JTpjXvK01glJPoXIl5CKZaNz+ZEfkmqJ2xvk3unbPd+7kb+OWda
 trEZrnZ3NzpP8uHCTZzYftalFdx/5wIdaoBQhrxNPVxgdiIghwpg+2wP8M3OPqfirjTd
 xnwKYQbjP84kmxrLM9ZxQ2L+sfZUek62Dy3owBDZGm0aQ2qax8dWHJG04y1UCCQkOeuM
 PcvsBY4gP2Eu0tIv5EGGfrTI+RlXVojwsHLkOMz6yutWmR06OxR8yq1klADXa4P0bQwV
 ool2uXbjJpW+F45cx8urCBsHAnKEob82EgvPFM7Eq5WwW85p/LaSm12Ccfkyebt5WyL7
 ovvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xCrkHvgx5Vjp7sEk2L8Nl84wrwMoF/axMUKdY9pah24=;
 b=FxsHmI3+r0+DpZbb5fdiXPXyMvEUYn56JdsjGmiNFNsN8UiYzKw5Hev261p0UyC5Lh
 CcpJRRvX+OKiIz6GmjXNz7O+nH7x/FBTRfwfZcaZDNFhVZ37QsL6kurUMGVv7oiLWn1g
 C0+SQUNBWA/JlPvZoV4Ll8+IZrYyQwPtEbN7rsZA4Xy5Sx3946SUZZr+Icq01WagtHH5
 PtPbSOwwGeyDuAHZJ2qYIrfPoLyH5BncKxtBdL0QHrE6/dAbHWQ8XZqgALIPWVxzCECx
 E4pxFKDpyWdM4Qz64r0skGVQtd9qLg/P7XZrChCZTA09rW9UQ4wrSwF9ZjceTHedHtBk
 tfdQ==
X-Gm-Message-State: AOAM532WImJ0kDWgsjWqsFCWklpoz7LkpwL+s4nIeL72QX5MCO5AU243
 yMHezaIE6RK2Pq3CU9vf1Gfyw24XOLUI
X-Google-Smtp-Source: ABdhPJyIruRnm597DeIoz+H4lQk2XaV0lp7fhRFMVmFaiZHZyDX1vs7MSEJSK9DYDl49AjGViAobxaMPEAN7
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1a96:a43f:6c2e:bb5a])
 (user=qperret job=sendgmr) by 2002:a1c:4c18:: with SMTP id
 z24mr32007850wmf.168.1626691692999; Mon, 19 Jul 2021 03:48:12 -0700 (PDT)
Date: Mon, 19 Jul 2021 11:47:35 +0100
In-Reply-To: <20210719104735.3681732-1-qperret@google.com>
Message-Id: <20210719104735.3681732-15-qperret@google.com>
Mime-Version: 1.0
References: <20210719104735.3681732-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH 14/14] KVM: arm64: Prevent late calls to
 __pkvm_create_private_mapping()
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

__pkvm_create_private_mapping() allows the host kernel to create
arbitrary mappings the hypervisor's "private" range. However, this is
only needed early on, and there should be no good reason for the host
to need this past the point where the pkvm static is set. Make sure to
stub the hypercall past this point to ensure it can't be used by a
malicious host.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f05ecbd382d0..e1d12f8122a7 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -154,7 +154,10 @@ static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ct
 	DECLARE_REG(size_t, size, host_ctxt, 2);
 	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 3);
 
-	cpu_reg(host_ctxt, 1) = __pkvm_create_private_mapping(phys, size, prot);
+	if (static_branch_unlikely(&kvm_protected_mode_initialized))
+		cpu_reg(host_ctxt, 1) = -EPERM;
+	else
+		cpu_reg(host_ctxt, 1) = __pkvm_create_private_mapping(phys, size, prot);
 }
 
 static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
