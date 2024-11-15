Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3168191493
	for <kvmarm@lists.linux.dev>; Fri, 15 Nov 2024 22:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731710999; cv=none; b=PbGDVWyETEIs8QA/4cWcSiixTe3BYFN3usPRFqx7lX/oE5OcI+ZOmWOLHIEemP8DU1Eo9G3Xu7gteh1JOgzQYKXBXdZQf64E3kOahzKZSY3KgqIxE3iAiTSo9xVDJmffyxb4LivgA6QE5Vegva/jEbV4mQpf+BzQMMfPgF7Pwm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731710999; c=relaxed/simple;
	bh=DNpmTOByli+BwRGPUopYG6a9SurFcdnEKLiaRmdRWpg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RvqNdJzM5w67VvHhYfw1uj4ev594ILSwZqgKskxL7vY8HepEUQ/7y0Fil6zKQ1PhP99E0J8GsaNNXrclMoWhohXXVN0rDYXbf0M+05xj56iBM6wqlmlb6sayXwMOqjoq2SnKvIQZkeTlgINMn9QFJjDg5XiUw0ZhrGYtxMhcg4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ah0ZEQWh; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ah0ZEQWh"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731710996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uM2wmq1HcpobSC+acm8I72LOBcapLa+mAz2m0QISIlg=;
	b=ah0ZEQWhR9oWF73Bavk7JFrD+ZuAumLGu6uxfMUhgLhu2qaRHB4UdH3clnGzMvngTwyP49
	IsFMqhTbog93ts7L4R8ngcl5AYXSDOuaSCBpi/S0qCtMoh2RvFLYVHX0AtADvUOPLZpZOB
	U/dlIRhJu6dYt41IRp8jRVVt7zasats=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 06/16] KVM: arm64: Clean up KVM_SET_GUEST_DEBUG handler
Date: Fri, 15 Nov 2024 14:49:14 -0800
Message-Id: <20241115224924.2132364-7-oliver.upton@linux.dev>
In-Reply-To: <20241115224924.2132364-1-oliver.upton@linux.dev>
References: <20241115224924.2132364-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

No particular reason other than it isn't nice to look at.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/guest.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 962f985977c2..af612ea20b71 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -917,31 +917,24 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg)
 {
-	int ret = 0;
-
 	trace_kvm_set_guest_debug(vcpu, dbg->control);
 
-	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if (dbg->control & KVM_GUESTDBG_ENABLE) {
-		vcpu->guest_debug = dbg->control;
-
-		/* Hardware assisted Break and Watch points */
-		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW) {
-			vcpu->arch.external_debug_state = dbg->arch;
-		}
+	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK)
+		return -EINVAL;
 
-	} else {
-		/* If not enabled clear all flags */
+	if (!(dbg->control & KVM_GUESTDBG_ENABLE)) {
 		vcpu->guest_debug = 0;
 		vcpu_clear_flag(vcpu, DBG_SS_ACTIVE_PENDING);
+		return 0;
 	}
 
-out:
-	return ret;
+	vcpu->guest_debug = dbg->control;
+
+	/* Hardware assisted Break and Watch points */
+	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW)
+		vcpu->arch.external_debug_state = dbg->arch;
+
+	return 0;
 }
 
 int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
-- 
2.39.5

