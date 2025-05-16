Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDC91361;
	Fri, 16 May 2025 12:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747397213; cv=none; b=UHeNdF2KzTHTvrFaI+8hgS4xqKs9VwxVyBNMdxh9LCd9ukdfkAfNv5ryd7wC/PuBLKt4cr/A/ocS1Curl5/Z+QC9Hy+Ec6HXtRsXFikvGAM06sdyTi0tuYx5DcBybhmAVUO6/PZNyqg1QutuV/wpFBbkgtkyb0c8pUI8vZF8JA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747397213; c=relaxed/simple;
	bh=YVC5S9ZL3DJBFupA3JCCgZgdIfQCsHEqHZ600McfhKo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rLHZo6YQck1fUD7/+dM3O9NnjI6/0DQwTwGb41jcrBJXQn90/R0pT/1D0zCRnYWO3KK2Xp9OMb9sd4mSTmOBaNkto3yxflQUk3Tr10ItPLC14oJIsUT+sTqfDmM/Z84exq4KrkSiFyBSEBZtxAcntP9v0MUc48VUHyVhy+hXF90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RX6+G9yC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RX6+G9yC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35145C4CEE4;
	Fri, 16 May 2025 12:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747397213;
	bh=YVC5S9ZL3DJBFupA3JCCgZgdIfQCsHEqHZ600McfhKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RX6+G9yCD2cqcY4Ffqv68F3AHQI1luiKN1nyR39iy7FK/dqfN6dyIykaBFIPIbu8Z
	 TZew2gR9Jaw5f8lLGS4im/wCCP+a7obSfnE285H0ZuuPF/qaSRdPAtaJsk5htiS/Q8
	 YlvOaP0135woHv4kqXZoaT8mR/1nlrCkJkFMOMUcc0GVHjbW+OLp5/5MYWYKyBhDRJ
	 0VTzyCbZZdGGl2eJ3rQrrk3f/v0OSVBn40qM3izXoR5XGi+p2deUNSanBeyVv8rpu2
	 THi/JvbD+lFYxDUW+36YALf8h6aZFNGr//O5Cz4VVZjlnYI40G2tw8IVpot9sMObTm
	 pktOP2UHrgu0A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uFtpz-00FXq5-0g;
	Fri, 16 May 2025 13:06:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Christoffer Dall <christoffer.dall@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: nv: Remove clearing of ICH_LR<n>.EOI if ICH_LR<n>.HW == 1
Date: Fri, 16 May 2025 13:06:47 +0100
Message-Id: <174739720148.2525124.8020669410674069519.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250512133223.866999-1-r09922117@csie.ntu.edu.tw>
References: <20250512133223.866999-1-r09922117@csie.ntu.edu.tw>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: r09922117@csie.ntu.edu.tw, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, jintack@cs.columbia.edu, christoffer.dall@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 12 May 2025 21:32:23 +0800, Wei-Lin Chang wrote:
> In the case of ICH_LR<n>.HW == 1, bit 41 of LR is just a part of pINTID
> without EOI meaning, and bit 41 will be zeroed by the subsequent clearing
> of ICH_LR_PHYS_ID_MASK anyway.
> No functional changes intended.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: nv: Remove clearing of ICH_LR<n>.EOI if ICH_LR<n>.HW == 1
      commit: 92c749e4aa90cd684d87cb5bde6a9d51e83fe6e3

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


