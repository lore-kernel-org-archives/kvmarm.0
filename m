From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v4 02/20] virtio: pci-legacy: Validate queue pfn
Date: Mon, 23 Jul 2018 10:44:23 +0100
Message-ID: <5a659490-13ce-87c1-a9bc-d89a8f8ee111@arm.com>
References: <1531905547-25478-1-git-send-email-suzuki.poulose@arm.com>
 <1531905547-25478-3-git-send-email-suzuki.poulose@arm.com>
 <20180722185335-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 276A7408AD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jul 2018 05:30:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TWI87zJ6wcsi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Jul 2018 05:30:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDB21408AA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jul 2018 05:30:36 -0400 (EDT)
In-Reply-To: <20180722185335-mutt-send-email-mst@kernel.org>
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
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, Jason Wang <jasowang@redhat.com>, will.deacon@arm.com, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/22/2018 04:53 PM, Michael S. Tsirkin wrote:
> On Wed, Jul 18, 2018 at 10:18:45AM +0100, Suzuki K Poulose wrote:
>> Legacy PCI over virtio uses a 32bit PFN for the queue. If the
>> queue pfn is too large to fit in 32bits, which we could hit on
>> arm64 systems with 52bit physical addresses (even with 64K page
>> size), we simply miss out a proper link to the other side of
>> the queue.
>>
>> Add a check to validate the PFN, rather than silently breaking
>> the devices.
>>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Cc: Jason Wang <jasowang@redhat.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <cdall@kernel.org>
>> Cc: Peter Maydel <peter.maydell@linaro.org>
>> Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>


Michael,

Thanks.

> 
> I assume this will be merged through some other tree.
>


As such these two virtio patches do not have any code dependencies with
the rest of the series. So, if you could pick this up it should be fine.
Otherwise, may be Marc can push it with the rest of the series.

Marc,

Are you OK with that ?

Suzuki
