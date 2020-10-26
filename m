Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B82C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 22:48:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4888B20791
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 22:48:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z0qtGEy2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4888B20791
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 794E84B57D;
	Mon, 26 Oct 2020 18:48:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Oz0AT81SdFQE; Mon, 26 Oct 2020 18:48:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D10F4B588;
	Mon, 26 Oct 2020 18:48:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B581D4B57D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 18:48:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id otLq0EXjVGc8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 18:48:09 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D64C74B567
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 18:48:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1603752489;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QZENRY/OqurIFQi4CLnDtE3iXJd2mbvXnYEHQia0UHw=;
 b=Z0qtGEy2pivgy8wWXeIWYPwmfNSoGdE3/DnL4bk6McU6Xau/5HzZTHNVgZbdVR7nnMxJDk
 a4P3yzXijYwbKKXzpz89nrun1y5ZtHJpOmxal1ON0nQRDljAj+Y8b0uQT/A9HW5hHahYDE
 aRvg8rLdAtTawIE+nHfRnrK86DZtBNc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-0DUL1UT2NrKgBZJ7BUWjsA-1; Mon, 26 Oct 2020 18:48:07 -0400
X-MC-Unique: 0DUL1UT2NrKgBZJ7BUWjsA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1268C186DD25;
 Mon, 26 Oct 2020 22:48:06 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 636BC55781;
 Mon, 26 Oct 2020 22:48:04 +0000 (UTC)
Subject: Re: [PATCH 1/3] KVM: arm64: Check if 52-bits PA is enabled
To: Marc Zyngier <maz@kernel.org>
References: <20201025002739.5804-1-gshan@redhat.com>
 <20201025002739.5804-2-gshan@redhat.com> <871rhmpr92.wl-maz@kernel.org>
 <333451bd-4730-4ebb-f76c-28fa5d0e1f7d@redhat.com>
 <a676f540d19fba2468fd1a801948826a@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <11639356-397a-4a25-879a-0c91d9845041@redhat.com>
Date: Tue, 27 Oct 2020 09:48:01 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <a676f540d19fba2468fd1a801948826a@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: will@kernel.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
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

On 10/26/20 7:53 PM, Marc Zyngier wrote:
> On 2020-10-25 22:23, Gavin Shan wrote:
>> Hi Marc,
>>
>> On 10/25/20 8:52 PM, Marc Zyngier wrote:
>>> On Sun, 25 Oct 2020 01:27:37 +0100,
>>> Gavin Shan <gshan@redhat.com> wrote:
>>>>
>>>> The 52-bits physical address is disabled until CONFIG_ARM64_PA_BITS_52
>>>> is chosen. This uses option for that check, to avoid the unconditional
>>>> check on PAGE_SHIFT in the hot path and thus save some CPU cycles.
>>>
>>> PAGE_SHIFT is known at compile time, and this code is dropped by the
>>> compiler if the selected page size is not 64K. This patch really only
>>> makes the code slightly less readable and the "CPU cycles" argument
>>> doesn't hold at all.
>>>
>>> So what are you trying to solve exactly?
>>>
>>
>> There are two points covered by the patch: (1) The 52-bits physical address
>> is visible only when CONFIG_ARM64_PA_BITS_52 is enabled in arch/arm64 code.
>> The code looks consistent with this option used here. (2) I had the assumption
>> that gcc doesn't optimize the code and PAGE_SHIFT is always checked in order
>> to get higher 4 physical address bits, but you said gcc should optimize the
>> code accordingly. However, it would be still nice to make the code explicit.
> 
> Conditional compilation only results in more breakages, specially for configs
> that hardly anyone uses (big-endian and 64K pages are the two that bitrot very
> quickly).
> 
> So if anything can build without #ifdef, I'll take that anytime. If the compiler
> doesn't optimize it away, let's fix the compiler.
> 

Ok. PATCH[1] and PATCH[2] have been dropped in v2.

Cheers,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
