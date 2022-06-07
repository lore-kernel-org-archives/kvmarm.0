Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DEE5CCA47C
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 13:14:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9ACE4B20D;
	Tue,  7 Jun 2022 09:14:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 41BwxVoE-zj6; Tue,  7 Jun 2022 09:14:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E71B4B377;
	Tue,  7 Jun 2022 09:14:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 179784B352
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 09:14:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kzwTsHuOmcYM for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2022 09:14:34 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C1FB54B30C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 09:14:34 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 3806C6138B;
 Tue,  7 Jun 2022 13:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1DDC385A5;
 Tue,  7 Jun 2022 13:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654607673;
 bh=RiFpv4ti8o+54/PIi4uIAl7GNNSk/w0np3Cg3vPA0Gk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=lxcKuQHTPYMDTWg7lUSCrAi28fydKer9Ii4G5fABeknMBwms4mnpvGCQiWM+Kkpgw
 E6d/cf/8LjwtwyAid5yw2/lc+lVVsF2mLQq0Y8PplgHAm8DHigcd8XzPkvGg3kmDfz
 HkGH/KML3kErO/OECw9jcCjyTJfxV0TY2d7ErO1JDdS4bCxPr1AZaTG8nkS/Dx5RbK
 RYxVBviQzvFQTkv5Bp7j5VliniLEdhan2M2ZCebrriO4gpHh+2IkGqmgBr8GMjlaRo
 BMn8YyaOZOzLxBmY6o4+dU/XX5cA1oKo0M4DSxoF9c0ldH4J4vWINnFEuo4SMS1iND
 wfXfeAdubhPMw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nyZ2V-00GBUI-AH; Tue, 07 Jun 2022 14:14:31 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Subject: [PATCH v2 3/3] KVM: arm64: Warn if accessing timer pending state
 outside of vcpu context
Date: Tue,  7 Jun 2022 14:14:27 +0100
Message-Id: <20220607131427.1164881-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220607131427.1164881-1-maz@kernel.org>
References: <20220607131427.1164881-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 eric.auger@redhat.com, ricarkol@google.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

A recurrent bug in the KVM/arm64 code base consists in trying to
access the timer pending state outside of the vcpu context, which
makes zero sense (the pending state only exists when the vcpu
is loaded).

In order to avoid more embarassing crashes and catch the offenders
red-handed, add a warning to kvm_arch_timer_get_input_level() and
return the state as non-pending. This avoids taking the system down,
and still helps tracking down silly bugs.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 4e39ace073af..3b8d062e30ea 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1230,6 +1230,9 @@ bool kvm_arch_timer_get_input_level(int vintid)
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	struct arch_timer_context *timer;
 
+	if (WARN(!vcpu, "No vcpu context!\n"))
+		return false;
+
 	if (vintid == vcpu_vtimer(vcpu)->irq.irq)
 		timer = vcpu_vtimer(vcpu);
 	else if (vintid == vcpu_ptimer(vcpu)->irq.irq)
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
