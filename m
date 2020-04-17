Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822B3C38A29
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 10:43:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 10035221EA
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 10:43:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RS9cp0PT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10035221EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E2E24B26B;
	Fri, 17 Apr 2020 06:43:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hf6QwmGmQVzA; Fri, 17 Apr 2020 06:43:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23D554B198;
	Fri, 17 Apr 2020 06:43:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 186AF4B254
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 06:34:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jpHjfNIkZlXv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 06:34:48 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDAE14B252
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 06:34:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587119688;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7WPUTCwZh0g8IKwK9yqDmsCA7SbkZwO1un8rmsHWCDs=;
 b=RS9cp0PTyDbL29pa9vNwYBr7DOP2JABFYzP/+iohZ9zOmhfv0gnTDqMkKXjwZ3d0uG/Q03
 tWGSHwZffn4OceRKO3QUEL7UUkeU6GOgQ/x5Jl2NUhbLIm5JAZU1vsSk0BLrvVeP6wRFHO
 vqsavRj1PQm0R+rgHYvhOeFntz369Pg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-k1R_bLtbNsCTovGpjXPc2A-1; Fri, 17 Apr 2020 06:34:42 -0400
X-MC-Unique: k1R_bLtbNsCTovGpjXPc2A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E7D21005510;
 Fri, 17 Apr 2020 10:34:40 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-104.bne.redhat.com
 [10.64.54.104])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A1F0C10027B8;
 Fri, 17 Apr 2020 10:34:33 +0000 (UTC)
Subject: Re: [PATCH RFCv1 0/7] Support Async Page Fault
To: Mark Rutland <mark.rutland@arm.com>
References: <20200410085820.758686-1-gshan@redhat.com>
 <d2882e806ad2f9793437160093c8d3fa@kernel.org>
 <6a1d7e8b-da10-409f-16d0-354004566a1a@redhat.com>
 <20200414110554.GB2486@C02TD0UTHF1T.local>
 <5bc62c4f-e19d-82f2-072e-dfa4498dccf3@redhat.com>
 <20200416091621.GA4987@lakrids.cambridge.arm.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <cf9ee96d-74f8-1e77-7157-474f5bdd6933@redhat.com>
Date: Fri, 17 Apr 2020 20:34:30 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200416091621.GA4987@lakrids.cambridge.arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Fri, 17 Apr 2020 06:43:07 -0400
Cc: Marc Zyngier <maz@kernel.org>, sudeep.holla@arm.com, shan.gavin@gmail.com,
 catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Mark,

On 4/16/20 7:16 PM, Mark Rutland wrote:
> On Thu, Apr 16, 2020 at 05:59:33PM +1000, Gavin Shan wrote:
>> On 4/14/20 9:05 PM, Mark Rutland wrote:
>>> On Tue, Apr 14, 2020 at 03:39:56PM +1000, Gavin Shan wrote:
>>>> On 4/10/20 10:52 PM, Marc Zyngier wrote:
>>>>> On 2020-04-10 09:58, Gavin Shan wrote:
>>>>>> In order to fulfil the control flow and convey signals between host
>>>>>> and guest. A IMPDEF system register (SYS_ASYNC_PF_EL1) is introduced.
>>>>>> The register accepts control block's physical address, plus requested
>>>>>> features. Also, the signal is sent using data abort with the specific
>>>>>> IMPDEF Data Fault Status Code (DFSC). The specific signal is stored
>>>>>> in the control block by host, to be consumed by guest.
>>>
>>>>> - We don't add IMPDEF sysregs, period. That's reserved for the HW. If
>>>>>      you want to trap, there's the HVC instruction to that effect.
>>>
>>>> I really don't understand how IMPDEF sysreg is used by hardware vendors.
>>>> Do we have an existing functionality, which depends on IMPDEF sysreg?
>>>> I was thinking the IMPDEF sysreg can be used by software either, but
>>>> it seems I'm wrong.
>>>
>>> The key is in the name: an IMPLEMENTATION DEFINED register is defined by
>>> the implementation (i.e. the specific CPU microarchitecture), so it's
>>> wrong for software to come up with an arbitrary semantic as this will
>>> differ from the implementation's defined semantic for the register.
>>>
>>> Typically, IMP DEF resgisters are used for things that firmware needs to
>>> do (e.g. enter/exit coherency), or for bringup-time debug (e.g. poking
>>> into TLB/cache internals), and are not usually intended for general
>>> purpose software.
>>>
>>> Linux generally avoids the use of IMP DEF registers, but does so in some
>>> cases (e.g. for PMUs) after FW explicitly describes that those are safe
>>> to access.
>>
>> Thanks for the explanation and details, which make things much clear. Since
>> the IMPDEF system register can't be used like this way, hypercall (HVC) would
>> be considered to serve same purpose - deliver signals from host to guest.
> 
> I'm not sure I follow how you'd use HVC to inject a signal into a guest;
> the HVC would have to be issued by the guest to the host. Unless you're
> injecting the signal via some other mechanism (e.g. an interrupt), and
> the guest issues the HVC in response to that?
> 

Yeah, I expressed it in wrong way. It should be - HVC is used by guest
to inject signal to host. Sorry for the confusion.

>> However, the hypercall number and behaviors are guarded by
>> specification. For example, the hypercalls used by para-virtualized
>> stolen time, which are defined in include/linux/arm-smccc.h, are
>> specified by ARM DEN0057A [1]. So I need a specification to be
>> created, where the hypercalls used by this feature are defined? If
>> it's not needed, can I pick hypercalls that aren't used and define
>> their behaviors by myself?
>>
>> [1] http://infocenter.arm.com/help/topic/com.arm.doc.den0057a/DEN0057A_Paravirtualized_Time_for_Arm_based_Systems_v1_0.pdf
> 
> Take a look at the SMCCC / SMC Calling Convention:
> 
>   https://developer.arm.com/docs/den0028/c
> 
> ... that defines ranges set aside for hypervisor-specific usage, and
> despite its name it also applies to HVC calls.
> 
> There's been intermittent work to add a probing story for that, so that
> part is subject to change, but for prototyping you can just choose an
> arbitray number in that range -- just be suere to mention in the commit
> and cover letter that this part isn't complete.
> 

Sure, thanks for the pointer, which is very useful. Will already shared
the git repo link about the probing story. I'll take a look and come back
to you if I have more questions. Yes, arbitrary numbers in the range is
ok for prototyping.

>> Another thing I want to check is about the ESR_EL1[DFSC]. In this series,
>> the asynchronous page fault is identified by IMPDEF DFSC (Data Fault Status
>> Code) in ESR_EL1. According to what we discussed, the IMPDEF DFSC shouldn't
>> be fired (produced) by software. It should be produced by hardware either?
>> What I understood is IMPDEF is hardware behavior. If this is true, I need
>> to avoid using IMPDEF DFSC in next revision :)
> 
> Yes, similar applies here.
> 
> If the guest is making a hypercall, you can return the fault info as the
> response in GPRs, so I don't think you need to touch any architectural
> fault registers.
> 

The guest passively receives the async page fault from the host. It means
there is no hypercall issued by guest. I think the asynchronous property can
be stored in control block by host and it's retrieved by guest when the async
page fault is handled. In this way, I needn't a specific (IMPDEF) DFSC. Note
the physical address of the control block is passed to host when the functionality
is enabled by HVC.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
