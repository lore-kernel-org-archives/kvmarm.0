Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A9CC4320A
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 10:16:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8509760560
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 10:16:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8509760560
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3883D4B0D1;
	Fri, 27 Aug 2021 06:16:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bwCvvdp18qvz; Fri, 27 Aug 2021 06:16:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA6724B130;
	Fri, 27 Aug 2021 06:16:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C78F74B11E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 06:16:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BwcMjB+iWqtH for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 06:16:29 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1018F4B10C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 06:16:27 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 p21-20020ac846150000b02902982d999bfbso81095qtn.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 03:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=7Wr1c8QdaWfV4IkzMvbq8rsuOgcUfrUVwpNW94s4KlQ=;
 b=jqTiY84bDwyDnYgeOBntMKkUrRKsSuLdDybsls1ckTi72mQrqU9MJHyU/YHjN3RicM
 ZdnuhjDg9QBmBra4754W5lwhvDbBm5+6q4dtreCVPQlcr/1npGJ/RdxdozMwZE5TVDHu
 p1EUx7UVsQ+e7DHonBMh4dsY5MxbNWsVuhYebKjcE227rS5y4YezB0dZ2lpPnvdYd0tI
 IEIcprf4+8WRH4GN0BLj1D3OY3mj4nRF+nmpLQegsaK6y0Jpq80xbPSDmYQA7HTAAwtS
 vBSdw4thyzmlWvQH2nzcCVNdKvdw+CBLxDOs8SBqeBvjE8M7yvIwhDakTm4Qbzhn+Z/W
 nmsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=7Wr1c8QdaWfV4IkzMvbq8rsuOgcUfrUVwpNW94s4KlQ=;
 b=JpY2+kDLgNQ7p8yL6GUlrfKR4F+Q0yfV4nICbrdtOZKk+0iEc3VP5MxL4NJo9WmKvf
 B21tP8mjspWnqXK4KJUGMxLcTsy9TnnFvKSoeShiXmWgSRzkf06LxqHP+LPgTWQOq7z0
 FiCWzDsV+ND/jeIXMCfrQG75qOQ2nW43vfRY0nwkeYvd468HIPHrDMqYAPqTLq4sNR91
 a8pbfKGaNGNrdCNFg+o5zKWgYJPGDuyyNaTP/pRUHToKakLdBuTkq4tUOReDAdvw7+ZP
 dFShRAdm942K4t0EK57HhAWmUEZN2YIN9npCiRWUvTfz7g44Kvf4y8sG3j3sbuc6H8xB
 IIkg==
X-Gm-Message-State: AOAM531a4ORAbFRrtkuxa5O1uOOzfsvsFTFztIOVHXMBZOxnrrGCwyzg
 H4J3puFhTBAu5HoP0eaemIVrVsPDtKIopgCp3Vfu/iBDADKtQg5XBY8jws/2awNJqWofoUx/XXS
 552x8PWkkpmvjZusyb3l8E6qCsEvIGUSqy1OTlqgxAJsDOhKcBvLxJIlHpxjavgpiU3Q=
X-Google-Smtp-Source: ABdhPJxr+OmFFSWemlsehudkURr3Vn6uvi0dUeFRBVF03SxZL/KBLtu9Ua2mp8cnp0Y5EA20Atj1oYsufg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:aac3:: with SMTP id
 g3mr9077497qvb.14.1630059386604; 
 Fri, 27 Aug 2021 03:16:26 -0700 (PDT)
Date: Fri, 27 Aug 2021 11:16:08 +0100
In-Reply-To: <20210827101609.2808181-1-tabba@google.com>
Message-Id: <20210827101609.2808181-8-tabba@google.com>
Mime-Version: 1.0
References: <20210827101609.2808181-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v5 7/8] KVM: arm64: Trap access to pVM restricted features
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

Trap accesses to restricted features for VMs running in protected
mode.

Access to feature registers are emulated, and only supported
features are exposed to protected VMs.

Accesses to restricted registers as well as restricted
instructions are trapped, and an undefined exception is injected
into the protected guests, i.e., with EC = 0x0 (unknown reason).
This EC is the one used, according to the Arm Architecture
Reference Manual, for unallocated or undefined system registers
or instructions.

Only affects the functionality of protected VMs. Otherwise,
should not affect non-protected VMs when KVM is running in
protected mode.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 41f05bf88f61..fe0c3833ec66 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -171,8 +171,23 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
+static const exit_handler_fn pvm_exit_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15,
+	[ESR_ELx_EC_CP15_64]		= kvm_hyp_handle_cp15,
+	[ESR_ELx_EC_SYS64]		= kvm_handle_pvm_sys64,
+	[ESR_ELx_EC_SVE]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_FP_ASIMD]		= kvm_handle_pvm_fpsimd,
+	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
+	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
+	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
+};
+
 const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 {
+	if (unlikely(kvm_vm_is_protected(kvm)))
+		return pvm_exit_handlers;
+
 	return hyp_exit_handlers;
 }
 
-- 
2.33.0.259.gc128427fd7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
