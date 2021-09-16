Return-Path: <SRS0=sbHD=OG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C7DDC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C7826120D
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1C7826120D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B12E24B1A2;
	Thu, 16 Sep 2021 14:15:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ki+VWLb+dxGg; Thu, 16 Sep 2021 14:15:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92DED4B174;
	Thu, 16 Sep 2021 14:15:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A5CE4B156
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id frC9l+KIo7Zy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 14:15:27 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D9D94B161
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:27 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 w13-20020a05621412ed00b0037cc26a5659so62167828qvv.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 11:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=CZEtXXeNpIXSrXo/BVsRgyGrmjyKYgmME4XdGa9+bYM=;
 b=iDaF0p6xegEkAf8PzcMdP3s+fpRHuXXgl97zAq4ajM+U3yjOno3KmoxnJm61JFbhXK
 VfyRyYTBT/uLo9Uia1U724DrLnLXtOayyYodTnCybsEgtgmF7z7Dhlg49Xj+2kd5kCuS
 f/5uHMXCij5W24v2yJVqX83X0oCUciZ/2Zcu5iLecKJhhCtKdR04VgeLk4f4ZDI6Uvja
 DgKQSDcN3Ulv5bHMX42U0ALMNzk93Y24nglw1ddOtJjgG89o6+DYs94hvvscdUsifpmh
 nsUKBVWv9qJs9sdPoTvuv2VHEpnsldk9S13e2PVxhCbzKw6e3WwiVARyCpBs1LD/Z4u3
 Bc5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=CZEtXXeNpIXSrXo/BVsRgyGrmjyKYgmME4XdGa9+bYM=;
 b=66BeOtHtQbmxSYC3B2Uc6faIwOwaAvsr1lJw+EcklLd4yNWvpK7FQIxhaWdwPyyZtA
 Ws08o5cifu5uCzBoteeE3omgX2oHlY3KBkOnL2v+WechoMwjML4gOkFw1R2ioFfCM6Q8
 UDyEb9O2kWzvf0RkWGba9DShvyrp8CfY+gj9OE9/FJaLAxk61K/iWK/z4kWvXrIgid0/
 hW+kkDVgtgHsLyR2AzaLcJh5UAnWfC8n9oLjvyXLjjXw+7Bws89eJp+aTyqvToGyXF45
 cy869I4+fr/ogSeyoYvnMMePEsqBlPvyU8cvgpCBQTXDAe2M0hF0mzQcOkLX01748Umh
 9DBw==
X-Gm-Message-State: AOAM532DJAU/9fXz04UYQI5Sx9LA1XhGQjLqmxpKZZ7oww+xdJUmvoTH
 v2pMS7yS1Kewkhb2nd+OlvKiyTS6ABw=
X-Google-Smtp-Source: ABdhPJzuML//NrffbdQcWfzCfBHgYs5KCnfRh2zIVPiWAz432/WqTbsx1cxsM3dFyt2dwSgzM6wBATO+55o=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:fc5:: with SMTP id
 188mr8465782ybp.51.1631816126794; 
 Thu, 16 Sep 2021 11:15:26 -0700 (PDT)
Date: Thu, 16 Sep 2021 18:15:05 +0000
In-Reply-To: <20210916181510.963449-1-oupton@google.com>
Message-Id: <20210916181510.963449-4-oupton@google.com>
Mime-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 3/8] KVM: arm64: Make a helper function to get nr of timer
 regs
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

Presently, the number of timer registers is constant. There may be
opt-in behavior in KVM that exposes more timer registers to userspace.
Prepare for the change by switching from a macro to a helper function to
get the number of timer registers.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/guest.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5ce26bedf23c..a13a79f5e0e2 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -588,7 +588,10 @@ static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
  * ARM64 versions of the TIMER registers, always available on arm64
  */
 
-#define NUM_TIMER_REGS 3
+static inline unsigned long num_timer_regs(struct kvm_vcpu *vcpu)
+{
+	return 3;
+}
 
 static bool is_timer_reg(u64 index)
 {
@@ -711,7 +714,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 	res += num_sve_regs(vcpu);
 	res += kvm_arm_num_sys_reg_descs(vcpu);
 	res += kvm_arm_get_fw_num_regs(vcpu);
-	res += NUM_TIMER_REGS;
+	res += num_timer_regs(vcpu);
 
 	return res;
 }
@@ -743,7 +746,7 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	ret = copy_timer_indices(vcpu, uindices);
 	if (ret < 0)
 		return ret;
-	uindices += NUM_TIMER_REGS;
+	uindices += num_timer_regs(vcpu);
 
 	return kvm_arm_copy_sys_reg_indices(vcpu, uindices);
 }
-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
