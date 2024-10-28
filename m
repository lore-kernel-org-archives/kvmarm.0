Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B60F188938
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 16:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730132421; cv=none; b=n0/9kNxAHYQdb7PbfUj0RtWHm6F5t3ruKDvY0lhkn7/UdmFeY/UE8MkvCnDAXIP0eox9pG3BUQxLVKh/GfjNapPoyQNzoCFa/6+bF2GjUzfbBOfPUyriW0U5js1+NS9g2HwEwlgDQitmhmd0268Fpp5ceYr5z/mjHTUKCgOtp6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730132421; c=relaxed/simple;
	bh=AXS0wbv4+wpG1h4CtwFqxYTL8Prku02Keuy5qTDSpNE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YJ9KlfuoKAxkAwvQNHwix0ftzDmlQVAviAT77YTf/wSRDv76xfhGXstBjXejJoexf5oOAF6RmxnuTX772vKXjdfH7KGbEJEMUJTg3y65cJ4MXxWRKgUHC+6HyiYuHlr1qeqmxELSJ2bd8h+0Ig47jZSB38wfj4cHJ6AYn/qPoBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FwaaEhe7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FwaaEhe7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730132418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wEB65em+UxE9CbH8ToQp/Aqsq3Gdimrn9NbYT5ZTZiM=;
	b=FwaaEhe7hDt683aNENrmcHRkhOdvLz3K3zGelvR16ybwq1LuIGaoOORuEYkw6UNrhHCk4l
	+t4LP6mXQB1xkPhFw+JkDK1jBqS01S5nACtALxZG2Mk0686aNu2KyAI2BtnkK2BXky/asp
	ZjCCOfupdB536d7uK+90ITd9ewVhH5I=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-561-mT4IjqerP4OirGAA0p4R0Q-1; Mon,
 28 Oct 2024 12:20:13 -0400
X-MC-Unique: mT4IjqerP4OirGAA0p4R0Q-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E24C61956048;
	Mon, 28 Oct 2024 16:20:11 +0000 (UTC)
Received: from localhost (unknown [10.22.88.106])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A46F1956054;
	Mon, 28 Oct 2024 16:20:09 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Kashyap Chamarthy <kchamart@redhat.com>, Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [RFC 00/21] kvm/arm: Introduce a customizable aarch64 KVM host
 model
In-Reply-To: <ZxuwZw2plMI6dNyE@pinwheel>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <ZxuwZw2plMI6dNyE@pinwheel>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 28 Oct 2024 17:20:07 +0100
Message-ID: <87v7xcnqrs.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Fri, Oct 25 2024, Kashyap Chamarthy <kchamart@redhat.com> wrote:

> On Fri, Oct 25, 2024 at 12:17:19PM +0200, Eric Auger wrote:
>
> Hi Eric,
>
> I'm new to Arm, so please bear with my questions :)
>
>> This RFC series introduces a KVM host "custom" model.
>
> (a) On terminology: as we know, in the x86 world, QEMU uses these
>     terms[1]:
>
>     - Host passthrough
>     - Named CPU models
>     - Then there's the libvirt abstraction, "host-model", that aims to
>       provide the best of 'host-passthrough' + named CPU models.
>
>     Now I see the term "host 'custom' model" here.  Most
>     management-layer tools and libvirt users are familiar with the
>     classic terms "host-model" or "custom".  If we now say "host
>     'custom' model", it can create confusion.  I hope we can settle on
>     one of the existing terms, or create a new term if need be.
>
>     (I'll share one more thought on how layers above libvirt tend to use
>     the term "custom", as a reply to patch 21/21, "arm/cpu-features:
>     Document custom vcpu model".)

I came up with the "custom" name just to have something to differentiate
from the currently existing "host" model (which supports a number of
properties that do not translate to id regs.) It is certainly not set in
stone; I expect us to end up with named models and a handling of the
"host" model which is more similar to what is done for other
archs. Maybe we can then rename "custom" to "franken" so that people do
not try to use it for productive work ;)

>
> (b) The current CPU features doc[2] for Arm doesn't mention "host
>     passthrough" at all.  It is only implied by the last part of this
>     paragraph, from the section titled "A note about CPU models and
>     KVM"[3]:
>
>       "Named CPU models generally do not work with KVM. There are a few
>       cases that do work [...] but mostly if KVM is enabled the 'host'
>       CPU type must be used."
>
>     Related: in your reply[4] to Dan in this series, you write: "Having
>     named models is the next thing".  So named CPU models will be a
>     thing in Arm, too?  Then the above statement in the Arm
>     'cpu-features' will need updating :-)

The currently existing named models are for cpus like cortex-a57; you
can use them for KVM if you happen to run on a matching host cpu, but
they only really make sense for use with tcg.

I currently think that an Armv9.0 or whatever model would make the most
sense, but that's certainly still up for discussion :)

