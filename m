From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] updated: arm64: KVM: vgic: deal with GIC sub-page
 alignment
Date: Fri, 1 Jul 2016 09:40:42 +0100
Message-ID: <57762C8A.8060105@arm.com>
References: <5775F854.3060306@riken.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78AFB49B42
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2016 04:35:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s2G7q6BcN7fW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jul 2016 04:35:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3A9349B21
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2016 04:35:26 -0400 (EDT)
In-Reply-To: <5775F854.3060306@riken.jp>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Itaru Kitayama <itaru.kitayama@riken.jp>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Itaru,

On 01/07/16 05:57, Itaru Kitayama wrote:
> This is merely an update to the patch Marc posted in 2014:
> 
> https://lists.cs.columbia.edu/pipermail/kvmarm/2014-June/010055.html
> 
> This updated patch is against today's current kvmarm git tree tag,
> kvm-for-arm-v4.7-rc6.
> 
> The GIC CPU interface is always 4k aligned. If the host is using
> 64k pages, it is critical to place the guest's GICC interface at the
> same relative alignment as the host's GICV. Failure to do so results
> in an impossibility for the guest to deal with interrupts.
> 
> Add a KVM_DEV_ARM_VGIC_GRP_ADDR_OFFSET attribute for the VGIC, allowing
> userspace to retrieve the GICV offset in a page. It becomes then trivial
> to adjust the GICC base address for the guest.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>>
> Signed-off-by: Itaru Kitayama <itaru.kitayama@riken.jp>

I'm working on a much more complete patch series that deals with this
and a bit more. Hopefully for the 4.9 time frame.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
