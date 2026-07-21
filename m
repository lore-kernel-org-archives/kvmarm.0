Received: from devianza.investici.org (devianza.investici.org [198.167.222.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DB8347512
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 10:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.167.222.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784631061; cv=none; b=W9rBdhxNSAK94mOpAguUdnujf13aSbgatTJ53RLcgTHCkCAO1edaqBEKP0gmbW1OE6Ilw7Nv517Ndb+P2JSmhCv4k1zCTj9ym2sad7J80+Gux3QzNe012m767ELCe6YNMR4pRfFma7JchC8CY/5ctewVVsBMENrHRDUfMnVG4XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784631061; c=relaxed/simple;
	bh=B83Y+w6g2pqsR8A/sJkug7QfPTwRvUjRY36y4JIueFo=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=EXPid27I16OndSwkMFhO4HsLsIbCq14alrLpLldzA/27ZjMoVadj65Nvl9w/3aTBURIvfHWnBhT0D1vBMicVN7ivyZip6Uq9CNoG4NLJ0mJkWg7v0n6omx1LtijyjWkPhlf1xTkHNBWlm6AdOb/o4rb1GML42qc9X2wBSGXgxxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=aJSp6ln/; arc=none smtp.client-ip=198.167.222.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="aJSp6ln/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1784631057;
	bh=B6KOq1zcA4RF8hkL1GnU5zB0hZi9lIcTa8eiKo4zmqE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=aJSp6ln/FCfPnydN3Nlf7bQw3fcOxS1+C8/tz6nRA7Vf4vT+PXUY2SOflZOJwHnVW
	 76T//tWS6M8QGlE7/IqgbgF4OD06PUnF40jPWSJTyC6StnUBT+uDQVYYLMZHdaiL0E
	 gdL3eQ+SC+AHAVeoswrKQykLpEZn5e3IIX5RjKKk=
Received: from mx2.investici.org (unknown [127.0.0.1])
	by devianza.investici.org (Postfix) with ESMTP id 4h4Dh10GPMz6vV9;
	Tue, 21 Jul 2026 10:50:57 +0000 (UTC)
Received: by mx2.investici.org (Postfix) id 4h4Dh04Yhnz4vyJ;
	Tue, 21 Jul 2026 10:50:56 +0000 (UTC)
Date: Tue, 21 Jul 2026 11:50:57 +0100
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
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v5_5/7=5D_KVM=3A_arm64=3A_Don=27?=
 =?US-ASCII?Q?t_WARN_on_pKVM_stage-2_map_failures?=
In-Reply-To: <20260717130317.1953574-6-fuad.tabba@linux.dev>
References: <20260717130317.1953574-1-fuad.tabba@linux.dev> <20260717130317.1953574-6-fuad.tabba@linux.dev>
Message-ID: <255752B7-E5B2-47D3-A050-C319CA425EF1@grrlz.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On July 17, 2026 2:03:15 PM GMT+01:00, Fuad Tabba <fuad.tabba@linux.dev>
wrote:
>pkvm_pgtable_stage2_map() wraps the __pkvm_host_share_guest() and
>__pkvm_host_donate_guest() return in WARN_ON(), but those hypercalls
>fail for reasons that are not EL1 invariant violations: -EINVAL for a
>pfn that is not memblock RAM (check_range_allowed_memory() rejects a
>device page mapped into a non-protected guest) and -ENOMEM under
>memcache pressure. Both are reachable from a guest fault, so the WARN
>splats on host input.
>
>Return the error without warning. The unshare and write-protect WARNs
>stay, since a failure there does signal a broken EL1 invariant.
>
>Fixes: 3669ddd8fa8b5 ("KVM: arm64: Add a range to pkvm_mappings")
>Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

LGTM,

Reviewed-by: Bradley Morgan <include@grrlz.net>


>---
> arch/arm64/kvm/pkvm.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
>index ba6570e37545..1212a2c5613d 100644
>--- a/arch/arm64/kvm/pkvm.c
>+++ b/arch/arm64/kvm/pkvm.c
>@@ -466,7 +466,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> 					size / PAGE_SIZE, prot);
> 	}
> 
>-	if (WARN_ON(ret))
>+	if (ret)
> 		return ret;
> 
> 	swap(mapping, cache->mapping);
>

Thanks!
