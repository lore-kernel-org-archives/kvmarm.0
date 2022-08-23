Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1687C3F6B0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 00:46:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7AAF4CF22;
	Mon, 22 Aug 2022 20:46:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NcoF5iUPNzRk; Mon, 22 Aug 2022 20:46:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0179E4CF19;
	Mon, 22 Aug 2022 20:46:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DD514CF16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 20:46:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UvIIutsYd84R for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Aug 2022 20:46:47 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4D494CF1D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 20:46:47 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 r74-20020a632b4d000000b0041bc393913eso5428301pgr.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 17:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=5wbHjJjCu3OWrOn0g8QSFmD92QscX6sNHkdnPnrNJvc=;
 b=GGOXmJOAwFS6LKwoOWp4bp7t6wNw/r+7YZKC8GNGkd18DnlB6LfP9CL34RL2KPfceG
 AXZl8PPfPtapEOLbCmJ/rNGm5f6yciTGJoywKkjojZNxw+GL1YEMWcjzDhmGBCk/MdMy
 4t7Q1LoMp7rN7dy2pMFqxMAJGP7jixHUwhGq1q/8ObLjXUCDxT+pRv0n8APeUo1COdXm
 hZwjDYvOa5gy4NpGGIl+jhzRr9f9Ii2wUpWXASQIPm5HwhVrZhUzyQI6uum045xl3TUP
 3jXo+RDzJG2rD4y1NqG9xsCTA/WKZF3fW3AxCEi9F87GMBLRezoaX2KOatGvk8ccetqZ
 Mr+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=5wbHjJjCu3OWrOn0g8QSFmD92QscX6sNHkdnPnrNJvc=;
 b=NDz6m53HgzNhNeA+slqaHCmoarUN0Uh7SZsgMh3iPfhL2zeZ2mPPiF4b4vOn7YniNk
 P9LTGTWV/+9cuSzAnHdHnSo9PFZpJId9+JlTowg4APZ7AY+q8DwcyiaKASfAiVKI/+WB
 BXIsiUxKedKSgiTRKMqnUy6SAFf1FVCg3FI/K7Bg03nBabY//YcjvicEF017Tly1y5Y3
 8S0xaKfUMXTM33zdbjhDjjvABnxzHnPo0sGQdbHWjKpeKoqxBLYvZVvNmqTvFqvf/hG/
 RThjP8GNzGSo4+OWpE/CeeWf47GEFt3QRIaiJ2dtMyT6s1W1P1nO/OovIPF1fTFJ9Ant
 1zMA==
X-Gm-Message-State: ACgBeo1rp6Z3LUsr79cjQ1T7RsTG8BgPUbr85NI1BDV+SK9BB37Ps8Ej
 47BA6X4SvfYphIY5vL2YsIkw5+RVu5OxCfo4
X-Google-Smtp-Source: AA6agR4dQrwU/uwhH/YBd8bM5leaexCVvoGHCx2rlR/Vt0DcZKu7/ZnqA8s5ncAFX9MqU3Pk76hGv0BKG2GC/oz4
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by
 2002:a05:6a00:15cb:b0:52e:6100:e7a7 with
 SMTP id o11-20020a056a0015cb00b0052e6100e7a7mr22724154pfu.23.1661215606877;
 Mon, 22 Aug 2022 17:46:46 -0700 (PDT)
Date: Tue, 23 Aug 2022 00:46:37 +0000
In-Reply-To: <20220823004639.2387269-1-yosryahmed@google.com>
Message-Id: <20220823004639.2387269-3-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220823004639.2387269-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v7 2/4] KVM: mmu: add a helper to account memory used by KVM
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
Acked-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/kvm_host.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f4519d3689e1..04c7e5f2f727 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2247,6 +2247,19 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+/*
+ * If more than one page is being (un)accounted, @virt must be the address of
+ * the first page of a block of pages what were allocated together (i.e
+ * accounted together).
+ *
+ * kvm_account_pgtable_pages() is thread-safe because mod_lruvec_page_state()
+ * is thread-safe.
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
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
