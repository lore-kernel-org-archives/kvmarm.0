Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FCF3A450F
	for <kvmarm@lists.linux.dev>; Sun, 19 Jul 2026 16:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784478801; cv=none; b=CI+wI6yiem7XsmR+Okxmd17tdlw5eYRH9pzR/s0bFJlkhxted0yEJeMB3g1iWj9CLjfBiYSyYM5826fm8/KBnGZYJ64zx0rpJg0vp2e9YD8JD0TLEiyzJ9muNgnwWx+bATBWnRkDdzyCX1utyG/6tB8b2hjLGKPZqpcFU4CiXho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784478801; c=relaxed/simple;
	bh=p0sJ6xbFKfrT+kvRj0p/Ed2cMpOSxbadvf3/VB01zR0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kvpC5bRau8ve1dMso6EivgeGL9tktlGHQCThzZekj51ES2rVZXMzDqxQ0HUcGNwpoyS9xh05xy0K1wYuM4u/hzjlIY2r1R9YMu3gOQUdOIa5CnWI1p+Q+OgIzeCxbdLO5KgeklKh0mT1RAW76JWYv8FLYnFD0LPVJFlNApYgOQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AO5lYXSZ; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AO5lYXSZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784478796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=smZHGSZd+IO/AnN/uVg98gEhWkbFF04beTjXtjoJyL0=;
	b=AO5lYXSZ0R465A+cTpfuESj7WV8mppFUwrTglz4gh1Qx83JeIw5v09WYTF5mBOVj3PqWZc
	UdDbkMSGBBtJw/885isZNMQQxoAGbAlT4TC7xCfHZNYh1dzrJ8uK2fbgzEALpRG3+15e4n
	cm7yk6tX6B1Rsl9IHmaqJLdnT0x1guc=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	tabba@google.com
Subject: [PATCH] KVM: arm64: Update Fuad Tabba's email address
Date: Sun, 19 Jul 2026 17:32:57 +0100
Message-Id: <20260719163257.3156529-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Switch my KVM/arm64 reviewer entry to fuad.tabba@linux.dev, my canonical
address for kernel work, and add a .mailmap entry so the existing
tabba@google.com commits map onto it.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 .mailmap    | 1 +
 MAINTAINERS | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/.mailmap b/.mailmap
index 735470e21075b..91003fb861367 100644
--- a/.mailmap
+++ b/.mailmap
@@ -291,6 +291,7 @@ Frank Rowand <frowand.list@gmail.com> <frank.rowand@sony.com>
 Frank Rowand <frowand.list@gmail.com> <frank.rowand@sonymobile.com>
 Frank Rowand <frowand.list@gmail.com> <frowand@mvista.com>
 Frank Zago <fzago@systemfabricworks.com>
+Fuad Tabba <fuad.tabba@linux.dev> <tabba@google.com>
 Gao Xiang <xiang@kernel.org> <gaoxiang25@huawei.com>
 Gao Xiang <xiang@kernel.org> <hsiangkao@aol.com>
 Gao Xiang <xiang@kernel.org> <hsiangkao@linux.alibaba.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index a674e36529f75..5ab6fc1504267 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14192,7 +14192,7 @@ F:	virt/kvm/*
 KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
 M:	Marc Zyngier <maz@kernel.org>
 M:	Oliver Upton <oupton@kernel.org>
-R:	Fuad Tabba <tabba@google.com>
+R:	Fuad Tabba <fuad.tabba@linux.dev>
 R:	Joey Gouly <joey.gouly@arm.com>
 R:	Steffen Eiden <seiden@linux.ibm.com>
 R:	Suzuki K Poulose <suzuki.poulose@arm.com>
-- 
2.39.5

