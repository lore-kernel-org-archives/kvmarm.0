Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2F88F7D
	for <kvmarm@lists.linux.dev>; Thu,  2 Jan 2025 22:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735856443; cv=none; b=fzE0gxY25CkPCaELa91eKuVvCKLsdMVb8zbo34b5GIvLyEJNjxfL5C0bn7w54NaDjGDYw8t9zu8tCVVeSkl/tBdaKX1N8Rl6Awr9YZAKmCutVbqqlTSYJjxqa91k4/oTQTsyRVc/cveb/cJd7pW5Mb5SLb2vXpAv/RVqdlXG/Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735856443; c=relaxed/simple;
	bh=ZPMVFvekgfEQcPWq4ctHuJPlF/h6r6wwUm37ZrGm/GE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rnepLODtEZIaUJ8m1cXZcG47yEVSX8c6bEJfn1e0EiSA2eDBsDx/Ioq33HFizHavzWzIc5laHV9qmeF8iQO823u6zU5XdB6F/HZEr7YyuxKFliREmOglChW6b9jSv5S9ebkZwchBp/WazyK4YCB7TBGK9MgUwwYlq39Zpw7Ckcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vOy6lKPY; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vOy6lKPY"
Date: Thu, 2 Jan 2025 14:20:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735856440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=20Vuf44vqQZnOQ/grQMGvEwR/ncOA7pXlyQr1M4eRZQ=;
	b=vOy6lKPYq6ZugWKkqZ6PDlKMwCEESwJfUXKPs+DQm+S+bRQaCtEMBRC10BWQ2aE87OYaCi
	xdhfAT1aybofvSdhpIWCmOdJHWY/gjzH07AhczmmGzze+g8gHxNmI3GcdLcZ/yTjGTlqlS
	jujWLHAxhbCVnkOkwOeV4RC2FnWsDnU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, Mark Brown <broonie@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [GIT PULL] Last KVM/arm64 fixes for 6.13
Message-ID: <Z3cRLtgqPUCvyrkj@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Paolo,

A little slow on the draw with the last set of fixes because of the
holidays. Nothing particularly remarkable here given that both pKVM
and NV are in a half-baked state upstream, although the selftests fix
does plug a new test failure as of 6.13.

Please pull.

-- 
Thanks,
Oliver

The following changes since commit 78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8:

  Linux 6.13-rc3 (2024-12-15 15:58:23 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags/kvmarm-fixes-6.13-3

for you to fetch changes up to e96d8b80afd3f63ffad58c0fdd5e0c380c4c404e:

  KVM: arm64: Only apply PMCR_EL0.P to the guest range of counters (2024-12-18 13:22:25 -0800)

----------------------------------------------------------------
KVM/arm64 changes for 6.13, part #3

 - Always check page state in hyp_ack_unshare()

 - Align set_id_regs selftest with the fact that ASIDBITS field is RO

 - Various vPMU fixes for bugs that only affect nested virt

----------------------------------------------------------------
Mark Brown (1):
      KVM: arm64: Fix set_id_regs selftest for ASIDBITS becoming unwritable

Oliver Upton (4):
      KVM: arm64: Add unified helper for reprogramming counters by mask
      KVM: arm64: Use KVM_REQ_RELOAD_PMU to handle PMCR_EL0.E change
      KVM: arm64: nv: Reload PMU events upon MDCR_EL2.HPME change
      KVM: arm64: Only apply PMCR_EL0.P to the guest range of counters

Quentin Perret (1):
      KVM: arm64: Always check the state from hyp_ack_unshare()

 arch/arm64/kvm/hyp/nvhe/mem_protect.c             |  3 -
 arch/arm64/kvm/pmu-emul.c                         | 89 +++++++++--------------
 arch/arm64/kvm/sys_regs.c                         | 32 ++++++--
 include/kvm/arm_pmu.h                             |  6 +-
 tools/testing/selftests/kvm/aarch64/set_id_regs.c |  1 -
 5 files changed, 62 insertions(+), 69 deletions(-)
