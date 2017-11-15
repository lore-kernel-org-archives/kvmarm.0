From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v4 00/21] SError rework + RAS&IESB for firmware first
 support
Date: Wed, 15 Nov 2017 17:59:41 +0800
Message-ID: <e73be829-7a05-a354-43f3-538f7a393306@huawei.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <5A049B20.6000501@arm.com> <20171113112946.GK14144@cbox>
 <20171113161445.xfqyuntza76ckdmq@hawk.localdomain> <5A0B1597.3030809@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 413AD49D97
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Nov 2017 04:57:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GugMhpe3aG9V for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Nov 2017 04:57:47 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C86DE49D56
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Nov 2017 04:57:45 -0500 (EST)
In-Reply-To: <5A0B1597.3030809@arm.com>
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
To: James Morse <james.morse@arm.com>, Andrew Jones <drjones@redhat.com>
Cc: Jonathan.Zhang@cavium.com, Christoffer Dall <cdall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

> 
> (While VSESR_EL2 is 64bit[0], the value gets written into the ESR, which is
> 32bit, so I doubt the top 32bits can be used, currently they are all reserved.)

In fact the valid bits for vsesr_el2 is 25bit, which will set to ESR.ISS, bits [24:0].
ESR.IL and ESR.EC are not set by vsesr_el2.

> 
> I'll go dig into how x86 uses this...
> 
> 
> Thanks!
> 
> James
> 
> 
> [0]
> https://static.docs.arm.com/ddi0587/a/RAS%20Extension-release%20candidate_march_29.pdf
> 
> .
> 
