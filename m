Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECD825C71D
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 13:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749130491; cv=none; b=uKUzn49aAKMYAUMYxS0gGGaxlJB+86X9+IEU/+2/VCq1Ic1jVR1i6GrjwTFRqcPxfOTZXtOyFHot/NviAKqia2b/JAIbucQMyl9KH75JhEVX3omBUc+GFiLmG8pXFhadcALLpZlV8R9eYeVWFPB/B+OG7Ngl84lEibfNXCZmQPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749130491; c=relaxed/simple;
	bh=6c08yMaPScAPjT2q9PtLNT/m6FgmW5i0I8814t4zESQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S9UZ1FxZ/Hc+p11Pt6hWBrf8lmQOaL6WS7q5AZtSNFO2FViSWy6Y4pMrgkXVYLhZMpbF8hODH18vQpLeu5jKgfXV7oN26w6EMpiW905S2/672Umv7i2wahaGoNyeKm6Fh8Dkaq/2Axg0s8hvauwOJMkd2mMp2air/iPnYWUNnHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oQycruX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oQycruX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1749C4CEE7;
	Thu,  5 Jun 2025 13:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749130491;
	bh=6c08yMaPScAPjT2q9PtLNT/m6FgmW5i0I8814t4zESQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQycruX6Ft+69hoARFw3CXlZX5gxdD4GTl23ki5AbhEGf0LQWe2muG2g60dEsxtv1
	 MY+oAjx1TnLypPHGwI9AWx9k6UHYCKiamVg2WduBh9b7+Q0g6zmSqPuO1vLUTsrszh
	 qgQtXZddYjCr0clgWARxLwC73ZuUfxDbk1iAdA34UsP501In3f6AgPIsyVrs6qxxhA
	 2GbAPXhPAZZjGM8a9RwNPOUwUj1RSKL6Y74Fvd/PtvWbgUZin70cQ5wLl/GB8+zZaK
	 /pO/qcECdt0MAzb0hvHhvM0i1bLbC83O56uuF0ce4slU8JFs42opW+YzshbjAFiH55
	 vO+YyX4/4kIUg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uNAk4-004J4j-OA;
	Thu, 05 Jun 2025 14:34:48 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Miguel Luis <miguel.luis@oracle.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: vcpu sysreg accessor rework
Date: Thu,  5 Jun 2025 14:34:37 +0100
Message-Id: <174913042252.1215953.11968070829426679957.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250603070824.1192795-1-maz@kernel.org>
References: <20250603070824.1192795-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, miguel.luis@oracle.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 03 Jun 2025 08:08:20 +0100, Marc Zyngier wrote:
> This series tries to bring some sanity to the way the RESx masks
> are applied when accessing the in-memory view of the guest's
> system registers.
> 
> Currently, we have *one* accessor (__vcpu_sys_reg()) that can either
> be used as a rvalue or lvalue while that applies the RESx masks behind
> the scenes. This works fine when used as a rvalue.
> 
> [...]

Applied to fixes, thanks!

[1/4] KVM: arm64: Add assignment-specific sysreg accessor
      commit: 6678791ee3da0b78c28fe7d77814097f53cbb8df
[2/4] KVM: arm64: Add RMW specific sysreg accessor
      commit: 8800b7c4bbede3cd40831726d3f98e8080baf4df
[3/4] KVM: arm64: Don't use __vcpu_sys_reg() to get the address of a sysreg
      commit: b61fae4ee120f337b8700dff43b2fd639f3bf6a5
[4/4] KVM: arm64: Make __vcpu_sys_reg() a pure rvalue operand
      commit: b5fa1f91e11fdf74ad4e2ac6dae246a57cbd2d95

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


