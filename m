Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9E51C5CC9
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 22:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734648108; cv=none; b=erW5g5aCj3X/mXA105Ii+xsAlppG/jr1Q4fwr6SSatJmkQtCJQ8rS/K1H+z1RCTQ2ZP8y38VHhFeLXcTbCykYcvEw6dj6G/6Uj7w0pAUVhS3yjkhouOavuO/C0UBpPXz8hmnOrdR8jVSSx1OGCOMBQ5FTOVk7EXE9zSRox/4aHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734648108; c=relaxed/simple;
	bh=s5wl3jLS4o/94FFIUczz8P7hqju9dsYK+Luq0v5mNyo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jHyHoaPFDTtYf0efbcXA8CzNmu7cbpFoAPBcOipNjJ8qwh+y1Uub0AnPGCeSXE7Dr42xiPCXVrdpwcFHxfjWNBdjPf1/DTaFwtlYcj9O0cJFcsC9e4Zudhq3gMWADNKBghnffPU37PesZmzRI4BEbKmT73bLQIxYquo5r2VrbzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OZPwxawU; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OZPwxawU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734648104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wirvpwLa2Msuk2wj7NwI9c1iVi9MztzqrFBv0otV+AU=;
	b=OZPwxawUWyhH71Ygy4HJ1PBAFHxFYnklf6gAeZfs41ULhYR+ASHDxtiFjryV+olLGszNGj
	oyRbJrhhyWvYNNE93P/uriTXDhTGieB1jVz5vFBTZXhwed/KBMqyfvhqLYAsDDk86LIipG
	5S8dySLESGAcw81V5x2SbVNyaumKQ+k=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 07/19] KVM: arm64: Clean up KVM_SET_GUEST_DEBUG handler
Date: Thu, 19 Dec 2024 14:41:04 -0800
Message-Id: <20241219224116.3941496-8-oliver.upton@linux.dev>
In-Reply-To: <20241219224116.3941496-1-oliver.upton@linux.dev>
References: <20241219224116.3941496-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

No particular reason other than it isn't nice to look at.

Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/guest.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 12dad841f2a5..1fe097c67766 100644
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

