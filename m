Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952E020E8
	for <kvmarm@lists.linux.dev>; Wed,  5 Jul 2023 08:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688546943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mejduW6pzyJ5/oq78SQym8Bp3DsXmuWwE5r2XAdQDl8=;
	b=ZcQTMDj3dolLwqNlHmdsu5KoEkEDdv0Bl3eVe/1OY1I1gk0WzMNE6GnIZT20+pMePua1F0
	7rQViWl12KIR3gps7NvNuK1+CPUs7NJTZyTwQajwVWVu7c4R9I6fjFVLG1IjAvzi8cR0s2
	6tVMqDpUSTowaAxQpGa+6HGjyP2gnNo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-plHcPoEfPyicWq02xxyA4Q-1; Wed, 05 Jul 2023 04:48:59 -0400
X-MC-Unique: plHcPoEfPyicWq02xxyA4Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E74B3C100A1;
	Wed,  5 Jul 2023 08:48:58 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 194B41121315;
	Wed,  5 Jul 2023 08:48:57 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>, KVMARM
 <kvmarm@lists.linux.dev>, ARMLinux <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>, Will
 Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, James Morse
 <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki
 K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, Reiji
 Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>,
 Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v4 1/4] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
In-Reply-To: <ZKRC80hb4hXwW8WK@thinky-boi>
Organization: Red Hat GmbH
References: <20230607194554.87359-1-jingzhangos@google.com>
 <20230607194554.87359-2-jingzhangos@google.com>
 <ZJm+Kj0C5YySp055@linux.dev> <874jmjiumh.fsf@redhat.com>
 <ZKRC80hb4hXwW8WK@thinky-boi>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Wed, 05 Jul 2023 10:48:57 +0200
Message-ID: <87o7kq3fra.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3

On Tue, Jul 04 2023, Oliver Upton <oliver.upton@linux.dev> wrote:

> Hi Cornelia,
>
> On Tue, Jul 04, 2023 at 05:06:30PM +0200, Cornelia Huck wrote:
>> On Mon, Jun 26 2023, Oliver Upton <oliver.upton@linux.dev> wrote:
>> 
>> > On Wed, Jun 07, 2023 at 07:45:51PM +0000, Jing Zhang wrote:
>> >> +	brps = FIELD_GET(ID_AA64DFR0_EL1_BRPs_MASK, val);
>> >> +	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs_MASK, val);
>> >> +	if (ctx_cmps > brps)
>> >> +		return -EINVAL;
>> >> +
>> >
>> > I'm not fully convinced on the need to do this sort of cross-field
>> > validation... I think it is probably more trouble than it is worth. If
>> > userspace writes something illogical to the register, oh well. All we
>> > should care about is that the advertised feature set is a subset of
>> > what's supported by the host.
>> >
>> > The series doesn't even do complete sanity checking, and instead works
>> > on a few cherry-picked examples. AA64PFR0.EL{0-3} would also require
>> > special handling depending on how pedantic you're feeling. AArch32
>> > support at a higher exception level implies AArch32 support at all lower
>> > exception levels.
>> >
>> > But that isn't a suggestion to implement it, more of a suggestion to
>> > just avoid the problem as a whole.
>> 
>> Generally speaking, how much effort do we want to invest to prevent
>> userspace from doing dumb things? "Make sure we advertise a subset of
>> features of what the host supports" and "disallow writing values that
>> are not allowed by the architecture in the first place" seem reasonable,
>> but if userspace wants to create weird frankencpus[1], should it be
>> allowed to break the guest and get to keep the pieces?
>
> What I'm specifically objecting to is having KVM do sanity checks across
> multiple fields. That requires explicit, per-field plumbing that will
> eventually become a tangled mess that Marc and I will have to maintain.
> The context-aware breakpoints is one example, as is ensuring SVE is
> exposed iff FP is too. In all likelihood we'll either get some part of
> this wrong, or miss a required check altogether.

Nod, this sounds like more trouble than it's worth in the end.

>
> Modulo a few exceptions to this case, I think per-field validation is
> going to cover almost everything we're worried about, and we get that
> largely for free from arm64_check_features().
>
>> I'd be more in favour to rely on userspace to configure something that
>> is actually usable; it needs to sanitize any user-provided configuration
>> anyway.
>
> Just want to make sure I understand your sentiment here, you'd be in
> favor of the more robust sanitization?

In userspace. E.g. QEMU can go ahead and try to implement the
user-exposed knobs in a way that the really broken configurations are
not even possible. I'd also expect userspace to have a more complete
view of what it is trying to instantiate (especially if code is shared
between instantiating a vcpu for use with KVM and a fully emulated
vcpu -- we probably don't want to go all crazy in the latter case,
either.)

>
>> [1] I think userspace will end up creating frankencpus in any case, but
>> at least it should be the kind that doesn't look out of place in the
>> subway if you dress it in proper clothing.
>
> I mean, KVM already advertises a frankencpu in the first place, so we're
> off to a good start :)

Indeed :)

