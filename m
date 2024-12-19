Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069A219F128
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 17:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734630725; cv=none; b=kdD5HNTJZFf1fO0XnoNlTiKYOVCicOJ5IMZQ6eufyZARmY3rOhtB0vqBOU/NAjCDOBIS1R1qChIXegWEBu8ccwHdp6Z+sFBHBaar1Q6xHvtDdq1MF9WPAP4CB8UmXbO4ZSHU8n8r3XAx/04Q9N4BJc1htQMIdM8kN8O6xFUpAtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734630725; c=relaxed/simple;
	bh=2EJfJbKHQeZ9DBkX7O0UaxEoLhF8GIg0BsjIK9Ov9xc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uIlUdUI8S0p3RVgmuuINs3x1XzQbyJOSyYrxMePLO493PbQjXRjVsdkCRH/m6hGN0Kwro+cifUuqYfHNaHe1l0/+w0oEOxvPbWz49ep2Mf6UZPduQI06FRmV6MXMOoLHyfc34wDBwJSKJo6aMajVcnrDjgFVTruItNh/4N+8tlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PeiU41tE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PeiU41tE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734630722;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/65f699+zP0hxZzXVK7O5ivtKVynSZ4cs9bwdZ4NyD0=;
	b=PeiU41tEoC/UEQ95sHNB4wzZh2qpxXZHBVgkPbLQHcscbk13r8Spyv8O53+BrpaSRwYyNV
	bpzwhqGYx8Ey0iSpJ65sMj2pEBpfpDyI8h/o94VnTUdXZBhxZRU0obssk23DlzMQLrymm0
	hEKUayFP+tuja3clFjh95xRYpoIIXHs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-127-e4tCeR3XMtKyv4rSvegFPA-1; Thu,
 19 Dec 2024 12:51:59 -0500
X-MC-Unique: e4tCeR3XMtKyv4rSvegFPA-1
X-Mimecast-MFC-AGG-ID: e4tCeR3XMtKyv4rSvegFPA
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 51B0419560B7;
	Thu, 19 Dec 2024 17:51:56 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.54])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C4A9019560A2;
	Thu, 19 Dec 2024 17:51:47 +0000 (UTC)
Date: Thu, 19 Dec 2024 17:51:44 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Kashyap Chamarthy <kchamart@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
	qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
	peter.maydell@linaro.org, richard.henderson@linaro.org,
	alex.bennee@linaro.org, oliver.upton@linux.dev, sebott@redhat.com,
	shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
	abologna@redhat.com, jdenemar@redhat.com, shahuang@redhat.com,
	mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH RFCv2 00/20] kvm/arm: Introduce a customizable aarch64
 KVM host model
Message-ID: <Z2RdMJHydsvPpmdH@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241206112213.88394-1-cohuck@redhat.com>
 <edc12140-6345-4868-938d-c80c4d2c2004@redhat.com>
 <Z1qoa8yXscTSAJ9e@redhat.com>
 <8734it1bv6.fsf@redhat.com>
 <1fea79e4-7a31-4592-8495-7b18cd82d02b@redhat.com>
 <Z2QE9AqZnpGM5sWD@gezellig>
 <8634ijrh8q.wl-maz@kernel.org>
 <Z2Q2rWj9cV0W_XVq@gezellig>
 <86zfkrptmj.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86zfkrptmj.wl-maz@kernel.org>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Thu, Dec 19, 2024 at 03:41:56PM +0000, Marc Zyngier wrote:
