Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793361074;
	b=GdQhi+UUcgNm5xm3h6j5uwgQZsjZfyc2Btt8zzz+oJz4qPUtdiTJhI//PS1UX+oDW5gM
	 FxIkKI30nNdFRqZCn5XvfnCcHsv/TGNfCkdZmu3G7ADucByfw6iySWLFWYHlFptL48Dz0
	 BVWcNZKa+20Kr09L3ACyyDXbnvKDKToZrxGH06wj7g2ZG1HqGPpJDsKTO65opKDTMbkC3
	 KpMjHpWkR1ToqeXkQJgSmpZge7cvG70UMa5Shgf2NBor1EdzG+v3Js0BNvzoBNmF5D59a
	 yjNwoXm1ou93cZcL8e7p9t1fNVaEfty3dGbHOEnYeLoDoKqV1lIo56a1/nLZRUxDAGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793361074;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=EV9q3xMYUg7eyUdptCPQkT+NInqEVi2Bft0i/3u9pWc=;
	b=hvg59mwm0qXleBFVL5DxzShWq8AEctBQCNELmQUq1+uQMj1cbGcQZnQJbkbNvp5NDQn8
	 CuM94wz3TmZ3zP9W35bGd9gKMuraPNzKbtF/VThtIWHiggU4KT3LTKPYk3jN9xWK+Upfy
	 PaKAsiEFR33FIrdcWEnV0+fzqP3MWNZ08VLbVzZ+Bt4t2DHbl8GLIlgie0ef5GwP0K5LF
	 eAtARjYnG3wG3kI4wqe4a8JIbdg2YlAhlUqXZnCHb7qWoYlM8AvHERSGECRBrVCfirS2h
	 QRdO42KuIgQjdcPGqCf5hUqsbnfZoXV+hiKGgMG6fSjpVkjl9V5lbp3MYmBSbGO4XDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=lhbs403c;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D212606A31C
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 11:51:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D212606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=lhbs403c
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A79E1682;
	Fri, 30 Oct 2026 04:51:10 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A3AE73F7B4;
	Fri, 30 Oct 2026 04:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793361073; bh=Mc3ZxWgjpeC+0tTsnex0ZyBfJ8y4oR4Ncako7tOwxzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhbs403ceP0i6J8ZnKQpDhpeznmarJmBUeflvdmtHnlB2nPAIKDzzcVGkjSj9dQ7W
	 vtYBO7rtqa2fVQpvzW5QK31u40tMnW4Jc2IGyVrESGNTwnIebruQEJnQGn+OPTDhPw
	 Gf2ge37yfRyKGQJ5KxdYYDrHf/8gyFWRm3p7HOp4=
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
	linux-kernel@vger.kernel.org,
	Zhou Wang <wangzhou1@hisilicon.com>
Subject: Re: [RFC PATCH 5/5] KVM: arm64: Enable HAFDBS for guests not on migration
Date: Fri, 30 Oct 2026 11:51:08 +0000
Message-ID: <auSErGzYpiTxgsgb@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <b8f76a0a-8b1e-4167-81cc-b3a4ee79fb6b@huawei.com>
References: <aqsl1_IqnV2r8kUL@kernel.org> <aqvt2gnlBZeNsaf4@LeoBrasDK> <as-mH36YSMxAosND@LeoBrasDK> <3e464bef-8dfe-44a3-afea-3c276ae87cd8@huawei.com> <attMtUqxNsuPooix@LeoBrasDK> <8eaaba87-7881-49c4-a76a-51dec2f29ffc@huawei.com> <auCPEQmnFwWldTaM@LeoBrasDK> <52945586-8c5c-4991-bd92-fe02aaf79fbe@huawei.com> <auM0CWJTPzYUTknh@LeoBrasDK> <b8f76a0a-8b1e-4167-81cc-b3a4ee79fb6b@huawei.com>
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

On Fri, Oct 30, 2026 at 02:01:49PM +0800, Tian Zheng wrote:
> 
> 
> On 10/29/2026 7:54 PM, Leonardo Bras wrote:
> > On Thu, Oct 29, 2026 at 10:54:24AM +0800, Tian Zheng wrote:
> > > Hi Leo,
> > > 
> > > I've read your discussion with Oliver on DBM RFC v2. As a suggestion,
> > > maybe we should go with Oliver's approach, i.e. revert to the v1 scheme
> > > and continue fixing from there.
> > 
> > Hi Tian,
> > I have been reading a bit more about permission indirection to try figuring
> > out a way that the change may work for both ways.
> > 
> > The problem with the previous approach is that it assume DBM=write at all
> > times, which is not architecturally correct. Having DBM=write only on
> > HAFDBS=on as suggested would require us to transverse the whole pagetable
> > to convert encodings when we enable/disable it, which can be quite
> > expensive.
> > 
> > One option would be to always enable HAFDBS when system supports HDBSS, but
> > I still have to figure out if that causes any performance regression before
> > suggesting.
> > 
> > The option I am pursuing is thinking on an unified code path for direct
> > permissison (both HACDBS=on and HACDBS=off) so we don't have to convert
> > between them, neither worry about the impact of HAFDBS=on on performance.
> > 
> > I will reply on the thread once I figure one of those options out.
> > 
> > Thanks!
> > Leo
> 
> Hi Leo,
> 
> Sounds good. I'll wait for your next version and review it once it's
> posted.
> 
> Thanks,
> Tian

Awesome, thanks!
Leo
