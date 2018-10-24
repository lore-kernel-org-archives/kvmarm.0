From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: ARM64 KVM crash
Date: Wed, 24 Oct 2018 17:40:42 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1810241738390.871@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1810121204120.16008@file01.intranet.prod.int.rdu2.redhat.com>
 <b3355304-5144-b17a-c39c-866e197e3cc6@arm.com>
 <alpine.LRH.2.02.1810121453380.14664@file01.intranet.prod.int.rdu2.redhat.com>
 <86h8hqtd4m.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <86h8hqtd4m.wl-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu



On Sat, 13 Oct 2018, Marc Zyngier wrote:

> On Fri, 12 Oct 2018 19:59:16 +0100,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > 
> > 
> > On Fri, 12 Oct 2018, Marc Zyngier wrote:
> > 
> > > Right. But how is that related to KVM? See below:
> > > 
> > > > [75476.680725]  find_next_and_bit+0xc/0x70
> > > > [75476.680728]  find_busiest_group+0x128/0x938
> > > > [75476.680730]  load_balance+0x148/0x848
> > > > [75476.680732]  pick_next_task_fair+0x1d4/0x568
> > > > [75476.680734]  __schedule+0xe8/0x4b0
> > > > [75476.680736]  schedule+0x38/0xa0
> > > > [75476.680739]  kvm_vcpu_block+0x88/0x180
> > > > [75476.680742]  kvm_handle_wfx+0x80/0xb8
> > > > [75476.680744]  handle_exit+0x138/0x1b8
> > > 
> > > The guest is exiting because it has executed a blocking WFI, so KVM's
> > > job is done and we're calling schedule(). The scheduler then starts
> > > doing its job of picking the next victim.
> > > 
> > > At this stage, the kernel indeed blows up. But this doesn't immediately
> > > seem to be KVM's fault. It is far more likely that the scheduler has
> > > messed something up in its own data structure, which is even worse :-(.
> > > 
> > > I'd suggest you get in touch with the scheduler guys to see if they have
> > > any insight. Also, trying to come up with a reproducer would be
> > > extremely useful.
> > > 
> > > Thanks,
> > > 
> > > 	M.
> > 
> > I use this machine most of the time without KVM - and it crashed when I 
> > started KVM - so I assume that KVM had something to do with it. Perhaps it 
> > corrupts random memory? I may try to run some KVM stress for many days to 
> > test if I reproduce it.
> 
> One thing I know for sure is that if you use a tap (such as macvtap)

I don't have macvtap compiled. The board is also used as a router and the 
virtual machine bridge uses the same routing tables and iptables rules as 
anything else.

> to give networking to your VMs, the Ethernet driver on the 8040 (such
> as on your MacchiatoBin) will happily corrupt memory (you can witness
> that without running KVM at all). Something to do with the sbk being
> freed early.
> 
> I've reported this issue several times, only to hear the wind
> blowing. At this stage, I've shelved it. There is enough decent and
> maintained platforms around not to worry about the unmaintained stuff.
> 
> Now, if you can give me a reproducer, I'll happily investigate.

I haven't reproduced it so far :-(

> Thanks,
> 
> 	M.

Mikulas
