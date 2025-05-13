Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9ED1E5B65
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 14:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747147371; cv=none; b=b/WCEQzP9bd/izzSn8sX8LT2jkSy7H15UTGajv4NT+P6anSm6WfiFwzwkkKIJklxNrKcz8kHBGQXaJbWAgee32p5ChTJPs1aXEfg6Qnu5VdnrUgTsTNt24y4sY4MR9DMY/mD3wqq8I0s0g7il+x2rnYCCpqj40zfqUe5z+09vrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747147371; c=relaxed/simple;
	bh=TQSNJweaMLXI2kXJgXfglZTJuWBdBtbP2CbtUpbRLfY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HI0UnlIjbjTi+KNJmBskKz1oRq7cdx+QfidHE/7F5S4UFOPSW7iug5K5GcXkylPUyGN9TcJtyTSsxRB/NolX7j7d4dradXL7NnqfoiA3nf9qtgXkDemrZ24vBPlKRjnCw0WjWpMNOIfRWR3o6IiFFdr62LtryezigwuffVhEtDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V17PIx/b; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V17PIx/b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747147368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p6Pc/DoCV1c6L4UtfRaupclGbLmRZkZUjIct4ZRvSAg=;
	b=V17PIx/beLSYZu397kOYCecBTfH2Zw1mpsOjbKzTEHuGwSU4H195MEtEthRGaHQKiTpBye
	3QmdyiwG33UqfGjDnsTTbgFxecHILwsFAK2ju2BGeXPLxoxPtof18EwvmzURFv6RaTr5fb
	IWARx13bCjMystNKUZWUHK2y9KtEjeY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-177-qDPC7BQuNki1Jg3wfs3r-A-1; Tue,
 13 May 2025 10:42:45 -0400
X-MC-Unique: qDPC7BQuNki1Jg3wfs3r-A-1
X-Mimecast-MFC-AGG-ID: qDPC7BQuNki1Jg3wfs3r-A_1747147362
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 085671800368;
	Tue, 13 May 2025 14:42:42 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D93A7180049D;
	Tue, 13 May 2025 14:42:40 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
 philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 04/10] kvm: kvm_get_writable_id_regs
In-Reply-To: <4f370fae-8234-48ca-97e2-3b7038092974@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-5-cohuck@redhat.com>
 <4f370fae-8234-48ca-97e2-3b7038092974@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 13 May 2025 16:42:38 +0200
Message-ID: <878qn0po69.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, May 13 2025, Eric Auger <eric.auger@redhat.com> wrote:

> Hi Connie,
>
> On 4/14/25 6:38 PM, Cornelia Huck wrote:
>> Add an helper to retrieve the writable id reg bitmask. The
>> status of the query is stored in the CPU struct so that an
>> an error, if any, can be reported on vcpu realize().
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  target/arm/cpu.h     | 26 ++++++++++++++++++++++++++
>>  target/arm/kvm.c     | 32 ++++++++++++++++++++++++++++++++
>>  target/arm/kvm_arm.h |  7 +++++++
>>  3 files changed, 65 insertions(+)
>>
>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>> index d27134f4a025..bbee7ff2414a 100644
>> --- a/target/arm/cpu.h
>> +++ b/target/arm/cpu.h
>> @@ -856,6 +856,26 @@ typedef struct {
>>      uint32_t map, init, supported;
>>  } ARMVQMap;
>>  
>> +typedef enum ARMIdRegsState {
>> +    WRITABLE_ID_REGS_UNKNOWN,
>> +    WRITABLE_ID_REGS_NOT_DISCOVERABLE,
>> +    WRITABLE_ID_REGS_FAILED,
>> +    WRITABLE_ID_REGS_AVAIL,
>> +} ARMIdRegsState;
>> +
>> +/*
>> + * The following structures are for the purpose of mapping the output of
>> + * KVM_ARM_GET_REG_WRITABLE_MASKS that also may cover id registers we do
>> + * not support in QEMU
>> + * ID registers in op0==3, op1=={0,1,3}, crn=0, crm=={0-7}, op2=={0-7},
>> + * as used by the KVM_ARM_GET_REG_WRITABLE_MASKS ioctl call.
>> + */
>> +#define NR_ID_REGS (3 * 8 * 8)
> We may rename this define to better associate to the KVM API. I tend to
> mix it with NUM_ID_IDX now ;-)
> maybe something like KVM_NR_EXPOSED_ID_REGS

The kernel calls it KVM_FEATURE_ID_RANGE_SIZE, but I'd like to avoid
adding 'KVM' in the name, as it is basically a range of registers and
nothing really KVM specific... maybe ID_REG_RANGE_SIZE?

>> +
>> +typedef struct IdRegMap {
>> +    uint64_t regs[NR_ID_REGS];
>> +} IdRegMap;
> I would add a comment saying this is the mask array, just to prevent the
> reading from thinking it is the actual reg content.

"More comments" seems to be a theme :) I'll go ahead and add them where
it makes sense.

>> +
>>  /* REG is ID_XXX */
>>  #define FIELD_DP64_IDREG(ISAR, REG, FIELD, VALUE)                       \
>>      ({                                                                  \
>> @@ -1044,6 +1064,12 @@ struct ArchCPU {
>>       */
>>      bool host_cpu_probe_failed;
>>  
>> +    /*
>> +     * state of writable id regs query used to report an error, if any,
>> +     * on KVM custom vcpu model realize
>> +     */
>> +    ARMIdRegsState writable_id_regs;
> maybe rename into writable_id_reg_status that would better reflect what
> it is.

Indeed.

