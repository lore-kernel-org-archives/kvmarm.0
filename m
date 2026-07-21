Received: from devianza.investici.org (devianza.investici.org [198.167.222.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A96B2E7F25
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 10:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.167.222.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784631047; cv=none; b=bBtfWh3lVODnWKQ4qYWC51rA5A7SfGevWtXT9YuUs0z4JDWrU5XHRQx+q657sdA55HC3Yzh2K0udhkyplqwZ8Ivf3gXXywfiEjOPctxmpG1ig2kOIEU4pstbhNJ9kBSdAAOG09lrYMeXwaisNrhicGF/bJmwIgbufPE13TAucCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784631047; c=relaxed/simple;
	bh=1weqDUXvSEwaPwCSGL/jlYmibzgQuWhROHW2zX7Px/M=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=rSu9fixb6WZI78kP412BPpQDnu3C9E3xS51Gf7aJV1hwLtj4NPp+zx4j9ZMpRPfvhdMtRe55qtIUDOm7RPzhl7vJdrD673s1TdQ+Uwk79YJGnhdvpUia2Evv3KXDwazCOQaY9RChh3s5HmwmMOq9ZzHOg9/+ZiZhabpgfl+WFKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=N59Po1k+; arc=none smtp.client-ip=198.167.222.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="N59Po1k+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1784631033;
	bh=tSeeoZJp2knuheF3VC8Cg0vSsJ06Oi4KKbvrXmMmHGA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=N59Po1k+rbpJAYub9rNYigwnjcVbFXA+fYg+xnw0gUwbD+VI8mImpa494f42lMBHR
	 v1U82ZfSVnzcqitul7kMsQ1HbxoX77oYc0/JIo65IQ0vuJ0vt38i7Qe9KCmdCCOsaW
	 mCqWvCBEOlQ8+iVDZ7G80jKwMTOZHUt6kDVCdYgg=
Received: from mx2.investici.org (unknown [127.0.0.1])
	by devianza.investici.org (Postfix) with ESMTP id 4h4DgY4WZRz6vPL;
	Tue, 21 Jul 2026 10:50:33 +0000 (UTC)
Received: by mx2.investici.org (Postfix) id 4h4DgY1HwPz4vyJ;
	Tue, 21 Jul 2026 10:50:33 +0000 (UTC)
Date: Tue, 21 Jul 2026 11:50:33 +0100
From: Bradley Morgan <include@grrlz.net>
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>
CC: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Shuah Khan <shuah@kernel.org>, Quentin Perret <qperret@google.com>,
 Vincent Donnefort <vdonnefort@google.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, Gavin Shan <gshan@redhat.com>,
 Dev Jain <dev.jain@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v5_4/7=5D_KVM=3A_arm64=3A_Skip_p?=
 =?US-ASCII?Q?KVM_stage-2_flush_when_FWB_is_enabled?=
In-Reply-To: <20260717130317.1953574-5-fuad.tabba@linux.dev>
References: <20260717130317.1953574-1-fuad.tabba@linux.dev> <20260717130317.1953574-5-fuad.tabba@linux.dev>
Message-ID: <2ECE2480-4E56-4EE8-AE1F-36571463A930@grrlz.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On July 17, 2026 2:03:14 PM GMT+01:00, Fuad Tabba <fuad.tabba@linux.dev>
wrote:
>pkvm_pgtable_stage2_flush() cleans the D-cache for every mapping in the
>range even on hardware with stage-2 Force Write-Back, where FWB keeps
>guest memory coherent to the PoC and the maintenance is unnecessary. The
>generic kvm_pgtable_stage2_flush() returns early in that case, but the
>pKVM MMU does not, so it needlessly cleans the whole range on, e.g.,
>every set/way trap.
>
>Return early when FWB is enabled, matching the generic walker.
>
>Fixes: e912efed485a ("KVM: arm64: Introduce the EL1 pKVM MMU")
>Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

LGTM,

Reviewed-by: Bradley Morgan <include@grrlz.net>

>---
> arch/arm64/kvm/pkvm.c | 4 ++++
> 1 file changed, 4 insertions(+)
>
>diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
>index f70c601dcf4c..ba6570e37545 100644
>--- a/arch/arm64/kvm/pkvm.c
>+++ b/arch/arm64/kvm/pkvm.c
>@@ -518,6 +518,10 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
> 	struct pkvm_mapping *mapping;
> 
> 	lockdep_assert_held(&kvm->mmu_lock);
>+
>+	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
>+		return 0;
>+
> 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> 		if (!mapping->nc)
> 			__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn),
>

Thanks!
