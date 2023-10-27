Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C377D816
	for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 00:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WwHQMZf8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698368089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cq/zS3bClxm7imQuXSmhkVhZzdLZ0oD5E8hPeZyMmAs=;
	b=WwHQMZf851niOPkkGeadjQ36LlhhpBLcxa3AUeqdx3S9WuUaGtA/1k3YFW81S15jE70V1y
	ExRV6gIE7nlOecKA4zCT4baT0EId/aNk+lTlpXmnqWZCBZ4f3futEZm7SP+QUnyhhKLO/+
	Od3X89MvtD9O8TlETpooZFYmtaRpgIE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Aishwarya TCV <aishwarya.tcv@arm.com>
Subject: [PATCH 0/2] tools: Makefile fixes for sysreg generation
Date: Fri, 27 Oct 2023 00:54:37 +0000
Message-ID: <20231027005439.3142015-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Fixing a couple of issues in the Makefile changes required to get sysreg
generation working.

Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>

Oliver Upton (2):
  tools: arm64: Fix references to top srcdir in Makefile
  KVM: selftests: Avoid using forced target for generating arm64 headers

 tools/arch/arm64/tools/Makefile      | 16 ++++++++--------
 tools/testing/selftests/kvm/Makefile | 11 +++++------
 2 files changed, 13 insertions(+), 14 deletions(-)


base-commit: 54a9ea73527d55ab746d5425e10f3fa748e00e70
-- 
2.42.0.820.g83a721a137-goog

