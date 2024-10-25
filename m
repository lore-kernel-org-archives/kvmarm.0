Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F81B1632C3
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 13:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729862050; cv=none; b=d8SFPjemplmwA9xqENz98eWZBOGAgP0/bcQY7p4e/W7LQd6j7nm3oSppCavK4AdKUL41PUU0NZ0oGg5dpWCCpW5kke4HvxbZ7oH1MPPfR6pavcwCTLW7jAabFRHy5M7mgUI7mGW+Jj+PaOuIzI4Jia1G14V4ENbhq7tYaDp75MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729862050; c=relaxed/simple;
	bh=OVZM4VQXI9Vi1p/2IMLGbLq1I7AdNZF5Hd55+ZAm+ZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UDv5WLfZIsKspDc7jf7SexSefsBmdrqyPQSXEIv++DPF+Oc6GcUX6xuN/TvNCGirKHsRPP0m+B79veY7nOQj1pnFAo64dEmbFn7GhrQnVsVkS/yl7eceEH3spjU/KKGSe/ZxNcygEjxR2YHU9yW4pDH0rvmmuMbI30+LHHQuDqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RGTFVeU2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RGTFVeU2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729862046;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=utmRzVQoxVVn0L+FQtdN5VmsyzaSJviEhgivbzjdJxU=;
	b=RGTFVeU2ApkdMj+1Lye7cYP1EE7NOeLwT5xPZsFGDGaQbJLWvq4DqF0r2asigxsN00gCl3
	fkhliofFAbs4tbKi6mXRq188PekQi8XoncK9T6nP99ABhWBCbMvPODZe+IZIYKBpl59KOa
	UCOqtwl4OGQFJ1KjaAEWMWDB5nrQx+U=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-424-ec0_NatpMH6YYRXoxfo7ag-1; Fri,
 25 Oct 2024 09:14:03 -0400
X-MC-Unique: ec0_NatpMH6YYRXoxfo7ag-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 80FB91956080;
	Fri, 25 Oct 2024 13:14:01 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.164])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA92C196BB7D;
	Fri, 25 Oct 2024 13:13:56 +0000 (UTC)
Date: Fri, 25 Oct 2024 14:13:53 +0100
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
Message-ID: <ZxuZkUFz_bwAA1pf@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-22-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241025101959.601048-22-eric.auger@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Fri, Oct 25, 2024 at 12:17:40PM +0200, Eric Auger wrote:
> From: Cornelia Huck <cohuck@redhat.com>
> 
> Add some documentation for the custom model.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  docs/system/arm/cpu-features.rst | 55 +++++++++++++++++++++++++++-----
>  1 file changed, 47 insertions(+), 8 deletions(-)


> @@ -167,6 +196,16 @@ disabling many SVE vector lengths would be quite verbose, the ``sve<N>`` CPU
>  properties have special semantics (see "SVE CPU Property Parsing
>  Semantics").
>  
> +The ``custom`` CPU model needs to be configured via individual ID register
> +field properties, for example::
> +
> +  $ qemu-system-aarch64 -M virt -cpu custom,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
> +
> +This forces ID_AA64ISAR0_EL1 DP field to 0.

What is the "baseline" featureset implied by 'custom' ?

On x86 we have the named CPU models each setting a baseline that matches
some corresponding real world silicon. Arm has that too, with TCG at
least. So that way you know what the baseline is that you're toggling
features against.

Experiance on x86 was that making arbitrary feature changes on top of the
named models could often backfire, as there are too many scenarios where
code will check for feature "Y", and assume that existance of "Y" implies
existance of "A", "B" and "C" too. So if you invent custom models where
Y is set, but B is missing, there's decent risk of things going wrong in
horrible to debug ways.  With that in mind, best practice is to try to
just the vanilla named CPU models to the greatest extent possible, and
keep feature toggling to an absolute minimum.  This 'custom' model does
not seem to give us such ability for arm.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

