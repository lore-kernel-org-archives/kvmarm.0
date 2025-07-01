Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F94275869
	for <kvmarm@lists.linux.dev>; Tue,  1 Jul 2025 15:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751383016; cv=none; b=kJ1fyx+UCBmRckBTYuqAaiZQl5tue5nCfUoI3zZW0G7UG3qTJ50dGr7OSTNf1EVgFBxfn2TT1pF7rqLC2/2EgWFf0G3EG0d/KnKKqndQjc49XEDD9v3fxt0VqkewDKAq4WEk/1OCevwKPinOdfhsem6/F3MWW3NzOA3QU6Hh8GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751383016; c=relaxed/simple;
	bh=EJQJBBlk1v5T+bL6aDyXe5U4Gd/9cKEPuNnqZJJuUwk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iUGL1sBfbGRObjwb0x8VpxnUWljxU77p+RwDYnTQP66bAxSZOFSGrEQ9Z2LzN+YktHz5xADdQ3hXSX5EKkT2brcXa7dlTYLYtc1ZVXPH9BQ0KwlKncegwYGZRhRGwBKv3RDpRnkavcZIzTiCUh5FgL93/6frt9Ngt/qAJLxDbzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CvWkxYL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CvWkxYL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C6AC4CEED;
	Tue,  1 Jul 2025 15:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751383016;
	bh=EJQJBBlk1v5T+bL6aDyXe5U4Gd/9cKEPuNnqZJJuUwk=;
	h=From:To:Cc:Subject:Date:From;
	b=CvWkxYL8SVhr7on0sWNzcIn3DTjUQJaEHWksMZQGTQ1UoQbykCAfhnbI7+MvHr9R2
	 Y1eUIGrLM7/tSR54eCcf3nKAb1T9TemWKXrqQS34sMsMrs+ZmGlQx9CwTWE1PNOrBK
	 ttrCVMhOTZMduqreendX0w5OyMpoxziqJ2OAxSdGFER/XUaQltAWtwomBwKgfKZX9g
	 DLP+1A1KEc+YPfevkifWkwYQmBB6rRY7rjvYfQAjIFkMtECyr8Q2Ay6/5Lr+/CUUfC
	 3Jvi2UwvpPFynj3uYCwdAK6hgqgZ9/d9RANLXNcQyToTQIUSL1klxF+yJj4KPbS0Ad
	 Skjf4sv9NN7bQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uWcj8-00Bch8-Gf;
	Tue, 01 Jul 2025 16:16:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/2] KVM: arm64: Fixes and clarifications for FEAT_S1POE
Date: Tue,  1 Jul 2025 16:16:46 +0100
Message-Id: <20250701151648.754785-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

I (almost accidentally) spotted a couple of issues with the current NV
support for S1POE:

- wi->{e0,}poe and wr->{p,u}ov are used interchangeably, and sometimes
  in conjunction -- none of that makes much sense

- The two rules describing WXN are not exactly been applied to the
  correct state

These two patches address these issues (not that it matters much yet,
there is no S1POE HW out there).

Marc Zyngier (2):
  KVM: arm64: Remove the wi->{e0,}poe vs wr->{p,u}ov confusion
  KVM: arm64: Follow specification when implementing WXN

 arch/arm64/kvm/at.c | 80 +++++++++++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 36 deletions(-)

-- 
2.39.2

