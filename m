Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C18C04A95
	for <kvmarm@archiver.kernel.org>; Sun, 25 Sep 2022 23:21:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B18274B82D;
	Sun, 25 Sep 2022 19:21:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2GBwJllaAt65; Sun, 25 Sep 2022 19:21:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4ED44B7F0;
	Sun, 25 Sep 2022 19:21:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AB324B733
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Sep 2022 19:21:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U6B+lt0-T3pc for <kvmarm@lists.cs.columbia.edu>;
 Sun, 25 Sep 2022 19:21:19 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FADF43399
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Sep 2022 19:21:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1664148079;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=sCD0xx2zMa4gS6Q6TKSN9kVDHDoO1KNdmd+17CQdIKI=;
 b=iXHFbUfC4VIjdqZEVs4Ak+XK8qOdSJhxQ/jHr8aH+EH3qNx8UVaFeizskt+/cfjvjMkqhQ
 Fl2SMryGCgGn1oaXm1yfC/88h/ffDUEupjVQNcbeQjj6U5GdcqoAiFF6xlXQqoNhCKM7jy
 opvF5xOMZ7V+AXr+PfWuIbMuctwSExM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-_NE_ZJrjOMeXaolZDVnXTw-1; Sun, 25 Sep 2022 19:21:16 -0400
X-MC-Unique: _NE_ZJrjOMeXaolZDVnXTw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6511A85A583;
 Sun, 25 Sep 2022 23:21:15 +0000 (UTC)
Received: from [10.64.54.126] (vpn2-54-126.bne.redhat.com [10.64.54.126])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B4A3140EBF3;
 Sun, 25 Sep 2022 23:21:11 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm64: vgic: Remove duplicate check in
 update_affinity_collection()
To: Marc Zyngier <maz@kernel.org>
References: <20220923065447.323445-1-gshan@redhat.com>
 <87bkr5hto4.wl-maz@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <61dad836-2c4d-e462-3f52-1524db437629@redhat.com>
Date: Mon, 26 Sep 2022 09:21:08 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <87bkr5hto4.wl-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Cc: yuzhe@nfschina.com, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Marc,

On 9/24/22 9:56 PM, Marc Zyngier wrote:
> Side note: please make sure you always Cc all the KVM/arm64 reviewers
> when sending patches (now added).
> 

Sure. The reason, why I didn't run './scripts/get_maintainer.pl' to get
all reviewers, is the patch is super simple one :)

> On Fri, 23 Sep 2022 07:54:47 +0100,
> Gavin Shan <gshan@redhat.com> wrote:
>>
>> The ITS collection is guranteed to be !NULL when update_affinity_collection()
>> is called. So we needn't check ITE's collection with NULL because the
>> check has been included to the later one.
> 
> It took me a while to understand what you meant by this: the 'coll'
> parameter to update_affinity_collection() is never NULL, so comparing
> it with 'ite->collection' is enough to cover both the NULL case and
> the "another collection" case.
> 
> If you agree with this, I can directly fix the commit message when
> applying the patch.
> 

Yes, the commit message is accurate and correct. Please help to apply
your commit message directly :)

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
