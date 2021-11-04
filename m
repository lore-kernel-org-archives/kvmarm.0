Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB78C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A5F3611EE
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9A5F3611EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 451E14B0F7;
	Wed,  3 Nov 2021 20:26:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lcAcuBONwBWe; Wed,  3 Nov 2021 20:26:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAA024B1E1;
	Wed,  3 Nov 2021 20:26:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F02C4B1A3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UvlvrisQZQAz for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:42 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 645BE4B104
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:42 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 r30-20020aa7989e000000b004812fdc343eso2344527pfl.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=g2JE1NchR5OuOuOibWq+8/K2CyWjv7Vlzl0jcmmyHKg=;
 b=UK0IuaxMRM8VI2p4RKcIncQCt3/rVVcLXbP5evDmYD/5MRFF0cnYdOJohdcwHEX0UL
 s1jIdejQk2RCs3P65ng7Qi/Nch6xWlLb3AJpNe9St0b08O8bclGAcjcwNlhuwKwlVdU1
 UAsDfdzka5c/8R6jSfqZAOtxqrF3sWb5+CRYIfY9EL/+phX4RhDTxJKT1BO5pHPTYR1k
 fxXTYBb9kgrmzPKpgw9GKqSRQ5hvlxWlweftTu0Q9G5eaVLj6I+ooPTk+H0MMEpbFXMo
 f+ER1N4nuFT1F4WSwfp35dekPy4XgcZqB/FM/tQgwuYCGxh5wKA5FoaSXrqIYkgUbgeI
 PAHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=g2JE1NchR5OuOuOibWq+8/K2CyWjv7Vlzl0jcmmyHKg=;
 b=spkvEfUIMNcIDZtFpCIHAfJhkeInR3PA1FWu7uZfBQ9kqzWiRu+/0FDT9hSqosBMjA
 iiBNjf2ogzK2pbR643HJjkO4BWaMl6GmOKIVM0nJz7+Qnk5VEYhV6XXWChDn18YoLLzL
 GfA4zXrMnEPIHPH7O40KFt988H2ut3Q2TDw7pU6W7RoatsAgOt0Pg79/MApd1K6QXUgA
 aGTqxv7pyTdd1grT8ia31hkwVtqIN4R6m2Pg7iJArYZrBzdKcC5MNwXzCaWEu+JAGr9I
 +YMqv0sWkA6kuFcs8v4pNCB0kddPyqUnn4MrFNavm9BaS2rxr67BHU3lr8w7l5wxSk94
 PwyA==
X-Gm-Message-State: AOAM532ePub29pXgd8MiZXKdYcUaHuXoJqZWgkp3gZ8xn7tRdP02ARnI
 nHHPLCtfSD8RfdVFp3vMcXGNzx/OjE0=
X-Google-Smtp-Source: ABdhPJxEVZZh8c79kJBVhyomHBKtGxgWv7d32Tr+YGvJXzn/bVGhXaf6aJM8D0LQz8M/cEOUCA1R/OXLlBc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2c7:b0:142:f06:e5fa
 with SMTP id
 n7-20020a170902d2c700b001420f06e5famr12493355plc.87.1635985601544; Wed, 03
 Nov 2021 17:26:41 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:26 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-26-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 25/30] KVM: s390: Introduce kvm_s390_get_gfn_end()
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

And use it where s390 code would just access the memslot with the highest
gfn directly.

No functional change intended.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/kvm/kvm-s390.c |  2 +-
 arch/s390/kvm/kvm-s390.h | 12 ++++++++++++
 arch/s390/kvm/pv.c       |  4 +---
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 4e032e176216..f7cc0853866b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2012,7 +2012,7 @@ static int kvm_s390_get_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
 	if (!ms)
 		return 0;
 	next_gfn = kvm_s390_next_dirty_cmma(slots, cur_gfn + 1);
-	mem_end = slots->memslots[0].base_gfn + slots->memslots[0].npages;
+	mem_end = kvm_s390_get_gfn_end(slots);
 
 	while (args->count < bufsize) {
 		hva = gfn_to_hva(kvm, cur_gfn);
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 52bc8fbaa60a..207d299d7fea 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -208,6 +208,18 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
 	return kvm->arch.user_cpu_state_ctrl != 0;
 }
 
+/* get the end gfn of the last (highest gfn) memslot */
+static inline unsigned long kvm_s390_get_gfn_end(struct kvm_memslots *slots)
+{
+	struct kvm_memory_slot *ms;
+
+	if (WARN_ON(!slots->used_slots))
+		return 0;
+
+	ms = slots->memslots;
+	return ms->base_gfn + ms->npages;
+}
+
 /* implemented in pv.c */
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
 int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index c8841f476e91..e51cccfded25 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -117,7 +117,6 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	unsigned long base = uv_info.guest_base_stor_len;
 	unsigned long virt = uv_info.guest_virt_var_stor_len;
 	unsigned long npages = 0, vlen = 0;
-	struct kvm_memory_slot *memslot;
 
 	kvm->arch.pv.stor_var = NULL;
 	kvm->arch.pv.stor_base = __get_free_pages(GFP_KERNEL_ACCOUNT, get_order(base));
@@ -131,8 +130,7 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	 * Slots are sorted by GFN
 	 */
 	mutex_lock(&kvm->slots_lock);
-	memslot = kvm_memslots(kvm)->memslots;
-	npages = memslot->base_gfn + memslot->npages;
+	npages = kvm_s390_get_gfn_end(kvm_memslots(kvm));
 	mutex_unlock(&kvm->slots_lock);
 
 	kvm->arch.pv.guest_len = npages * PAGE_SIZE;
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
