From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v9 07/11] arm/arm64: vgic: Implement
 KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl
Date: Wed, 30 Nov 2016 07:10:51 +0000
Message-ID: <CAFEAcA_1i7-ti_H_RZrTbCW2DmFPvYudKn_WFs=_XRoyKKsnbQ@mail.gmail.com>
References: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
 <1479906118-15832-8-git-send-email-vijay.kilari@gmail.com>
 <20161128195028.GH18170@cbox>
 <CALicx6uW5RmjsPPBKB5wLW4TzNmcdc9ZADqp=M2ZJe9Cd+keZg@mail.gmail.com>
 <20161129210901.GC15346@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20161129210901.GC15346@cbox>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Vijay Kilari <vijay.kilari@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, Pavel Fedin <p.fedin@samsung.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 29 November 2016 at 21:09, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> Actually, I'm not sure what the semantics of the line level ioctl should
> be for edge-triggered interrupts?  My inclination is that it shouldn't
> have any effect at this point, but that would mean that at this point we
> should only set the pending variable and try to queue the interrupt if
> the config is level.  But that also means that when we set the config
> later, we need to try to queue the interrupt, which we don't do
> currently, because we rely on the guest not fiddling with the config of
> an enabled interrupt.
>
> Could it be considered an error if user space tries to set the level for
> an edge-triggered interrupt and therefore something we can just ignore
> and assume that the corresponing interrupt will be configured as a
> level-triggered one later?

Userspace will always read the line-level values out and write
them back for migration, and I'd rather not make it have to
do cross-checks against whether the interrupt is edge or level
triggered to see whether it should write the level values into
the kernel. Telling the kernel the level for an edge-triggered
interrupt should be a no-op because it doesn't have any effect
on pending status.

> In any case we probably need to clarify the ABI in terms of this
> particular KVM_DEV_AR_VGIC_GRP_LEVEL_INFO group and how it relates to
> the config of edge vs. level of interrupts and ordering on restore...

IIRC the QEMU code restores the config first. (There's a similar
ordering thing for GICv2 where we have to restore GICD_ICFGRn before
GICD_ISPENDRn.)

thanks
-- PMM
