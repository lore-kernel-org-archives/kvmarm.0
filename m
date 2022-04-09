Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D899C433FE
	for <kvmarm@archiver.kernel.org>; Sat,  9 Apr 2022 18:46:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F04C84B239;
	Sat,  9 Apr 2022 14:46:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w+ctHHy3wM0V; Sat,  9 Apr 2022 14:46:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87D984B1EC;
	Sat,  9 Apr 2022 14:46:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C48884B0ED
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZeJZqTYggCHk for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Apr 2022 14:46:11 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 514654B133
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:11 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 x6-20020a923006000000b002bea39c3974so7625075ile.12
 for <kvmarm@lists.cs.columbia.edu>; Sat, 09 Apr 2022 11:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=MMbJ8GPbxLd/QjbYzRi47+OsTy08VP9GXDUZhFt58o8=;
 b=UmbfA4iSxMPA8fk6qLLzD609587uXylxPvsJyjpO+zhYDsmK1Cc9jUcA/aAaWZRxCu
 tHA/r1//CW2+0IOUUQzAc1M+GSndHUAVcLcHEyWzIre8CytvdvXZQ5lzzX5pStECTyAD
 AKceZSRfgjd0ctaY+wtM8gqfEtoHvyI6hWHmdgOMXnRxlWFFZI7sAbL+xR5l8KbSPYI2
 oA/hxbNHLk18KnkaMdrRE4XFrFJ+BpwfQqp8YUf0b85zV8WdFPSOrW9J3TzBZUYo+rkg
 gs33Ks3C5NmgZ5zo5dPhEMcQG+itPRxbJT6gVqkXeRzo5kg2MY8SPKC2wHLeJR9UtFF2
 D8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=MMbJ8GPbxLd/QjbYzRi47+OsTy08VP9GXDUZhFt58o8=;
 b=jse4CTeWNcWUXpyIhpdbxM6g1f/Vc7f7U0T4yU1g+24PVI7HxwiW+YCamx0CXx0bPs
 RxxM9tMMt870mtPkvJP81bj7pTXolSuk9HPs4eI3vEsTksv3p49qT5jeFgdNDveimdQI
 Jh87S2L2xbLBDlVFJPBFYOie/z8QllAbk5PTICZ3wwDoNrEAcprgoQJ+Lea4kvk4Lsew
 MbW/WHxozFmtzKV3PDUH+p3F+2qryUdNoWhFqIQ1VIxNiY5Nf8sUxU2puB3SIm27KiDR
 SVIv1lxFBm9mbca6Tpd4rAjjzlELllXDAdceAi5Rwndqf/+gQAtMKyKPzloO62dJlqWl
 +apw==
X-Gm-Message-State: AOAM5316VNIf7hvKfLKj8wEX4YAtqr9onYIdwbcT/HW8yy5oyY6Kwpml
 s0xwIZ+Fx3O+5yNrkoHBkYp8yUsmJ6qX/lIkeJyhnypfoTecqBv/RMhk6xNPkuWeES2eyOFpkul
 M5hVSr/83bUzuDTjbqJboztFb1BbBqWfLjOC35pSusPDLstpl1ux3qPT6eahHfgQ0KbWaNg==
X-Google-Smtp-Source: ABdhPJxlH14Og43qv+kMIjC03b6Q3ltqRhEMdMCiQzsvYUfxJs6dhn0LzpS3eneC9kFiQWN4ueXFk59kq8Y=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:2b04:b0:645:102d:2f86
 with SMTP id
 p4-20020a0566022b0400b00645102d2f86mr10947073iov.153.1649529970585; Sat, 09
 Apr 2022 11:46:10 -0700 (PDT)
Date: Sat,  9 Apr 2022 18:45:47 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-12-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 11/13] selftests: KVM: Use KVM_SET_MP_STATE to power off
 vCPU in psci_test
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
 pshier@google.com, kvm-riscv@lists.infradead.org, atishp@atishpatra.org,
 pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com
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
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
