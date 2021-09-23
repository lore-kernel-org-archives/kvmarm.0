Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 551E1C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0CD8D6124C
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0CD8D6124C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B80634B11A;
	Thu, 23 Sep 2021 15:16:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l0qGHe6gOJBz; Thu, 23 Sep 2021 15:16:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BC534B172;
	Thu, 23 Sep 2021 15:16:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89EB14B14D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7YsQn2Lw8g1B for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 15:16:27 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35E344B16C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:26 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 b9-20020a5b07890000b0290558245b7eabso296530ybq.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 12:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=U2ldqwBk17qF8sMmjm/VY0u4QjSaXwIWBiVrOhl2aZs=;
 b=aEtYZFNlk3fZGcGLyul66+37tVVs2OtdlmTMOFzR2aXZyttrz3WoXvPMSl5r59JVyr
 lIofk16aP6VLef+gS0F9CkKgZ7hABCK+Rh/V2Q+sWPWMS+M9XxMjtl7tcNtzpH/L+9Ga
 kGqqY7A9jcOtnmWYAO7yMEtvU5mkYU18D5imyfI12VJ7u3J0LuQ00migBbwJ2pCVXJYl
 5nB5RpbcYqwQw63BrLFwNwTf77KzNWCJfFpdtlHyTeTJ2WGrfUIHUxaTI7SKZ9auWh5z
 rH7CwUiKVqJwjr35Q8nYg2SrDlg2hIQxRq5uu25QIr15QI4z7yYrQyG5ITq+tTcqrKIP
 ogNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=U2ldqwBk17qF8sMmjm/VY0u4QjSaXwIWBiVrOhl2aZs=;
 b=Piw69SborxjqUBlhYxy9mr4zeRlemgTCOrdcgsVFZk418zpxXKAynU2pJGVr30eSDV
 GdU+QF2ghcPD+yrxaUpqjXMEKf8Af8CXoZLuHQzWOSHf510zjdX2KGrP6cOo5gM8f4XQ
 WXHNEd2WcFDEg1xgYzWqXvWhDvhjkwVbhJsZANj+vj8iJLrcuwiry952ZkKq9zlG1y2H
 Q8/qeucAS3nfhNFf2086wA0ZyHg1klqFhQpktGvJbbsTCm83NGdsIgGkkWgk0BmrFsM3
 pxYbalJDnsaM27WpMdrSxXEu2MQG8TqsDGTkOa7rofUZdolvO0/RnrLgsD48aysNi+YQ
 HVmQ==
X-Gm-Message-State: AOAM532QcauJqMI0hf2iqtzWyn5+v+KNkTqL4scFRDr8CbxmengJa6s1
 X8MFs827Q+ZYAqTF9eRO+n+n+CzPsklmQh7xkEm0GFdi0g41sQuKIj4m4wcXEDyIj9AwL9kSQPU
 uM9riDWMtraeN9YSAhQ75FpeQXGAh9vG1aIVKw+XbWjY15axKuMy05Dm6acG4jk68Habt3g==
X-Google-Smtp-Source: ABdhPJyqHXosu+dqAJLT4LzmBg3B50Oe9S3R7psdBVQf0KyXF99CbnJiJj78oOxsVMiagI2g5lP3Ar5SRqI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:c753:: with SMTP id
 w80mr7792105ybe.245.1632424585769; 
 Thu, 23 Sep 2021 12:16:25 -0700 (PDT)
Date: Thu, 23 Sep 2021 19:16:08 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-10-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 09/11] selftests: KVM: Use KVM_SET_MP_STATE to power off
 vCPU in psci_test
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>
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
index cebea7356e5a..8d043e12b137 100644
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
 
 	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
 	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
