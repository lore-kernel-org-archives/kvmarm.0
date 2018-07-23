From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 02/20] virtio: pci-legacy: Validate queue pfn
Date: Mon, 23 Jul 2018 13:54:10 +0100
Message-ID: <db295a96-cf1e-9e8b-9b29-5882084781e1@arm.com>
References: <1531905547-25478-1-git-send-email-suzuki.poulose@arm.com>
 <1531905547-25478-3-git-send-email-suzuki.poulose@arm.com>
 <20180722185335-mutt-send-email-mst@kernel.org>
 <5a659490-13ce-87c1-a9bc-d89a8f8ee111@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E04449FA8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jul 2018 08:41:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jkCgKswmYE3x for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Jul 2018 08:40:58 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3986549E14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jul 2018 08:40:58 -0400 (EDT)
In-Reply-To: <5a659490-13ce-87c1-a9bc-d89a8f8ee111@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: cdall@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com, Jason Wang <jasowang@redhat.com>, will.deacon@arm.com, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 23/07/18 10:44, Suzuki K Poulose wrote:
> On 07/22/2018 04:53 PM, Michael S. Tsirkin wrote:
>> On Wed, Jul 18, 2018 at 10:18:45AM +0100, Suzuki K Poulose wrote:
>>> Legacy PCI over virtio uses a 32bit PFN for the queue. If the
>>> queue pfn is too large to fit in 32bits, which we could hit on
>>> arm64 systems with 52bit physical addresses (even with 64K page
>>> size), we simply miss out a proper link to the other side of
>>> the queue.
>>>
>>> Add a check to validate the PFN, rather than silently breaking
>>> the devices.
>>>
>>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>>> Cc: Jason Wang <jasowang@redhat.com>
>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>> Cc: Christoffer Dall <cdall@kernel.org>
>>> Cc: Peter Maydel <peter.maydell@linaro.org>
>>> Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> 
> Michael,
> 
> Thanks.
> 
>>
>> I assume this will be merged through some other tree.
>>
> 
> 
> As such these two virtio patches do not have any code dependencies with
> the rest of the series. So, if you could pick this up it should be fine.
> Otherwise, may be Marc can push it with the rest of the series.
> 
> Marc,
> 
> Are you OK with that ?

Given that these two patches completely independent, I think their
natural path should be the virtio tree. But if Michael doesn't want to
pick them, I'll do it as part of this series.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
