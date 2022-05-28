Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F5D5C433FE
	for <kvmarm@archiver.kernel.org>; Sat, 28 May 2022 11:38:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E99244B369;
	Sat, 28 May 2022 07:38:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TUY8MwGkvkYA; Sat, 28 May 2022 07:38:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6AD44B383;
	Sat, 28 May 2022 07:38:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F37484B32E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:38:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eOgkJJ-Q0z-B for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 May 2022 07:38:39 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 391614B2BF
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:38:39 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 4EC6AB82665;
 Sat, 28 May 2022 11:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C726C341C0;
 Sat, 28 May 2022 11:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1653737916;
 bh=p0/Z96QLuUnjfzpou5qfF4Pu/aafkp4ZE/VEpJVwk5w=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=OBOqe5zvN52Cu5/QJHxRVD+vRlT6ywEpOq4NwfDr+LULL5HPZnLcN0NlOwmuP1Gyr
 Qe18h4wkcKBP1M2rUGaT85JhM//vLYyP0QywKwEdoGKouOybBuSwCp67iusGT84Hnm
 tsQxAn79plOdvGrk5XIB08IpQWVrptzoJoQ21XEJKiK7qdG8sA3NuNTRb24+FrmhIE
 +bcSYZAuLAICWR5OfMb1Sb1doXeUPT1EEyDdLzxdOjh5me6ujcpbkTdabYHlpzgG8M
 wci+6M/XsuCzDzVhzWnsjVheyzyrekU7QvzxRJ4KiUB0Rmq07io7N2EX+cZnAo92LX
 8dC+BnL8yjjgw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nuumA-00EEGh-Ix; Sat, 28 May 2022 12:38:34 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 05/18] KVM: arm64: Add helpers to manipulate vcpu flags among
 a set
Date: Sat, 28 May 2022 12:38:15 +0100
Message-Id: <20220528113829.1043361-6-maz@kernel.org>
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

Careful analysis of the vcpu flags show that this is a mix of
configuration, communication between the host and the hypervisor,
as well as anciliary state that has no consistency. It'd be a lot
better if we could split these flags into consistent categories.

However, even if we split these flags apart, we want to make sure
that each flag can only be applied to its own set, and not across
sets.

To achieve this, use a preprocessor hack so that each flag is always
associated with:

- the set that contains it,

- a mask that describe all the bits that contain it (for a simple
  flag, this is the same thing as the flag itself, but we will
  eventually have values that cover multiple bits at once).

Each flag is thus a triplet that is not directly usable as a value,
but used by three helpers that allow the flag to be set, cleared,
and fetched. By mandating the use of such helper, we can easily
enforce that a flag can only be used with the set it belongs to.

Finally, one last helper "unpacks" the raw value from the triplet
that represents a flag, which is useful for multi-bit values that
need to be enumerated (in a switch statement, for example).

Further patches will start making use of this infrastructure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 33 +++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a46f952b97f6..5eb6791df608 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -418,6 +418,39 @@ struct kvm_vcpu_arch {
 	} steal;
 };
 
+#define __vcpu_get_flag(v, flagset, f, m)			\
+	({							\
+		v->arch.flagset & (m);				\
+	})
+
+#define __vcpu_set_flag(v, flagset, f, m)			\
+	do {							\
+		typeof(v->arch.flagset) *fset;			\
+								\
+		fset = &v->arch.flagset;			\
+		if (HWEIGHT(m) > 1)				\
+			*fset &= ~(m);				\
+		*fset |= (f);					\
+	} while (0)
+
+#define __vcpu_clear_flag(v, flagset, f, m)			\
+	do {							\
+		typeof(v->arch.flagset) *fset;			\
+								\
+		fset = &v->arch.flagset;			\
+		*fset &= ~(m);					\
+	} while (0)
+
+#define vcpu_get_flag(v, ...)	__vcpu_get_flag(v, __VA_ARGS__)
+#define vcpu_set_flag(v, ...)	__vcpu_set_flag(v, __VA_ARGS__)
+#define vcpu_clear_flag(v, ...)	__vcpu_clear_flag(v, __VA_ARGS__)
+
+#define __vcpu_single_flag(_set, _f)	_set, (_f), (_f)
+
+#define __flag_unpack(_set, _f, _m)	_f
+#define vcpu_flag_unpack(...)		__flag_unpack(__VA_ARGS__)
+
+
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
 			     sve_ffr_offset((vcpu)->arch.sve_max_vl))
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
