Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5572C3248
	for <kvmarm@lists.linux.dev>; Sat, 28 Mar 2026 17:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774718043; cv=none; b=TESVqpSr27YI629o7Aa0AWAet9U+nMrtVM9zUQNnFGMy4kVZQaehB6Y3HG9atgbwJ3SgsXaoV51rNP1HXTecB7Op19r2oX7gU1qMkWje0fZAp0R22SrohzTM/I/wwxgYleYPG5uSJIveRKwS1F4OmYH/bLD/VQYa6DEEoQbq3Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774718043; c=relaxed/simple;
	bh=mDmQJZ1IBenCzInFd2Kb+fmyIt8tSDMmmiM1p0CHO4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O2i5mho+uSyiCqt1lgHS7QEhhkXIhnBhzNy66yKcNv5x1WWLpp6XlLQwyfN/a0b3r9uOxwKbxYxzUJK5JuHIPr/Z7SzvqnOBhsI2pChVGIZsb4RF8biRkmHIxcMsFSU9hH5BA77DkvqSlT++0MMIJkLd43UuPJsd87do3kS5KxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R9+9oMEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R9+9oMEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A48EC4CEF7;
	Sat, 28 Mar 2026 17:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774718042;
	bh=mDmQJZ1IBenCzInFd2Kb+fmyIt8tSDMmmiM1p0CHO4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9+9oMEzq7UyGPggLEV8EOjhR7vO7ibqVCBumOF3S3hw3I4Ve3Mf04QiBQlGRVpcY
	 eiT4SvdwBDdm9S6S7FIUUDO5HcAxZiN4q7g4D+X4H60J30b8QJBRrW+xVv9bTXw017
	 AFnezxgpCduPy1BRSYselgLfJTJfIVBdHDKR90JOqCIVrnPOOPS2X71ZjMCnNrap4k
	 6o3L2StCgPjk96RnIM27e7+n8/MY2VOPotIKAJ363qL84jNL/rv24iVlznsiwcnveO
	 CoMkwl7EqYdQc9AXVUjz2CoaroJXFlj+AUG3qDqX5dUAcHOTVyaS6r38comg0vT9Ry
	 2Cn72/uh2f9YQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w6XEV-00000006fvb-3lfA;
	Sat, 28 Mar 2026 17:14:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Yabin Cui <yabinc@google.com>
Subject: Re: [PATCH v4 0/3] KVM: arm64: Fix SPE and TRBE nVHE world switch
Date: Sat, 28 Mar 2026 17:13:55 +0000
Message-ID: <177471802478.55481.7594241413365738023.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327130047.21065-1-will@kernel.org>
References: <20260327130047.21065-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, will@kernel.org, mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, oupton@kernel.org, james.clark@linaro.org, leo.yan@arm.com, suzuki.poulose@arm.com, tabba@google.com, alexandru.elisei@arm.com, yabinc@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 27 Mar 2026 13:00:43 +0000, Will Deacon wrote:
> I got the Sashiko treatment on v3, so here's a quick respin to address
> the BRBE thinko it found in the last patch.
> 
> Previous versions of the series are available at:
> 
>   v1: https://lore.kernel.org/r/20260216130959.19317-1-will@kernel.org
>   v2: https://lore.kernel.org/r/20260227212136.7660-1-will@kernel.org
>   v3: https://lore.kernel.org/r/20260326141214.18990-1-will@kernel.org
> 
> [...]

Applied to next, thanks!

[1/3] KVM: arm64: Disable TRBE Trace Buffer Unit when running in guest context
      commit: d133aa75e39dd72e0b8577ab1f5fc17c72246536
[2/3] KVM: arm64: Disable SPE Profiling Buffer when running in guest context
      commit: 07695f7dc1e141601254057a00bf4e23301eb0b2
[3/3] KVM: arm64: Don't pass host_debug_state to BRBE world-switch routines
      commit: 7aba10efef1d972fc82b00b84911f07f6afbdb78

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


