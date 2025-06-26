Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB6F38FB9;
	Thu, 26 Jun 2025 07:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750924377; cv=none; b=m9s4z5b6taoSlyx/5feYraCWC1wtEwvL7iHuBLo41w3rzgnSnxP/qzEVvAYJMo8C5iOxhSW482rLluYqmynnDoKtULZ9k7hDGRXQtlpU1ftjUxy6WPSSQLKPfJCEOyg2StKehX0sZf1SIsGG8TpmJDEC+K25ClaZoGJCXO7SkLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750924377; c=relaxed/simple;
	bh=pJA1oEnHjl7M7Z9qrdqOkWhZGLir+8D6TagEYS/sYmc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GGKDCeBFVbauqq9E4Aeh8eXOexkdgD4ujPnmSAs3gjnZFohqC0+JZiqKc0adbVPONXksMYiiRg4p6EAoPKkjfHIFE5xe2nGEZ3YskeyCsI5YEy2yzcJZrQLUErmzMRiIPdPB0DEj1wh1BmBuorIIJPUe+y4T+Rj6JC6XSs9yo+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g8tEl3zA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g8tEl3zA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B36C4CEEB;
	Thu, 26 Jun 2025 07:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750924376;
	bh=pJA1oEnHjl7M7Z9qrdqOkWhZGLir+8D6TagEYS/sYmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8tEl3zAcKnl8rBFQAKlUrnNDdx7tOq3djNZLVF8prU9kr9+VwIeqrOYRiDVqzdLa
	 YZB2wxKAIHM7r77YFbVYdAXaCX6MLpabsUjwAatSY5cgmgsACdqSTJCgs9g2KU9RgU
	 1jepk5Fns3rRgq/+AF2XlbWQCWAobPpDWCBOlAf1cDqOpdXQxfi+BOIY8n9GYhFiPd
	 N6ONq7+M1DOL9BQQFwsLM3Rp+uIF1IEW/vfJfpMaIIbvYRvizTC2z0+H22Fvb8dcYZ
	 wa83J0Uzo9ESjbuKrn7iatx0TOfXb3/Wa9iSvzSRfk/CQ9IpECvTrQgDlca7xjA4mh
	 uBr09ZNzMfUpw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uUhPh-00A8gF-Rn;
	Thu, 26 Jun 2025 08:52:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] KVM: arm64: nv: Fix MI line level calculation in vgic_v3_nested_update_mi()
Date: Thu, 26 Jun 2025 08:52:50 +0100
Message-Id: <175092436132.7925.6436811848886215951.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250625084709.3968844-1-r09922117@csie.ntu.edu.tw>
References: <20250625084709.3968844-1-r09922117@csie.ntu.edu.tw>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, r09922117@csie.ntu.edu.tw, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, jintack@cs.columbia.edu, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 25 Jun 2025 16:47:09 +0800, Wei-Lin Chang wrote:
> The state of the vcpu's MI line should be asserted when its
> ICH_HCR_EL2.En is set and ICH_MISR_EL2 is non-zero. Using bitwise AND
> (&=) directly for this calculation will not give us the correct result
> when the LSB of the vcpu's ICH_MISR_EL2 isn't set. Correct this by first
> adjusting the return value of vgic_v3_get_misr() into 1 if it is
> non-zero.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: nv: Fix MI line level calculation in vgic_v3_nested_update_mi()
      commit: af040a9a296044fd4b748786c2516f172a7617f1

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


