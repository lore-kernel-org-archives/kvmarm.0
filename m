Return-Path: <SRS0=nF4w=P6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FCFC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 02:07:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 13168619A6
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 02:07:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 13168619A6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5F804B162;
	Wed, 10 Nov 2021 21:07:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dl48F2wrzk8q; Wed, 10 Nov 2021 21:07:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34AC24B1FE;
	Wed, 10 Nov 2021 21:07:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38EC84B1F8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 21:07:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XqpNh53LUeim for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 21:07:46 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E8384B15A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 21:07:45 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 76-20020a63054f000000b002c9284978aaso2490006pgf.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 18:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=hK/bb2+8SYaruhoQBxjUMD9dzEtjE9dODoHgmaxXM04=;
 b=ioMgfZT9xO/74nIuEa5s079HZzqYDthukPpMRSdF0C3awDBWthDsWqAFo50b69aUgk
 Nhl7hmTYeB+KSKGuShd9pnZgSHEJ4YdF59a3n2gw+3Am+iHw8BnPD9PQEuIObPEX1zet
 XT5oCTwKFkgZjUeOaAP52YI/QxstVIlhlvJS+3cp25s9mkhbYvGe1eTarbKtvSx415JI
 ECVQms8ylbLIS/A+wF3YHJcodbwqtGvWDNxp9OhyCccF49POD6LZ1YDg80r7wc3jC1/x
 2UeOF3HXehBTuQGieAJ2PQ8fh4iSC2ZmT1gzNp9Gsi+Io2TQjCObkIi6pMuDLYQvs7JU
 qJOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=hK/bb2+8SYaruhoQBxjUMD9dzEtjE9dODoHgmaxXM04=;
 b=gfxYg1wizuvPSxLWXy+bGCn3JwHWMsrASMZRYoi3htMb9NaaNqxjVtMPegmzKBpkjl
 WwYEhDXk25DiDAtWJdCr3Qp5Dxi9FHtGOK2cqP6b81uPrkHoz+BMv30+zvqbKBtM4pJq
 Rw54dJ3tS8OAJrtY4qtoXQ6cakqPPTtKB6fYjBpMoWmipNprRfzo034T3oKZG2tNEKc0
 izi83CVBWBIVFqU4e9j/hbQ2M0RCTZjW9tHSRvSsZk4b8QpzVP8ApXfI0gkWysZ48CB+
 +Xc2JB8OZpJewlx3HZX1otRxljG/S+cIC6NFKF1PXebcCW2wVcbvkBWhEACZZOy1kc4d
 9Bxw==
X-Gm-Message-State: AOAM53291wZxQS2UzR79vpeaQcnoW0QEh+wstjLC69YqgGKHoMeWXl6V
 E31FFEFPu2fsLNYp8agGQ7rS7TkFTn8=
X-Google-Smtp-Source: ABdhPJyQu0wj6xnqaOSUJnCa9iYYs/0X0i20LUCAU5FW0hNQJqyaWntSFAsP1Erw+w1uVAuo6SyrzLgxEvw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1822:b0:49f:c55b:6235
 with SMTP id
 y34-20020a056a00182200b0049fc55b6235mr3668521pfa.66.1636596464117; Wed, 10
 Nov 2021 18:07:44 -0800 (PST)
Date: Thu, 11 Nov 2021 02:07:23 +0000
In-Reply-To: <20211111020738.2512932-1-seanjc@google.com>
Message-Id: <20211111020738.2512932-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211111020738.2512932-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH v4 02/17] KVM: x86: Register perf callbacks after calling
 vendor's hardware_setup()
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, 
 Russell King <linux@armlinux.org.uk>, Marc Zyngier <maz@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>, 
 Nick Hu <nickhu@andestech.com>, Greentime Hu <green.hu@gmail.com>, 
 Vincent Chen <deanbo422@gmail.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 Paolo Bonzini <pbonzini@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
 Juergen Gross <jgross@suse.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Jiri Olsa <jolsa@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Stefano Stabellini <sstabellini@kernel.org>, Like Xu <like.xu@linux.intel.com>,
 Joerg Roedel <joro@8bytes.org>, linux-csky@vger.kernel.org,
 xen-devel@lists.xenproject.org, Zhu Lingshan <lingshan.zhu@intel.com>,
 Namhyung Kim <namhyung@kernel.org>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Like Xu <like.xu.linux@gmail.com>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
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

Wait to register perf callbacks until after doing vendor hardaware setup.
VMX's hardware_setup() configures Intel Processor Trace (PT) mode, and a
future fix to register the Intel PT guest interrupt hook if and only if
Intel PT is exposed to the guest will consume the configured PT mode.

Delaying registration to hardware setup is effectively a nop as KVM's perf
hooks all pivot on the per-CPU current_vcpu, which is non-NULL only when
KVM is handling an IRQ/NMI in a VM-Exit path.  I.e. current_vcpu will be
NULL throughout both kvm_arch_init() and kvm_arch_hardware_setup().

Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Artem Kashkanov <artem.kashkanov@intel.com>
Cc: stable@vger.kernel.org
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c1c4e2b05a63..021b2c1ac9f0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8567,8 +8567,6 @@ int kvm_arch_init(void *opaque)
 
 	kvm_timer_init();
 
-	perf_register_guest_info_callbacks(&kvm_guest_cbs);
-
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
@@ -8600,7 +8598,6 @@ void kvm_arch_exit(void)
 		clear_hv_tscchange_cb();
 #endif
 	kvm_lapic_exit();
-	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
 
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
@@ -11149,6 +11146,8 @@ int kvm_arch_hardware_setup(void *opaque)
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 	kvm_ops_static_call_update();
 
+	perf_register_guest_info_callbacks(&kvm_guest_cbs);
+
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
 
@@ -11176,6 +11175,8 @@ int kvm_arch_hardware_setup(void *opaque)
 
 void kvm_arch_hardware_unsetup(void)
 {
+	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
+
 	static_call(kvm_x86_hardware_unsetup)();
 }
 
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
