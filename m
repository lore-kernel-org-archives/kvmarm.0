Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3DF73446
	for <kvmarm@lists.linux.dev>; Fri, 29 Nov 2024 15:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732893042; cv=none; b=mKA7VlIh3YP0MVOMQNfvss9MJ7aocbty2oqNHfu3mCKU4FvHzrzAeoWkAeDT+ew0BKu5f2KipfXxzY4IAfc7DXbr2Swg+O8Okv5FWDPJDY+9WyvmQIK9cMqg+H5Ls+zufE5fcIU4azD7zt8kaSxLfM4rN2zobChR0RvvrCBGc/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732893042; c=relaxed/simple;
	bh=3wQ96THql2seorF+HB+Vi2pvuEedh6Kpydso5NHG1+g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jU9pb6c0ElI6hifz9w3Q1h6ghVbJvcojr7MwJe8VG/P0yufmWGRXM/tp8ytQA8OCNln+DenpDKGczzk+91CjbwS51gTjPAYchsCLvS14D+5P+JbTVc76tJh37MvZnLJgTrRExLIAC/N4a2xRYjUXOH+OS9B3PmlNp5X2wdPw18k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NMF0QYB+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NMF0QYB+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732893039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fSyJcMTVp+SmKM3QylQZyVp/qDUGBvFM5wftYV/Cb7E=;
	b=NMF0QYB+iax//ckM2z6YhlwH4zmBnqGolGWnN+WlfhPqG0OJCm5pyNO+Git9g3L2V2SaEN
	zgE6ikhmgGOIX+JLrf5KGBeYAQivnmndliw2tSIBT1BpPed+LpmTRMPKijD/e0VFmv4UwD
	3VVMVAoDGOU88KOw2IGz2KOZO92Q/ek=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-499-pebAgQsZPM6jKHQLKh7dWw-1; Fri,
 29 Nov 2024 10:10:33 -0500
X-MC-Unique: pebAgQsZPM6jKHQLKh7dWw-1
X-Mimecast-MFC-AGG-ID: pebAgQsZPM6jKHQLKh7dWw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7CFC01954AEC;
	Fri, 29 Nov 2024 15:10:31 +0000 (UTC)
