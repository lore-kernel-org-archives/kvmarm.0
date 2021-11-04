Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22C2C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5710C611CA
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5710C611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09A1049FE6;
	Wed,  3 Nov 2021 20:26:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xCYAReF1xFDf; Wed,  3 Nov 2021 20:26:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 750FA4B1BC;
	Wed,  3 Nov 2021 20:26:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2152949FE6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SPhT3x-tabhF for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:38 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 01EA64B13D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:38 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 o1-20020a635d41000000b002bd97c0a03dso2408359pgm.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=z9H8IQzlDNgV44iopVPD/a5Trpa0ZdTpJckFcsIyzz0=;
 b=YKpIJ4e4/wfganLDuC8K208Zpsp5JVcK50xnWQQTLSFM+X50LE78T6m87p5qT3DblR
 Oqy3rk1VQsN1i/paB2gXcz5pvl+Jhd8ELjKdXAD0WmwFnDoXvIApQ5t8wATtH/xHBo3e
 E3zgwsISbQWVPjz/S1RIgDi94l9z3MF9WBJMMJEtMbLYrCmw/M0/pklTGnCcvsIM1IzC
 7p8hk9aIycQqutIs+/eYz7g/lbNHI/oVf07ie2vQl+tlRkiyfau6HsmDc9DeODVl5ybk
 WJzJ95EFnzX+H5HwRah9xIveGt9v2x/cU0TbcVn1MuEYGyTz7eHSGiF0kmPeMBG8mGAx
 hpBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=z9H8IQzlDNgV44iopVPD/a5Trpa0ZdTpJckFcsIyzz0=;
 b=02bqFlmHmC5vhkUGIW/pk+kHFbWph9x0jX9p5V+4qzGaEaW8viBOo6Vu+p5gcW1YvC
 c19ntBI0PvjJLSYic412kxLvzIse7Pi6H62NWpMHdVyyDdsCTEvgKHc7TYRJNkrXiwQP
 L19J3imBqDaQyKIfCUikcPBwjWVtR9GOp9BgvNO91YDOndp4UkjnE2RKRQRaYbR45iTV
 0PezivE+ywiTrmwLQVanvehfYJi93E5YG/GGCjRP/X0eQ/bIYDlliespQLhnJXkJyVTl
 lWOsBgBk++baSk6kiB+ieksBx7T82gYh/ozoSgYfcOqeendUduEzXapCnJg0gzjcjwKP
 VESA==
X-Gm-Message-State: AOAM531vxtxRt9LaBnqimll2mQGnUvvKhRIC35UrA6cHSRPwV05qfkdM
 3i97ZiX0O03M/0Xp/Gnk3iYqo8CzXPQ=
X-Google-Smtp-Source: ABdhPJzonurVPT2PlJyw4WaELXDlFkKjeT4hoSllYUuMDrNarwts75/W8wr8EQC45lWUJfQCoW+ypti7LUM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5285:: with SMTP id
 w5mr261421pjh.1.1635985596589; Wed, 03 Nov 2021 17:26:36 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:23 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-23-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 22/30] KVM: Move WARN on invalid memslot index to
 update_memslots()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Anup Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, Ben Gardon <bgardon@google.com>,
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-riscv@lists.infradead.org,
 Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Since kvm_memslot_move_forward() can theoretically return a negative
memslot index even when kvm_memslot_move_backward() returned a positive one
(and so did not WARN) let's just move the warning to the common code.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a2d51ce957e1..d45d574a5a2d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1307,8 +1307,7 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
 	struct kvm_memory_slot *mslots = slots->memslots;
 	int i;
 
-	if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
-	    WARN_ON_ONCE(!slots->used_slots))
+	if (slots->id_to_index[memslot->id] == -1 || !slots->used_slots)
 		return -1;
 
 	/*
@@ -1412,6 +1411,9 @@ static void update_memslots(struct kvm_memslots *slots,
 			i = kvm_memslot_move_backward(slots, memslot);
 		i = kvm_memslot_move_forward(slots, memslot, i);
 
+		if (WARN_ON_ONCE(i < 0))
+			return;
+
 		/*
 		 * Copy the memslot to its new position in memslots and update
 		 * its index accordingly.
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
