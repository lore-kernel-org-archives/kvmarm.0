Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3931C30
	for <kvmarm@lists.linux.dev>; Mon, 17 Apr 2023 09:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAB1C433EF;
	Mon, 17 Apr 2023 09:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681724205;
	bh=KeQTm2yBf7lmV1SmG8Zc9mtIZJvTYh+5UwPe5wHnMAE=;
	h=From:To:Cc:Subject:Date:From;
	b=o41Hevtxb/HlIeFnl7UijhGGQXziFR82gJYtj3SIxze3nzhEpoMCZLEpOoeefhmY5
	 Ap6tjlfIC1eCYQuLrJVDDY7T4+NZLqP58u/ofE5TNqO1GnQYRuQQJu1hyP/EVNWd1y
	 wrF4p+CLw2WdIp/7F7f7Sn/BMoqvM6EPvgRIkp2eIhZckWfTRbpzo1Mk0dKrCDfpo4
	 QmPfDsZqG/M7OPpCSJoSZVH+2pWSNq8SWWUO23V4jZu7EqhSZNo5As0h9bxZfK/5ey
	 BWM98lSkjDTreKeJaf8i4YYXBzCe79oAin1+tH9Ua1pB/rgDafLR50q62/FhDoX/Qy
	 7KVdML/l98frA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1poLHu-008t1H-Vb;
	Mon, 17 Apr 2023 10:36:43 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Make vcpu flag updates non-preemptible
Date: Mon, 17 Apr 2023 10:36:29 +0100
Message-Id: <20230417093629.1440039-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, qperret@google.com, smostafa@google.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Per-vcpu flags are updated using a non-atomic RMW operation.
Which means it is possible to get preempted between the read and
write operations.

Another interesting thing to note is that preemption also updates
flags, as we have some flag manipulation in both the load and put
operations.

It is thus possible to lose information communicated by either
load or put, as the preempted flag update will overwrite the flags
when the thread is resumed. This is specially critical if either
load or put has stored information which depends on the physical
CPU the vcpu runs on.

This results in really elusive bugs, and kudos must be given to
Mostafa for the long hours of debugging, and finally spotting
the problem.

Fixes: e87abb73e594 ("KVM: arm64: Add helpers to manipulate vcpu flags among a set")
Reported-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/include/asm/kvm_host.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bcd774d74f34..d716cfd806e8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -579,6 +579,19 @@ struct kvm_vcpu_arch {
 		v->arch.flagset & (m);				\
 	})
 
+/*
+ * Note that the set/clear accessors must be preempt-safe in order to
+ * avoid nesting them with load/put which also manipulate flags...
+ */
+#ifdef __KVM_NVHE_HYPERVISOR__
+/* the nVHE hypervisor is always non-preemptible */
+#define __vcpu_flags_preempt_disable()
+#define __vcpu_flags_preempt_enable()
+#else
+#define __vcpu_flags_preempt_disable()	preempt_disable()
+#define __vcpu_flags_preempt_enable()	preempt_enable()
+#endif
+
 #define __vcpu_set_flag(v, flagset, f, m)			\
 	do {							\
 		typeof(v->arch.flagset) *fset;			\
@@ -586,9 +599,11 @@ struct kvm_vcpu_arch {
 		__build_check_flag(v, flagset, f, m);		\
 								\
 		fset = &v->arch.flagset;			\
+		__vcpu_flags_preempt_disable();			\
 		if (HWEIGHT(m) > 1)				\
 			*fset &= ~(m);				\
 		*fset |= (f);					\
+		__vcpu_flags_preempt_enable();			\
 	} while (0)
 
 #define __vcpu_clear_flag(v, flagset, f, m)			\
@@ -598,7 +613,9 @@ struct kvm_vcpu_arch {
 		__build_check_flag(v, flagset, f, m);		\
 								\
 		fset = &v->arch.flagset;			\
+		__vcpu_flags_preempt_disable();			\
 		*fset &= ~(m);					\
+		__vcpu_flags_preempt_enable();			\
 	} while (0)
 
 #define vcpu_get_flag(v, ...)	__vcpu_get_flag((v), __VA_ARGS__)
-- 
2.34.1

