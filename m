Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33CA148AE1F
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 16:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787157703; cv=none; b=Rmpq+lQ1rrVMiYoO5cdKewRVAaqzbycVY6Y+FVJfcufksSd9wmFIF1IudBgfqseYMtApNYmWblQZSRtkXQY7e50qg/uUF4O1AOfEHXOAFyujkVNqWqPQygT+U9gip3B+Xn9HQD//3vcqgbmd2X5mndbRgheahqmwrdpA+F18HQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787157703; c=relaxed/simple;
	bh=25ho0NYij3g9I6d9bI+yv5urlO1j/m2cx5ybWXXuSV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=d7VKziZcIdJxfH38x+BqldydLbBsydSSXwvNTPmPaEMvvmkEcdZqPY1xq1aipVSFyOgLK7qaP36za5mHF4S0kFBwdhqANdyXAodWsBcI8SssOQ/IyRJ4LT/EXJ33OhFQK5Lazvy5ZMixdGpYe3lYFlx5djRcLq/xbrOQlaNNdgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=j+2MTGPb; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="j+2MTGPb"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4E3414BF;
	Wed, 19 Aug 2026 09:41:36 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 55E1C3F85F;
	Wed, 19 Aug 2026 09:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787157700; bh=25ho0NYij3g9I6d9bI+yv5urlO1j/m2cx5ybWXXuSV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+2MTGPbLA+b1cph9was2HgVwZ8WElXY7cms8edRNl9rxdj0ltIXLA3WHSA4/w3Ds
	 jXiMSUSdjYCgwGzjL1IXfz/69PJZVGcbZEXJ/3TikpNJ6HN5ge6WR5DylTTqhVw9aN
	 4o2cVN4w6k58AVK92Gzm8O2ENY3GKcCs5q+aXWZg=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 01/14] arm64/gcs: Ensure FGTs for EL1 GCS instructions are disabled
Date: Wed, 19 Aug 2026 17:41:35 +0100
Message-ID: <aoXcv8kx7x3GolaW@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <a6fe8050-18f1-4013-8d6f-38ecc754c7e7@sirena.org.uk>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org> <20260812-arm64-gcs-v19-1-9105afd828ac@kernel.org> <aoWyeTx8lYGfiwYc@LeoBrasDK> <a6fe8050-18f1-4013-8d6f-38ecc754c7e7@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Aug 19, 2026 at 03:21:31PM +0100, Mark Brown wrote:
> On Wed, Aug 19, 2026 at 02:41:13PM +0100, Leonardo Bras wrote:
> > On Wed, Aug 12, 2026 at 08:12:00PM +0100, Mark Brown wrote:
> 
> > > +	/* Disable traps of GCS instructions at EL1 */
> > > +	orr	x2, x2, #HFGITR_EL2_nGCSEPP_MASK
> > > +	orr	x2, x2, #HFGITR_EL2_nGCSSTR_EL1_MASK
> > > +	orr	x2, x2, #HFGITR_EL2_nGCSPUSHM_EL1_MASK
> 
> > Which I understand to be the way of us saying that EL2 will not interfere 
> > on nor manage those instructions that let software change the entries of 
> > GCS. Is that correct?
> 
> Yes, the goal is to allow EL1 to manage things how it wants (there are
> controls for store and push in GCSCR_EL1 too).
> 
> > As for the asm routine, x2 at this point have nBRBIALL and nBRBINJ already 
> > set, and will be loaded to SYS_HFGITR_EL2 in the next block of 
> > instructions.
> 
> > Did I get it right? Is there any missing detail here?
> 
> That's the idea.


Awesome! FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

