Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA2D343894
	for <kvmarm@lists.linux.dev>; Tue,  9 Jun 2026 18:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781031127; cv=none; b=VDykK23zlCKLcROP6NyTBhx9Xa9pe5dRWcP0g5Wh6DLhQmzD+PKkNQN8nYBQeQNZrIJqFe0UxzSyiXcS17voPmtwJ0dUGdJGbTS2VD8seUySm+MAu4aXOgqRSPmS9cxzfjsVxHBmvZo1Ko3e+t+aiBuq1kW6g6lwDGkf/FcUocQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781031127; c=relaxed/simple;
	bh=9SH/cudvX52DGv2ny9DurWlRxZr4Qlwgq8m3z+lEx9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IQY7/p8SpJT9/Y6S9GlNulQxKl5gcxL3dOXrzWjRhpF3NHvzgmCRRfJ/Xw3RULHe0GWFFiGdZuMgfWx56zRaDkoLOylZoUzGOFb9xAWh60y0gf2PVw7/R+iwxyObxQb8zIQK1z2PyVi+2Taz2EV9YOE0Wf31s7d04lDBZjDJXkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NyIZ14LT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NyIZ14LT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345BB1F00893;
	Tue,  9 Jun 2026 18:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781031126;
	bh=U/5xc3RPnZ2BKXwM5O535wYk/P6ZtZfpSjfrj8XileE=;
	h=From:To:Cc:Subject:Date;
	b=NyIZ14LTVeWZHjoWghtGxNDkzTH48EE4871bAYvOM2YGMawUxbRK6/zeR37R6Budo
	 XuPqY0JsE45Ib9NvGoHfs/4F+zYfuw9AJhmdlqq+oH51zTBuk+H09QVTkbcb6yNATZ
	 GbApDvruCrXn6s7KwwJzocgpskhT3J027l4oApxpy/eY/kJ4RRqjlNUOz9e613YRkf
	 HaKMnf6yyYSqdXbvyrS3UoYC3FQJzQqNeh9ebjZm71w3xehVEsLSu7MT8L+ztcD9I1
	 3+4XZqOF6Q8uonFEGVv2IcW51gvTc5jH4lXwfj0XnqythKehAag/v0WgrIPLxVFIsQ
	 IRkrfBtMk524Q==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 0/2] KVM: arm64: nv: A couple more VNCR fixes
Date: Tue,  9 Jun 2026 11:51:56 -0700
Message-ID: <20260609185204.745929-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Another day, another handful of ugly MMU bugs.

The first addresses an issue where the host stage-1 VNCR mapping only
relies on the guest stage-1 permissions, potentially allowing RW
accesses to an RO PFN.

The second avoids a BUG_ON() in the case that the output of stage-1
translation exists outside of a memslot, and instead does the usual
thing and injects an SEA.

Based on kvmarm/next since the first pile of MMU changes was taken
(thanks!)

Oliver Upton (2):
  KVM: arm64: nv: Respect read-only PFN when mapping L1 VNCR
  KVM: arm64: nv: Inject SEA if kvm_translate_vncr() can't resolve PFN

 arch/arm64/include/asm/kvm_nested.h |  8 ++++++
 arch/arm64/kvm/at.c                 |  8 ------
 arch/arm64/kvm/nested.c             | 40 +++++++++++++++++++++--------
 3 files changed, 38 insertions(+), 18 deletions(-)


base-commit: 406f0c31f47877db036e885f15830106b89ca950
-- 
2.47.3

