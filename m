From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v3 0/2] KVM: ARM: Enable vtimers with user space gic
Date: Fri, 16 Sep 2016 14:43:29 +0200
Message-ID: <FE01F921-046D-4536-8D69-CE702E2FF375@suse.de>
References: <1474007187-18673-1-git-send-email-agraf@suse.de> <57DBC782.7080305@arm.com> <060ADA14-786E-400E-9B11-61C34B7081B5@suse.de> <20160916122937.GA14140@cbox>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160916122937.GA14140@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu


> On 16 Sep 2016, at 14:29, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> 
> On Fri, Sep 16, 2016 at 02:25:01PM +0200, Alexander Graf wrote:
>> 
>>> On 16 Sep 2016, at 12:20, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> 
>>> Hi Alex,
>>> 
>>> On 16/09/16 07:26, Alexander Graf wrote:
>>>> Some systems out there (well, one type in particular - the Raspberry Pi series)
>>>> do have virtualization capabilities in the core, but no ARM GIC interrupt
>>>> controller.
>>>> 
>>>> To run on these systems, the cleanest route is to just handle all
>>>> interrupt delivery in user space and only deal with IRQ pins in the core
>>>> side in KVM.
>>>> 
>>>> This works pretty well already, but breaks when the guest starts to use
>>>> architected timers, as these are handled straight inside kernel space today.
>>>> 
>>>> This patch set allows user space to receive vtimer events as well as mask
>>>> them, so that we can handle all vtimer related interrupt injection from user
>>>> space, enabling us to use architected timer with user space gic emulation.
>>> 
>>> I have already voiced my concerns in the past, including face to face,
>>> and I'm going to repeat it: I not keen at all on adding a new userspace
>>> interface that is going to bitrot extremely quickly.
>>> 
>>> Let's face it, this new ABI will have a single user, with a limited
>>> shelf life. I understand that the RPi is a popular product, but it looks
>>> fairly obvious that this kind of sub-standard HW will eventually
>>> disappear. We'll then be left with a userspace ABI that will break at
>> 
>> I’m not 100% convinced that this is the case. Emulating the GIC in user space can have other interesting use cases. For example, it might come in handy for nesting. It may be useful for migrating a gicv2 VM to a gicv3 host without gicv2 emulation as well.
>> 
> 
> I don't see why you'd do this; the VGIC hardware can perfectly well be
> used for nesting as well, and this works rather well.

Mostly because it’s more. I like my problems self-contained, and simulating only nesting on the CPU level is less to worry about than simulating vgic switchover as well. Of course eventually with nesting you’d want a nested vgic ;).

> 
>>> every single release, given that nobody in the RPi community actually
>>> uses a mainline kernel.
>> 
>> I actually verified all of this patch on 4.8-rc5 upstream, which is the only 64bit kernel you can find for the RPi. So I’d expect the situation to change with 64bit.
>> 
>>> And breaking this ABI will introduce userspace exploitable bugs, like
>>> the one you've already shown. If anything, I would have loved to
>>> completely kill the whole userspace GIC, because nobody cares. Yes, I
>>> understand it is fun to have KVM running on the RPi. But the maintenance
>>> costs far outweigh the fun aspect already.
>> 
>> Having CPU pins accessible is very useful for use cases of KVM that are beyond your traditional VM.
>> 
>>> You could still run KVM with an external emulated timer (not the arch
>>> timer). No need for a new ABI for that.
>> 
>> That’s what I thought too, but turns out that it’s not quite as simple as I hoped ;).
> 
> Why not?  I thought a few people had this running recently.  What were
> the issues?  Perhaps I can convince someone to submit the patches they
> used if useful.

Just give it a try - I didn’t get any timer events and couldn’t quite figure out why. Patch is attached below.


Alex

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index a193b5a..f118ab8 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -91,6 +91,7 @@ typedef struct {
     bool secure;
     bool highmem;
     int32_t gic_version;
+    bool archtimer;
 } VirtMachineState;

 #define TYPE_VIRT_MACHINE   MACHINE_TYPE_NAME("virt")
@@ -177,6 +178,7 @@ static const MemMapEntry a15memmap[] = {
     [VIRT_FW_CFG] =             { 0x09020000, 0x00000018 },
     [VIRT_GPIO] =               { 0x09030000, 0x00001000 },
     [VIRT_SECURE_UART] =        { 0x09040000, 0x00001000 },
+    [VIRT_SP804] =              { 0x09050000, 0x00001000 },
     [VIRT_MMIO] =               { 0x0a000000, 0x00000200 },
     /* ...repeating for a total of NUM_VIRTIO_TRANSPORTS, each of that size */
     [VIRT_PLATFORM_BUS] =       { 0x0c000000, 0x02000000 },
@@ -195,6 +197,7 @@ static const int a15irqmap[] = {
     [VIRT_PCIE] = 3, /* ... to 6 */
     [VIRT_GPIO] = 7,
     [VIRT_SECURE_UART] = 8,
+    [VIRT_SP804] = 9,
     [VIRT_MMIO] = 16, /* ...to 16 + NUM_VIRTIO_TRANSPORTS - 1 */
     [VIRT_GIC_V2M] = 48, /* ...to 48 + NUM_GICV2M_SPIS - 1 */
     [VIRT_PLATFORM_BUS] = 112, /* ...to 112 + PLATFORM_BUS_NUM_IRQS -1 */
@@ -352,11 +355,13 @@ static void fdt_add_timer_nodes(const VirtBoardInfo *vbi, int gictype)
                                 "arm,armv7-timer");
     }
     qemu_fdt_setprop(vbi->fdt, "/timer", "always-on", NULL, 0);
