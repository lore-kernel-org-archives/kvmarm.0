Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224162367D4;
	Wed, 21 May 2025 11:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747825399; cv=none; b=lSdtEWHKSBbN1fo+9JpylthRhTLUhXVjOJ0nhzQuQfPPTSziSbPma1HIo1uvXZbTuAObRlqOezE5LP15Y3gLRiuE+Uz8Gm9CDMshvCGMuQ94UrK2xgCnAdoQncdXHroK2C7V/xtd8AWuacWPTumy/j55iZWyyCzwu99ZNGENEzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747825399; c=relaxed/simple;
	bh=QAUAYNKmlM0RlaNjGicH9GqKIAhlrFtqHhssH2BVJ88=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RrC+NppFHUwhe36PVgJOGukn5n4GmCIaywa/Wh1IIF4jiZVAvmNFlqWrRWTVZzxqJM7unknryq7L3crPthz5te829hI14phofOEG4FG1OOAZnszL98xs0SBjqOrV4f+N72UgLUXsLwBl7tWZJzvizMUqlRL0BWdbC49xWEkeaUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VtShJ3KJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VtShJ3KJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0738DC4CEEA;
	Wed, 21 May 2025 11:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747825398;
	bh=QAUAYNKmlM0RlaNjGicH9GqKIAhlrFtqHhssH2BVJ88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtShJ3KJfMOydCfX5LajLrW/grN0PgqMTvj8HUyAMTJ5FEC1IsFZMNmbHkxRz87Xz
	 UkbWY81F+ziNXmhvlfU2JLD4NvHSCGjDlybRT19p8UrwW8Vp2AUaLTBRl5HY4FPEhF
	 L0ceKaiyVl6ctqBuDIzw9rSu7lzWfTWsV+KFVhJd2VhtLoxMRuSdqUXMbaUFMlYUY6
	 fGlMt/nulJ2DFsJ+T3D5JJwWcjlqWF7qjCGOk+W3Jc+HVrSyPIVzDEkc8ZlOPlP+pX
	 sYB71O1EVTh1ixylTXJDmFRLmL3fcachHtO1Vu8T/T7obmGPUSweDn6Tz+Cd1fzFlR
	 EGKRY/rOOkROw==
From: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v22 0/5] arm64/perf: Enable branch stack sampling
Date: Wed, 21 May 2025 12:01:18 +0100
Message-Id: <174782307035.3423409.3825975640964405604.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20250520-arm-brbe-v19-v22-0-c1ddde38e7f8@kernel.org>
References: <20250520-arm-brbe-v19-v22-0-c1ddde38e7f8@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 20 May 2025 17:27:35 -0500, Rob Herring (Arm) wrote:
> This series enables perf branch stack sampling support on arm64 via a
> v9.2 arch feature called Branch Record Buffer Extension (BRBE). Details
> on BRBE can be found in the Arm ARM[1] chapter D18.
> 
> I've picked up this series from Anshuman. v19 and later versions have
> been reworked quite a bit by Mark and myself. The bulk of those changes
> are in patch 5.
> 
> [...]

Applied the '__init_el2_fgt' label cleanup to arm64 (for-next/entry), thanks!

[2/5] arm64: el2_setup.h: Make __init_el2_fgt labels consistent, again
      https://git.kernel.org/arm64/c/54b8070548c6

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
