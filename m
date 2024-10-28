Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84AE1DEFC4
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 16:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730133358; cv=none; b=F4tENQy5vFizj533Xt2YpeaJtTWzhTifca19OvZQ538TwdMkh7itFwzKGxPqzU5SIzqFctWSvgDSoh0MLmAAnfiiVzeHA2WaxKFCKOphZ4HMBithzOmfjKm8zXRjHLQN0bvy3FGcbmhW94A1B0R61bOBZbywpJ1Hr3u6yI+PJyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730133358; c=relaxed/simple;
	bh=KerATjdieBekw4nqxhfDRkuljX3jY3gIDC2yLuhzJaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LvqgonKWyP3nyXdcDipxjcV24fCf0WbPFll32DavYm6VAT41CCB5cgGPOBJlrC4aYCT28OnMBUFT+1xT9stquw+93HaKtOkCAxwRjELsLAfXTuJz6JIcrOVJlr2Zi20hZJoJcCAp56+JUn5LkLuxLiz47u4TAf78drQtWv9GbFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WTrQWiZI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WTrQWiZI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730133354;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9b5CzbUSU2n0RZT4h84OA5Z8uF+KezT8fQqdhGRljA=;
	b=WTrQWiZIWjmXn0POEYDFN2NKGxeXgeNOzObR2jggTr08aJhtYRDKUgls3a9Xdaz5rX1tsQ
	Ko/jjdFpDO/d1DrqiIFkV2na9vqDw5dLWmC+aEj04T3opxy1eRE6e06zJ/mhZFWGvSqabc
	Srelamlw1XUaT5AwGSvU1CtIZmxPwbM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-120-n8NY9vqZPxSv0Fatb-9iKg-1; Mon,
 28 Oct 2024 12:35:53 -0400
X-MC-Unique: n8NY9vqZPxSv0Fatb-9iKg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFB2C1955F3C;
	Mon, 28 Oct 2024 16:35:49 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.86])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9EE719560A2;
	Mon, 28 Oct 2024 16:35:42 +0000 (UTC)
Date: Mon, 28 Oct 2024 16:35:39 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
	cohuck@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev, richard.henderson@linaro.org,
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
	shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
	pbonzini@redhat.com
Subject: Re: [RFC 18/21] arm/cpu: Introduce a customizable kvm host cpu model
Message-ID: <Zx-9WxXkmkMuGIlQ@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-19-eric.auger@redhat.com>
 <ZxuX4i9NjVRizB72@redhat.com>
 <cb6c8f62-c5dc-416d-865f-fbdf96164dac@redhat.com>
 <Zxub7ol4p8P_sWF8@redhat.com>
 <CAFEAcA_wQu17y0PyQwxw0wuf2H5y2VE5aX16nLP2-u7QUP2ggA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFEAcA_wQu17y0PyQwxw0wuf2H5y2VE5aX16nLP2-u7QUP2ggA@mail.gmail.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Oct 28, 2024 at 04:16:31PM +0000, Peter Maydell wrote:
> On Fri, 25 Oct 2024 at 14:24, Daniel P. Berrangé <berrange@redhat.com> wrote:
> > On Fri, Oct 25, 2024 at 03:18:25PM +0200, Eric Auger wrote:
> > > On 10/25/24 15:06, Daniel P. Berrangé wrote:
> > > > Also, is this naming convention really the same one that users
> > > > will see when they look at /proc/cpuinfo to view features ? It
> > > No it is not. I do agree that the custom cpu model is very low level. It
> > > is very well suited to test all series turning ID regs as writable but
> > > this would require an extra layer that adapts /proc/cpuinfo feature
> > > level to this regid/field abstraction.
> > >
> > > In /cpu/proc you will see somethink like:
> > >  Features    : fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp
> > > asimdhp cpuid asimdrdm lrcpc dcpop asimddp
> >
> > Right, IMHO, this is the terminology that QEMU must use in user
> > facing APIs.
> 
> /proc/cpuinfo's naming is rather weird for historical
> reasons (for instance there is only one FEAT_FP16 feature
> but cpuinfo lists "fphp" and "asimdhp" separately).

There's plenty of wierd history in x86 too. In this
case I might suggest just picking one of the two
common names, and ignoring the other.

If we really wanted to, we could alias the 2nd name
to the first, but its likely not worth the bother.

> Currently QEMU only has to care about cpuinfo name tags
> in linux-user/elfload.c where there's a bunch of data
> structures for "what hwcaps do we need to advertise
> given what the CPU has?". I would definitely prefer it if
> we could use architectural feature names...
> 
> On other architectures do we do anything to forbid
> invalid combinations? For Arm there are architectural
> rules about feature X requiring features Y and Z.
> Are we going to just let the user create a CPU that
> the guest OS will barf on if they want to? (The
> user-experience for that is potentially not very nice,
> because something like "-cpu cortex-a57,+sve" seems like
> something you might want to do but isn't actually valid;
> even listing the direct required dependency of FEAT_SVE
> like "-cpu cortex-a57,+sve,+fp16" isn't sufficient
> because SVE is optional-from-v8.2 and so a guest could
> in theory assume the presence of anything mandatory in
> v8.1 and v8.2. But even merely diagnosing invalid
> combinations is a huge pain, and automagically pulling
> in every mandatory implicit or explicit dependency
> seems like it might be surprising to users, as well as
> being annoying to implement. Currently we sidestep
> all of these problems by (a) only allowing the command
> line to disable a feature, not to enable it where it
> didn't previously exist and (b) mostly not providing
> command line flags for individual features...)

AFAICT, in x86 world, there's no generally documented dependancies
between features. I imagine there might be deps mentioned in an
adhoc basis in docs/specs.  There are certainly implicit deps though
where apps check for X, and blindly assume it means Y+Z also exist.

In the QEMU  & libvirt world though, there's no deps. This is generally
why we discourage apps/users from trying to enable arbitrarily many
features. People should stick to the named CPU models, and just use
feature enablement as an exception.

Enabling individual features *is* certainly a critically important
benefit though, even with the risks from implicit undocumented
dependencies.

Most notably, it has been used to turn on fixes for hardware CVEs,
where microcode introduces a new named feature. Your named CPU
model may not be updated, but as long as QEMU knows the feature
name, you can turn it on.

Overall, while it would be desirable to have a way to express
feature dependencies, I wouldn't call that a blocker for enabling
the ability to turn features on & off.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

