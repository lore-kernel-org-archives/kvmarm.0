Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D768A1AEFFF;
	Thu,  4 Jul 2024 16:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720110155; cv=none; b=dq2BzD4xCjC88hRscghqY2b9Xyxcp1QyUl74W2Rt7CyyTLKLJDo8nVRJFG/WksFXnpO6n1lG6iSP3L5+8Z/zFli6RO2m4Rc/+EU7tsA56vyok6sIICWg77/GnjgHmIv5kAsxJ71pPoVntE2KC+b6cT7imVrbKUQIaSOrini9y1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720110155; c=relaxed/simple;
	bh=yLzcPY0Tkd1yy63iM9n94MQZwVpxYr9G4i9fXW/G+Mw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CZcBu8qDOlx4+1zlYkGW7L+P5w4PL60WHxbA4tWmoa3qcVs2k+lLmrvmmKjhtHMvZO0Xvflwje6lNm+92Kr53+o6bcw34H7KrpSe/461m3VfxiSpPndMTkMtT0Mh18NoiXh+YrxdaOD+0F+KgjqrTUFW1HNmXPrYayCcnis2J3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97677C3277B;
	Thu,  4 Jul 2024 16:22:33 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Will Deacon <will@kernel.org>,
	mark.rutland@arm.com,
	ryan.roberts@arm.com,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/2] arm64: Drop ID_AA64PFR0_EL1_ELx_[64BIT_ONLY|32BIT_64BIT]
Date: Thu,  4 Jul 2024 17:22:31 +0100
Message-Id: <172011014332.983778.3066072666781359420.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240613102710.3295108-1-anshuman.khandual@arm.com>
References: <20240613102710.3295108-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 13 Jun 2024 15:57:08 +0530, Anshuman Khandual wrote:
> This series replaces custom macros usage for ID_AA64PFR0_EL1_ELx_64BIT_ONLY
> and ID_AA64PFR0_EL1_ELx_32BIT_64BIT fields, thus finally just dropping them
> off completely. This series applies on v6.10-rc3
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.linux.dev
> Cc: linux-kernel@vger.kernel.org
> 
> [...]

Applied to arm64 (for-next/cpufeature), thanks!

[1/2] KVM: arm64: Replace custom macros with fields from ID_AA64PFR0_EL1
      https://git.kernel.org/arm64/c/42b9fed388a5
[2/2] arm64/cpufeature: Replace custom macros with fields from ID_AA64PFR0_EL1
      https://git.kernel.org/arm64/c/056600ff7330

-- 
Catalin

