Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA71206500
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 13:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729861622; cv=none; b=SwYoGVTh/cZgFbXFNHsCFGF5GucLBNW+DVOjDuG6/RuSsNm836zn8rPdIo3TjOVczAIoAzZKuoLskmYjFirj8fdLBsY9+ppBkPzc/AgpxSYdZ2+mQPBp/uaVUuYeEpTcO/Bp1ekeWOzITZIeSG6MO09GgL7yD7jYuorW9zxzETM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729861622; c=relaxed/simple;
	bh=bf9r11I+KnOzXrNpPkd7UoOsudvx/B/hgrXPOqEooFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XUmVLzsH4Wgwr946X2jsFF7lVUw7SfjWf2pban0Ru7zwa7G0YDhbCaabuplgBwy+DBLuN2Y8BIJkjlO/sNMWpHnn+3bNqRG7W5Rc3PSagIzL7x0lOxRKywN9tecICKPsCC9OyhJOj4n946IxhdXx8+9f8oYFMWNxzWlVIigTUVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JKFRgFvN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JKFRgFvN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729861619;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=xsCzoibnSTl/nXMnbdZJ3n//wdWYLvbIDAUZDZZBDm4=;
	b=JKFRgFvNVrq0f+ACXGIyOP+uOeOpfJCnqzolgVW1UnY1RGuFb7RFRaTAOH4aySLnlGPFOc
	ICFOo1D6XWrq7yimLZNzMXQkcwujJ+BaBUhyBaD2EqUZmY7yTWtsRbuWJjNy8PrisP/UzL
	8eVW96Lgfi6i3bWoVSykqwZDvBqiONM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-119-5XZE1yUWNaW-rEI11PDeNg-1; Fri,
 25 Oct 2024 09:06:55 -0400
X-MC-Unique: 5XZE1yUWNaW-rEI11PDeNg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9294D1955F06;
	Fri, 25 Oct 2024 13:06:53 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.164])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A8051956088;
	Fri, 25 Oct 2024 13:06:44 +0000 (UTC)
Date: Fri, 25 Oct 2024 14:06:42 +0100
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
Message-ID: <ZxuX4i9NjVRizB72@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-19-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241025101959.601048-19-eric.auger@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, Oct 25, 2024 at 12:17:37PM +0200, Eric Auger wrote:
> This new cpu model takes by default the host cpu values.
> However it exposes uint64 SYSREG properties for writable ID reg
> fields exposed by the host kernel. Properties are named
> SYSREG_<REG>_<FIELD> with REG and FIELD being those used
> in linux arch/arm64/tools/sysreg. This done by matching the
> writable fields retrieved from the host kernel against the
> generated description of sysregs.
> 
> An example of invocation is:
> -cpu custom,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
> which sets DP field of ID_AA64ISAR0_EL1 to 0.

"SYSREG_" feels kinda redundant to repeat on every single
feature. 

Also, is this naming convention really the same one that users
will see when they look at /proc/cpuinfo to view features ? It
feels pretty low level to me ?  Naming after the registers &
fields, would be like configuring x86 CPU features by asking
for "SYSREG_EAX_1_ECX_20" instead of saying "vmx" which is the
human friendly name.


> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> 
> ---
> 
> At the moment, the custom model does not support legacy options
> of the host cpu model. We need to understand what we do with those
> latter (SVE, ...). This means that related KVM ioctl are
> not called yet.

It will be pretty painful to have to use different feature
terminology for different CPU models. Everything in libvirt
assuming feature terminology varies per-arch, not per-CPU
model.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

