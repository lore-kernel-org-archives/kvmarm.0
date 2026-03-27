Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A043E5EFB
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 13:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774616473; cv=none; b=YkdeabJIX98NH9KnafxfsrAWWqPf7keq1p0wTobVDC2Fi76cZV8AocByoKQ4mWc0Sulows7tFAgs5fnZY06brUG3HsBYQIi84JdIpKP/piJ4QCbD1vne8JhPm58TTYbbCp24y8ZiBjvSvG0N7KOa/7JmIyWYua8PnpWNkqBxtQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774616473; c=relaxed/simple;
	bh=clZGoSYnunaz353uIOTaKe0JjLBlcI1p6Gjqr/3pQlY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yexx4ugnhTzi/N7WD0X3t7jbqOOW/sHQclztNc0rzgR7daTbGE1UoHi3BgcF9aJbUvcAiUTy+62ZxCX/d2pnrD8QkZM8792loiSzgW+Y5UNSNZNyfX2o4tez5Ea+0WEX0Lr6daysqvPyDj7+C6/6sdwwkuL5gWdGYzACqcFEtXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PwixPOwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PwixPOwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD901C19423;
	Fri, 27 Mar 2026 13:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774616473;
	bh=clZGoSYnunaz353uIOTaKe0JjLBlcI1p6Gjqr/3pQlY=;
	h=From:To:Cc:Subject:Date:From;
	b=PwixPOwjLr7IToaBIVQvvm8EabafJiiQs273lGLio3ZnZ8LquoyM5RStVq6Qk3YWr
	 30tO7KfGGpZ1oNVvK6uagOMCmIYGrWTpQ94VQXQpWgPm4NFzOeGe7QRY0EtloRCMFK
	 m4qsJlfszlS+hAs6Zo942V0Bkt3efxd/4e8G5R+ShjiyVsUJAUrG8QFFI6nK2T7A1n
	 uHPfneNduK9KhIrEipXQwXPZ43AHYCQjv4DtY3SeaDDQN49omOBhg2GcIUKv0gcNgo
	 TQ8JinVdHIm2XoWjIBXJNJDj87EQ555xSPCQSvhj69fbGS8crz5jTPSNSHGQ3QkC6R
	 EFjv/ZmAfr0qA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Yabin Cui <yabinc@google.com>
Subject: [PATCH v4 0/3] KVM: arm64: Fix SPE and TRBE nVHE world switch
Date: Fri, 27 Mar 2026 13:00:43 +0000
Message-ID: <20260327130047.21065-1-will@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

I got the Sashiko treatment on v3, so here's a quick respin to address
the BRBE thinko it found in the last patch.

Previous versions of the series are available at:

  v1: https://lore.kernel.org/r/20260216130959.19317-1-will@kernel.org
  v2: https://lore.kernel.org/r/20260227212136.7660-1-will@kernel.org
  v3: https://lore.kernel.org/r/20260326141214.18990-1-will@kernel.org

Changes since v3 include:

  * Retain zeroing of *brbcr_el1 when saving BRBE state
  * Dropped R-b / T-b tags on the BRBE patch

Cheers,

Will

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: James Clark <james.clark@linaro.org>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Yabin Cui <yabinc@google.com>

--->8

Will Deacon (3):
  KVM: arm64: Disable TRBE Trace Buffer Unit when running in guest
    context
  KVM: arm64: Disable SPE Profiling Buffer when running in guest context
  KVM: arm64: Don't pass host_debug_state to BRBE world-switch routines

 arch/arm64/include/asm/kvm_host.h  |   2 +
 arch/arm64/kvm/hyp/nvhe/debug-sr.c | 116 +++++++++++++++++++++++------
 arch/arm64/kvm/hyp/nvhe/switch.c   |   2 +-
 3 files changed, 95 insertions(+), 25 deletions(-)

-- 
2.53.0.1018.g2bb0e51243-goog

