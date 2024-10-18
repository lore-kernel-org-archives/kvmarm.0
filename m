Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD938F6B
	for <kvmarm@lists.linux.dev>; Fri, 18 Oct 2024 12:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729254513; cv=none; b=DajhBDps6GEFCBoLtiYD1I9aAghPbzrd5ihhyTNRgUBvhbnUxH0rA0nqnU1ChF9WKwj3oHBMXIEtDmy6jMVttIMqJ6q0gOo3Ql/2FODG05R4xZ7aEJtslrRhqwPou9A2iqLtiEcg7WgrubXkWcP+p2gyWtms3LG5QLtDCeXOGbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729254513; c=relaxed/simple;
	bh=HTx1e4+FqZdbWBlTaataaPFfVBg/W9B273TF5RHlDpc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=DU4WsR8hN7Elr8mkWE+Gt9/hCFYPMEE3ZHy4z22ilZ6tBwR5daRytU0aVpp7YcraM0eK/YLVmFcnQyFk+rMstpVvhBvqoSCaVckezSrf9bFLHXjdFMyoyyq7MorP6kgBolwZgskACxglUGh9xt9zdH02I+etFv4Rz8nQoxuk2Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M5VZDLXr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M5VZDLXr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729254510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NG7zGDxhiPRDpcFZR5Y55rGJs4/cOwK4rTpIZ8xc9yA=;
	b=M5VZDLXrjifXdPhDah+3ZEBM2/1Cx6b2NdB1+LMZlkcQjhFSUxMjZmMP/6pXaCFA5UotwW
	FSzxqXnQp0bW0usMyFdANvvAtTHMEKXpJvJ9k4pt8CpfIeQgXe+U6QwXa7ikDRMq4RtJoI
	70ClSwsKboG4e3tPraX59tYovqQ4e6A=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-449-RgX3D5w1MKiSZnhc_agrwQ-1; Fri,
 18 Oct 2024 08:28:27 -0400
X-MC-Unique: RgX3D5w1MKiSZnhc_agrwQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 68AF819560AE;
	Fri, 18 Oct 2024 12:28:24 +0000 (UTC)
