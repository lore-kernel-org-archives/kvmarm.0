From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC] Question about enable doorbell irq and halt_poll process
Date: Wed, 20 Mar 2019 17:02:19 +0000
Message-ID: <20190320170219.510f2e1e@why.wild-wind.fr.eu.org>
References: <0fb3c9ba-8428-ea6c-2973-952624f601cc@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0fb3c9ba-8428-ea6c-2973-952624f601cc@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Tangnianyao (ICT)" <tangnianyao@huawei.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Linuxarm <linuxarm@huawei.com>, guoheyi@huawei.com, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 19 Mar 2019 21:25:47 +0800
"Tangnianyao (ICT)" <tangnianyao@huawei.com> wrote:

> Hi, all
> 
> Using gicv4, when guest is waiting for irq, it sends wfi and traps to kvm.
> When vlpi is forwarded to PE after its_vpe_deschedule, before halt_poll in
> kvm_vcpu_block, halt_poll may increase latency for this vlpi getting to guest.
> In halt_poll process, it checks if there's pending irq for vcpu using pending_last.
> However, doorbell is not enable at this moment and vlpi or doorbell can not set
> pending_last true, to stop halt_poll. It will run until halt_poll time ends, if
> there's no other physical irq coming in the meantime. And then vcpu is scheduled out.
> This pending vlpi has to wait for vcpu getting schedule in next time.
> 
> Should we enable doorbell before halt_poll process ?

Enabling doorbells can be quite expensive. Depending on the HW, this is
either:

- a write to memory (+DSB, potential cache maintenance), a write to the
  INVLPI register, and a poll of the SYNC register
- a write to memory (+DSB, potential cache maintenance), potentially
  a string of DISCARD+SYNC+MAPI+SYNC commands, and an INV+SYNC command

Frankly, you want to be careful with that. I'd rather enable them late
and have a chance of not blocking because of another (virtual)
interrupt, which saves us the doorbell business.

I wonder if you wouldn't be in a better position by drastically
reducing halt_poll_ns for vcpu that can have directly injected
interrupts.

In any case, this is something that we should measure, not guess.

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
