Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793308464;
	b=aJ97BIVG2Z1BalJHpEpyUVFDAtXZZ/t03yQqIDkxHM+Ui+eaWi/opvVmH7YOk36R3Jud
	 RATlCcLr/q4ALQG9CAHLlkLi+kENiBCOhuBaZs0qvEBSEHpk9pen4PvCiZP3++140HZtW
	 UnScBRsnnzSTrpLRcNL0XewifGVy+KpQfyTR72jzGrPm7CFgIMcDumsab9d4I0py92Z+7
	 RZHdYIm2c5ibGIdU02dddvaTS/v8guk9oX1B+STHxVYoqYdDJhCiHsZUEre7yZ4uZ3GUf
	 Gkrmpu4Zb3V7oPoyVz/YEvLNau0NDLLn+3qUiVcdTQa1Y/M5PH6dlUGJZHGUEAtsizQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793308464;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=7pzjhtn6j5+N8CZXLk0hQRmO9CNlQSOA3omzcm5VGk0=;
	b=mhh96UNztkWH2OpjAldQ1r4GE25IKzMrU9eseWgKWHcTZfd+eF6tv39hzNJ6XW63m7+Z
	 g8n1oFNln69TcWSvg1/cu90t1H6k493l5yiSUPq5d8eHTmBDOcBDosOuM4RvU/FrIovTH
	 cCOAqf5mLE2+SkTPWqM7b/wAiz653bz4wZp3U+FHwUaH3K7X3xJfmQg9VU6sXdBETgznc
	 pfZYQ5qZ0spKPpTQ1WaKcjwHaV9QUM48M8EqKJQ0dK9NO4qBbA59fDJ4i6QSoBGvUJeLG
	 r+G4ARsmwNJGybHeS7TGb7GSqSTYgTrg7bt7XeGWjps7TtYc0V4yzpkF0ORQZOy7NcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=p9DS9Eak;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F9E606A31C
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 21:14:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7F9E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=p9DS9Eak
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D38FC1682;
	Thu, 29 Oct 2026 14:14:19 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D06203F59E;
	Thu, 29 Oct 2026 14:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793308462; bh=38wAcV6+Pv6BUffZcJjTOzperonmticUwGom7ntWZAI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p9DS9EakVP9HFrT+Dq5D5QflP8AsibvK4b16nw+3P+LFEwVRxQqTVKObaNvyb75GT
	 Ek0Tw96E1T0R93ckTjFwoUcsTGJGeiERUvjdZYnZsTL3mmN9rXtnrZImSR4jRyjMft
	 vJQ26MLNCQ6XqAljjKT5k0Edby4PnzN4T+fDm2Fg=
Date: Thu, 29 Oct 2026 21:14:18 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Zhou Wang <wangzhou1@hisilicon.com>, Arnd Bergmann <arnd@arndb.de>,
	Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] arm64: Add override for ID_AA64ISAR1_EL1.LS64
Message-ID: <auO3Kiykovvs279e@arm.com>
References: <20261025075138.2919734-1-fuad.tabba@linux.dev>
 <20261025075138.2919734-2-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261025075138.2919734-2-fuad.tabba@linux.dev>

On Sun, Oct 25, 2026 at 07:51:34AM +0000, Fuad Tabba wrote:
> Accesses to ACCDATA_EL1, which FEAT_LS64_ACCDATA adds, trap to EL3
> unless firmware sets SCR_EL3.ADEn. Once KVM context-switches the
> register for its guests, a host whose firmware leaves the bit clear
> can't run them.
> 
> Add an override for ID_AA64ISAR1_EL1.LS64, with an arm64.nols64 alias,
> so that the feature can be disabled on such a host and for its guests.
> id_aa64isar1.ls64=2 disables only FEAT_LS64_ACCDATA and above.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

However, does this need a plain cc stable? I assume you want it to go in
with patch 3 but that one only goes as far as 7.0. Same cc stable in
patch 2 which you may want to limit (or add both as dependencies to the
cc stable in patch 3 when committing).

-- 
Catalin
