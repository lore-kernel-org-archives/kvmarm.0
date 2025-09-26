Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EF01A0728
	for <kvmarm@lists.linux.dev>; Fri, 26 Sep 2025 19:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758915684; cv=none; b=gOei20oZmMZF05cAnOyvzjA0gBoZIbnzvae6tpNWFMAWnYBnSxYe4I7zeHgiFxsSrfIzHZwUFsj7bwPYSG5w0rhXsv2fLLt6LNIIqW18e+iy6DaR4rUZssIGkARSnoZyCzgWgJmpFg6D7GxH2POZsMgK5dbZjg7qUBFlLsuKWZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758915684; c=relaxed/simple;
	bh=PVrjuiUuH9MiukBTnHz3bNPqONav6kNSrTQNx1uw5X0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XF119qe7pIdT5BOSdkAaHUe+hne/9znfhzSMrr8c0tkOEa2j/9gtZGeWOCPlX/e9FQFw8nGWh2zb878wYXO8QySFA7QGS9xEpzCPatoDVHzUy3BUXN9RbxUt6C5RYlJcfWhuk2tSrVBBT4Y9gpTsf/oHhhsZirG0DMQD3A+tpxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VemThlej; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VemThlej"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758915680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w5xp7XhZoQgA8gncLMzH1cbDZLAsLXHbLrYI7qe1D/I=;
	b=VemThlejkP8Beypt2bujbc3/RqQoPzi4iM2C6d+RQz1OGrJ6sjujzBiN0uFrnBVtFG2SLW
	1MYY3j5D+XcKHiEBHbs+7ckxJYXl1KQWKCVuaYunSO/1tzsmKpyGiRhX2qQEi46KZ8N700
	nnAl6xpf0eLOso3kpFphlPyrcQz6n+E=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jan Kotas <jank@cadence.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/2] KVM: arm64: nv: Don't advance PC when pending an SVE exception
Date: Fri, 26 Sep 2025 12:41:08 -0700
Message-Id: <20250926194108.84093-3-oliver.upton@linux.dev>
In-Reply-To: <20250926194108.84093-1-oliver.upton@linux.dev>
References: <20250926194108.84093-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Marc Zyngier <maz@kernel.org>

Jan reports that running a nested guest on Neoverse-V2 leads to a WARN
in the host due to simultaneously pending an exception and PC increment
after an access to ZCR_EL2.

Returning true from a sysreg accessor is an indication that the sysreg
instruction has been retired. Of course this isn't the case when we've
pended a synchronous SVE exception for the guest. Fix the return value
and let the exception propagate to the guest as usual.

Reported-by: Jan Kotas <jank@cadence.com>
Closes: https://lore.kernel.org/kvmarm/865xd61tt5.wl-maz@kernel.org/
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4a75e5f0c259..ee8a7033c85b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2704,7 +2704,7 @@ static bool access_zcr_el2(struct kvm_vcpu *vcpu,
 
 	if (guest_hyp_sve_traps_enabled(vcpu)) {
 		kvm_inject_nested_sve_trap(vcpu);
-		return true;
+		return false;
 	}
 
 	if (!p->is_write) {
-- 
2.39.5

