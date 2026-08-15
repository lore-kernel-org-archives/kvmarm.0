Received: from mta0.migadu.com (out-207.mta0.migadu.com [91.218.175.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F59119CC14
	for <kvmarm@lists.linux.dev>; Sat, 15 Aug 2026 00:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786753129; cv=none; b=RNxFmXKZKCUY0MA6uo0bRIIqicU2A/bNpfkIn8blNimr4lsLeey0mvMq4k5vGIDNYctZjai98fxJ8NuaYIwpWDHRXuze+zvwdjETd3fVuJAZ++q3Ni0rjK8woYy25J7vJAeNr02nFTpfBvzK5ebQGLaonX0vfYXp8O3HEwu3UGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786753129; c=relaxed/simple;
	bh=HlDIpqm069G70cSVX9IpKdU7viVskBXwDZemew5s+u8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AzTJdwul24l6OxDKBdpRNcrKvdoVeiuZCFuQCyD8DFJ2or4vF/1aRLgU/1bPt9EQ+Lk68f5BmdHRFVk8DLriZUMbl1tnk3Z8OQrUpAueoWsyVvQvbl/FGMvLGGtfJb6fFyRuGj1A5MgbgYUZddfcvrlYgNVPYBOw4lmttJ2aCgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=juemGM2B; arc=none smtp.client-ip=91.218.175.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="juemGM2B"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=HlDIpqm069G70cSVX9IpKdU7viVskBXwDZemew5s+u8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786753124; v=1; x=1787357924;
 b=juemGM2BiH5nTi4UHj0Kn2xc9ppBvnrEbKyCYnHU+jBvmYz1JnwlCK1SHyzUR9A+0h9l9kR5
 K6Z7Hpt5DbHfcCa6UzcdHVPjE9AmOTOUJgWcO1Oo/xbkBcc6ZgV9Hm7lo0jQzs5ykOaHswEJJVQ
 L9BJUDfSHAQ3Rq1hPRDameBU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f46.google.com (209.85.167.46)
	by smtp.migadu.com with ESMTPS id 39b4c4eb57857335;
	Sat, 15 Aug 2026 00:18:44 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so15010e87.0
        for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 17:18:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpavhwCbmXMOpMXE1UvFvaxz5bf6L7bnV6Ta7KfhDJSrt2uhm97eaUyoVYgFOa+iUMpHIp1Mmc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVKzUPwynd8nZgHQyp2lP5TaFmOOjf1ZnRELpmTay4xUavW/2M
	/Yvk3edBbTi+v/v5lrDPqyDrwpYvxDlYlR2D6/jxVv1M07tvaQODQYp660K3Me0euOhu/Byk0SB
	auel8cCMyUhxkLdsW5fQiSBu4VHephI+Brw72QNJQ
X-Received: by 2002:a05:6512:1092:b0:5ae:a4e8:47be with SMTP id
 2adb3069b0e04-5b45975c815mr305656e87.7.1786753119575; Fri, 14 Aug 2026
 17:18:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260807104102.2410744-1-fuad.tabba@linux.dev>
 <20260807104102.2410744-2-fuad.tabba@linux.dev> <0ce5e496-a067-48fd-80d2-94fe9981d505@redhat.com>
In-Reply-To: <0ce5e496-a067-48fd-80d2-94fe9981d505@redhat.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sat, 15 Aug 2026 02:18:03 +0200
X-Gmail-Original-Message-ID: <CA+EHjTzsCgBbaJQpv1ne-0Xo_3wdwv-R1RWMabdLxiMjMh4peA@mail.gmail.com>
X-Gm-Features: AUfX_mxLSNC5ubSrnmPIZs7wo8JAHvSfgoxf3yq_YIzru-oTtZpAGPxeJWhZIZ0
Message-ID: <CA+EHjTzsCgBbaJQpv1ne-0Xo_3wdwv-R1RWMabdLxiMjMh4peA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: vgic-its: Don't dereference a NULL
 collection on ITT save
To: Eric Auger <eauger@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Sascha Bischoff <sascha.bischoff@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Fri, 14 Aug 2026 at 14:36, Eric Auger <eauger@redhat.com> wrote:
>
> Hi Fuad,
>
> On 8/7/26 12:40 PM, Fuad Tabba wrote:
> > MAPC with V=0 drops ite->collection but leaves the ITE on the device's
> > ITT list, and vgic_its_save_ite() dereferences it unconditionally. A
> > guest that issues MAPD, MAPTI and then MAPC(V=0) therefore oopses the
> > host when the VMM issues KVM_DEV_ARM_ITS_SAVE_TABLES to migrate it.
> Thank you for fixing this bug!
> > That sequence is UNPREDICTABLE per the architecture, but KVM already
> > handles the resulting state in the translate, MOVI and DISCARD paths.
> Maybe: "its_is_collection_mapped() already checks the collection is non
> null in translate, movi and discard"

Agreed, that's more accurate. This went into kvmarm/next on the 8th
[1], so it's the comment rather than the commit message I can still
fix.

...

> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > index 36ab3e4929154..ed281fbf008b9 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -2119,6 +2119,14 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
> >       u32 next_offset;
> >       u64 val;
> >
> > +     /*
> > +      * MAPC with V=0 keeps the ITEs mapped but drops their collection,
> > +      * and with it the ICID. Save a zeroed entry, which the restore path
> > +      * reads back as invalid.
> in
>
> https://lore.kernel.org/all/CA+EHjTymdanCKoQO3ATmUZ=7Ph2wv4ES8SfkSsTgmOYAYBWayQ@mail.gmail.com/
>
> you also mentionned this can also happen on clearing
> GITS_BASER<coll>.Valid clear. So maybe don't specifically focus on MAPC
> in in the comment.

Yes, and the BASER case is the one that justifies the check: MAPC(V=0)
is UNPREDICTABLE, so it could be answered by dropping the ITEs, while
clearing GITS_BASER<coll>.Valid on a disabled ITS cannot. The comment
names only the case that doesn't. I'll send a patch on top to reword
it.

>
>
> > +      */
> > +     if (!ite->collection)
> > +             return vgic_its_write_entry_lock(its, gpa, 0ULL, ite);
> I would rather squash 4/4 here to emphasize we are unlinking that entry
> from the scan chain.

1/4 has Cc: stable and 4/4 isn't a fix, so I kept them apart. 4/4
doesn't make the write unnecessary either: an orphaned ITE with no
valid predecessor is read directly, regardless of the offsets.

> Besides I also wonder if we should directly remove those entries from
> the &device->itt_head on MAPC and GITS_BASER<coll>.Valid reset.

For MAPC(V=0) I think it works, and it would stop the event slot being
wedged: an orphaned ITE today can't be DISCARD-ed or remapped with
MAPTI. But the ITT entry has to be zeroed with it, the way DISCARD
does, or an earlier save's entry stays in the slot and restore fails
find_collection() on the destination. Oliver suggested the same on v1
[2].

That pairing is what makes me doubt the BASER reset. There we would be
zeroing every ITE of every mapped device from the GITS_BASER write
handler, which is an unbounded number of guest memory writes on a
register access, and unlike MAPC(V=0) that write isn't UNPREDICTABLE
to begin with.

Cheers,
/fuad

[1] https://lore.kernel.org/all/178621413198.380376.1272590130654213471.b4-ty@kernel.org/
[2] https://lore.kernel.org/all/anQQ3dcbk72N1g1a@kernel.org/

> Thanks
>
> Eric>   next_offset = compute_next_eventid_offset(&dev->itt_head, ite);
> >       val = ((u64)next_offset << KVM_ITS_ITE_NEXT_SHIFT) |
> >              ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
>
