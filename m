Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59653921D1
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 17:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772040934; cv=none; b=XgSm1BxpVCHH2GTz/KUKZ/G7qof6MQgorOu8jFVZdFZcEUIKixU9zpWtUJ4XCrhl/cmyP/zGHBVsojzXc4RA2v4zplyOiPIZJb0rNOMBL8EC6d1UIBaPiuw7YMz6qKFE8eXX56KFQMwn0bvkmlw5ZExPfui3A3uwck7j0+3unu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772040934; c=relaxed/simple;
	bh=dcqTp1+cUwmvXpUmr0bid/5uWLDGTsRYFVHuD7ND5X8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lQs8TkDHfd58wXIvR7ltxIqvuxPvMgpuajEWZcA7U3QQXa+hRxwq4Wu8FNUQF+1QlgpFk5xRtvV7trlK/SuNi1j1jkVEwTC2BjA2UNXPTEUfrq0SwO9otjug5Gaqjfzr6bGknzyrqZlYM3wqTi4OoGzDls7kFNy0PSxCvLTrigU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BGgY5BM6; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BGgY5BM6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772040929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tSRem5oxOU2IDDdQ2E3UwWWmJ3yb9FJ/cqyqXPmzMQg=;
	b=BGgY5BM6/Tl9tHFSxShQOW8PQyKMuay72Zhs4arW3APrlmWkIaF0RRnE4aoXc2QTsVMvKc
	RSwl/AFGzWeesCVowLa+4awRjjjUWHzuME7vr4BrrTPH9TqgVjnV2mETG+McbbB3of7U/c
	PITUfd1sKNDvW9od7CS04tzhIdk5j8I=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH 0/3] KVM: arm64: minor fixes about S2 page table walker
Date: Thu, 26 Feb 2026 01:35:12 +0800
Message-ID: <20260225173515.20490-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

A small step towards fixing the issues discussed in
https://lore.kernel.org/all/3f88cd49-68f1-4276-a067-b7c6beadb27c@linux.dev .

Zenghui Yu (Huawei) (3):
  KVM: arm64: nv: Check S2 limits based on implemented PA size
  KVM: arm64: nv: Report addrsz fault at level 0 with a bad VTTBR.BADDR
  KVM: arm64: nv: Inject a SEA if failed to read the descriptor

 arch/arm64/kvm/nested.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

-- 
2.53.0

