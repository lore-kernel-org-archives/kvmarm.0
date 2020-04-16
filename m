Return-Path: <SRS0=0qdQ=6A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC08FC352BE
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 11:10:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 861DD208E4
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 11:10:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hsF1i6JW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 861DD208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EC1D4B285;
	Thu, 16 Apr 2020 07:10:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jQhPYQBVfx64; Thu, 16 Apr 2020 07:10:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 756884B265;
	Thu, 16 Apr 2020 07:10:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 438744B201
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 03:59:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NM3V1KtMpZD3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Apr 2020 03:59:53 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 268044B1FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 03:59:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587023992;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=59R+ovlxm6On+Qd8pYU/mUIYBEwTiidwJnUqasBYx2I=;
 b=hsF1i6JWQ6LADO/6TlDqfQmMRCK6Lk4WszDgCPDegG8Nrl2+2T3IH/j09HqReJJZCBeOxk
 XexlxsFDNswcztX+jAlkGmXjb7Dxm+b/e48s5C04Mvt3a2/hVvQGsDp6+ttOD3QA85mdj5
 68cf+ob+Qlw2uq+ODOB7lwbZfBkhDRI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-9hOwk_6DP4u2o4uguH0tVQ-1; Thu, 16 Apr 2020 03:59:45 -0400
X-MC-Unique: 9hOwk_6DP4u2o4uguH0tVQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A503618C8C04;
 Thu, 16 Apr 2020 07:59:43 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-119.bne.redhat.com
 [10.64.54.119])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 26C495C1C5;
 Thu, 16 Apr 2020 07:59:36 +0000 (UTC)
Subject: Re: [PATCH RFCv1 0/7] Support Async Page Fault
To: Mark Rutland <mark.rutland@arm.com>
References: <20200410085820.758686-1-gshan@redhat.com>
 <d2882e806ad2f9793437160093c8d3fa@kernel.org>
 <6a1d7e8b-da10-409f-16d0-354004566a1a@redhat.com>
 <20200414110554.GB2486@C02TD0UTHF1T.local>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <5bc62c4f-e19d-82f2-072e-dfa4498dccf3@redhat.com>
Date: Thu, 16 Apr 2020 17:59:33 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200414110554.GB2486@C02TD0UTHF1T.local>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Thu, 16 Apr 2020 07:10:16 -0400
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

On 4/14/20 9:05 PM, Mark Rutland wrote:
> On Tue, Apr 14, 2020 at 03:39:56PM +1000, Gavin Shan wrote:
>> On 4/10/20 10:52 PM, Marc Zyngier wrote:
>>> On 2020-04-10 09:58, Gavin Shan wrote:
>>>> In order to fulfil the control flow and convey signals between host
>>>> and guest. A IMPDEF system register (SYS_ASYNC_PF_EL1) is introduced.
>>>> The register accepts control block's physical address, plus requested
>>>> features. Also, the signal is sent using data abort with the specific
>>>> IMPDEF Data Fault Status Code (DFSC). The specific signal is stored
>>>> in the control block by host, to be consumed by guest.
> 
>>> - We don't add IMPDEF sysregs, period. That's reserved for the HW. If
>>>     you want to trap, there's the HVC instruction to that effect.
> 
>> I really don't understand how IMPDEF sysreg is used by hardware vendors.
>> Do we have an existing functionality, which depends on IMPDEF sysreg?
>> I was thinking the IMPDEF sysreg can be used by software either, but
>> it seems I'm wrong.
> 
> The key is in the name: an IMPLEMENTATION DEFINED register is defined by
> the implementation (i.e. the specific CPU microarchitecture), so it's
> wrong for software to come up with an arbitrary semantic as this will
> differ from the implementation's defined semantic for the register.
> 
> Typically, IMP DEF resgisters are used for things that firmware needs to
> do (e.g. enter/exit coherency), or for bringup-time debug (e.g. poking
> into TLB/cache internals), and are not usually intended for general
> purpose software.
> 
> Linux generally avoids the use of IMP DEF registers, but does so in some
> cases (e.g. for PMUs) after FW explicitly describes that those are safe
> to access.
> 

Thanks for the explanation and details, which make things much clear. Since
the IMPDEF system register can't be used like this way, hypercall (HVC) would
be considered to serve same purpose - deliver signals from host to guest. However,
the hypercall number and behaviors are guarded by specification. For example,
the hypercalls used by para-virtualized stolen time, which are defined in
include/linux/arm-smccc.h, are specified by ARM DEN0057A [1]. So I need a
specification to be created, where the hypercalls used by this feature are
defined? If it's not needed, can I pick hypercalls that aren't used and define
their behaviors by myself?

[1] http://infocenter.arm.com/help/topic/com.arm.doc.den0057a/DEN0057A_Paravirtualized_Time_for_Arm_based_Systems_v1_0.pdf

Another thing I want to check is about the ESR_EL1[DFSC]. In this series,
the asynchronous page fault is identified by IMPDEF DFSC (Data Fault Status
Code) in ESR_EL1. According to what we discussed, the IMPDEF DFSC shouldn't
be fired (produced) by software. It should be produced by hardware either?
What I understood is IMPDEF is hardware behavior. If this is true, I need
to avoid using IMPDEF DFSC in next revision :)


Thanks,
Gavin



_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
