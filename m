From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v10 00/21] KVM: ARM64: Add guest PMU support
Date: Thu, 28 Jan 2016 22:30:44 +0100
Message-ID: <20160128213044.GM16453@hawk.localdomain>
References: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6453B407A6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2016 16:25:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uDO+3x1Hy04G for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Jan 2016 16:25:47 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2BEE9407A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2016 16:25:46 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, shannon.zhao@linaro.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 27, 2016 at 11:51:28AM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> This patchset adds guest PMU support for KVM on ARM64. It takes
> trap-and-emulate approach. When guest wants to monitor one event, it
> will be trapped by KVM and KVM will call perf_event API to create a perf
> event and call relevant perf_event APIs to get the count value of event.
> 
> Use perf to test this patchset in guest. When using "perf list", it
> shows the list of the hardware events and hardware cache events perf
> supports. Then use "perf stat -e EVENT" to monitor some event. For
> example, use "perf stat -e cycles" to count cpu cycles and
> "perf stat -e cache-misses" to count cache misses.
>

Hi Shannon,

I just completed my first full review of the series. I'm sorry I didn't
have time to do a full review on an earlier version. I have a few comments,
but most of them are minor. If you'd like to add some r-b's from me, then
here are the patches I can offer them for

1-5,8,9,11-13,16-21

5,8,9,12 had some extra masking on input/outputs that I'm not sure is
necessary.

Thanks,
drew
