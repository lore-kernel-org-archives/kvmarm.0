Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684812D052
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 16:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730132136; cv=none; b=mulCej0wAkvEIdJKab/OKs4ySPHi+9b/wgCMoHRP+mUAiFopc/5+b58Gub/8654Vwgi7UEYcq4+Y03BgS9vtragti1D5Yxc2TDH75s2GhAxglNu4Df+VWauus8/9prhi6vIUwIlqfnfWsaXpi4d7yo3nZF8njxVslU2iB0rotPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730132136; c=relaxed/simple;
	bh=09mkEW0UIpQfQEcVJMsqZ9iKSpky63SwXF43AT9od4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U6kiBzaTM3eicSiqbOwmv870qnWETfDSyvCxS5YijV9sD1ndEMcaJ6UmJyqnl6gHRdtcuU1toQZw5xNXwh3cAluN+l5eQnhZRtDbjqcB0EiWxcW6cH0QXhxAP2vTUH3nFd9I91qjsMXGyzxAQ3mB1y7XVahyoj8xMGeYD/OUr+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ka3BYkwu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ka3BYkwu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730132133;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QKIrHJfj63rZmwzKwL6iYi78U/EbdLp1fslXaennyrc=;
	b=Ka3BYkwuVpMSYnpyiBvmbSIWdIJPg6b3+XnaqFAzxjrjki7/thCFdnxW051Vwgi03YnfvA
	4A7m0IQHt/RjfNnI7RlOxSEE4O/oBJ/bMWL9w/MS6t3zbH4EUn5FStjF7cMAzMmM0DCoqq
	PyUs3C74jxSpEaJ0me1vw+mnAOyMjEY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-232-BrWJYIK0PX-Z2wN_TKKHTA-1; Mon,
 28 Oct 2024 12:15:30 -0400
X-MC-Unique: BrWJYIK0PX-Z2wN_TKKHTA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C31EB1956080;
	Mon, 28 Oct 2024 16:15:27 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.86])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 82EC51956086;
	Mon, 28 Oct 2024 16:15:20 +0000 (UTC)
Date: Mon, 28 Oct 2024 16:15:16 +0000
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
Subject: Re: [RFC 18/21] arm/cpu: Introduce a customizable kvm host cpu model
Message-ID: <Zx-4lE5IS9BxD7nK@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-19-eric.auger@redhat.com>
 <ZxuX4i9NjVRizB72@redhat.com>
 <cb6c8f62-c5dc-416d-865f-fbdf96164dac@redhat.com>
 <Zxub7ol4p8P_sWF8@redhat.com>
 <871q00p68h.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <871q00p68h.fsf@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Mon, Oct 28, 2024 at 05:00:46PM +0100, Cornelia Huck wrote:
> On Fri, Oct 25 2024, Daniel P. Berrangé <berrange@redhat.com> wrote:
> 
> > On Fri, Oct 25, 2024 at 03:18:25PM +0200, Eric Auger wrote:
> >> Hi Daniel,
> >> 
> >> On 10/25/24 15:06, Daniel P. Berrangé wrote:
> >> > On Fri, Oct 25, 2024 at 12:17:37PM +0200, Eric Auger wrote:
> >> >> At the moment, the custom model does not support legacy options
> >> >> of the host cpu model. We need to understand what we do with those
> >> >> latter (SVE, ...). This means that related KVM ioctl are
> >> >> not called yet.
> >> > It will be pretty painful to have to use different feature
> >> > terminology for different CPU models. Everything in libvirt
> >> > assuming feature terminology varies per-arch, not per-CPU
> >> > model.
> >> Actually as far as I understand those regids/fields would fit all kind
> >> of aarch64 Cortex-A CPUs. So they wouldn't vary per-CPU (I mean their
> >> terminology. Their availability will).
> >
> > What I mean is can we define  named models for various different
> > vendor's Cortex-A silicon and just use that without needing to
> > toggle features, except in rare cases.
> 
> I'm not sure whether creating named models for various cpus would
> actually scale; what we probably could do is come up with some Armv8.6,
> Armv8.7, ... models and have additional models for some well-known cpus.
> That would also give us some basic sanity checks for feature
> combinations, if we do not want to support completely custom
> frankencpus.

Yep, even on x86 we don't add named models for every conceivable
CPU SKU variant, just one so called "typical" variant for a given
microarchiteture level [1].

The vendor independent Arm CPU spec versions are a good enough
match for typical real world silicon, then it would make sense
to focus mostly on such named CPU models, not try to make an
exhaustive definition of every vendor's impl. I could see there
might be some exceptions where adding a vendor specific named
model would be worthwhile, but hopefully that'd be relatively
uncommon and   -cpu Armv8.6,+feat1,+feat2 would be sufficient.

eg toggling 1/2/3 extra features to precise match a vendor's
named mode is ok, but adding 20-30 extra features get a match
is painful. That's the kind of rule of thumb that could be
used when deciding whether its worth adding a vendor specific
named model, vs relying on the generic spec based models.

With regards,
Daniel

[1] we do have CPU model versions, as a way to "bugfix" our
    CPU definitions. 
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

