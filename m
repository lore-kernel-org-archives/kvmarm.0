Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E29929BDBF
	for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 16:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760374586; cv=none; b=jPhdFVGxvdfT93dEVVz896Wzga24+mGtQ+WH2yIAl5U1AQlJOZxBhlHq4Se4LUHxQI8Mi4SfCWQvr9Tignin0+trDiTB46XSffQ+v2qo3vU/ic/nyCgki6Zh93YAqr6lcgqKtrs6wObijdA/efcvxFYJT9IVO5bngbDbgjjpBL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760374586; c=relaxed/simple;
	bh=gNLN7Pti1bOZ2Xsv9KZwfsHwKMV9bJGIivKaX2POC3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZROWXF3O8WKTr48NHpnfljNYkJqDTYR5ncj9TXvN5KeeGyyQd0S5oAfOc7RXi2Jt7wCwNyFQLbfeqrHXFHtBCCCtlEZBxreCpLVfD0goM0jSsBBljlvFcTR1zdgZ1ccPMQMn4Z0B4CQyYB7klpZ5PBc0gBIkuBYVsbrjgO4NdYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QjzC/Zy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QjzC/Zy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995B1C4CEE7;
	Mon, 13 Oct 2025 16:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760374585;
	bh=gNLN7Pti1bOZ2Xsv9KZwfsHwKMV9bJGIivKaX2POC3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjzC/Zy+zFYIxPAsq56KctQ6QB3BQoZTzyFtOmwY1N3nb9q5TIvOL9WxlluSviLLN
	 9iO6+upmD4YKw7pfixqAzYLyJAyiczWpsSgbo+9AykOulkhGB9QKn/khR5MWefAucE
	 eE90jGcKPtW2Gwu/ca+7pHkcdzx3GKwIl+wSFenh0HAX+lxJIgZezIoHwxupFFYdkn
	 6Fpr1W5eKvTz6w+5tagL/d6VKR00tggzH4FKwJTGCztkXKyHELGW3QFG0WfBiLaw4S
	 HRiSVt0HnSCKlMRDrHSGz5zxt/ijwZhLTL6sBD074QG+2kvNyZg+5vR0ShGLj5KIdL
	 WUj6JtZ0cpa1w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v8LqR-0000000DaW3-3TLg;
	Mon, 13 Oct 2025 16:56:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Cc: oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH] KVM: arm64: selftests: Sync ID_AA64PFR1, MPIDR, CLIDR in guest
Date: Mon, 13 Oct 2025 17:56:21 +0100
Message-ID: <176037441174.969330.14159948575043752138.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251012154352.61133-1-zenghui.yu@linux.dev>
References: <20251012154352.61133-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, zenghui.yu@linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sun, 12 Oct 2025 23:43:52 +0800, Zenghui Yu wrote:
> We forgot to sync several registers (ID_AA64PFR1, MPIDR, CLIDR) in guest to
> make sure that the guest had seen the written value.
> 
> Add them to the list.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm64: selftests: Sync ID_AA64PFR1, MPIDR, CLIDR in guest
      commit: 9a7f87eb587da49993f47f44c4c5535d8de76750

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


