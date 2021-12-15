Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E24C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 15 Dec 2021 16:13:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4A4C4B129;
	Wed, 15 Dec 2021 11:13:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IpH82e2r3OGk; Wed, 15 Dec 2021 11:13:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD9834B1C0;
	Wed, 15 Dec 2021 11:13:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4AC64B119
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 11:13:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1WChWaR3yLUw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Dec 2021 11:13:10 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 540834B1E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 11:13:10 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id
 n22-20020adf8b16000000b001a22f61b29cso647574wra.23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 08:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=8rgSQfxqCRM7uaw93tRPVu2i1VyDlU+SgH6AjdwelFg=;
 b=oL/4mToqyjfnEM6iyT67/BqZZr2PNLhiYQmR5ckr4IxYAMm3DJ8qXK8tH50bG1H1m/
 vRkewaRsNmYjaDXv7YrXRz5/gziGd7MhVs8Mhinsx5SvjCflWGkam/TtMjX3Z++skB00
 mruR2m7aZDYO9w3PkO3k2QmQKHrfBeUsyKS4zwIOQ7k491fnzDsEEcIJ12VpQB8r32sY
 JygdFvcfEU4MjPLHsd4oSD1/xBooRBb9m7s7Tt5nyCGm3S7W3rsmxZr5xl6Dw832HU1d
 ZS1OMoGsa1TLOGXwEo3GKHhFA9Q7xYLD1FNoNEikntrurFNYroaXlmDvYvmz+Br7YqwS
 9OVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=8rgSQfxqCRM7uaw93tRPVu2i1VyDlU+SgH6AjdwelFg=;
 b=CzJ7gKJR848xFroK+ErWQ2wqFO1zmNM6ccIXc5CC8hh+n8xXJMvTQR4/t6/N2EA5oG
 +aJokXzRLf3s4wi/Mr83EsY7njMxf+UuzSVQSQQfi0C45Z8qfIsWZBRPI2SxM9hDT3tC
 bvugDHKS1FhKFdAQtawyz9QuHh4i3XN44h64OyoVpxq2HeFfdrUaKTmppPX3wed5gsiB
 /Qt6TMf8gtkJeEN7wvJlY5OIoSA1TGOdsvIua9wKCg3MC56k3FSI20QvHqm2HK7nDPOr
 UlBwq/i9MagA/F9s8oReiNeMJiu+AgW+pb9x6y3gafWWryyas7v+h6lzTCyXk0X2n8KH
 tePg==
X-Gm-Message-State: AOAM5321cFt/yKqS6LoRIcKpMvUMUkBBZNUP2n1lhYNsoBDjvmEMiY1U
 W0lKVA6f7OLi/am77m9X+ujGgeuXCG3X
X-Google-Smtp-Source: ABdhPJxXvEycf99ECGUzXgk4Cq7sONC0HLtF5x7Y6YaPQ6+CwNHwdN/fgrDRTjcwDTjmSjH4G+ePR4js0bD1
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:fc03:4f5b:4e9b:3ec1])
 (user=qperret job=sendgmr) by 2002:a05:6000:168e:: with SMTP id
 y14mr4991297wrd.331.1639584789556; Wed, 15 Dec 2021 08:13:09 -0800 (PST)
Date: Wed, 15 Dec 2021 16:12:25 +0000
In-Reply-To: <20211215161232.1480836-1-qperret@google.com>
Message-Id: <20211215161232.1480836-9-qperret@google.com>
Mime-Version: 1.0
References: <20211215161232.1480836-1-qperret@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 08/14] KVM: arm64: Extend pkvm_page_state enumeration to
 handle absent pages
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: qwandor@google.com, linux-kernel@vger.kernel.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Explicitly name the combination of SW0 | SW1 as reserved in the pte and
introduce a new PKVM_NOPAGE meta-state which, although not directly
stored in the software bits of the pte, can be used to represent an
entry for which there is no underlying page. This is distinct from an
invalid pte, as stage-2 identity mappings for the host are created
lazily and so an invalid pte there is the same as a valid mapping for
the purposes of ownership information.

This state will be used for permission checking during page transitions
in later patches.

Reviewed-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index b58c910babaf..56445586c755 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -24,6 +24,11 @@ enum pkvm_page_state {
 	PKVM_PAGE_OWNED			= 0ULL,
 	PKVM_PAGE_SHARED_OWNED		= KVM_PGTABLE_PROT_SW0,
 	PKVM_PAGE_SHARED_BORROWED	= KVM_PGTABLE_PROT_SW1,
+	__PKVM_PAGE_RESERVED		= KVM_PGTABLE_PROT_SW0 |
+					  KVM_PGTABLE_PROT_SW1,
+
+	/* Meta-states which aren't encoded directly in the PTE's SW bits */
+	PKVM_NOPAGE,
 };
 
 #define PKVM_PAGE_STATE_PROT_MASK	(KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
-- 
2.34.1.173.g76aa8bc2d0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
