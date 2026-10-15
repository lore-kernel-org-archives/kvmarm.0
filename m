Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5841625EF87;
	Thu, 15 Oct 2026 09:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792056723; cv=none; b=p/Xt0TkUOekvcFtdKgCFcd/zTGvjttD/2db3qa02YxnSzLwGxFIM6QfivLyTsIDA4KZFh5duXAG5rRgTxres8/vgfvMMS3l+OenlDbJ+FAdiNDITDkLxIpqBZWf2rbkuJaDLGrII3VaDDHd7VQDSrrFmV7zRh3iRdYSVJ+XJ6O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792056723; c=relaxed/simple;
	bh=QzdpYfoQEErbBAebGY92+RcigWxBHMQS5Vtn0cOtBmo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=dirD8gd8BxVOcc7yo1PBYJLrVmeZNCOmcHGlPAgPp74FSLMjfdAZI5L9IoqS/4qN5bqY3Q1Xl98M/dG9hSjtgmzwJruLUap7nPFElAxzGCf6+Vk+ouzOxkUbHxHAQF9Lv+QshVvt8j0hl2SSfpGvMufyBazKOWeAGc6Osmi2EBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TtAttl89; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TtAttl89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E0E1F000C4;
	Thu, 15 Oct 2026 09:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792056721;
	bh=r+ilM+P1ev730bUBcqRovMoOiqIOLokGHIw92Q+VPKk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=TtAttl89pU+Ar6H2ZGB8oGU19ZW3MJFoRwyM33BzqO4kJQ1r9EW91CaaTA3zQ9jXz
	 div97sLCynNqQjbNjp8THUt/J8DVqJRKtbKCPZfUJlfGSvZntf+STilaWf8RDIJfYO
	 6nJsRJHCZIVbjuW/2ZqKFG8NjTUnqlDKLJJCfEQyhj72X2QhFMEdJvB7tCi6fnmSIA
	 D/BBGOUNi123ZYVeNkmp4/+09MU+MdBji8hD582ihHHCnTB7HBKDbgbUN1T/11AQXh
	 bmnGZ+e6ACgCyw9brL9WLWGJXz1fnotuoWJUvDeeiim2ihuN/FnTcpvTL/kdNA+wt7
	 H5z5kaf3TRpvg==
From: Thomas Gleixner <tglx@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>, Oliver
 Upton <oupton@kernel.org>
Cc: Eric Auger <eauger@redhat.com>, Joey Gouly <joey.gouly@arm.com>, Steffen
 Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, Sascha
 Bischoff <Sascha.Bischoff@arm.com>, Sebastian Ene
 <sebastianene@google.com>, Yuan Yao <yaoyuan@linux.alibaba.com>, Fuad
 Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] irqchip/gic-v4, KVM: arm64: Fix the vgic init
 error paths
In-Reply-To: <20260921072958.2918477-1-fuad.tabba@linux.dev>
References: <20260921072958.2918477-1-fuad.tabba@linux.dev>
Date: Thu, 15 Oct 2026 11:31:58 +0200
Message-ID: <87wlrje2cx.ffs@fw13>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Sep 21 2026 at 08:29, Fuad Tabba wrote:
> Hi folks,
>
> Changes since v2 [1]:
>   - Patch 3: a vgic_v4_init() failure now frees only the SPI array,
>     since that function unwinds its own state; the teardown label is
>     for the routing failure. (Yuan Yao)
>   - Rebased on kvmarm/next, where the routing failure already tears
>     down the GICv5 state. Patch 3 moves that into the shared label, so
>     the SPI array is freed on that path too.
>   - Collected Reviewed-by from Yuan Yao on patches 1 and 2. (thanks!)
>
> Four fixes on the paths that run when vgic init fails partway. Each one
> needs an allocation failure to reach.

Marc?
