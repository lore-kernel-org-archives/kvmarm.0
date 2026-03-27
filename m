Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C46B23E330
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 19:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774639691; cv=none; b=fLwkK61W6rwXlTh03I03uBNsFOP37o4mK7e4jZL7ou30w9wO7ceeX5wJ/4iBrJVOiYZdTMpPY3Lvn0eHWcuDX8xv1HtVAFMBtCMvWSvj1udROpvuoGZStPYpNyvI+ORADjo+nlyloJx1NoNI5kGHXVcv/J/jJnFb+R9cwMOv9rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774639691; c=relaxed/simple;
	bh=6fASlMcZDdVsHCTt1uhCxnsHEkKnDO2hrSP4QRWJYyg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IltxjAkxZ0WgahRKL15IhGxHbOxvnw87yuU5syeCCZsrvX2q263iOtTfmVT/0NNONdODOcjxlpG3p6TcUycabc7mpZTwxlQVaDqPkOez7k4UfG9MtEgIhb3AkbIppzLCwmVNpNQbgk1PanHGh/mx40j0190CIyJebbUT4WDbD9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rWGVw+Yo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rWGVw+Yo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F4DC19423;
	Fri, 27 Mar 2026 19:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774639690;
	bh=6fASlMcZDdVsHCTt1uhCxnsHEkKnDO2hrSP4QRWJYyg=;
	h=From:To:Cc:Subject:Date:From;
	b=rWGVw+YoWUmbbep5eMAywEHm9AzG11V3L7cRxNihEX6U/477YCyIBzxc+4By0uX7U
	 PB6hRB0rTW+FCp29KyA6nGvWjNIv0wub463udeoN+U2Aak6hso+DQCc5aXbKOyBHlx
	 M7bhKjGx0bcLWR9os1bcOaELHKLfl+4RxuTysVrnOHu2PbeXwrR7OQM6BUbxH9HCAN
	 13SPKcWRA36CqchBmCot4fAosYofQCtlo+mfoFg8GhTKUJJx+yTWfsP5ktSlD4Bz5o
	 NnXTM5zA2BMHvpYHyrVfBmqItsQi1o7yWlwrmxbEhYa41/MRiIFn3luuJVHIlJBLSR
	 hiGmQNnXC9+iQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/2] KVM: arm64: Tentative fixes for page-table lifetime issues
Date: Fri, 27 Mar 2026 19:27:55 +0000
Message-ID: <20260327192758.21739-1-will@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Sashiko highlighted a couple of potential page-table lifetime issues
in the upstream code while it was reviewing the pKVM protected memory
series. They make sense to me so I've had a crack at fixing them and
writing a better description of the problem in the commit message.

For the second issue, I've tested it by forcing the notifier
registration to fail and then watching the SecPageTables line in
/proc/meminfo after attempting to create VMs.

Cheers,

Will

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>

--->8

Will Deacon (2):
  KVM: arm64: Don't leave mmu->pgt dangling on kvm_init_stage2_mmu()
    error
  KVM: arm64: Destroy stage-2 page-table in kvm_arch_destroy_vm()

 arch/arm64/kvm/arm.c | 1 +
 arch/arm64/kvm/mmu.c | 1 +
 2 files changed, 2 insertions(+)

-- 
2.53.0.1018.g2bb0e51243-goog

