Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217531D89ED
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 09:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733996218; cv=none; b=CK51ytUbipMI8UknfQjDHIlHU2aMZ33sNm43kOrqW/TtLZ9s+ahnDlfz208/UW4GW6zuqrgzHd4wow5CO43aENeK2MlC65okZ/1VMIBx88NNthKpWxViD6hVDk54UQ+yb3UconsRlqKQy2kTmPftyrtABT+SZ2Q7jGE/2HCVqIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733996218; c=relaxed/simple;
	bh=F/9NQDt38feaPbPQYRMs0zXk6yk25jzB2X8DSYiVh5U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gFmqgg2Ws/2NHPp4Pjn6lvbOax1KAm9ZXUGytjE9Wynl6rP7A/qCARvAc5nvcrbKLzox/WQHXBSRfBj0Sv23T5xDnwA1wFxsCpUA/VFZ4Oc0QHOX0PXNRhZlAbxcae7sRHBefGh3Y0QrBGDGQfSwZpHSn0OGtx1oreWTG0dH7bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BOGZRkdV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BOGZRkdV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733996215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0le+hEokhYiZAYCKfki7cLSm1RRAIf5/On72KterXG0=;
	b=BOGZRkdVr0Y/VYeDLXD7bW2nm7qVeQSeqoSfhaDRMlQCBIFMi22siBXVXZt9kS5bosc6yQ
	rQc7zBqYd84JLmiVrQS4WIeyECKPwtGpYBNTsndc0qnknFwH8872KlG4CkDWnIW6W7eIa9
	6rf/u53p7hgxAL8Jrw5peOJtBsNJhJ0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-aOovSca8PIOFOobEMdvSpQ-1; Thu,
 12 Dec 2024 04:36:52 -0500
X-MC-Unique: aOovSca8PIOFOobEMdvSpQ-1
X-Mimecast-MFC-AGG-ID: aOovSca8PIOFOobEMdvSpQ
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA4BA19560BD;
	Thu, 12 Dec 2024 09:36:49 +0000 (UTC)
Received: from localhost (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B1B530044C1;
	Thu, 12 Dec 2024 09:36:47 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, Eric Auger
 <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 abologna@redhat.com, jdenemar@redhat.com, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH RFCv2 00/20] kvm/arm: Introduce a customizable aarch64
 KVM host model
In-Reply-To: <Z1qoa8yXscTSAJ9e@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241206112213.88394-1-cohuck@redhat.com>
 <edc12140-6345-4868-938d-c80c4d2c2004@redhat.com>
 <Z1qoa8yXscTSAJ9e@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Thu, 12 Dec 2024 10:36:45 +0100
Message-ID: <8734it1bv6.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Dec 12 2024, Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:

> On Thu, Dec 12, 2024 at 09:12:33AM +0100, Eric Auger wrote:
>> Connie,
>>=20
>> On 12/6/24 12:21, Cornelia Huck wrote:
>> > A respin/update on the aarch64 KVM cpu models. Also available at
>> > gitlab.com/cohuck/qemu arm-cpu-model-rfcv2
>
> snip
>
>> From a named model point of view, since I do not see much traction
>> upstream besides Red Hat use cases, targetting ARM spec revision
>> baselines may be overkill. Personally I would try to focus on above
>> models: AltraMax, AmpereOne, Grace, ... Or maybe the ARM cores they may
>> be derived from.
>
> If we target modelling of vendor named CPU models, then beware that
> we're opening the door to an very large set (potentially unbounded)
> of named CPU models over time. If we target ARM spec baselines then
> the set of named CPU models is fairly modest and grows slowly.
>
> Including ARM spec baselines will probably reduce the demand for
> adding vendor specific named models, though I expect we'll still
> end up wanting some, or possibly even many.
>
> Having some common baseline models is likely useful for mgmt
> applications in other ways though.
>
> Consider you mgmt app wants to set a CPU model that's common across
> heterogeneous hardware. They don't neccessarily want/need to be
> able to live migrate between heterogeneous CPUs, but for simplicity
> of configuration desire to set a single named CPU across all guests,
> irrespective of what host hey are launched on. The ARM spec baseline
> named models would give you that config simplicity.

If we use architecture extensions (i.e. Armv8.x/9.x) as baseline, I'm
seeing some drawbacks:
- a lot of work before we can address some specific use cases
- old models can get new optional features
- a specific cpu might have a huge set of optional features on top of
  the baseline model

Using a reference core such as Neoverse-V2 probably makes more sense
(easier to get started, less feature diff?) It would still make a good
starting point for a simple config.

