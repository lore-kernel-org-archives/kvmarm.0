Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC4048822A;
	Wed,  7 Oct 2026 10:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791367471; cv=none; b=FuTy55W6HJC4SyQiVEeaI4H8DG2ktL7MSZ1dlrXiSMV69KoQRvYYPic7GYyKF66Jsy4IUGTAEX7QE53fa5oCe9NGQnKKsPmuvMxKtlJ7/OBLJwmOJx7L4sSXJ9KztaqnxyTt0xUqdgTcisEJhyDEiZCUZxgzkSBFSEekqw2TWjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791367471; c=relaxed/simple;
	bh=sEIZxq/zxpwKKzSYDQ6XzSaK+HAsstIRb1uGP+YKEtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KNg9s5T+3rT1P7echUkXQVOL25DzgOEdox8qX4ksZwcao8H81s9uoR04wsPwAh3xlgBcRfOdoIPk/iz8CyjaVKTVndAJhs+kVcaZi3Zz6wLMje69V5PQtJDxWTJAFnuizY4J39VBiaYePfR43eHTTklEfatKTKUnMHskT8Gwl8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e1QmOhj/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e1QmOhj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00A11F0089B;
	Wed,  7 Oct 2026 10:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791367461;
	bh=OkV7aWutgjFpbY2mI5Akvl/9Cn2GxgJ/KIs/Ot1aoZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e1QmOhj/T/jVqQOyBRwu5c6J7dAbbLrI4gMImRCkaGw/DZaPMBfqK8qoww/kbqKuR
	 iaqYfJJuECPvknLllTY2Jgw1iCsCGMkSeMvLk0jfa4xOTvQNZSD1Q33WleAt1J+Cux
	 KKuivvuUU6CnxYvwDAZrYGqddAneVKlHjN4klWQNtFSEO2ybCZ3f0U1BV6+jOW7ABf
	 PYLgJAsXRNJfHoOep3aIgzg82583sBfYgmvjoy6l8Yt8NpvJk7JLDh8YYm2u14YLgq
	 kDLEo2sRL35t7pOktGGIQx8deqEqMoRM7KCfOehlpPikv2LuORUT2XfocDqxZlXHBA
	 8MCjc6r3SNsrg==
Date: Wed, 7 Oct 2026 01:41:43 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3] KVM: arm64: Only emulate an SError's entry for vCPUs
 with NV
Message-ID: <asYFx8g_P9H_bjb7@kernel.org>
References: <20261007080833.371899-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007080833.371899-1-fuad.tabba@linux.dev>

On Wed, Oct 07, 2026 at 09:08:33AM +0100, Fuad Tabba wrote:
> kvm_inject_serror_esr() emulates an SError's exception entry when the
> host's copy of PSTATE says SErrors are unmasked, although only NV needs
> this, for a nested context whose guest hypervisor owns the vSError. A
> protected vCPU's PSTATE lives at EL2, and the VMM can unmask SErrors in
> the host's copy before the first run, so KVM emulates the entry on that
> copy and the guest never takes the SError.
> 
> Emulate the entry only for a vCPU with NV, which protected VMs don't
> support, and otherwise pend the SError through HCR_EL2.VSE, as KVM did
> before commit ce66109cec867 ("KVM: arm64: nv: Take "masked" aborts to
> EL2 when HCRX_EL2.TMEA is set").
> 
> Fixes: 872383bd12e11 ("KVM: arm64: Add per-EC entry/exit state marshalling for protected guests")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/all/20261001142109.794CA1F000FF@smtp.kernel.org/
> Suggested-by: Oliver Upton <oupton@kernel.org>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver
