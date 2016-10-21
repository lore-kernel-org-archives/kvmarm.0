From: Andrew Jones <drjones@redhat.com>
Subject: Re: v4.9-rc1 fails booting as a guest on ARM64 Cavium ThunderX
Date: Fri, 21 Oct 2016 13:49:51 +0200
Message-ID: <20161021114951.gm3u6msvl4jz2kv7@kamzik.brq.redhat.com>
References: <924fd627-329a-54e0-694c-a9bdf979f696@redhat.com>
 <de2acaca-f694-be1a-5d2c-93fcf3b25011@arm.com>
 <99c7d3b5-0495-083f-b4b7-b58b20cf859e@redhat.com>
 <5a5e4ed5-a575-f720-36f0-acb545a170f4@arm.com>
 <e52f2867-102f-8aad-4815-2a682586f129@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="3q4q5uoiqpnh4cql"
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e52f2867-102f-8aad-4815-2a682586f129@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, daniel.thompson@linaro.org, Robert Richter <robert.richter@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu


--3q4q5uoiqpnh4cql
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 21, 2016 at 11:46:04AM +0200, Auger Eric wrote:
> Hi Marc,
> On 21/10/2016 11:40, Marc Zyngier wrote:
> > On 21/10/16 10:05, Auger Eric wrote:
> >> Hi Marc,
> >>
> >> On 21/10/2016 10:45, Marc Zyngier wrote:
> >>> +Robert
> >>>
> >>> On 21/10/16 08:01, Auger Eric wrote:
> >>>> Hi,
> >>>>
> >>>> I am not able to boot 4.9-rc1 as a guest on Cavium ThunderX (dt and acpi
> >>>> mode). Bisecting the guest shows that the problem shows up at
> >>>>
> >>>> 91ef84428a86b75a52e15c6fe4f56b446ba75f93
> >>>> irqchip/gic-v3: Reset BPR during initialization
> >>>>
> >>>> If I remove the write to the ICC_BPR1_EL1 register on guest, the VM boots.
> >>>
> >>> That's very odd. A ICC_BPR1_EL1 access when HCR_EL2.IMO is set only
> >>> affects ICH_VMCR_EL2.VBPR1. It is not trapped, since we don't set
> >>> ICH_HCR_EL2.TALL1. It is a very boring sysreg!
> >>>
> >>> So from a pure architectural point of view, I don't see how this can
> >>> fail. I've just run the same configuration on my Freescale board (GICv3
> >>> as well), and can't see any issue at all.
> >>>
> >>>> Investigating KVM code ...
> >>>
> >>> What is the failure syndrome? Do you see it crashing? Locking up? What
> >>> is the PC at that stage?
> >> No guest crash. the guest just locks up. No traces output.
> > 
> > But you're able to kill the guest, right,
> Yes I am
>  and the CPU is not going to
> > lalaland. We should be able to put a breakpoint on this instruction
> > using qemu + GDB, and step it to find out what's happening. Or even
> > execute the instruction in isolation with a bunch of printks in the guest.
> Yep I will investigate this afternoon.
>

You might be able to debug faster with kvm-unit-tests. The attached patch
applies to the arm/gic branch of my repo,

 https://github.com/rhdrjones/kvm-unit-tests/commits/arm/gic

and reproduces the issue. Before applying the attached patch, running

 $ arm/run arm/gic.flat

passes.

 PASS: gicv3: ipi: self: Completed in 100 ms

After applying the patch it times-out

 FAIL: gicv3: ipi: self: Timed-out (5s). ACKS: missing=1 extra=0 unexpected=0

Using the monitor and stopping/starting the vcpu to see what it's doing I
confirmed that we're just spinning in udelay waiting for the interrupt.

So it appears setting this register to zero disables the vcpu's ability
to receive interrupts?

I also read the register before writing it and saw it was 3. I tried
writing 3 instead of 0 to see what would happen, but the failure
persisted. I did read back the register after writing it to confirm the
change took affect.

Thanks,
drew

--3q4q5uoiqpnh4cql
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-arm64-gic-write-bpr1.patch"

>From cd8989fa11255d0bf21d46051a65c3b073a182e6 Mon Sep 17 00:00:00 2001
From: Andrew Jones <drjones@redhat.com>
Date: Fri, 21 Oct 2016 13:22:38 +0200
Subject: [kvm-unit-tests PATCH] arm64: gic: write bpr1

---
 lib/arm/gic.c              | 1 +
 lib/arm64/asm/arch_gicv3.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index bb62407f7286..c44f7614be4d 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -137,6 +137,7 @@ void gicv3_enable_defaults(void)
 	gicv3_redist_wait_for_rwp();
 
 	gicv3_write_pmr(0xf0);
+	gicv3_write_bpr1(0);
 	gicv3_write_ctlr(ICC_CTLR_EL1_EOImode_drop_dir);
 	gicv3_write_grpen1(1);
 }
diff --git a/lib/arm64/asm/arch_gicv3.h b/lib/arm64/asm/arch_gicv3.h
index eff2efdfe2d4..cd9d8c95ef0d 100644
--- a/lib/arm64/asm/arch_gicv3.h
+++ b/lib/arm64/asm/arch_gicv3.h
@@ -18,6 +18,7 @@
 #define ICC_CTLR_EL1			sys_reg(3, 0, 12, 12, 4)
 #define ICC_SRE_EL1			sys_reg(3, 0, 12, 12, 5)
 #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
+#define ICC_BPR1_EL1			sys_reg(3, 0, 12, 12, 3)
 
 #define ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
 
@@ -162,6 +163,11 @@ static inline void gicv3_write_sre(u32 val)
 	isb();
 }
 
+static inline void gicv3_write_bpr1(u32 val)
+{
+	asm volatile("msr_s " __stringify(ICC_BPR1_EL1) ", %0" : : "r" (val));
+}
+
 #define gicv3_read_typer(c)		readq(c)
 #define gicv3_write_irouter(v, c)	writeq(v, c)
 
-- 
2.7.4


--3q4q5uoiqpnh4cql--
