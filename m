Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793816862;
	b=14j9fynTu/TRxrjHZvH7WWFVD8+l+246sIgDHHbqPAiF7uLhaUcBfHDOtViWvrxhoKES
	 O/uaZKvSrIHhUPAwe59IQz52eSTJ5HMpsOYrvGqqp2vYwXFxMdx3d+CJ+K5PNmYRr9/BN
	 Y7qGvoz5KCCeeDUYtdxzHYb3B2LK+kQNNaRYc5hkqmO26XyamcavmAhG2+6AYEYTb8Wg7
	 0TjFdjPMXhttttSk4o8yDTAChtjl2vuIzotVgCj2zd6ETguaxMTN8Vj+Q0jng64qjZJhp
	 RNk4aaTI37iqOWv+HcT6v83vC67yWERdr3hRamEKOzj4brLBiZXr753On6yd/ybvomQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793816862;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=Rz5+9rBZ11rvSb1aMAFDb3teQDHBLOGre5kK2wU24yU=;
	b=KJt4RPA4H8jCyH0388fSxMaIAeB44C5WsvCLgsDge/9KkhrdZAN5REYVzk0qO7xFY5Kt
	 /w0G7v17CFqWmLW8K80CWHOW2aYQvejS+UQJ/iwUtXgi+MlRhGpxrtCy1HN+C55zh9zqe
	 bBkNCZ+Z8WHd7QjajKGbNRw3er3LO1zczAipLQkdrsMhwoE/AGrxEFse66TjRGtpCDM03
	 Zx7taaUEu72xCRXKDFXKcW4ZmUje98cHqO+bdE8kpqciV99bfjsRJYtWP5bsbznu003Hb
	 cZ5CV2ux4HKZcxJW5rXQJ6vKqHdeX7SloUEVGZ/Q2xbappfpgbmACbgDS6GLroGYdYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=QJqA7j1U;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA2BE606A331
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 18:27:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA2BE606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=QJqA7j1U
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 821171BB0;
	Wed,  4 Nov 2026 10:27:36 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A5B03F632;
	Wed,  4 Nov 2026 10:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793816859; bh=Qbiq4ldPj2ZF9qQEwEyqmOBl3UJZY/6wX4dZHg8docY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJqA7j1UF0rsURkYrFytNvEeG66/0TVXGet+L1IQK29fkDhKf0opWUdgb82Lhxs79
	 0JOcu8CyJZde4sZXIpycQ7vYwJfTBKZNZ/WAKK/uSIehq1PMkSHwgFNPKpX/agdJO3
	 MdLFku7eVqqOVnXFX2gPMVFx7fcD2KKMEb2weUis=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2 18/28] KVM: arm64: nv: Emulate CMOs via writable-clean translations as NOPs
Date: Wed,  4 Nov 2026 18:27:35 +0000
Message-ID: <aut5F2V0glbJv6ys@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <autzno1eEpw4X-0I@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org> <20261023205610.1044532-19-oupton@kernel.org> <autJUntFMhCoqZeH@LeoBrasDK> <autp0cVkXwvSXPGC@kernel.org> <autrOLZWT-s4Ailc@LeoBrasDK> <autzno1eEpw4X-0I@kernel.org>
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

On Wed, Nov 04, 2026 at 10:04:14AM -0800, Oliver Upton wrote:
> On Wed, Nov 04, 2026 at 05:28:24PM +0000, Leonardo Bras wrote:
> > > The writable-clean state is nonexistent when VTCR_EL2.HD=0 in the direct
> > > permission model. So we have no way to construct a translation in the
> > > stage-2 that satisfies our requirements.
> > 
> > Since other vcpus will have VTCR_EL2.HD=0, couldn't we enable it just for 
> > the sake of processing this CMO?
> > 
> > I guess it would need to either decode the instruction or single-step this 
> > vcpu just to make sure it does not write to the same page we just did mark 
> > WC.
> > 
> > > 
> > > The other way to do this would likely involve halting all vCPUs in the
> > > VM and attempting to single-step which has a near 100% chance of blowing
> > > up in our face.
> > 
> > Sorry, why all vCPUs?
> > 
> > I know for all vCPUs it would be terrible for performance, what else 
> > do you mean by "blowing up in our face"? 
> 
> In order to make this work, you need to guarantee that there's no
> concurrent updates to either the instruction itself of the stage-1
> translation.

Oh, wait. We have to be worried about an instruciton changing while the 
vcpu is running on them? wow
(What would happen if the instruction changed while we were running?)

Well, stage1 changing could be prevented by some existing lock, but maybe 
that's weird to access from kvm code.

> 
> The operations would be, approximately:
> 
>  - Take a stage-2 permission fault on the cache maintenance instruction.
>    Walk the guest's stage-2 and find a translation in writable-clean
>    state.
> 
>  - Pause the VM, re-enter the guest and single-step the instruction. If
>    we take the debug exception then the guest must've changed the
>    instruction. Go back to base state.

Pausing the VM would be required so other vcpu treads do not access the 
page we are trying to run CMO on, right? 

> 
>  - If we take another stage-2 permission fault for a cache maintenance
>    instruction, temporarily promote the translation to RW in the shadow
>    stage-2 and re-enter with single-step enabled.
> 
>  - Take the debug exception, invalidate the shadow stage-2 translation,
>    disarm single-step, restart the VM.
> 
> The transient RW mappings seems ripe for pretty nasty bugs.

Ah, right, other running vcpus could write to it while it's RW if we don't 
pause the whole VM. Yeah, makes sense to me now, would be horrible.


Thanks for helping me understand!
Leo
