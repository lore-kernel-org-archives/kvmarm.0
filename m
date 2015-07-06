From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH 0/3] arm: KVM: VFP lazy switch in KVM Host Mode may save
 upto 98%
Date: Mon, 06 Jul 2015 11:43:05 -0700
Message-ID: <559ACC39.7030609@samsung.com>
References: <1435203028-23142-1-git-send-email-m.smarduch@samsung.com>
 <20150705193758.GD3869@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 550B757D1E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 14:31:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qBfrtOGpJFoc for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2015 14:31:44 -0400 (EDT)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A3F957D1D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 14:31:44 -0400 (EDT)
Received: from uscpsbgex2.samsung.com
 (u123.gpu85.samsung.co.kr [203.254.195.123]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NR20036OXBZR960@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 06 Jul 2015 14:43:11 -0400 (EDT)
In-reply-to: <20150705193758.GD3869@cbox>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/05/2015 12:37 PM, Christoffer Dall wrote:
> Hi Mario,
> 
> On Wed, Jun 24, 2015 at 08:30:25PM -0700, Mario Smarduch wrote:
>> Currently we do a lazy VFP switch in Hyp mode, but once we exit and re-enter hyp
>> mode we trap again on VFP access. This mode has shown around 30-50% improvement
>> running hackbench and lmbench.
>>
>> This patch series extends lazy VFP switch beyond Hyp mode to KVM host mode.
>>
>> 1 - On guest access we switch from host to guest and set a flag accessible to 
>>     host
>> 2 - On exit to KVM host, VFP state is restored on vcpu_put if flag is marked (1)
>> 3 - Otherwise guest is resumed and continues to use its VFP registers. 
>> 4 - In case of 2 on VM entry we set VFP trap flag to repeat 1.
>>
>> If guest does not access VFP registers them implemenation remains the same.
>>
>> Executing hackbench on Fast Models and Exynos arm32 board shows good
>> results. Considering all exits 2% of the time KVM host lazy vfp switch is 
>> invoked.
>>
>> Howeverr this patch set requires more burn in time and testing under various 
>> loads.
>>
>> Currently ARM32 is addressed later ARM64.
>>
> I think Marc said that he experimented with a similar patch once, but
> that it caused corruption on the host side somehow.
> 
> Am I remembering correctly?  If so, we would need to make sure this
> doesn't happen with this patch set...

I think upstreaming the basic approach first (arm64, arm32 cleanups),
and let this series get some good runtime - would be better
and safer approach.


> 
> Otherwise I think this sounds like a fairly good idea and I wonder if
> the same could be done on arm64?

Yes that's the intent, doing both architectures at once would be preferable.

Thanks,
  Mario
> 
> Thanks,
> -Christoffer
> 
