Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02B31BF81B
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 15:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730733879; cv=none; b=tEpzn/zr5O0LL1uA7c7kplPMKNqAQzJgklwDfRHlddruMjomMxl3SyWWxd2LsiZWH2S6TbB5S5mmgpNdn5FbKyGZrdRyZ2aIeWqEzdB/7GuTAAXkNFrMffieolySTNM5m2XAADf0GBglPcXOhpo6v9jR6DG7mgcDBmZD2TgqwXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730733879; c=relaxed/simple;
	bh=DUkkDJLlDnIyuVrVgvJb0Ji3XjE+XppHR1Mg1usi1Zk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PLOzLUBy/iCy8/xIna25qXzo7LdbdwoEGKhaeYhSDM6E6aKD4VahjvHraoMllB0V/4ziLBrI5wD4REYX9gzz38JTlnN/et0eXCcQv079WVDMDGoNuTnJa1nQKiRcMCyGK3UPNYl27SRkv3DUCUAriDxOO+j5hAZJlggFmzJoCd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C5uu3UWM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C5uu3UWM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730733876;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Rpq/uBr2y2YyfHOuA0rZNYcdp3Fhq0ehdI8m+Y3eq0=;
	b=C5uu3UWM+uwUFBilZ2YVZizF2nwT0l8R/kDtsZg8TpDuw81iJ7Qq7u65ocDa0CoHx2QdRu
	QJaz0ABOCKjqYOIJIl+gjhyFyGmx+FLiL7p9SxhgPDNGc+vXdft6+Ljs50zMViq6pbdFJc
	bDrPbRbNkOOVOkb6QRyaVB0noKegPtM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-372-nFxoB0yaNfuObz_1CF_hXA-1; Mon,
 04 Nov 2024 10:24:33 -0500
X-MC-Unique: nFxoB0yaNfuObz_1CF_hXA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A90081955BC7;
	Mon,  4 Nov 2024 15:24:26 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.152])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 33BC219560AA;
	Mon,  4 Nov 2024 15:24:19 +0000 (UTC)
Date: Mon, 4 Nov 2024 15:24:16 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Cornelia Huck <cohuck@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
	qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
	peter.maydell@linaro.org, richard.henderson@linaro.org,
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
	shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
	pbonzini@redhat.com
Subject: Re: [RFC 21/21] arm/cpu-features: Document custom vcpu model
Message-ID: <ZyjnIMteSuCvpGPW@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-22-eric.auger@redhat.com>
 <ZxuZkUFz_bwAA1pf@redhat.com>
 <0700af51-a1a6-4b11-a4bf-0eaf6e279c6d@redhat.com>
 <Zxudl5-fZV1vIaEL@redhat.com>
 <87y128nrfr.fsf@redhat.com>
 <Zx-3OUioG1l47hW3@redhat.com>
 <24ca0278-5018-41e3-a097-ac560a16f8fa@redhat.com>
 <ZyjgWJ3bZ69sueE2@redhat.com>
 <875xp3nigb.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <875xp3nigb.fsf@redhat.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Mon, Nov 04, 2024 at 04:10:12PM +0100, Cornelia Huck wrote:
> On Mon, Nov 04 2024, Daniel P. Berrangé <berrange@redhat.com> wrote:
> 
> >
> > FYI, in x86 target the -cpu command has had a "migratable=bool" property
> > for a long time , which defaults to 'true' for 'host' model. This causes
> > QEMU to explicitly drop features which would otherwise prevent migration
> > between two hosts with identical physical CPUs.
> >
> > IOW, if there are some bits present in 'host' that cause migration
> > problems on Ampere hosts, ideally either QEMU (or KVM kmod) would
> > detect them and turn them off automatically if migratable=true is
> > set. See commit message in 84f1b92f & 120eee7d1fd for some background
> > info
> 
> How does this work for version-sensitive features -- are they always
> defaulting to off? How many features are left with that in the end?

Do you mean QEMU versions here ? The non-migratable feature list is
just hardcoded in QEMU right now, and there's only 1 of them.
eg grep for 'unmigratable_flags'

Note, that "migratable" property is not defining a general purpose
migration mask between different hw generations. It was specifically
blocking just stuff that is known to make migration impossible, even
if HW is identical on both sides.

> > NB "migratable" is defined in i386 target code today, but conceptually
> > we should expand/move that to apply to all targets for consistency,
> > even if it is effectively a no-op some targets (eg if they are
> > guaranteed migratable out of the box already with '-cpu host').
> 
> How does this compare to s390x, which defines some migration-safe cpu
> models, based upon the different hw generations? If I look at the QEMU
> code for x86 and s390x, the s390x approach seems cleaner to me (probably
> because it came later, and therefore could start afresh without having
> to care for legacy things.) Given that we'll cook up a new model for Arm
> migration as well, we might as well start with a clean implementation :)

The impression I get (as an distant observer) is that CPUs on s390x in
general have less complexity to worry about. A combination of not having
a vendor who creates loads off different SKUs for the same CPU model
family with slight variations between each, and also not seeming to have
a situation where CPU flags a known to disappear (or appear) arbitrarily
in microcode updates.

The s390x idea of a "migratable" and "non migratable" model for each
HW generation is a nice simplification, but I can't see how it could
be made to work for x86 when you can't predict ahead of time what
features are going to be removed from existing HW definition by the
next microcode update, or by the next CPU SKU that removes a feature
you had assumed would always be present in a given HW generation.

I don't know much about how ARM world works, but having lots of vendors
competing with their own custom impls makes me worry complexity will
be closer to x86 than to s390.

If the ARM specifications define a minimum require featureset for each
HW generation, maybe you can define a model based on that ? You might
still want to have vendor specific models though, if there are compelling
features they expose which are optional, or non-standardized. 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

