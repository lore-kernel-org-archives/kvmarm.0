Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151542868B
	for <kvmarm@lists.linux.dev>; Fri, 18 Apr 2025 21:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745010156; cv=none; b=HB73ygWmfC17pCKYLj8IpRNcuN5mzHC/osp/nTb+kOBTZfZ6LB1IGWWQRtSiUyN/RbJlCGLEgZYEZUZo9JYqioeTjSPcr31P/Xybpg6E8P6s2Nnt735WJx2I8bxGqUmDv/u+JFmyz7fPmhkLgiA00of4nfdcnLWJhWSbHzEJJKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745010156; c=relaxed/simple;
	bh=LBWkBaKQ7ZCDzItwIGLg/Ar8kkXWqEgSuHBi45M7dBU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UIPFl1z+AaD4NYxQHkxsFVKVIT5xjnb2NhOH8XOz5WzIzUBs8KzbKjI8acQPXPogIS7ULhQKFswdseGlovmQCOGtYgdneLVzP/nRXLfE8jPQOgmKGyuRV5mPonepdY+kvAYuBr90AMMkAc3NYvu1BUWfefWTe+4yYiwzGzdSJhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wLgtC0hd; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wLgtC0hd"
Date: Fri, 18 Apr 2025 14:01:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745010149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=w+85ylRyrUIGs6mLVwkG3LiYjOpMIfTz1LLrItLJJQ4=;
	b=wLgtC0hdw+vr786vQJOTO2QbvqEjxlCcTXLXZXEEVYgusptAWMJsmBUGSYHabyb9c2qlLp
	aQaz1VRZbprquWTWiMACL0UZ++sQCsflEv7R7lmRUFVySNVccL+HJhK6mLD4hQZbU2q2Mk
	u0E5kXiXNPy3fVd1gDjSW+OUHl3SVFk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>
Subject: [GIT PULL] KVM/arm64 fixes for 6.15, round #2
Message-ID: <aAK9xg9DMfCsCPux@linux.dev>
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

Here's a single rather urgent fix for 6.15 that addresses boot failures
from the PV MIDR infrastructure. Catalin has reviewed the patch and
asked I grab it since it's the end of the working week for him.

Please pull.

Thanks,
Oliver

The following changes since commit a344e258acb0a7f0e7ed10a795c52d1baf705164:

  KVM: arm64: Use acquire/release to communicate FF-A version negotiation (2025-04-07 15:03:34 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags/kvmarm-fixes-6.15-2

for you to fetch changes up to 117c3b21d3c79af56750f18a54f2c468f30c8a45:

  arm64: Rework checks for broken Cavium HW in the PI code (2025-04-18 13:51:07 -0700)

----------------------------------------------------------------
KVM/arm64 fixes for 6.15, round #2

 - Single fix for broken usage of 'multi-MIDR' infrastructure in PI
   code, adding an open-coded erratum check for everyone's favorite pile
   of sand: Cavium ThunderX

----------------------------------------------------------------
Marc Zyngier (1):
      arm64: Rework checks for broken Cavium HW in the PI code

 arch/arm64/include/asm/mmu.h      | 11 -----------
 arch/arm64/kernel/cpu_errata.c    |  2 +-
 arch/arm64/kernel/image-vars.h    |  4 ----
 arch/arm64/kernel/pi/map_kernel.c | 25 ++++++++++++++++++++++++-
 4 files changed, 25 insertions(+), 17 deletions(-)
