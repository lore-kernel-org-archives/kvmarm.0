Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05E9C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 18:21:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A5264B2CE;
	Fri,  1 Apr 2022 14:21:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gn2ooag2kHGv; Fri,  1 Apr 2022 14:21:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87DF04B2E0;
	Fri,  1 Apr 2022 14:20:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C1F9410DA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vXs9ocfXsvNI for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 13:56:21 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8798B4B216
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:21 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 oo16-20020a17090b1c9000b001c6d21e8c04so4354921pjb.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 10:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=zKDQj9FrafQ+86iVPP3K51OIfRdmfs50RkYPmE+oxOQ=;
 b=jwJrV9wgSOZhOdo64taCxPoODAC6XGsgJuKkwc48uKLDwCehUF0oYRs0fx/6iUYJsN
 bDU8lVrfYvdUg3f5cyhCck37cCyLL5/oocbLVeX/2RMocHB7whP9YgJV1BPU0FInpT8M
 Jey3QTtqfjXizgqaTWKrOuc0XTGX8k9DlHlIvbHGsjO2yN1YnnybWB4lTqrMuaaxskHT
 tzBNngTy7KVEqbn10arUq+QvHMRdcdxlBk6ThObz7bZ8fYOmHleUEQKDX3znsHn2k++f
 k/IMtVSXnTPiSX4RDt6Ql8Je3nitAyb3Jw6XHuF5ueww4Kk/F0qDai4j5R/xhVPgfIGK
 wEzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=zKDQj9FrafQ+86iVPP3K51OIfRdmfs50RkYPmE+oxOQ=;
 b=Wax57cbPG8dqEVv9ADtKqV3PwsHV/Rpm5BN/yUKCyVM3gvAXmLlEcxyF7kt9z7l63N
 Q7Hlg9NmD9Vm4Vuygr0XJka18Jr1D2E79gqWGwu4bzk/Zj3pEmQJJiII89A42m4nmc+7
 hd3dNkytlNVrxSmf3Ifso6TuXQjH28zK/sbV8pX6nWHKxVJULO0dXjxpQXnxg2KRuxUp
 Od7cp5SIX+Fy6hlptxq5W5GlQKAtfHGwiZ5txXp2JZxBlpC8QLlW4B6I9zR6rNe7FVgg
 BY4VoTffIxQ01Pwkz6DYxtvjLPu6QuOmNSZL1lQEtKWFAt2lgJvE/ja6A+lDEqsQ8rVL
 g7Lg==
X-Gm-Message-State: AOAM533rNzgbbQfBct7Z4YtKCud3WLQW/ONlejNuXHDGjgFLrNFQFmYX
 aqwlASmUl48eQRyqXeRh/t3MmhbWvlKVPA==
X-Google-Smtp-Source: ABdhPJxYcEKA7pbWp7jjIlDB7Ac6r83BwprafTTSyvULHdi4YCW6thoQ1uhQkF3OnBLrsgJpdsF5d76dQHZQHA==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:7304:b0:1c6:aadc:90e5 with SMTP
 id m4-20020a17090a730400b001c6aadc90e5mr13237879pjk.164.1648835780708; Fri,
 01 Apr 2022 10:56:20 -0700 (PDT)
Date: Fri,  1 Apr 2022 17:55:43 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-13-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 12/23] KVM: x86/mmu: Pass const memslot to rmap_add()
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

rmap_add() only uses the slot to call gfn_to_rmap() which takes a const
memslot.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 37385835c399..1efe161f9c02 100644
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
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
