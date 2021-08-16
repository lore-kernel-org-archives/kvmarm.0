Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F77C4338F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:13:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D6A206137D
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:13:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D6A206137D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88CD84B0B6;
	Sun, 15 Aug 2021 20:13:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kEk0pjb0FohS; Sun, 15 Aug 2021 20:13:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E50254B148;
	Sun, 15 Aug 2021 20:13:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9379E4B108
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:13:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IWab91cFZ7s4 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Aug 2021 20:13:04 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AAA564B126
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:58 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 n4-20020a056e021ba400b0022481cdc803so575737ili.15
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 17:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=LDn71X/mteHSm80S6t26TyxwkEj27LrlTf7lB/WnK0E=;
 b=tFGja0lkfeepK+FkjFeq/aVGW+mKNcPoNNlqpTMnu0V3vovCmctbotfMUDQjFSAcD4
 6HOZbhkVK/AJkuPU4vE4cvo6B1mF3aDEYLG107YqyjKseSoClfb8cG4UAZjnRyke0Ce+
 WkIpMN+ybYGn2RRLaX7uoEOw+pTWEzeY7aTzSFVuig04pceKNl0TVXOGaDRVgK2a8Vhr
 2DXYsb5DVrL2L3qN297jolFCHfD3H6kPSjk+gIA/ush9nBL2y5iojzV6Yx6PC74aeADD
 Cak/sRa9pm9NFS5qTT+cpb8hE/wID6LMeB6ol1Ypc7u2S47YZbKgp0UUN7W+RYGywGaI
 mVRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=LDn71X/mteHSm80S6t26TyxwkEj27LrlTf7lB/WnK0E=;
 b=P5VaghtC/TSnZDJkFcnETXEnPXnPvpfDWVQlf4hUEIrKoivMJ5aHAPSExpEPCvFII4
 YFTTtmRkg1i1ZEBAKmXDkvkKjEYnzDY3pKuY2vuYCH7iLOvb+TpPHYBECL2bw/7GWRqx
 Jv+yFG3g17cV7KRJVfzFYSLPVDU/N7ZRJqryqsm9FzI0jaIPR0L7NEZHpdDAG3hRXGcO
 cxIFEL7NBnuOY26oHbI8Wy6jzVCZG41VJT+r/MXOi1kQc7ONZgXRSVNTVeaSonIfbK4E
 7/49Bq8UQxkRl++WYgLw2bnwivMTk9wYYlQVPya5rGKa2Ph36KYyd2g66cKiy2G7KGuM
 AFMg==
X-Gm-Message-State: AOAM531F0hwEWzhz8QyPu4cjV1ZZ7ukQxrof48ILOf82wzaCV9CWnAd5
 dE4bkzm8kCMTpbIJw/JqumUIUKZ65Bg=
X-Google-Smtp-Source: ABdhPJxBGSNKp7nAwuyx4V4ZkrlD3NGCg0jwXeIu/+7/9/7758jjyZKMe4CTsweb4Xrvpxd+DmoDyTn6Lyo=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:fb07:: with SMTP id
 h7mr3843368iog.201.1629072778180; 
 Sun, 15 Aug 2021 17:12:58 -0700 (PDT)
Date: Mon, 16 Aug 2021 00:12:43 +0000
In-Reply-To: <20210816001246.3067312-1-oupton@google.com>
Message-Id: <20210816001246.3067312-7-oupton@google.com>
Mime-Version: 1.0
References: <20210816001246.3067312-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 6/9] selftests: KVM: Add helper to check for register
 presence
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

The KVM_GET_REG_LIST vCPU ioctl returns a list of supported registers
for a given vCPU. Add a helper to check if a register exists in the list
of supported registers.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 1b3ef5757819..077082dd2ca7 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -215,6 +215,8 @@ void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid,
 		  struct kvm_fpu *fpu);
 void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid,
 		  struct kvm_fpu *fpu);
+
+bool vcpu_has_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t reg_id);
 void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
 void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
 #ifdef __KVM_HAVE_VCPU_EVENTS
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 0fe66ca6139a..a5801d4ed37d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1823,6 +1823,25 @@ void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
 		    ret, errno, strerror(errno));
 }
 
+bool vcpu_has_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t reg_id)
+{
+	struct kvm_reg_list *list;
+	bool ret = false;
+	uint64_t i;
+
+	list = vcpu_get_reg_list(vm, vcpuid);
+
+	for (i = 0; i < list->n; i++) {
+		if (list->reg[i] == reg_id) {
+			ret = true;
+			break;
+		}
+	}
+
+	free(list);
+	return ret;
+}
+
 void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
 {
 	int ret;
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
