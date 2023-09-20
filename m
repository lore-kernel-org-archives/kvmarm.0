Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EA31A583
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 18:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10623C433D9;
	Wed, 20 Sep 2023 18:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695233860;
	bh=0lCI9vVo+XFWhmo/qM09sP7BePJ3MPGwh8pEm0Qjxe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GB/KZ7jg5DLjhVEOyC1ctv3v9Cumof6TcXeDB+UU8xXl9Pfvbv+yUWpJSwxJsNdo4
	 bcekAoh95pVT2MD6VCSOrnuf4XsGbiEMRYhuDEOScD0Wdp1jQrw/ov6mYlc14FF/q0
	 Hc8e4MG2habd0zIABq4neUtOw1h9oRVOoMmvZuYFxlGg1hpGKUjbdmxdZvZkobTGQY
	 9hkUUAQBxbN4yaDc7p5wrGZlfpyIjbcATq/oDeK8B5/5tG37E1t/T5IUYmAalAEbhd
	 l83ffN9FKvECgggA2WSsITETHgUXKn1CFK7+N0me6K2Y4Ex0lFylyA4DbYvPEs4lBy
	 5GAecXdhaT38w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qj1la-00Ejx0-6h;
	Wed, 20 Sep 2023 19:17:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Xu Zhao <zhaoxu.35@bytedance.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 06/11] KVM: arm64: Use vcpu_idx for invalidation tracking
Date: Wed, 20 Sep 2023 19:17:26 +0100
Message-Id: <20230920181731.2232453-7-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230920181731.2232453-1-maz@kernel.org>
References: <20230920181731.2232453-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, shameerali.kolothum.thodi@huawei.com, zhaoxu.35@bytedance.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 872679a0cbd7..23c22dbd1969 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -438,9 +438,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	 * We might get preempted before the vCPU actually runs, but
 	 * over-invalidation doesn't affect correctness.
 	 */
-	if (*last_ran != vcpu->vcpu_id) {
+	if (*last_ran != vcpu->vcpu_idx) {
 		kvm_call_hyp(__kvm_flush_cpu_context, mmu);
-		*last_ran = vcpu->vcpu_id;
+		*last_ran = vcpu->vcpu_idx;
 	}
 
 	vcpu->cpu = cpu;
-- 
2.34.1

