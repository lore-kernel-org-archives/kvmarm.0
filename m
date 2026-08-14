Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0E53515EE
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 10:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786703616; cv=none; b=qDuaCY7ubLqBv0gsMtaDmJJyXvM+2SKy6DnbE95C/sVtnKsrsWZDNLqrG+6zSG/oM+oKe3FG+cSwaalrJzPmD3QkjedwuQwtZjXLnHgn+ErspNh1vDP61jGEf3Ti2o/TYTrpZx04cBOog3RQzusLEFYSQy7phnMCQGKyF376lwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786703616; c=relaxed/simple;
	bh=0E3Q6KZaWSRqfjeEucYhL8capX/XVc5bVrcvUekpt1o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JeMNUCA9mLy/a2XWHF+NJHcUqTpP0L5NYP4Xn/Xsb2mV596iRpW2llzfqUpJzmo1HTZ8fBsDJI5G8QIRidNcALB8fSkeg0wbXHBnngzteF/+JmyNeAj3/3A2G5dRryK4x+Erl1w9DbS6Guk0Kge8S2wJKuADBwixRx454K3ylcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZzamFo2D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZzamFo2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7301F00A3A;
	Fri, 14 Aug 2026 10:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786703606;
	bh=gWoF82RYFJwJElEEQ8rjV8LHygpxdWPmPiSAGiUpOdo=;
	h=From:To:Cc:Subject:Date;
	b=ZzamFo2DtTzFVfcyeEGG5XXsD6QQ8f8/ttmwPHVWHJs2K+rWmDWh/1qJf5UpSpaG4
	 vZNOVWKua1TrwjTJqow68LlRDfTZaayZN9SD9gg/vlEmSnIcXPHFPOiFliORc0UtRz
	 O7eADigC6mm85FtO0EvwjatK+KuVAQs98FnwLt/ROJ6zdoFriWhCG1KnsfPrToMO8s
	 0eOtXvh+om/BvTzMvwEYInx5ruKBetI3NWTf91qfXaivH/qv1ep7yOzmLP6lehDm/L
	 Sb15ufTnux1c3ZZ3KinLPlQsMYaNLZUXHwqxi+DvCEP0FnGDH+mbNFYo19SJGOCn3O
	 kobtgTpIVbpog==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wupE3-0000000FdQO-32Xs;
	Fri, 14 Aug 2026 10:33:23 +0000
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
Subject: [PATCH v2 0/2] KVM: arm64: nv: Shadow S2 life-cycle fixes
Date: Fri, 14 Aug 2026 11:32:28 +0100
Message-ID: <20260814103230.858578-1-maz@kernel.org>
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

This is yet another stab at trying to fix a bunch of annoying issues
(i.e. very stupid bugs) that plague the life cycle of shadow S2 MMU
structures and page tables.

The first patch is identical to [1], only with added lockdep_assert(),
as suggested by Joey. The second patch finishes the job (at least one
hopes) by freeing the S2 MMUs when it is actually safe to do so.

Both are targeting 7.3, and are stable candidates.

[1] https://lore.kernel.org/r/20260811122057.754772-1-maz@kernel.org

Marc Zyngier (2):
  KVM: arm64: nv: Fix life cycle of the nested_mmus array
  KVM: arm64: nv: Delay freeing of shadow S2 structures until VM
    destruction

 arch/arm64/include/asm/kvm_host.h   |   2 +-
 arch/arm64/include/asm/kvm_nested.h |   3 +-
 arch/arm64/kvm/arm.c                |   8 +-
 arch/arm64/kvm/nested.c             | 115 +++++++++++++++-------------
 4 files changed, 69 insertions(+), 59 deletions(-)

-- 
2.47.3

