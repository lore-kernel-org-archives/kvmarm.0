From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: Potential deadlock in vgic
Date: Fri, 4 May 2018 15:51:20 +0100
Message-ID: <1f343d54-03a2-10b4-1413-c0fa4a84bb7e@arm.com>
References: <20180504110343.GA10968@hc>
 <20180504124742.GG10191@C02W217FHV2R.local> <20180504130854.GA14663@hc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180504130854.GA14663@hc>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Jan Glauber <jan.glauber@caviumnetworks.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 04/05/18 14:08, Jan Glauber wrote:
> On Fri, May 04, 2018 at 02:47:42PM +0200, Christoffer Dall wrote:
>> Hi Jan,
>>
>> On Fri, May 04, 2018 at 01:03:44PM +0200, Jan Glauber wrote:
>>> Hi all,
>>>
>>> enabling lockdep I see the following reported in the host when I start a kvm guest:
>>>
>>> [12399.954245]        CPU0                    CPU1
>>> [12399.958762]        ----                    ----
>>> [12399.963279]   lock(&(&dist->lpi_list_lock)->rlock);
>>> [12399.968146]                                local_irq_disable();
>>> [12399.974052]                                lock(&(&vgic_cpu->ap_list_lock)->rlock);
>>> [12399.981696]                                lock(&(&dist->lpi_list_lock)->rlock);
>>> [12399.989081]   <Interrupt>
>>> [12399.991688]     lock(&(&vgic_cpu->ap_list_lock)->rlock);
>>> [12399.996989]
>>>                 *** DEADLOCK ***
>>>
>>> [12400.002897] 2 locks held by qemu-system-aar/5597:
>>> [12400.007587]  #0: 0000000042beb9dc (&vcpu->mutex){+.+.}, at: kvm_vcpu_ioctl+0x7c/0xa68
>>> [12400.015411]  #1: 00000000c45d644a (&(&vgic_cpu->ap_list_lock)->rlock){-.-.}, at: kvm_vgic_sync_hwstate+0x8c/0x328
>>>
>>>
>>> There is nothing unusual in my config or qemu parameters, I can upload these
>>> if needed. I see this on ThunderX and ThunderX2 and also with older kernels
>>> (4.13+ distribution kernel).
>>>
>>> I tried making the lpi_list_lock irq safe but that just leads to different
>>> warnings. The locking here seems to be quite sophisticated and I'm not familiar
>>> with it.
>>
>> That's unfortunate.  The problem here is that we end up violating our
>> locking order, which stipulates that ap_list_lock must be taken before
>> the lpi_list_lock.
>>
>> Give that we can take the ap_list_lock from interrupt context (timers
>> firing), the only solution I can easily think of is to change
>> lpi_list_lock takers to disable interrupts as well.
>>
>> Which warnings did you encounter with that approach?
> 
> Hi Christoffer,
> 
> making lpi_list_lock irq safe I get:
> 
> [  394.239174] ========================================================
> [  394.245515] WARNING: possible irq lock inversion dependency detected
> [  394.251857] 4.17.0-rc3-jang+ #72 Not tainted
> [  394.256114] --------------------------------------------------------
> [  394.262454] qemu-system-aar/5596 just changed the state of lock:
> [  394.268448] 00000000da3f09ef (&(&irq->irq_lock)->rlock#3){+...}, at: update_affinity+0x3c/0xa8
> [  394.277066] but this lock was taken by another, HARDIRQ-safe lock in the past:
> [  394.284274]  (&(&vgic_cpu->ap_list_lock)->rlock){-.-.}
> [  394.284278] 
>                
>                and interrupts could create inverse lock ordering between them.
> 
> [  394.300777] 
>                other info that might help us debug this:
> [  394.307292]  Possible interrupt unsafe locking scenario:
> 
> [  394.314066]        CPU0                    CPU1
> [  394.318584]        ----                    ----
> [  394.323101]   lock(&(&irq->irq_lock)->rlock#3);
> [  394.327622]                                local_irq_disable();
> [  394.333528]                                lock(&(&vgic_cpu->ap_list_lock)->rlock);
> [  394.341172]                                lock(&(&irq->irq_lock)->rlock#3);
> [  394.348210]   <Interrupt>
> [  394.350817]     lock(&(&vgic_cpu->ap_list_lock)->rlock);
> [  394.356118] 

That's weird, as that shouldn't happen anymore. IIRC we switched *both*
ap_list_lock and irq_lock over to be IRQ safe, so the first lock on CPU0
would disable IRQs, making the interrupt afterwards impossible.
Did we actually forget some irq_lock's to convert over and lockdep is
picking those up?

So if this is the case, we should be fine by making the missing ones
irqsave as well, then adding _irqsave to the lpi_list_lock, which has
just a few users and guards only short critical sections contained
within a function.

Cheers,
Andre.

>                 *** DEADLOCK ***
> 
> [  394.362025] 4 locks held by qemu-system-aar/5596:
> [  394.366716]  #0: 00000000719c7423 (&vcpu->mutex){+.+.}, at: kvm_vcpu_ioctl+0x7c/0xa68
> [  394.374545]  #1: 0000000060090841 (&kvm->srcu){....}, at: kvm_handle_guest_abort+0x11c/0xb70
> [  394.382984]  #2: 0000000064647766 (&its->cmd_lock){+.+.}, at: vgic_mmio_write_its_cwriter+0x44/0xa8
> [  394.392022]  #3: 0000000075f90a8a (&its->its_lock){+.+.}, at: vgic_its_process_commands.part.11+0xac/0x780
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
