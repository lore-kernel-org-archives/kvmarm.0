Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73A8823C3
	for <kvmarm@lists.linux.dev>; Wed, 22 May 2024 10:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716372865; cv=none; b=Uf3FehSQ37YmD7ENXZMqIihb9+rb/cTKlVAyNW0scLLnbZ0APlVuAZ0DLmrTGXETuS5nZjZRBJ4zUILpQ8iTfaMw4q9XAHKJIafkZ3i/L43KoINshaLwB78TdhwtKFQm9QRk7PJl7sLrqK2MeaXU1MecARWRnc5gPPSNT1j0e+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716372865; c=relaxed/simple;
	bh=SY4PoGxkZbY9EB+8q6oKpL4YKpeUpsHiiyG7kK8YPgw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fwvWIEgVxjoX27JIJe1wCdUYgLtepW7LfwBFtrhLCC6SQcvIqSFjm8Ro6o5WZ7DFu6HGOMUlHteii8xVEiUbwTe9xYZ8X8n29eK1P0+ZuJIG2/2m4FJIWsvJ7n1b7TVXQXnWKRFWYtKU32BCWsm/u83ZLe8j/NlaGn5442fb7gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bXc6fDO5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bXc6fDO5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716372859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3swaZNhAm3tQcBfbWtUrlmE8bOex+h0YEsXyT/7SdNM=;
	b=bXc6fDO5IuvsPwpRHpXRspRMvn5yM/zn7ZtyZxyfbMgjsa+HlXP+/LhuWyl0rAUUSQb+VX
	HWC7S+7J8h6K8glkJzsjOs9pq/vEjJPTIxGZ84psmk0PswsizJzQrF+W6WcSdokbQsG4MQ
	v/IyvOX4BNymsY/td/GX5zlTgSMOvzo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-d5EhlufyMVCqBOFbqorWyQ-1; Wed, 22 May 2024 06:14:09 -0400
X-MC-Unique: d5EhlufyMVCqBOFbqorWyQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4001B185A78E;
	Wed, 22 May 2024 10:14:09 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 90C3C1C0654B;
	Wed, 22 May 2024 10:14:08 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>, Marc Zyngier
 <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will@kernel.org>, James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH RFC] KVM: arm64: allow ID_MMFR4_EL1 to be writable
In-Reply-To: <ZkKFmvZlFDzJ4Kka@linux.dev>
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
 <Zjuy40shK5a-yp95@linux.dev> <875xvlhfci.fsf@redhat.com>
 <ZkKFmvZlFDzJ4Kka@linux.dev>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Wed, 22 May 2024 12:14:07 +0200
Message-ID: <87r0du6tn4.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, May 13 2024, Oliver Upton <oliver.upton@linux.dev> wrote:

[apologies for the late reply]

> On Fri, May 10, 2024 at 05:11:09PM +0200, Cornelia Huck wrote:
>> On Wed, May 08 2024, Oliver Upton <oliver.upton@linux.dev> wrote:
>> > I'm willing to wager that the set of users who want to migrate state
>> > from kernel N -> (N - 1) know the exact CPU definition they want to
>> > expose to the guest, and in that case should be using a static set of
>> > feature register values matching their intent.
>>=20
>> I think the trouble starts when we introduce additional ranges of
>> registers that can be controled via that interface -- old userspace will
>> be able to figure out that there are more ranges available than what it
>> is aware of, but will have no idea how to handle those additional ranges
>> to get into a defined state (what is the actual range, for example?)
>
> Even though the UAPI was designed around supporting multiple ranges, I
> do not see this being an issue for quite some time. We already fully
> describe the Feature ID register range from the architecture.

Yeah, we're probably fine for the time being, but something to keep in
mind, I guess.

>
>> >
>> > Beyond the CPU architecture, KVM presents hypercall features to the VM
>> > which userspace can _opt-out_ of on a per-feature basis using the
>> > feature bitmap registers described in [2]. Like the feature ID
>> > registers, we've preallocated a range of indices to be used for
>> > hypercall bitmaps. So if an unexpected bitmap register appears on a ne=
w
>> > kernel, userspace should write 0 to it to prevent new features from
>> > silently creeping in.
>>=20
>> Hm, the doc says: "The features for the registers that are untouched,
>> probably because userspace isn=E2=80=99t aware of them, will be exposed =
as is to
>> the guest." Seems to indicate that it is not too hard to get this wrong =
:)
>
> Sure, but keep in mind the full range of possible Feature ID registers is
> already known to userspace. Many of these register encodings are reserved=
,
> RAZ to allow for future expansion of the architecture [*]. New registers
> will come from one of these RAZ encodings.
>
> If userspace wants to assert complete control over the CPU feature set
> exposed to the VM it should use a pre-baked value for every register in
> the range Op0=3D3, Op1=3D0, CRn=3D0, CRm=3D{1-8}, Op2=3D{0-8}.
>
> [*] DDI0487J.a Table D18-2

Might make sense to spell that out?

From 1d952c816d3192a4c2f3d95339aa96d86d3d0406 Mon Sep 17 00:00:00 2001
From: Cornelia Huck <cohuck@redhat.com>
Date: Wed, 22 May 2024 12:01:24 +0200
Subject: [PATCH] KVM: arm64: provide hint about vCPU feature stability

Give userspace some advice on how to achieve a stable feature set.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 Documentation/virt/kvm/arm/vcpu-features.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/virt/kvm/arm/vcpu-features.rst b/Documentation/v=
irt/kvm/arm/vcpu-features.rst
index f7cc6d8d8b74..01973bf8815d 100644
--- a/Documentation/virt/kvm/arm/vcpu-features.rst
+++ b/Documentation/virt/kvm/arm/vcpu-features.rst
@@ -40,6 +40,10 @@ outlined by the architecture in DDI0487J.a D19.1.3 'Prin=
ciples of the ID
 scheme for fields in ID register'. KVM does not allow ID register values t=
hat
 exceed the capabilities of the system.
=20
+As KVM will enable new features by default, userspace that wants to provid=
e a
+stable feature set regardless of the kernel version is advised to supply a
+complete set of values for all of the ID registers.
+
 .. warning::
    It is **strongly recommended** that userspace modify the ID register va=
lues
    before accessing the rest of the vCPU's CPU register state. KVM may use=
 the

>
>> >
>> > The canonical reason for this behavior, though, is that KVM/arm64
>> > defaults to the maximum-possible feature set as discussed above.
>>=20
>> /me contemplating "reverse" features, but too tired to think this
>> through on a Friday afternoon.
>>=20
>
> Reverse as in a negative / removed feature?
>
> These tend to appear as negative ID register fields, to imply that the
> feature set is less than what's provided for with a value of 0x0. KVM
> probably couldn't start deprecating features in the default ID register
> values but userspace could probe for features it can opt-out of using
> the writable mask + trying to write -1 to a field.
>
> DDI0487J.a D19.1.3 covers this.

Yes, that would make the most sense (explicit opt-out from userspace),
the advice from above would still apply.

