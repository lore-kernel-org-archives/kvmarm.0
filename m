Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4C321219F
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 13:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729863083; cv=none; b=NXbTMhQreziwSHek4SKHpFoTnUt0or5lcor8CA3xDYK02xWvjbTgLlSrU9TRCxB2Fi3hcnWMLF1eoKEHLIzpoK+Rbs+crvDuuNMD2Imx1onIFoEEHzNlr/qNGNK78xf+ejBleXrfpGbFXS5a4Htdw1TIxOaUctu03KnMvFJ92r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729863083; c=relaxed/simple;
	bh=IepKr0KGsDTFOOysmDXRf0jcOJghfaIg7FOvIfNdd0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cvIBrpauTUHKAYsEDXtuJ/HKv+nLN9jovQuMn74p+zy7j1uP8T6QxhyD9YfK3Y6lEwDBZ7IRnfiYkizLaR3Dt8t3STR6DaKp3t5MFQ9SqB9AlYXgFiL0+OHs0+e/9r5lAxOx9bGchZX/281iMdjsCzc6ywcqzfPpUk3GfceDI+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H+CK+4gD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H+CK+4gD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729863080;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=waoi+b8XH0c3xLVAJPFetdqTvj+3eqZAdduWa1Fv1LI=;
	b=H+CK+4gD6pDb0fstRJeBt9S+fRlnTzwHCkprQTq6O11vpS7mbnnnuJrV53bLCZCrWGYJab
	zJl/gzM8KN6MGjy4EqBGc/coiO8MF8iEktpVrIxP5oDqch0aglOWk5bDFvFAzSIi2VrBdI
	VWVMB03ojFdU5PajcfgvGMI0XPKcZ4A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-38-Rd7mrFVRPGm__spTrUcptA-1; Fri,
 25 Oct 2024 09:31:18 -0400
X-MC-Unique: Rd7mrFVRPGm__spTrUcptA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 00F3819560A2;
	Fri, 25 Oct 2024 13:31:14 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.164])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F9F430001A9;
	Fri, 25 Oct 2024 13:31:06 +0000 (UTC)
Date: Fri, 25 Oct 2024 14:31:03 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, cohuck@redhat.com, qemu-devel@nongnu.org,
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
	peter.maydell@linaro.org, richard.henderson@linaro.org,
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
	shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
	pbonzini@redhat.com
Subject: Re: [RFC 21/21] arm/cpu-features: Document custom vcpu model
Message-ID: <Zxudl5-fZV1vIaEL@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-22-eric.auger@redhat.com>
 <ZxuZkUFz_bwAA1pf@redhat.com>
 <0700af51-a1a6-4b11-a4bf-0eaf6e279c6d@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0700af51-a1a6-4b11-a4bf-0eaf6e279c6d@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Oct 25, 2024 at 03:28:35PM +0200, Eric Auger wrote:
> Hi Daniel,
> 
> On 10/25/24 15:13, Daniel P. Berrangé wrote:
> > On Fri, Oct 25, 2024 at 12:17:40PM +0200, Eric Auger wrote:
> >> From: Cornelia Huck <cohuck@redhat.com>
> >>
> >> Add some documentation for the custom model.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> >> ---
> >>  docs/system/arm/cpu-features.rst | 55 +++++++++++++++++++++++++++-----
> >>  1 file changed, 47 insertions(+), 8 deletions(-)
> >
> >> @@ -167,6 +196,16 @@ disabling many SVE vector lengths would be quite verbose, the ``sve<N>`` CPU
> >>  properties have special semantics (see "SVE CPU Property Parsing
> >>  Semantics").
> >>  
> >> +The ``custom`` CPU model needs to be configured via individual ID register
> >> +field properties, for example::
> >> +
> >> +  $ qemu-system-aarch64 -M virt -cpu custom,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
> >> +
> >> +This forces ID_AA64ISAR0_EL1 DP field to 0.
> > What is the "baseline" featureset implied by 'custom' ?
> there is no baseline at the moment. By default this is a host
> passthrough model.

Why do we need to create "custom" at all, as opposed to just letting
users toggle features on "-cpu host" ? 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

