Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BB13B6BE1
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748688; cv=none; b=EAWKsMUVPe+Nw/cusJJEycnMRhBpk+9p2fFwnKJR1Ezf/HgN8lxc+dCgGowkFjY0XxbazsV4aBc7gUVfmE671M0c2+YAPgLVhDlsS6OG5J0gcIO714f8y3B84zMYbDmNkvI9T6QsZF2KcF0EZO41dCPPQLMTtVYVSUDEy14czHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748688; c=relaxed/simple;
	bh=2gctEw+ccsSJpqJdhH2NraKuCJmspR5Yf70y6A1ymLY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gZL6qxZfUqGGqxWdpnpaT9cS+ZxzXPPwRpeBJC1xrCdCHNfKNQD7GmlXfvrPi7PO2hw3eN66tcZt/o/HrT88ecxDnzkCuAH9gHBHSyhj1WVH2mo8qIXJ3OeQsh/D9dCfXtftM0KQSq9Y3Zyed4hQ4oa1Bnr+vl1fjqfZpH2ai2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P7tZbnZg; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P7tZbnZg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773748684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Zjwds4Z8n6IYLF5dnZmswgQEZ5qdvju6jCMsGxe61A0=;
	b=P7tZbnZgAX34zDtFfW6SJ+K0yhL/vqFP9y3FtcmkUwyTpewIbSrqEeSYyREQlCsbYYiLWI
	U52SrhG4Tn25UEvyxnCeDgNgdeT161flSX+StZfHSSTKd+wOwF1N0STkpTJDOVDt5FAZry
	0cCuE4GKRnp0q7kxwyzbIJQzCyZ+fEU=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] KVM: arm64: Fix the descriptor address in __kvm_at_swap_desc()
Date: Tue, 17 Mar 2026 19:57:48 +0800
Message-ID: <20260317115748.47332-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

Using "(u64 __user *)hva + offset" to get the virtual addresses of S1/S2
descriptors looks really wrong, if offset is not zero. What we want to get
for swapping is hva + offset, not hva + offset*8. ;-)

Fix it.

Fixes: f6927b41d573 ("KVM: arm64: Add helper for swapping guest descriptor")
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 arch/arm64/kvm/at.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index c5c5644b1878..a024d9a770dc 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1753,7 +1753,7 @@ int __kvm_at_swap_desc(struct kvm *kvm, gpa_t ipa, u64 old, u64 new)
 	if (!writable)
 		return -EPERM;
 
-	ptep = (u64 __user *)hva + offset;
+	ptep = (void __user *)hva + offset;
 	if (cpus_have_final_cap(ARM64_HAS_LSE_ATOMICS))
 		r = __lse_swap_desc(ptep, old, new);
 	else
-- 
2.53.0

