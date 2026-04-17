Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3D92ED846
	for <kvmarm@lists.linux.dev>; Fri, 17 Apr 2026 14:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776435825; cv=none; b=lIuTfyyY8qgiuNyKyGxSUub6p5OsfcDSNs+BA/iSc3ryeExmPMB51ZsIdEGugwnhlHFcwl35/vGxdEid9aC3UKPfhQmbRoqZh14p7xhYn6dsBAXCM0GBni5zMs2DGdk8yEWTCJlL3WFahh6bJeeO/lq7bmVSKs0XpTKWouksSes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776435825; c=relaxed/simple;
	bh=zhUHPzY2DIz9PTs+Q9VEpXkjQUQmTgulEPEXDyPPQfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IwfNx310s3YaNXS2N8blg+0GGCzBohAD6kvkZGFvk3kfRPFS1JkfOET7YVDYy8avecDbdGGiZ673haKmelSWj++cwTXpyUTDefE2d+oryN3hLqChz9LLqq0l+/MB0btheTz8Hw1nO5oTH4yqVbq+PQumLfzSl2241e+70gmrtCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rf1FTpNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rf1FTpNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A28C19425;
	Fri, 17 Apr 2026 14:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776435824;
	bh=zhUHPzY2DIz9PTs+Q9VEpXkjQUQmTgulEPEXDyPPQfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rf1FTpNWQlUgJbCcz+8IS8mlsHeHCTVCsqLXP+nBsKGGI9ppoEnx4lPpQlf/5kQmd
	 eRmPYxJ5rry0sLfiRQ28kRC9Yw+wll8Deg2iHQsxxnOnvnw7cLIvEKbnVh26j6M0Al
	 G7ewILkunNgobbMKo1UZOLncGg5vHOovdsyKkpAvarUV+L5bO5TaH1K3Q4e6x2aWqg
	 v0pb41mMtsmXKJxErVzLq0yKDVOIzEtePbgS9U5fTdad12nLU3geX8jZ+mQro+tIUR
	 jzEIol2geCtxlRmC0HAfD2hca1YMTltvWm2MYNXTKjW3c23E/tDoO67tBqKBn7nx+c
	 aEFPjcBWri22w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wDk6g-0000000CTLj-1zr4;
	Fri, 17 Apr 2026 14:23:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	Oliver Upton <oupton@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Re-allow hyp tracing HVCs for [nh]VHE
Date: Fri, 17 Apr 2026 15:23:39 +0100
Message-ID: <177643580644.2772443.3573116792668710722.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260414100231.1859687-1-vdonnefort@google.com>
References: <20260414100231.1859687-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, oupton@kernel.org, vdonnefort@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 14 Apr 2026 11:02:31 +0100, Vincent Donnefort wrote:
> The introduction of __KVM_HOST_SMCCC_FUNC_MAX_NO_PKVM excluded hyp
> tracing HVCs from the common [nh]VHE/pKVM list. Re-allow them.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm64: Re-allow hyp tracing HVCs for [nh]VHE
      commit: ccab51d69b1478b549ad0bbb38f556ab3bfb47ab

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


