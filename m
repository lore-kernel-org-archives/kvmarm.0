Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F56C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:44:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D5B64B3F8;
	Thu, 19 May 2022 09:44:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4I1iLd5dPf+5; Thu, 19 May 2022 09:44:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E6944B3EB;
	Thu, 19 May 2022 09:44:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 379A34B211
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id npgdeF8+ZWsA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:44:42 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 373754B3C8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:42 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 58C33B824AF;
 Thu, 19 May 2022 13:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB594C34100;
 Thu, 19 May 2022 13:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967880;
 bh=sMh0UCgIWjXVfrdGOf6s/H5Omqvu6QIYMqHdrALaiFQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=fChHAdSeRCu5nnQLCIerdlLwME4HuSOoTq765F+p2PmiqZDNBy1OVBaPUy1Z+HP/5
 Qr1oV8QjMOdjFyK0QNZ5b+s6lQhG92ykY+hY/pqHuopk2MFzqF41khrHQy/p/Ge8cz
 vJ1Cpm4Ro9E4tqvDsz+QEcI6ejpFG36wYD/mc1nx7d1v4zxcLiTyKdWgjXgcoDMs4x
 i+EkttApQGaALL7WwshRplmOs/bHG0ui/pZLNqG0PpfG0DKO1Q3fpSdp00+mzz0JO1
 TByAThQbuHkNkXxIXi4JwfqrSNOhO7eTBWHimmB6/ZmlyAKq6zxN2SzCqDS94EJyKf
 Pu3EqqpciPeHQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 34/89] KVM: arm64: Don't access kvm_arm_hyp_percpu_base at EL1
Date: Thu, 19 May 2022 14:41:09 +0100
Message-Id: <20220519134204.5379-35-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

The host KVM PMU code can currently index kvm_arm_hyp_percpu_base[]
through this_cpu_ptr_hyp_sym(), but will not actually dereference that
pointer when protected KVM is enabled. In preparation for making
kvm_arm_hyp_percpu_base[] unaccessible to the host, let's make sure the
indexing in hyp per-cpu pages is also done after the static key check to
avoid spurious accesses to EL2-private data from EL1.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/pmu.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 03a6c1f4a09a..a8878fd8b696 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -31,9 +31,13 @@ static bool kvm_pmu_switch_needed(struct perf_event_attr *attr)
  */
 void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
 {
-	struct kvm_host_data *ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
+	struct kvm_host_data *ctx;
 
-	if (!kvm_arm_support_pmu_v3() || !ctx || !kvm_pmu_switch_needed(attr))
+	if (!kvm_arm_support_pmu_v3())
+		return;
+
+	ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
+	if (!ctx || !kvm_pmu_switch_needed(attr))
 		return;
 
 	if (!attr->exclude_host)
@@ -47,9 +51,13 @@ void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
  */
 void kvm_clr_pmu_events(u32 clr)
 {
-	struct kvm_host_data *ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
+	struct kvm_host_data *ctx;
+
+	if (!kvm_arm_support_pmu_v3())
+		return;
 
-	if (!kvm_arm_support_pmu_v3() || !ctx)
+	ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
+	if (!ctx)
 		return;
 
 	ctx->pmu_events.events_host &= ~clr;
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
