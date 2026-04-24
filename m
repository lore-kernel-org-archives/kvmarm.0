Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D214B39B97F;
	Fri, 24 Apr 2026 11:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777028887; cv=none; b=S6ulxh23bJN6r8E0PPWDrJ77AfDT8/0KAZm0BXgdLcvCTt8geksIoSpjR0GwGk7XF+vByAqOZLE3P4LZH7bhPVdCnVH565fYS/VYbqXkq6W6XUcaT9X6GDEKEAdMvkvhGaz5PwqMHxHc0F89h5ciTW8WmAObUD4hyR8343xe5Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777028887; c=relaxed/simple;
	bh=Ea5gfF+HbRCMpht8ZAX8ej/HdIt06cHNLMmLRfWSvcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CIFX6dk/IoSsPxNA45Qxjprsq27cyf14Xf2tKXYnEGykR8jn7KZo+E0YYy+sJwr6+OV0S1lnOhq7CKqMYPV9IRRFhteU/0qo09adVte9CB8sFSZiRj4wAryDtaWhptkP4Zr6YZmIaXGAogoe1bgat19YkoApYgo09NJ+tQIqGqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y9xOnyAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y9xOnyAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A7DC2BCB4;
	Fri, 24 Apr 2026 11:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777028887;
	bh=Ea5gfF+HbRCMpht8ZAX8ej/HdIt06cHNLMmLRfWSvcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9xOnyAg7p/24KacJ858wX3cZoHMZCs1Pmxrx5QXUdmgF4CFM8pIUGaakyX2+4HDZ
	 8blnIujUN1DTs7RzLn9giR5KdRZXzfFEAQHIxQk1wBColOQzNa4OE0qtfCoXZ9T8ym
	 BUaSoJbW41Cm8uX6LCZ6lfHQdO9y9XPXSNaJyawATVqHsvFmDVH7V9HjBECL713nyq
	 oL4U/OtJdur1rfbKZMSr4QmHK29hlhrb45JRO0qgf+hUgWZIlwoSUT97SlqeCU9sPQ
	 cJiqnUjyh60W9opatnTSWuM+qnzuNjeTXDfwMdgRgEutISFicMryvVXu6XyETgSRl4
	 kI2QM5hGL6I/A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wGEOD-0000000ELuS-1s94;
	Fri, 24 Apr 2026 11:08:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Wake-up from WFI when iqrchip is in userspace
Date: Fri, 24 Apr 2026 12:08:02 +0100
Message-ID: <177702878146.537738.5575062424805224774.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260423163607.486345-1-maz@kernel.org>
References: <20260423163607.486345-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 23 Apr 2026 17:36:07 +0100, Marc Zyngier wrote:
> It appears that there is nothing in the wake-up path that
> evaluates whether the in-kernel interrupts are pending unless
> we have a vgic.
> 
> This means that the userspace irqchip support has been broken for
> about four years, and nobody noticed. It was also broken before
> as we wouldn't wake-up on a PMU interrupt, but hey, who cares...
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Wake-up from WFI when iqrchip is in userspace
      commit: 4ce98bf0865c349e7026ad9c14f48da264920953

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


