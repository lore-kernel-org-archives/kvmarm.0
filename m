Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E4C1DA614
	for <kvmarm@lists.linux.dev>; Tue, 26 Nov 2024 18:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732646941; cv=none; b=fXPoloiJ1mpQ0rEYqpD/1AxRum4g7uXCFW29h8skf3vnvlSIemoQS36fiGmLzPDLSyqPcm9rmY1pvRkhapJZfa86zcNw3DkxlTyUzKx4NhHA346TNqvMQjwYfpl/HsLZ8tq3rFPzlKDxsxFEgUBHPo1cOEU3+jK035SaGv852jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732646941; c=relaxed/simple;
	bh=eO7Yjw7pts8z1wlkVCi2gFG4+/XhY9dI85zQzEL0dIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dt7zV6D+WLkmM+ZKuBMQIZqpVCopwkJNXNh1uuvxG7SAHJWeics6w+7v2nqjPAsgA8bgFmtNVIdjGEztYb/4cIP2abHl+FmgKFQs3XkbesoVFfaGxuhQM+cg+I2na2gLuZeincUPrDM/VdOlv9Z4rmyZW+vKTqr0lNSkFY9sBrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L4/aYIeq; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L4/aYIeq"
Date: Tue, 26 Nov 2024 10:48:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732646936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ToEmNiBbhN5F/yjkx/YHq03WfxPjrJ7SieRa4FeLMBs=;
	b=L4/aYIeqWZUgwP8whOq9QGeoy4pNVidemMixAv6nZOlhild0Wre4/bBQIc5VeQigkiArVi
	8h7bFgbTSzWEIETs5dCZdCyUQMCK9vg9JutUo9YuEIldao2+2rIbEBbJhCB2eqca0kQ5Pb
	oBLUVmzdt5NDvOO5m9YOWXVTAjpBJ2s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm64: Fix S1/S2 combination when FWB==1 and S2 has
 Device memory type
Message-ID: <Z0YYEmeJhpJ2PaWf@linux.dev>
References: <20241125094756.609590-1-maz@kernel.org>
 <Z0XoxGSWRCjbTFie@linux.dev>
 <86ed2yufdz.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ed2yufdz.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 26, 2024 at 04:30:16PM +0000, Marc Zyngier wrote:
> On Tue, 26 Nov 2024 15:27:00 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Mon, Nov 25, 2024 at 09:47:56AM +0000, Marc Zyngier wrote:
> > > The G.a revision of the ARM ARM had it pretty clear that HCR_EL2.FWB
> > > had no influence on "The way that stage 1 memory types and attributes
> > > are combined with stage 2 Device type and attributes." (D5.5.5).
> > > 
> > > However, this wording was lost in further revisions of the architecture.
> > > 
> > > Restore the intended behaviour, which is to take the strongest memory
> > > type of S1 and S2 in this case, as if FWB was 0. The specification is
> > > being fixed accordingly.
> > 
> > Since you're already asking for a spec fix, could you mention that the
> > column headers in DDI0487K.a Table D8-95 are incorrect? MemAttr[1:0] is
> > used twice, although I believe the first column is actually MemAttr[3:2].
> 
> That one has already been fixed as D22366, as described in the Known
> Issues document for version K.a (issue 07) [1].

Ah, right on. Thanks!

-- 
Best,
Oliver
