Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7391C10
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 08:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690188352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SGEuuzEfpEqIyIcWlh8SdwBRdtZDbiU/gwg6y6Nb3TI=;
	b=bpfLZTbUq4duzHarEY6clhK+8irHcxI6hkvk/9Lau3tgU5K3AqJlGZJ6DkUF4T+qOOD4p+
	vpE7f9JkR57PyZLvLXS7gpZ/WOkRu99t/eQBb7IN7X8I5y48dk9TUptw8xdFWDVzngMLNg
	gQ89cUw0lsooE+rEP9BE4jvwej8MVOI=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-r5c13_EwNVqst-YIzyGjyg-1; Mon, 24 Jul 2023 04:45:47 -0400
X-MC-Unique: r5c13_EwNVqst-YIzyGjyg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E5483813F3A;
	Mon, 24 Jul 2023 08:45:46 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27B49F783B;
	Mon, 24 Jul 2023 08:45:46 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>, Jing Zhang <jingzhangos@google.com>
Cc: Marc Zyngier <maz@kernel.org>, KVM <kvm@vger.kernel.org>, KVMARM
 <kvmarm@lists.linux.dev>, ARMLinux <linux-arm-kernel@lists.infradead.org>,
 Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, James
 Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>,
 Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta
 <rananta@google.com>, Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v6 3/6] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
 and ID_DFR0_EL1
In-Reply-To: <ZLr0LcQENZmIGMAt@linux.dev>
Organization: Red Hat GmbH
References: <20230718164522.3498236-1-jingzhangos@google.com>
 <20230718164522.3498236-4-jingzhangos@google.com>
 <87o7k77yn5.fsf@redhat.com>
 <CAAdAUthM6JJ0tEqWELcW48E235EbcjZQSDLF9OQUZ_kUtqh3Ng@mail.gmail.com>
 <87sf9h8xs0.fsf@redhat.com> <86r0p1txun.wl-maz@kernel.org>
 <CAAdAUtjNW6Q+phGbc6jXWTERRhYo7E3H4Ws0iDSngc17Sac0uA@mail.gmail.com>
 <ZLr0LcQENZmIGMAt@linux.dev>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Mon, 24 Jul 2023 10:45:44 +0200
Message-ID: <87edkxg0jr.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5

On Fri, Jul 21 2023, Oliver Upton <oliver.upton@linux.dev> wrote:

> On Fri, Jul 21, 2023 at 11:22:35AM -0700, Jing Zhang wrote:
>> On Fri, Jul 21, 2023 at 2:31=E2=80=AFAM Marc Zyngier <maz@kernel.org> wr=
ote:
>> > My preference would be a single ioctl that returns the full list of
>> > writeable masks in the ID reg range. It is big, but not crazy big
>> > (1536 bytes, if I haven't messed up), and includes the non ID_*_EL1
>> > sysreg such as MPIDR_EL1, CTR_EL1, SMIDR_EL1.
>> Just want to double confirm that would the ioclt return the list of
>> only writable masks, not the list of {idreg_name, mask} pair? So, the
>> VMM will need to index idreg's writable mask by op1, CRm, op2?
>
> I generally agree with the approach Marc is proposing, but I wonder if
> it makes sense to have userspace ask the kernel for this information on
> a per-register basis.
>
> What I had in mind was something similar to the KVM_GET_ONE_REG ioctl,
> but instead of returning the register value it'd return the mask of the
> register. This would keep the kernel implementation dead simple (I'm
> lazy) and more easily allow for future expansion in case we want to
> start describing more registers this way. Userspace would iterate the ID
> register space and ask the kernel for the mask of registers it wants to
> change.

Hm... for userspace it might be easier to get one big list and then
parse it afterwards? Similar to what GET_REG_LIST does today.

Are you thinking more of a KVM_GET_REG_INFO or so ioctl, that could
support different kinds of extra info (and might also make sense for
other architectures?) If we end up with something more versatile, it
might make sense going that route.

