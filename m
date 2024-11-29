Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C8412C54B
	for <kvmarm@lists.linux.dev>; Fri, 29 Nov 2024 15:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732895490; cv=none; b=S58gys42hezq8/JNA3G8NAh4QsTKW8pqWHZj1EPZcmxPfZzCQD2blItgtl86sFRsvyn0M0u+A/tPsRxpocY9sHtl/rxSidFurESE0hsRv6v+XodNLi6Vj6IWFuOqy2w45JnSrY351rjTYaio30PtIiIT3xxSKir1xIql8cI5HI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732895490; c=relaxed/simple;
	bh=AKrv4sUuGIo0pk1QcQLWFHP1LUEh4msWcBHUzcqeYvs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=T5VDBk5mFQMt+WOQQQ50x901piOJtRvf4O0xDSeisFYOpInAAW99kKWKNleoP2CTrIQj3JAfXk6zLUUkRG1+CtvJiEu8eLgCgp9b1EgC4BYx/dW502pjaNJ/bD1UiZU3byPkkY+jvhvMRQ5SIvZPs1PXzwwwaNCO2QMPq7I4FeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h7zP6nQt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h7zP6nQt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732895487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8GJVdazRf21ux4iTl+yQ/9gjpKS7isQK/8RyegOC2SY=;
	b=h7zP6nQtgUkpDrmZlPJoC1JCD2l4oVVVkGa0y3kp6le8+49ZjX/jvIBSIuGErcT7wBCGt0
	FeyWSXiuvfc0Tyh5HqXadeIs4sFoTRGBP0Ixm6sXQDrXZmm25J4RDc1v8QlFGkApSgNSWb
	FOk5fm3lfsmo7CEY0bH2CJ2m6qDRix0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-Zf6NAUy_PLaWPTeSmpfhhQ-1; Fri,
 29 Nov 2024 10:51:24 -0500
X-MC-Unique: Zf6NAUy_PLaWPTeSmpfhhQ-1
X-Mimecast-MFC-AGG-ID: Zf6NAUy_PLaWPTeSmpfhhQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A74DE19560B7;
	Fri, 29 Nov 2024 15:51:20 +0000 (UTC)
Received: from localhost (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 16249195605A;
	Fri, 29 Nov 2024 15:51:17 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: eric.auger@redhat.com, =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>,
 eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
 armbru@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [RFC 18/21] arm/cpu: Introduce a customizable kvm host cpu model
In-Reply-To: <CAFEAcA-Pi4GRXyY3Lf-rCYk0CDZ5cT22orHT6JDxK14k9JMkng@mail.gmail.com>
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
 <87ldx2krdp.fsf@redhat.com>
 <CAFEAcA-Pi4GRXyY3Lf-rCYk0CDZ5cT22orHT6JDxK14k9JMkng@mail.gmail.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 29 Nov 2024 16:51:15 +0100
Message-ID: <87frnakpho.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Fri, Nov 29 2024, Peter Maydell <peter.maydell@linaro.org> wrote:

> On Fri, 29 Nov 2024 at 15:10, Cornelia Huck <cohuck@redhat.com> wrote:
>> The good news is that in many cases we only have differences in bits
>> that map to a feature (and are actually writable in current KVM.) The
>> bad news is that we have a number of exceptions.
>>
>> Comparison #1:
>>
>> ID_AA64DFR0
>> f010307009      #of breakpoints:7
>> f010305009      #of breakpoints:5
>>
>> BRPs does not match to any feature (but has a different meaning when we
>> have FEAT_Debugv8p9 and 16+ breakpoints)
>> [this is a whole can of worms in general]
>>
>> ID_AA64MMFR0
>> 2100022200101026        FEAT_ECV, FEAT_FGT, 4PB
>> 0000022200101125        mixed endian, 256TB
>>
>> FEAT_ECV -> may be 1 or 2 in ECV, with different capabilities (I guess
>> we would need to allow something like FEAT_ECV=2 to expess this?)
>
> This one was an unfortunate oversight; I expect that there
> will be a separate feature name for the =2 case in some future
> spec release. But as you note for FEAT_BBM below, not
> every different ID field value always has its own FEAT_ name.
> (FEAT_HAFDBS is another -- it allows ID_AA64MMFR1_EL1.HAFDBS to
> be 1 or 2.)

Ah yes, I actually noticed FEAT_HAFDBS as well.

>
>> support for mixed endian -> indicated in BigEnd, no feature (how
>> relevant is this in practice?)
>
> ID_AA64MMFR0_EL1.BigEnd == 1 is FEAT_MixedEnd. Relevant if your
> guest or its userspace wants to use big-endian, which is probably
> approximately nobody in a KVM context but is theoretically possible.

Ok, that one I missed in the list; if there's a feature, we should be
able to use it.

>
>> PARange (52 bits/4PB vs 48 bits/256TB) -> no feature, but some values
>> depend on other features -- we care about this when creating a cpu, but
>> migrating to another system with a mismatched range would be
>> problematic, unless configuration outside of the cpu model would take
>> care of it
>>
>> Comparison #2:
>>
>> ID_AA64PFR0
>> 1101011021111111        FEAT_AMUv1, GIC v3.0/4.0
>> 1101001020111111
>>
>> GIC == 1 indicates GIC CPU sysreg interface for 3.0/4.0, but no feature
>> (I'm not quite sure how we handle this in QEMU)
>
> We basically defer GIC emulation almost entirely to the
> kernel (which will set the GIC bit in the ID registers
> according to whether userspace asked it for a GIC or not).
>
>> ID_AA64MMFR1
>> 1000000010312122        FEAT_ECBHB, !FEAT_ETS2, FEAT_PAN3, FEAT_HPDS2, FEAT_HAFDBS
>> 0000001010211120        !FEAT_ETS2, FEAT_PAN2, FEAT_HPDS
>>
>> both ETS == 0 and ETS == 1 indicate that FEAT_ETS2 is not implememented
>> (ETS == 2 would indicate FEAT_ETS2) -- I guess we would want to
>> standardize on ETS == 0
>> FEAT_PAN3 implies FEAT_PAN2, and FEAT_HPDS2 implies FEAT_HPDS2, so
>> probably fine
>
> Yes, in general if the number in the field gets bigger
> this should be a backwards-compatible improvement in
> the feature.

Indeed, I hope that this will be the case for new features.

