Return-Path: <SRS0=Cc05=O3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6765C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 23:35:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5443B61076
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 23:35:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5443B61076
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E93864B259;
	Thu,  7 Oct 2021 19:35:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u9byWwQCTe0c; Thu,  7 Oct 2021 19:35:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DD5A4B26A;
	Thu,  7 Oct 2021 19:35:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29DBF4B25C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 19:35:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tv6ZpxXnRWs3 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Oct 2021 19:35:12 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6054B4B238
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 19:35:12 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 n15-20020a170902e54f00b0013ed08c1bacso3925836plf.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Oct 2021 16:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=nkCzPFgOJztBJ0PQFO3yLXxYkMFo6+sOQFUA9flKBVo=;
 b=qIEp/mw1Fg8Yf1raio1KjNBQpvMThqVC27jDw7TFFKUVwmSmxIf9kcfbMtMb4xLuh1
 TqxDv3zeD7163ziETqd4Nlc/1v7wdrVWClnSpICosTfIwTLVD3nobC2rWO6b2BNvUePO
 gnLdM09pNNi21tdLYufksj4K1u4PWwI/PNtH9OS4gfhVoKR+//msDWyrzzE61xZUE8Vv
 RsmVezCne62HXXTub3gBKuC6dIRxtVonEv2VKxAu2YqQSARZ5UxP560D3vhniSVtIQSY
 UzxexI3EPgtXuHRYrn4pCwLA+GforI1Dd0poR8lm8m3+4iq/rs1m8m9cwZ8KEbgf+t8o
 x8kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=nkCzPFgOJztBJ0PQFO3yLXxYkMFo6+sOQFUA9flKBVo=;
 b=yd3yyD1QXvcJF89TYl+pDC7aPtHdvlYmarDgEehGY0jDmdGGv0NOSQh4gvuf703cVt
 7l/AvgmwCDqVxPUj06rBlSSmSXBeX6Wx5OL3MVtCRH9oQcx6KlOtnK4FEZFcFsl/Z6Qj
 IURsrxsib3e5OVlRZ2BWtkMbuLzdRNzr+h1OQsCADAUq9Us8q97ky9bycsT768E7Ea3F
 hlw+QlxMi3qJY0HoJ1tqiWoGFDfeu763TLhrs6pa0YQsOe9obRLzNA2NyWypygcqLk9H
 PKmp1Z3GWGhjp1gy1vP42U07Rb3YPvaFd9fv0L5D1Wbz7UFrKVAHtToDi0haN1Yiv/Pj
 tz4w==
X-Gm-Message-State: AOAM531Y4o+rFVJwfg2vggKTCgo004gTPhYm33ey4J6tzyul17wO8zRL
 4n3DeWsxXzYxy0xQFCLAm5skCWfGDv1U
X-Google-Smtp-Source: ABdhPJyF285C27p4CHJ8ZoPVE07j8+batfUwCNrzEr36gltXnfaZXtP8+IsE/rtmvNVJDMCV0IKk2/DYj4uR
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:b188:b029:11b:1549:da31 with SMTP
 id s8-20020a170902b188b029011b1549da31mr6330570plr.7.1633649711389; Thu, 07
 Oct 2021 16:35:11 -0700 (PDT)
Date: Thu,  7 Oct 2021 23:34:34 +0000
In-Reply-To: <20211007233439.1826892-1-rananta@google.com>
Message-Id: <20211007233439.1826892-11-rananta@google.com>
Mime-Version: 1.0
References: <20211007233439.1826892-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 10/15] KVM: arm64: selftests: Add guest support to get the
 vcpuid
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

At times, such as when in the interrupt handler, the guest wants
to get the vcpuid that it's running on to pull the per-cpu private
data. As a result, introduce guest_get_vcpuid() that returns the
vcpuid of the calling vcpu. The interface is architecture
independent, but defined only for arm64 as of now.

Suggested-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h      | 2 ++
 tools/testing/selftests/kvm/lib/aarch64/processor.c | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 010b59b13917..bcf05f5381ed 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -400,4 +400,6 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
 
+uint32_t guest_get_vcpuid(void);
+
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 34f6bd47661f..b4eeeafd2a70 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -277,6 +277,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init
 	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TCR_EL1), tcr_el1);
 	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
 	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TTBR0_EL1), vm->pgd);
+	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TPIDR_EL1), vcpuid);
 }
 
 void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
@@ -426,3 +427,8 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 	assert(vector < VECTOR_NUM);
 	handlers->exception_handlers[vector][0] = handler;
 }
+
+uint32_t guest_get_vcpuid(void)
+{
+	return read_sysreg(tpidr_el1);
+}
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
