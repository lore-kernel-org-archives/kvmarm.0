Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B436D3DD51A
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 07:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786002170; cv=none; b=mupyTuXeaHYZvAbvFOikCLGmtTvy6I6xo1i4b5fY4nxJaTIdHZ5a7BTpKjWYYTzefuUgd/Vk4Sn7Zimh/a21rI9Pe6p/Od83yeONh+SzgGZQZhdzBm4tslD7kgxIKLv3xLm5/MBHNWvKQAkIOROUvI2eRaIOMCPQZnT+d0lUVg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786002170; c=relaxed/simple;
	bh=dwm8jGpgcLXQCj8AgQtV8L7yV8o4yLJL6/HCrudquBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JBla9Hnx/vZ/M69xN0HRD3ZyaKthVOmgEwm9W+X34OIvleU+LmNL4hVi7i4hAA230zYVeZKsdYffLL5nx5DDTkncaCiHNzRWHUifEUYf/GYKWF2Gm5Ji2e6M9NCejvVeTTjphYbTogrwlffqhxqQ0Ksjv7AAOGXq7XZ9rQsFSKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=amo7V2rw; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="amo7V2rw"
X-Forwarded-Encrypted: i=1; AHgh+RqO4TdZE9tu/2E5vstSH4CGWN4jB5CcfECOzNz4RmIyi6FoRhUUK4LZXRFk/i9G/ImvyyaI9DU=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786002165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s5mDgbwvY3SqOuoz1jd042jQGZrilknm7rjQphy+tiA=;
	b=amo7V2rwZHPCteW3v2mKaIqlrusOMtZqibwQXMYLLlN08MldU0Pm1Q9MInxmi6PV+ijJKU
	UDzL588VeK66sG4j2Fax/PN5eroc1SW07CteLnAV6xCXq8U0/V1nfQayEuY3mht/KjZMI2
	V0CAW6Lk34R+36RJuSSivev9qU+JHlw=
X-Gm-Message-State: AOJu0YwuoJt8jV6VnWQploH8f1kUGNPyg1fmNyMApjFK0S9uL0fOohnz
	g9mMkdAjwa1brntpK5DMqM9jTGmkqYXb0QGEy8z4J7zACE7TUk19wheAQRvAzvgKjJQJU+l2ASB
	6orFlHITN9xtK3SF/XVvTtA3pa27bhdOQiiniaHKc
X-Received: by 2002:ac8:7c4c:0:b0:517:5d71:84e5 with SMTP id
 d75a77b69052e-52cfea0149dmr8214081cf.5.1786002153058; Thu, 06 Aug 2026
 00:42:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260805093828.3626610-1-fuad.tabba@linux.dev>
 <20260805093828.3626610-2-fuad.tabba@linux.dev> <anQQ3dcbk72N1g1a@kernel.org>
In-Reply-To: <anQQ3dcbk72N1g1a@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 6 Aug 2026 08:41:56 +0100
X-Gmail-Original-Message-ID: <CA+EHjTymdanCKoQO3ATmUZ=7Ph2wv4ES8SfkSsTgmOYAYBWayQ@mail.gmail.com>
X-Gm-Features: AUfX_myxDlOAjmYWKzMHR0N2hwA_2mNGaJp6De5XS0c3Q0cWjlphcGHmt0zum28
Message-ID: <CA+EHjTymdanCKoQO3ATmUZ=7Ph2wv4ES8SfkSsTgmOYAYBWayQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: vgic-its: Don't dereference a NULL
 collection on ITT save
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Sascha Bischoff <sascha.bischoff@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Oliver,

On Thu, 6 Aug 2026 at 05:43, Oliver Upton <oupton@kernel.org> wrote:
>
> Hi Fuad,
>
> Thanks for fixing this.
>
> On Wed, Aug 05, 2026 at 10:38:26AM +0100, Fuad Tabba wrote:
> > @@ -2119,6 +2119,14 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
> >       u32 next_offset;
> >       u64 val;
> >
> > +     /*
> > +      * MAPC with V=0 keeps the ITEs mapped but drops their collection,
> > +      * and with it the ICID. Save a zeroed entry, which the restore path
> > +      * reads back as invalid.
> > +      */
> > +     if (!ite->collection)
> > +             return vgic_its_write_entry_lock(its, gpa, 0ULL, ite);
> > +
>
> Writing a zero entry results in a suboptimal scan on the target,
> compute_next_eventid_offset() should just skip ITEs that are known
> invalid.

Agreed, I can do that on top on the respin (I still owe Sashiko one
for patch 3/3 [1]). The predecessor's next_offset still points at the
zeroed slot today, so the restore crawls from there to the next valid
ITE.

I don't think it replaces the write, though. Restore starts at event 0
and walks forward until it finds a valid entry, so an orphaned ITE at
or before that point is read directly, with no predecessor to skip it.
Leave the slot alone and an earlier save's entry is still sitting in
it: restore fails find_collection() and the migration dies with
-EINVAL on the destination. Zeroing is what DISCARD already does.

> Or better yet, we should just make the ITS emulation consistent
> with the migration behavior and delete ITEs when their corresponding
> collection is deleted. As you note, this is UNPRED after all :)

Happy to do that for MAPC(V=0), but I think it might not remove the
need for the check. vgic_its_free_collection() has a second caller:
with the ITS disabled, clearing GITS_BASER<coll>.Valid frees every
collection through vgic_its_free_collection_list() and NULLs
ite->collection, while the device list and the ITTs survive and
vgic_its_save_device_tables() only looks at the device BASER. I have a
selftest that oopses in vgic_its_save_ite() that way, with no MAPC in
it. And that one isn't UNPRED, so I'm not sure we can answer it by
deleting ITEs and zeroing their ITTs.

Cheers,
/fuad

[1] https://lore.kernel.org/all/CA+EHjTxuYLBwNsDnZd4B_jYWBDvGxXMWSDKPiMqjJjdCMYySaw@mail.gmail.com/

>
> Thanks,
> Oliver