Received: from localhost (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E37EE300018D;
	Fri, 29 Nov 2024 15:10:28 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger@redhat.com, =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Peter
 Maydell <peter.maydell@linaro.org>
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
 armbru@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [RFC 18/21] arm/cpu: Introduce a customizable kvm host cpu model
In-Reply-To: <b7f25d3b-6ba7-4924-9383-74c1169dfe86@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-19-eric.auger@redhat.com>
 <ZxuX4i9NjVRizB72@redhat.com>
 <cb6c8f62-c5dc-416d-865f-fbdf96164dac@redhat.com>
 <Zxub7ol4p8P_sWF8@redhat.com>
 <CAFEAcA_wQu17y0PyQwxw0wuf2H5y2VE5aX16nLP2-u7QUP2ggA@mail.gmail.com>
 <Zx-9WxXkmkMuGIlQ@redhat.com>
 <CAFEAcA9w0mb5bcU8p+fScQony-=oqLmNurGWpnL_sBneQCzxUg@mail.gmail.com>
 <Zx_EGxj2aqc_2-kY@redhat.com>
 <63c232c2-a325-48d6-8ed4-753a7c6e3b4e@redhat.com>
 <87ikstn8sc.fsf@redhat.com> <87frnwmn2v.fsf@redhat.com>
 <b7f25d3b-6ba7-4924-9383-74c1169dfe86@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 29 Nov 2024 16:10:26 +0100
Message-ID: <87ldx2krdp.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Nov 12 2024, Eric Auger <eric.auger@redhat.com> wrote:
> I am scared about the overall implementation/test matrix. Can we afford
> supporting that many setups, revision based models, named models with
> all kinds of features optim-in/opt-out. We should also keep in mind what
> is our current goal, ie. supporting migration between different machines
> but still with sufficient commonalities.
>
> Shouldn't we try to collect community needs in that regard. I don't know
> if people will/can tell us what they want to migrate from/to. At least
> do the machines comply with the same spec rev or how large is the gap.
> How many ID regs/features do mismatch in general. Are those ID regs
> currently writable? What would be the best grouping model for them?
>
> Also many ID regs are not writable, because we have not turned them yet
> as writable or because they are not that much a problem at the moment.
> Maybe some features are not fully turned as writable. I mean some ID
> regs they depend on are but not all of them.
>
> So maybe we should reduce the complexity by reducing the scope to the 16
> writable regs we have atm (~ 126 writable ID reg fields).

Reducing scope is definetely needed here, I agree. Probably best to put
the design of named models on the backburner for now, until we've
figured out what we actually need/want to support.

In order to figure out how difficult/problematic mapping ID register
contents to features would be, I've been looking at some real world
examples, i.e. looking at register dumps on some servers that should be
reasonably close in capabilities and where we would like to be able to
migrate between them. "Reasonably close" is mostly "not more than two
handfuls of differences"; sometimes derived from a common base
(e.g. Neoverse-V2.)

The good news is that in many cases we only have differences in bits
that map to a feature (and are actually writable in current KVM.) The
bad news is that we have a number of exceptions.

Comparison #1:

ID_AA64DFR0
f010307009	#of breakpoints:7
f010305009	#of breakpoints:5

BRPs does not match to any feature (but has a different meaning when we
have FEAT_Debugv8p9 and 16+ breakpoints)
[this is a whole can of worms in general]

ID_AA64MMFR0
2100022200101026	FEAT_ECV, FEAT_FGT, 4PB
0000022200101125	mixed endian, 256TB

FEAT_ECV -> may be 1 or 2 in ECV, with different capabilities (I guess
we would need to allow something like FEAT_ECV=2 to expess this?)
support for mixed endian -> indicated in BigEnd, no feature (how
relevant is this in practice?)
PARange (52 bits/4PB vs 48 bits/256TB) -> no feature, but some values
depend on other features -- we care about this when creating a cpu, but
migrating to another system with a mismatched range would be
problematic, unless configuration outside of the cpu model would take
care of it

Comparison #2:

ID_AA64PFR0
1101011021111111	FEAT_AMUv1, GIC v3.0/4.0
1101001020111111

GIC == 1 indicates GIC CPU sysreg interface for 3.0/4.0, but no feature
(I'm not quite sure how we handle this in QEMU)

ID_AA64MMFR1
1000000010312122	FEAT_ECBHB, !FEAT_ETS2, FEAT_PAN3, FEAT_HPDS2, FEAT_HAFDBS
0000001010211120	!FEAT_ETS2, FEAT_PAN2, FEAT_HPDS

both ETS == 0 and ETS == 1 indicate that FEAT_ETS2 is not implememented
(ETS == 2 would indicate FEAT_ETS2) -- I guess we would want to
standardize on ETS == 0
FEAT_PAN3 implies FEAT_PAN2, and FEAT_HPDS2 implies FEAT_HPDS2, so
probably fine

ID_AA64MMFR2
1221011112001011	FEAT_BBM=2
1211011112011011	FEAT_BBM=1, FEAT_LVA

FEAT_BBM can have different values -- so not a neat boolean

So in summary, we have
(a) a few features that look a bit funky, but should be managable,
    especially if we accept non-boolean values
(b) things that are indicated in ID registers but do not map to any
    feature like mixed endian support
(c) things in (b) that we already know to be problematic, like the
    number of breakpoints
(d) things in (b) that actually interact with other configurations we
    might do via the commandline (PARange, probably GIC?)

and that's just from a sample of existing systems I was able to get data
from; I think we don't expect that there aren't any more of these in the
remainder of the architecture. (I'm excluding not-yet writable bits, as
I assume we'll eventually render everything writable that is feasible
and needed, although I suspect that there are problems lurking in there
as well.)

[I completely ignored aarch32 registers.]

My current plan is to push off features vs id regs into the future and
do a new version of this patch set that keeps id regs, but drops the
'custom' model, and that can be used to try migration between some hand
picked systems (to find out what other problems we will need to deal
with.)

