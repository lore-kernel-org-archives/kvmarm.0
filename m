From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 0/3] Add support for for GICv2m and MSIs
	to arm-virt
Date: Wed, 6 May 2015 17:33:46 +0100
Message-ID: <CAFEAcA8WecTOiAKYxOOOrsJPyaQxpNskjE799kS8kipg4q3KMQ@mail.gmail.com>
References: <1430155872-27030-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1430155872-27030-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 27 April 2015 at 18:31, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> Now when we have a host generic PCIe controller in the virt board, it
> would be nice to be able to use MSIs so that we can eventually enable
> VHOST with KVM.
>
> With these patches you can use MSIs with TCG and with KVM, but you still
> need some fixes for the mapping of the IRQ index to the GSI number for
> IRQFD to work.  A separate series that enables IRQFD and vhost
> is available: "ARM adaptations for vhost irqfd setup"
> https://lists.gnu.org/archive/html/qemu-devel/2015-04/msg01054.html)
>
> Tested with KVM on XGene and with TCG by configuring a virtio-pci
> network adapter for the guest and verifying MSIs going through as
> expected.

You forgot to change the QOM device name to 'arm-gicv2m', but
I'll fix that up as I apply this to target-arm.next.

thanks
-- PMM
