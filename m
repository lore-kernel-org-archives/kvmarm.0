Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CCFC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 15:59:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8F6D26101A
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 15:59:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8F6D26101A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42C824B16E;
	Fri,  8 Oct 2021 11:59:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OXAOceaO06iT; Fri,  8 Oct 2021 11:59:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 233634B0B3;
	Fri,  8 Oct 2021 11:59:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD5494B13E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 11:59:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sMqCgXX6Lc2j for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 11:58:59 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 450304B152
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 11:58:59 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 r16-20020adfbb10000000b00160958ed8acso7663086wrg.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 08:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=0Epvk7fyUEu9mwVCJWkvWNY079YeUJZah0Cu5fJzAEQ=;
 b=bkkZXWvHXy0SOvqcTVfyEyTMLdSxme3xzkLNnyVMQIKtMfHOw9o7FMlaTNpoQbHd0l
 573fiZ7H6X+7w+Zvl0W1v4/zGGqX39Q83L4+hHRwBUywjjLL+i3JCoXI7V8XbSF1aWhf
 ag8Oow9SDCDz1pgQydp+eSPRLes0FCw9tuQ9WxdZ54V97xvUXFjOMrP2pbEP0LCyDRxq
 9EclHHjs8AVhqZckZsrNoICEACHtA/8MD0Ad5RtMPFZy/jVWZ1VRSxSAGy21y04wS9Ae
 EoOqh7x8+FzLEca90tftm7wz37rkPaI/OSV0/ekAUba4EhWtlctBVWCMPEM1mUNiz8HH
 EwyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=0Epvk7fyUEu9mwVCJWkvWNY079YeUJZah0Cu5fJzAEQ=;
 b=VKeC8mGgn1KWAse0CLiCSyWMkMHBxjlkGDTypwotmSfzhCj7M7kZacdVn3Z1nJereF
 O17Opf5l5yUnZNw7g1BTsK7jiBTr75mu6bQs2o9fSWxmLb/4kUv+5C3zPGwdb051XG65
 4tzZJ2cmsPYT/AKTFt69TLkZGMk93dKNXXHdNhw9NZkflxG+0eYPR5tQ6dMUULOp7iql
 XJ+EkHgJelLh8Davamu7qx2noXLtoSdfTl0TOqmm2pv8Dxg/GnEXAyRhaA+e2jDBLRbo
 moCTq99RAuqvocha0Cac8v4byAJ2ZiMcWceEcXF5AFu2LEE+gfWDkRb674a4rokZq3N3
 KW8Q==
X-Gm-Message-State: AOAM531guNdoa71Q4+gbYg19eu97yslC/fSXCafKPf9vn4MCAc43nyXM
 ZPTjXJlz0zkKG5lR0hi0KiQpvKnbJ12zbeUF7Dr7X10OaeLYSZV6Wpn90CekQkjS/cDGEV1Ab4k
 wTIclxXSKLrN49Mlf1yx8JugFy8fs+waGHVkdr6TpjsQzoGaj7W7T2Phv1/EYCc9xjns=
X-Google-Smtp-Source: ABdhPJzU2h0ROk8Sq5UVDfvGO63XxvZxMKDO7VXZYWh/Ma9TOAK9WxoCj7FEDSVF/rrNof7KlIJt0t4MTg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a5d:5250:: with SMTP id
 k16mr5225506wrc.82.1633708738469; 
 Fri, 08 Oct 2021 08:58:58 -0700 (PDT)
Date: Fri,  8 Oct 2021 16:58:32 +0100
In-Reply-To: <20211008155832.1415010-1-tabba@google.com>
Message-Id: <20211008155832.1415010-12-tabba@google.com>
Mime-Version: 1.0
References: <20211008155832.1415010-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v7 11/11] KVM: arm64: Handle protected guests at 32 bits
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Protected KVM does not support protected AArch32 guests. However,
it is possible for the guest to force run AArch32, potentially
causing problems. Add an extra check so that if the hypervisor
catches the guest doing that, it can prevent the guest from
running again by resetting vcpu->arch.target and returning
ARM_EXCEPTION_IL.

If this were to happen, The VMM can try and fix it by re-
initializing the vcpu with KVM_ARM_VCPU_INIT, however, this is
likely not possible for protected VMs.

Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
AArch32 systems")

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 34 ++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 2c72c31e516e..f97e3012ef60 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -232,6 +232,37 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 	return hyp_exit_handlers;
 }
 
+/*
+ * Some guests (e.g., protected VMs) are not be allowed to run in AArch32.
+ * The ARMv8 architecture does not give the hypervisor a mechanism to prevent a
+ * guest from dropping to AArch32 EL0 if implemented by the CPU. If the
+ * hypervisor spots a guest in such a state ensure it is handled, and don't
+ * trust the host to spot or fix it.  The check below is based on the one in
+ * kvm_arch_vcpu_ioctl_run().
+ *
+ * Returns false if the guest ran in AArch32 when it shouldn't have, and
+ * thus should exit to the host, or true if a the guest run loop can continue.
+ */
+static bool handle_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	const struct kvm *kvm = kern_hyp_va(vcpu->kvm);
+
+	if (kvm_vm_is_protected(kvm) && vcpu_mode_is_32bit(vcpu)) {
+		/*
+		 * As we have caught the guest red-handed, decide that it isn't
+		 * fit for purpose anymore by making the vcpu invalid. The VMM
+		 * can try and fix it by re-initializing the vcpu with
+		 * KVM_ARM_VCPU_INIT, however, this is likely not possible for
+		 * protected VMs.
+		 */
+		vcpu->arch.target = -1;
+		*exit_code = ARM_EXCEPTION_IL;
+		return false;
+	}
+
+	return true;
+}
+
 /* Switch to the guest for legacy non-VHE systems */
 int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
@@ -294,6 +325,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
 
+		if (unlikely(!handle_aarch32_guest(vcpu, &exit_code)))
+			break;
+
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