> On Thu, 19 Dec 2024 15:07:25 +0000,
> Kashyap Chamarthy <kchamart@redhat.com> wrote:
> > 
> > On Thu, Dec 19, 2024 at 12:26:29PM +0000, Marc Zyngier wrote:
> > > On Thu, 19 Dec 2024 11:35:16 +0000,
> > > Kashyap Chamarthy <kchamart@redhat.com> wrote:
> > 
> > [...]
> > 
> > > > Consider this:
> > > > 
> > > > Say, there's a serious security issue in a released ARM CPU.  As part of
> > > > the fix, two new CPU flags need to be exposed to the guest OS, call them
> > > > "secflag1" and "secflag2".  Here, the user is configuring a baseline
> > > > model + two extra CPU flags, not to get close to some other CPU model
> > > > but to mitigate itself against a serious security flaw.
> > > 
> > > If there's such a security issue, that the hypervisor's job to do so,
> > > not userspace. 
> > 
> > I don't disagree.  Probably that has always been the case on ARM.  I
> > asked the above based on how QEMU on x86 handles it today.
> > 
> > > See what KVM does for CSV3, for example (and all the
> > > rest of the side-channel stuff).
> > 
> > Noted.  From a quick look in the kernel tree, I assume you're referring
> > to these commits[1].
> > 
> > > You can't rely on userspace for security, that'd be completely
> > > ludicrous.
> > 
> > As Dan Berrangé points out, it's the bog-standard way QEMU deals with
> > some of the CPU-related issues on x86 today.  See this "important CPU
> > flags"[2] section in the QEMU docs.
> 
> I had a look, and we do things quite differently. For example, the
> spec-ctrl equivalent in implemented in FW and in KVM, and is exposed
> by default if the HW is vulnerable. Userspace could hide that the
> mitigation is there, but that's the extent of the configurability.

Whether it is enabled by default or disabled by default isn't a
totally fatal problem. If QEMU can toggle it to the opposite value,
we have the same level of configurability in both cases.

It does, however, have implications for QEMU as if KVM gained support
for exposing the new feature by default and QEMU didn't know about
it, then the guest ABI would have changed without QEMU realizing it.

IOW, it would imply a requirement for timely QEMU updates to match
the kernel, which is something we wouldn't need in x86 world where
the feature is disabled by default. Disable by default is a more
stable approach from QEMU's POV.

> > Mind you, I'm _not_ saying this is how ARM should do it.  I don't know
> > enough about ARM to make such remarks.
> > 
> >     * * *
> > 
> > To reply to your other question on this thread[3] about "which ABI?"  I
> > think Dan is talking about the *guest* ABI: the virtual "chipset" that
> > is exposed to a guest (e.g. PCI(e) topology, ACPI tables, CPU model,
> > etc).  As I understand it, this "guest ABI" should remain predictable,
> > regardless of:
> > 
> >   - whether you're updating KVM, QEMU, or the underlying physical
> >     hardware itself; or
> >   - if the guest is migrated, live or offline
> > 
> > (As you might know, QEMU's "machine types" concept allows to create a
> > stable guest ABI.)
> 
> All of this is under control of QEMU, *except* for the "maximum" of
> the architectural features exposed to the guest. All you can do is
> *downgrade* from there, and only to a limited extent.
> 
> That, in turn has a direct impact on what you call the "CPU model",
> which for the ARM architecture really doesn't exist. All we have is a
> bag of discrete features, with intricate dependencies between them.
> 
> Even ignoring virtualisation: you can readily find two machines using
> the same CPUs (let's say Neoverse-N1), integrated by the same vendor
> (let's say, Ampere), in SoCs that bear the same name (Altra), and
> realise that they have a different feature set. Fun, isn't it?

"Fun" is probably not the word I'd pick :-)

> That's why I don't see CPU models as a viable thing in terms of ABI.
> They are an approximation of what you could have, but the ABI is
> elsewhere.

Right, this makes life quite challenging for QEMU. The premise of named
CPU models (as opposed to -host), is to facilitate the migration of VMs
between heterogenous hardware platforms. That assumes it is possible to
downgrade the CPU on both src + dst, to the common baseline you desire.

If we were to define a named CPU model, for that to be usable, QEMU
would have to be able to query the "maxmimum" architectural features,
and validate that the delta between the host maximum, and the named
CPU model is possible to downgrade. Is arm providing sufficient info
to let QEMU do that ?

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

