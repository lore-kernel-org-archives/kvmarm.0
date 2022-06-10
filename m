Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF94C43334
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jun 2022 09:29:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DA764B3B2;
	Fri, 10 Jun 2022 05:29:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iRF5a1S3V3SN; Fri, 10 Jun 2022 05:29:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EF5B4B3BD;
	Fri, 10 Jun 2022 05:29:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 219F24B3C2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:28:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ycyj9CczdBIp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jun 2022 05:28:58 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 01CA94B328
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:28:57 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 77DBC61EEA;
 Fri, 10 Jun 2022 09:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D20C341C4;
 Fri, 10 Jun 2022 09:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654853336;
 bh=P3Qxslc70t7szyihyigEdSCT8f++FwiYBUbMe+9p1Js=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=repJdJP+3B+b4bA+4zepxK2ntoRGYJnX4W1cq5592Se+BAcPe+M0tggogGKF/p1FL
 C8e6G1C8h9VZbNqFiLL/NfbAj42KpntD+4b1kwaHN6TnDChgwtmArV7agqoAnU7CCO
 RXSvCDxOC24XGlOZD6+4eZ/FyJAnMLHppDC76DoN7NYCF8WmQrrcXpZIkknd5kdJCv
 pdyl6qIrYEpLmy9lefGhHW5kEbrk+2U5Inf4mo9UDf4AQBeVnZPKd7l/dzZT271HUb
 MNBMSP/ksmpbT/sLPufrhHyF1FD3cBfsxyakpFL9mEqhsqiFsNxqJq23RjyjbFwsmE
 chzQLvXz9RfNg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nzawo-00H6Dt-U1; Fri, 10 Jun 2022 10:28:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 05/19] KVM: arm64: Add helpers to manipulate vcpu flags
 among a set
Date: Fri, 10 Jun 2022 10:28:24 +0100
Message-Id: <20220610092838.1205755-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610092838.1205755-1-maz@kernel.org>
References: <20220610092838.1205755-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com,
 will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org,
 reijiw@google.com, kernel-team@android.com
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
 arch/arm64/include/asm/kvm_host.h | 44 +++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 372c5642cfab..6d30ac7e3164 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -415,6 +415,50 @@ struct kvm_vcpu_arch {
 	} steal;
 };
 
+/*
+ * Each 'flag' is composed of a comma-separated triplet:
+ *
+ * - the flag-set it belongs to in the vcpu->arch structure
+ * - the value for that flag
+ * - the mask for that flag
+ *
+ *  __vcpu_single_flag() builds such a triplet for a single-bit flag.
+ * unpack_vcpu_flag() extract the flag value from the triplet for
+ * direct use outside of the flag accessors.
+ */
+#define __vcpu_single_flag(_set, _f)	_set, (_f), (_f)
+
+#define __unpack_flag(_set, _f, _m)	_f
+#define unpack_vcpu_flag(...)		__unpack_flag(__VA_ARGS__)
+
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
+#define vcpu_get_flag(v, ...)	__vcpu_get_flag((v), __VA_ARGS__)
+#define vcpu_set_flag(v, ...)	__vcpu_set_flag((v), __VA_ARGS__)
+#define vcpu_clear_flag(v, ...)	__vcpu_clear_flag((v), __VA_ARGS__)
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
