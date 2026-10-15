Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6634FECE2;
	Thu, 15 Oct 2026 12:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792067576; cv=none; b=f5A/iu04/vOnoLStaVBQXD4UGemGrm38MSIZ7TixD2lislMl6H6Oxo0fgK2fyFPWGQfO29wdWFswlFPA8Db0HZH/Z4sjkKVZzHph4kWClZKVlbWGukUvEVMuvh8AAzmJUYJI2msjhsaU92Tr1HXaMQxGhBVxUFfbx6WxfwEXrVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792067576; c=relaxed/simple;
	bh=kbWlM/FtX2sSNXp+q36DBYwSOxWDhBNofwnAxXb7ACk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=WR+jfa7I2kTT2udB8f9ZKhByGiV2B3ZRdGADITN0qVLN4CkHryrJWwHD8Y+685Myh2NZSC2MXeNL7vIzjWbCUvI6JC2CIpPAZgkdp9mo407acSD+uGFTZgzIIMB8yn165DoKJJzfjY2B4WEKbQsyEaeVGxBRFdOplraQMSRlPi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9tUWqZx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9tUWqZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA731F000C4;
	Thu, 15 Oct 2026 12:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792067575;
	bh=hknBwdOobDFBq9SWOoVzNpEOW9eSZ86xCbruz506nEI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Z9tUWqZx+6+eiXlIF9iF04KadtrsgrXJAbXensNxOYykBfoLlWuAWLHSJkOw0fpV5
	 HHGfNM/BZYVM8LFuQKINe7zUa7TgFV/NU5oy+NY4jWeqGu5NB5NXxpdNYSHJ8uG2Ih
	 cXY1usxM3qDl83rvj83UzaXbouVfgUim8mAUKHFRxCcmSo9m8wXxj1SLDLBCHUPOG8
	 5k+PNqP320ELICm2XXIjawtyB/xoG3wCau4Hse3theA5fWhJtOHxN5djvUEVa+4aTW
	 /JGZ/Mx8MyJNmvcDFaA6chhZn42yPtfMemOgLd1To8Qwi3VjimlfEIxFnQqhnAHBIQ
	 GjM7F6MnU/BOA==
From: Thomas Gleixner <tglx@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Oliver
 Upton <oupton@kernel.org>, Eric Auger <eauger@redhat.com>, Joey Gouly
 <joey.gouly@arm.com>, Steffen
 Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, Sascha
 Bischoff <Sascha.Bischoff@arm.com>, Sebastian Ene
 <sebastianene@google.com>, Yuan Yao <yaoyuan@linux.alibaba.com>, Fuad
 Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] irqchip/gic-v4, KVM: arm64: Fix the vgic init
 error paths
In-Reply-To: <86o6cv1d2n.wl-maz@kernel.org>
References: <20260921072958.2918477-1-fuad.tabba@linux.dev>
 <87wlrje2cx.ffs@fw13> <86o6cv1d2n.wl-maz@kernel.org>
Date: Thu, 15 Oct 2026 14:32:52 +0200
Message-ID: <87qzhrdtzf.ffs@fw13>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Oct 15 2026 at 11:18, Marc Zyngier wrote:
> On Thu, 15 Oct 2026 10:31:58 +0100,
> Thomas Gleixner <tglx@kernel.org> wrote:
>> 
>> On Mon, Sep 21 2026 at 08:29, Fuad Tabba wrote:
>> > Hi folks,
>> >
>> > Changes since v2 [1]:
>> >   - Patch 3: a vgic_v4_init() failure now frees only the SPI array,
>> >     since that function unwinds its own state; the teardown label is
>> >     for the routing failure. (Yuan Yao)
>> >   - Rebased on kvmarm/next, where the routing failure already tears
>> >     down the GICv5 state. Patch 3 moves that into the shared label, so
>> >     the SPI array is freed on that path too.
>> >   - Collected Reviewed-by from Yuan Yao on patches 1 and 2. (thanks!)
>> >
>> > Four fixes on the paths that run when vgic init fails partway. Each one
>> > needs an allocation failure to reach.
>> 
>> Marc?
>
> I was about to say that I had already queued that, except that it
> appears it only happened in my head, and nowhere else... :-(
>
> If that's OK with you, I'll queue (for real!) the whole thing via the
> kvmarm tree, targeting 7.4-rc1.

Ack
