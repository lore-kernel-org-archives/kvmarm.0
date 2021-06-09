Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86FEC48BDF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 15:19:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 32462613B6
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 15:19:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32462613B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F491409DD;
	Wed,  9 Jun 2021 11:19:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A6+ATdyFeOl9; Wed,  9 Jun 2021 11:19:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D0204086A;
	Wed,  9 Jun 2021 11:19:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B46440821
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 11:19:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yVAar5pArEo8 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 11:19:24 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B373407F4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 11:19:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623251963;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=EPs1wywtpCyKnad9uo0ufdiauhYEOI43/mf6957AL8M=;
 b=g53V4X/Id226hobIIBSOaMhttkmzifilNtZUB3JOm64hlvBAdW8HqdvNswz5nXnTTC683p
 HSF46oCSNxADp5oio73Zgl9tQMnzsT15j59XTIDmOimeQYeQ4MhXpTrInhZhybGfPp9ypy
 a3iT/M3pKqVrBK+rQvx1jcLdUiX5Lec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-kf6qpB-yPj-dkOTAj5ORMA-1; Wed, 09 Jun 2021 11:19:14 -0400
X-MC-Unique: kf6qpB-yPj-dkOTAj5ORMA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A9F0101C8AD;
 Wed,  9 Jun 2021 15:19:12 +0000 (UTC)
Received: from localhost (ovpn-113-134.ams2.redhat.com [10.36.113.134])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 19CFD60853;
 Wed,  9 Jun 2021 15:19:08 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: David Hildenbrand <david@redhat.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>, Andrew Jones
 <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/7] README.md: add guideline for
 header guards format
In-Reply-To: <4884a501-939e-a343-7cb3-a31d2f59914f@redhat.com>
Organization: Red Hat GmbH
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-2-cohuck@redhat.com>
 <4884a501-939e-a343-7cb3-a31d2f59914f@redhat.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date: Wed, 09 Jun 2021 17:19:06 +0200
Message-ID: <87a6nz12xh.fsf@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: Laurent Vivier <lvivier@redhat.com>, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 kvm-ppc@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Jun 09 2021, David Hildenbrand <david@redhat.com> wrote:

> On 09.06.21 16:37, Cornelia Huck wrote:
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>   README.md | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>> 
>> diff --git a/README.md b/README.md
>> index 24d4bdaaee0d..687ff50d0af1 100644
>> --- a/README.md
>> +++ b/README.md
>> @@ -156,6 +156,15 @@ Exceptions:
>>   
>>     - While the kernel standard requires 80 columns, we allow up to 120.
>>   
>> +Header guards:
>> +
>> +Please try to adhere to adhere to the following patterns when adding
>> +"#ifndef <...> #define <...>" header guards:
>> +    ./lib:             _HEADER_H_
>> +    ./lib/<ARCH>:      _ARCH_HEADER_H_
>> +    ./lib/<ARCH>/asm:  _ASMARCH_HEADER_H_
>
> I'd have used _ARCH_ASM_HEADER_H_

I had that first, but the pattern I ended up using caused way less churn
(this is basically what arm[64] uses.)

>
> Reviewed-by: David Hildenbrand <david@redhat.com>

Thanks!

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
