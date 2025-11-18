Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1513835F8D4
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 13:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763474395; cv=none; b=uuItcedA5f/0rydlhaM16ybuoy/2jNUwwpoIZn0oWm86q54JfQkWCnX/7WakuXuNiigMHQU0OqJZeHoZ1XJz1nw71HZtbF5HSEiFm9SLax0Nci0t0NAYLZD8/uIRfR7sHdNFGHGINBmWU/yE4hwFNGgIHhEAIw1WSqAiK/S68Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763474395; c=relaxed/simple;
	bh=a4l6UmF6YkipJmQfu6Xj5itRRy/apLU9qhpssM5sf3Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UX0KQ0QZnBm8OrWUGSM/0KpkHSMKGVqyqSNzPPj15jQ1rhCRKZ5F+pBGMwnhk78JZhg+nZ8687oqhvnGTk37ySXNpvhPbEd6QBA5aB9/pddZwYx5Kkw5ph3TYad7HeUrf5jlfjL1K2anta67++njr0oQ2UnvPDOvbwn4WQbbdXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3MQMSvgq; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3MQMSvgq"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ed67a143c5so312621cf.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 05:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763474392; x=1764079192; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R2GwSQ++DitICmTZEwHDVEkQZZItGNz+IuoJwTCHLm0=;
        b=3MQMSvgqsexK6m9IQHniUo++65ywrBDhmYSUPKJP+IjQQ0vcciMfF9QyjBiKsZNYjM
         ZwCsJtnkE9IdiAUr82L5wABNtitzv3rre8R75F3rpQtX0lc9qSHhEteHRZ5SOwue+hQw
         BT6qFU3ZmARG8ydS6BZA857C7I4RgHAZrjRREV52NelfbY+2vT30rXFdLF6smvkFPLWa
         I+sbM3oRoYgznDO+1WNYPgiOHfCvRg3JNX+Wl+SV7sQ9nCJmP16KO6QmeVzWRl3u6Dsu
         PggyP689g9NWApipGK2gYuQ9poldoOJvHXulDV2GRi9ElVBkOJyNCzvF/pL7LSWaK7ow
         bQjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763474392; x=1764079192;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2GwSQ++DitICmTZEwHDVEkQZZItGNz+IuoJwTCHLm0=;
        b=I9CJXyu/g39lueN7VbxjAltzw4umq7f48AT61Gwb77C0XqXB/Sfl5NiwfGY1Ue7GtE
         eMltCclhbaGt0+4LRV1YUY1ENApRS7Ceo1ViAYENizS1S1GjP30CaHMUsdm/r+UgmJ42
         y3cjNBWKx0apjhHSi/lFNG2sYKCnSn7Zo+GvOgc/5bX6jrMuBXhiTZRkpRWxiKy7yXti
         otNS0hB0fc8XjOJO7X26XNWq/Z3Z38aZMiGczNLEKCOQib1rVfXthdwPh0sji5cFALqU
         fwQpcprzcA1yd5J4LnQN0KrsZPG8p0RGccwVCllz+PZA1Rwm3N9A91wpvx3DAc5sjA29
         maMA==
X-Forwarded-Encrypted: i=1; AJvYcCXa4NpuowYclFLO6gfA3KGfZIbIdAQNvNsXkKNIFdDn/+3+jBaJJe3uzijcANYw2gZcCXlsyXE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTuMnk/eTs7OWcmY1Y8m18dbMGaqk8XgzR2ERoIVAmAsSeqAbZ
	/vpBMjoyOQ9in0/z71/tnfSMAmExCnBgxLjaRp1I/8O6ZF4VTUa5jWM4N0RzATQcSkxjeNuHIwL
	/iod8sg5s1dM2TcXPGpKiDo11vTiBOd4SHwqUWrYB
