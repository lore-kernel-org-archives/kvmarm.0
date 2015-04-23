From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/2] kvm-all.c: add qemu_irq/gsi hash
 table and utility routines
Date: Thu, 23 Apr 2015 17:22:40 +0200
Message-ID: <55390E40.5000503@redhat.com>
References: <1429801716-8027-1-git-send-email-eric.auger@linaro.org>
	<1429801716-8027-2-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1429801716-8027-2-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, qemu-devel@nongnu.org, peter.maydell@linaro.org, agraf@suse.de
Cc: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 23/04/2015 17:08, Eric Auger wrote:
>  int kvm_irqchip_add_irqfd_notifier(KVMState *s, EventNotifier *n,
>                                     EventNotifier *rn, int virq);
>  int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n, int virq);
> +int kvm_irqchip_add_qemuirq_irqfd_notifier(KVMState *s, EventNotifier *n,
> +                                           EventNotifier *rn, qemu_irq irq);
> +int kvm_irqchip_remove_qemuirq_irqfd_notifier(KVMState *s, EventNotifier *n,
> +                                              qemu_irq irq);


Perhaps rename the existing ones to

kvm_irqchip_add_irqfd_notifier_gsi
kvm_irqchip_remove_irqfd_notifier_gsi

and change the new ones to kvm_irqchip_add_irqfd_notifier and
kvm_irqchip_remove_irqfd_notifier?

Okay with that change; include it in the vfio-platform series and I'll
ack it.

Paolo
