Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5682185AF
	for <kvmarm@lists.linux.dev>; Fri, 11 Oct 2024 14:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728656085; cv=none; b=q/AmL80QWx5HKIw34LVEQc0EaXOGPQ7Ktako03ozgwNbghLOUKgLmG1h5IKYsYXQpBt3d0814/FcoQY6dCWi2bKRfy/ELV7HzsFxJ6LpXYHNAIf2OqdZ8qL4VwUnSvjKTGF1OirQN66YmQgm/G85mRAN0iQkoSP/8ENkHkUxDYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728656085; c=relaxed/simple;
	bh=KuEvSXWchR6WvW2acuAOXk78Epu080AQjYkaoqRyzSs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KJXxFL5tCzJckKxZNB806dNEPJn0CxCHTWbDQplpnV/b2OA9ra3HvFvHvg61jRDvL+7HIIGIxLM7M669e5TkuNckclpNh4lROJooc1fKPxbyvvNo5luJFrMXt92/LkkMZfNYwcfjKRDVp/OaAShFWUduHB0+TYK54CZWvoMyfNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eEwm4ZO1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eEwm4ZO1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728656082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+6TCPgkIuI75pPPy7xgIkD4f7dDd4S1TDJrEU/GmgCI=;
	b=eEwm4ZO1aYimS2dKnKhYBdLmPgBl8feT1BsNnL1Q4HgJcdCZSKRh+3Kneur5xrgSZnDpx+
	pLji3NUbEMc5tmpS6sr/QvOVRsWM6sNXcWupd7Iwdb8yWMc8E0bz+X/328RrVZgB3R3HqX
	Y/mXdst2jGSYTCqQ3QfQ0Ku2iN0Oa1E=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-231-G52hpAYRO-6yNatmDDkiIQ-1; Fri,
 11 Oct 2024 10:14:41 -0400
X-MC-Unique: G52hpAYRO-6yNatmDDkiIQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC4B11955F77;
	Fri, 11 Oct 2024 14:14:38 +0000 (UTC)
Received: from localhost (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1511619560AA;
	Fri, 11 Oct 2024 14:14:35 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "maz@kernel.org"
 <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Cc: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
 <will@kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>, yuzenghui
 <yuzenghui@huawei.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>,
 jiangkunkun <jiangkunkun@huawei.com>, Jonathan Cameron
 <jonathan.cameron@huawei.com>, Anthony Jebson <anthony.jebson@huawei.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, Linuxarm <linuxarm@huawei.com>
Subject: RE: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
 migration
In-Reply-To: <54afcc8182d341d8ab294d8a54c1fbf3@huawei.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
 <87jzeerd6z.fsf@redhat.com> <54afcc8182d341d8ab294d8a54c1fbf3@huawei.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 11 Oct 2024 16:14:33 +0200
Message-ID: <87h69irak6.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

On Fri, Oct 11 2024, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

>> -----Original Message-----
>> From: Cornelia Huck <cohuck@redhat.com>
>> Sent: Friday, October 11, 2024 2:18 PM
>> To: Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com>; kvmarm@lists.linux.dev;
>> maz@kernel.org; oliver.upton@linux.dev
>> Cc: catalin.marinas@arm.com; will@kernel.org; mark.rutland@arm.com;
>> eric.auger@redhat.com; yuzenghui <yuzenghui@huawei.com>; Wangzhou
>> (B) <wangzhou1@hisilicon.com>; jiangkunkun
>> <jiangkunkun@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>; Anthony Jebson
>> <anthony.jebson@huawei.com>; linux-arm-kernel@lists.infradead.org;
>> Linuxarm <linuxarm@huawei.com>
>> Subject: Re: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
>> migration
>> 
>> On Fri, Oct 11 2024, Shameer Kolothum
>> <shameerali.kolothum.thodi@huawei.com> wrote:
>> 
>> > Hi,
>> >
>> > On ARM64 platforms most of the errata workarounds are based on CPU
>> > MIDR/REVIDR values and a number of these workarounds need to be
>> > implemented by the Guest kernel as well. This creates a problem when
>> > Guest needs to be migrated to a platform that differs in these
>> > MIDR/REVIDR values even if the VMM can come up with a common
>> minimum
>> > feature list for the Guest using the recently introduced "Writable
>> > ID registers" support.
>> >
>> > (This is roughly based on a discussion I had with Marc and Oliver
>> > at KVM forum. Marc outlined his idea for a solution and this is an
>> > attempt to implement it. Thanks to both and I take all the blame
>> > if this is nowhere near what is intended/required)
>> >
>> > This RFC proposes a solution to handle the above issue by introducing
>> > the following,
>> >
>> > 1. A new VM IOCTL,
>> >    KVM_ARM_SET_MIGRN_TARGET_CPUS  _IOW(KVMIO,  0xb7, struct
>> kvm_arm_migrn_cpus)
>> >    This can be used by the userspace(VMM) to set the target CPUs the
>> >    Guest will run in its lifetime. See patch #2
>> > 2. Add hypercall support for Guest kernel to retrieve any migration
>> >    errata bitmap(ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_ERRATA)
>> >    The above will return the bitmaps in R0-R3 registers. See patch #4
>> > 3. The "capability" field in struct arm64_cpu_capabilities is a generated
>> >    one at present and may get renumbered or reordered. Hence, we can't
>> use
>> >    this directly for migration errata bitmaps. Instead, introduced
>> >    "migartion_safe_cap", which has to be set statically for any
>> >    erratum that needs to be enabled and is safe for migration
>> >    purposes. See patches 3 & 6.
>> > 4. Rest of the patches includes the plumbing required to populate the
>> >    errata bitmap based on the target CPUs set by the VMM and update the
>> >    system_cap based on it.
>> >
>> > ToDos:-
>> >   -We still need a way to  handle the error in setting the invariant
>> >    registers(MIDR/REVIDR/AIDR) during Guest migration. Perhaps we can
>> >    handle it in userspace?
>> > -  Possibly we could do better to avoid the additional
>> "migartion_safe_cap" use.
>> >    Suggestions welcome.
>> >   -There are errata that require more than MIDR/REVIDR, eg: CTR_EL0.
>> >    How to handle those?
>> >   -Check for locking requirements if any.
>> >
>> > This is lightly tested on a HiSilicon ARM64 platform.
>> >
>> > Please take a look and let me know your thoughts.
>> 
>> So, I've only taken a very quick look at it, but IIUC, the idea is for
>> the VMM to do the following:
>> - figure out where we want to possibly run
>
>
> Yes.
>
>> - figure out the least common denominator for writable features
>
> Yes
>
>> - tell KVM about the possible target cpu resp. the errata it wants
>
> This might change as per Marc's comments. VMM has to handle hypercall
> directly and provide the target CPU list to Guest.
>
>> - build a frankencpu via the writable id reg infrastructure, fiddling
>>   with invariant handling as needed?
>
> That is my idea of handling the invariant registers. If the VMM has provided a list of 
> target CPUs for the Guest,  make sure the incoming CPU is part of the list 
> during migration and ignore invariant(MIDR/REVIDR) reg SET errors.

Thanks!

I hope I'll be able to spend some time on this next week.

