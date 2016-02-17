From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: ensure bitmaps are long enough
Date: Wed, 17 Feb 2016 10:15:14 +0100
Message-ID: <20160217091514.GA6696@cbox>
References: <1455634051-1860-1-git-send-email-mark.rutland@arm.com>
 <56C33C1A.3090703@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7954749947
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2016 04:08:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b3TdjfFRUUi7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Feb 2016 04:08:09 -0500 (EST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 480DE49936
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2016 04:08:08 -0500 (EST)
Received: by mail-wm0-f45.google.com with SMTP id b205so146250249wmb.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2016 01:14:26 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <56C33C1A.3090703@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 16, 2016 at 03:11:22PM +0000, Marc Zyngier wrote:
> On 16/02/16 14:47, Mark Rutland wrote:
> > When we allocate bitmaps in vgic_vcpu_init_maps, we divide the number of
> > bits we need by 8 to figure out how many bytes to allocate. However,
> > bitmap elements are always accessed as unsigned longs, and if we didn't
> > happen to allocate a size such that size % sizeof(unsigned long) == 0,
> > bitmap accesses may go past the end of the allocation.
> > 
> > When using KASAN (which does byte-granular access checks), this results
> > in a continuous stream of BUGs whenever these bitmaps are accessed:
> > 
> > =============================================================================
> > BUG kmalloc-128 (Tainted: G    B          ): kasan: bad access detected
> > -----------------------------------------------------------------------------
> > 
> > INFO: Allocated in vgic_init.part.25+0x55c/0x990 age=7493 cpu=3 pid=1730
> > INFO: Slab 0xffffffbde6d5da40 objects=16 used=15 fp=0xffffffc935769700 flags=0x4000000000000080
> > INFO: Object 0xffffffc935769500 @offset=1280 fp=0x          (null)
> > 
> > Bytes b4 ffffffc9357694f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Object ffffffc935769500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Object ffffffc935769510: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Object ffffffc935769520: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Object ffffffc935769530: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Object ffffffc935769540: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Object ffffffc935769550: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Object ffffffc935769560: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Object ffffffc935769570: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Padding ffffffc9357695b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Padding ffffffc9357695c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Padding ffffffc9357695d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Padding ffffffc9357695e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Padding ffffffc9357695f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > CPU: 3 PID: 1740 Comm: kvm-vcpu-0 Tainted: G    B           4.4.0+ #17
> > Hardware name: ARM Juno development board (r1) (DT)
> > Call trace:
> > [<ffffffc00008e770>] dump_backtrace+0x0/0x280
> > [<ffffffc00008ea04>] show_stack+0x14/0x20
> > [<ffffffc000726360>] dump_stack+0x100/0x188
> > [<ffffffc00030d324>] print_trailer+0xfc/0x168
> > [<ffffffc000312294>] object_err+0x3c/0x50
> > [<ffffffc0003140fc>] kasan_report_error+0x244/0x558
> > [<ffffffc000314548>] __asan_report_load8_noabort+0x48/0x50
> > [<ffffffc000745688>] __bitmap_or+0xc0/0xc8
> > [<ffffffc0000d9e44>] kvm_vgic_flush_hwstate+0x1bc/0x650
> > [<ffffffc0000c514c>] kvm_arch_vcpu_ioctl_run+0x2ec/0xa60
> > [<ffffffc0000b9a6c>] kvm_vcpu_ioctl+0x474/0xa68
> > [<ffffffc00036b7b0>] do_vfs_ioctl+0x5b8/0xcb0
> > [<ffffffc00036bf34>] SyS_ioctl+0x8c/0xa0
> > [<ffffffc000086cb0>] el0_svc_naked+0x24/0x28
> > Memory state around the buggy address:
> >  ffffffc935769400: 00 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >  ffffffc935769480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >> ffffffc935769500: 04 fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >                    ^
> >  ffffffc935769580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >  ffffffc935769600: 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc
> > ==================================================================
> > 
> > Fix the issue by always allocating a multiple of sizeof(unsigned long),
> > as we do elsewhere in the vgic code.
> > 
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > Cc: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  virt/kvm/arm/vgic.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> > index 7a2f449..5d10f10 100644
> > --- a/virt/kvm/arm/vgic.c
> > +++ b/virt/kvm/arm/vgic.c
> > @@ -1875,8 +1875,8 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
> >  static int vgic_vcpu_init_maps(struct kvm_vcpu *vcpu, int nr_irqs)
> >  {
> >  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> > -
> > -	int sz = (nr_irqs - VGIC_NR_PRIVATE_IRQS) / 8;
> > +	int nr_longs = BITS_TO_LONGS(nr_irqs - VGIC_NR_PRIVATE_IRQS);
> > +	int sz = nr_longs * sizeof(unsigned long);
> >  	vgic_cpu->pending_shared = kzalloc(sz, GFP_KERNEL);
> >  	vgic_cpu->active_shared = kzalloc(sz, GFP_KERNEL);
> >  	vgic_cpu->pend_act_shared = kzalloc(sz, GFP_KERNEL);
> > 
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> Worth mentioning:
> 
> Fixes: c1bfb577a ("arm/arm64: KVM: vgic: switch to dynamic allocation")
> Cc: stable@vger.kernel.org
> 
Thanks for this fix:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
