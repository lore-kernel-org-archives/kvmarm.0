Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6125B5293F5
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792070547; cv=none; b=qggFGXb6u1aO/KxMktScWND3pPieejYgQWe7fyHpD+DkMphYbw9Td1lf1AJxZni75JjAPCmy/5Rfd4TxVqNW2Ro+fzEgNrIoGbu4XswLTe80bfyWtLaa75fN87mtTJydvgTZFue3FuqiLyHePNhij+tYMygWRn2/f4fCx+2Q1DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792070547; c=relaxed/simple;
	bh=ijgdmJJoARJJ0ZUPqeRSJrO1Ou8HLC5tqytld0XM8dw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Egp0cIU2IW4te+ZCSU4O3JQNFdclwifYAYXvVu6VpTA1DYtl8p8lhSWD+KE6inoJWE/LcN44nMvX5qkP+R6XkPC/Q8PdljfnDE73CfsUnW/FBmTeIelD4d5jxb1elVry82Yq+0SCg/iR4QKBKc+zdBxDUSrSRk4W/sDZGSvXzlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XJyjcEIK; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XJyjcEIK"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 876F414BF;
	Thu, 15 Oct 2026 06:22:21 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 944113F673;
	Thu, 15 Oct 2026 06:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792070544; bh=ijgdmJJoARJJ0ZUPqeRSJrO1Ou8HLC5tqytld0XM8dw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XJyjcEIKsgTcGTvcksw6c/N35HND1bFPDo9bzxz/919el9l/sCIrLRKKweEoWTXqb
	 sw9G/XqAdf4XUWz3xIREfw5uSA5JLsgjs+JprwcFjzCVBNAzSC+d1v8SHdkgdbgds6
	 sWZVXSZpp+dmoU1Zfkw+47in3YY/JFGvIkfltik0=
Date: Thu, 15 Oct 2026 14:22:19 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, will@kernel.org, mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org, catalin.marinas@arm.com,
	james.clark@linaro.org
Subject: Re: [RFC PATCH v7 00/28] KVM: arm64: Add Statistical Profiling
 Extension (SPE) support
Message-ID: <atDTi0bNMvzIW4Nr@raptor>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <atCqFRdGzFq5dOdT@raptor>
 <atDLgcMeh7kizHGt@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atDLgcMeh7kizHGt@gremlin>

Hi Lorenzo,

On Thu, Oct 15, 2026 at 01:50:09PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Oct 15, 2026 at 11:25:25AM +0100, Alexandru Elisei wrote:
> > Hi Oliver, Marc,
> >
> > Gentle ping regarding this series. Is there something you want me to do to make
> > reviewing easier? Do you want me to rebase it on top of v7.4-rc1 when it comes
> > out? Something else?
> >
> > Thanks,
> > Alex
> 
> Just to say that I'm planning to go through this series myself and can hopefully
> help with the review workload here! :)

Sounds great, thanks!

Alex
