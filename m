Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312781E528
	for <kvmarm@lists.linux.dev>; Thu,  3 Aug 2023 13:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691068846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SMsAApeVsUKCtcw77w2tHWzG/2gWwfjt/a0cgmISXuo=;
	b=FxlukFfWKy5KMCi9BSlkh7ikKxVpwBOCqJnPwM3ylGdKnfnmY8uiG+kmGkI5zUI6vidos7
	PCzrLU/x5n0PEAE/hnqjxk9sp2KPlpM/0hp1MGAShuHNrAIcX6f2YgPGL0IXbdstT3IJrw
	WWxS1ysWxt+X5caIW97iwngMmnZk74g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-ACCy8DQmMtyjZz5FrcpV9Q-1; Thu, 03 Aug 2023 09:20:43 -0400
X-MC-Unique: ACCy8DQmMtyjZz5FrcpV9Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FDE0800159;
	Thu,  3 Aug 2023 13:20:42 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5659840C2063;
	Thu,  3 Aug 2023 13:20:42 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>, Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, ARMLinux
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, James
 Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>,
 Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta
 <rananta@google.com>, Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v7 01/10] KVM: arm64: Allow userspace to get the
 writable masks for feature ID registers
In-Reply-To: <ZMqMofRCmB14XUZr@linux.dev>
Organization: Red Hat GmbH
References: <20230801152007.337272-1-jingzhangos@google.com>
 <20230801152007.337272-2-jingzhangos@google.com>
 <ZMmdnou5Pk/9V1Gs@linux.dev>
 <CAAdAUtj-6tk53TE6p0TYBfmFghj94g+Sg2KK_80Gar18kJ=5OA@mail.gmail.com>
 <ZMqMofRCmB14XUZr@linux.dev>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Thu, 03 Aug 2023 15:20:41 +0200
Message-ID: <877cqc8dp2.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1

On Wed, Aug 02 2023, Oliver Upton <oliver.upton@linux.dev> wrote:

> On Wed, Aug 02, 2023 at 08:55:43AM -0700, Jing Zhang wrote:
>> > > +#define ARM64_FEATURE_ID_SPACE_SIZE  (3 * 8 * 8)
>> > > +
>> > > +struct feature_id_writable_masks {
>> > > +     __u64 mask[ARM64_FEATURE_ID_SPACE_SIZE];
>> > > +};
>> >
>> > This UAPI is rather difficult to extend in the future. We may need to
>> > support describing the masks of multiple ranges of registers in the
>> > future. I was thinking something along the lines of:
>> >
>> >         enum reg_mask_range_idx {
>> >                 FEATURE_ID,
>> >         };
>> >
>> >         struct reg_mask_range {
>> >                 __u64 idx;
>> >                 __u64 *masks;
>> >                 __u64 rsvd[6];
>> >         };
>> >
>> Since have the way to map sysregs encoding to the index in the mask
>> array, we can extend the UAPI by just adding a size field in struct
>> feature_id_writable_masks like below:
>> struct feature_id_writable_masks {
>>          __u64 size;
>>          __u64 mask[ARM64_FEATURE_ID_SPACE_SIZE];
>> };
>> The 'size' field can be used as input for the size of 'mask' array and
>> output for the number of masks actually read in.
>> This way, we can freely add more ranges without breaking anything in userspace.
>> WDYT?
>
> Sorry, 'index' is a bit overloaded in this context. The point I was
> trying to get across is that we might want to describe a completely
> different range of registers than the feature ID registers in the
> future. Nonetheless, we shouldn't even presume the shape of future
> extensions to the ioctl.
>
> 	struct reg_mask_range {
> 		__u64 addr;	/* pointer to mask array */
> 		__u64 rsvd[7];
> 	};
>
> Then in KVM we should require ::rsvd be zero and fail the ioctl
> otherwise.

[I assume rsvd == reserved? I think I have tried to divine further
meaning into this for far too long...]

Is the idea here for userspace the request a mask array for FEATURE_ID
and future ranges separately instead of getting all id-type regs in one
go?

