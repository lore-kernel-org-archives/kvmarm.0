Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5495AC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Apr 2022 15:23:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB98D4B1F5;
	Tue, 26 Apr 2022 11:23:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O1Jxyvhxj8CC; Tue, 26 Apr 2022 11:23:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79CC94B1C9;
	Tue, 26 Apr 2022 11:23:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 058444B1C7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 01:39:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iS-YXyelrHWg for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 01:39:21 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 95CE74B1BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 01:39:21 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 k12-20020a63f00c000000b003aa33c2696eso10375525pgh.20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 22:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=75ck2E1viXT4HNKGmhZGUqApOq35yGNlgD3kbgrzKrw=;
 b=j/6W1Jv8f36ZodhL68vNcySdndUH2oV1c5OzKpRXYolTLJgwBi7OaIg/S/yKMnJp+b
 lqqaZUm1JBr3oQixRNwaNTgB81/saUAppnPAjz68yxAbmgh4igyoOQ92n9+HzD+TEgqv
 ajW2TFBTyLuEXXVz0pJuHgyUGpGRZnhkjtQoBS+4am6LkE8kl60VYw6Q/6q6/jo9xQNu
 GX4i53uLVaKJIRtdwjxSSMxM+nKgqH6qhEODIoJjq5XuOby3Ip1qDLu+YxucaAIrUMzY
 Psb6biLd1G6xVSJaPjnJffEREeUS4oL482CYqW+UsriFD7QsTwFn/nDOVqJKFywwwAfj
 8XNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=75ck2E1viXT4HNKGmhZGUqApOq35yGNlgD3kbgrzKrw=;
 b=GlmbV5lnR2pDg208ZbA3TFpWRLT35Qz4lnFNBxPanP84sS6eCE6dBEPN9M9zJNywwj
 tfRYMk/BI+IYbm77xw5nvdAqIi3Na2krYhj3vWRRt+GTn4wpuALhrgR0xoDU8Cydptd7
 J/ks+Xmu6LkI+VTHy6vEWvh3oHNXxdVsmoQtYQ7a9XjRBlINPV6NpnydAYrEnPEFTjw8
 dU7+9lHFq3bQnmY0iTVr4SiOioNu+SaSnk1ObaOa+UlC7PNtJ1cWS7hJACsu6nE6tjeg
 mpy7ToPdtk/jpEBzKLrvu64r5MeA38gWa9s6BCcdTaKDHll/7gvyc95jy7EyrQmBQZRC
 AYWQ==
X-Gm-Message-State: AOAM533dIrQi32LC4yuwkx9NCObZyuXOMMqmKCcUw5NastOUKzuwV/ce
 NzKXfp44W/asElX4OKCWpwLQasrOXlsfoU6Z
X-Google-Smtp-Source: ABdhPJz+02KDDV9V68suFOiQPkifF2E9mLN9n/bWhK+6QOZ7ZJ3fdHfj/Lkck5hrYAftknNAaw0TdY1+WqYFvIkS
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by
 2002:a17:902:9881:b0:158:f258:c3c3 with SMTP
 id s1-20020a170902988100b00158f258c3c3mr21548367plp.7.1650951560612; Mon, 25
 Apr 2022 22:39:20 -0700 (PDT)
Date: Tue, 26 Apr 2022 05:39:00 +0000
In-Reply-To: <20220426053904.3684293-1-yosryahmed@google.com>
Message-Id: <20220426053904.3684293-3-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220426053904.3684293-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v3 2/6] KVM: mmu: add a helper to account page table pages
 used by KVM.
From: Yosry Ahmed <yosryahmed@google.com>
To: Sean Christopherson <seanjc@google.com>,
 Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, 
 Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
 Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeelb@google.com>, James Morse <james.morse@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Marc Zyngier <maz@kernel.org>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
X-Mailman-Approved-At: Tue, 26 Apr 2022 11:23:27 -0400
Cc: kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>,
 linux-mm@kvack.org, kvm-riscv@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
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

Add a helper to account pages used by KVM for page tables as pagetable
stats. This function will be used by subsequent patches in different
archs.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 include/linux/kvm_host.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 252ee4a61b58..54cc4634053c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2221,6 +2221,15 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+/*
+ * If nr > 1, we assume virt is the address of the first page of a block of
+ * pages that were allocated together (i.e accounted together).
+ */
+static inline void kvm_account_pgtable_pages(void *virt, int nr)
+{
+	mod_lruvec_page_state(virt_to_page(virt), NR_SECONDARY_PAGETABLE, nr);
+}
+
 /*
  * This defines how many reserved entries we want to keep before we
  * kick the vcpu to the userspace to avoid dirty ring full.  This
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
