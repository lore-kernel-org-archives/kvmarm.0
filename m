Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30525127E18
	for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 15:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715353883; cv=none; b=HXW/RGPtS+oE2yBSRtsujW7zjotyHeJGhQKwF61e0oK77IvvmM0X1C9FkB9kU/e4ObZIS/xrx4Du+O1SKvRlbn6ws5XtvpIK7zve/6mZTEEH5h7mHs3litMlJR204COwCg2SqUQ++UeUgQGsZW7l8ApKw7Lqd0xhgjBKumlaXGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715353883; c=relaxed/simple;
	bh=ztkUBcLcIUpZv28LSxi8b0OilCPoVz6sTePjYkYJv/s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ppIIj1s3uw0qCnSwJhs3zJ10SbcNOZDGGI4ONBmycrDwzhshtRraEphqHbgOhkwUDj/BmXJf+6uDJoz/zpJQH+Zn3xSjxcMc0c15awCjYb0YHKyYHtKfWtxtliJTmYfUtgdAnjJQ6zkqE6Mau5KCk0aT552HAisnNlyxN2lq0hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KBAWrew0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KBAWrew0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715353881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ztkUBcLcIUpZv28LSxi8b0OilCPoVz6sTePjYkYJv/s=;
	b=KBAWrew0axtr3M2O1prJ6cI++wUJwVlR1rlJ943iJKtx9ZEbd+EUmUoSb7lylElP3TwxN4
	4zM+dpn79WnZlZ5QWb9sjA1OIeee0sFajCjomNeSnHhisoHDmP6icNMMrdWFcwiff9TOpp
	jTxAWDpPwz1K0yknG9H3t+6QyXo6/ck=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-669-MT0tNmU0M2mHagOT3kVcWQ-1; Fri,
 10 May 2024 11:11:11 -0400
X-MC-Unique: MT0tNmU0M2mHagOT3kVcWQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BAAA1C0151F;
	Fri, 10 May 2024 15:11:10 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F0ABC20898CA;
	Fri, 10 May 2024 15:11:09 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>, Marc Zyngier
 <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will@kernel.org>, James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH RFC] KVM: arm64: allow ID_MMFR4_EL1 to be writable
In-Reply-To: <Zjuy40shK5a-yp95@linux.dev>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <E1s2DPv-00AhaA-Ra@rmk-PC.armlinux.org.uk>
 <ZjKCgIyWqNKC6TUu@linux.dev> <ZjKFBUXEhwZ7ZmMM@shell.armlinux.org.uk>
 <ZjKRBcAML5T6cm4q@linux.dev> <ZjOl5hwU7yPXk8gs@shell.armlinux.org.uk>
 <ZjPDQSeQPE2wgVup@linux.dev> <87jzk4h5ir.fsf@redhat.com>
 <Zjuy40shK5a-yp95@linux.dev>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 10 May 2024 17:11:09 +0200
Message-ID: <875xvlhfci.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, May 08 2024, Oliver Upton <oliver.upton@linux.dev> wrote:

> Hi Cornelia,
>
> On Wed, May 08, 2024 at 02:06:36PM +0200, Cornelia Huck wrote:
>> On Thu, May 02 2024, Oliver Upton <oliver.upton@linux.dev> wrote:
>> > I think (1) should only be expected of VMMs that want rollback safety,
>> > i.e. the ability to migrate state back to an older kernel. Our userspa=
ce
>> > initializes vCPUs from a fixed set of feature ID register values that
>> > prevents VMs on new kernels from picking up new CPU features.
>> >
>> > It is quite tedious, but necessary as rollback safety is very much a
>> > non-goal of the KVM UAPI.
>>=20
>> Depending on your use case, rollback safety might be quite
>> important... have we ever stated exactly which guarantees the KVM UAPI
>> is giving? IOW, can someone implementing a VMM look at a doc and see
>> "oh, if I want to be able to go backwards, I need to be able to deal
>> with x, y, and z coming up on the new kernel"?
>
> The behavior of KVM/arm64 has always been that new VMs get the maximum
> set of vCPU features supported by KVM / hardware modulo the ones we
> require explicit opt-in from userspace (e.g. SVE, vPMU). This behavior
> is described in the arm64 vCPU feature documentation [1].
>
> The biggest benefit of this approach is that new vCPU features can be
> added without a VMM change, as userspace can just treat the registers in
> KVM_GET_REG_LIST as an opaque blob of data that needs to be migrated.

It also needs to actively turn off everything it does not know how to
handle, if migration between different hardware is supposed to be
supported.

>
> I'm willing to wager that the set of users who want to migrate state
> from kernel N -> (N - 1) know the exact CPU definition they want to
> expose to the guest, and in that case should be using a static set of
> feature register values matching their intent.

I think the trouble starts when we introduce additional ranges of
registers that can be controled via that interface -- old userspace will
be able to figure out that there are more ranges available than what it
is aware of, but will have no idea how to handle those additional ranges
to get into a defined state (what is the actual range, for example?)

>
> Beyond the CPU architecture, KVM presents hypercall features to the VM
> which userspace can _opt-out_ of on a per-feature basis using the
> feature bitmap registers described in [2]. Like the feature ID
> registers, we've preallocated a range of indices to be used for
> hypercall bitmaps. So if an unexpected bitmap register appears on a new
> kernel, userspace should write 0 to it to prevent new features from
> silently creeping in.

Hm, the doc says: "The features for the registers that are untouched,
probably because userspace isn=E2=80=99t aware of them, will be exposed as =
is to
the guest." Seems to indicate that it is not too hard to get this wrong :)

>
> Prescribing the exact combination of these UAPIs to achieve a
> rollback-safe feature set is beyond the scope of the KVM documentation
> and should be determined based on the minimum kernel version that needs
> to work.
>
> [1]: https://docs.kernel.org/virt/kvm/arm/vcpu-features.html#the-id-regis=
ters
> [2]: https://docs.kernel.org/virt/kvm/arm/hypercalls.html
>
>> >> I've been bitten before with KVM differences between kernel versions
>> >> in the past - where the number of registers that userspace sees has
>> >> changed despite being on the same hardware.
>> >
>> > This is intended behavior, as VMs are initialized to the maximum featu=
re
>> > set KVM is able to support. Forward-compatibility for the set of expos=
ed
>> > registers is tested, see the get-reg-list selftest.
>>=20
>> I've seen this problem come up as well; if it is clear that this is
>> something that KVM expects the VMM to handle if needed, that is fine;
>> should we consider "it's tested in a selftest" as a canonical indicator
>> of "this is what KVM supports compatibility wise"?
>
> It certainly is the level of compatibility that gets actively tested :)

:)

>
> The canonical reason for this behavior, though, is that KVM/arm64
> defaults to the maximum-possible feature set as discussed above.

/me contemplating "reverse" features, but too tired to think this
through on a Friday afternoon.

