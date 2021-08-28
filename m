Return-Path: <SRS0=Klgp=NT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82405C432BE
	for <kvmarm@archiver.kernel.org>; Sat, 28 Aug 2021 09:21:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3430760E76
	for <kvmarm@archiver.kernel.org>; Sat, 28 Aug 2021 09:21:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3430760E76
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA0BE4B10D;
	Sat, 28 Aug 2021 05:21:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GJ5C0sS0zyef; Sat, 28 Aug 2021 05:21:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D1514B158;
	Sat, 28 Aug 2021 05:20:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEF6A4B0DD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 20:36:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 76JIVA5jLFEH for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 20:36:32 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB4B74B133
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 20:36:32 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 f64-20020a2538430000b0290593bfc4b046so8277192yba.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 17:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=oqmEir0ICv/3G92ai+heTZuDyr/2G3d8WRYAGw86atk=;
 b=PcPAOihT8OlOhhUR4O32+YWwPzAPmLXJ1HEV+moJpFC1Qy84KcVrj+ajHpTlQK+a3F
 iyxUIoBJmALw6qqcNEgkIBWBH6GlQPAe+u7xlbyeAychGYyySNpy/bvcaaDuenDkzBb1
 Tjlhu6cHuXug1LfrtevGrfztVaOuMtHQ1BbUdWdKfT8tes9/0JNecwDm/BWfVrT79Qhh
 U/SjMl4oOYlt5v38Pnm8Mc6W1SnA5LO9EWqHnie5e5sXhbuMbSanMYmcJC2M9uljBuiN
 FTc3AiajdilK67F7Z2gaOx4+/6EEfK+b8GQmcjFFKC29NzjAngrdpD9yW51Odds/BoDr
 blsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=oqmEir0ICv/3G92ai+heTZuDyr/2G3d8WRYAGw86atk=;
 b=Wht1E6wZRMXXJCuSJ/4jPbHhlzw7z/+NTxVniE3vECtOLkKXsrdz+OZ6Nk8sY6HkOk
 ECgYqpVQTTd8T6zkkwWPSsnIeZgHkBWoWlaeowh/1IvUh/RovvKUXsMiic3UbnK2lOvA
 SbUWS/GzGHAohOllhBVdtaoiFLQ13+9liHUOiAkyiFrTm1uNQWkYwmaglsCsOviE3SFq
 MsaKetLBO0zUQ9/ukSuXilk2flBkNAayBQ3Uq5ZaaHRa1Evy0QMr8AzH9uXINo0P/0sb
 SPe+8g8gVOFhgfIjHkrpN9DcS1H46I/pKuTXSPH5W6JKcmjdyVSaOod0AtV7PzA7Sibs
 wHtQ==
X-Gm-Message-State: AOAM531hXcaRn/ry04xQHtOEETh13I62O8TTAi6LGfHbMaaXuZ4Ut+j8
 PHdGnoLdAD4MgefVTcJobDNeapk+nFI=
X-Google-Smtp-Source: ABdhPJyTmAQoKJ2tjPvfJaPWBN34/RS1O5zwXSkZLsm9h521rPpR1j//umIRZ/UqerB16AfCO1AGIAPsHvE=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:f66c:b851:7e79:7ed4])
 (user=seanjc job=sendgmr) by 2002:a25:4545:: with SMTP id
 s66mr8318615yba.191.1630110992229; 
 Fri, 27 Aug 2021 17:36:32 -0700 (PDT)
Date: Fri, 27 Aug 2021 17:35:48 -0700
In-Reply-To: <20210828003558.713983-1-seanjc@google.com>
Message-Id: <20210828003558.713983-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210828003558.713983-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v2 03/13] KVM: x86: Register Processor Trace interrupt hook
 iff PT enabled in guest
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Guo Ren <guoren@kernel.org>, 
 Nick Hu <nickhu@andestech.com>, Greentime Hu <green.hu@gmail.com>, 
 Vincent Chen <deanbo422@gmail.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
 x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
 Juergen Gross <jgross@suse.com>
X-Mailman-Approved-At: Sat, 28 Aug 2021 05:20:53 -0400
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

Override the Processor Trace (PT) interrupt handler for guest mode if and
only if PT is configured for host+guest mode, i.e. is being used
independently by both host and guest.  If PT is configured for system
mode, the host fully controls PT and must handle all events.

Fixes: 8479e04e7d6b ("KVM: x86: Inject PMI for KVM guest")
Cc: stable@vger.kernel.org
Cc: Like Xu <like.xu.linux@gmail.com>
Reported-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reported-by: Artem Kashkanov <artem.kashkanov@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/vmx.c          | 1 +
 arch/x86/kvm/x86.c              | 5 ++++-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 09b256db394a..1ea4943a73d7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1494,6 +1494,7 @@ struct kvm_x86_init_ops {
 	int (*disabled_by_bios)(void);
 	int (*check_processor_compatibility)(void);
 	int (*hardware_setup)(void);
+	bool (*intel_pt_intr_in_guest)(void);
 
 	struct kvm_x86_ops *runtime_ops;
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fada1055f325..f19d72136f77 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7896,6 +7896,7 @@ static struct kvm_x86_init_ops vmx_init_ops __initdata = {
 	.disabled_by_bios = vmx_disabled_by_bios,
 	.check_processor_compatibility = vmx_check_processor_compat,
 	.hardware_setup = hardware_setup,
+	.intel_pt_intr_in_guest = vmx_pt_mode_is_host_guest,
 
 	.runtime_ops = &vmx_x86_ops,
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb6015f97f9e..ffc6c2d73508 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8305,7 +8305,7 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
 	.is_in_guest		= kvm_is_in_guest,
 	.is_user_mode		= kvm_is_user_mode,
 	.get_guest_ip		= kvm_get_guest_ip,
-	.handle_intel_pt_intr	= kvm_handle_intel_pt_intr,
+	.handle_intel_pt_intr	= NULL,
 };
 
 #ifdef CONFIG_X86_64
@@ -11061,6 +11061,8 @@ int kvm_arch_hardware_setup(void *opaque)
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 	kvm_ops_static_call_update();
 
+	if (ops->intel_pt_intr_in_guest && ops->intel_pt_intr_in_guest())
+		kvm_guest_cbs.handle_intel_pt_intr = kvm_handle_intel_pt_intr;
 	perf_register_guest_info_callbacks(&kvm_guest_cbs);
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
@@ -11091,6 +11093,7 @@ int kvm_arch_hardware_setup(void *opaque)
 void kvm_arch_hardware_unsetup(void)
 {
 	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
+	kvm_guest_cbs.handle_intel_pt_intr = NULL;
 
 	static_call(kvm_x86_hardware_unsetup)();
 }
-- 
2.33.0.259.gc128427fd7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
