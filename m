Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7BE35201E
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 23:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782947796; cv=none; b=aEfirBIhaZHIxuf2IsglX/HeYCS2WD5/wHHwDNAZROXAC3Tf36H+L0MVNUFJI5sMM02IlcmbAzJDkwsJTv+iJ4s5TchYYmaW/6Qz7dcQZvyvDr+4BD/QNZZrc0pN3jMlW7STVuUA/nnsTUU4jEqg/TszHz6YUEM6HHsVFgipNSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782947796; c=relaxed/simple;
	bh=pDkTB/DorVP+bAB4xov6DS6cmLax7raAfTTL29usDOY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OjsLudPQ9BOJKQ4q8HqJhcNmuNYBGmWnb4p3O0wpm+xf4qn+bez1FvJeiU5FwnGPhkWzBpT0qHRaxITB2AmPHtsyvz4Oo5yM4s3UGYlXf5/6MPpD80vQwNru+wJIF02YXC6z4iHPx6mzrzDlB0YFGd+c2TbLLgmTqGxsebAQDEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QCqa6RhE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QCqa6RhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5041F000E9;
	Wed,  1 Jul 2026 23:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782947792;
	bh=WRyz9Vh487BDYIFx7AbXC+KRAbvVVVDHjmFL2zW57jU=;
	h=From:To:Cc:Subject:Date;
	b=QCqa6RhEAnqYWvuKqmB5Y2L08NaID0VD0AU/18rRZa0WPHVd2K61ZS/CXfWnUr6JL
	 AgFB7cqwfO3Y1sZGvxKuY5llmGbr/Y9rTrYgxGwBCotsyyly8Apu1r8NTUJWUwsX7g
	 uzYlcLo4wK86IacQGOY9sDA5AQbrta8q9rmpSfmRykIfovW/XARrvi7auXPRwEnLsg
	 VvU7wvhBKMml8gzcj93//Q6cMPZ51sUcEtzCNnFMcqVJ6ucJCn/MpOJ+2Y/x265rW/
	 vcB72fIRvNw+XdcgEbBgm30Lv7glHdP7T49gh0dgiA1BdIKJrwloqQ8ZzMXrYlml2s
	 d6RPy5QZaOLuA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 0/2] KVM: arm64: Fixes for S2 permission relaxation
Date: Wed,  1 Jul 2026 16:16:18 -0700
Message-ID: <20260701231620.3300204-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Couple of small fixes for S2 permission relaxation.

The first patch looks a bit worse than it actually is, potentially
consuming an uninitialized stack variable as a TLBI TTL hint in the
event of a race to update the PTE. However, if the bad TTL value results
in the stale TLB entry remaining valid, the vCPU will just fault again
and (hopefully) avoid the race.

Second patch is of a similar flavor, where the permission relaxation was
unconditionally updating XN, potentially reaping execute permissions
when handling a write fault. The consequence of this is taking an
unintended execute permission fault to restore the original XN value.

Applies to 7.2-rc1.

Oliver Upton (2):
  KVM: arm64: Ensure level is always initialized when relaxing perms
  KVM: arm64: Only update XN attr when requested during S2 relaxation

 arch/arm64/kvm/hyp/pgtable.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)


base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
2.47.3

