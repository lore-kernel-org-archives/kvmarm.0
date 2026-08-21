Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329C53630AE
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 16:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787329116; cv=none; b=Ib5NrAUpKiFyOSM1xIYANviBVXaITexsifeHTZGfvRMCcNP6eCbyl4EqZIVZi+0Kldd5clOk5NPa4lEMg8ftuLw6tCWiXyZzEZ03OpjyqdNkdbEdu5PZdI/KwTv40xen356WUKJ3bcnjMeW88+kHVzhaNM7W0Kxg7c++kS7qh6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787329116; c=relaxed/simple;
	bh=7GbSPrY7KihDMgo8ewA/GI6j+khnco4/sk2wzONAJL4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bVi70ZzXdU3ZiIJvY1KFkkeWIFsJZH3AIn+s820c9PqJUxRcJchZ9maDzYYqg2o8zoHeSHtt+m1Vgm5LkHRkpsdk5yrPLD54XXID3zcekfHa6rP/2Xh2dvYXwvhAUJ93rDEhGbDmfqMtS2inyA2Zv8EReFodoFtl5M7RyWsTieg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nleCJikt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nleCJikt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0CD1F000E9;
	Fri, 21 Aug 2026 16:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787329114;
	bh=MFdz8NPU5/wMJeL/vsXxp5eUFzRpWg8luiFq5DUlWyE=;
	h=From:To:Cc:Subject:Date;
	b=nleCJiktGqkqWtl23fu+RcGzfsMl6d7jrzCbnMJLx/lk38ApmF7vmtjFmfcyzf1RR
	 KDo6E0kSi4iCrBHUTfU7kN2k57AUNtD1d7nNTcaa7fOAjIyGxLE8gg84Fx6EnVjBpZ
	 IENHx3ord8GlXVxl40/u0mU5OmiNxYp9jkLm86sB2pwQhAb3Ol8HtIS0+3KJzeTRPe
	 /+oKnauFY+qVG9sF2S61KCqQBBLnBdyZ/jg0NUzgoG9Ij63CZrMcATTQXJI/y2HAYM
	 AcJvo4Sv9ALkTHF6Teyoteu4agOYnxyrz/5duftKjKSGef4h6+Vv8KmYIG6KxAGUk6
	 V9yM8pTkYqd0w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wxRwu-000000006fx-1M56;
	Fri, 21 Aug 2026 16:18:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	ljs@kernel.org,
	Shen Yongchao <grayhat@foxmail.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 0/2] KVM: arm64: nv: Shadow S2 life-cycle fixes
Date: Fri, 21 Aug 2026 17:18:27 +0100
Message-ID: <20260821161829.1032561-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, ljs@kernel.org, grayhat@foxmail.com, kmehltretter@gmail.com, weilin.chang@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is the (hopefully) last revision for this set of fixes for the
shadow S2 life cycle.

* From v2 [1]

  - Fixed the nonsensical type used for allocating the nested S2
    array, switching to kvmalloc_objs() in the process, guaranteeing
    some level of type checking

  - Dropped the extra S2 freeing after Wei-Lin pointed out that we are
    guaranteed to run the MMU notifier release callback, ensuring that
    nothing is left behind

  - Collected AB from Lorenzo, with thanks.

[1] https://lore.kernel.org/all/20260814103230.858578-1-maz@kernel.org/

Marc Zyngier (2):
  KVM: arm64: nv: Fix life cycle of the nested_mmus array
  KVM: arm64: nv: Delay freeing of shadow S2 structures until VM
    destruction

 arch/arm64/include/asm/kvm_host.h   |   2 +-
 arch/arm64/include/asm/kvm_nested.h |   3 +-
 arch/arm64/kvm/arm.c                |   8 ++-
 arch/arm64/kvm/nested.c             | 100 ++++++++++++++--------------
 4 files changed, 58 insertions(+), 55 deletions(-)

-- 
2.47.3

