Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C71AC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:46:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AFA7B6321B
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:46:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AFA7B6321B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 260114086F;
	Wed, 17 Nov 2021 01:46:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5TB2Xs8h-aka; Wed, 17 Nov 2021 01:46:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D1874B0FC;
	Wed, 17 Nov 2021 01:46:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C9174B0EF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:46:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dLKTnVRXLvuw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:46:36 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E03CB4086F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:46:35 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 m16-20020a628c10000000b004a282d715b2so1110979pfd.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=N8fXLZvqvLp46Vlb4MzkHW+PGd4Y1uV4+vNk1MNsoX0=;
 b=elNT4EfICJasbMSr/sYT0V1/WkFPMoqyqLRbGmG7zbzGDFT6A4OQRNMQGgcXR0LaSX
 oLEu/mbv1y3wwz3gKGrHjlgyRVltbe5BnSEaGEUFHNujVkdVYM7yEnqle/1ENDCe59t4
 yfQK7K/JOWgUWTTmlLUj+CgQjQgrgQnltIJ9mc065L65W9UDIAtVBzxY/T9FxKVtGU4Z
 pPabu4FCY5kW58/Np0jr4Pmd1Hg6LcbQkgOzQJShJfb9aqtddBl85imtFziYKFyKIRWj
 ArwDotwmWfET5LLJ55ke68oyxkVYzKI0hR/rDvAIfOw37WfDwQ5rBxhavWPRQtst24dk
 XTrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=N8fXLZvqvLp46Vlb4MzkHW+PGd4Y1uV4+vNk1MNsoX0=;
 b=ckC7xiA8le24RMZ8CksMitnEgSZedtPRihvenVBME/rOFA819gFVe9Oc38JSNw7x8Q
 pq4x9ftmsk4xHf0RWgida+MjWOkmHDvG77zy8E3zvXz42xdI680IHHrQnFXdoYhNZP5b
 jMQ2Huy+QjRl3dW8392UvFxv0osHARXFEOSPQNvPOuuigg78qb2pcTQp2XAsSAxPu47v
 a8lZt0fJQ1IoRJ0N5ImqG9mxh7GjbzvHsC/mB7ZWNBUWSeuFlr3NKPu9+vPKktqWsHBK
 69dmO+OKbkXRDoXdq8VCpsEfjfs0+z2pF7b5T2QkWvTmFju/vV5hDgxWF710yL0xJ5S/
 y5qg==
X-Gm-Message-State: AOAM531vtlFcd8b1KUbCdTAcelUYFKWUcn9Tf9nwU5Vult3oZ2yHWwL5
 tnzVtRmhi/UxWd68O4BLVt+9ps/6SpI=
X-Google-Smtp-Source: ABdhPJwNBUSOEB1JuFJIrJfbR51JUxxZJ1OON4wodu+1NC7Urx/fRiLZJ4etkL1sB/ACUMvvsEJ5yqyqc0k=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a62:15d0:0:b0:4a0:2dd5:ee4e with SMTP id
 199-20020a6215d0000000b004a02dd5ee4emr46726718pfv.14.1637131594948; Tue, 16
 Nov 2021 22:46:34 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:31 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-2-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 01/29] KVM: arm64: Add has_reset_once flag for vcpu
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

Introduce 'has_reset_once' flag in kvm_vcpu_arch, which indicates
if the vCPU reset has been done once, for later use.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/reset.c            | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2a5f7f38006f..edbe2cb21947 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -385,6 +385,7 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		gpa_t base;
 	} steal;
+	bool has_reset_once;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
@@ -450,6 +451,7 @@ struct kvm_vcpu_arch {
 
 #define vcpu_has_sve(vcpu) (system_supports_sve() &&			\
 			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
+#define	vcpu_has_reset_once(vcpu) ((vcpu)->arch.has_reset_once)
 
 #ifdef CONFIG_ARM64_PTR_AUTH
 #define vcpu_has_ptrauth(vcpu)						\
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 426bd7fbc3fd..c3a91ab370fa 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -305,6 +305,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	if (loaded)
 		kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
+
+	if (!ret && !vcpu->arch.has_reset_once)
+		vcpu->arch.has_reset_once = true;
+
 	return ret;
 }
 
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
