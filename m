Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222561DD541
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 17:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323188; cv=none; b=AjsIxF6wZp+NWXvV08eXZfKxYLsXKizf9Yk7vOEvLx7gWQSeNPN81AM3Bf7w0aLhgMzWNPTXDNANKnU1m61knpSEzknDmK7NHpsu8K5q0twYaY05dlraZHjxm1pROFddplFV+UmhyRRw7x2JdYmFYqZA/7HN/7b+9oGcX4IdNFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323188; c=relaxed/simple;
	bh=lnAxVuUGAifXgoJTx0oR04wDPUhalfVFA7REDJDgLog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEtOysDFlDloL4TRDpWCy0azHmCpYHnXo8osXliKJfoiMbJd+Q1ymrZqcQhC9SePU36n6LYQFqZyDRDknAcM0VzkrP0cMj6ko12pBNlSCAzBCVP3KhzOvUYjQNPj2OQouxHFP4q/akcWiQ3dwhfg2xv0ryFPP9k4AisId857vkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vcu+vsqL; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vcu+vsqL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728323184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Fqb51pS4Wbony3Z/5lfgDCrCaJOqBZwZBIi2GkwMNU=;
	b=vcu+vsqLs39QUH/7fVkwkfdw1nTkyYk5vpXDO97/2YQmoZ1R+0ninawiMOPkOZuRzNuyXb
	14TaGnsnWjiK/NIDEYWaaN5DD6R8MBXZtQppyj//bl2lHJA2fS9Is5d8iHmbaeVI+BEptG
	U0uJCxrze790tBCbuH8MSw3Zky2zlgo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 05/17] KVM: arm64: nv: Allow coarse-grained trap combos to use complex traps
Date: Mon,  7 Oct 2024 17:45:47 +0000
Message-ID: <20241007174559.1830205-6-oliver.upton@linux.dev>
In-Reply-To: <20241007174559.1830205-1-oliver.upton@linux.dev>
References: <20241007174559.1830205-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM uses a sanity-check to avoid infinite recursion in trap combinations
that could potentially depend on itself. Narrow the scope of this sanity
check to the exact CGT IDs that correspond w/ trap combos, opening the
door to using 'complex' traps as part of a combination.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/emulate-nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 05b6435d02a9..da7ab14e036d 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2021,7 +2021,8 @@ int __init populate_nv_trap_config(void)
 		cgids = coarse_control_combo[id - __MULTIPLE_CONTROL_BITS__];
 
 		for (int i = 0; cgids[i] != __RESERVED__; i++) {
-			if (cgids[i] >= __MULTIPLE_CONTROL_BITS__) {
+			if (cgids[i] >= __MULTIPLE_CONTROL_BITS__ &&
+			    cgids[i] < __COMPLEX_CONDITIONS__) {
 				kvm_err("Recursive MCB %d/%d\n", id, cgids[i]);
 				ret = -EINVAL;
 			}
-- 
2.47.0.rc0.187.ge670bccf7e-goog

