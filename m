Return-Path: <SRS0=NSSj=46=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB56C1975A
	for <kvmarm@archiver.kernel.org>; Fri, 13 Mar 2020 01:55:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 270EF206EB
	for <kvmarm@archiver.kernel.org>; Fri, 13 Mar 2020 01:55:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 270EF206EB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8218F4AEEF;
	Thu, 12 Mar 2020 21:55:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PAdiSh+k0wFp; Thu, 12 Mar 2020 21:55:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73A2E4A5A3;
	Thu, 12 Mar 2020 21:55:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EF514A5A3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 21:55:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id btDk8WnG1TVm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Mar 2020 21:55:42 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A29594A51F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 21:55:42 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 3CC268047441D80DBB2B;
 Fri, 13 Mar 2020 09:55:38 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Fri, 13 Mar 2020
 09:55:31 +0800
Subject: Re: [kvm-unit-tests PATCH v5 10/13] arm/arm64: ITS: INT functional
 tests
To: Auger Eric <eric.auger@redhat.com>
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-11-eric.auger@redhat.com>
 <d3f651a0-2344-4d6e-111b-be133db7e068@huawei.com>
 <46f0ed1d-3bda-f91b-e2b0-addf1c61c373@redhat.com>
 <301a8b402ff7e480e927b0f8f8b093f2@kernel.org>
 <7fb9f81f-6520-526d-7031-d3d08cb1dd6a@huawei.com>
 <acc652b7-f331-1e48-160c-f07e0e5283b3@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <160015aa-f5d7-2fdc-8d06-1322af241896@huawei.com>
Date: Fri, 13 Mar 2020 09:55:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <acc652b7-f331-1e48-160c-f07e0e5283b3@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, andre.przywara@arm.com, thuth@redhat.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Eric,

On 2020/3/12 17:59, Auger Eric wrote:
> Hi Zenghui,
> 
> On 3/12/20 10:19 AM, Zenghui Yu wrote:
>> On 2020/3/11 22:00, Marc Zyngier wrote:
>>> That is still a problem with the ITS. There is no architectural way
>>> to report an error, even if the error numbers are architected...
>>>
>>> One thing we could do though is to implement the stall model (as
>>> described
>>> in 5.3.2). It still doesn't give us the error, but at least the command
>>> queue would stop on detecting an error.
>>
>> It would be interesting to see the buggy guest's behavior under the
>> stall mode. I've used the following diff (absolutely *not* a formal
>> patch, don't handle CREADR.Stalled and CWRITER.Retry at all) to have
>> a try, and caught another command error in the 'its-trigger' test.
>>
>> logs/its-trigger.log:
>> " INT dev_id=2 event_id=20
>> lib/arm64/gic-v3-its-cmd.c:194: assert failed: false: INT timeout! "
>>
>> dmesg:
>> [13297.711958] ------------[ cut here ]------------
>> [13297.711964] ITS command error encoding 0x10307
>>
>> It's the last INT test in test_its_trigger() who has triggered this
>> error, Eric?
> 
> Yes it may be the culprit. Anyway I removed the collection unmap in v6.

I forgot to mention that this is based on your v6. I'll reply to it.

> 
> By the way are you OK now with v6? I think Drew plans to send a pull
> request by the end of this week.

Sorry I haven't looked at it yet (v5 already looks good except for
some minor issues).


Thanks,
Zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
