Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74125209F32;
	Fri, 10 Jan 2025 11:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736506844; cv=none; b=CYHb8iCPHDf4DtkZjxixVggYL/D4AK1JVmw5JbWCeTcTSf75eKu7tEorZRxX9eWDF7Hg7gmK2NgcEJt2qQB19Bb2Nvow+b/SJrSDK88p/ZOXC/4QrJs3SJq5W+prNCuRonHwhOLql3ImL+EZtloT6zMOE4Z0b+TbMGCPaSsD07A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736506844; c=relaxed/simple;
	bh=vVgMyrLW1OMFgKTrIDDDXD458WHn0AVjGex0Tfq7F2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hnyd5arvTAv1l65SyqII58R6YL4MzcowIYQQMskg8OH4EOJWEGEAmetB04dQSnIRci+UJdlSFV5OKuHOO9DtfhnVHFT5c0+kklT0+8MYwETOzQRj5dpZxeLsfTvrdcen7drLz28lqwU1sGSZgolZKAeCNiZblotHSBtonUvOX8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mMeyRf4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mMeyRf4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBABC4CEE0;
	Fri, 10 Jan 2025 11:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736506843;
	bh=vVgMyrLW1OMFgKTrIDDDXD458WHn0AVjGex0Tfq7F2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMeyRf4KG/aKnNkh+oX9xfvNoII4/xPf/OICujDFWt1vJ2Y41oEGhKboNzyYbrBNB
	 MOkvxOuf4w8/quEjBV0VKaXaLLb1wZD7zvLVj9dx4Icmx8WVEFOuMDugN6Ull/fsE3
	 C2vQJqi85AnDHH2sBi6H/91/ofsuT9n0z61FkZxmVyPoiSTIqJhg0RgWkllPW0/LN3
	 l3SMHzOqOXSzYEUShgsgr7E6g0jzaXpV9cVMiHZqDbhNJN2wBVkngOJaMcJA9CguTu
	 zAU5N59Q/V9vMAmWr5UZ/9aoKXCxIY4pkehnRN75crZm3+bbZYR9KJz7JyVYFQrmeO
	 CdtaYRWKBnaDw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [PATCH v2 2/7] KVM: arm64: MTE: Update code comments
Date: Fri, 10 Jan 2025 16:30:18 +0530
Message-ID: <20250110110023.2963795-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
References: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit d77e59a8fccd ("arm64: mte: Lock a page for MTE tag
initialisation") updated the locking such the kernel now allows
VM_SHARED mapping with MTE. Update the code comment to reflect this.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/kvm/mmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c9d46ad57e52..eb8220a409e1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1391,11 +1391,11 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
  * able to see the page's tags and therefore they must be initialised first. If
  * PG_mte_tagged is set, tags have already been initialised.
  *
- * The race in the test/set of the PG_mte_tagged flag is handled by:
- * - preventing VM_SHARED mappings in a memslot with MTE preventing two VMs
- *   racing to santise the same page
- * - mmap_lock protects between a VM faulting a page in and the VMM performing
- *   an mprotect() to add VM_MTE
+ * The race in the test/set of the PG_mte_tagged flag is handled by using
+ * PG_mte_lock and PG_mte_tagged together. if PG_mte_lock is found unset, we can
+ * go ahead and clear the page tags. if PG_mte_lock is found set, then the page
+ * tags are already cleared or there is a parallel tag clearing is going on. We
+ * wait for the parallel tag clear to finish by waiting on PG_mte_tagged bit.
  */
 static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 			      unsigned long size)
-- 
2.43.0

