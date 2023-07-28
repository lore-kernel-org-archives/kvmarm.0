Received: from out-96.mta1.migadu.com (out-96.mta1.migadu.com [95.215.58.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737D114AB3
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:10:32 +0000 (UTC)
Date: Fri, 28 Jul 2023 17:10:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1690564230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3zA+4nJlOSetPJVXcYxSbHnCnBkBQE+nfqzpGg07rSU=;
	b=DTneeEco3n2i1y/plwh3EzuzVtxBo54D7J9k7Byq8h9hFsn4+coZ3j0lwGeHXLG/TGyLkY
	fBbfj463h6WrLtDeNaGZq0BGRh13O9LfXlU/c4382kq8KltW9nHSye7QKMN0LlGvqq1VTx
	1wV9TVEh1jghHxlq0RjYIRxuvt54CdY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Skip instruction after emulating write to
 TCR_EL1
Message-ID: <ZMP2g29gsg96BshH@linux.dev>
References: <20230728000824.3848025-1-oliver.upton@linux.dev>
 <87h6poqwq1.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h6poqwq1.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 28, 2023 at 09:14:14AM +0100, Marc Zyngier wrote:
> On Fri, 28 Jul 2023 01:08:24 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Whelp, this is embarrassing. Since commit 082fdfd13841 ("KVM: arm64:
> > Prevent guests from enabling HA/HD on Ampere1") KVM traps writes to
> > TCR_EL1 on AmpereOne to work around an erratum in the unadvertised
> > HAFDBS implementation, preventing the guest from enabling the feature.
> > Unfortunately, I failed virtualization 101 when working on that change,
> > and forgot to advance PC after instruction emulation.
> > 
> > Do the right thing and skip the MSR instruction after emulating the
> > write.
> > 
> > Fixes: 082fdfd13841 ("KVM: arm64: Prevent guests from enabling HA/HD on Ampere1")
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> 
> Oh hum... I think it is high time for a new PR to Paolo!

Definitely, now let's sweep this mess under the rug :)

> Acked-by: Marc Zyngier <maz@kernel.org>

Appreciated!

-- 
Thanks,
Oliver
