Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE89C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 03:25:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8E184B20A;
	Tue,  3 May 2022 23:25:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZXHoKNnjwe-C; Tue,  3 May 2022 23:25:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADF184B1C7;
	Tue,  3 May 2022 23:25:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 024F24B17D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:25:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vzcj7sjSshcq for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 23:25:11 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ACD954B1BD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:25:10 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 y17-20020a637d11000000b003ab06870074so91082pgc.15
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 20:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=vC3V+2CBJIc1C3R9s0y8nQnpmWBf83eXJD/GXiFHTxk=;
 b=i8yg46C8ANIA2EeY47SlTmObZ07geosP5go76P5bWKcOMH+uyUCxbwt2Kk168LIZHI
 LCNQZ3JxYIR6TmH+z2dqzuWIzq9GEKZ9n8W3JhDZXCRzh9m6SY2QF49N9xrhjOKjwHCg
 WIQDqZfNFaPw/Cod7ereFSUKrvtslwg2TmcmogERVoq2xsGKHFhX5xqeexzxnHIIyIGL
 BgPIoNlIoFuoWxdieMBrNc8F3m5kh9R9WSQifwTdGoUmhuZ7v86yEkdFWi0q9n88CFVd
 +i1Hw4yEvtj2vHYZ7/sgTOgNDW6jj2KLz2QNUJ/FSbyJkqgusc+FLhyoyF6Fquf/kbfR
 cXNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=vC3V+2CBJIc1C3R9s0y8nQnpmWBf83eXJD/GXiFHTxk=;
 b=4gIHDyKbiJs2Ro3DGBF7t6LUL3KhhRiJU6k+Wo37KUKOmdQxNCdL1TRaZJ/8ZbVi3v
 gUDStZgsP05kpvDQ1Au4QSbDxce6OJnfhRrXBIFK4a1UlEOsGKFpi5Ut2m4VCMuz3IHJ
 gS/oFaHg9Y5FBn9LBU26IM2kBNgPto6I8OjJhgWzq0f+R/zbDQqGDpZqN9Sjn7qu+0HU
 bCTHppIvAnNtMsGEpuTiN5IiZNTiLIRkbvHsDyKFOOXJQYyOFiylMw0umS/F81FLu2On
 NFtbpmvcJdGizRZFCHXZszCV5rI6g3LF2mZTyRWx+NmjEp9yqAPFp/Q7ZNZWidjFxgHH
 gB2Q==
X-Gm-Message-State: AOAM530H3Ho/QXdvHeeyokkqqKAfYwm4vRdd4ozMtH7MRbqkbaPGwHpt
 y1aarXn67mdZVsDsvr4efyIG4si+0sNjLlRKeTDY/A//3KT7Z1C6Oty316AJRtYCoI8j2cctA2p
 6Oc35UyCuidSg/e+nheMBlqXtG86OosrMkJ7LG9Ht6YCGVyrvAXX5A8IFVosWX57TgqeyYg==
X-Google-Smtp-Source: ABdhPJym7VaWlC5x9ioDgbuAXxdKjWGCuRNU6ZzBqtt+v8vwKT5s0AloQM3OscjKyqjYn0lPOfjYJrrWKWI=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:90a:dd45:b0:1bc:9466:9b64 with SMTP id
 u5-20020a17090add4500b001bc94669b64mr8262744pjv.23.1651634709842; Tue, 03 May
 2022 20:25:09 -0700 (PDT)
Date: Wed,  4 May 2022 03:24:44 +0000
In-Reply-To: <20220504032446.4133305-1-oupton@google.com>
Message-Id: <20220504032446.4133305-11-oupton@google.com>
Mime-Version: 1.0
References: <20220504032446.4133305-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 10/12] selftests: KVM: Use KVM_SET_MP_STATE to power off
 vCPU in psci_test
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
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
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
