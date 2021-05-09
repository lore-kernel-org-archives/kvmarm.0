Return-Path: <SRS0=43FB=KE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835B3C433ED
	for <kvmarm@archiver.kernel.org>; Sun,  9 May 2021 17:04:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D4FE7613B6
	for <kvmarm@archiver.kernel.org>; Sun,  9 May 2021 17:04:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4FE7613B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F9F44B2B4;
	Sun,  9 May 2021 13:04:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qy-ecB6YD1Mq; Sun,  9 May 2021 13:04:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DE574B815;
	Sun,  9 May 2021 13:04:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F4774B4D3
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 May 2021 13:04:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xM4sFo-56CG6 for <kvmarm@lists.cs.columbia.edu>;
 Sun,  9 May 2021 13:04:38 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 190924B4CB
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 May 2021 13:04:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620579877;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=gS221mF5itctneFLHEBt6dN2sStEXBf4HlghBIHalXQ=;
 b=QVxhoh4BCi/g0FZ8LYBFSQshkIJo+qTIylhd6aENrQootgCXqyIh+1/X0E7x8i8i5qF38R
 QSZ/g/a7DhF/3uy2G3CLWuDx4723mIPnBaQurDpg5tS9MAnZrywbP2XfJU5EHdla/KlUG4
 Ms29MZCb90/hV+PCH5HThFSubo69504=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-NKNK1PMkMt-tlAQTihZAUg-1; Sun, 09 May 2021 13:04:36 -0400
X-MC-Unique: NKNK1PMkMt-tlAQTihZAUg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A58B18397A6;
 Sun,  9 May 2021 17:04:34 +0000 (UTC)
Received: from [10.36.113.168] (ovpn-113-168.ams2.redhat.com [10.36.113.168])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DAF1169FCE;
 Sun,  9 May 2021 17:04:24 +0000 (UTC)
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
To: Marc Zyngier <maz@kernel.org>, Zhu Lingshan <lingshan.zhu@intel.com>
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
 <8735uxvajh.wl-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <65e48458-f94c-e5fd-03d5-93d6acfb356c@redhat.com>
Date: Sun, 9 May 2021 19:04:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <8735uxvajh.wl-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, cohuck@redhat.com,
 stable@vger.kernel.org, Shaokun Zhang <zhangshaokun@hisilicon.com>,
 alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi,
On 5/8/21 11:29 AM, Marc Zyngier wrote:
> On Sat, 08 May 2021 08:11:52 +0100,
> Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>>
>> This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.
>>
>> The reverted commit may cause VM freeze on arm64 platform.
>> Because on arm64 platform, stop a consumer will suspend the VM,
>> the VM will freeze without a start consumer
> 
> It also unconditionally calls del_consumer on the producer, which
> isn't exactly expected.
> 
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> 
> Reported-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> Suggested-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Fixes: a979a6aa009f ("irqbypass: do not start cons/prod when failed connect")
> Link: https://lore.kernel.org/r/3a2c66d6-6ca0-8478-d24b-61e8e3241b20@hisilicon.com
> Cc: stable@vger.kernel.org
> 
> Thanks,
> 
> 	M.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
