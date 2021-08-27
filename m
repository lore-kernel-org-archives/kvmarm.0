Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73F7C432BE
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 57E4060FD9
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 57E4060FD9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2D064B0F7;
	Fri, 27 Aug 2021 03:50:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0KhtTFOk7h1J; Fri, 27 Aug 2021 03:49:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AA994B177;
	Fri, 27 Aug 2021 03:49:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D62304B10A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 20:57:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YMOYR7UlBrmS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Aug 2021 20:57:48 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9DB44B11B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 20:57:47 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 j9-20020a2581490000b02905897d81c63fso1770237ybm.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 17:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=AFHcFLQ8Zudn3D234yQQ371MlX0hPffSTnop5clNbU4=;
 b=ehODs2sAzX4fmqGdkUXhOCuacyAsZ5WG5XMN79bjP+xq4RU4v9fT+sBLKRTlQqGWyX
 q30luLe7UbUT+k5DL/N9U4aU2TEa+qPeGqAJxEBE/FVgE0CuiF3raXC1RXOK3ImBGaQ4
 XbKMz4w/DkAC9W9hss3rUtWCAWdzbERpB661AM+dQQmPgaw7Ftx+tH6bG8AYsTaZ9CDU
 e02FAinIj3+x9EA64fOdiwehQIAyNOzTqpYk8MnCh+cFqm78JcgPcKiioGpdAXvwto5l
 kIPH0qjJWMM4k2bYrS2zDHxLCqBbRaCfrumPTD8MLrYqYErmy2b3iS7uHQauGeKAtamE
 EuYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=AFHcFLQ8Zudn3D234yQQ371MlX0hPffSTnop5clNbU4=;
 b=V5awy1aRjdpxARmHKXpp5ahR5QR/Ay5OBPWaAqQY+gKDIGZ0o2FbkuMNKvrypAW7la
 8dlYTohztv914CW9NbCzGraPtJr/HO8uSiRJLX/SdN6Ntw//ZFHWbpfmmvseNksfx10o
 uFFE1qPBaP19IHvdqFH3MP84qWQrCvSciWTeti2hnk+vmXUu3u9txARQ9GXSUX+FNulB
 2XCYFpRxkUCMOZ1TInc0mQ4wScBEKAj09F3fhb9XVtoa8SxMJvkh/YNgSYWvJXIGyrQ2
 HcxvchO7q8209s2Nt3OyidNsJvUgA7hVsCaTtBjtDsHjFkIc4pcaQrQW6bg1dkwkaa8U
 kmTg==
X-Gm-Message-State: AOAM533zjGjbn7OhUIxJ+nALuwoCsa5rQDNru2O6ZSjAhBtgD67k+fea
 VinXC2TERa2IF9rMyO9s3xkuQYqm9Dc=
X-Google-Smtp-Source: ABdhPJxdtTMoWPCFq9FJTrWuwV5L/MyoyJcLiUL8JKOdEyDnebSuapnzs9qVktMCvhy616hB+yWZoBPXnlo=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:c16c:db05:96b2:1475])
 (user=seanjc job=sendgmr) by 2002:a25:7a03:: with SMTP id
 v3mr2037918ybc.202.1630025867497; 
 Thu, 26 Aug 2021 17:57:47 -0700 (PDT)
Date: Thu, 26 Aug 2021 17:57:11 -0700
In-Reply-To: <20210827005718.585190-1-seanjc@google.com>
Message-Id: <20210827005718.585190-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210827005718.585190-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 08/15] KVM: x86: Drop current_vcpu in favor of kvm_running_vcpu
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

Now that KVM registers perf callbacks only when the CPU is "in guest",
use kvm_running_vcpu instead of current_vcpu to retrieve the associated
vCPU and drop current_vcpu.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 12 +++++-------
 arch/x86/kvm/x86.h |  4 ----
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d4d91944fde7..e337aef60793 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8264,17 +8264,15 @@ static void kvm_timer_init(void)
 			  kvmclock_cpu_online, kvmclock_cpu_down_prep);
 }
 
-DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
-EXPORT_PER_CPU_SYMBOL_GPL(current_vcpu);
-
 static int kvm_is_in_guest(void)
 {
-	return __this_cpu_read(current_vcpu) != NULL;
+	/* x86's callbacks are registered only when handling a guest NMI. */
+	return true;
 }
 
 static int kvm_is_user_mode(void)
 {
-	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 	if (WARN_ON_ONCE(!vcpu))
 		return 0;
@@ -8284,7 +8282,7 @@ static int kvm_is_user_mode(void)
 
 static unsigned long kvm_get_guest_ip(void)
 {
-	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 	if (WARN_ON_ONCE(!vcpu))
 		return 0;
@@ -8294,7 +8292,7 @@ static unsigned long kvm_get_guest_ip(void)
 
 static void kvm_handle_intel_pt_intr(void)
 {
-	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 	if (WARN_ON_ONCE(!vcpu))
 		return;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4c5ba4128b38..f13f15d2fab8 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -393,11 +393,8 @@ static inline void kvm_unregister_perf_callbacks(void)
 	__perf_unregister_guest_info_callbacks();
 }
 
-DECLARE_PER_CPU(struct kvm_vcpu *, current_vcpu);
-
 static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu, bool is_nmi)
 {
-	__this_cpu_write(current_vcpu, vcpu);
 	WRITE_ONCE(vcpu->arch.handling_nmi_from_guest, is_nmi);
 
 	kvm_register_perf_callbacks();
@@ -408,7 +405,6 @@ static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
 	kvm_unregister_perf_callbacks();
 
 	WRITE_ONCE(vcpu->arch.handling_nmi_from_guest, false);
-	__this_cpu_write(current_vcpu, NULL);
 }
 
 
-- 
2.33.0.259.gc128427fd7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
