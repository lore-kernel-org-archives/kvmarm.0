Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4825C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 25 Mar 2022 08:00:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 056B74B0B4;
	Fri, 25 Mar 2022 04:00:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ow9z4SLTezaJ; Fri, 25 Mar 2022 04:00:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA79049F0A;
	Fri, 25 Mar 2022 04:00:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A82749F0A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 04:00:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dleIP8LNypnW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Mar 2022 04:00:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D77D449F09
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 04:00:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1648195207;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=cfDrVvEWHr46qfjijRXtEH0K+gu5X/21OdyaakJ2Cts=;
 b=IZBB4BeiR6V0n4dyMbv0i2QUaDwrR5WKH8K5jtdNQFboM71FVwN+DBKGqxq+Nqvl0OqdTJ
 ar4uhcPB+bcXRRZthJIWadHICpvWnopCGt2+1pdF7/fX59tVa/eeEYW6/YDoIQjv7M+cNw
 6kLp0LjFTu/OrmjHc1J6AQxDCWpocrA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-UwunwPqJN8GkCBCO1qdAEQ-1; Fri, 25 Mar 2022 04:00:04 -0400
X-MC-Unique: UwunwPqJN8GkCBCO1qdAEQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A910785A5A8;
 Fri, 25 Mar 2022 08:00:03 +0000 (UTC)
Received: from [10.72.12.33] (ovpn-12-33.pek2.redhat.com [10.72.12.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 20B46C15D78;
 Fri, 25 Mar 2022 07:59:56 +0000 (UTC)
Subject: Re: [PATCH v5 19/22] KVM: arm64: Support SDEI ioctl commands on vCPU
To: Oliver Upton <oupton@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
 <20220322080710.51727-20-gshan@redhat.com> <Yjte/g4yG+gw7vnt@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <949146db-d467-4949-9e82-94f803c3b166@redhat.com>
Date: Fri, 25 Mar 2022 15:59:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Yjte/g4yG+gw7vnt@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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

On 3/24/22 1:55 AM, Oliver Upton wrote:
> On Tue, Mar 22, 2022 at 04:07:07PM +0800, Gavin Shan wrote:
>> This supports ioctl commands on vCPU to manage the various object.
>> It's primarily used by VMM to accomplish migration. The ioctl
>> commands introduced by this are highlighted as below:
>>
>>     * KVM_SDEI_CMD_GET_VCPU_EVENT_COUNT
>>       Return the total count of vCPU events, which have been queued
>>       on the target vCPU.
>>
>>     * KVM_SDEI_CMD_GET_VCPU_EVENT
>>     * KVM_SDEI_CMD_SET_VCPU_EVENT
>>       Get or set vCPU events.
>>
>>     * KVM_SDEI_CMD_GET_VCPU_STATE
>>     * KVM_SDEI_CMD_SET_VCPU_STATE
>>       Get or set vCPU state.
> 
> All of this GET/SET stuff can probably be added to KVM_{GET,SET}_ONE_REG
> immediately. Just introduce new registers any time a new event comes
> along. The only event we have at the end of this series is the
> software-signaled event, with async PF coming later right?
> 
> Some special consideration is likely necessary to avoid adding a
> register for every u64 chunk of data. I don't think we need to afford
> userspace any illusion of granularity with these, and can probably lump
> it all under one giant pseudoregister.
> 

Yes, KVM_{GET,SET}_ONE_REG is the ideal interface for migration. You're
correct we're only concerned by software signaled event and the one for
Async PF.

I didn't look into Raghavendra's series deeply. Actually, a lump of
registers can be avoid after 2048 byte size is specified in its
encoding. I think 2048 bytes are enough for now since there are
only two supported events.

In the future, we probably have varied number of SDEI events to
be migrated. In that case, we need to add a new bit to the encoding
of the pseudo system register, so that VMM (QEMU) can support
variable sized system register and keep reading and writing on
these registers on migration:

     PSEUDO_SDEI_ADDR: 64-bits in width
     PSEUDO_SDEI_DATA: has varied size

PSEUDO_SDEI_ADDR is used to (1) Indicate the size of PSEUDO_SDEI_DATA
(2) The information to be read/written, for example the (shared/private)
registered events on VM and vCPU, VCPU state.

PSEUDO_SDEI_DATA is used to (1) Retrieved information or that to be
written. (2) Flags to indicate current block of information is the
last one or not.

>>     * KVM_SDEI_CMD_INJECT_EVENT
>>       Inject SDEI event.
> 
> What events are we going to allow userspace to inject? IIUC, the
> software-signaled event is an IPI and really under the control of the
> guest. Async PF is entriely under KVM control.
> 
> I do agree that having some form of event injection would be great. VM
> providers have found it useful to allow users to NMI their VMs when they
> get wedged. I just believe that userspace should not be able to trigger
> events that have a defined meaning and are under full KVM ownership.
> 
> IMO, unless the async PF changes need to go out to userspace, you could
> probably skip event injection for now and only worry about SDEI within a
> VM.
> 

I was overthinking on the usage of SDEI. I had the assumption that SDEI
may be used by emulated devices to inject SDEI events in VMM. It can
even be done through PSEUDO_SDEI_{ADDR, DATA} in future. For now, the
software signaled and Async PF events are concerned, Async PF event
is always raised by host/KVM. So we needn't it for now and I will drop
this functionality, actually the whole ioctl commands and migration
support in next respin, as you suggested :)

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
