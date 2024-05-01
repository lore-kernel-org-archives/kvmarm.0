Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92EF1384B1
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 17:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714585504; cv=none; b=GIFdQdiPmo1/dnW0u2EwyUkqAYhfVyIjtSjP56Hv7KBJHBN/72x59SzHYglQbNca04JyNNZkYLawh0rKJdy4JhDvU/c2ujnZgNoQ7rFhcNRfEExTHGlAkhbyMFPFCWqAuAc2NNXbbQ4h8hlX03nhsA4OEcGnoYZTMXozuQefG7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714585504; c=relaxed/simple;
	bh=Gwacnc1uhy0FvSDUqsiC2ye9bpGIvhcWCtJlhO4dgmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Do1M10VPTJxAJuH3jkrGrWFYgemem2JcOOgJbHxcUKNG2xamZkIsx/+2pOUT/rMp5NEvF5xrgHFa3dLTsHYOanygwTDYuGLDy3TU+o4kzjqDLECX3utHTrooOumEVMXzMrX1vg6O+ZYSajZdCtpX9FAC0VfFGpuOPjyYSneC+f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qn+c0F66; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qn+c0F66"
Date: Wed, 1 May 2024 17:44:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714585501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yAxXoSAOiKALcSFu1+/2BCFIL3wLdkpMncuKL1W3TJo=;
	b=qn+c0F665Sk77kK3B5mdxUqEtHqKl3MZeACqWVJ+gQf5n50w+/8GZ12SA2CNlT+flmMCNJ
	/HRFFsSToCB4gb8goHWJ3TdDYh1riID2ByVvcFFEWCWKR6OynSxxF2YPwgT4LpVBoCL67t
	rgGdNFGhfIOvh+uE1+c4FuR2qbNe2Mc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/2] KVM: arm64: Fix hvhe/nvhe early alias parsing
Message-ID: <ZjJ_mdsCa_fAy_NT@linux.dev>
References: <20240501163400.15838-1-will@kernel.org>
 <20240501163400.15838-2-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501163400.15838-2-will@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, May 01, 2024 at 05:33:59PM +0100, Will Deacon wrote:
> Booting a kernel with "arm64_sw.hvhe=1 kvm-arm.mode=nvhe" on the
> command-line results in KVM initialising using hVHE, whereas one might
> expect the latter option to override the former.
> 
> Fix this by adding "arm64_sw.hvhe=0" to the alias expansion for
> "kvm-arm.mode=nvhe".

Hmm, I wonder if it'd be better to just evaluate the sanitised VH field
in hvhe_possible(). Otherwise I worry about keeping aliases in sync when
new command line options come along.

This is similar to what we had before commit 35876f35f482 ("arm64:
cpufeature: Add helper to test for CPU feature overrides") w/ the added
use of the sanitised reg.

Thoughts?

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 56583677c1f2..3bd5f00a8db3 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2138,6 +2138,12 @@ static bool has_nested_virt_support(const struct arm64_cpu_capabilities *cap,
 static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
 			  int __unused)
 {
+	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+
+	/* No VHE? Then no hVHE for you either. */
+	if (!SYS_FIELD_GET(ID_AA64MMFR1_EL1, VH, val))
+		return false;
+
 	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
 }
 

-- 
Thanks,
Oliver
