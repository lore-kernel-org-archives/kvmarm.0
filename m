Return-Path: <SRS0=E5f7=XA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C944FC3A5AB
	for <kvmarm@archiver.kernel.org>; Thu,  5 Sep 2019 12:02:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4A06021883
	for <kvmarm@archiver.kernel.org>; Thu,  5 Sep 2019 12:02:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="JU8ZtJW7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A06021883
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89A964A58B;
	Thu,  5 Sep 2019 08:02:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmx.net
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sBS1rtrr3o76; Thu,  5 Sep 2019 08:02:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77E684A525;
	Thu,  5 Sep 2019 08:02:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE2094A525
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Sep 2019 08:02:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jVgw9bX8xVaq for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Sep 2019 08:02:07 -0400 (EDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 465BD4A51F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Sep 2019 08:02:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
 s=badeba3b8450; t=1567684918;
 bh=Ifg8ScrvmDwqe6DT0xc5FKzrFMpkjXP2CoDGAqSR8Kw=;
 h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
 b=JU8ZtJW7Cs/y7o84KN46w39L+ZCoR7OPTknfmpuCV5OD8V53+MXH7NXMWAWQkaF8q
 oDhmBH8rbONkCNzjnFPMYT+Zzyb5xSE75ivlSHgkeNxOtPAB5rwW7yOX8M9m/KmODh
 z/a74375T9cydsM86Hw0vbMyI4fte5OTKpNn0q1Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.123.51] ([84.118.159.3]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mj8qd-1ibrou3xmX-00fDo3; Thu, 05
 Sep 2019 14:01:58 +0200
Subject: Re: [PATCH 1/1] KVM: inject data abort if instruction cannot be
 decoded
To: Stefan Hajnoczi <stefanha@redhat.com>
References: <20190904180736.29009-1-xypron.glpk@gmx.de>
 <20190905092039.GG32415@stefanha-x1.localdomain>
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Message-ID: <561eae08-c5f1-9543-275c-0da0a85cd7df@gmx.de>
Date: Thu, 5 Sep 2019 14:01:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190905092039.GG32415@stefanha-x1.localdomain>
Content-Language: en-US
X-Provags-ID: V03:K1:CajlwCQ/dFSIPb9BoBQWcuZxEtLDjozJAje3PZp6uiuat15ZNyn
 FUaYmh7XqHvansuNFN3EW9g1BL3iSOv26VEPD/OHNNPfz6yRrPAWseemeuNoa2Db4u8FgU4
 hRR9abF3JReiH5UubK9R9bDE1itGIlfDiAPGxa+lS6RSJdCZ0Q7uUEqcdnrSYjI2tV0lM2B
 zhEgrfWIk4Jf6ijAXnw7A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2BnKRf1R0is=:dW6bd8F7Kb6/NPNuN6OFhb
 GOEJaRTw800UZN5LtZ2/IFZOLl+53OjXKhKUTr+cOxiqTLiwdIW6pYtJmh7GWde/N5YqKVkGF
 y7Qoxu5j40FTU3g7qcQl+ZVOg0XGAyxFADTVnXg4Tu7bp76exom2rJ7oTut+/2P2sQCFJGE6g
 2nLaCmGH759OQxnDtJk2ldc6ELEkkAa7PynWqW+029ojHdKCqrIXCY6t9OjVuVUYXBE0dbNA1
 LR11OS9HtfgR8yVkdw2KBB5v6VOPl0aYLBP64mtaoiydjnDI4SK6ye6l5z0wq/hya9fq46yrQ
 5u5JGxk17epcB2AheMwd2hto76WAcdoQv2OZzGQWG2mO98a4cvBWOJf8XORqePrsghgfArHMw
 STaTLU9/6f5GBWAggapSZJ5M7ON8lwNTLtuWtw+UEK3aHBbNrn5C1lWasf8h5z8YN+iYmiApj
 FBY6rZprcN2uvoPKzetlwrzAmWfszRAGqQZXdC3wn54/gKuWd0TmyZ0uQizxj1EBZM9KINbPb
 ONbLtRIYz5j+XyAr8HTPyz0IepeyPSGha7vFGl5q91tHBUwV1a0hb/VevmLOUM0nn91a12hX4
 VgPst8PWjMarExnQiJvyjF/IcZ0zJukQzfgtJABCME+6vrpmpBlcyUw9Ah5nXzcJ5f+q0S2Xr
 Pul5BbpiLstYWYwAyF4h9tVzpI0z5+rhWayV9Esm8Yn5wc6WEPR2EOrYMr3zzgNTZeFM+YBsN
 Aa4/B6dIaKILhaup0bW8Zyr4E5AW3r6nX2kjmGOJ2ZU9y4swBA0zSunaYTr/xjcmBa8SgblSi
 lSEkmdctrX5G/a6lmMcROX5rRXiKjMDPcXmHxnzGPFIYr4VQwe7UnJ2xwlY5Uk+j0c2PmB/Ni
 1gAGaGftPPj3D5T4jqxtJbKWnaJHgzJxvb43gOAbBOc5tZKbeVLeLRxEpuikr5GBYRMYazimZ
 co5vjpUJI+p0z/1S6b/3bnmMnb82DlWVzB2M8ihBGLeuyQKraZZWsDxBmcR1RkHORgURkeHK/
 Bo3NLJOB36l/+YwDzfcUY3gXOldMxcnj97lJM4327ZJR5ucIVo8QJnVArHkeAgEX0wPScvhps
 xzTBUQVaPfGQqQkPgv0Xl+tvdXUQKYAGn2qiQLtoKgZciv58hCY2QGI7mtuAiS4spWGCuQvDf
 ldtDCuxobhlc09zMg0OmAMjBYYRYhcQyy5LpKIPFHd10Y3SomZG8bGQvQT/KdSGTveRDwPRnN
 Yd7f70iAK5o4000W7
Cc: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
 Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
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

On 9/5/19 11:20 AM, Stefan Hajnoczi wrote:
> On Wed, Sep 04, 2019 at 08:07:36PM +0200, Heinrich Schuchardt wrote:
>> If an application tries to access memory that is not mapped, an error
>> ENOSYS, "load/store instruction decoding not implemented" may occur.
>> QEMU will hang with a register dump.
>>
>> Instead create a data abort that can be handled gracefully by the
>> application running in the virtual environment.
>>
>> Now the virtual machine can react to the event in the most appropriate
>> way - by recovering, by writing an informative log, or by rebooting.
>>
>> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
>> ---
>>   virt/kvm/arm/mmio.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
>> index a8a6a0c883f1..0cbed7d6a0f4 100644
>> --- a/virt/kvm/arm/mmio.c
>> +++ b/virt/kvm/arm/mmio.c
>> @@ -161,8 +161,8 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>>   		if (ret)
>>   			return ret;
>>   	} else {
>> -		kvm_err("load/store instruction decoding not implemented\n");
>> -		return -ENOSYS;
>> +		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
>> +		return 1;
>
> I see this more as a temporary debugging hack than something to merge.
>
> It sounds like in your case the guest environment provided good
> debugging information and you preferred it over debugging this from the
> host side.  That's fine, but allowing the guest to continue running in
> the general case makes it much harder to track down the root cause of a
> problem because many guest CPU instructions may be executed after the
> original problem occurs.  Other guest software may fail silently in
> weird ways.  IMO it's best to fail early.
>
> Stefan
>

As virtual machine are ubiquitous, expect also mission critical system
to run on them. At development time halting a machine may be a good
idea. In production this is often the worst solution. Rebooting may be
essential for survival.

For an anecdotal example see:
https://www.hq.nasa.gov/alsj/a11/a11.1201-pa.html

I am convinced that leaving it to the guest to decide how to react is
the best choice.

Best regards

Heinrich
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
