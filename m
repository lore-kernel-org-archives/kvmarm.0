Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8A619D06A
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 15:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732806782; cv=none; b=XKN0i1ZsBwyHChPGhhy6tKI0sSvyzdoYP5yMV6ZPXPiKbRd5f6i9A2zNDkolpcVA/zs11g48EI/0ef5Nt0b+n9nqx14+N9qzRAex8uNAQiapZP/8kwKzE7fNTyEuUOegf1cR/QsOgaNBlC6qixWLOSqFXqOj57GTEbvIIee6Hyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732806782; c=relaxed/simple;
	bh=hc1ZnRwxrRsJoEPhnB++7jxfqcU/o5PGaexYpFYa0FI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SyuV+qHgsjCzBCWc3xCajzOCND8xsc6e+AHkRbJ11gi4jaaamFaAZTAXiQedUPZ3J+64VVM/97QA9P1TgH/afVBwGcWa/X9M7S0goCSHW3+ypdVlGU76/SGmNKelOUQAN6sCIa+iHe+GJxR726hPaN5au4yIZi8N5M4ygotr9k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 756E51474;
	Thu, 28 Nov 2024 07:13:29 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5F9E3F66E;
	Thu, 28 Nov 2024 07:12:57 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	apatel@ventanamicro.com,
	andre.przywara@arm.com,
	suzuki.poulose@arm.com,
	s.abdollahi22@imperial.ac.uk
Subject: [PATCH RESEND kvmtool 0/4] arm: Payload memory layout change
Date: Thu, 28 Nov 2024 15:12:42 +0000
Message-ID: <20241128151246.10858-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

(resending because I accidently only sent the cover letter, sorry for that)

The first 3 patches are fixes to kvm__arch_load_kernel_image(). I've CC'ed
the riscv maintainer because it looks to me like riscv is similarly
affected.

Patch #4 ("arm64: Increase the payload memory region size to 512MB") might
be controversial. Follows a bug report I received from Abdollahi Sina in
private. Details in the commit message, but the gist of the patch is that
the memory region where kernel + initrd + DTB are copied to are changed
from 256MB to 512MB.  As a result, the DTB and initrd are moved from below
ram_start + 256MB to ram_start + 512MB to accomodate a larger initrd.  If
users rely on finding the DTB and initrd at the current addresses, then I'm
not sure the patch is justified - after all, if someone really wants to use
such a large initrd instead of a disk image with virtio, then replacing
SZ_256M with SZ_512M locally doesn't look like a big ask.

On the other hand, if there are no users that rely on the current payload
layout, increasing the memory region size to 512MB to allow for more
unusual use cases, while still maintaining compatibility with older
kernels, doesn't seem unreasonable to me.

Please comment, I don't feel strongly either way - I'll happy drop the last
patch if there are objections.

Alexandru Elisei (4):
  arm: Fix off-by-one errors when computing payload memory layout
  arm: Check return value for host_to_guest_flat()
  arm64: Use the kernel header image_size when loading into memory
  arm64: Increase the payload memory region size to 512MB

 arm/aarch32/include/kvm/kvm-arch.h |  5 +-
 arm/aarch64/include/kvm/kvm-arch.h |  7 ++-
 arm/aarch64/kvm.c                  | 88 +++++++++++++++++++++++-------
 arm/kvm.c                          | 35 +++++++++---
 4 files changed, 105 insertions(+), 30 deletions(-)

-- 
2.47.0

