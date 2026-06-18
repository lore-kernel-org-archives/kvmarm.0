Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B489D175A91
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 23:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781826133; cv=none; b=pIAfCONsWZbN6qBNt/frpJzsECR2Zg1aGv5eUxdCEvxk1D5k7VeUmjX95psdX09LB7zsTliKNHTDCRmp4UJR/oFBpZB4OFeNvfYpwOa9ws5/evhQb2qF08pL1uIJmdBtIYxCFiIkfnncEN1HSDxfGOxAEHLR5LmxQXGVrGR3C/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781826133; c=relaxed/simple;
	bh=A/NfwCckC9TasC8KzLCAlu8zwpPqAES/k1oRDJDqpUs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kLJAD/TNN0cKNZMHY46E4PBPG3KNJ4mkYncvtlkI9fycQNYlsugFMf8I7Vso4LKYuiQnvq865MZ7xzKIapiO6jU3uMAK3ilbMCKEnSISWTR3EH5DW70BHJgYB1mYcuvqwSvcpkrr21oVSyk/fAmKdTR0c/5v0nUulh+kz+jZFAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QLVSb8dj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QLVSb8dj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C5A1F000E9;
	Thu, 18 Jun 2026 23:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781826132;
	bh=viWq0cQ8H7J7PiNxnh8BO0hLBM184BkWoTBi2MBpp1Y=;
	h=From:To:Cc:Subject:Date;
	b=QLVSb8djG6GYU7NXK48EKAIJMK4OFCWOosUo00XKmRoY1y6/+FVfXhageotoR5WrP
	 OrfM/RGmyIwAQjlJOJhdoOxknBR5BIoroBbJGYPzMZKmdIheKeEKQot6N7diJPL5ml
	 PmE4ssVP6gflprN9lPeM9OuEKRKTOYW08Xqi8df5MJsMwXs2ndSY3WcP0joDc7KRy5
	 JOFDtsDRNFKDEx+d+gs7r59SJa43nvCjpJpK7WhMxiUcEFCuYLb4jtqo22wolqGLY8
	 qemVby9edlzq1EZbDpkG+6E+7jULYP4JIXxNp4EXpf9hkW0rBSeZEyXmPb6XPgnY2Y
	 MBFNebZ4QxWMA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 0/5] KVM: arm64: nv: Even more VNCR fixes
Date: Thu, 18 Jun 2026 16:42:01 -0700
Message-ID: <20260618234207.1063941-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Addressing most of the issues that came up with v2. Of note, I left
Sashiko's (valid) feedback about HWPOISON PFNs not signalling userspace
unaddressed because it requires untangling the return code mess a bit.
That and the bugs fixed in this series are quite a bit worse :)

Applies to kvmarm/fixes.

v2 -> v3:
 - Avoid evaluating permissions in case of early return / higher
   priority fault (Marc)
 - Drop BUG_ON() from VNCR abort injetion path (Marc)
 - Ensure is_gmem is always initialized (Sashiko)
 - Return EINVAL for SEAs due to memory attribute mismatch, avoiding
   confusion with gmem memory fault exits (Sashiko)

Oliver Upton (5):
  KVM: arm64: nv: Respect read-only PFN when mapping L1 VNCR
  KVM: arm64: nv: Inject SEA if kvm_translate_vncr() can't resolve PFN
  KVM: arm64: nv: Re-translate VNCR before injecting abort
  KVM: arm64: nv: Inject SEA if guest VNCR isn't normal memory
  KVM: arm64: nv: Mark VM as bugged for unexpected VNCR abort

 arch/arm64/include/asm/kvm_nested.h |   8 ++
 arch/arm64/kvm/at.c                 |   8 --
 arch/arm64/kvm/nested.c             | 164 ++++++++++++++--------------
 3 files changed, 91 insertions(+), 89 deletions(-)


base-commit: fcda30b134d262a1b1826555352bd7349051486e
-- 
2.47.3

