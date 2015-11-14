From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH 3/3] KVM/arm64: enable enhanced armv8 fp/simd lazy switch
Date: Sat, 14 Nov 2015 15:04:23 -0800
Message-ID: <5647BDF7.5070209@samsung.com>
References: <1446242193-8424-1-git-send-email-m.smarduch@samsung.com>
 <1446242193-8424-4-git-send-email-m.smarduch@samsung.com>
 <20151105150255.GD5819@cbox> <5641288B.90105@samsung.com>
 <20151110111822.GC12968@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5C3849616
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Nov 2015 18:04:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FEItIFvT61Ea for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Nov 2015 18:04:03 -0500 (EST)
Received: from usmailout3.samsung.com (mailout3.w2.samsung.com
 [211.189.100.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C15048535
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Nov 2015 18:04:02 -0500 (EST)
Received: from uscpsbgex4.samsung.com
 (u125.gpu85.samsung.co.kr [203.254.195.125]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NXT00KSPURD0550@usmailout3.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Sat, 14 Nov 2015 18:04:25 -0500 (EST)
In-reply-to: <20151110111822.GC12968@cbox>
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
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 11/10/2015 3:18 AM, Christoffer Dall wrote:
> On Mon, Nov 09, 2015 at 03:13:15PM -0800, Mario Smarduch wrote:
>>
>>
>> On 11/5/2015 7:02 AM, Christoffer Dall wrote:
>>> On Fri, Oct 30, 2015 at 02:56:33PM -0700, Mario Smarduch wrote:
[....]
>> kern_hyp_va x0
>> add x2, x0, #VCPU_CONTEXT
>> mrs x1, fpexec32_el2
>> str x1, [x2, #CPU_SYSREG_OFFSET(FPEXC32_EL2)]
>> ret
>>
>> Of course each hyp call has additional overhead, at a high exit to
>> vcpu_put ratio hyp call appears better. But all this is very
>> highly dependent on exit rate and fp/simd usage. IMO hyp call
>> works better under extreme loads should be pretty close
>> for general loads.
>>
>> Any thoughts?
>>
> I think the typical case will be lots of exits and few
> vcpu_load/vcpu_put, and I think it's reasonable to write the code that
> way.

Yes, especially for RT guests where vCPU is pinned.

Thanks.
> 
> That should also be much better for VHE.
> 
> So I would go that direction.
> 
> Thanks,
> -Christoffer
> 
