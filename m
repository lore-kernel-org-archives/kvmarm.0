Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B26A2C029D;
	Wed, 20 May 2026 07:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779261241; cv=none; b=OHu66eU2fRaW1HITIQdjg7x22hF6/F5OKsgoErnmLCQKzmY0zZX5Osf1ApPfK+FpTggLl+JwVs6BHYj9K7whBwJikwK0eBb6SqWWbyjgDPhx6SUrRoj+QqJ2UEPwYKmrzC492M2SurEfPYlBWBx+ATmwkgLtZ8NPy3g9SbBQteY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779261241; c=relaxed/simple;
	bh=Omk1GK48uaQTvwQx3DRNcE9N40pY0spGM3LxtBqehIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BUYan1QGTLJ8Ou5a8nu0xUsdexdR7U2eGiKpoRp7I92Y7FnO+OctHvFHHZB2eBq1K95FeOJiQyDecwn8nIh2ty2p2T2lPbUTx7XELDov4Y9GZvrzEEomf5k6uS+T7PjnPH0xJ3EPvbIIyX8Hg7cQFZGbwGcXVtj2sC+b0ZR4jZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=baOEhpPl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="baOEhpPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52111F000E9;
	Wed, 20 May 2026 07:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779261239;
	bh=PMvBUpEgXSeKRNncOVDBP9O0vPsscPTWuBykm2sSqXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=baOEhpPlP87qch1i34tnXPikTwZ14iuIjurWtLg2BhEAknkpBqeLqLcvSJvQpGGuu
	 g2Qz9J1zlkP3vSrG0jmXKSHIkXcPa41Ui1v/TDuTNUqYYeXtfYU9jgECrA+2LkwIpM
	 nR+CAQZ9ryEnYdOIqYPfyfRSdO0Q3eA8j/5gW4PAxWWMs0ylUubPZbQtQ25thAyZhE
	 SNPMYzmk/M+tbBR9JuGqTtEJsMOZJlP65RBV7RxKrvBGT5DJbnZ8ROONzc7myuuHtj
	 l5gDaTAkWWX5z8+bnP+d7xMRgFdHsg2Occ84BR3zs1NEawb/qczW4hVaZ5n0+n5gBW
	 SLCpAzAr8DygQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=localhost.localdomain)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPb7t-00000004FYd-3Ou3;
	Wed, 20 May 2026 07:13:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>
Cc: Yao Yuan <yaoyuan@linux.alibaba.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: vgic-its: reject restored DTE with out-of-range num_eventid_bits
Date: Wed, 20 May 2026 08:17:09 +0100
Message-ID: <177926141814.52935.2813857161910568316.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260519132519.2142458-1-michael.bommarito@gmail.com>
References: <20260517174955.273004-1-michael.bommarito@gmail.com> <20260519132519.2142458-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, michael.bommarito@gmail.com, yaoyuan@linux.alibaba.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 19 May 2026 09:25:19 -0400, Michael Bommarito wrote:
> Userspace can restore an ITS Device Table Entry whose Size field encodes
> more EventID bits than the virtual ITS supports.  The live MAPD path
> rejects that state, but vgic_its_restore_dte() accepts it and stores the
> out-of-range value in dev->num_eventid_bits.
> 
> Reject restored DTEs with num_eventid_bits > VITS_TYPER_IDBITS before
> allocating the device.  This mirrors the MAPD check and prevents the
> restored state from reaching vgic_its_restore_itt(), where the unchecked
> value can be converted into an oversized scan_its_table() range.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: vgic-its: reject restored DTE with out-of-range num_eventid_bits
      commit: 9ce754ed8e7ab4e3999767ce1505f85c449ccb07

Cheers,

	M.
-- 
Jazz isn't dead. It just smells funny.


