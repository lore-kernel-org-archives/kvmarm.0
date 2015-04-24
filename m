From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 0/2] irq: add get_gsi callback
Date: Fri, 24 Apr 2015 11:48:14 +0200
Message-ID: <553A115E.1050705@linaro.org>
References: <1429778977-1632-1-git-send-email-eric.auger@linaro.org>
 <5538BBD3.9040404@redhat.com> <5538BE19.6030009@linaro.org>
 <5538C246.20304@redhat.com> <553A0657.6050100@linaro.org>
 <553A08D3.3020609@redhat.com> <553A0A4D.905@linaro.org>
 <553A0CF5.9030304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 739434E637
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 05:42:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pg-pVsqGIGHC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Apr 2015 05:42:36 -0400 (EDT)
Received: from mail-wg0-f49.google.com (mail-wg0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 697624E61D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 05:42:36 -0400 (EDT)
Received: by wgin8 with SMTP id n8so44913919wgi.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 02:50:51 -0700 (PDT)
In-Reply-To: <553A0CF5.9030304@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, eric.auger@st.com, qemu-devel@nongnu.org, alex.williamson@redhat.com, peter.maydell@linaro.org, agraf@suse.de
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/24/2015 11:29 AM, Paolo Bonzini wrote:
> 
> 
> On 24/04/2015 11:18, Eric Auger wrote:
>>>>>> I implemented this alternative but my concern is the check method is
>>>>>> called before the qemu_irq setting. So on this callback I cannot
>>>>>> retrieve the qemu_irq VFIOINTp struct container object needed to setup
>>>>>> irqfd hence does not work for me.
>>>>
>>>> Isn't the qemu_irq passed as the third argument to the callback?  I
>>>> thought this solution was fine because you weren't passing the "int n"
>>>> from sysbus_connect_irq to your notifier.
>> Yes it is. But I need to access the EventNotifiers for trigger &
>> resample which were initialized before for eventfd trigger and stored in
>> the container object. Will study if I can restructure the code ...
> 
> What did the notifier code look like with your patch?

Currently both notifiers are stored in the VFIOINTp struct. They are
initialized in vfio_init_intp. VFIO platform device holds a list of
VFIOINTp struct.

When the vfio_start_irqfd callback is called the qemuirq is not yet
initialized so I cannot retrieve the EventNotifiers by container_of.

I can allocate and initialize them in the callback but I need a place to
store them to close the eventfd.

Also at the moment I start irqfd I must take some actions to stop (user
side) eventfd trigger; this also urges me to get access to VFIOINTp
struct. Some extracted pieces below (under work).

Eric

typedef struct VFIOINTp {
    QLIST_ENTRY(VFIOINTp) next; /* entry for IRQ list */
    QSIMPLEQ_ENTRY(VFIOINTp) pqnext; /* entry for pending IRQ queue */
    EventNotifier interrupt; /* eventfd triggered on interrupt */
    EventNotifier unmask; /* eventfd for unmask on QEMU bypass */
    qemu_irq qemuirq;
    struct VFIOPlatformDevice *vdev; /* back pointer to device */
    int state; /* inactive, pending, active */
    uint8_t pin; /* index */
    uint32_t flags; /* IRQ info flags */
    bool kvm_accel; /* set when QEMU bypass through KVM enabled */
} VFIOINTp;


static VFIOINTp *vfio_init_intp(VFIODevice *vbasedev,
                                struct vfio_irq_info info)
{
    int ret;
    VFIOPlatformDevice *vdev =
        container_of(vbasedev, VFIOPlatformDevice, vbasedev);
    SysBusDevice *sbdev = SYS_BUS_DEVICE(vdev);
    VFIOINTp *intp;

    intp = g_malloc0(sizeof(*intp));
    intp->vdev = vdev;
    intp->pin = info.index;
    intp->flags = info.flags;
    intp->state = VFIO_IRQ_INACTIVE;
    intp->kvm_accel = false;

    sysbus_init_irq(sbdev, &intp->qemuirq);

    /* Get an eventfd for trigger */
    ret = event_notifier_init(&intp->interrupt, 0);
    if (ret) {
        g_free(intp);
        error_report("vfio: Error: trigger event_notifier_init failed ");
        return NULL;
    }
    /* Get an eventfd for resample/unmask */
    ret = event_notifier_init(&intp->unmask, 0);
    if (ret) {
        g_free(intp);
        error_report("vfio: Error: resample event_notifier_init failed ");
        return NULL;
    }


static void vfio_start_irqfd(Object *obj, const char *name,
                             Object *child, Error ** err)
{
    VFIOPlatformDevice *vdev = VFIO_PLATFORM_DEVICE(obj);
    qemu_irq irq = OBJECT_CHECK(struct IRQState, (child), TYPE_IRQ);
    struct VFIOINTp *tmp, *intp = container_of(&irq, struct VFIOINTp,
qemuirq);
    EventNotifier *interrupt, *unmask;

    vfio_stop_vfio_signaling(intp);

    interrupt = g_new(EventNotifier, 1);
    unmask = g_new(EventNotifier, 1);

    /* Get an eventfd for trigger */
    ret = event_notifier_init(interrupt, 0);
    if (ret) {
        return NULL;
    }
    /* Get an eventfd for resample/unmask */
    ret = event_notifier_init(unmask, 0);
    if (ret) {
        return NULL;
    }

    kvm_irqchip_add_qemuirq_irqfd_notifier(kvm_state,
                                           interrupt,
                                           unmask,
                                           irq);

../..
}

> 
> Paolo
> 
