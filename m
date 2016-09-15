From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v4 00/10] ARM: KVM: Support for vgic-v3
Date: Thu, 15 Sep 2016 11:33:58 +0100
Message-ID: <57DA7916.4060706@arm.com>
References: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
 <20160915091334.GB23629@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C02AF49B66
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Sep 2016 06:25:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m+tTmj9MMcl9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Sep 2016 06:25:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A3FF49B3F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Sep 2016 06:25:17 -0400 (EDT)
In-Reply-To: <20160915091334.GB23629@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 15/09/16 10:13, Christoffer Dall wrote:
> Hi Valdimir,
> 
> On Mon, Sep 12, 2016 at 03:49:14PM +0100, Vladimir Murzin wrote:
>> Hi,
>>
>> This is an attempt to make use vgic-v3 under arch/arm since
>> save-restore functionality got re-written in C and can be shared
>> between arm/arm64 like it has already been done for vgic-v2 and timer.
>>
>> With this patches I'm able to get 32 core an AArch32 ARMv8 guest boot:
>>
>> ...
>> GICv3: CPU31: found redistributor 703 region 0:0x000000003ffd0000
>> CPU31: thread -1, cpu 3, socket 7, mpidr 80000703
>> Brought up 32 CPUs
>> SMP: Total of 32 processors activated (768.00 BogoMIPS).
>> CPU: All CPU(s) started in SVC mode.
>> ...
>>
>> Additionally, quite lightweight test based on Self IPI guest test[1]
>> has been run with up to 255 cpus.
>>
> I have applied this to kvmarm/queue, fixing up a few trivial conflicts,
> and I have changed the kvm_info message.

Great!

> 
> If you could test the integrated branch with GICv3 on a 32-bit platform,
> that would be great.

I've just pulled kvmarm/queue and started testing.

> 
> I'll give people a few days to give their acks to the non-KVM part of
> the series and will then put it in next.
> 

Thanks!
Vladimir

> Thanks for the work,
> -Christoffer
> 
> 
