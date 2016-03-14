From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 00/16] KVM: arm64: GICv3 ITS emulation
Date: Mon, 14 Mar 2016 11:13:14 +0000
Message-ID: <56E69CCA.5070407@arm.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
 <56E00A7E.4080101@semihalf.com> <20160313181608.GA15988@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F477410D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 07:13:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6NskrnLGozIl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2016 07:13:03 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0B2A40F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 07:13:02 -0400 (EDT)
In-Reply-To: <20160313181608.GA15988@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Tomasz Nowicki <tn@semihalf.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 13/03/16 18:16, Christoffer Dall wrote:
> On Wed, Mar 09, 2016 at 12:35:26PM +0100, Tomasz Nowicki wrote:
>> Hi Andre,
>>
>> Forgive me if anybody already asked this question for previous
>> series versions.
>>
>> The review is still pending so it is worth to ask. What is your idea
>> for saving and restoring vITS state? I notice device, itte and
>> collection linked lists which are essential for vITS state. Of
>> course it is not feasible to transfer these list to e.g. QEMU using
>> KVM_{GET|SET}_DEVICE_ATTR.
>>
> If I recall correctly these items are the ones stored in memory on real
> hardware, and not in hardware registers.

Potentially, but not necessarily.

> We had an idea where userspace asks the kernel vgic to flush its
> internal cache into the memory allocated by the guest driver for the
> vITS data structures and then the state would be transferred across to
> the new VM via the memory transfer mechanism.

The problem with this idea is that we currently don't use guest memory
to hold those data structures. As we report 0 on reads for all BASER<n>
registers, this includes Type=0 for each register, which translates into
"Unimplemented", so a guest OS would never allocate memory for it.
Instead we claim to hold all information in our "cache" (aka. host
memory). This has several advantages, but obviously breaks this
save/restore approach.
So I see two ways to fix this:
1.) we find a KVM specific way of letting userland save and restore the
ITS tables directly
2.) we implement the BASER<n> registers, but still use our "cache" for
normal operations. On demand we would serialize KVM's virtual ITS data
structures and put them into the guest's memory, so they could be
saved/restored from there.

> Only caveat there I think was that we had to decide on a storage format
> in those memory regions, to allow QEMU to understand the state and to
> ensure back/forwards compatibility between KVM versions.

Do we need QEMU to actually understand this? Can't we just leave this
all to the kernel and QEMU just passes on the data? That would still
require some ABI stability between kernel versions in this respect, but
it's less problematic than exposing the data format to userland at all.

Cheers,
Andre.
