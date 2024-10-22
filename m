Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B657F199EA2
	for <kvmarm@lists.linux.dev>; Tue, 22 Oct 2024 10:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594698; cv=none; b=tYgqNWbr8QdNPRQl7VL43mOmiYhKIllhoKITFU4aP6exm5nWnBgzosKbeHk5G2kvP4GqYrBAQWODC6PLD1M5WW2zxOfuzVPxR6oVeXuOdd7H9ni0IrQPdrP9ALA2qo7g9XIwwwG9muje1SaHerH6ew4Z2pVuaG53vH6JIA2SatM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594698; c=relaxed/simple;
	bh=30tgV+bHyc9Puo5Dmw3xzCOVQ5D2q4CdSGEq88MZ61k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=RtuLmfQM3kg13XzMPz0YDofa6g6ZbZ34TFROWzxxjSGyzyW06Xr9jakyHH2ewpaC7oTKsRin02P3q8QNENUZt/IP2FZlJKpffLgwBnVQ79YxAGfajFcnaTeE3BaIv0MYWNl41pEfZB24pHFtJkrBwTIna9nK/6Dl9EtVImdzHFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ECIFPoJ0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ECIFPoJ0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729594695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fp83jOWTpK+zBC4vYT+NPQKNf3GM0RoJxilfK5NsfGA=;
	b=ECIFPoJ0cLSjUs4sftUvUHTM57qNIT8FI/ujBZDKgLTulw+zkoCUJeKxg1HUMPZIC9Txsg
	at69Xoot+GaVX7lw436ScBpDnFKC/P76j+j5dJSR8hIctRVk9Cistnor8JOFqkNmHjoMxm
	heL9j7a4kitjtcrAEkrWWvhZD5ChiFw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-180-QflyPgM8PTmRVh4Zp_ZqlQ-1; Tue,
 22 Oct 2024 06:58:11 -0400
X-MC-Unique: QflyPgM8PTmRVh4Zp_ZqlQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 525F71955F2B;
	Tue, 22 Oct 2024 10:58:08 +0000 (UTC)
Received: from localhost (unknown [10.39.194.115])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8CE8B300018D;
	Tue, 22 Oct 2024 10:58:05 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: eric.auger@redhat.com, Shameerali Kolothum Thodi
 <shameerali.kolothum.thodi@huawei.com>, "kvmarm@lists.linux.dev"
 <kvmarm@lists.linux.dev>, "catalin.marinas@arm.com"
 <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
 "mark.rutland@arm.com" <mark.rutland@arm.com>, yuzenghui
 <yuzenghui@huawei.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>,
 jiangkunkun <jiangkunkun@huawei.com>, Jonathan Cameron
 <jonathan.cameron@huawei.com>, Anthony Jebson <anthony.jebson@huawei.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, Linuxarm <linuxarm@huawei.com>
Subject: Re: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
 migration
In-Reply-To: <ZxKudSBRKfM1OkMK@linux.dev>
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
 <86frot4kki.wl-maz@kernel.org> <ZxKudSBRKfM1OkMK@linux.dev>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 22 Oct 2024 12:58:02 +0200
Message-ID: <87o73cpfph.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

On Fri, Oct 18 2024, Oliver Upton <oliver.upton@linux.dev> wrote:

> On Fri, Oct 18, 2024 at 02:17:17PM +0100, Marc Zyngier wrote:
>> On Thu, 17 Oct 2024 18:16:04 +0100,
>> Eric Auger <eric.auger@redhat.com> wrote:
>> > 
>> > Hi Shameer,
>> > 
>> > On 10/17/24 17:49, Cornelia Huck wrote:
>> 
>> > > Speaking of QEMU: Do you maybe already have some prototype code that
>> > > tries to do something with the setup here? (I don't think QEMU currently
>> > > mucks around with MIDR and friends when running with KVM; I wonder what
>> > > it should provide to the guest and if it should care to set something as
>> > > a base level that gives guests not using the hypercall a chance to work
>> > > properly.)
>> > >
>> > As discussed during the KVM forum we are working on a qemu integration
>> > for writable ID regs. The first goal is to be able to specialize the
>> > host passthrough model (custom host model). Maybe this will trigger more
>> > discussions on named models too. This is complementary to the
>> > MIDR/REVIDR problematic and I hope we will be able to consolidate our
>> > works at some point.
>> 
>> Complementary to the MIDR/REVIDR work, I would also like to make
>> MIDR/REVIDR writable when this scheme is available. Ideally reporting
>> a synthetic CPU description (with MIDR_EL1.Implementer returning 0,
>> and the rest being VMM-specific, but with a clear definition for the
>> IMPDEF fields so that we can version the ABI).
>
> When the VMM is using the hypercall mechanism to describe
> implementations, 100% agree.
>
>> Thoughts?
>
> I think we should go a step further and allow userspace full control of
> known fields in these registers, even for a nonzero Implementer code.
>
> We're already affording userspace full control of what implementation(s)
> the guest sees anyway via hypercalls, so there isn't much left for KVM
> to enforce.
>
> Ignoring errata, it'd let folks spoof an old implementation on newer
> hardware for testing, especially when dealing w/ older software.

So basically, the VMM would have to make a choice which guests it wants
to support? Modern guests, which are aware through the hypercall
interface what is going on and are able to parse any information in our
synthetic MIDR correctly, or older guests, which should be presented
with a MIDR that makes them hopefully act in the way we want it to act?

I guess that would mean that for full migration support between
different hosts, we'd want enlightned guests, and for (some) other
cases, we could generate a configuration that will hopefully work?

(Spoofing for testing things sounds useful regardless.)

