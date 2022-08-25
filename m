Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 421C5C28D13
	for <kvmarm@archiver.kernel.org>; Thu, 25 Aug 2022 05:10:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E73774E2E0;
	Thu, 25 Aug 2022 01:10:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H7B4pVUw3ie3; Thu, 25 Aug 2022 01:10:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8BFF4E2E2;
	Thu, 25 Aug 2022 01:10:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 851304E2C7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:10:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0UT5byYGVKHh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 01:10:21 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4AA324E2D8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:10:21 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-33352499223so325301307b3.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 22:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=EmnP6URNfHv6I0nbxGmg1XJ0KHdi317moIKFVeeAsc8=;
 b=odzh+413GPIsjI66IJBEHSOJ1TAozjY8/5h10hAgbwXYR+m8+Bq098asyIJO31M6XX
 FG6XQOp4j4ukN2HsJ06YJmmH7orlAaws2A+dvnD8GzU49lsEM59llnl7vYysAlJjgJkB
 Z9sSIQCG/bNvPvmJkwVn3TuSSS3HX7RGRbtoLkCPKctFswbbcSHV14tjLpeVjQWTS/3U
 74fuO1j9abX4bH4TwtyH1divYl7Kc0o51RcxSyPowqEfdSqwcMMuUC8p7UUGhR3wso3K
 bgUqyEQlUfxjPBGEj9/3GzXGK/Y/DNJHWiAHHQS6DuztTtwkFMrAa/O5D1XFFaAaC9wU
 XO+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=EmnP6URNfHv6I0nbxGmg1XJ0KHdi317moIKFVeeAsc8=;
 b=7V7QekhvzxIC/CgdQvIpWNyYkds8Nh2x1Ms31DyMMJmR/y8mFFlAqTkZKa6fDKEPGl
 lrZqZ3ZaJzkhXpctWSIXah1L/+qKCNqYYwBXtqk7j9mt2f8SHVYh19BSe2+NShlhjTBo
 KmSdNlYjmjxo4Nizu1a3JV8z7/8l3tlspV+gcNkkg7VieVeU6TbL3tPC3eUj9QC2etrZ
 PpOO5iqSFxv+mEeEk7btVl8Q8i8Xudz15jhnuVIGDdFCYu5dlGCZQqEVD6/jnWUqFytU
 6fDopQHzoaq00KppA6LiFQX7ojCOeMn1rjthZy4kYujeRqpG+vN8i7qGR0oGFYoU1y0F
 plmQ==
X-Gm-Message-State: ACgBeo3yjmlGBqK9NfWomDL0ROuK7m7r4EviDBbA+gh8rjbxW4ufOKeo
 Si+6aYxx8ej2qIvR5cTQk+vSmN/Or1s=
X-Google-Smtp-Source: AA6agR4ONormzDuDs7YpdVMH6kwTbayc6AXSuIT5cwIOH9liK5R8puxixgYLfHyko+rG1K4Ic3X2+t6qTmc=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a5b:dd2:0:b0:695:7965:1747 with SMTP id
 t18-20020a5b0dd2000000b0069579651747mr1981297ybr.415.1661404221149; Wed, 24
 Aug 2022 22:10:21 -0700 (PDT)
Date: Wed, 24 Aug 2022 22:08:43 -0700
In-Reply-To: <20220825050846.3418868-1-reijiw@google.com>
Message-Id: <20220825050846.3418868-7-reijiw@google.com>
Mime-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 6/9] KVM: arm64: selftests: Change debug_version() to take
 ID_AA64DFR0_EL1
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
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

Change debug_version() to take the ID_AA64DFR0_EL1 value instead of
vcpu as an argument, and change its callsite to read ID_AA64DFR0_EL1
(and pass it to debug_version()).
Subsequent patches will reuse the register value in the callsite.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 17b17359ac41..ab8860e3a9fa 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -315,11 +315,8 @@ static void guest_svc_handler(struct ex_regs *regs)
 	svc_addr = regs->pc;
 }
 
-static int debug_version(struct kvm_vcpu *vcpu)
+static int debug_version(uint64_t id_aa64dfr0)
 {
-	uint64_t id_aa64dfr0;
-
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
 	return cpuid_get_ufield(id_aa64dfr0, ID_AA64DFR0_DEBUGVER_SHIFT);
 }
 
@@ -329,6 +326,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage;
+	uint64_t aa64dfr0;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	ucall_init(vm, NULL);
@@ -336,7 +334,8 @@ int main(int argc, char *argv[])
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
 
-	__TEST_REQUIRE(debug_version(vcpu) >= 6,
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
+	__TEST_REQUIRE(debug_version(aa64dfr0) >= 6,
 		       "Armv8 debug architecture not supported.");
 
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
