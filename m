From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH] KVM: arm64: handle the translation table walk RAS error
Date: Thu, 30 Nov 2017 19:32:25 +0800
Message-ID: <e7b232bb-0f00-f250-cf63-2da04b9360f8@huawei.com>
References: <1511988524-30240-1-git-send-email-gengdongjiu@huawei.com>
 <20171129132212.GA10563@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EEF549D6B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Nov 2017 06:29:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EEMpKSL4JYZ6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Nov 2017 06:29:58 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D851A49D09
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Nov 2017 06:29:57 -0500 (EST)
In-Reply-To: <20171129132212.GA10563@lvm>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: wuquanming@huawei.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linuxarm@huawei.com, linux-arm-kernel@lists.infradead.org, huangshaoyu@huawei.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


On 2017/11/29 21:22, Christoffer Dall wrote:
>> table, but it already unmap by host APEI driver, then
>> generate stage2 data abort again, so this will lead to dead
>> loop.
> Why does it lead to a loop? If the host has marked a page as unusable,
> shouldn't the guest stage 1 page table be backed by a different page
> when the fault happens on stage 2?

Thanks a lot for the question and reply, I will test more to confirm it.

> 
