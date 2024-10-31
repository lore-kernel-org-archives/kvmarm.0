Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E08F14831D
	for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 12:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730377499; cv=none; b=HSATQ1yc2au3Zt0Zux6jZHGhnNv3CUnLGAu+81qyzV1RlA1k4on9c+Kr/warsu4J2Zh5S73Yp9yqYMsDKP2wRcHz1FgJagzMHB8ZB8/Y5Byvou4mcquyIckVrZS90QpNEJdTQa3wbP5djpxDHliUuGp68hyeXSWijuWqmjJX1po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730377499; c=relaxed/simple;
	bh=7pY9J1Iu0lH0K5ZdbZSF+gcGKaKyI6cKR5hTn64G7C8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n1xKkTimWaW7PVefRqwhot3OcRJd0h32v1O5fKfYmK1xTVspM7GU4hZnXL7OgCH/U3R2az5AnSBZ5/VlA8q3FOKP59lcRcNiluvegaRPAynfqVO3XgfvmgKhgnhb5LVn/4xcB8SbxnXcSlgGzmphkY+FXsndQxUPSimTX2nHJnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZGgIgDWh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZGgIgDWh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730377495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KPd7oDcX9eG7TVtE1AQlSacTh7/i7Z+qfMhr0px/qxo=;
	b=ZGgIgDWhagVF6sp3UOaBpAWT8idhmdTj3LOnb3CwzIshuvk/CJQbo9Nz3puDnEvKiBuQMY
	nJ4nW2t5ZL5tYYaX9z3B9a5K5LVLCg3zgIT8ivclrhhV6bSLnl1640HTYxf/WbRsTCQLkp
	oQeKHAkfFWdj8DtpLqs0+RjIymXMQts=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-410-oLV_MKhvOJit6ANUPC0mtw-1; Thu,
 31 Oct 2024 08:24:51 -0400
X-MC-Unique: oLV_MKhvOJit6ANUPC0mtw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 562F919560BC;
	Thu, 31 Oct 2024 12:24:48 +0000 (UTC)
Received: from pinwheel (unknown [10.39.194.127])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB1821956054;
	Thu, 31 Oct 2024 12:24:40 +0000 (UTC)
Date: Thu, 31 Oct 2024 13:24:37 +0100
From: Kashyap Chamarthy <kchamart@redhat.com>
To: Cornelia Huck <cohuck@redhat.com>
Cc: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
	qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
	peter.maydell@linaro.org, richard.henderson@linaro.org,
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
	shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
	pbonzini@redhat.com
Subject: Re: [RFC 21/21] arm/cpu-features: Document custom vcpu model
Message-ID: <ZyN3A6dAEDkx51yb@pinwheel>
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-22-eric.auger@redhat.com>
 <ZxuZkUFz_bwAA1pf@redhat.com>
 <0700af51-a1a6-4b11-a4bf-0eaf6e279c6d@redhat.com>
 <Zxudl5-fZV1vIaEL@redhat.com>
 <87y128nrfr.fsf@redhat.com>
 <Zx-3OUioG1l47hW3@redhat.com>
 <87plnknqco.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87plnknqco.fsf@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Mon, Oct 28, 2024 at 05:29:11PM +0100, Cornelia Huck wrote:
> On Mon, Oct 28 2024, Daniel P. Berrangé <berrange@redhat.com> wrote:

[...]

> >> We could consolidate that to the current "host" model, once we figure
> >> out how to handle the currently already existing properties. Models
> >> based on the different architecture extensions would probably be more
> >> useable in the long run; maybe "custom" has a place for testing.
> >
> > If you can set the features against "host", then any testing could
> > be done with "host" surely, making 'custom' pointless ?
> 
> We might differentiate between "do some consistency checks" and "allow
> a completely weird wolpertinger"; if we agree that we don't need it,
> then we surely could drop it again.

Yeah, FWIW, I agree that it's best to drop "custom" if all the
meaningful tests can be handled by being able to add/remove CPU flags
from `-cpu host`.


Related: I don't see any mention of `-cpu max` here.  Is it not
relevant?  It is currently defined as: "enables all features supported
by the accelerator in the current host".  Does it make sense for `max`
to allow disabling features?  Or is the idea that, why would you choose
`-cpu max` if you want to disable features?  In that case, go with
either:

    -cpu host,feat1=off

Or:

    -cpu some_future_named_model,$feat1=off

?

-- 
/kashyap

