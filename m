Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD24C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 25 Mar 2022 10:23:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4819849ED9;
	Fri, 25 Mar 2022 06:23:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MiZgnw3vOmlI; Fri, 25 Mar 2022 06:23:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CED504B0B4;
	Fri, 25 Mar 2022 06:23:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 144EF49EEF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 06:23:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oQLzKT1vykdW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Mar 2022 06:23:24 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A880649ED9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 06:23:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1648203804;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=FqCkuUzPjL3vvNWJz+rpLQdGrzF6nE10Um+x1rzjlhw=;
 b=EYxtwIASjfyaFcElGQpXdgZs4ED0ot//HiGmfzqgU85ia3SzuGiy0ABE3/Mjaegb7Ei8+V
 uHENYn9LFL5UE7QhpwzXes5eW5AjLEaDbEbHRcmd7lsTjqtK8hlCi64x10YB0F13S+gubc
 bT05oS5nr7wsgAWBwfgHRlKT/ocV0NY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-4BHchNMkNC6H0D-e-9kIow-1; Fri, 25 Mar 2022 06:23:22 -0400
X-MC-Unique: 4BHchNMkNC6H0D-e-9kIow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5387B802803;
 Fri, 25 Mar 2022 10:23:22 +0000 (UTC)
Received: from [10.72.12.33] (ovpn-12-33.pek2.redhat.com [10.72.12.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C5CC840D296B;
 Fri, 25 Mar 2022 10:23:17 +0000 (UTC)
Subject: Re: [PATCH v5 19/22] KVM: arm64: Support SDEI ioctl commands on vCPU
To: Oliver Upton <oupton@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
 <20220322080710.51727-20-gshan@redhat.com> <Yjte/g4yG+gw7vnt@google.com>
 <949146db-d467-4949-9e82-94f803c3b166@redhat.com>
 <Yj1/Y5ql0d0h39rX@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <ac9a870d-e3bc-e86b-43e0-2e10a883aa2d@redhat.com>
Date: Fri, 25 Mar 2022 18:23:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Yj1/Y5ql0d0h39rX@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Oliver,

On 3/25/22 4:37 PM, Oliver Upton wrote:
> On Fri, Mar 25, 2022 at 03:59:50PM +0800, Gavin Shan wrote:
>> On 3/24/22 1:55 AM, Oliver Upton wrote:
>>> On Tue, Mar 22, 2022 at 04:07:07PM +0800, Gavin Shan wrote:
>>>> This supports ioctl commands on vCPU to manage the various object.
>>>> It's primarily used by VMM to accomplish migration. The ioctl
>>>> commands introduced by this are highlighted as below:
>>>>
>>>>      * KVM_SDEI_CMD_GET_VCPU_EVENT_COUNT
>>>>        Return the total count of vCPU events, which have been queued
>>>>        on the target vCPU.
>>>>
>>>>      * KVM_SDEI_CMD_GET_VCPU_EVENT
>>>>      * KVM_SDEI_CMD_SET_VCPU_EVENT
>>>>        Get or set vCPU events.
>>>>
>>>>      * KVM_SDEI_CMD_GET_VCPU_STATE
>>>>      * KVM_SDEI_CMD_SET_VCPU_STATE
>>>>        Get or set vCPU state.
>>>
>>> All of this GET/SET stuff can probably be added to KVM_{GET,SET}_ONE_REG
>>> immediately. Just introduce new registers any time a new event comes
>>> along. The only event we have at the end of this series is the
>>> software-signaled event, with async PF coming later right?
>>>
>>> Some special consideration is likely necessary to avoid adding a
>>> register for every u64 chunk of data. I don't think we need to afford
>>> userspace any illusion of granularity with these, and can probably lump
>>> it all under one giant pseudoregister.
>>>
>>
>> Yes, KVM_{GET,SET}_ONE_REG is the ideal interface for migration. You're
>> correct we're only concerned by software signaled event and the one for
>> Async PF.
>>
>> I didn't look into Raghavendra's series deeply. Actually, a lump of
>> registers can be avoid after 2048 byte size is specified in its
>> encoding. I think 2048 bytes are enough for now since there are
>> only two supported events.
> 
> When I had said 'one giant pseudoregister' I actually meant 'one
> pseudoregister per event', not all of SDEI into a single
> structure. Since most of this is in flux now, it is hard to point
> out what/how we should migrate from conversation alone.
> 
> And on the topic of Raghavendra's series, I do not believe it is
> required anymore here w/ the removal of shared events, which I'm
> strongly in favor of.
> 
> Let's delve deeper into migration on the next series :)
> 

Ok, Thanks for your clarification about 'one giant pseudoregister'.
Lets have more discussion about the migration on next revision.
To be more clear, I plan to implement the base functionality,
where only the private event is supported. After it reaches into
mergeable or merged, we can post the add-on series to support
migration.

>> In the future, we probably have varied number of SDEI events to
>> be migrated. In that case, we need to add a new bit to the encoding
>> of the pseudo system register, so that VMM (QEMU) can support
>> variable sized system register and keep reading and writing on
>> these registers on migration:
>>
>>      PSEUDO_SDEI_ADDR: 64-bits in width
>>      PSEUDO_SDEI_DATA: has varied size
>>
>> PSEUDO_SDEI_ADDR is used to (1) Indicate the size of PSEUDO_SDEI_DATA
>> (2) The information to be read/written, for example the (shared/private)
>> registered events on VM and vCPU, VCPU state.
>>
>> PSEUDO_SDEI_DATA is used to (1) Retrieved information or that to be
>> written. (2) Flags to indicate current block of information is the
>> last one or not.
> 
> I don't think we have sufficient encoding space in the register ID
> to allow for arbitrary length registers. Any new registers for SDEI will
> need to fit into one of the predefined sizes. Note that we've already
> conditioned userspace to handle registers this way and anything else is
> an ABI change.
> 

Ok, I think we need padding to structures of the event, to make the
event object aligned to 64-bytes aligned, and VCPU state to 512-bytes
aligned. 64-bytes and 128-bytes registers have been supported.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
