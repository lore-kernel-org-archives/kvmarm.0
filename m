Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CCB1DED4F
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729180213; cv=none; b=M2y1ykcvAipcCy2Uf9M0S+0Wj9jJiiWGnzZkjp7o3BlFYSqvNxrQXoTTiyNEWdIDaUgzsr3vrGl2aCr1cVTKF8QvB9M+k2udZh5lQzTWB/F5nkTcoaZFSHuvzT+wDkk7gl572iDL9oM2oIwUN9O+7JtHgpfe9ChAd9DXdQUWROI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729180213; c=relaxed/simple;
	bh=g776Yee/+LxdoaGv+CjSjTiSnqa/SMcgSTdt3Sdu+24=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gB21GrToM4KGM06gNis/E+rMYrsZPABdRqdiesLerxnAvUi/jb6pjVqN09kwVCpo5aI3YHi9W+uxGG/HDbUFBqCsQdQOmW2MNNWJiopDL9sSOKycpNy5yO2Adg3Q1H2Gwx0I+Umdv7U9CHXIkr5CdfxvqCHzl0AOIplijZdfrYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=chPK1yJu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="chPK1yJu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729180207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6hNvVkE15DnCxqx2pKiUWEQ26XlDg4qXsXTpA0aX9UY=;
	b=chPK1yJu8Ip3AxTcP5LLbq09aqmNS2/k2Sk8rixpefnWFA85iPCKwEXL/4Lls5LyKK3zMT
	t1cw0VVTo2V7Lmk8pL3tt3rXxfPkZZsXBWSVvDgB2r99ma96md0dHusQw8/SNCnvCZX2sb
	3IwoGBE9icSayB61V7GSNKzv8THHZYI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-410-d0yVcna0N36ImNywZgYbxg-1; Thu,
 17 Oct 2024 11:50:02 -0400
X-MC-Unique: d0yVcna0N36ImNywZgYbxg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F38219560B6;
	Thu, 17 Oct 2024 15:49:59 +0000 (UTC)
Received: from localhost (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BFF219560A2;
	Thu, 17 Oct 2024 15:49:55 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Oliver
 Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
 <will@kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>, yuzenghui
 <yuzenghui@huawei.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>,
 jiangkunkun <jiangkunkun@huawei.com>, Jonathan
 Cameron <jonathan.cameron@huawei.com>, Anthony Jebson
 <anthony.jebson@huawei.com>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, Linuxarm <linuxarm@huawei.com>
Subject: RE: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
 migration
In-Reply-To: <08261a41b9644f5ab49063824e4060c3@huawei.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
 <86jzef53iz.wl-maz@kernel.org>
 <3f4469c49625413f9ab2c224d0d3fbea@huawei.com>
 <86ikty6f1b.wl-maz@kernel.org> <ZwlADbp-HjkijElX@linux.dev>
 <08261a41b9644f5ab49063824e4060c3@huawei.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Thu, 17 Oct 2024 17:49:53 +0200
Message-ID: <87bjziraou.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

On Fri, Oct 11 2024, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

>> -----Original Message-----
>> From: Oliver Upton <oliver.upton@linux.dev>
>> Sent: Friday, October 11, 2024 4:11 PM
>> To: Marc Zyngier <maz@kernel.org>
>> Cc: Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com>; kvmarm@lists.linux.dev;
>> catalin.marinas@arm.com; will@kernel.org; mark.rutland@arm.com;
>> cohuck@redhat.com; eric.auger@redhat.com; yuzenghui
>> <yuzenghui@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>;
>> jiangkunkun <jiangkunkun@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>; Anthony Jebson
>> <anthony.jebson@huawei.com>; linux-arm-kernel@lists.infradead.org;
>> Linuxarm <linuxarm@huawei.com>
>> Subject: Re: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
>> migration
>> 
>> On Fri, Oct 11, 2024 at 12:43:28PM +0100, Marc Zyngier wrote:
>> > On Fri, 11 Oct 2024 11:57:10 +0100, Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com> wrote:
>> > > > >
>> > > > > Please take a look and let me know your thoughts.
>> > > >
>> > > > Having eyeballed this very superficially, I think we can do something
>> > > > simpler, and maybe more future-proof:
>> > >
>> > > Thanks Marc for taking a look and the quick feedback.
>> >
>> > No worries, that's the least I could do given that you put the effort
>> > implementing my silly ideas! ;-)
>> >
>> > > > - I don't think KVM should be concerned about the description of the
>> > > >   target CPUs. The hypercall you defined is the right thing to do,
>> > > >   but the VMM should completely handle it. That's an implementation
>> > > >   detail, but it would make things much simpler.
>> > >
>> > > Ok. So does that mean the hypercall will use some sort of shared
>> memory
>> > > to retrieve the list of target CPUs from VMM?
>> >
>> > Two possibilities:
>> >
>> > - either shared memory, in which case the hypercall would require the
>> >   guest to give an IPA and size for the VMM to write its stuff into
>> >   the guest memory,
>> >
>> > - or more simply return the data as an MIDR/REVIDR pair in registers,
>> >   the guest requesting an index, and getting an error when out of
>> >   range, leaving it with the freedom to organise the storage.
>> >
>> > The second option is a bit slower, but way simpler, and it only
>> > happens once per guest boot, so it would probably be my preferred
>> > option unless this is proved to be impractical.
>> 
>> Also worth noting there's existing UAPI [*] for allowing userspace to
>> register range(s) of hypercalls that it services directly. It's a bit
>> weird that we'd allow userspace to do stuff in KVM's own hypercall
>> range, but I don't think it really matters at this point since this is
>> all prototyping.
>> 
>> [*]: https://docs.kernel.org/virt/kvm/devices/vm.html#attribute-kvm-arm-
>> vm-smccc-filter-w-o
>
> Thanks. Yes and there are attempts to add that handling in Qemu[*] in the context
> of vCPU hotplug support(PSCI related ones though).  Will take a look.
>
> Thanks,
> Shameer
> [1] https://lore.kernel.org/qemu-devel/20241009033704.250287-1-salil.mehta@huawei.com/

Speaking of QEMU: Do you maybe already have some prototype code that
tries to do something with the setup here? (I don't think QEMU currently
mucks around with MIDR and friends when running with KVM; I wonder what
it should provide to the guest and if it should care to set something as
a base level that gives guests not using the hypercall a chance to work
properly.)

