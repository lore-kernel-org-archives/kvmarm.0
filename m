Return-Path: <SRS0=zNRV=2K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C161C43603
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 07:34:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1E2AE24679
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 07:34:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E2AE24679
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E3924AC65;
	Fri, 20 Dec 2019 02:34:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l5vtPixUB+gV; Fri, 20 Dec 2019 02:34:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A68844A5A3;
	Fri, 20 Dec 2019 02:34:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C2744A576
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 02:34:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VFnXlcfsSJmS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Dec 2019 02:34:33 -0500 (EST)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 515924A54B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 02:34:33 -0500 (EST)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 3DF20FFEDCEF0B4DF2E7;
 Fri, 20 Dec 2019 15:34:29 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Fri, 20 Dec 2019
 15:34:22 +0800
Subject: Re: [kvm-unit-tests PATCH 05/16] arm/arm64: ITS: Introspection tests
To: Auger Eric <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
 <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>
References: <20191216140235.10751-1-eric.auger@redhat.com>
 <20191216140235.10751-6-eric.auger@redhat.com>
 <c133ebe6-10f4-2ff7-f75f-75b755397785@huawei.com>
 <6542297b-74d2-f3c2-63d8-04bb284414df@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <c164db0f-2e18-093f-8886-4746cb197fe2@huawei.com>
Date: Fri, 20 Dec 2019 15:34:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <6542297b-74d2-f3c2-63d8-04bb284414df@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: andre.przywara@arm.com, thuth@redhat.com
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

On 2019/12/18 16:34, Auger Eric wrote:
> Hi Zenghui,
> 
> On 12/18/19 4:46 AM, Zenghui Yu wrote:
>> Hi Eric,
>>
>> I have to admit that this is the first time I've looked into
>> the kvm-unit-tests code, so only some minor comments inline :)
> 
> no problem. Thank you for looking at this.
> 
> By the way, with patch 16 I was able to test yout fix: "KVM: arm/arm64:
> vgic: Don't rely on the wrong pending table". Reverting it produced an
> error.

which is great! Thanks for your work!


Zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