Received: from localhost (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D1C1A195607C;
	Fri, 18 Oct 2024 12:28:21 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>, Oliver Upton
 <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
 <will@kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>,
 yuzenghui <yuzenghui@huawei.com>, "Wangzhou (B)"
 <wangzhou1@hisilicon.com>, jiangkunkun <jiangkunkun@huawei.com>, Jonathan
 Cameron <jonathan.cameron@huawei.com>, Anthony Jebson
 <anthony.jebson@huawei.com>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, Linuxarm <linuxarm@huawei.com>
Subject: RE: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
 migration
In-Reply-To: <432569c372284ddba8ed29f09595390e@huawei.com>
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
 <08261a41b9644f5ab49063824e4060c3@huawei.com> <87bjziraou.fsf@redhat.com>
 <7df21c56-0b07-4112-839e-ef90c5999fcd@redhat.com>
 <432569c372284ddba8ed29f09595390e@huawei.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 18 Oct 2024 14:28:19 +0200
Message-ID: <875xppr3x8.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

On Fri, Oct 18 2024, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

>> -----Original Message-----
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: Thursday, October 17, 2024 6:16 PM
>> To: Cornelia Huck <cohuck@redhat.com>; Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com>; Oliver Upton
>> <oliver.upton@linux.dev>; Marc Zyngier <maz@kernel.org>
>> Cc: kvmarm@lists.linux.dev; catalin.marinas@arm.com; will@kernel.org;
>> mark.rutland@arm.com; yuzenghui <yuzenghui@huawei.com>; Wangzhou
>> (B) <wangzhou1@hisilicon.com>; jiangkunkun
>> <jiangkunkun@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>; Anthony Jebson
>> <anthony.jebson@huawei.com>; linux-arm-kernel@lists.infradead.org;
>> Linuxarm <linuxarm@huawei.com>
>> Subject: Re: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
>> migration
>> 
>> Hi Shameer,
>> 
>> On 10/17/24 17:49, Cornelia Huck wrote:
>> > On Fri, Oct 11 2024, Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com> wrote:
>> >
>> >>> -----Original Message-----
>> >>> From: Oliver Upton <oliver.upton@linux.dev>
>> >>> Sent: Friday, October 11, 2024 4:11 PM
>> >>> To: Marc Zyngier <maz@kernel.org>
>> >>> Cc: Shameerali Kolothum Thodi
>> >>> <shameerali.kolothum.thodi@huawei.com>; kvmarm@lists.linux.dev;
>> >>> catalin.marinas@arm.com; will@kernel.org; mark.rutland@arm.com;
>> >>> cohuck@redhat.com; eric.auger@redhat.com; yuzenghui
>> >>> <yuzenghui@huawei.com>; Wangzhou (B)
>> <wangzhou1@hisilicon.com>;
>> >>> jiangkunkun <jiangkunkun@huawei.com>; Jonathan Cameron
>> >>> <jonathan.cameron@huawei.com>; Anthony Jebson
>> >>> <anthony.jebson@huawei.com>; linux-arm-kernel@lists.infradead.org;
>> >>> Linuxarm <linuxarm@huawei.com>
>> >>> Subject: Re: [RFC PATCH 0/6] KVM: arm64: Errata management for VM
>> Live
>> >>> migration
>> >>>
>> >>> On Fri, Oct 11, 2024 at 12:43:28PM +0100, Marc Zyngier wrote:
>> >>>> On Fri, 11 Oct 2024 11:57:10 +0100, Shameerali Kolothum Thodi
>> >>> <shameerali.kolothum.thodi@huawei.com> wrote:
>> >>>>>>> Please take a look and let me know your thoughts.
>> >>>>>> Having eyeballed this very superficially, I think we can do
>> something
>> >>>>>> simpler, and maybe more future-proof:
>> >>>>> Thanks Marc for taking a look and the quick feedback.
>> >>>> No worries, that's the least I could do given that you put the effort
>> >>>> implementing my silly ideas! ;-)
>> >>>>
>> >>>>>> - I don't think KVM should be concerned about the description of
>> the
>> >>>>>>   target CPUs. The hypercall you defined is the right thing to do,
>> >>>>>>   but the VMM should completely handle it. That's an
>> implementation
>> >>>>>>   detail, but it would make things much simpler.
>> >>>>> Ok. So does that mean the hypercall will use some sort of shared
>> >>> memory
>> >>>>> to retrieve the list of target CPUs from VMM?
>> >>>> Two possibilities:
>> >>>>
>> >>>> - either shared memory, in which case the hypercall would require the
>> >>>>   guest to give an IPA and size for the VMM to write its stuff into
>> >>>>   the guest memory,
>> >>>>
>> >>>> - or more simply return the data as an MIDR/REVIDR pair in registers,
>> >>>>   the guest requesting an index, and getting an error when out of
>> >>>>   range, leaving it with the freedom to organise the storage.
>> >>>>
>> >>>> The second option is a bit slower, but way simpler, and it only
>> >>>> happens once per guest boot, so it would probably be my preferred
>> >>>> option unless this is proved to be impractical.
>> >>> Also worth noting there's existing UAPI [*] for allowing userspace to
>> >>> register range(s) of hypercalls that it services directly. It's a bit
>> >>> weird that we'd allow userspace to do stuff in KVM's own hypercall
>> >>> range, but I don't think it really matters at this point since this is
>> >>> all prototyping.
>> >>>
>> >>> [*]: https://docs.kernel.org/virt/kvm/devices/vm.html#attribute-kvm-
>> arm-
>> >>> vm-smccc-filter-w-o
>> >> Thanks. Yes and there are attempts to add that handling in Qemu[*] in
>> the context
>> >> of vCPU hotplug support(PSCI related ones though).  Will take a look.
>> >>
>> >> Thanks,
>> >> Shameer
>> >> [1] https://lore.kernel.org/qemu-devel/20241009033704.250287-1-
>> salil.mehta@huawei.com/
>> > Speaking of QEMU: Do you maybe already have some prototype code that
>> > tries to do something with the setup here? (I don't think QEMU currently
>> > mucks around with MIDR and friends when running with KVM; I wonder
>> what
>> > it should provide to the guest and if it should care to set something as
>> > a base level that gives guests not using the hypercall a chance to work
>> > properly.)
>
> I had a hacked Qemu to test this RFC. Nothing fancy but just to verify the  RFC.
> It basically adds a named CPU to virt as below,
>
> 1. Checks the host MIDR and REVIDR and if it is one of the supported platforms,
>    use the writable register interface to update the ID registers with a common
>    minimum    feature list.
> 2. Use the IOCTL in this RFC to update the target CPU list info.
> 3. Ignore the invariant register SET errors.

Thanks for sharing this information (no need to share the code, I
usually do not want to share my hacked-together-for-testing code, either
:)

>
>> >
>> As discussed during the KVM forum we are working on a qemu integration
>> for writable ID regs. The first goal is to be able to specialize the
>> host passthrough model (custom host model). Maybe this will trigger more
>> discussions on named models too. This is complementary to the
>> MIDR/REVIDR problematic and I hope we will be able to consolidate our
>> works at some point.
>
> Cool!. Happy to know that it is making progress. Once I rework this RFC based on the
> suggestions, I will rework the Qemu to have a hacked prototype to test it as well and
> probably can share that.

The reason I asked was mostly to get a feel about how you wanted to end
up using the interface. Did I understand correctly that you derive your
custom set of features from whatever comes as common features with the
MIDR/REVIDR, and do not treat "frankencpu with features common across
all possible targets" and "list of MIDR/REVIDR for all possible targets"
separately and tack them together in the end? It would also be
interesting to discuss what actual named models could look like (models
we could use for baselining etc.) But that's probably something that
needs to be discussed on qemu-devel anyway, and I certainly don't want
to derail the discussions about the KVM changes. (Agreeing on QEMU
interfaces is going to take a lot of work anyway :)

>
> Please keep me in loop if you have plans to share your Qemu work soon. That will
> be very helpful.
>
> Thanks,
> Shameer

