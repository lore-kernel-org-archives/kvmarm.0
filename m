Return-Path: <SRS0=sbHD=OG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6627DC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DF805611C4
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DF805611C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80A384B152;
	Thu, 16 Sep 2021 14:15:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZIyN+TFnZLB1; Thu, 16 Sep 2021 14:15:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B4B14B14D;
	Thu, 16 Sep 2021 14:15:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06C6D4B0C2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uw9c+ZgPPOKF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 14:15:25 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 281684B09C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:25 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 n17-20020a922611000000b0023db5ee1cafso13952778ile.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 11:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=3RpJBwIvRP9pmK/0Ce4ZApsRskzFPqH6cQQcNE1phYg=;
 b=brVRcKUDjW8YWhMj164gJJN+u3N/rXel6jjJ5VBvfnF+snrEiDXqSxLCK7g/dXcKSU
 isij6yZK2ghEM3fGjLNp1Ax3lKItUBY2kW727t071Acxg6Tw3DZg+ybJp04yYhlXnsSu
 BiFb3KJctoL6l237QYRTTW0GFqEiyB1tmfJArBth9Dyf3ZbYQ0SQqphiN2fPOXnE4CB8
 2pXo84ot9H0u/o+BQrhifCAEI3qgCMICMYWl2nnTuRP01Eyh+VxxzVmtOFVge4JpiAIN
 Wf3KFTvJNuKnb0c3szNCcD7tvxyTTibMBC+y2eMjNA4cKjSI7h0hQN+luMXWtK+2BLQf
 fNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=3RpJBwIvRP9pmK/0Ce4ZApsRskzFPqH6cQQcNE1phYg=;
 b=6lk3VEutEQA1MNX06CtbnYI1Fy9v2XEHBol/hKEU+fg0v1du2npwmtEpDwBY39q3Gx
 6OZeF03Dq1sCyQiYYK/Ab+Z3AUCOoQO83xf24qUglY2lScN4dw9zdlfKt6NaC/9VlwaV
 BbS0MImwBwzukJiTQDdmAn6jnRXxoCOCWQDzprTzoOTh8qprvBsxu/MvHKIbD7V03u09
 /HtlXb5UfuR1/EMyDQoID6LbFCYOyNFijRiLx45YLxiiSaViMzrcAn0PVCXLjy18kbK2
 ABKSCdUHQ/PwtoGQixH4SWPVTVc/gHoVeIiAgkLiTxEiTCOsHmpuyDVAJGVVtPoBi6pm
 iRag==
X-Gm-Message-State: AOAM530hjmcI6qQJ9XB+VgdOlySeAG1QOqX0eiqtlGwya0cHD+bu3Hzv
 TskzG9tyIMirakIomb613LiloIpoyWA=
X-Google-Smtp-Source: ABdhPJx6QoYMzNxz6Jr/FocYXQ2V8gW6BZoL4oAcigjXW7DAc1ZNeN6gOx2OC7wUVtKB/0HOuOb+sGiXNOA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:16d4:: with SMTP id
 g20mr5478616jat.22.1631816124631; Thu, 16 Sep 2021 11:15:24 -0700 (PDT)
Date: Thu, 16 Sep 2021 18:15:03 +0000
In-Reply-To: <20210916181510.963449-1-oupton@google.com>
Message-Id: <20210916181510.963449-2-oupton@google.com>
Mime-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 1/8] KVM: arm64: Refactor update_vtimer_cntvoff()
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

Make the implementation of update_vtimer_cntvoff() generic w.r.t. guest
timer context and spin off into a new helper method for later use.
Require callers of this new helper method to grab the kvm lock
beforehand.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/arch_timer.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 3df67c127489..c0101db75ad4 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -747,22 +747,32 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-/* Make the updates of cntvoff for all vtimer contexts atomic */
-static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
+/* Make offset updates for all timer contexts atomic */
+static void update_timer_offset(struct kvm_vcpu *vcpu,
+				enum kvm_arch_timers timer, u64 offset)
 {
 	int i;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_vcpu *tmp;
 
-	mutex_lock(&kvm->lock);
+	lockdep_assert_held(&kvm->lock);
+
 	kvm_for_each_vcpu(i, tmp, kvm)
-		timer_set_offset(vcpu_vtimer(tmp), cntvoff);
+		timer_set_offset(vcpu_get_timer(tmp, timer), offset);
 
 	/*
 	 * When called from the vcpu create path, the CPU being created is not
 	 * included in the loop above, so we just set it here as well.
 	 */
-	timer_set_offset(vcpu_vtimer(vcpu), cntvoff);
+	timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
+}
+
+static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	mutex_lock(&kvm->lock);
+	update_timer_offset(vcpu, TIMER_VTIMER, cntvoff);
 	mutex_unlock(&kvm->lock);
 }
 
-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
