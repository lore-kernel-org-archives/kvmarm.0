Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE093C6608
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 11:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781263511; cv=none; b=XG8XdSKYzALethpBcKzSLrP+M4S64b5PHCuhPFSDBlchD2ogz4Ux93E03coLG7mvarURdwYpgZphEXnWjzIxP7yVV6S7DMLMMCFTa3vsqiXs6FYKSQ7bQ81/NdH5lQDkTMJ5qAJwI79tfKxBzr2dlaB39H7mm57pfPFYAxX/Zjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781263511; c=relaxed/simple;
	bh=8+TMBPFLOXt4CEGgo5MuL/IbBwkWinUUx43hn6z7Rk4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=o4ra79mU96jgMy45ARe3rIQaUo8XyoSVyyMROSyzuO6QBThGaK/unpoaaQx29/gxurboy2ciVv/k7ZslLaHfBKTvWesWBJYlnDhWPxUqo4PO+KwGurxGjXqT0yk/EukHc1yyx1QiNneOxn9wcJ0ILUcl5n4HKjO2TCBCMVQo7XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AEiHIkDV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AEiHIkDV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781263507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aEJtkLPRSIgHIFIU0/rrxmffA42MTYT1FFKMyK/sGAM=;
	b=AEiHIkDVSqyt7vgooZBeg00vWKDrvqsseEhumojmpZGT0UqAdozV6hu4p0GbQcd/hN4NRX
	55lRw9RAEcPZse9S5o1781DfapREZTLGuWNA1kopGItLz2curHWPM0oQgFYgZpbqOdL35t
	keG88H0BI7japxr6IYV4MQ4PPYA8Mww=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-426-WHrgOT3-MxebZ8ilUpvDmg-1; Fri,
 12 Jun 2026 07:25:04 -0400
X-MC-Unique: WHrgOT3-MxebZ8ilUpvDmg-1
X-Mimecast-MFC-AGG-ID: WHrgOT3-MxebZ8ilUpvDmg_1781263502
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F94D1800845;
	Fri, 12 Jun 2026 11:25:02 +0000 (UTC)
Received: from localhost (unknown [10.44.49.167])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5EFEB1954128;
	Fri, 12 Jun 2026 11:25:00 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Khushit Shah <khushit.shah@nutanix.com>, "eric.auger@redhat.com"
 <eric.auger@redhat.com>, "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Cc: "peter.maydell@linaro.org" <peter.maydell@linaro.org>, Shaju Abraham
 <shaju.abraham@nutanix.com>, Mark Cave-Ayland
 <mark.caveayland@nutanix.com>, =?utf-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Shameer
 Kolothum <skolothumtho@nvidia.com>, Jinqian Yang <yangjinqian1@huawei.com>,
 Marc Zyngier <maz@kernel.org>, Sebastian Ott <sebott@redhat.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: [RFC] arm: property and value naming summary between named CPU
 models vs customizable host model
In-Reply-To: <B820643E-3F14-4CDA-BA6B-09C632F17B9E@nutanix.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <B820643E-3F14-4CDA-BA6B-09C632F17B9E@nutanix.com>
User-Agent: Notmuch/0.40 (https://notmuchmail.org)
Date: Fri, 12 Jun 2026 13:24:57 +0200
Message-ID: <87bjdgm25y.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: EovqPXTFcoZUN0hCGuniqnYKQ2oalnFMyNs1c2SW4aQ_1781263502
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

On Wed, Jun 10 2026, Khushit Shah <khushit.shah@nutanix.com> wrote:

Thank you for the writeup!

(...)

> I have tried to keep the comparison above neutral, but Eric/Cornelia can
> add more. I see real merit in [2]'s simplicity and generalization. But
> for [1], I love a command line that looks like:
> -cpu host,feat_DP=off,feat_AES=off,feat_RAS=0.0,...
>
> instead of:
> -cpu host \
>      SYSREG_ID_AA64ISAR0_DP=0,\
>      SYSREG_ID_AA64ISAR0_AES=0,\
>      SYSREG_ID_AA64PFR0_RAS=0,\
>      SYSREG_ID_AA64PFR1_RAS_FRAC=0 
>
> I have no strong preference on this topic. The named CPU model layer is
> independent of whichever convention we choose here, so I'd like the
> community to decide which direction makes the most sense :)

I see the human-friendliness of providing prop names as in [1], but I
also see the advantages of generating properties automatically from the
ARM specification in [2]. Maybe there's a way to get the best of both
worlds? Can we expose the feat_XXX properties to users by mapping them
to the relevant registers respectively the combinations of them and
still keep the raw sysregs for those cases where something does not
match to feat_XXX (e.g. some cache values), or just as an alternative
way of configuring things?

Also, we've mostly talked about KVM so far. If we also consider TCG, or
other hypervisors such as HVF, I'd be in favour of grabbing definitions
from the spec, instead of from a specific kernel. (We can still choose
to match the Linux names, but we should not have to.)

There are also some pre-existing properties for cpus; can we express
them via the new interfaces, or do we want to deprecate them, only
keeping those that do not match to hardware, but to accelerator
implementation details?

