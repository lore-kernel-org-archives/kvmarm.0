Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64015C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0E4E9611B0
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0E4E9611B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B45154B0DB;
	Wed, 22 Sep 2021 08:47:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Onf9nQgktt9h; Wed, 22 Sep 2021 08:47:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D3854B0E2;
	Wed, 22 Sep 2021 08:47:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F9574A49C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Zx3hvS9UOQI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 08:47:34 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2239C4B0F7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:32 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 d20-20020ac81194000000b002a53ffbd04dso8734971qtj.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 05:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=MCg7tHy3/sZ81tGGFXf0NcnSSZrwV+Eij7+P/yRsSfg=;
 b=EiMTA1NnhtOUvnrBFvPdoslDCpEUBRA+f3Q+0xFhUdwNwFKpnE1rIZITIVSG+lZ7m6
 szKsCVt2+byDFfsu8ex+Vl/Em/kSog5HGfVbKv+x1oBqXfC4SJRoN/tdHYG6ZDVYOf9r
 XILDlqXVu0shnC8/4najcsjA+dsJzLGyaEOLHg6Ji3MwioXvsTAJSrifCeZ6J3BqdR8X
 Oai+aUpC/qGou978VV0ybNJafCXFduFfSD1oVPVaiuAwmDEUImb9mq5DRvQ3DuW6Gp9q
 QoIiTJ04JAv6wENM2NmcsF3jpqBjcmdTWpPA297mOqJnHSB91TGUaNbFsobw84DcrTlO
 TLKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=MCg7tHy3/sZ81tGGFXf0NcnSSZrwV+Eij7+P/yRsSfg=;
 b=i92QSlShu2SqS2nJNkJJSqXp46+8LqRzR0lAa1ifuAF1zVK4OeFmD1L3YR2R7PJUBW
 pjiVF0LhGYyFUGk80nyJF/ozz9o7yiosRB3v3qy9ByB57anIrczpOjws0jZp5e1FZMmh
 lGzIqrTandgxtnM+lwTokFIm5O+kWalMnpfdzz2x8f3Cdxtp4iN837k5XKaC60DW/J2G
 qv4oy1p1m5VDy0SwJG82REBzPz3AgnAz91nF4Nc74a1NoRV5ukaPyYXIMxhVYoEjgsM1
 bNPn5kU7K2m6vVRfYULpgt6xxeZtBWGc+OGF0rZh3NP2vZ0CMvOKrHcLc4LHJwzAOqF8
 tpWg==
X-Gm-Message-State: AOAM530DgLBD6TgvgxpYBUBolzFf5L0mv/L25ezoeJqnm5ozSiTEs6Ss
 vaOLGCGqQ104Wcrw/w8hxYDJZiUYUIaIiJC9xrYE7YHC2z7cPx7bFR68fy9FFJyqJeczmyhre7Z
 dOFY9ymA6Ht4lRleTvo/0okV8/BdFdaI6kfZs/QZrCCiefFyhfEUuOvnWKYgv3+4pbz0=
X-Google-Smtp-Source: ABdhPJxdGqe4Wwg8ftovL0+NfZlJpKCUs8fzSEQy3CdlkWIXsbQJJ1pi4X33SfdQvc0UggyU55QtvD50hg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:46ab:: with SMTP id
 br11mr36084622qvb.15.1632314851756; 
 Wed, 22 Sep 2021 05:47:31 -0700 (PDT)
Date: Wed, 22 Sep 2021 13:47:04 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-13-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 12/12] KVM: arm64: Handle protected guests at 32 bits
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
 arch/arm64/kvm/hyp/nvhe/switch.c | 40 ++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 2bf5952f651b..d66226e49013 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -235,6 +235,43 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 	return hyp_exit_handlers;
 }
 
+/*
+ * Some guests (e.g., protected VMs) might not be allowed to run in AArch32.
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
+	struct kvm *kvm = (struct kvm *) kern_hyp_va(vcpu->kvm);
+	bool is_aarch32_allowed =
+		FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0),
+			  get_pvm_id_aa64pfr0(vcpu)) >=
+				ID_AA64PFR0_ELx_32BIT_64BIT;
+
+	if (kvm_vm_is_protected(kvm) &&
+	    vcpu_mode_is_32bit(vcpu) &&
+	    !is_aarch32_allowed) {
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
@@ -297,6 +334,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
 
+		if (unlikely(!handle_aarch32_guest(vcpu, &exit_code)))
+			break;
+
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
