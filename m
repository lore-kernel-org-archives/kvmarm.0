From: Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH v1 2/4] KVM: arm/arm64: vgic: Improve comment on
 kvm_vgic_inject_irq
Date: Mon, 25 Feb 2019 08:09:17 +0800
Message-ID: <20190225000917.GA4001@leoy-ThinkPad-X240s>
References: <20190222082327.3312-1-leo.yan@linaro.org>
 <20190222082327.3312-3-leo.yan@linaro.org>
 <20190222083756.359523ca@why.wild-wind.fr.eu.org>
 <20190222085439.GA845@leoy-ThinkPad-X240s>
 <20190222093923.09e36583@why.wild-wind.fr.eu.org>
 <20190222124906.GB845@leoy-ThinkPad-X240s>
 <86r2bzrful.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <86r2bzrful.wl-marc.zyngier@arm.com>
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
Cc: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, linux-kernel@vger.kernel.org, Jun Yao <yaojun8558363@gmail.com>, James Morse <james.morse@arm.com>, Andre Przywara <andre.przywara@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 22, 2019 at 03:40:50PM +0000, Marc Zyngier wrote:

[...]

> > > The interrupt affinity is either defined by the distributor
> > > configuration (SPIs) or the ITS configuration (LPIs).
> > 
> > Given to the up example, I am struggling to understand how you can set
> > the interrupt affinity for virtio device.
> > 
> > Do you set the physical interrupt affinity to CPU0/1 in host OS and
> > forward it to guest OS?  Or set interrupt affinity in guest OS (I
> > tried on Juno board to set irq affinity in guest OS from
> > '/proc/irq/xxx/smp_affinity' but failed)?   Or this is accomplished by
> > user space tool (lkvm or qemu)?
> 
> virtio interrupts are purely virtual, and the host plays no part in
> their routing (nor does userspace). As for their affinity, that
> depends on the virtio driver. Some virtio devices allow their affinity
> to be changed, some don't. Here, this is a virtio-net device, which is
> perfectly happy to see its queue interrupts moved to a different vcpu.
> 
> I tend to run irqbalance in my guests so that it actually exercises
> the affinity setting in the background.
> 
> > Sorry if I am asking a stupid question :)
> 
> It's not stupid. You're simply confusing multiple independent layers.

Thanks a lot for explaination, Marc.

Thanks,
Leo Yan