+#if 0
     qemu_fdt_setprop_cells(vbi->fdt, "/timer", "interrupts",
                        GIC_FDT_IRQ_TYPE_PPI, ARCH_TIMER_S_EL1_IRQ, irqflags,
                        GIC_FDT_IRQ_TYPE_PPI, ARCH_TIMER_NS_EL1_IRQ, irqflags,
                        GIC_FDT_IRQ_TYPE_PPI, ARCH_TIMER_VIRT_IRQ, irqflags,
                        GIC_FDT_IRQ_TYPE_PPI, ARCH_TIMER_NS_EL2_IRQ, irqflags);
+#endif
 }

 static void fdt_add_cpu_nodes(const VirtBoardInfo *vbi)
@@ -655,6 +660,29 @@ static void create_rtc(const VirtBoardInfo *vbi, qemu_irq *pic)
     g_free(nodename);
 }

+static void create_sp804(const VirtBoardInfo *vbi, qemu_irq *pic)
+{
+    char *nodename;
+    hwaddr base = vbi->memmap[VIRT_SP804].base;
+    hwaddr size = vbi->memmap[VIRT_SP804].size;
+    int irq = vbi->irqmap[VIRT_SP804];
+    const char compat[] = "arm,sp804\0arm,primecell";
+
+    sysbus_create_simple("sp804", base, pic[irq]);
+
+    nodename = g_strdup_printf("/sp804@%" PRIx64, base);
+    qemu_fdt_add_subnode(vbi->fdt, nodename);
+    qemu_fdt_setprop(vbi->fdt, nodename, "compatible", compat, sizeof(compat));
+    qemu_fdt_setprop_sized_cells(vbi->fdt, nodename, "reg",
+                                 2, base, 2, size);
+    qemu_fdt_setprop_cells(vbi->fdt, nodename, "interrupts",
+                           GIC_FDT_IRQ_TYPE_SPI, irq,
+                           GIC_FDT_IRQ_FLAGS_LEVEL_HI);
+    qemu_fdt_setprop_cell(vbi->fdt, nodename, "clocks", vbi->clock_phandle);
+    qemu_fdt_setprop_string(vbi->fdt, nodename, "clock-names", "apb_pclk");
+    g_free(nodename);
+}
+
 static DeviceState *gpio_key_dev;
 static void virt_powerdown_req(Notifier *n, void *opaque)
 {
@@ -1354,6 +1385,10 @@ static void machvirt_init(MachineState *machine)

     create_rtc(vbi, pic);

+    if (!vms->archtimer) {
+        create_sp804(vbi, pic);
+    }
+
     create_pcie(vbi, pic, vms->highmem);

     create_gpio(vbi, pic);
@@ -1448,6 +1483,20 @@ static void virt_set_gic_version(Object *obj, const char *value, Error **errp)
     }
 }

+static bool virt_get_archtimer(Object *obj, Error **errp)
+{
+    VirtMachineState *vms = VIRT_MACHINE(obj);
+
+    return vms->archtimer;
+}
+
+static void virt_set_archtimer(Object *obj, bool value, Error **errp)
+{
+    VirtMachineState *vms = VIRT_MACHINE(obj);
+
+    vms->archtimer = value;
+}
+
 static void virt_machine_class_init(ObjectClass *oc, void *data)
 {
     MachineClass *mc = MACHINE_CLASS(oc);
@@ -1510,6 +1559,15 @@ static void virt_2_7_instance_init(Object *obj)
     object_property_set_description(obj, "gic-version",
                                     "Set GIC version. "
                                     "Valid values are 2, 3 and host", NULL);
+
+    /* Architected Timers are available by default */
+    vms->archtimer = true;
+    object_property_add_bool(obj, "archtimer", virt_get_archtimer,
+                             virt_set_archtimer, NULL);
+    object_property_set_description(obj, "archtimer",
+                                    "Set on/off to enable/disable exposure "
+                                    "of architected timers to the guest",
+                                    NULL);
 }

 static void virt_machine_2_7_options(MachineClass *mc)
diff --git a/hw/timer/arm_timer.c b/hw/timer/arm_timer.c
index 111a16d..b71db7e 100644
--- a/hw/timer/arm_timer.c
+++ b/hw/timer/arm_timer.c
diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
index 9650193..510cdc0 100644
--- a/include/hw/arm/virt.h
+++ b/include/hw/arm/virt.h
@@ -67,6 +67,7 @@ enum {
     VIRT_GPIO,
     VIRT_SECURE_UART,
     VIRT_SECURE_MEM,
+    VIRT_SP804,
 };

 typedef struct MemMapEntry {