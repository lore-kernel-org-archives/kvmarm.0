Received: from mta0.migadu.com (out-157.mta0.migadu.com [91.218.175.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8620942C4F3
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 11:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787225417; cv=none; b=PtqGm5PteMKiNli+qhSCNSdD3uhXMpkTjP1dcJMot72QufC2A85MHDwY3CVTewLp+Y7mrFFIVszKyXKHV6U/2yDzceOOT1MtpIVSsmmzKlywWI9r1OwzMCrL9fBzXCX4uhaEdP0gmXyANR2quy70o92bmmPHnkGMGO+wmlKQN8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787225417; c=relaxed/simple;
	bh=OqIF4LDj3J7ikjkeCVzQqcDHvIZZRrdzH89ljTD8g20=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b8+Uy/L7I5jIt8TQPlSRqJyesGsrgSJGHhEu8VvnYTMgcG0Mb9Cfxo6olUzL4YpGWoEYn9UjjJa9rrTnFZX/YqHIQL9XzHHq7AiUD/uvyu2c3ylQJXKnnS0EcXEtuyInJf5VBC3/lUoQNBKfuWT6iK5+GTd5K1RGRBe68RBiiQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sM2czI+s; arc=none smtp.client-ip=91.218.175.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sM2czI+s"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=OqIF4LDj3J7ikjkeCVzQqcDHvIZZRrdzH89ljTD8g20=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787225411; v=1; x=1787830211;
 b=sM2czI+sDbgFDH2CAoUON77zxak4erViTa1xNdlU3N9Zgfk0RL72QlUVCIBxGAWSsfrt01BT
 BFulz7kadpCet7z0XjE/GC9zeaVSOYTjrDayzz/QoauTs+Nbj8B02vgwNO0xT01T/FnYs7BzbXN
 TWfy7MEfNrCZ6yLrjh+1tsRE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f43.google.com (209.85.167.43)
	by smtp.migadu.com with ESMTPS id f872cd100dc54ff5;
	Thu, 20 Aug 2026 11:30:11 +0000
X-Mizu-Trace-ID: f872cd100dc54ff5
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5b0129cf6ffso8597e87.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 04:30:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpUDS7dBoHhNCLmCkygeKtOsdgAq1c9+sVFresVd5iCysbwqA309kuzvnaCxSbw9aQLIqx34xE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0avHAc8Jn/+tjqH5Lmob8vGXuceUg2uldGbIHjF3wdj2dvQhG
	bW1l/XKX1kAUNfW85llgnkvnjK9hcjRRX7hczcppjPYSrP6/z0AUxIKEKkxAgbMqpZIe+zD6/A+
	I3Q6JFaa6XqMuspcaar80E7aG78+fsQCJJ3zETrPZ
X-Received: by 2002:a05:6512:3b88:b0:5a8:6646:d7b4 with SMTP id
 2adb3069b0e04-5b47dd877a7mr146343e87.1.1787225406760; Thu, 20 Aug 2026
 04:30:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260819102809.310708-1-fuad.tabba@linux.dev> <20260819102809.310708-2-fuad.tabba@linux.dev>
 <78d60d96-d0c7-4eaa-b425-ca4f75263b12@redhat.com> <871pbtoz7m.wl-maz@kernel.org>
In-Reply-To: <871pbtoz7m.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 20 Aug 2026 12:29:30 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxbhoa6140-EWQhXXjC=8DZkVSpGDSOYFrhybnQrdcsQQ@mail.gmail.com>
X-Gm-Features: AcwNN1W2LDdE_Byp_W3eAl_A609Io6u9cE21Rn601gKsnfbMx6Lgh7NQOHAxHyg
Message-ID: <CA+EHjTxbhoa6140-EWQhXXjC=8DZkVSpGDSOYFrhybnQrdcsQQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: arm64: vgic-its: Free the caches when GITS_BASER changes
To: Marc Zyngier <maz@kernel.org>
Cc: Eric Auger <eauger@redhat.com>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Will Deacon <will@kernel.org>, Sascha Bischoff <sascha.bischoff@arm.com>, 
	Sebastian Ene <sebastianene@google.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Eric, Marc,

On Thu, 20 Aug 2026 at 11:34, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Eric,
>
> On Thu, 20 Aug 2026 11:09:06 +0100,
> Eric Auger <eauger@redhat.com> wrote:
> >
> > Hi Fuad,
> >
> > On 8/19/26 12:28 PM, Fuad Tabba wrote:
> > > A guest that disables the ITS and re-points or shrinks GITS_BASER<n>
> > > with VALID still set keeps the devices and collections it mapped
> > > against the old table, as KVM frees them only when VALID is cleared.
> > > The table format is not architected, so a write with a different value
> > > is allowed to lose what it describes. Free the list whenever the
> > I don't really get "a write with a different value is allowed to lose
> > what it describes". A write at which place, in the collection table?
>
> A write to the GITS_BASERn register describing the pointer to the
> collection table.
>
> The additional clarification is that because the *content* of the
> table is IMPDEF, if you point the ITS to a different location or size
> in memory, then there is no guarantee that the caches (the KVM
> internal data structures) are up to date. In this case, the proposed
> course of action is to invalidate the caches and start afresh.

My sentence should have said what the write was to. I'll spell it out
in v2 along the lines of your reply.

...

> > One question: There is no vgic_its_invalidate_cache() in the function.
> > Is it OK?
>
> Probably not. We should make sure that the translation cache is gone
> as well so that we retranslate and avoid signalling LPIs that have
> undergone such invalidation. Thanks for spotting this.

I'll add it in v2. The device branch already gets it through
vgic_its_free_device(), but the collection branch doesn't.

Thank you both,
/fuad

> > Besides out of curiosity, why don't we go further and remove ite entries
> > that refer to removed collections in vgic_its_free_collection()?
>
> The current policy is to keep the LPI alive as long as it is
> mapped. The only thing is that we can't signal it, obviously. But it
> would be legal to drop them altogether, only more work.
>
> An additional question is whether we should consider doing a reload of
> the collection table or not. I'm not keen on it, but I can also see
> how a guest could want to do this. Feels a bit over the top though.
>
> Thanks,
>
>         M.
>
> --
> Jazz isn't dead. It just smells funny.
