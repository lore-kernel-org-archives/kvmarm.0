Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D932CFA3741
	for <kvmarm@archiver.kernel.org>; Fri, 28 Oct 2022 12:06:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49A2F49EED;
	Fri, 28 Oct 2022 08:06:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3BwcEcUXNKxi; Fri, 28 Oct 2022 08:06:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0123840D0B;
	Fri, 28 Oct 2022 08:06:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC31B40BD9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 08:06:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ggG+plnHV1c6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Oct 2022 08:06:47 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 810C24079D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 08:06:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1666958807;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=08bh16k+MkWlMw0GIlY8wPoFsEGUYu9WpRc4x9URdi0=;
 b=VwgsL2StHd6UjA+V0Zd0OcMsMmdOgSo5QCq02hAIX9SoKXwxnKK4Z/c1Vg4yL+V/aoLy2v
 5LR1oFdaStxCAB14H0eWmdHkEjj4GVaqsTNvo4XIrDnhdMwi4/WNqPb5BYLVhycgEjKXMJ
 o3iceOt3f72Pw5BSVWH3H8VqDo0m2nM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-qDeqJMT-PBWy6JmSBeULnw-1; Fri, 28 Oct 2022 08:06:43 -0400
X-MC-Unique: qDeqJMT-PBWy6JmSBeULnw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8425C1C09C86;
 Fri, 28 Oct 2022 12:06:43 +0000 (UTC)
Received: from localhost (unknown [10.39.193.13])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AAC92166B2C;
 Fri, 28 Oct 2022 12:06:43 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [kvm-unit-tests PATCH] MAINTAINERS: new kvmarm mailing list
In-Reply-To: <20221028114446.zn2xz64lrzptskgd@kamzik>
Organization: Red Hat GmbH
References: <20221025160730.40846-1-cohuck@redhat.com>
 <87a65gkwld.fsf@redhat.com> <20221028114446.zn2xz64lrzptskgd@kamzik>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Fri, 28 Oct 2022 14:06:41 +0200
Message-ID: <877d0kkv8u.fsf@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Fri, Oct 28 2022, Andrew Jones <andrew.jones@linux.dev> wrote:

> On Fri, Oct 28, 2022 at 01:37:34PM +0200, Cornelia Huck wrote:
>> On Tue, Oct 25 2022, Cornelia Huck <cohuck@redhat.com> wrote:
>> 
>> > KVM/arm64 development is moving to a new mailing list (see
>> > https://lore.kernel.org/all/20221001091245.3900668-1-maz@kernel.org/);
>> > kvm-unit-tests should advertise the new list as well.
>> >
>> > Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> > ---
>> >  MAINTAINERS | 3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/MAINTAINERS b/MAINTAINERS
>> > index 90ead214a75d..649de509a511 100644
>> > --- a/MAINTAINERS
>> > +++ b/MAINTAINERS
>> > @@ -67,7 +67,8 @@ ARM
>> >  M: Andrew Jones <andrew.jones@linux.dev>
>> >  S: Supported
>> >  L: kvm@vger.kernel.org
>> > -L: kvmarm@lists.cs.columbia.edu
>> > +L: kvmarm@lists.linux.dev
>> > +L: kvmarm@lists.cs.columbia.edu (deprecated)
>> 
>> As the days of the Columbia list really seem to be numbered (see
>> https://lore.kernel.org/all/364100e884023234e4ab9e525774d427@kernel.org/),
>> should we maybe drop it completely from MAINTAINERS, depending on when
>> this gets merged?
>
> I'll merge your patch now with the old (deprecated) list still there. When
> mail starts bouncing it may help people better understand why. When the
> kernel drops it from its MAINTAINERS file, then we can drop it here too.

OK, makes sense.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