X-Gm-Gg: ASbGncvZQE+sayXyfiXWkyREGO3vz9XrLn/h4n9iFm2rv68AygQq7s0jQKIKpZmDJ9H
	nEcps9C2QPdNVSxmMefSRNOwF//jsa1vul5E7xg9nPhHHVsRVFmkNi1/dhzVLQJEatO0jTxNneY
	n6oXMlUAlepENDbLryhFA34EkuNtE1HE6cqEZSOdyHhRe51AEX9YgYpRYnM3Xkn24SpEHzMTbOA
	qhXqoTdap+62U9/1s4jZQyhP5EiX8LlxZUL6k3yfPwjSb/fqZl6UNybrQE4KPzg4hiqxWQSAXD2
	nvPP4m+tLNI1TLS2Pgr7qWJ5
X-Google-Smtp-Source: AGHT+IHCyANdQgsaiOtaga2HnBxQXXGPzcCZ4Ohf00BEMrBIOJ7VpUX3rg5vryaN2JUlMoGY94TIkE6SWzKp36uqz+s=
X-Received: by 2002:a05:622a:1455:b0:4b2:ecb6:e6dd with SMTP id
 d75a77b69052e-4ee37321ee7mr2670321cf.1.1763474391448; Tue, 18 Nov 2025
 05:59:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <aRweUM4O71ecPvVr@kernel.org>
In-Reply-To: <aRweUM4O71ecPvVr@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 18 Nov 2025 13:59:14 +0000
X-Gm-Features: AWmQ_bkF-6pn3IYOEpn92xj1HYWHcPhO6SZ_J8WYU-pS4TiyeHoHMyN4vCkYXBs
Message-ID: <CA+EHjTzJQOTTSUoXVKpGdWO8vz9Vc-2AL3zRyzG4DkUPz+wBBQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] KVM: arm64: Add LR overflow infrastructure (the
 dregs, the bad and the ugly)
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 18 Nov 2025 at 07:20, Oliver Upton <oupton@kernel.org> wrote:
>
> On Mon, Nov 17, 2025 at 09:15:22AM +0000, Marc Zyngier wrote:
> > This is a follow-up to the original series [1] (and fixes [2][3])
> > with a bunch of bug-fixes and improvements. At least one patch has
> > already been posted, but I thought I might repost it as part of a
> > series, since I accumulated more stuff:
> >
> > - The first patch addresses Mark's observation that the no-vgic-v3
> >   test has been broken once more. At some point, we'll have to retire
> >   that functionality, because even if we keep fixing the SR handling,
> >   nobody tests the actual interrupt state exposure to userspace, which
> >   I'm pretty sure has badly been broken for at least 5 years.
> >
> > - The second one addresses a report from Fuad that on QEMU,
> >   ICH_HCR_EL2.TDIR traps ICC_DIR_EL1 on top of ICV_DIR_EL1, leading to
> >   the host exploding on deactivating an interrupt. This behaviour is
> >   allowed by the spec, so make sure we clear all trap bits
> >
> > - Running vgic_irq in an L1 guest (the test being an L2) results in a
> >   MI storm on the host, as the state synchronisation is done at the
> >   wrong place, much like it was on the non-NV path before it was
> >   reworked. Apply the same methods to the NV code, and enjoy much
> >   better MI emulation, now tested all the way into an L3.
> >
> > - Nuke a small leftover from previous rework.
> >
> > - Force a read-back of ICH_MISR_EL2 when disabling the vgic, so that
> >   the trap prevents too many spurious MIs in an L1 guest, as the write
> >   to ICH_HCR_EL2 does exactly nothing on its own when running under
> >   FEAT_NV2.
> >
> > Oliver: this is starting to be a large series of fixes on top of the
> > existing series, plus the two patches you have already added. I'd be
> > happy to respin a full v4 with the fixes squashed into their original
> > patches. On the other hand, if you want to see the history in its full
> > glory, that also works for me.
>
> I'll pick up these patches in a moment but at this point I'd prefer a
> clean history. Plan is to send out the 6.19 pull sometime next week so
> any time before then would be great for v4.

I'm happy to take that for another spin Marc before you send it, if
it's different from the ToT I tested. In that case, just send me a
pointer to the branch.

Cheers,
/fuad

> Thanks for ironing out all the quirks :)
>
> Best,
> Oliver
