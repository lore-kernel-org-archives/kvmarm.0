Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56ED1DE894
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 16:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730131787; cv=none; b=Sx0+uNtBCt8CX11m5f+9DVxKXy8ZJxhhzf+MEMonmbiLwBIT69RCu2W9gIXpBOogXVdNDeV2MhOsZ3G560S/tTtzzEaNyYjqF0pepzSurSX9t0aWcw+Xsmc81u/J7u5IsD3Flb0ltnxsDpwqWjrsCHC4plCcelJSyQFJlSCvUxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730131787; c=relaxed/simple;
	bh=9B2Fhr9ot5U91JhbLWdLBB1gmU6HOU9dJmW2hZ/cud0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t/L8sDYOdB/r81jbDMiGP542X7KHZXVbkwqTe2vkrfPvG8MqRUCLLfw0x0ctmQYH0Uf4APJ6VmENvFiJwgdj49AFqawOM5956cFJ2m/M08F6DEc48hLOi7MGYDK5BrN175i1KbhZxammQALV5vNloUVY50bNauxq4WMLT4Lw0h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F4dLl1LU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F4dLl1LU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730131783;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ea6G5wtzKMhZ2E+87Bpxxtu+p19GIanpiqAsDf/FIog=;
	b=F4dLl1LUBojrJMi9146mItNDAr1HcpYWbraLjRQUjQLVQQRkc+n2DKn8sEMjgmoAkgYBHE
	WzdMwb2n6Bqw1kDPgEaCVrRTRPAthNj8rX14d64qMVki7wqqbP7E5Qw2hchwozbhvTnSsp
	3s68s71B1fJRzrmj3lc/ZC9dCjQfvBk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-53-MFjKr2uwM3GR5URt0I5N1A-1; Mon,
 28 Oct 2024 12:09:40 -0400
X-MC-Unique: MFjKr2uwM3GR5URt0I5N1A-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9EE4619560BD;
	Mon, 28 Oct 2024 16:09:38 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.86])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B18619560AA;
	Mon, 28 Oct 2024 16:09:31 +0000 (UTC)
Date: Mon, 28 Oct 2024 16:09:29 +0000
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
Message-ID: <Zx-3OUioG1l47hW3@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-22-eric.auger@redhat.com>
 <ZxuZkUFz_bwAA1pf@redhat.com>
 <0700af51-a1a6-4b11-a4bf-0eaf6e279c6d@redhat.com>
 <Zxudl5-fZV1vIaEL@redhat.com>
 <87y128nrfr.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87y128nrfr.fsf@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Mon, Oct 28, 2024 at 05:05:44PM +0100, Cornelia Huck wrote:
> On Fri, Oct 25 2024, Daniel P. Berrangé <berrange@redhat.com> wrote:
> 
> > On Fri, Oct 25, 2024 at 03:28:35PM +0200, Eric Auger wrote:
> >> Hi Daniel,
> >> 
> >> On 10/25/24 15:13, Daniel P. Berrangé wrote:
> >> > On Fri, Oct 25, 2024 at 12:17:40PM +0200, Eric Auger wrote:
> >> >> From: Cornelia Huck <cohuck@redhat.com>
> >> >>
> >> >> Add some documentation for the custom model.
> >> >>
> >> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >> >> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> >> >> ---
> >> >>  docs/system/arm/cpu-features.rst | 55 +++++++++++++++++++++++++++-----
> >> >>  1 file changed, 47 insertions(+), 8 deletions(-)
> >> >
> >> >> @@ -167,6 +196,16 @@ disabling many SVE vector lengths would be quite verbose, the ``sve<N>`` CPU
> >> >>  properties have special semantics (see "SVE CPU Property Parsing
> >> >>  Semantics").
> >> >>  
> >> >> +The ``custom`` CPU model needs to be configured via individual ID register
> >> >> +field properties, for example::
> >> >> +
> >> >> +  $ qemu-system-aarch64 -M virt -cpu custom,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
> >> >> +
> >> >> +This forces ID_AA64ISAR0_EL1 DP field to 0.
> >> > What is the "baseline" featureset implied by 'custom' ?
> >> there is no baseline at the moment. By default this is a host
> >> passthrough model.
> >
> > Why do we need to create "custom" at all, as opposed to just letting
> > users toggle features on "-cpu host" ? 
> 
> We could consolidate that to the current "host" model, once we figure
> out how to handle the currently already existing properties. Models
> based on the different architecture extensions would probably be more
> useable in the long run; maybe "custom" has a place for testing.

If you can set the features against "host", then any testing could
be done with "host" surely, making 'custom' pointless ?

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

