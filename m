Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2583C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 04:20:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EF3F4C318;
	Tue, 22 Feb 2022 23:20:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RkaV3cy1smAX; Tue, 22 Feb 2022 23:20:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F4144C3F8;
	Tue, 22 Feb 2022 23:20:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A813E4C369
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id udSgjd2g5CBg for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 23:19:58 -0500 (EST)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D7444C3EE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:58 -0500 (EST)
Received: by mail-il1-f201.google.com with SMTP id
 x6-20020a923006000000b002bea39c3974so11803390ile.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 20:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=mNL+HTBUZ2MsABidwZFWaxMTNZTxqHsDRZZiQtVvY9U=;
 b=AnT6yz+jzBN+vZRmnnU3kjwLqiu3bJDpwtLDuddpuszcgrqzqhSXZ5D1upnUqYuCgs
 cXEK3U2pvCizUZ0UOIi8jHCh1VfC1GrM2HmD4ZnPWkMB9rZYWd1Enk2vqA2A5xy9wsxO
 E+mzny0LNc3xOzqkH6jLQ6R6qWfKPKw5X6meGW7xSAAj4zTNi3xO+sqccqedCgV8qCga
 fRhznPV4YXuu1WR1IUaOU8J9Rn4uHJd5964/doZzZDIhtH9+RsKPPYkg27TRddFJFG4Z
 n0CAbnRU8DaEdayNrTP6vjkeXhqvahh7ZEHhS4VszZ1JckMmkqsx3O8STOTwXgaHOQ6A
 4s2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=mNL+HTBUZ2MsABidwZFWaxMTNZTxqHsDRZZiQtVvY9U=;
 b=NljvbfXkaWHCrVy+x6xJFHQy7AMpGRhzIgRU/kE3fil80wnYntMr4xKoVQ/MdBhjBf
 MojgT2Eq+3JtYEYeNyzPAs3TDPaP3K4MgxbuoeF8iGORHUaasZMMzbJ7A2VXj7tHRGDg
 g2VtI0cu3MYzekZw81qI6FNM3HJErSGpVtnivrrVYHWxlEiAHwwadFkje+Ao9SFiYq4r
 RM6WrL2J7G0e38rxomiPH82NhOMFKTLogo5Ta1jORJNGjujaaL7FnQw6fZG8scB66og4
 V5JCb211+K7n+WG5IQMyIJtSnGZrubYER1ERmxgmggh+TZgP+YXGZlDu/ia1v8oTs5RG
 C0qA==
X-Gm-Message-State: AOAM533PGd29Xt0kDNEG7Z3VR1HRvh2sRVWw0uxhZ8gAY7DIM8HB049n
 aK3blwNFwsvjBhbzYPxeGppj9nuAbAcevIUl92u3PpDqrzmECLDw0zX11dqLQSRu7cGGweS5rHG
 q2FwWtlN1BMqDnVaHWx3f9n9S3T9ujeNfKduZKAJHGBGkJODtgsofjRP3qW6Kp7podWP0cQ==
X-Google-Smtp-Source: ABdhPJw0kP0Dlf52lvVcBVnZ85OYD33u0JUbWlmw8FKgmBU6fU3nlvm/brYHvzUYLCy9kdMtFX8SXw/pFCk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:b048:0:b0:311:85be:a797 with
 SMTP id
 q8-20020a02b048000000b0031185bea797mr21012184jah.284.1645589997820; Tue, 22
 Feb 2022 20:19:57 -0800 (PST)
Date: Wed, 23 Feb 2022 04:18:42 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-18-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 17/19] selftests: KVM: Use KVM_SET_MP_STATE to power off
 vCPU in psci_test
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Atish Patra <atishp@atishpatra.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>
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

Setting a vCPU's MP state to KVM_MP_STATE_STOPPED has the effect of
powering off the vCPU. Rather than using the vCPU init feature flag, use
the KVM_SET_MP_STATE ioctl to power off the target vCPU.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/aarch64/psci_test.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 8c998f0b802c..fe1d5d343a2f 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -60,6 +60,15 @@ static void guest_main(uint64_t target_cpu)
 	GUEST_DONE();
 }
 
+static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	struct kvm_mp_state mp_state = {
+		.mp_state = KVM_MP_STATE_STOPPED,
+	};
+
+	vcpu_set_mp_state(vm, vcpuid, &mp_state);
+}
+
 int main(void)
 {
 	uint64_t target_mpidr, obs_pc, obs_x0;
@@ -75,12 +84,12 @@ int main(void)
 	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
 
 	aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_main);
+	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
 
 	/*
 	 * make sure the target is already off when executing the test.
 	 */
-	init.features[0] |= (1 << KVM_ARM_VCPU_POWER_OFF);
-	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
+	vcpu_power_off(vm, VCPU_ID_TARGET);
 
 	get_reg(vm, VCPU_ID_TARGET, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &target_mpidr);
 	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
