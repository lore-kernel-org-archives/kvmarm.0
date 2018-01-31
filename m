From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Fix arch timers with userspace irqchips
Date: Wed, 31 Jan 2018 14:37:06 +0100
Message-ID: <CAMJs5B-e7THiBQsH9BXR0Ks2CkttMWpv5KqJHDpJZLbnQ1QM=w@mail.gmail.com>
References: <20180130124609.15076-1-christoffer.dall@linaro.org>
 <9eb4f221-2aad-8656-912a-4a7e068a23eb@arm.com> <20180131100530.GZ21802@cbox>
 <560b5cbc-4ac7-a55a-3f11-9a32b1ffc9e0@arm.com> <CAMJs5B_H16cxgAmzZ1+xU9FJWpaG3pHgziN=RBb62nMbQrZdhw@mail.gmail.com>
 <20180131131631.hecvgdsa67bhf2gv@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180131131631.hecvgdsa67bhf2gv@kamzik.brq.redhat.com>
Sender: stable-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Stable <stable@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 31, 2018 at 2:16 PM, Andrew Jones <drjones@redhat.com> wrote:
> On Wed, Jan 31, 2018 at 12:23:09PM +0100, Christoffer Dall wrote:
>> Did I mention that I hate this feature, which keeps breaking, and
>> which really isn't covered by a simple kvm-unit-test script?
>>
>
> Doesn't running the kvm-unit-tests' timer tests with
> '-machine kernel_irqchip=off' exercise at least some
> of these paths? If so, then the kvm-unit-tests patch
> below may help
>

I do this by hand currently (for kvm-unit-tests and for other tests),
but as you say, it only covers a tiny portion of the overall problem.

To test this properly, you have to run at least 4 VMs in parallel,
some that use irqchip in userspace and some that use an in-kernel
irqchip, and then you have to reboot some of these machines while the
other machines are running workloads (to catch the
deactivate-before-ack thing), and really hammer on the timer while
migrating the VCPUs around.

Then you have to run all of this on a GICv2 machine.  And on a GICv3
machine.  And on a non-GIC (or broken GIC - is there any other kind?)
machine.

So I've done that, using my https://github.com/chazy/vm-loop-test
thing, and found these issues, but I'm probably not going to do this
for every patch, so most likely we'll see breakages.

>
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 44b98cfc7afde..7c0041e44d5f3 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -116,3 +116,10 @@ file = timer.flat
>  groups = timer
>  timeout = 2s
>  arch = arm64
> +
> +[timer-userspace-gic]
> +file = timer.flat
> +extra_params = -machine kernel_irqchip=off
> +groups = timer
> +timeout = 2s
> +arch = arm64

you probably want "gic_version=2" as well, since otherwise some
versions of QEMU pretend they can support a GICv3 in userspace, which
they cannot.  Also, this feature is broken around v2.9.1, so there's
another fun data point when debugging this.

It definitely doesn't hurt if we add this to kvm-unit-test.  Then
perhaps someone else than me occasionally tests this feature.

Thanks,
-Christoffer
