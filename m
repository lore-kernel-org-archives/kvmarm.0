Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870F51E5208;
	Tue, 18 Feb 2025 19:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739905436; cv=none; b=Mh51ZnhthFcJTPuOEn/F7TW2o4Xlgd+u79n5CtKt05Inj/fP6X3JzbKNUx2p0snlGuicjmkh3buvkhN1IAL+BtyPlXBh7wpQQhjB6YLRefguSJGcgdcSH3bXcPfqnm5XQSOzlkMaFA2CANV3HVxsqmnCetQjTZdEVlJTrB+FJxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739905436; c=relaxed/simple;
	bh=7UIBAvOYhhHNC6NkKRtUodz1gJ9tFQycOOlXBe8KJdg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C5GxO8f3ShaYOE8dwYgFZmg2xQwskTp+0KHqmXIJPL9Ono7M6GggQC7uC0crPA0Bp26LjTs1ySiJqCRpaeATqvSBfPFVoOs1IBehe7giekOKSIumHdDEkSFXp718yrUkNwlJZh2cBVdwjxobYrjVDM8CEq0OUtRI81s3ZQbD634=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F437C4CEE2;
	Tue, 18 Feb 2025 19:03:51 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <robh@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Auger <eric.auger@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: (subset) [PATCH V2 0/7] arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
Date: Tue, 18 Feb 2025 19:03:49 +0000
Message-Id: <173990541533.375660.5963781767181928314.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250203050828.1049370-1-anshuman.khandual@arm.com>
References: <20250203050828.1049370-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 03 Feb 2025 10:38:21 +0530, Anshuman Khandual wrote:
> This series adds fine grained trap control in EL2 required for FEAT_PMUv3p9
> registers like PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1 which are already
> being used in the kernel. This is required to prevent their EL1 access trap
> into EL2.
> 
> PMZR_EL0 register trap control i.e HDFGWTR2_EL2.nPMZR_EL0 remains unchanged
> for now as it does not get accessed in the kernel, and there is no plan for
> its access from user space.
> 
> [...]

Applied to arm64 (for-next/el2-enable-feat-pmuv3p9), thanks!

[7/7] arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
      https://git.kernel.org/arm64/c/f134bbc054ae

-- 
Catalin

