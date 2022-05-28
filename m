Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C12CC433F5
	for <kvmarm@archiver.kernel.org>; Sat, 28 May 2022 11:49:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C30B4B28F;
	Sat, 28 May 2022 07:49:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id STbzfXitjsYp; Sat, 28 May 2022 07:49:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8A284B2F2;
	Sat, 28 May 2022 07:49:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CBE44B2AA
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:49:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FpLACmDmkikf for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 May 2022 07:49:55 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C99774B108
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:49:54 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 7EA91CE191E;
 Sat, 28 May 2022 11:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC160C34100;
 Sat, 28 May 2022 11:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1653738589;
 bh=OvbuqjCsYRsACHJmFHA5RtdLvj3YPOeVzGbn+ZzrKrQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=eu3l4UaY7mnC7O9DPaOKnbpHQYefi9Fjlv+v3XUB5+VGlJmIAJ/35hbiqkPtfQCbS
 Z61gRVAPd+I8n3H5IKXZcVYU1s58VdwEDqCcgviY2jy4YyIPcUZ+RmvlTN7iCocT/8
 qOoaAaof17sAZ9HubdVKWW1JiviiF+B41nb88IQZzRTUFMG6YwbGYgnAOnFzg20PC5
 2RsCsIkw/vzCvoGEFHpbyOKKhpKzvX3fyvgBvESEfOuUcXM2a51+GoPULhE3mJxJlL
 uhMhbl9dOPNsxFA8mVFkzM86fcGkjX9Pn0yCwrebkf54jUFW5yxa/8pRIWzwzoTq+9
 Z9nAx1FEpdgkw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nuumD-00EEGh-LB; Sat, 28 May 2022 12:38:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 17/18] KVM: arm64: Reduce the size of the vcpu flag members
Date: Sat, 28 May 2022 12:38:27 +0100
Message-Id: <20220528113829.1043361-18-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220528113829.1043361-1-maz@kernel.org>
References: <20220528113829.1043361-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com,
 will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>
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

Now that we can detect flags overflowing their container, reduce
the size of all flag set members in the vcpu struct, turning them
into 8bit quantities.

Even with the FP state enum occupying 32bit, the whole of the state
that was represented by flags is smaller by one byte. Profit!

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 70931231f0cb..83f3dae4333a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -336,13 +336,13 @@ struct kvm_vcpu_arch {
 	} fp_state;
 
 	/* Configuration flags */
-	u64 cflags;
+	u8 cflags;
 
 	/* Input flags to the hypervisor code */
-	u64 iflags;
+	u8 iflags;
 
 	/* State flags, unused by the hypervisor code */
-	u64 sflags;
+	u8 sflags;
 
 	/*
 	 * We maintain more than a single set of debug registers to support
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
