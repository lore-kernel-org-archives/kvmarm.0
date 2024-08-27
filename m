Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF0E1FDA
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 00:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724718186; cv=none; b=H2JRqdD+BnjBuXHwvynYZFgR+WXOeWS4LA/4R0ORu/rzpeNDTpMuHMOlDR9VXd6YWNBZlB+JVjh5C3uB0rBdZEeuilF68msEJLrImy24JYkVUMEasi1lZj5ICKdw9h1KBhSYQqNyqGXhsag4uRbpE4kD4ca7n91NyDt+YtbQeVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724718186; c=relaxed/simple;
	bh=pbjjuGpqJ8IOFdGJiLe2NKsTDB4Z8Glu2TsVdTVjQHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJC2gK7xZuldqITMPR1u/6xfXkRnv7d9z66r3s4tSZPNmrxTDJLVbka6Mgxl7SVBbl3JvMySIOe+lgb3QYb0RWD2oT63VWxJmCLMFQr8GYZ8xYiQB8jXmyZUbBfdgEz2zCGfeSaYyOZXtNjtpVrQrUsNFLRzceRSX9LLmu0Cgf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jhPy9YWT; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jhPy9YWT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724718179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mHVNTbzovKZy7+dqmVrvC2tMFyFYk68ukGOyD2mtGTM=;
	b=jhPy9YWTBTchhhmHIOjHgO0KDwfno9l+zpbOVDYNclJ8bjYXJskjw7/dhG97WuWEJPUAU+
	50E7kN4xaHIHx3/Tk2r65v3wTPVeommmt81ySJvSKci1uakmgRBLIFHnJ1LrtY7OlDZ73k
	GwCFHQgJn8scxMGSTI0UxH+r89Rlook=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 07/12] KVM: arm64: nv: Allow coarse-grained trap combos to use complex traps
Date: Tue, 27 Aug 2024 00:22:30 +0000
Message-ID: <20240827002235.1753237-8-oliver.upton@linux.dev>
In-Reply-To: <20240827002235.1753237-1-oliver.upton@linux.dev>
References: <20240827002235.1753237-1-oliver.upton@linux.dev>
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
index 41839ad85bcf..afc1e2a0e308 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1984,7 +1984,8 @@ int __init populate_nv_trap_config(void)
 		cgids = coarse_control_combo[id - __MULTIPLE_CONTROL_BITS__];
 
 		for (int i = 0; cgids[i] != __RESERVED__; i++) {
-			if (cgids[i] >= __MULTIPLE_CONTROL_BITS__) {
+			if (cgids[i] >= __MULTIPLE_CONTROL_BITS__ &&
+			    cgids[i] < __COMPLEX_CONDITIONS__) {
 				kvm_err("Recursive MCB %d/%d\n", id, cgids[i]);
 				ret = -EINVAL;
 			}
-- 
2.46.0.295.g3b9ea8a38a-goog

