Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08564C43219
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:41:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA26549ED3;
	Fri, 11 Mar 2022 12:41:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ltbyRkleXYFX; Fri, 11 Mar 2022 12:41:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2120549E48;
	Fri, 11 Mar 2022 12:41:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1F6640AEA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O8+siubLnmGT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:41:16 -0500 (EST)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A91049ED8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:14 -0500 (EST)
Received: by mail-io1-f74.google.com with SMTP id
 w25-20020a6bd619000000b00640ddd0ad11so6774451ioa.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=OfvwPno/vdVeaI3Bj5TBXZDiFhwzoDjkPKpMT+kPSsg=;
 b=Z1f4KpYaERqF+Z8wu4YaA3FqS4uUe0o489BvF9qQu+m5jAdV0e2lMnn0bKzZiIFKyu
 X9L0LQInEbA43NtmcasH163uIOWEZHF3m9b1oFQ+1LaU4nvjnfGfZTIHgK5xa8joRgCu
 U5boVyiFvKsnlsC95lZ8jC9d8iyyZSrkS6SVwlS2nJh7p3Ido7dU9sc6ZRyMyHxJmau0
 i8N6iXnmHtU2hFZEQmx8s9+B31O6AD4yFPqMS1Nhpn2SBevF+B/EsO+kow7ntN2w8Ct7
 CBaCCGL/lP8tkCaikzq/yHBUzh5uGWOOQ7sObzGy/4p6HA3MQwYcM7CsC78SX91YbDz5
 DpHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=OfvwPno/vdVeaI3Bj5TBXZDiFhwzoDjkPKpMT+kPSsg=;
 b=powRCer5cUF6H4ZsYVKKOV6+mH38KFx+LCe/gf29cfKQevFKs5/Ao5+Yehazm83idW
 tfZOV5u3q+6nL7/Q2tlDiKyqQUFHMSBGEkawjdIIKRyMo9oAFsuH9MmCwiJ+QSPDPQHB
 Lgq89ylar305jcgfE+ggXZp8SmrcF6uL7pMvOf5vhDBdK0PfKDQEKg8fBK5FPJmFUSU9
 jVZWQKQmT6GNjfdmcvPE/y9BzKW7B46lr0nMTw02wB3h+UYNy8MZivp1B6qnh85e02XE
 mPB//U2DTLnaWEnCPTWIfBZKpAo4kwFUfWROacexN6kWzqEMHrA0aHzdc/nhHSdCkdn6
 es+w==
X-Gm-Message-State: AOAM5330HMfxOTFzWxPIRjQsFzDmHUQw8XrD1aDVHOVtC1CUqbh5WDpI
 rpUPCxUwjyQHpW4iea9zkprzekQWgqo1iuAmj8YEAXb+xBSalNSJlYIYh+Pl6kC9kG/Cbo/CuAP
 ouXKqVRf1xKc5nwhlRCnwYe1eOr2BhL3cqOvnpdF8wMlTD9GGTmIp9jaUkeFwWELcalpwFA==
X-Google-Smtp-Source: ABdhPJxU4o6d12HlS+cwJHR6AnNPMTg+5NGTOavt5pmb+N5rymKdGyajtqzZmyUeSPjQs3h26Wf1GyDGFoA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:dcf:b0:319:e022:ad6c
 with SMTP id
 m15-20020a0566380dcf00b00319e022ad6cmr1001835jaj.143.1647020474006; Fri, 11
 Mar 2022 09:41:14 -0800 (PST)
Date: Fri, 11 Mar 2022 17:39:59 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-14-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 13/15] selftests: KVM: Use KVM_SET_MP_STATE to power off
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
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
