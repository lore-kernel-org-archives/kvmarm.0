Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03EDBC48BCF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 15:47:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6B68261377
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 15:47:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B68261377
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E77FF49F83;
	Wed,  9 Jun 2021 11:47:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ti6KNfDoO1HB; Wed,  9 Jun 2021 11:47:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E08D340CF9;
	Wed,  9 Jun 2021 11:47:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0088C40877
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 11:47:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yXmJf5LYtdpc for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 11:47:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38C9840874
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 11:47:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623253659;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=HrJ56KNgOU02CakepH78uzRXCKVfyAtnPm/2ZtxoPPI=;
 b=Q6ZAoYZJD5nSQy3WPOJLeiAfKzTINJ7ewRxAJZ4Knu2p1cj97/7SrUC/HtxksMJt9+f3UZ
 +PBjm9bgPT/JAICbaKhk4QjYX7BvFKL0L6A1TRkctb+cXvosTE07j32gDwN6rQ8JyBj16c
 H+e/DfPWYXH+ezbj/Zmr18b64AWiygw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-0PxVCkv8ND-DEVJNQY53gQ-1; Wed, 09 Jun 2021 11:47:36 -0400
X-MC-Unique: 0PxVCkv8ND-DEVJNQY53gQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 798941922960;
 Wed,  9 Jun 2021 15:47:34 +0000 (UTC)
Received: from localhost (ovpn-113-134.ams2.redhat.com [10.36.113.134])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 04E0B5D9C6;
 Wed,  9 Jun 2021 15:47:30 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Laurent Vivier <lvivier@redhat.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>, Andrew Jones
 <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/7] arm: unify header guards
In-Reply-To: <8399161a-ef26-7d4f-19fb-c54ca40fe6c3@redhat.com>
Organization: Red Hat GmbH
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-5-cohuck@redhat.com>
 <8399161a-ef26-7d4f-19fb-c54ca40fe6c3@redhat.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date: Wed, 09 Jun 2021 17:47:29 +0200
Message-ID: <874ke711m6.fsf@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
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

On Wed, Jun 09 2021, Laurent Vivier <lvivier@redhat.com> wrote:

> On 09/06/2021 16:37, Cornelia Huck wrote:
>> The assembler.h files were the only ones not already following
>> the convention.
>> 
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  lib/arm/asm/assembler.h   | 6 +++---
>>  lib/arm64/asm/assembler.h | 6 +++---
>>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> What about lib/arm/io.h?

It didn't have a guard yet, so I didn't touch it.

>
> I think you can remove the guard from
>
> lib/arm/asm/memory_areas.h
>
> as the other files including directly a header doesn't guard it.

I see other architectures doing that, though. I guess it doesn't hurt,
but we can certainly also remove it. Other opinions?

>
> Missing lib/arm/asm/mmu-api.h, lib/arm/asm/mmu.h, lib/arm64/asm/mmu.h

Oops, overlooked the extra underscore there.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
