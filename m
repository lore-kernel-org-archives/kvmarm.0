Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711181;
	b=alRE/YRmIq4ct+UwmlN/5xBV+4yz3WbBIY1NK7HzR8JTIZaSjfjJzLYCNYWRbbPUsJr+
	 VFDf1Ua8Rls7mz7Hh2ZHvJhFmJOw9E80XeCEWUQucOm4yVbUgVrhjP6oLVOTKpvR9NmV0
	 GMmPksm9YOhUK3hFWZiyocMuTGt4yl6QgMTdX8HAuvj5pnXrp2ePi6IqXlPJZL7smaDYo
	 +CR7H/zRJIWC3Cd2gKCJJYpdm/pMNP1KMHFnQXSvn2yTl6heh8rUC7461xjTmrMWR6FcR
	 2xO70TWmLyH3MF3L5PtStaMkDbiMfL7TF5xZGdYSG44CiABXZqX7iCAOtXHPz1kIcjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711181;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=Y83TXB3pI0gHj1un5pNeNwtJKzO6fTfsM92MJn/Tr6Y=;
	b=eNhQOcdTW8UtKZoaYMc24xfi+V4fLDuyAgCsVAt98NjVlf3Vh0M2OqEI7dX1MJlIECJ1
	 MtPTIDzk4RgZKNMpJsJ5n+4c2q2VpXfoya1CIS7CZt/C1VY6mhr9EsFH1V4uPmm/Tp3b6
	 OQNk6tUw8K0PuNCBcs3ZiyGUwlcYRU+3vXOKetveUjViHN5NhDO/MKkgi1Uw5j5m7tYVH
	 Hx/PWqBD5rB9ilQRl+uj7HVOkiqePbSTWTTkZljZ7TaUBYb9MdoSd1t/r2fDE6M2ZYh/g
	 y67pzFOMXT5sSYQRYbGllWZEkU1gdL2+kLv23Ru2SF9KyiB1jup//nwrYgp8IeucLlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GnJy1aiA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADC2606A336;
	Tue,  3 Nov 2026 13:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GnJy1aiA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A111F00A1D;
	Tue,  3 Nov 2026 13:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711181;
	bh=Y83TXB3pI0gHj1un5pNeNwtJKzO6fTfsM92MJn/Tr6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GnJy1aiAn3tS1izjvwAFeQRs4WPdoYFWRPqCYu9Ni9pa57b6xnevbXiGLzngqongj
	 mu9m6EBmj4WtrJADo1Kc1Qb6nO1mDuggsDjIqmNN9oE8Z0QMmdYMP+iy9doreS/sBV
	 f1iIXdTNoaqQZKaDWaeS80wa5mKYpDYZp6fnXO5SN5wB9UMkrkIgkWxTzThTMADf4R
	 6yvxnu9E2fmEBZ226q7TXQ5DtsdbKRrpjc74Ctq/KzBViT0VcOZbS2EnmqqpJPnkeZ
	 3JyPwcfwHrcRlyOlMZMT89i29rE7VMBp8xMpHQBDoNOa2xuW/PU/8Q2ccdDc+TAE0b
	 dzrY0eYamlyow==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEDT-0000000ATWs-2dTM;
	Tue, 03 Nov 2026 13:06:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Eric Auger <eauger@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] irqchip/gic-v4, KVM: arm64: Fix the vgic init error paths
Date: Tue,  3 Nov 2026 13:05:38 +0000
Message-ID: <179371111256.2844725.10760972508293645316.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260921072958.2918477-1-fuad.tabba@linux.dev>
References: <20260921072958.2918477-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, fuad.tabba@linux.dev, tglx@kernel.org, eauger@redhat.com, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, Sascha.Bischoff@arm.com, sebastianene@google.com, yaoyuan@linux.alibaba.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 21 Sep 2026 08:29:54 +0100, Fuad Tabba wrote:
> Changes since v2 [1]:
>   - Patch 3: a vgic_v4_init() failure now frees only the SPI array,
>     since that function unwinds its own state; the teardown label is
>     for the routing failure. (Yuan Yao)
>   - Rebased on kvmarm/next, where the routing failure already tears
>     down the GICv5 state. Patch 3 moves that into the shared label, so
>     the SPI array is freed on that path too.
>   - Collected Reviewed-by from Yuan Yao on patches 1 and 2. (thanks!)
> 
> [...]

Applied to fixes, thanks!

[1/4] irqchip/gic-v4: Clear the domain and fwnode pointers after freeing them
      commit: 861bebd1fac5f5a25c11e40aec3c3291542045d1
[2/4] irqchip/gic-v4: Unwind what its_alloc_vcpu_irqs() allocated on failure
      commit: fd86d69c951765e24e89a162c53dfe33a8aba976
[3/4] KVM: arm64: vgic: Tear down what vgic_init() created when it fails
      commit: 9f63ac1e31c370d5ed9d49caec4faa469d0007fc
[4/4] KVM: arm64: vgic-v4: Restore nr_vpes before freeing the vPE resources
      commit: 1ad8b8b8827e72b7d5907ee47c43ca0e2506b4f5

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


