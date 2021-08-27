Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A624C43214
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2062360F92
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2062360F92
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C84B94B144;
	Fri, 27 Aug 2021 03:50:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y1EVhu8BrHk0; Fri, 27 Aug 2021 03:50:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6FF64B193;
	Fri, 27 Aug 2021 03:49:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A71DA4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 20:57:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iU4Em6+p7m0A for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Aug 2021 20:57:56 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADCCB4B0F4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 20:57:56 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b198-20020a2534cf000000b0059bae206c16so4867273yba.18
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 17:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=O3P/C2+r50j2qd2oZl4HIFqUJ1Gm6eQIurE1pthLu88=;
 b=KoGI0t2ANmOACIY8bQhuBH4FJbrSHsRwhYJXWmn01ufiEJZVk4tPOEhaZ6T1MAQL+U
 jhUGDn7yZArl2k29+8gFqfCF2DSg2n6fTQ6je+tOvHWwtuk6IOGhYE1XQmYmAQV0Z6yb
 UcRXDhGukzYa0e3OogJgHIniy20AUzkgcDYnuJ9TMbdSfPm19k9DAbSEVKXLmzcP7bku
 dkqNoqFL3rJ6iAJ27Dy3HXfxWITTJ68h7TnziapcFth9ZxiSCsQJGqvRdjvidglqsZgx
 4yCjuWco92qzMYV8AJs3vnXk8sqdZ/Z/v4yFDjKSCTqWPBnhz4PL5zWola/ctdZ9nHLd
 axcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=O3P/C2+r50j2qd2oZl4HIFqUJ1Gm6eQIurE1pthLu88=;
 b=RvCLEwH1ClgnflzFphd1eT51vSeoYXCvptsHrEBJgH2EFcz58iaCaPtGfl/WIvxG+Y
 ZETBTelMarE7dIsretNvcvM8JggwGc5yqIHvVwQ1u18dZ+HoGwYcv7R+FSKxG/+kN+ko
 elqvOCUIY2gFNx1aGnbpluGC8lhaZEq6Ee9NKrikDeKLnnBZow7qmcluOJ2/A3lu9E9e
 ME5WClxwl7dlfekgeg1UOieqa0dHJ8QgQgs4jp0CYKxmKaTX2bzKs1sOw6N9vz1zrNlJ
 zpsWdq+V/jaY9vS4BJ838FoZABW92N9fvSW3Bf1ucjWwjG+8KN997Jq2Uc485wtU9Hmn
 A9ZA==
X-Gm-Message-State: AOAM532FDbyA6JXmNPoBANBrlRq7VCQxjDZIqG0hmXx3aYIBK8xrH5Qh
 kagmd4zPjFdUpupZ1csBvXYYOzu9mfU=
X-Google-Smtp-Source: ABdhPJyKjk6geoVg3b6/+yDfPSeW/L1PMiXY41SolyC47I84TPxrPvrL+bKgY05p4LEuynGQ+EFAFv5UkSk=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:c16c:db05:96b2:1475])
 (user=seanjc job=sendgmr) by 2002:a25:dcd3:: with SMTP id
 y202mr2039489ybe.161.1630025876285; 
 Thu, 26 Aug 2021 17:57:56 -0700 (PDT)
Date: Thu, 26 Aug 2021 17:57:15 -0700
In-Reply-To: <20210827005718.585190-1-seanjc@google.com>
Message-Id: <20210827005718.585190-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210827005718.585190-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 12/15] KVM: arm64: Convert to the generic perf callbacks
From: Sean Christopherson <seanjc@google.com>
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, 
 Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>, 
 Greentime Hu <green.hu@gmail.com>, Vincent Chen <deanbo422@gmail.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Thomas Gleixner <tglx@linutronix.de>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, 
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>
X-Mailman-Approved-At: Fri, 27 Aug 2021 03:49:31 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Jiri Olsa <jolsa@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Stefano Stabellini <sstabellini@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 linux-csky@vger.kernel.org, xen-devel@lists.xenproject.org,
 Zhu Lingshan <lingshan.zhu@intel.com>, Namhyung Kim <namhyung@kernel.org>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Like Xu <like.xu.linux@gmail.com>, Sean Christopherson <seanjc@google.com>,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Drop arm64's version of the callbacks in favor of the callbacks provided
by generic KVM, which are semantically identical.  Implement the "get ip"
hook as needed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  6 +----
 arch/arm64/kvm/arm.c              |  5 ++++
 arch/arm64/kvm/perf.c             | 38 -------------------------------
 3 files changed, 6 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 007c38d77fd9..12e8d789e1ac 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -673,11 +673,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa);
 void kvm_perf_init(void);
 
 #ifdef CONFIG_PERF_EVENTS
-void kvm_register_perf_callbacks(void);
-static inline void kvm_unregister_perf_callbacks(void)
-{
-	__perf_unregister_guest_info_callbacks();
-}
+#define __KVM_WANT_PERF_CALLBACKS
 #else
 static inline void kvm_register_perf_callbacks(void) {}
 static inline void kvm_unregister_perf_callbacks(void) {}
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ec386971030d..dfc8078dd4f9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -503,6 +503,11 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 	return vcpu_mode_priv(vcpu);
 }
 
+unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
+{
+	return *vcpu_pc(vcpu);
+}
+
 /* Just ensure a guest exit from a particular CPU */
 static void exit_vm_noop(void *info)
 {
diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
index 2556b0a3b096..ad9fdc2f2f70 100644
--- a/arch/arm64/kvm/perf.c
+++ b/arch/arm64/kvm/perf.c
@@ -13,44 +13,6 @@
 
 DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
 
-#ifdef CONFIG_PERF_EVENTS
-static int kvm_is_in_guest(void)
-{
-	return true;
-}
-
-static int kvm_is_user_mode(void)
-{
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
-
-	if (WARN_ON_ONCE(!vcpu))
-		return 0;
-
-	return !vcpu_mode_priv(vcpu);
-}
-
-static unsigned long kvm_get_guest_ip(void)
-{
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
-
-	if (WARN_ON_ONCE(!vcpu))
-		return 0;
-
-	return *vcpu_pc(vcpu);
-}
-
-static struct perf_guest_info_callbacks kvm_guest_cbs = {
-	.is_in_guest	= kvm_is_in_guest,
-	.is_user_mode	= kvm_is_user_mode,
-	.get_guest_ip	= kvm_get_guest_ip,
-};
-
-void kvm_register_perf_callbacks(void)
-{
-	__perf_register_guest_info_callbacks(&kvm_guest_cbs);
-}
-#endif /* CONFIG_PERF_EVENTS*/
-
 void kvm_perf_init(void)
 {
 	if (kvm_pmu_probe_pmuver() != 0xf && !is_protected_kvm_enabled())
-- 
2.33.0.259.gc128427fd7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
