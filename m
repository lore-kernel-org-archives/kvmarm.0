Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54DBCC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 07:28:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C40614B0DE;
	Mon,  2 May 2022 03:28:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OGjGDhUFiGrR; Mon,  2 May 2022 03:28:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 780FD4B12E;
	Mon,  2 May 2022 03:28:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26D024B0DE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 03:28:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uPd6++a69h4p for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 03:28:40 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 112E34B0D0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 03:28:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1651476519;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=EywQlrSHGmaFztkZ6nGxOyoDkOWNb3RCFHAorrh5itE=;
 b=MJxeX3beQJ4nOvpqkUxjulY8vIOjT9e2M1IaOREIG029aV6jToGaGoaF5tiNYAUx5hML2l
 bWJhpT4E0d4U9nnQkkiYa5xL2Z5lfU8WEZSx/oC+i7kX13maEN6isi8MnpbiaHTH3PyV26
 GMW3Oiet7xJIc1DWlnM13dllC+foFJU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-29NrMOZXMyqurb0Nic8wWA-1; Mon, 02 May 2022 03:28:34 -0400
X-MC-Unique: 29NrMOZXMyqurb0Nic8wWA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2689F1014A67;
 Mon,  2 May 2022 07:28:34 +0000 (UTC)
Received: from [10.72.12.86] (ovpn-12-86.pek2.redhat.com [10.72.12.86])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 19C92112D165;
 Mon,  2 May 2022 07:28:27 +0000 (UTC)
Subject: Re: [PATCH v6 04/18] KVM: arm64: Support SDEI_EVENT_REGISTER hypercall
To: Oliver Upton <oupton@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-5-gshan@redhat.com> <Ym1Nsaq/ERUx/ebD@google.com>
 <6e7cb20d-24c4-b357-8830-a68ff05638fe@redhat.com>
 <Ym9TarUE6+lJ0izt@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <a6122234-907a-4ede-26fc-872c196c5912@redhat.com>
Date: Mon, 2 May 2022 15:28:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Ym9TarUE6+lJ0izt@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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

On 5/2/22 11:43 AM, Oliver Upton wrote:
> On Mon, May 02, 2022 at 10:55:51AM +0800, Gavin Shan wrote:
>>>> +	unsigned long route_mode = smccc_get_arg(vcpu, 4);
>>>
>>> This is really 'flags'. route_mode is bit[0]. I imagine we don't want to
>>> support relative mode, so bit[1] is useless for us in that case too.
>>>
>>> The spec is somewhat imprecise on what happens for reserved flags. The
>>> prototype in section 5.1.2 of [1] suggests that reserved bits must be
>>> zero, but 5.1.2.3 'Client responsibilities' does not state that invalid
>>> flags result in an error.
>>>
>>> Arm TF certainly rejects unexpected flags [2].
>>>
>>> [1]: DEN0054C https://developer.arm.com/documentation/den0054/latest
>>> [2]: https://github.com/ARM-software/arm-trusted-firmware/blob/66c3906e4c32d675eb06bd081de8a3359f76b84c/services/std_svc/sdei/sdei_main.c#L260
>>>
>>
>> Yes, This chunk of code is still stick to old specification. Lets
>> improve in next respin:
>>
>>     - Rename @route_mode to @flags
>>     - Reject if the reserved bits are set.
>>     - Reject if relative mode (bit#1) is selected.
>>     - Reject if routing mode (bit#0) isn't RM_ANY (0).
> 
> Bit[0] is ignored for private events, actually. So we really just reject
> if any of bit[63:1] are set.
> 

It makes sense to me. Thanks for your confirm :)

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
