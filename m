Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C65B223DC6
	for <kvmarm@lists.linux.dev>; Tue,  2 Jun 2026 16:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780419544; cv=none; b=bt35UVI4rXRmFv9p4guqQAZt62+E9OrmHBhAcXa+nYQ51KC5dPpG2/SVm7MD4gzxFYhK66upZe5dl/sgnygczESinXuDNM+pPHa0fpXegKkJZpzT3nC803b2kggP6DmUqR2MrQjFtpPwBK8NNPWp0z5THQ+Rtkae+GZAZuC4+Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780419544; c=relaxed/simple;
	bh=spvw/5uhWkpMKJM/vjt1k1eQk8SqMTIjMFprMVRAnvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YF0CJDu5qjmyuGEd69eGNop+7fzCi1ptwwg8aEsBMQFYcYIHpl9m93HB0ttbJBgHRSwwVAcUH7J5owYLlWTrnX58/Rs5tbso0bT0RrWVDd0nBSW8zZ/NxWfwnF5QcMqA/LJrXag/cP8kpmAIdViZyDQq68anVEj2BGZxmjo58W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CMZoPk4z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CMZoPk4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BF01F00898;
	Tue,  2 Jun 2026 16:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780419543;
	bh=c/tJru/knKDnzk9orSLpVZlqTA2j+VpCTV69uY6yJkU=;
	h=From:To:Cc:Subject:Date;
	b=CMZoPk4zFjlFWVmthu8JwQ73peqjdGvaHgv+2j/7BGXpFQjfEVxX81s1NBmQXqt3G
	 NbV2kETbnLhm2+ht95vF0AEDZ8tmbAjb9ncQfcu1CmSa7kuUfdLEUKLc4wHMqOYGuC
	 lSAZlE/h8u0hGGiTEfImzEEH/2AETmpUIRl7rBEXl1BWZ2LKP1JmqklJ7PoAhoWhdL
	 Ss2kiicNs0rHMmbEpbjx89suUJQGVBpWJI0fwLPzxz/BIMela0lEobrwrSrSnNvKAJ
	 pW8w7eGg5cxuEI9j0vqHZKgcuj1WljFMxaZromkWHEg0EbJ+Yfo4sD+uUg7ggZjUGu
	 I4lN58jJ7Y07w==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 0/2] KVM: arm64: nv: Fixes for FEAT_XNX (and the lack thereof)
Date: Tue,  2 Jun 2026 09:58:59 -0700
Message-ID: <20260602165901.52800-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sending a v2 to address Wei-Lin's feedback and fix an additional issue
spotted by sashiko.

v1: https://lore.kernel.org/kvmarm/20260602072759.37885-1-oupton@kernel.org/

Oliver Upton (2):
  KVM: arm64: nv: Fix handling of XN[0] when !FEAT_XNX
  KVM: arm64: Correctly identify executable PTEs at stage-2

 arch/arm64/include/asm/kvm_nested.h | 4 ++--
 arch/arm64/kvm/hyp/pgtable.c        | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
2.47.3

