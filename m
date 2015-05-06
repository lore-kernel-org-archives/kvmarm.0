From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC v2 0/4] chip/vgic adaptations for forwarded irq
Date: Wed, 06 May 2015 17:32:53 +0200
Message-ID: <554A3425.7070909@linaro.org>
References: <1423642857-24240-1-git-send-email-eric.auger@linaro.org>
 <20150506142748.GC6796@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EDFB509BA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 May 2015 11:26:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HvgX-W1+lo-f for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 May 2015 11:26:46 -0400 (EDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
 [209.85.212.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 639CD50943
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 May 2015 11:26:45 -0400 (EDT)
Received: by widdi4 with SMTP id di4so27186537wid.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 May 2015 08:35:33 -0700 (PDT)
In-Reply-To: <20150506142748.GC6796@cbox>
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
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/06/2015 04:27 PM, Christoffer Dall wrote:
> Hi Eric,
> 
> On Wed, Feb 11, 2015 at 09:20:53AM +0100, Eric Auger wrote:
>> This series proposes some fixes that appeared to be necessary
>> to integrate IRQ forwarding in KVM/VFIO.
>>
>> - deactivation of the forwarded IRQ in irq_disabled case
>> - a specific handling of forwarded IRQ into the VGIC state machine.
>> - deactivation of physical IRQ and unforwarding on vgic destruction
>> - rb_tree lock in vgic.c
>>
>> Integrated pieces can be found at
>> ssh://git.linaro.org/people/eric.auger/linux.git
>> on branch irqfd_integ_v9
>>
> What are the dependencies for this at this point?
> 
> I assume it relies at least on the split EOI/priority drop changes?

Yes it now only depends on split EOI/priority drop changes since
"genirq: Saving/restoring the irqchip state of an irq line" now is
upstreamed.

> 
> Are you going to respin this when there are newer versions of the
> dependencies out, or what are the plans?

Yes I will respin according to new versions. I am currently using a
rebased version of Marc's original RFC "ARM: Forwarding physical
interrupts to a guest VM" (http://lwn.net/Articles/603514/) which is a
superset of [PATCH] genirq: Add support for priority-drop/deactivate
interrupt controllers.

- Eric
> 
> Thanks,
> -Christoffer
> 
