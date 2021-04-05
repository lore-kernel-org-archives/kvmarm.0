Return-Path: <SRS0=Uj0Q=JC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C338CC43461
	for <kvmarm@archiver.kernel.org>; Mon,  5 Apr 2021 16:31:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 337C8613A0
	for <kvmarm@archiver.kernel.org>; Mon,  5 Apr 2021 16:31:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 337C8613A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A70974BA3E;
	Mon,  5 Apr 2021 12:31:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NWqqfJIPBC-Z; Mon,  5 Apr 2021 12:31:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA6C44BA7A;
	Mon,  5 Apr 2021 12:31:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C20B64BA3B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Apr 2021 12:31:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s6i0rlS1Ag6F for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Apr 2021 12:31:09 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8D9F4BA39
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Apr 2021 12:31:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617640269;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9lG+nLR5IoYSNGo0IQTIdcrOzj+guXrJm8gXPF7fbQI=;
 b=WsLLEf4VVmuN7lGW9kBqlZTzzCSG5gu4EPspPspM5asuj1c1862HZWEqO+UKeDWclIjhj3
 x/Qz4eWNissTonLs5sr3Stg7GC9QFWUundHtAKH21l1xnOka2+PNvT40oyaLeqUZMm0LKW
 GnA/BRSo04SV3WZLtS4VSh0kw+NDkCM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-TM7Gs4ibP2GI3VgXCeSJwQ-1; Mon, 05 Apr 2021 12:31:07 -0400
X-MC-Unique: TM7Gs4ibP2GI3VgXCeSJwQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E83EF802575;
 Mon,  5 Apr 2021 16:31:05 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AB0E01349A;
 Mon,  5 Apr 2021 16:31:00 +0000 (UTC)
Subject: Re: [PATCH v5 0/8] KVM/ARM: Some vgic fixes and init sequence KVM
 selftests
To: Marc Zyngier <maz@kernel.org>
References: <20210404172243.504309-1-eric.auger@redhat.com>
 <877dlhf3ae.wl-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <051db106-791c-46e7-d921-23e2bfb68b7e@redhat.com>
Date: Mon, 5 Apr 2021 18:30:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <877dlhf3ae.wl-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: kvm@vger.kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

Hi Marc,

On 4/5/21 12:12 PM, Marc Zyngier wrote:
> Hi Eric,
> 
> On Sun, 04 Apr 2021 18:22:35 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
>>
>> While writting vgic v3 init sequence KVM selftests I noticed some
>> relatively minor issues. This was also the opportunity to try to
>> fix the issue laterly reported by Zenghui, related to the RDIST_TYPER
>> last bit emulation. The final patch is a first batch of VGIC init
>> sequence selftests. Of course they can be augmented with a lot more
>> register access tests, but let's try to move forward incrementally ...
>>
>> Best Regards
>>
>> Eric
>>
>> This series can be found at:
>> https://github.com/eauger/linux/tree/vgic_kvmselftests_v5
>>
>> History:
>> v4 -> v5:
>> - rewrite the last bit detection according to Marc's
>>   interpretation of the spec and modify the kvm selftests
>>   accordingly
> 
> Have you dropped v4's patch #1? It did seem to fix an actual issue,
> didn't it?

Hum no that was not my intent :-( Resending ...

Eric
> 
> Thanks,
> 
> 	M.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
