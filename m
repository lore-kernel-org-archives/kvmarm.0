From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: Re: [Query] Does Linux & Qemu support KVM for ARM32 guest on
 ARM64 host
Date: Thu, 28 Apr 2016 07:46:09 +0100
Message-ID: <CAFEAcA9eEdNhPSWgM39WoySe29+wLUz687PBDptHM20GwZC9Gg@mail.gmail.com>
References: <708585848.188261461823397987.JavaMail.weblogic@ep2mlwas06d>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <708585848.188261461823397987.JavaMail.weblogic@ep2mlwas06d>
Sender: kvm-owner@vger.kernel.org
To: r.sande@samsung.com
Cc: Shannon Zhao <zhaoshenglong@huawei.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 28 April 2016 at 07:03, RAVINDRA KUMAR SANDE <r.sande@samsung.com> wrote:
> I have another query, for Arm32 host with KVM enabled.
> I see that "qemu-system-arm  -enable-kvm   -machine vexpress-a9  ..." gives error
> kmv_init_vcpu (IOCtl on /dev/kvm) failed, guest not supported.
>
> Is there any way to emulate vexpress-a9  with  -enable-kvm   on qemu ?

No. You can only emulate a CPU of the same type as the host
you're using, and the vexpress-a9 must use a Cortex-A9 CPU,
so it can't be used under virtualization.

thanks
-- PMM
