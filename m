Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F233F9F4D;
	Mon, 18 May 2026 12:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779109186; cv=none; b=RuXsMixRyt7hSwDrj4wnH/HLJtOIedWFCVFj40qiPNU6KT4DaoRXcBo1vcERx/G+0FWyxE9pULxkJI8MhxBH9P69jkEPHxJyee5OkFB57GABEae3/tLRzsCqhfbNUPw0lh0rBnt4eHiX41SvJ//1YIkDusFOniMpmJOH26w5/ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779109186; c=relaxed/simple;
	bh=pHjLGDYdRaAdVxh0pgGrolDY1QWcj+3GpztGTtENOpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bi8Jg2lCUQHwNdFaph9dhxQxNjhUvBw1Z5JsYT27pnAm9/5OL2AayXcpOGyXdJBuoEwX4ntnN/a0YJ/mnG9g8H0D5m3QxD3fpZOET4Z/P/ql3PvEuzOUv349KzSuzG102cqVsKa164V4owvFIw+PSVorFBFl1LH033whD6pcupY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ss9om4+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ss9om4+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169D4C2BCB8;
	Mon, 18 May 2026 12:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779109185;
	bh=pHjLGDYdRaAdVxh0pgGrolDY1QWcj+3GpztGTtENOpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ss9om4+yiEIvQj1iIweQ35VPNZ04FVWz6PuG2qgvbTt2NKFKhRsZTbIdkHGmlESD7
	 xBVx7iYmGzjT1QP2/oTmO1bDll5g3wYwbLMG4Y0CxzKJU/A9RuJtIDOiY+k5GOt74n
	 hsn72PRULGT3K6T6bLfokcqMOleWr+HykmcJCvRvC02+LBQk9RdAc0lwVecTJu1rSn
	 J7FVterz5IBxae4A1t0dkvX7dCOLY1RlUQozSY/0OywfeFFq1xAxcTg+nYgW/lLKBB
	 7d3QtzxqrfzPFaObeDsb38Oa1JhpRUJVfDEd+PAdXrAPLIa/c7+oLyg3MrfmAxqw9/
	 1LnnXrAF0EAVQ==
Date: Mon, 18 May 2026 13:59:39 +0100
From: Will Deacon <will@kernel.org>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 00/14] coco/TSM: Host-side Arm CCA IDE setup via
 connect/disconnect callbacks
Message-ID: <agsNO9cc7H-b0H8L@willie-the-truck>
References: <20260427065121.916615-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427065121.916615-1-aneesh.kumar@kernel.org>

On Mon, Apr 27, 2026 at 12:21:07PM +0530, Aneesh Kumar K.V (Arm) wrote:
>  arch/arm64/include/asm/rmi_cmds.h         |  85 +++
>  arch/arm64/include/asm/rmi_smc.h          | 168 +++++

Curious, but why does this stuff have to live in the arch code? Wouldn't
it be better off somewhere like drivers/firmware/ or
include/linux/arm-rmi.h?

Will
