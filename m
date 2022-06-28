Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E95A3CCA47C
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jun 2022 09:13:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93E7C4B4ED;
	Wed, 29 Jun 2022 05:13:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V3PZT+RxrU3B; Wed, 29 Jun 2022 05:13:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F1134B553;
	Wed, 29 Jun 2022 05:13:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F3534B495
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2022 18:09:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 95ndk2hzn3oY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jun 2022 18:09:47 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C9BB64B32C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2022 18:09:47 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 37-20020a630a25000000b003fdcbe1ffc8so7275455pgk.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2022 15:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=hqFBlBT797q6Bk+fNjYVKQU7mV5jV3ma9qnt5KK3uBo=;
 b=JEAq+g+yt98HJQFYcbZo11EgdQCrTknULQcgOojyYtX5/1qIJPFoMDpUb0JvS07kBs
 UBB0lOj3a7XuYN+RxZH7OqEQNbrIbIfwbCX+Napc1EFMPMrzrqRPrpv6TLBnEGIk4l6e
 D8NTKSe14qutuJxDTg6f/mJOdQOL1xHUrqnK3PlzvOfoI2lI6HUiSSkGIdpK0f7vh6H4
 6O9GKuEoHUyXKiAyRapcd/Jdby2QsOa/y878lIAO/AkXQnUJ/iuK6p0Jig+0f5ZboxYv
 e9Ap/B7iZODIQKB3o8NbA9y6v8baiPB6zs+62vjyZxY29inV33HeqiOuSq0QsRfR0U2q
 Gycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=hqFBlBT797q6Bk+fNjYVKQU7mV5jV3ma9qnt5KK3uBo=;
 b=ntA9KL+DsejEJY6V6EBszr88u4BW5lT7pq0SBXDBY/44PWfKI8NtP1IIfwrLJe7qWd
 BKn1cdZJ4QW1a35yBP8pK1ZVtQ6qD28u4D3tfkYL5pEYVpOB3/gPky5qWTckfSkHa7K2
 hsXQ9j5wSWYddbQtbF4IenR+SZ9lTLisI0euH8OMX5ZFLjLBDC6pcrTd7r9oQJiOAf5/
 L2lv3xC6P3V8/sHRxDWWB9BPjc2vKp+SqSsgWBjJj5m6QtrVVDPWgnYM55dyQlVsCn4x
 lLUjAyd4R+HIBk71MfaSlEMcuyPbxw/2QEOWU4gnPjWocXxKxZxydt1+7L5OXd1POTm1
 +Kgg==
X-Gm-Message-State: AJIora967ZnDaHr4XzuOS+Y0wT9+k8HEyE5Ga/yKIxLfBVd8R3XgzBkz
 PVDr8fBNKwT+lwNxp5qCcla6QygLIPUXRD9i
X-Google-Smtp-Source: AGRyM1smcFnstKabQ4toVMOHujMO/7vgP/k20+XUxS7A/7XLJg4mWmkTw/RyJ8/gkqU1w7+Eoe95tXVR0LKZACoL
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by
 2002:a05:6a00:15d6:b0:525:3757:4b98 with
 SMTP id o22-20020a056a0015d600b0052537574b98mr6883216pfu.64.1656454186604;
 Tue, 28 Jun 2022 15:09:46 -0700 (PDT)
Date: Tue, 28 Jun 2022 22:09:36 +0000
In-Reply-To: <20220628220938.3657876-1-yosryahmed@google.com>
Message-Id: <20220628220938.3657876-3-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220628220938.3657876-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v6 2/4] KVM: mmu: add a helper to account memory used by KVM
 MMU.
From: Yosry Ahmed <yosryahmed@google.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Wed, 29 Jun 2022 05:13:43 -0400
Cc: Yosry Ahmed <yosryahmed@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Huang@google.com,
 Shaoqin <shaoqin.huang@intel.com>, linux-mm@kvack.org, cgroups@vger.kernel.org,
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

Add a helper to account pages used by KVM for page tables in memory
secondary pagetable stats. This function will be used by subsequent
patches in different archs.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 include/linux/kvm_host.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3b40f8d68fbb1..032821d77e920 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2241,6 +2241,16 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+/*
+ * If more than one page is being (un)accounted, @virt must be the address of
+ * the first page of a block of pages what were allocated together (i.e
+ * accounted together).
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
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
