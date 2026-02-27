Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9CA2BE63F
	for <kvmarm@lists.linux.dev>; Fri, 27 Feb 2026 21:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772227329; cv=none; b=mxLP26rp3xdmajmVgzq7K9WrB9N5IUIbidcYWaiwu7+URdrdTJk5G/TOSbMX3iXYOMLohpSmDKs1rE5D0Bj1hr1oV9OiTW//OaCf2pINtftIO2j2lvtiLqkZq77oEIrX3zTL5RPDyXbFjIjZGN4mK/7TLQ2oUrCfqVv/LVCw6Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772227329; c=relaxed/simple;
	bh=lbmOvF2j4H2gM9f9E+jo9GT5XZZz8FGdqwqTpXMG4fI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gCVJGnWuVasE7tciFhVaQDGNE+mhYr7cha+21ToQ8t9N5PboYfjOzM2VuGIViV0wwCjH/tUOV/h5BtT2KdjjRK6WY9aK84XnwK4vE1/PfPEvqS3ZRXZ3eaQDbvOFWMv5SZUZKPE4ruxjHx01tgSdoW08ejhkG1pesUU/YQRX8Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AenEIsFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AenEIsFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22E0C116C6;
	Fri, 27 Feb 2026 21:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772227329;
	bh=lbmOvF2j4H2gM9f9E+jo9GT5XZZz8FGdqwqTpXMG4fI=;
	h=From:To:Cc:Subject:Date:From;
	b=AenEIsFCWc6WXPcDF5B6PhuzvHPP+0WZOmq0yCR8YrYKZtRKcgmiQY8y1aLEo8aFN
	 CTX3Z5J5eB4kt1QfbDT20nshkL+XgnPnNBX2zymU9dqxSKhzmfvd7WgNbQ5GlQE5mL
	 p7Nxm9CPlIPuD62DZlzdK8da64canH6RPMvx3DS+aAeS67nzSzsFopuAx8PAriw2CX
	 JBjj+PBYolRueSnaWjbdRgQk87H4CEOGaptmUoc3QVd9hOl1H9ukWG7IP5OAfv/UI0
	 i3es00DaYaEUKGlqhbsTNl1R47d14VKVFNjtmfIFG+D8hzQttU46ODDpPzNtQKvZek
	 szQlCXdVTM+ng==
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
Subject: [PATCH v2 0/3] KVM: arm64: Fix SPE and TRBE nVHE world switch
Date: Fri, 27 Feb 2026 21:21:32 +0000
Message-ID: <20260227212136.7660-1-will@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This is version two of the patch that I originally sent here:

  https://lore.kernel.org/r/20260216130959.19317-1-will@kernel.org

Changes since v1 include:

  * Add missing memory barriers and comments for each step
  * Work around known CPU errata in TRBE draining / enabling sequences
  * Fix SPE as well!
  * Minor clean up to BRBE so that it smells the same as SPE and TRBE

As before, I've not been able to test this as-is.

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
 arch/arm64/kvm/hyp/nvhe/debug-sr.c | 118 +++++++++++++++++++++++------
 arch/arm64/kvm/hyp/nvhe/switch.c   |   2 +-
 3 files changed, 96 insertions(+), 26 deletions(-)

-- 
2.53.0.473.g4a7958ca14-goog

