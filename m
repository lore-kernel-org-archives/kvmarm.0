Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C2141B6D00
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 15:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732806783; cv=none; b=aZSt7i+qalK5mfX7gMjy4bAm/ThVqdD+qz70wDA1q8U1ULJyfncB99vZSMpSXh+kM+epTwk1czFF/f/NlfNc3twuXnDvHylU+cFM1JuS70hQt6H/UqewWBrhNHKZ66/4TxXkNcXL89qZ4aU0EMJBpWkaopxBUzMyItxxOgwXBpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732806783; c=relaxed/simple;
	bh=dbMuuKJJU1bCqHlaL0UVjvAN7kojyjUkT2IObE8rFq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmnG/GPMevxdw8A634KvKETdYkakQzrYVCCi76LmA+BQHezzH3ssl9AzpTRCTidXeQlGA71QW9AUHsOHsVx0X/mMhD6+RbSe+YFSK2hX+OJzb47NiIhVTMNJL0svqpla2/WzgeuptFbzD2KJFSeBN2q6Qwx7fZjLEp7Nx1k942o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A32211476;
	Thu, 28 Nov 2024 07:13:31 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 001953F66E;
	Thu, 28 Nov 2024 07:12:59 -0800 (PST)
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
Subject: [PATCH kvmtool 1/4] arm: Fix off-by-one errors when computing payload memory layout
Date: Thu, 28 Nov 2024 15:12:43 +0000
Message-ID: <20241128151246.10858-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241128151246.10858-1-alexandru.elisei@arm.com>
References: <20241128151246.10858-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In kvm__arch_load_kernel_image(), 'limit' is computed to be the topmost
byte address where the payload can reside.

In all the read_file() calls, the maximum size of the file being read is
computed as limit - pos, which is incorrect: either limit is inclusive, and
it should be limit - pos + 1, or the maximum size is correct and limit is
incorrectly computed as inclusive.

After reserving space for the DTB, 'limit' is updated to point at the first
byte of the DTB. Which is in contradiction with the way it is initially
calculated, because in theory this makes it possible for the initrd (which
is copied below the DTB) to overwrite the first byte of the DTB. That's
only avoided by accident, and not by design, because, as explained above,
the size of the initrd is smaller by 1 byte (read_file() has the size
parameter limit - pos, instead of limit - pos + 1).

Let's get rid of this confusion and compute 'limit' as exclusive from the
start.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index 9f9582326401..da0430c40c36 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -109,7 +109,7 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	 * Linux requires the initrd and dtb to be mapped inside lowmem,
 	 * so we can't just place them at the top of memory.
 	 */
-	limit = kvm->ram_start + min(kvm->ram_size, (u64)SZ_256M) - 1;
+	limit = kvm->ram_start + min(kvm->ram_size, (u64)SZ_256M);
 
 	pos = kvm->ram_start + kvm__arch_get_kern_offset(kvm, fd_kernel);
 	kvm->arch.kern_guest_start = host_to_guest_flat(kvm, pos);
@@ -139,7 +139,7 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	kvm->arch.dtb_guest_start = guest_addr;
 	pr_debug("Placing fdt at 0x%llx - 0x%llx",
 		 kvm->arch.dtb_guest_start,
-		 host_to_guest_flat(kvm, limit));
+		 host_to_guest_flat(kvm, limit - 1));
 	limit = pos;
 
 	/* ... and finally the initrd, if we have one. */
-- 
2.47.0

