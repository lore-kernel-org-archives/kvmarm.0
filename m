Return-Path: <SRS0=Cc05=O3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3012AC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 23:35:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D5C6C61381
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 23:35:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D5C6C61381
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 777794B255;
	Thu,  7 Oct 2021 19:35:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2sj-FesmFqyd; Thu,  7 Oct 2021 19:35:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C00C4B25E;
	Thu,  7 Oct 2021 19:35:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1381D4B25A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 19:35:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P8lJeKbaket1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Oct 2021 19:35:12 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A1334086F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 19:35:10 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 u2-20020a17090add4200b001a04c270354so1620088pjv.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Oct 2021 16:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=3YTqSaquht49DYwV2xuwN1X0OlaTExbB3K3aGCLZvU4=;
 b=iWyDlCyt++mvNVjpsszZMVe3mrpU8G5zxbRwKZBxglKbMvcprMFNqT75wIu/ofn5d5
 lu0nTdWxnEubwCSc3gXsnw4gCeRt7s8eKxarEEnfGimMtNYqqtsALGYqmHmUt0+OA7BR
 EoHYaeNjZjRscVlw6dAkXJNM6chFPwlREiYoYa4lXmK9YrEt2CqjrnBVEUNVvufovVi9
 FLJ5zJpLGVEnIHwMhk7WUnxjoxA1Qk0eJYfTmg8XdDxsBYpB6g5WeTMyn4HeNjo4FGrP
 Ey/66+bshubWicxpL1Og+qwaNfnRpVZs9/n8t1uok9Gc8LZQ40TRSDMJ+vkH75eG6mQs
 4NXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=3YTqSaquht49DYwV2xuwN1X0OlaTExbB3K3aGCLZvU4=;
 b=BtTDjI7sPaolO7+z0+oPgSbs/D2muVpJuE1zpfIZlFMGbBd1DjBQXCS6bYyQubUnm1
 jqdYf4Ug60B0VkRZOdV4RjS8SAdMUH653/RIs8XyscbdFMyfHhla/qfoHheWYAfzGVv3
 18OVXyWzbcgpUpfry0NSqv9xt4PJSB9ZDVImYe4tGZMospswd0U7XjZRXeFBJw/1yP6L
 7jnWBJEV/AHGIixAXVckEnG1PMTq+ZVCWEEbNmmoPbr5ZuZ4Mg5s2osi2uRJ45eiT/en
 UBXUyq6EP4ukEg1TDWHBHiA07Rt7BQcAmyJF7AuKu6ojpOQTzHXojgb8Xh7sGTtqN0Rp
 jKhA==
X-Gm-Message-State: AOAM530Khm4i6xQ2ReAlblNcfFpI4AjQ1F7+ZDEvLwnpPCz6ckoy9t8A
 jpZ3NOLUg1QFRWRngiqFHZH60svPDcuq
X-Google-Smtp-Source: ABdhPJxa/UqZJH8wMTzMrpOdYqAB4XnezhGeu0Toy/yEJFz2+kvRBNn3w8lt6T7GB7p01L3yhlcFcVlfnFux
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a63:cd48:: with SMTP id
 a8mr2038837pgj.180.1633649709219; Thu, 07 Oct 2021 16:35:09 -0700 (PDT)
Date: Thu,  7 Oct 2021 23:34:33 +0000
In-Reply-To: <20211007233439.1826892-1-rananta@google.com>
Message-Id: <20211007233439.1826892-10-rananta@google.com>
Mime-Version: 1.0
References: <20211007233439.1826892-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 09/15] KVM: arm64: selftests: Maintain consistency for
 vcpuid type
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

The prototype of aarch64_vcpu_setup() accepts vcpuid as
'int', while the rest of the aarch64 (and struct vcpu)
carries it as 'uint32_t'. Hence, change the prototype
to make it consistent throughout the board.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/include/aarch64/processor.h | 2 +-
 tools/testing/selftests/kvm/lib/aarch64/processor.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 515d04a3c27d..27d8e1bb5b36 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -63,7 +63,7 @@ static inline void set_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id, uint
 	vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &reg);
 }
 
-void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *init);
+void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init *init);
 void aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid,
 			      struct kvm_vcpu_init *init, void *guest_code);
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index db64ee206064..34f6bd47661f 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -212,7 +212,7 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	}
 }
 
-void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *init)
+void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init *init)
 {
 	struct kvm_vcpu_init default_init = { .target = -1, };
 	uint64_t sctlr_el1, tcr_el1;
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
