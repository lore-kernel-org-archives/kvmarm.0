Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078C8101E9
	for <kvmarm@lists.linux.dev>; Thu, 27 Jul 2023 09:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690450505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XF4EWqeO3utKlZb4GqfyDhkUV3gjNXvAr/jtDDNki8Y=;
	b=bVw85koDbK2LgG4fsPWOsgZU5lHBwf+gKDZw6fNWAxLLsyKbqg/gA2EIQgRYWDERRr5wyf
	Zsewbthun4WUyuRsQX471qncL0qjSaUJTFkAI0gZ1FVbm+2wN2EqQG+q1781WKpf6Ddwkm
	ts3N92a4gEjZl487bG7r2mySvGJ7eaE=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-fEa3c2g0MEWOSi8fD0qHcw-1; Thu, 27 Jul 2023 05:35:01 -0400
X-MC-Unique: fEa3c2g0MEWOSi8fD0qHcw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 084A91C2BD66;
	Thu, 27 Jul 2023 09:35:01 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA940414A80D;
	Thu, 27 Jul 2023 09:35:00 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Jing Zhang <jingzhangos@google.com>, Marc Zyngier <maz@kernel.org>, KVM
 <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, ARMLinux
 <linux-arm-kernel@lists.infradead.org>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, Reiji Watanabe
 <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, Suraj
 Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v6 3/6] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
 and ID_DFR0_EL1
In-Reply-To: <ZMFWsvWzfkkz2VNB@thinky-boi>
Organization: Red Hat GmbH
References: <20230718164522.3498236-1-jingzhangos@google.com>
 <20230718164522.3498236-4-jingzhangos@google.com>
 <87o7k77yn5.fsf@redhat.com>
 <CAAdAUthM6JJ0tEqWELcW48E235EbcjZQSDLF9OQUZ_kUtqh3Ng@mail.gmail.com>
 <87sf9h8xs0.fsf@redhat.com> <86r0p1txun.wl-maz@kernel.org>
 <CAAdAUtjNW6Q+phGbc6jXWTERRhYo7E3H4Ws0iDSngc17Sac0uA@mail.gmail.com>
 <ZLr0LcQENZmIGMAt@linux.dev> <87edkxg0jr.fsf@redhat.com>
 <ZMFWsvWzfkkz2VNB@thinky-boi>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Thu, 27 Jul 2023 11:34:57 +0200
Message-ID: <878rb166ke.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2

On Wed, Jul 26 2023, Oliver Upton <oliver.upton@linux.dev> wrote:

> Hi Cornelia,
>
> On Mon, Jul 24, 2023 at 10:45:44AM +0200, Cornelia Huck wrote:
>> On Fri, Jul 21 2023, Oliver Upton <oliver.upton@linux.dev> wrote:
>> > What I had in mind was something similar to the KVM_GET_ONE_REG ioctl,
>> > but instead of returning the register value it'd return the mask of the
>> > register. This would keep the kernel implementation dead simple (I'm
>> > lazy) and more easily allow for future expansion in case we want to
>> > start describing more registers this way. Userspace would iterate the ID
>> > register space and ask the kernel for the mask of registers it wants to
>> > change.
>> 
>> Hm... for userspace it might be easier to get one big list and then
>> parse it afterwards? Similar to what GET_REG_LIST does today.
>
> Possibly, but I felt like it was a bit different from GET_REG_LIST since
> this would actually be a list of key-value pairs (reg_id, mask) instead
> of a pure enumeration of IDs. My worry is that if/when we wind up describing
> more registers in this list-based ioctl then userspace is going to wind
> up traversing that structure a lot to find the register masks it actually
> cares about.

Depends on how userspace actually digests it, but point taken.

>
>> Are you thinking more of a KVM_GET_REG_INFO or so ioctl, that could
>> support different kinds of extra info (and might also make sense for
>> other architectures?) If we end up with something more versatile, it
>> might make sense going that route.
>
> TBH, I hadn't considered the extensibililty of a per-register ioctl, but
> that does seem like a good point.

Maybe smth like

/* available with KVM_CAP_GET_REG_INFO */
struct kvm_reg_info {
	__u64 id;
	__u32 op;
	__u32 len;
	__u8 data[];
};

/* operations for kvm_reg_info->op */
#define KVM_REG_INFO_ARM_ID_REG 0

#define KVM_GET_REG_INFO _IOW(KVMIO, 0xd2, struct kvm_reg_info)

and returning sys_reg_desc->val in data if id points to a valid id reg.

