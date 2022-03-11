Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A149C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:48:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E996C49F02;
	Fri, 11 Mar 2022 03:48:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cp0prVpnOYEU; Fri, 11 Mar 2022 03:48:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C102949F54;
	Fri, 11 Mar 2022 03:48:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F50840FAA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5EZb5lY-lJcp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:25:52 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5BE4840CF5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:52 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 u10-20020a63df0a000000b0037886b8707bso3755450pgg.23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=FuGhM+ADTv/ZcWx+5nd4XLS/9fWvtmM0zVjBEofzrxU=;
 b=Ji7DjPBUNinn477C4vHC7v0CuY0YoR6Yspro2QMZ2A3u86aqpm1X0/aNnOB3Onp3w2
 HgDtdMQ+gjJdoqlarq8fbzeMvb9spnuW9GS9uYaCSHgwIzu15JEmHu79mAnZ1tLJFwPT
 oFowkvO9jBF3oyujgESdSYeqoe0gYjAcidMXMJAHHt6OtFUYjbz9/XwZHovpDi/VB3a2
 2w1CxktgeA3NrBx+qyKN/4Ey7VJIa/lVAfIOLkSA5mAPxkDNWBz2kAed064YBhLxUxUP
 f0JOgrZf/UTO6C022foFU+9duN7WQjx0LGEL0QoLxC6tLxyIOe8si9f3ojrRG/e9lbPJ
 RSag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=FuGhM+ADTv/ZcWx+5nd4XLS/9fWvtmM0zVjBEofzrxU=;
 b=4B4bg7QDi69fw2936dHHV8tHN8XyckdP7yRHN5DMKE7cU3jW/YM89OFGm/D3sTuqnO
 pSL3foQTLxUDNKS7Z4Tcldjsqp/OXOsGeBfSflzvXa+Q/ZK7I2CGLmyoBAXd9c59NktT
 6LLLSDFjXUOgSSVCAByv8RwL57tlK6SsCj/5PIIXt82D5aPnCSqDARKFUB6rAbJe68Wu
 PQuoqko8NZ1S0a5ITeR8kEEo4x2IPUdwYbSePYYnZZL0vSwyogTZGhBjlGUfzndZprE8
 XUCMuZX3vyHBoG13CNOY9mm/27U6SUclAyIUptnEQUnVli3EIdxIDJi4b6nJ+1lUoJ37
 A06Q==
X-Gm-Message-State: AOAM532QlPMEeD75Fk0k1etLo7A89twKd4PqTp8lSkpsELUIzkMWJ+cb
 6PbI6x3Td1PcBtXvQyhcwAzWbqx0JQ51VA==
X-Google-Smtp-Source: ABdhPJwexzqWNekNQlu0Z8Q7kGjrMeWTrgWkJ92wr1Nrhoh86lXtdckWOSYIgTE9CJlEh1iQr24fdow+vmFtsQ==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:192:b0:151:8df9:6cdb with SMTP id
 z18-20020a170903019200b001518df96cdbmr7919327plg.20.1646958351495; Thu, 10
 Mar 2022 16:25:51 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:14 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-13-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 12/26] KVM: x86/mmu: Pass const memslot to rmap_add()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 11 Mar 2022 03:48:42 -0500
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

rmap_add() only uses the slot to call gfn_to_rmap() which takes a const
memslot.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4c8feaeb063d..23c0a36ac93f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1596,7 +1596,7 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 #define RMAP_RECYCLE_THRESHOLD 1000
 
-static void rmap_add(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
 		     u64 *spte, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
