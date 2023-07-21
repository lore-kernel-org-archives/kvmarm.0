Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F76C14F98
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 09:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689932917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RjvyrEQM7aXCO6ILKRYhquPIXIYqhL2c7IVe9Axezuc=;
	b=hUUF6ZpLFuLtLZve3oJVzVhXo5PPjnR9mZiiU2KU0Kcg+uHasK3r2bTdEGg0LXRh04y7Rx
	uIvFibalmhPPWocbhOaVfHAcJkcVVoDvhiWHSOxllEGyfoK0GTVBo27SvKlRx63ebZBK0s
	dDMXekaSnSnWAVc02sHu5bwsKDOSHHA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-4I0gsGDEPkWXs6vJjKvo3A-1; Fri, 21 Jul 2023 05:48:34 -0400
X-MC-Unique: 4I0gsGDEPkWXs6vJjKvo3A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 326F5801CF8;
	Fri, 21 Jul 2023 09:48:33 +0000 (UTC)
Received: from localhost (unknown [10.39.193.38])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CEE7640C206F;
	Fri, 21 Jul 2023 09:48:29 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>, KVMARM
 <kvmarm@lists.linux.dev>, ARMLinux <linux-arm-kernel@lists.infradead.org>,
 Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, Reiji Watanabe
 <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, Suraj
 Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v6 3/6] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
 and ID_DFR0_EL1
In-Reply-To: <86r0p1txun.wl-maz@kernel.org>
Organization: Red Hat GmbH
References: <20230718164522.3498236-1-jingzhangos@google.com>
 <20230718164522.3498236-4-jingzhangos@google.com>
 <87o7k77yn5.fsf@redhat.com>
 <CAAdAUthM6JJ0tEqWELcW48E235EbcjZQSDLF9OQUZ_kUtqh3Ng@mail.gmail.com>
 <87sf9h8xs0.fsf@redhat.com> <86r0p1txun.wl-maz@kernel.org>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Fri, 21 Jul 2023 11:48:27 +0200
Message-ID: <87pm4l8uj8.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1

On Fri, Jul 21 2023, Marc Zyngier <maz@kernel.org> wrote:

> On Fri, 21 Jul 2023 09:38:23 +0100,
> Cornelia Huck <cohuck@redhat.com> wrote:
>> 
>> On Thu, Jul 20 2023, Jing Zhang <jingzhangos@google.com> wrote:
>> > No mechanism was provided to userspace to discover if a given idreg or
>> > any fields of a given idreg is writable. The write to a readonly idreg
>> > can also succeed (write ignored) without any error if what's written
>> > is exactly the same as what the idreg holds or if it is a write to
>> > AArch32 idregs on an AArch64-only system.
>> 
>> Hm, I'm not sure that's a good thing for the cases where we want to
>> support mix-and-match userspace and kernels. Userspace may want to know
>> upfront whether it can actually tweak the contents of an idreg or not
>> (for example, in the context of using CPU models for compatibility), so
>> that it can reject or warn about certain configurations that may not
>> turn out as the user expects.
>> 
>> > Not sure if it is worth adding an API to return the writable mask for
>> > idregs, since we want to enable the writable for all allocated
>> > unhidden idregs eventually.
>> 
>> We'd enable any new idregs for writing from the start in the future, I
>> guess?
>> 
>> I see two approaches here:
>> - add an API to get a list of idregs with their writable masks
>> - add a capability "you can write to all idregs whatever you'd expect to
>>   be able to write there architecture wise", which would require to add
>>   support for all idregs prior to exposing that cap
>> 
>> The second option would be the easier one (if we don't manage to break
>> it in the future :)
>
> I'm not sure the last option is even possible. The architecture keeps
> allocating new ID registers in the op0==3, op1=={0, 1, 3}, CRn==0,
> CRm=={0-7}, op2=={0-7} space, so fields that were RES0 until then
> start having a non-0 value.
>
> This could lead to a situation where you move from a system that
> didn't know about ID_AA64MMFR6_EL1.XYZ to a system that advertises it,
> and for which the XYZ instruction has another behaviour. Bad things
> follow.

Hrm :(

>
> My preference would be a single ioctl that returns the full list of
> writeable masks in the ID reg range. It is big, but not crazy big
> (1536 bytes, if I haven't messed up), and includes the non ID_*_EL1
> sysreg such as MPIDR_EL1, CTR_EL1, SMIDR_EL1.
>
> It would allow the VMM to actively write zeroes to any writable ID
> register it doesn't know about, or for which it doesn't have anything
> to restore. It is also relatively future proof, as it covers
> *everything* the architecture has provisioned for the future (by the
> time that space is exhausted, I hope none of us will still be involved
> with this crap).

Famous last words :)

But yes, that should work. This wouldn't be the first ioctl returning a
long list, and the VMM would just call it once on VM startup to figure
things out anyway.

