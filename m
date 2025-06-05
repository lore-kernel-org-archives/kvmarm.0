Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C819126AD0
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 16:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749141084; cv=none; b=l06jQVyx275pyjVQWS4taUkRXwtbvovwst5MYZEbRM15FOGLvgFUPqTXczyILoyn2GxzxyeFdBxxefmhLuZyqCJQcEpq7mUj1LJkhxzha/umIunk8tx0836QXCiDiaLmyBM/m182IdllLq+QOaroX0E7NO+iL62QU4c03xt+ed4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749141084; c=relaxed/simple;
	bh=bMuErSmST/NDcmyWL59xwfJhqI8xfraq29DPYJGTmNc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=AsuownzuspMjj6ZJFgDnFmKfmNgFiL5M4fafS+F7Zev9Nrjr0ZYqIeuP7AwEzjFNeRQMI0WuwwToTQKTBcfWMQvppeq8GaI/HJvIn5oHRCBnMedwuDUg1HszIQUJFCcUwNpVv1ytLKAyUmvVsXfjKtBh3TZKuy8hUuuSC3auXyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XtTyAuLJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XtTyAuLJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749141081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jH9CaHdji2L1f3dp8GEPNtVV1TXTMcV74nELdv/ss0Q=;
	b=XtTyAuLJ7gpvAS8UKl4L5Qw377kC7PzvBEsFW9ykZmtEslmW2PXpi+VS4qKGJzF+SMEoG9
	KVrRZtCSswTpAKWQpy+oNNYNhKhUAChInPYMqJzEgf4AWK5LlQjoVFfoSVzeZ/zNX2NMHy
	6wZZorPTx2t015ihpBI56n5xWnB9okg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-670-CVVf4lS7Pv-qCoZFLO-JqA-1; Thu,
 05 Jun 2025 12:31:18 -0400
X-MC-Unique: CVVf4lS7Pv-qCoZFLO-JqA-1
X-Mimecast-MFC-AGG-ID: CVVf4lS7Pv-qCoZFLO-JqA_1749141076
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB5461800771;
	Thu,  5 Jun 2025 16:31:15 +0000 (UTC)
Received: from localhost (unknown [10.45.225.217])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1E9CC195E74A;
	Thu,  5 Jun 2025 16:31:13 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>, "qemu-devel@nongnu.org"
 <qemu-devel@nongnu.org>, "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "alex.bennee@linaro.org" <alex.bennee@linaro.org>, "maz@kernel.org"
 <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "sebott@redhat.com" <sebott@redhat.com>, "armbru@redhat.com"
 <armbru@redhat.com>, "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>, "jdenemar@redhat.com"
 <jdenemar@redhat.com>
Cc: "agraf@csgraf.de" <agraf@csgraf.de>, "shahuang@redhat.com"
 <shahuang@redhat.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>,
 "philmd@linaro.org" <philmd@linaro.org>, "pbonzini@redhat.com"
 <pbonzini@redhat.com>
Subject: RE: [PATCH v3 00/10] kvm/arm: Introduce a customizable aarch64 KVM
 host model
In-Reply-To: <58dee0533a40458d9cbd2049c8330c5b@huawei.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250414163849.321857-1-cohuck@redhat.com>
 <de7db6bc22ad4f0a8ac1fac718c810a1@huawei.com> <87bjrfbkyz.fsf@redhat.com>
 <878qmibc5a.fsf@redhat.com> <87tt4wamcp.fsf@redhat.com>
 <f11e5fbddf634bbc88ba4c07bafe3f26@huawei.com> <87o6v3adle.fsf@redhat.com>
 <58dee0533a40458d9cbd2049c8330c5b@huawei.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Thu, 05 Jun 2025 18:31:10 +0200
Message-ID: <87ldq69mlt.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Jun 04 2025, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@h=
uawei.com> wrote:

