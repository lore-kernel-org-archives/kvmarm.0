Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BEB21218B
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 13:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729862658; cv=none; b=RA9kOgP2LzkM82jHhlD+mTeNRg7LhjbR+gGy0JjvjicKDxChcXlrbASVazSQClhJyZpsCgkODREjqcEIfVP/T6MxuHFi+1oRm43KaEsAooLU53E2+4EVpAR9zn6Iw6rjS5WUi+6OaUFiCmRgJZtKgLKloD4aNulUo5DJNH5yI4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729862658; c=relaxed/simple;
	bh=Hu6cSeHFMHSAsN5pRduCn/9wliNcwcWhVxivSeHpKgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s6KBijSxd3km37YMHEIKfEgc7tdkJ5kAIA5hHsZK1CBMPVCno4Roulvn3wFiFJawXJ7KCYS93BStH+Fop6M9kOcPxmTS+b6fBw2UgDLEDm36jy7Cz24dvYT9H7Mbgjav3D0Y+oDLYRXn9BQAQSmaJPT9Klcw2ckv3mSA/gm17Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DmxuCm+4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DmxuCm+4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729862654;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4jwhy2OH/3EypchV1ohJFKLuUp6Hz5miw89y3nkFMXs=;
	b=DmxuCm+4UYFuEklz76K/wk2NaDsVqjY0z4NIfdT/0c2OqDcbA/rytNFo6x+TtwH0jZFwak
	A9Pr7cHmdjbZAR5/mJhfaSszXYr0bJqT20FY3k3UOnZo+oWKgZx1Nh2EOZhUInI73B3tmX
	BS1DGs9Br/wrxusYeyciWA5OFBc1D3g=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-372-z4pMRBx_NAa-FFL8VBYx9Q-1; Fri,
 25 Oct 2024 09:24:11 -0400
X-MC-Unique: z4pMRBx_NAa-FFL8VBYx9Q-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 47D781955E7F;
	Fri, 25 Oct 2024 13:24:09 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.164])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D4E21955F30;
	Fri, 25 Oct 2024 13:24:01 +0000 (UTC)
Date: Fri, 25 Oct 2024 14:23:58 +0100
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
Subject: Re: [RFC 18/21] arm/cpu: Introduce a customizable kvm host cpu model
Message-ID: <Zxub7ol4p8P_sWF8@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-19-eric.auger@redhat.com>
 <ZxuX4i9NjVRizB72@redhat.com>
 <cb6c8f62-c5dc-416d-865f-fbdf96164dac@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb6c8f62-c5dc-416d-865f-fbdf96164dac@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, Oct 25, 2024 at 03:18:25PM +0200, Eric Auger wrote:
> Hi Daniel,
> 
> On 10/25/24 15:06, Daniel P. Berrangé wrote:
> > On Fri, Oct 25, 2024 at 12:17:37PM +0200, Eric Auger wrote:
> >> This new cpu model takes by default the host cpu values.
> >> However it exposes uint64 SYSREG properties for writable ID reg
> >> fields exposed by the host kernel. Properties are named
> >> SYSREG_<REG>_<FIELD> with REG and FIELD being those used
> >> in linux arch/arm64/tools/sysreg. This done by matching the
> >> writable fields retrieved from the host kernel against the
> >> generated description of sysregs.
> >>
> >> An example of invocation is:
> >> -cpu custom,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
> >> which sets DP field of ID_AA64ISAR0_EL1 to 0.
> > "SYSREG_" feels kinda redundant to repeat on every single
> > feature. 
> 
> I do agree. To be honest this was mostly driven my implementation need
> for cpu model expansion. Given the high number of props which are
> getting exposed, I iterate on all props and having a prefix let me
> return only those SYSREG props. Most probably we can get rid of the
> prefix by using some generated code as well.
> >
> > Also, is this naming convention really the same one that users
> > will see when they look at /proc/cpuinfo to view features ? It
> No it is not. I do agree that the custom cpu model is very low level. It
> is very well suited to test all series turning ID regs as writable but
> this would require an extra layer that adapts /proc/cpuinfo feature
> level to this regid/field abstraction.
> 
> In /cpu/proc you will see somethink like:
>  Features    : fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp
> asimdhp cpuid asimdrdm lrcpc dcpop asimddp

Right, IMHO, this is the terminology that QEMU must use in user
facing APIs.

On x86 we have a conversion tables for named features to register
bits

  https://gitlab.com/qemu-project/qemu/-/blob/master/target/i386/cpu.c#L914

and libvirt does similar

  https://gitlab.com/libvirt/libvirt/-/blob/master/src/cpu_map/x86_features.xml

Yep, it is more work, but it is also much better for humans IMHO.

> > feels pretty low level to me ?  Naming after the registers &
> > fields, would be like configuring x86 CPU features by asking
> > for "SYSREG_EAX_1_ECX_20" instead of saying "vmx" which is the
> > human friendly name.
> agreed.

> >> At the moment, the custom model does not support legacy options
> >> of the host cpu model. We need to understand what we do with those
> >> latter (SVE, ...). This means that related KVM ioctl are
> >> not called yet.
> > It will be pretty painful to have to use different feature
> > terminology for different CPU models. Everything in libvirt
> > assuming feature terminology varies per-arch, not per-CPU
> > model.
> Actually as far as I understand those regids/fields would fit all kind
> of aarch64 Cortex-A CPUs. So they wouldn't vary per-CPU (I mean their
> terminology. Their availability will).

What I mean is can we define  named models for various different
vendor's Cortex-A silicon and just use that without needing to
toggle features, except in rare cases.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

