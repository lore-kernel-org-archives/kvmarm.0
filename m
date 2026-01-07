Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215563093C4
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 12:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767787207; cv=none; b=sDrK3l8CYo93x9t/cyhqyYje0hzX6rhUhKCCbj4Ij7i3sgIhjxxhNfOFkSplJjLPKB3VNt/9e2WBW9Uj23MyVgqK8Pe548P9xowbWu7xa9mi35gX7ekoQElM+QaNcJqzxG2dX/eCA+zZFHEKLwrIBZn9F8d56i4q9KdTeMq/IpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767787207; c=relaxed/simple;
	bh=DFzcXBzUKkY3oB1avFcHqpTKyx2NIBr33jUnOa1uluc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cVFKb6+9fqD/V5X5hq4vofrcIrVTEZArvmSmr/FyEOUDEw/4gKmVbmsuT+3DvYj6FuVXyJaUrWfY7PYC4qrfEcIxXk/Ilrf+gJsGq3f3922Di5wtkDn9aJFNtDqNlKOwRPnV23JPDE02KEbSqklGCw+Xxsd18YcDsI2UWIKyOUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=buAczF4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="buAczF4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945D8C19421;
	Wed,  7 Jan 2026 12:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767787205;
	bh=DFzcXBzUKkY3oB1avFcHqpTKyx2NIBr33jUnOa1uluc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=buAczF4h9LdQUJ6l4BOZWhEC6r+tsX+AzMnJ3stxO/TW8aLEH5Tk8QQYxk0DIClsX
	 dqh2RjVqOtxXYH7jPauiYAolTUYAFQl2itwgc2rZTJGJiL+g3tbnDX3wCZsjklz89W
	 N/m5/ZuAryf6lURGeGEG7X20AsuHxWILr+jA0jwLKHHL5eKO051I52n3iKnMfmUXaY
	 SAw1u7gjVv49B9iDu6ZRL/F/g+Y19Od6mn1DHG7QGzbP9oqtCFd6AEqUf526Ui+Fqg
	 6nA+wSTSHI5Vzen5yajdZmH+kSF7OxrlXgZ5irajHGhRYhIjSDk5LC3PXxwrrn9e16
	 wMlZdN1CE85Ag==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vdSCp-000000003aK-1F7E;
	Wed, 07 Jan 2026 12:00:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	tabba@google.com,
	will@kernel.org,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH 0/3] KVM: arm64: Trivial FPSIMD cleanups
Date: Wed,  7 Jan 2026 11:59:53 +0000
Message-ID: <176778718617.2735797.4211814414552789582.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260106173707.3292074-1-mark.rutland@arm.com>
References: <20260106173707.3292074-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, mark.rutland@arm.com, broonie@kernel.org, catalin.marinas@arm.com, tabba@google.com, will@kernel.org, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 06 Jan 2026 17:37:04 +0000, Mark Rutland wrote:
> This series contains a few trivial cleanup patches left over from all
> the FPSIMD/SVE/SME rework last year, all rebased atop v6.19-rc1:
> 
> * Patch 1 corrects a comment which I typo'd.
> * Patch 2 repacks some flag indices to be adjacent.
> * Patch 3 removes an unnecssary ISB.
> 
> [...]

Applied to next, thanks!

[1/3] KVM: arm64: Fix comment in fpsimd_lazy_switch_to_host()
      commit: 334a1a1e1a5f8b4b172683e7507cfec566313a7c
[2/3] KVM: arm64: Shuffle KVM_HOST_DATA_FLAG_* indices
      commit: acd8bfaa9384300a509c8aff5ee4a59a06eb2b2b
[3/3] KVM: arm64: Remove ISB after writing FPEXC32_EL2
      commit: b1a9a9b96169bf1f9cb94b8aa33601996fad1e9c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


