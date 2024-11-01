Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C206C1AC884
	for <kvmarm@lists.linux.dev>; Fri,  1 Nov 2024 17:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730482590; cv=none; b=B5WV5RcW4bFLpedwrq3WetJagQQjPJ5SpQD93Eb5xp7mrZvS3bayPyRAVSK9sE69CKoZmSYdMZTT18q0jn5S8I0VzocmBPpBbOXt4/uy6IcrktzgBK6oTuI88GGosPj1DC4C+fSsGV9iLZ0/NemPHm0TUboERZA0NuW0gELTRgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730482590; c=relaxed/simple;
	bh=66mjropKSJfnevaC7+Nz/xs5ozQT0xQRz+OEml8Oi9M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aulirkhtbuo9VU1mbykjibNBfJ/gd1d/cwmrpry3QO29yePF/JxDuFxiTlDF+v/7Dp8ioZ/3czzbb1t1zpmtzdIK34pUSaC3gIGxxHjR2tdcxijKWzbVLULBhThKbIoK82VDRRvySgsk/ccprK319F3oSMiz4/8mLb2s/1ltnXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2850C4CECD;
	Fri,  1 Nov 2024 17:36:28 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] arm64: Expose ID_AA64ISAR1_EL1.XS to sanitised feature consumers
Date: Fri,  1 Nov 2024 17:36:26 +0000
Message-Id: <173048223698.1108539.8437113781961190311.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241031083519.364313-1-maz@kernel.org>
References: <20241031083519.364313-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 31 Oct 2024 08:35:19 +0000, Marc Zyngier wrote:
> Despite KVM now being able to deal with XS-tagged TLBIs, we still don't
> expose these feature bits to KVM.
> 
> Plumb in the feature in ID_AA64ISAR1_EL1.
> 
> 

Applied to arm64 (for-next/misc), thanks!

[1/1] arm64: Expose ID_AA64ISAR1_EL1.XS to sanitised feature consumers
      https://git.kernel.org/arm64/c/2287a4c1e118

-- 
Catalin

