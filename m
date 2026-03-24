Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364D8387587
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 10:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774347429; cv=none; b=sYci+Ih+sqCgHM4LyBdZNdHFCgfYCV0tuyNG++RUa/PcgMHsTy5FxDa+uCq/tUkd6st+HmjdV4GtDUE4V4/1QmPVYp2/xxLeNsCS2/0wnNuT5TlIat3sR7MtzJM0Ka77OMA+bg18TNvnxbVZFJppMvv4qtrO/e+0iUkZHq6Qlsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774347429; c=relaxed/simple;
	bh=X57S92v9PsVwANXqz2O9mxWwkDwdhZBcWmfotp7Y8ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ljh6fnNQmSkS8lGMomiD5wT/wg1+ft0+mtgRL3NmhfmwT3gKzWVwx9Vc4dM1GWP6DyNjoutXGEz2bXdO+DqpsmgFrTXEcHnd2mg0uPcJbJ7aE4EJoqNVAOD+aDHshJ7bV2F/xUyXkpfrFh419/OAF6l6HfIEC6CTGoxBmessMXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WJI+7T8b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WJI+7T8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA612C19424;
	Tue, 24 Mar 2026 10:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774347428;
	bh=X57S92v9PsVwANXqz2O9mxWwkDwdhZBcWmfotp7Y8ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJI+7T8bkIRW2PoOLSUOY2IqNusWm+c8BS/WDcatufsiApR52vyeazBcKXEee683U
	 HyPDF8xpCfmhzOW/66gbd/W9bucrpJiG0Jj4xCGOOhTNJn3UR2108UguEhQnweerhS
	 OKf9O/2ZNCw/fzhsavx0NQMjFU4x64Jgqz3+BUneQjdeneJgNTNNODoKv1tFqdhhzj
	 m2aBOzlhTPtb8uRBwzEuiCGw3bOp0YukoVVjasYrGB7iLrrmHTLHErsPXUSeZePrgA
	 Hd0UPPulp5+dCch1OIKR6qDOLNXxNAhEgdeuIQ8oTFM+ZUqugikc4ZHKGYL17ayHlW
	 RV9aHrwZErJ5g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w4yos-0000000572R-1i9f;
	Tue, 24 Mar 2026 10:17:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: vgic: Don't reset cpuif/redist addresses at finalize time
Date: Tue, 24 Mar 2026 10:17:03 +0000
Message-ID: <177434741587.3191556.9572155374639344215.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323174713.3183111-1-maz@kernel.org>
References: <20260323174713.3183111-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 23 Mar 2026 17:47:13 +0000, Marc Zyngier wrote:
> Although we are OK with rewriting idregs at finalize time, resetting
> the guest's cpuif (GICv3) or redistributor (GICv3) addresses once
> we start running the guest is a pretty bad idea.
> 
> Move back this initialisation to vgic creation time.
> 
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: vgic: Don't reset cpuif/redist addresses at finalize time
      commit: bb90920c5ae1217449409dc0b5256c6ed4ccab27

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