>> -----Original Message-----
>> From: Cornelia Huck <cohuck@redhat.com>
>> Sent: Wednesday, June 4, 2025 1:36 PM
>> To: Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com>; eric.auger.pro@gmail.com;
>> eric.auger@redhat.com; qemu-devel@nongnu.org; qemu-arm@nongnu.org;
>> kvmarm@lists.linux.dev; peter.maydell@linaro.org;
>> richard.henderson@linaro.org; alex.bennee@linaro.org; maz@kernel.org;
>> oliver.upton@linux.dev; sebott@redhat.com; armbru@redhat.com;
>> berrange@redhat.com; abologna@redhat.com; jdenemar@redhat.com
>> Cc: agraf@csgraf.de; shahuang@redhat.com; mark.rutland@arm.com;
>> philmd@linaro.org; pbonzini@redhat.com
>> Subject: RE: [PATCH v3 00/10] kvm/arm: Introduce a customizable aarch64
>> KVM host model
>>=20
>> On Wed, Jun 04 2025, Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com> wrote:
>>=20
>> >> -----Original Message-----
>> >> From: Cornelia Huck <cohuck@redhat.com>
>> >> Sent: Tuesday, June 3, 2025 4:15 PM
>> >> To: Shameerali Kolothum Thodi
>> >> <shameerali.kolothum.thodi@huawei.com>; eric.auger.pro@gmail.com;
>> >> eric.auger@redhat.com; qemu-devel@nongnu.org; qemu-
>> arm@nongnu.org;
>> >> kvmarm@lists.linux.dev; peter.maydell@linaro.org;
>> >> richard.henderson@linaro.org; alex.bennee@linaro.org;
>> maz@kernel.org;
>> >> oliver.upton@linux.dev; sebott@redhat.com; armbru@redhat.com;
>> >> berrange@redhat.com; abologna@redhat.com; jdenemar@redhat.com
>> >> Cc: agraf@csgraf.de; shahuang@redhat.com; mark.rutland@arm.com;
>> >> philmd@linaro.org; pbonzini@redhat.com
>> >> Subject: RE: [PATCH v3 00/10] kvm/arm: Introduce a customizable
>> aarch64
>> >> KVM host model
>> >>
>> >> On Tue, May 27 2025, Cornelia Huck <cohuck@redhat.com> wrote:
>> >> > The conversion functions are not at fault here, but we're missing
>> >> > registers. If we have MIDR and friends writable, they show up in the
>> >> > masks returned by the kernel, but they are not present in the kerne=
l's
>> >> > sysreg file where we generate our definitions from, and
>> >> > kvm_idx_to_idregs_idx() asserts instead of returning an error, which
>> >> > is kind of suboptimal...
>> >> >
>> >> > So I see two possible ways to fix this:
>> >> > - add MIDR and friends to the kernel's sysreg file
>> >> > - add MIDR and friends in QEMU's cpu-sysregs.h.inc file, and only
>> append
>> >> >   generated definitions there
>> >> >
>> >> > First option means one more round trip, second options has more
>> >> > potential for messing things up if we keep stuff local to QEMU.
>> >>
>> >> With the patch below, things work for me with a 6.15+ kernel. It's a =
bit
>> >
>> > Yes works for me too now. Thanks.
>>=20
>> Thanks for checking.
>>=20
>> >
>> >> messy, though, and raises questions (how do we want to handle those
>> regs
>> >> across accelerators, for example, or how we can make sure that the co=
de
>> is
>> >> more robust when registers are added.)
>> >>
>> >> My biggest question, however, is how this interacts with the framework
>> to
>> >> provide lists of MIDR/REVIDR/AIDR for errata management. The hack
>> below
>> >> adds properties to configure those regs, I guess we'd want to suppress
>> >> adding the props in order to avoid conflicts.
>> >
>> > Not sure how this impacts the errata management though. My initial take
>> on
>> > this was, user will provide a list of target CPU ids through command l=
ine
>> and
>> > that will be used to set the target CPUs for errata management(if kern=
el
>> > supports it).
>> >
>> > Eg:
>> > -machine virt,.., x-target-impl-cpus=3D0xMIDR1:0xREVIDR1-0xMIDR2:REVID=
R2
>>=20
>> I'm a bit confused by the range, I'd rather expect a list of tuples,
>> e.g. <midr>:<revidr>,<midr>:<revidr>, ...
>
> Hmm..is the concern here is the format or the number of entries?

Format of the command line; number of entries is something we can change
later.

>
>>=20
>> >
>> > And these will be stored in,
>> >
>> > #define MAX_TARGET_IMPL_CPUS    4
>> > typedef struct TargetImplCpu {
>> >      uint32_t midr;
>> >      uint32_t revidr;
>>=20
>> Isn't revidr a 64 bit value?
>
> Yes. In fact they both are, though MIDR only uses 32 bits now. Will chang=
e.

It probably should also have aidr, just to be safe. (Even if triplets on
the command line will be a bit ugly.)

>
>>=20
>> > } TargetImplCpu;
>> >
>> >
>> > Please see the initial (a hack for testing kernel) implementation here,
>> >
>> https://github.com/hisilicon/qemu/commit/a393c1180274c73d34f32eaab66
>> 764a874a9ad31
>> >
>> > Please let me know if there is a better/preferred way of obtaining this
>> > target CPU list from user.
>>=20
>> I'm mostly wondering about conflicting values between "we make MIDR et
>> al. writable, so we have a value different from what the host sees" and
>> "we provide a list of possible values to the guest, so it can prepare
>> for running on those hosts". Do we want to be able to provide a common
>> set to the guest, and then enlighten it with the list of systems that it
>> actually *might* run on? A benefit would be that it could always observe
>> the same (configured) register entries, regardless where it runs (needs
>> more plumbing in QEMU, I think.) We'd also need to be clear about what
>> we'd require (i.e. do we expect that both the real host values and the
>> configured values are present in the list?)
>
> The expectation from kernel is that when target errata CPUs are specified,
> it includes the current host CPU Ids as well. We could check to see the l=
ist includes
> the host one. But I am not sure how we can validate the complete list pro=
vided
> by user though. I think,  the onus of deciding which platforms this Guest=
 VM is
> going to run during its life time and specifying that correctly is with t=
he user.

My question was more along the line of "if the user configures MIDR to
something different from the actual host values, do they need to include
that modified value in the list of target cpus as well?" If we disallow
changing MIDR, we'd naturally sidestep that issue.

>
>>=20
>> Not sure if the machine level is the right place to configure this, or
>> if it needs to go to the cpu options. While it is a machine-wide
>> configuration, it also means that we configure some cpu features in two
>> different places (even if they serve a different purpose.)
>
> I exploited MachineState for ease of hacking =F0=9F=98=8A. But not sure t=
his belongs to CPU
> either as it is very specific to KVM is enabled, supported kernel etc.

That's an interesting question :) I think we can keep it with the
machine state for now until we figure out more details -- it's more
important to actually test it out with real life scenarios.

>=20=20
>> We could also choose to not expose properties for MIDR and friends at
>> all, even if they are writable.
>>
>
> Does that mean Qemu figures out all the supported target Ids based on the=
=20
> Host CPU  Ids?

I think the target ids always need to be figured out and provided by the
user (as only they can possibly have an idea on where that guest might
end up running.) The question is more whether we should give the user
the means to directly configure the regs for a certain instance.

