Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B551F3BE154
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 15:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772723995; cv=none; b=J6VbMM5K57NqLTzx9TV7UCpd2dazarUmuPDJXliKqqkqj7w277sP+LpOMZoOtzGlOIg0XHUfSqQDGxVliGWWNufal/hYswU2pOWbTwwmKQkvLpvf46kqmVMShkKZ3FeprzLjpMOfFoBym6yf97qza9SPDqvqi+b3EVMjzJAeCC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772723995; c=relaxed/simple;
	bh=VN7n9yn5PJFyec0HMW+P/5sg7qAXWN+gohsAAiVTLkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Efd7NZa1UqS31BtZLicKSHAajJs5a0LnS1H5Jj3uatjxpRKPu2cjWgOLb59wWqPLVxz7aNL4qocG/zSwCDBhwaVtHpf7O8saT/+gAAUXsZh/lgInmtJNT0Q/Z0xJ5lHr3UUTB/+zfTJGrBKN1vP9M0DTK0n2BKHUbWKzQRP5RDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q30LB88P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q30LB88P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5787EC116C6;
	Thu,  5 Mar 2026 15:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772723995;
	bh=VN7n9yn5PJFyec0HMW+P/5sg7qAXWN+gohsAAiVTLkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q30LB88PX/dK9INys+BOUhU+sSAaWnlIweL0ztSoM2OJBHBelFFfLEKM0fQl629lp
	 AdGva/AfxcxQ6eD/oH0QwgL4YyvtF5xYKClqTFr8/fKB40nCnF/w4c5cd+sw3y4EYY
	 AY9ZXrYUP3kc66MzEsTh59ZEQrEo3Y5VIEuqdKF/tSaW/5vzEoC0s1cQ6ctzI6cna9
	 vOLZnPxoqLPyP2+gp1Da8eQeM2hpL8AyeWCtrnXbw8bhnkFDsIUfJtEZ3fDGghI9LR
	 lMmTpXPR8GWzRXbTHsprsE56MKtaqzu0nwBn1ThwtPxluZ6AbyQeK3DZtFi8Ft0bn9
	 6vFmD24tD7IOg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vyAUS-0000000GVHz-3q2s;
	Thu, 05 Mar 2026 15:19:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Eagerly init vgic dist/redist on vgic creation
Date: Thu,  5 Mar 2026 15:19:49 +0000
Message-ID: <177272398041.2929264.7575517803288015477.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260228164559.936268-1-maz@kernel.org>
References: <20260228164559.936268-1-maz@kernel.org>
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

On Sat, 28 Feb 2026 16:45:59 +0000, Marc Zyngier wrote:
> If vgic_allocate_private_irqs_locked() fails for any odd reason,
> we exit kvm_vgic_create() early, leaving dist->rd_regions uninitialised.
> 
> kvm_vgic_dist_destroy() then comes along and walks into the weeds
> trying to free the RDs. Got to love this stuff.
> 
> Solve it by moving all the static initialisation early, and make
> sure that if we fail halfway, we're in a reasonable shape to
> perform the rest of the teardown. While at it, reset the vgic model
> on failure, just in case...
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Eagerly init vgic dist/redist on vgic creation
      commit: ac6769c8f948dff33265c50e524aebf9aa6f1be0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


