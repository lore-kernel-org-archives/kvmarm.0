Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D629837FF60;
	Mon,  9 Feb 2026 16:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770654364; cv=none; b=Qa5pWKGuP6g415zK8W5hFE1fxsg0SP5X/3LsL1PSc1WJzk7BA3c42OV5atJTE01Tvrq0Y+3ahq3RJj0MC/VjGP6oJkL/o8oJ8NFv2nzrSukNG9TU3E4N9oX6RDSafYGr5++T4n9QowTRKLvr6SvPZ2thTYNcCsuVBTdATXIRsJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770654364; c=relaxed/simple;
	bh=vOt6IWZzTIDhkiXg48eP8sqkTRhkQ87IKPxf/63TD2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lu+L+FywlmIc3PgjW0mVobSnQnACEgBqMjB/GWS4SmrZDJ873Mh/KtKNP3id0s6XJWaHOHT17QtZPAZZaCnhw3eXClJddgfpzWnUTrMMqJ79dQgcux9JdfTyatkh2M5wWYHlWgTIu9uzgZ2l5gvc1+ZjApjdYsSGE/gomXPRGsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UPKNlM6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UPKNlM6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C690FC19423;
	Mon,  9 Feb 2026 16:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770654364;
	bh=vOt6IWZzTIDhkiXg48eP8sqkTRhkQ87IKPxf/63TD2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPKNlM6aX9IYrncrd1XInuqgnztttR+i39gfBf1nIto5ICv82TRvOFP2WQvGMuwcU
	 7SiEAmA1gFHAxf1saQzxmc1BapTFMf4suo7QqE2WBVhQit1madV7P5nmFBEeeDUMHC
	 orFThx4ZnmdKfJNQronmeMkSPlD88U52bCb940b1sBX3U+wP9e4JV83xZ893IBJA67
	 7kKmlvpvlK7mEuwMjOKLLB8TItv497gtVpuNWn8Hg56LoBe9rsXespR49/17Pgh7QE
	 Tr0qbigMuUCv5Gw/Wn+xPJFDCwQdfJkJ5KT4/14i0/z6R2BecIrxQcLczxLYewDh0e
	 ay/vDbJuKg1Eg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	kvm@vger.kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	aneesh.kumar@kernel.org,
	steven.price@arm.com,
	linux-kernel@vger.kernel.org,
	alexandru.elisei@arm.com,
	tabba@google.com
Subject: Re: [kvmtool PATCH v5 00/15] arm64: Handle PSCI calls in userspace
Date: Mon,  9 Feb 2026 16:25:56 +0000
Message-ID: <177065098414.630568.10507776922590625513.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260108175753.1292097-1-suzuki.poulose@arm.com>
References: <20260108175753.1292097-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 08 Jan 2026 17:57:38 +0000, Suzuki K Poulose wrote:
> This is version 5 of the patch series, originally posted by Oliver [0].
> 
> Use SMCCC filtering capability in to handle PSCI calls in the userspace.
> 
> Changes since v4:
> Link: https://lkml.kernel.org/r/20250930103130.197534-1-suzuki.poulose@arm.com
> 
> [...]

Applied first patch to kvmtool (master), thanks!

[01/15] Allow pausing the VM from vcpu thread
        https://git.kernel.org/will/kvmtool/c/56f7f680de28

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
