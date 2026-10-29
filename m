Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793274898;
	b=XXoKoyQMc58kiwxq68wiGlIRfOPt+GibidIknJ2vbteLBT7rpWRTGIrDAdzM1qJZ+ctz
	 DIw4cG3d/sQLQWGcsgTZve1jZ9lUGCr1BsOPT6scBUKdrZolILNx3qrPgym7BY38JBZ7k
	 YlbWo7XB/+cdiYJK3ancU80Yv11rCf8zhuQ7g8rX13fHxSrBSzXnwewJuVRp51uRTC169
	 JjYzViB0tMLvA+2aTwemaSuUUfJ0tNQTH0XBIKiga3Lz9NFrJq6A6ec7WiMD2in8C7o/G
	 9SYqBaoCh/cYNhV5C3npW49y2YiTfLthyfS1gikQ5ZVy+j6lErzVJkqpVZgu3aRN7SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793274898;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=h/fSgV0zO2t1wf4b6fHc2vLg5ezMBdguHQgR0SISKi0=;
	b=24dqmadH6vMDciOV49cUO1QjpEjzygNfyHjijK7GKjts9E/zZoV72dqTB1HpLYf2aZTG
	 UN4t3ZAgC2vfqJdM/lzSNS1fc44We9WllblbdYPPrCfKIHEhmaVBWq3P80x6yX8dTTNob
	 G4iChu0KX+D/RHJIDekUrDTKoqR1k8GIqzIfg0CFHtPQWpDlGoaVUx/vBsYVsKii64yxy
	 KQn675fGcWpZfcj2D8KlBdqV+9f9yqixcNcEtxiiYUOQtJTi4N8abnu+S37f0YGgFxIjg
	 Er8wT/2/Yhe1tPUhUGqOrk8WEBKLBq+ixdrXHpp07OZbccIJZsMJ+eoln3f4TJjG5sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=I8KFvowK;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D0AE606A31C
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 11:54:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D0AE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=I8KFvowK
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DE9161BB2;
	Thu, 29 Oct 2026 04:54:52 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB64F3F59E;
	Thu, 29 Oct 2026 04:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793274896; bh=qViMHAB2Kt/5NwjHfumEcn0tMJKp0+ZDStMShfsDLVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8KFvowKpOVUFgo6sy3X5C6rFJhaRyJnA25w33Wgx/17gKnukyLRomu1Pf1yI0Iof
	 lcQnpe0Abth0EmgQxlHKa3rA+Kef/8Nq0SM2/MdkIDBqHJb0lHq64HxFrw1tmpcN78
	 kDWC+g8JQgHOjQKJWsPFk6CCDbTnj7J797e+n+f4=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	liuyonglong <liuyonglong@huawei.com>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] KVM: arm64: Enable HAFDBS for guests not on migration
Date: Thu, 29 Oct 2026 11:54:49 +0000
Message-ID: <auM0CWJTPzYUTknh@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <52945586-8c5c-4991-bd92-fe02aaf79fbe@huawei.com>
References: <aqneWnlsdpocLIl6@kernel.org> <aqqhDs3NyjtkZzXK@LeoBrasDK> <aqsl1_IqnV2r8kUL@kernel.org> <aqvt2gnlBZeNsaf4@LeoBrasDK> <as-mH36YSMxAosND@LeoBrasDK> <3e464bef-8dfe-44a3-afea-3c276ae87cd8@huawei.com> <attMtUqxNsuPooix@LeoBrasDK> <8eaaba87-7881-49c4-a76a-51dec2f29ffc@huawei.com> <auCPEQmnFwWldTaM@LeoBrasDK> <52945586-8c5c-4991-bd92-fe02aaf79fbe@huawei.com>
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
Content-Transfer-Encoding: 8bit

On Thu, Oct 29, 2026 at 10:54:24AM +0800, Tian Zheng wrote:
> Hi Leo,
> 
> I've read your discussion with Oliver on DBM RFC v2. As a suggestion,
> maybe we should go with Oliver's approach, i.e. revert to the v1 scheme
> and continue fixing from there.

Hi Tian,
I have been reading a bit more about permission indirection to try figuring 
out a way that the change may work for both ways.

The problem with the previous approach is that it assume DBM=write at all 
times, which is not architecturally correct. Having DBM=write only on 
HAFDBS=on as suggested would require us to transverse the whole pagetable 
to convert encodings when we enable/disable it, which can be quite 
expensive.

One option would be to always enable HAFDBS when system supports HDBSS, but 
I still have to figure out if that causes any performance regression before 
suggesting.

The option I am pursuing is thinking on an unified code path for direct 
permissison (both HACDBS=on and HACDBS=off) so we don't have to convert 
between them, neither worry about the impact of HAFDBS=on on performance. 

I will reply on the thread once I figure one of those options out.

Thanks!
Leo
