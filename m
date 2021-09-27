Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1914FC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 23:59:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8F15761205
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 23:59:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8F15761205
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AD3C4B0BA;
	Mon, 27 Sep 2021 19:59:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PWH-EGEVjdFP; Mon, 27 Sep 2021 19:59:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08EDB4A19F;
	Mon, 27 Sep 2021 19:59:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C75D40573
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 19:59:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 48oP4BAv4Fnk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 19:59:40 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C9CA4B092
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 19:59:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632787180;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=RWuQbjjw7d6RpnrVRV+KE6JwsTnLJqx5vfaAKc+bH9Y=;
 b=fB/QHw+EQ3M5PyU/eWNe75ESzOtrTlKiaQHxwen8MRyfxIHGb11/RsXTLjco5R8Y/RsM4i
 iXUiudyVZbY/tPBzZyTTJdYdr843Y8i43zy3D+FEykhDEBTmpXV2BfgmSe1HeHwHyZoaEV
 MJBMsqYRw9PwP+XNhchkQylqWnULNgQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-FOpKJpTdN6GVc0BnQsUYZw-1; Mon, 27 Sep 2021 19:59:36 -0400
X-MC-Unique: FOpKJpTdN6GVc0BnQsUYZw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1527835DE0;
 Mon, 27 Sep 2021 23:59:34 +0000 (UTC)
Received: from [10.64.54.16] (vpn2-54-16.bne.redhat.com [10.64.54.16])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 390D560657;
 Mon, 27 Sep 2021 23:59:29 +0000 (UTC)
Subject: Re: [PATCH v2 2/2] of, numa: Fetch empty NUMA node ID from distance
 map
To: Rob Herring <robh@kernel.org>
References: <20210927064119.127285-1-gshan@redhat.com>
 <20210927064119.127285-3-gshan@redhat.com>
 <CAL_JsqL8+_Q690-c3J4TS6LBF-mCUBxbhTfr994=Fwffqab0_w@mail.gmail.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <c101363f-1de7-1d56-a8d9-243f003b48c1@redhat.com>
Date: Tue, 28 Sep 2021 09:59:25 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <CAL_JsqL8+_Q690-c3J4TS6LBF-mCUBxbhTfr994=Fwffqab0_w@mail.gmail.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: devicetree@vger.kernel.org, linux-efi <linux-efi@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 shan.gavin@gmail.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

Hi Rob,

On 9/28/21 12:49 AM, Rob Herring wrote:
> On Mon, Sep 27, 2021 at 1:42 AM Gavin Shan <gshan@redhat.com> wrote:
>>
>> There is no device node for the empty NUMA node. However, the
>> corresponding NUMA node ID and distance map is still valid in
>> "numa-distance-map-v1" compatible device node.
>>
>> This fetches the NUMA node ID and distance map for these empty
>> NUMA node from "numa-distance-map-v1" compatible device node.
> 
> This is much nicer.
> 

Indeed, thanks for your suggestions :)

>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   drivers/of/of_numa.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/of/of_numa.c b/drivers/of/of_numa.c
>> index fe6b13608e51..5949829a1b00 100644
>> --- a/drivers/of/of_numa.c
>> +++ b/drivers/of/of_numa.c
>> @@ -111,6 +111,8 @@ static int __init of_numa_parse_distance_map_v1(struct device_node *map)
>>                          return -EINVAL;
>>                  }
>>
>> +               node_set(nodea, numa_nodes_parsed);
>> +
> 
> With this, couldn't we remove of_numa_parse_cpu_nodes() as the only
> thing it does is node_set()?
> 

I don't think so for couple of reasons:

(1) With problematic device-tree, the distance map node might be missed
     or incomplete. In this case, of_numa_parse_cpu_nodes() still helps.

(2) @numa_nodes_parsed is also updated when the memory nodes are iterated
     in of_numa_parse_memory_nodes() and numa_add_memblk().

So @numa_nodes_parsed, which is synchronized to @node_possible_map afterwards,
is the gathering output of CPU nodes, memory nodes and distance map node.

>>                  numa_set_distance(nodea, nodeb, distance);
>>
>>                  /* Set default distance of node B->A same as A->B */

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
