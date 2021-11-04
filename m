Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4579EC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D260C611EE
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D260C611EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8159C4B0B8;
	Wed,  3 Nov 2021 20:26:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xflKJ0QZIMq3; Wed,  3 Nov 2021 20:26:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC58A4A3A5;
	Wed,  3 Nov 2021 20:26:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E0974B08F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ro9x1tHS1kJm for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:03 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE7C24B0A3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:03 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 i25-20020a631319000000b002cce0a43e94so2443778pgl.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=uUiF2cCeyvLcomA71gNb8UtnumiDOcYwDfMiXjWen6E=;
 b=oTQ7zxZOtJdIWwrRYuqPf1zjANoRXpGs4d18yx/1uFcULOqfGSPv/eGnnTHt2OaFXl
 Fw2Ja9jpx42JTWA+4xQHXaSDJzaLjB39qn72mpFaq/+8Pgyy1WE+Sui5ukzf7K0T1tch
 WQUzSIOcUqQ4RYGuYqINyp9t2Du3YpUpxuubgXkNzI9EfzqleZjWAUTMgOc4YeGCZQie
 KXx3n4rodQ4x96mmNgtB9r6T1WA9dTicsSrUIx+if+mPJuWUWAF+djp3CD78xEHLczgf
 /8ph947YIr/9EVIDN0A2sn1MabQLXDCtd3nrNdsi57mxIxM3VfxgHreQqgiovSN/aw02
 N1Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=uUiF2cCeyvLcomA71gNb8UtnumiDOcYwDfMiXjWen6E=;
 b=4F6k78fHdgtRMty41saZPRARxvN6skkc799vTCqD61BhaY/zTZF/WLzV1omWA8b+Gk
 rUtcfoOI0HY63qDJ5ufCIOG6eLS4FA1GmLMQ014T6xU7r977cI/oeF1LrUWeMrvM2YWR
 G/Pm4e/INlKJ6ZmtYFPrVKXpJxwww/CybFwskD457apaD2aTshLaTP9visYeDSq13os3
 GKyEDo5N3V6ozBCxlnDu5yEm5lj8W/Ve9m7uanpV60KNFX/5iA1B7rI43A6Kg2b7z1Pk
 /K02nHLj2s5JNg/QH8S0P4pkCPtu0LffhS6u/0kv857xa8xTqLl7zIz9hzeOLHja/Ujj
 8kkQ==
X-Gm-Message-State: AOAM532wIYtByZ64N+q/nUge9C6xyqoyTS2EO/nKowBkhLpW5PcuV5zE
 Z9HrJeuqLARoOvVo4PqkcnptKskHuvg=
X-Google-Smtp-Source: ABdhPJzS1sKm1vihVbRPixin8ADPxwIwiRu+sSSO0iFE9jTmdDmiJb4scGZK4H9WqPr37m1ISOQPandeoog=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2181:b0:44c:f4bc:2f74
 with SMTP id
 h1-20020a056a00218100b0044cf4bc2f74mr47622932pfi.68.1635985562987; Wed, 03
 Nov 2021 17:26:02 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:04 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-4-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 03/30] KVM: Require total number of memslot pages to fit
 in an unsigned long
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

Explicitly disallow creating more memslot pages than can fit in an
unsigned long, KVM doesn't correctly handle a total number of memslot
pages that doesn't fit in an unsigned long and remedying that would be a
waste of time.

For a 64-bit kernel, this is a nop as memslots are not allowed to overlap
in the gfn address space.

With a 32-bit kernel, userspace can at most address 3gb of virtual memory,
whereas wrapping the total number of pages would require 4tb+ of guest
physical memory.  Even with x86's second address space for SMM, userspace
would need to alias all of guest memory more than one _thousand_ times.
And on older x86 hardware with MAXPHYADDR < 43, the guest couldn't
actually access any of those aliases even if userspace lied about
guest.MAXPHYADDR.

On 390 and arm64, this is a nop as they don't support 32-bit hosts.

On x86, practically speaking this is simply acknowledging reality as the
existing kvm_mmu_calculate_default_mmu_pages() assumes the total number
of pages fits in an "unsigned long".

On PPC, this is likely a nop as every flavor of PPC KVM assumes gfns (and
gpas!) fit in unsigned long.  arch/powerpc/kvm/book3s_32_mmu_host.c goes
a step further and fails the build if CONFIG_PTE_64BIT=y, which
presumably means that it does't support 64-bit physical addresses.

On MIPS, this is also likely a nop as the core MMU helpers assume gpas
fit in unsigned long, e.g. see kvm_mips_##name##_pte.

And finally, RISC-V is a "don't care" as it doesn't exist in any release,
i.e. there is no established ABI to break.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 60a35d9fe259..d8e92d4a78d8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -551,6 +551,7 @@ struct kvm {
 	 */
 	struct mutex slots_arch_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
+	unsigned long nr_memslot_pages;
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 83287730389f..264c4b16520b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1623,6 +1623,15 @@ static int kvm_set_memslot(struct kvm *kvm,
 	update_memslots(slots, new, change);
 	slots = install_new_memslots(kvm, as_id, slots);
 
+	/*
+	 * Update the total number of memslot pages before calling the arch
+	 * hook so that architectures can consume the result directly.
+	 */
+	if (change == KVM_MR_DELETE)
+		kvm->nr_memslot_pages -= old.npages;
+	else if (change == KVM_MR_CREATE)
+		kvm->nr_memslot_pages += new->npages;
+
 	kvm_arch_commit_memory_region(kvm, mem, &old, new, change);
 
 	/* Free the old memslot's metadata.  Note, this is the full copy!!! */
@@ -1653,6 +1662,9 @@ static int kvm_delete_memslot(struct kvm *kvm,
 	if (!old->npages)
 		return -EINVAL;
 
+	if (WARN_ON_ONCE(kvm->nr_memslot_pages < old->npages))
+		return -EIO;
+
 	memset(&new, 0, sizeof(new));
 	new.id = old->id;
 	/*
@@ -1736,6 +1748,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (!old.npages) {
 		change = KVM_MR_CREATE;
 		new.dirty_bitmap = NULL;
+
+		/*
+		 * To simplify KVM internals, the total number of pages across
+		 * all memslots must fit in an unsigned long.
+		 */
+		if ((kvm->nr_memslot_pages + new.npages) < kvm->nr_memslot_pages)
+			return -EINVAL;
 	} else { /* Modify an existing slot. */
 		if ((new.userspace_addr != old.userspace_addr) ||
 		    (new.npages != old.npages) ||
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
