Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 005DAC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 07:51:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CE1A4B164;
	Mon,  2 May 2022 03:51:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yk7tn0rhVzDT; Mon,  2 May 2022 03:51:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 212214B16F;
	Mon,  2 May 2022 03:51:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E927D4B15C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 03:51:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 752qo0K1N9UR for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 03:51:36 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEFDA4B159
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 03:51:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1651477896;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Rl14DS8awHFv+JBdruHpEbheLcyZwCqVXY9Y6bJisC4=;
 b=bQSAlGadgzvlkLtP44gDDyLofdgN0A7AGK4lZN7YMtHd+KNBNc8ss1VsiJwIXzyQf69xFq
 43kM2WHSKWwM06HhRiEMFN0dQ/+zyFQiDyV+vLplYTfP2qvnVnV4sPFN8E4XYidOpImXhC
 nRDaVTMv/bNtmovoIJZ8pD7oOHBsT50=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-F1M6lgvkOWmiCTPp9K9jMA-1; Mon, 02 May 2022 03:51:33 -0400
X-MC-Unique: F1M6lgvkOWmiCTPp9K9jMA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5BC21C05148;
 Mon,  2 May 2022 07:51:32 +0000 (UTC)
Received: from [10.72.12.86] (ovpn-12-86.pek2.redhat.com [10.72.12.86])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 745B6C52C80;
 Mon,  2 May 2022 07:51:26 +0000 (UTC)
Subject: Re: [PATCH v6 13/18] KVM: arm64: Support
 SDEI_EVENT_{COMPLETE,COMPLETE_AND_RESUME} hypercall
To: Oliver Upton <oupton@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-14-gshan@redhat.com> <Ym4tzRL0iMxyumJe@google.com>
 <ba094956-2e58-4913-527a-af79475ee949@redhat.com>
 <Ym+KdY2y2vzMeDOL@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <e5b527a6-2774-20ef-5a04-43abb43c4812@redhat.com>
Date: Mon, 2 May 2022 15:51:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Ym+KdY2y2vzMeDOL@google.com>
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

On 5/2/22 3:38 PM, Oliver Upton wrote:
> On Mon, May 02, 2022 at 02:19:30PM +0800, Gavin Shan wrote:
>> On 5/1/22 2:50 PM, Oliver Upton wrote:
>>> On Sun, Apr 03, 2022 at 11:39:06PM +0800, Gavin Shan wrote:
>>>> This supports SDEI_EVENT_{COMPLETE, COMPLETE_AND_RESUME} hypercall.
>>>> They are used by guest to notify the completion of event in its
>>>> handler. The previously interrupted or preempted context is restored
>>>> like below.
>>>>
>>>>      * x0 - x17, PC and PState are restored to what values we had in
>>>>        the interrupted or preempted context.
>>>>
>>>>      * If it's SDEI_EVENT_COMPLETE_AND_RESUME hypercall, IRQ exception
>>>>        is injected.
>>>
>>> I don't think that's how COMPLETE_AND_RESUME works. The caller specifies an
>>> address at which it would like to begin execution within the client
>>> exception level.
>>>
>>> SDEI spec suggests this behaves like a synchronous exception. DEN 0054C
>>> 5.2.2 'Event Resume Context' speaks more about how it is supposed to
>>> work.
>>>
>>
>> It's actually the linux convention. If the event handler, which was
>> specified in previous hypercall to EVENT_REGISTER, returns success,
>> the (linux) client calls into COMPLETE_AND_RESUME and the resume
>> address is specified with FIQ vector offset. More details can be
>> found from arch/arm64/kernel::sdei.c::do_sdei_event().
> 
> Right -- but look at what its doing. It returns the address at which it
> wants to resume execution.
> 
> arch/arm64/kernel.entry.S::__sdei_asm_handler winds up passing this as
> an argument to COMPLETE_AND_RESUME. Also, what would happen if we run
> something that isn't Linux inside of KVM? This is why I suggested
> implementing COMPLETE_AND_RESUME in line with the specification, not
> based on what the kernel is presently doing.
> 

Indeed. The address for the resumed execution is passed by x1 when
COMPLETE_AND_RESUME is called. I will figure this out in next revision.
I don't think we can have the assumption that the guest is linux.

Thanks again for your review and comments :)

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
