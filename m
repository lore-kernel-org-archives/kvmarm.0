Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317032E06E6
	for <kvmarm@lists.linux.dev>; Sat, 27 Sep 2025 11:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758972607; cv=none; b=kB6ackFRNUd0d1J5xlqeuICshVUImOYvmYZV/JihUQxOfipM58azoHlNwxT+7Tu9YUG9rwGN7TbZc4BCXR3V4ZZ+ZMa1keTtQB9C09OEEzEr2A0WKPl/5/xg55BJX9HSuZflgMrv11YUyQGcwUd1rJpiZFRC4YTpQj4427Hr0fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758972607; c=relaxed/simple;
	bh=OeP0i8Iirv15JrdBhSaIWmOkXYQXbERJCgqncNadi5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B9KpF9FPsDoa+4S6dODGeEahluuB62Yk4lMuepdb9DfD0hHh+GnU13NfS+/4NyWyHsELfTY8xG4v4fUDkAm1cZhO8Eamg7Y778y9OXb7kfOhrj2+MkjRgBj/TkB64BLqQXckx2Mr9+7g+z52g0E6D/YQqLAzSShViCtQrMI1wXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XJMpTBaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJMpTBaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4794C4CEE7;
	Sat, 27 Sep 2025 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758972606;
	bh=OeP0i8Iirv15JrdBhSaIWmOkXYQXbERJCgqncNadi5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJMpTBaJAB0Kq3aeu8wEtefFjPJZ3waCEbgTMOHf8dAxYZniG3fSza1HbABM6VBSN
	 fl69+R28hwmDDsQcZ8ZKwC59owuyxr9MG9hJXKLNPDVEs2PckiKDCElfr7yq/5oBXS
	 j9QzHivPP3elo5lpzuKkCXWK2NdiT0HUXkPAK8oo+dNGGU2k+NZq48wRfapP/SgZAF
	 LTQj6NZWLpJLmYKWUMtRBvgVyYGwq2e8pMaeQkAXII9Ogo8KbxvWvRiF6YQ1UpUePS
	 azeNUbb7nm1xG+S/VRLnAErMairzAGRqW513LlbZ5nVFy8Rihy8UFNFatVDJC4Vr2q
	 rEA/cOIKob9mg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v2T7s-00000009rd1-1aTj;
	Sat, 27 Sep 2025 11:30:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jan Kotas <jank@cadence.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fixes for NV+SVE
Date: Sat, 27 Sep 2025 12:29:58 +0100
Message-ID: <175897259874.2798422.14525256541540685044.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250926194108.84093-1-oliver.upton@linux.dev>
References: <20250926194108.84093-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, jank@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 26 Sep 2025 12:41:06 -0700, Oliver Upton wrote:
> After staring at the ZCR_EL2 handling for the issue Jan reported I
> also spotted an ugly preemption bug because ZCR_EL2 residence is *very*
> different from the other sysregs.
> 
> We could definitely get away with loading ZCR_ELx on the CPU at
> vcpu_load() but I'd rather not given the amount of special treatment
> that we need to do for it already.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: nv: Don't treat ZCR_EL2 as a 'mapped' register
      commit: eea94a0ea55d7c65fca192927481f9c5cb90efd9
[2/2] KVM: arm64: nv: Don't advance PC when pending an SVE exception
      commit: 5bd5d7d43a921ffee7dedae1b3ad5dea28fed385

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


