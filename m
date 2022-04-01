Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 460CDC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 18:20:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA3684B291;
	Fri,  1 Apr 2022 14:20:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bqL3qdaGoKqD; Fri,  1 Apr 2022 14:20:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EBCF4B2C6;
	Fri,  1 Apr 2022 14:20:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C2554B219
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VpVwBCRtfddI for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 13:56:05 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 084144B216
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:05 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 m24-20020a17090b069800b001c7de0243a2so1628196pjz.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 10:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=jbEbkPKHHe1JjNjX3H5iG4xlTs9fnMsds5ok0hlcBBc=;
 b=VV57lG6jUHDDUIO2Lve/uFa7PUGIIl+l6vrjKQogFkiWK8u49u3fcY3FaY1VnX4SWU
 lAhHv82539GUIUhq5aY9Du6ih9DNPH3fkNleGNlcSEwXfPzGL+uipqnqtPitwZgwY1En
 57IYSOhVR6QY6lWhxuALbHeIrXgCjKYELkI6V4Xg8HggG1c7xMCmklb0Ukj4j2O9z6nQ
 YHOCnhTZhVGdpOaQG3eacojXN34VLFVPbQS8nVMFlhHg4igvU1YVx1PAf6nhmFbJBGl2
 y61oE1GKqMOOrtIH+uzY9fU55CkheYZRQEPwA//BTrqovqruJ4S0W1hVj+wMXZn/uESV
 wioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=jbEbkPKHHe1JjNjX3H5iG4xlTs9fnMsds5ok0hlcBBc=;
 b=iSZPlg7XBovCmPIscZTWFKvbSDFW3X9dvxN1SOkOkinvQUcLbjYwI1lipRub9mlH+5
 lR8sA88rLqQk4IC+d0Fo9Kbk0MlepmBs0BzF+y67ea7IRB8KLrFAoXLMKFahTKR764/3
 VLTKxEtR3S080xkPaqpiEUnMx9hJJG7H3dmvZNUY+XdHo6ZcgUH1V22cu9cB7cQFQfAS
 2ITYqIr1uORNFxzP0zJYjqaG3RDqBP6HHvZlTnt8eXjOlKJcusLz8WjP/gh9QVO3xJ1g
 e+VbISQrAv1F/JItMuAfmMaSzbZXHMGmgdA5A5raNTLkCRxXZALEo8ITitxHC/JYit5m
 cAHg==
X-Gm-Message-State: AOAM530W6NNPDWfzRiEKsEq8KW4yTG1EiinE7f7UYqTwLU9D+Y1lgm9J
 NA0EKR3HcCZzRTABQSLUiMNiIN78R1domQ==
X-Google-Smtp-Source: ABdhPJyXx7LaJtvQMH0HZ9aVW4MOJlG+noLjDvNAF17gJHNyl1HpSw9eMVXCjPkuG58rcMsky7HoJ7Kj5bLngA==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:ccc4:b0:156:5d37:b42f with SMTP
 id z4-20020a170902ccc400b001565d37b42fmr7667666ple.157.1648835764076; Fri, 01
 Apr 2022 10:56:04 -0700 (PDT)
Date: Fri,  1 Apr 2022 17:55:33 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 02/23] KVM: x86/mmu: Use a bool for direct
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 01 Apr 2022 14:20:42 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

The parameter "direct" can either be true or false, and all of the
callers pass in a bool variable or true/false literal, so just use the
type bool.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dbfda133adbe..1c8d157c097b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1706,7 +1706,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
 {
 	struct kvm_mmu_page *sp;
 
@@ -2031,7 +2031,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gfn_t gfn,
 					     gva_t gaddr,
 					     unsigned level,
-					     int direct,
+					     bool direct,
 					     unsigned int access)
 {
 	union kvm_mmu_page_role role;
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
