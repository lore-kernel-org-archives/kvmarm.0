From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v4 00/21] SError rework + RAS&IESB for firmware first
 support
Date: Wed, 15 Nov 2017 17:15:07 +0800
Message-ID: <e0dea261-a9ef-9d00-682a-a4449d1de5ec@huawei.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <5A049B20.6000501@arm.com> <20171113112946.GK14144@cbox>
 <5A0B13B5.3000205@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14C2449D6E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Nov 2017 04:13:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5HshiaybN2j2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Nov 2017 04:13:42 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8C7C49D57
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Nov 2017 04:13:40 -0500 (EST)
In-Reply-To: <5A0B13B5.3000205@arm.com>
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
To: James Morse <james.morse@arm.com>, Christoffer Dall <cdall@linaro.org>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi james,

On 2017/11/15 0:03, James Morse wrote:
>> Hope this helps?
> Yes, I'll go looking for a way to expose VSESR_EL2 to user-space.

what is the purpose to expose VSESR_EL2?
do you mean set its value after migration?

May be we can use similar below Mechanism
https://www.spinics.net/lists/arm-kernel/msg603525.html

when user-space sync the register status, it will get these register value.
it will reuse the IOCTL KVM_GET_ONE_REG and no need to add extra API.

> 
> 
> Thanks!
> 
> James
