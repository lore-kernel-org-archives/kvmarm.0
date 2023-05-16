Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BBA24EA6
	for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 12:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684239202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tzUmk87snFS7HoBIZst/R05wwfkMdbgCSpiT96qaD5s=;
	b=HChdg4N0DB70WumkWdghdm+tvwaDgmTEqCUF33USumbD0SgioPJqH1CNqzNqeOU/CIUtaM
	vG9ezAj5ilIAIVKoZwpewMvAR+qYNgcPuu7A4bL+z4wmygsmVCfsE/nzPZ4z1YCoRl82qK
	qL+9Gd0KNwARpUyS1/2rtmkXSiN6VkA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-ZmlMnNkGOxCQCpdbM_NETQ-1; Tue, 16 May 2023 07:55:23 -0400
X-MC-Unique: ZmlMnNkGOxCQCpdbM_NETQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8AC372801A68;
	Tue, 16 May 2023 11:55:16 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CEAC40C6EC4;
	Tue, 16 May 2023 11:55:15 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Marc
 Zyngier <maz@kernel.org>
Cc: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>, KVMARM
 <kvmarm@lists.linux.dev>, ARMLinux <linux-arm-kernel@lists.infradead.org>,
 Oliver Upton <oupton@google.com>, Will Deacon <will@kernel.org>, Paolo
 Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, Reiji Watanabe
 <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Subject: RE: [PATCH v8 0/6] Support writable CPU ID registers from userspace
In-Reply-To: <1a96a72e87684e2fb3f8c77e32516d04@huawei.com>
Organization: Red Hat GmbH
References: <20230503171618.2020461-1-jingzhangos@google.com>
 <2ef9208dabe44f5db445a1061a0d5918@huawei.com>
 <868rdomtfo.wl-maz@kernel.org>
 <1a96a72e87684e2fb3f8c77e32516d04@huawei.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Tue, 16 May 2023 13:55:14 +0200
Message-ID: <87cz30h4nx.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2

On Tue, May 16 2023, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

>> -----Original Message-----
>> From: Marc Zyngier [mailto:maz@kernel.org]
>> Sent: 16 May 2023 12:01
>> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
>> Cc: Jing Zhang <jingzhangos@google.com>; KVM <kvm@vger.kernel.org>;
>> KVMARM <kvmarm@lists.linux.dev>; ARMLinux
>> <linux-arm-kernel@lists.infradead.org>; Oliver Upton <oupton@google.com>;
>> Will Deacon <will@kernel.org>; Paolo Bonzini <pbonzini@redhat.com>;
>> James Morse <james.morse@arm.com>; Alexandru Elisei
>> <alexandru.elisei@arm.com>; Suzuki K Poulose <suzuki.poulose@arm.com>;
>> Fuad Tabba <tabba@google.com>; Reiji Watanabe <reijiw@google.com>;
>> Raghavendra Rao Ananta <rananta@google.com>
>> Subject: Re: [PATCH v8 0/6] Support writable CPU ID registers from
>> userspace
>> 
>> On Tue, 16 May 2023 11:37:20 +0100,
>> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
>> wrote:
>> >
>> > > -----Original Message-----
>> > > From: Jing Zhang [mailto:jingzhangos@google.com]
>> > > Sent: 03 May 2023 18:16
>> > > To: KVM <kvm@vger.kernel.org>; KVMARM <kvmarm@lists.linux.dev>;
>> > > ARMLinux <linux-arm-kernel@lists.infradead.org>; Marc Zyngier
>> > > <maz@kernel.org>; Oliver Upton <oupton@google.com>
>> > > Cc: Will Deacon <will@kernel.org>; Paolo Bonzini
>> <pbonzini@redhat.com>;
>> > > James Morse <james.morse@arm.com>; Alexandru Elisei
>> > > <alexandru.elisei@arm.com>; Suzuki K Poulose
>> <suzuki.poulose@arm.com>;
>> > > Fuad Tabba <tabba@google.com>; Reiji Watanabe <reijiw@google.com>;
>> > > Raghavendra Rao Ananta <rananta@google.com>; Jing Zhang
>> > > <jingzhangos@google.com>
>> > > Subject: [PATCH v8 0/6] Support writable CPU ID registers from
>> userspace
>> > >
>> > > This patchset refactors/adds code to support writable per guest CPU ID
>> > > feature
>> > > registers. Part of the code/ideas are from
>> > >
>> https://lore.kernel.org/all/20220419065544.3616948-1-reijiw@google.com
>> >
>> > Hi Jing/Reiji,
>> >
>> > Just to check the status on the above mentioned series "KVM: arm64: Make
>> CPU
>> > ID registers writable by userspace". Is there any plan to respin that one
>> soon?
>> > (Sorry, not sure there is any other series in progress for that support
>> currently)
>> 
>> I think this still is the latest, which I'm about to review again. I'd
>> appreciate if you could have a look to!
>
> Thanks Marc for confirming. Will go through. We do have some requirement to
> add support for Qemu CPU models/migration between different hosts.

Do you have more concrete ideas for QEMU CPU models already? Asking
because I wanted to talk about this at KVM Forum, so collecting what
others would like to do seems like a good idea :)

