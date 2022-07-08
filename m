Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F2D1C43334
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jul 2022 13:03:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9609F4B83E;
	Fri,  8 Jul 2022 09:03:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NmUDlZKsdPVX; Fri,  8 Jul 2022 09:03:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 180EA4B834;
	Fri,  8 Jul 2022 09:03:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ED844B832
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 09:03:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Id0TLw0XjtuY for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jul 2022 09:03:40 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD2634B831
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 09:03:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1657285420;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=dfG27/f+o/ptwnOkSWJ0DWXNX/DLyn4lBrSqo3TTM7Y=;
 b=I6/QbwcxfU2ibA86UjdETHO5xOqChmiHISmjBW591ymaNiDn6ADrEMQ22se4zfhbyPpwqQ
 KC8//lCrXb0/tXWWnG4UePSjDRvmmrbPGH/ukevQ7JC0C5Ak8O180y+5WLAwsyRuP1S2nH
 qvembr4sdAnIC4lTmEDfNwAAKSfBk5Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-IU5YGY_aN8aZ44R0bj1BRQ-1; Fri, 08 Jul 2022 09:03:37 -0400
X-MC-Unique: IU5YGY_aN8aZ44R0bj1BRQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23F03805F38;
 Fri,  8 Jul 2022 13:03:36 +0000 (UTC)
Received: from localhost (unknown [10.39.193.86])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B6652492C3B;
 Fri,  8 Jul 2022 13:03:35 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Steven Price <steven.price@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
In-Reply-To: <b91ae197-d191-2204-aab5-21a0aabded69@arm.com>
Organization: Red Hat GmbH
References: <20220623234944.141869-1-pcc@google.com>
 <YrXu0Uzi73pUDwye@arm.com> <14f2a69e-4022-e463-1662-30032655e3d1@arm.com>
 <875ykmcd8q.fsf@redhat.com> <YrwRPh1S6qjzkJMm@arm.com>
 <7a32fde7-611d-4649-2d74-f5e434497649@arm.com> <871qv12hqj.fsf@redhat.com>
 <b91ae197-d191-2204-aab5-21a0aabded69@arm.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date: Fri, 08 Jul 2022 15:03:34 +0200
Message-ID: <87bktz7o49.fsf@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Andy Lutomirski <luto@amacapital.net>, Will Deacon <will@kernel.org>,
 Evgenii Stepanov <eugenis@google.com>, Michael Roth <michael.roth@amd.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Peter Collingbourne <pcc@google.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Jul 04 2022, Steven Price <steven.price@arm.com> wrote:

> On 04/07/2022 13:19, Cornelia Huck wrote:
>> On Mon, Jul 04 2022, Steven Price <steven.price@arm.com> wrote:
>> 
>>> On 29/06/2022 09:45, Catalin Marinas wrote:
>>>> On Mon, Jun 27, 2022 at 05:55:33PM +0200, Cornelia Huck wrote:
>>>
>>>>> [Postcopy needs a different interface, I guess, so that the migration
>>>>> target can atomically place a received page and its metadata. I see
>>>>> https://lore.kernel.org/all/CAJc+Z1FZxSYB_zJit4+0uTR-88VqQL+-01XNMSEfua-dXDy6Wg@mail.gmail.com/;
>>>>> has there been any follow-up?]
>>>>
>>>> I don't follow the qemu list, so I wasn't even aware of that thread. But
>>>> postcopy, the VMM needs to ensure that both the data and tags are up to
>>>> date before mapping such page into the guest address space.
>>>>
>>>
>>> I'm not sure I see how atomically updating data+tags is different from
>>> the existing issues around atomically updating the data. The VMM needs
>>> to ensure that the guest doesn't see the page before all the data+all
>>> the tags are written. It does mean lazy setting of the tags isn't
>>> possible in the VMM, but I'm not sure that's a worthwhile thing anyway.
>>> Perhaps I'm missing something?
>> 
>> For postcopy, we basically want to fault in any not-yet-migrated page
>> via uffd once the guest accesses it. We only get the page data that way,
>> though, not the tag. I'm wondering whether we'd need a 'page+metadata'
>> uffd mode; not sure if that makes sense. Otherwise, we'd need to stop
>> the guest while grabbing the tags for the page as well, and stopping is
>> the thing we want to avoid here.
>
> Ah, I think I see now. UFFDIO_COPY atomically populates the (data) page
> and ensures that no thread will see the partially populated page. But
> there's currently no way of doing that with tags as well.

Nod.

>
> I'd not looked at the implementation of userfaultfd before and I'd
> assumed it avoided the need for an 'atomic' operation like this. But
> apparently not! AFAICT either a new ioctl would be needed (which can
> take a tag buffer) or a new flag to UFFDIO_COPY which would tighten the
> alignment requirements of `src` and would copy the tags along with the data.

I was thinking about a new flag that implies "copy metadata"; not sure
how we would get the same atomicity with a separate ioctl. I've only
just started looking at userfaultfd, though, and I might be on a wrong
track... One thing I'd like to avoid is having something that is too
ARM-specific, I think there are other architecture features that might
have similar issues.

Maybe someone more familiar with uffd and/or postcopy can chime in?

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
