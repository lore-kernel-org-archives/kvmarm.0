Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85770282F0B;
	Sat, 21 Mar 2026 21:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774128278; cv=none; b=JsClRNiGYhP7/CEz49eELMy+60YHmRKcf7IGA4IESfojA7C0fJ8euFjdzmhlcssP1WBh/QNh7i0NUeEwZcfqg5wHbyG+KGrAaQ0dSF+dWoA237dWqJRaywnNpzX/5VznRIZtr/Npy2hAmEmkLkyAs+3eXUhxX8qQqY7ExECm1gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774128278; c=relaxed/simple;
	bh=nRoaLuGwYpbMvsPMsvVjX2A8kmDi7xUzyfUclf9j2sI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lKSqysC4Uz6um2gGxAKniTjMJSMr+fIAjLd0DHJ2KW9MDlp1XH3JjHA3q50LY8pZRjOmvz4n++LAoI74qndfEiVUWQQpuvwyDMyl8fDmu08ElA3aw2jKKUhaekVO7385G63vfxekoppJhIao0S16Z1zAGugsY5iaKPx+89rZrwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kxHgA9b0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kxHgA9b0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AABC19421;
	Sat, 21 Mar 2026 21:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774128278;
	bh=nRoaLuGwYpbMvsPMsvVjX2A8kmDi7xUzyfUclf9j2sI=;
	h=From:To:Cc:Subject:Date:From;
	b=kxHgA9b0ymDLPEMZUXO1eGE1UH8fHQHKuNn4TK80XUw7V13PyyCrq/exXa+enbE3O
	 cyWBS7Gp+PmdL/f0u/4S2PMakkepZE91N0UeoUIt1rrZwRf0kkH9XiB4tHkSdQctP0
	 E8vCHmr0GrXszj9mGI1yBPQNVFD7OjU2r7LGBi319XEO7oweZBxLgt30Y0SJSgDsCV
	 MC94O/Dg1Mp0f9B45oyfZ4VtV0e8gksS5wBRZ1IwEPbgW/3jqj5jO0LB9rOz55aLk/
	 4SVwrijbWuDaNWY5xJhHDozZ/yr1bs8A2B194wadkF95+0F9UbsjXPkyCV+iF/jqG+
	 CO4TdJAQgEhkg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w43oB-00000004NPB-38Z0;
	Sat, 21 Mar 2026 21:24:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH 0/5] KVM: arm64: pkvm; Rework aspects of the PSCI relay
Date: Sat, 21 Mar 2026 21:24:14 +0000
Message-ID: <20260321212419.2803972-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, smostafa@google.com, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Having recently spent some quality time debugging [1], I ended up
reading too much of the PSCI relay code and felt that it could do with
a bit of spring cleaning.

To be clear, this series doesn't really fix anything. It simply adjust
things to my own taste, which may or may not be everyone's.

Comments appreciated,

Marc Zyngier (5):
  KVM: arm64: pkvm: Move error handling to the end of kvm_hyp_cpu_entry
  KVM: arm64: pkvm: Simplify BTI handling on CPU boot
  KVM: arm64: pkvm: Turn __kvm_hyp_init_cpu into an inner label
  KVM: arm64: pkvm: Use direct function pointers for cpu_{on,resume}
  KVM: arm64: Remove extra ISBs when using msr_hcr_el2

 arch/arm64/include/asm/el2_setup.h   |  2 --
 arch/arm64/include/asm/kvm_asm.h     |  3 +-
 arch/arm64/include/asm/sysreg.h      |  6 ++--
 arch/arm64/kernel/hyp-stub.S         |  1 -
 arch/arm64/kvm/hyp/nvhe/host.S       | 11 --------
 arch/arm64/kvm/hyp/nvhe/hyp-init.S   | 41 ++++++++++------------------
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 39 ++++++++++++++++----------
 7 files changed, 43 insertions(+), 60 deletions(-)

-- 
2.47.3

