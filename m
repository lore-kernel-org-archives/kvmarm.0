From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Mon, 6 Jul 2015 13:07:16 +0200
Message-ID: <559A6164.1000401@redhat.com>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-2-git-send-email-eric.auger@linaro.org>
 <011f01d0b498$6a17aeb0$3e470c10$@samsung.com> <5596503E.6040902@arm.com>
 <00fd01d0b7b6$f6cf3550$e46d9ff0$@samsung.com> <559A3C9C.6050302@arm.com>
 <20150706093026.GA11590@cbox> <559A52E6.5050402@arm.com>
 <20150706103755.GC11590@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150706103755.GC11590@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>
Cc: Pavel Fedin <p.fedin@samsung.com>, 'Eric Auger' <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 06/07/2015 12:37, Christoffer Dall wrote:
> I don't view it as 'the kernel requires this' but as 'the kernel will
> not complain with arbitrary error code if you set the devid flag'
> capability, and it's up to userspace (as usual) to provide the correct
> arguments for things to work, and up to the kernel to ensure we don't
> crash the system etc.
> 
> Thus, if you want to advertise it as a capability, I would rather call
> it KVM_CAP_MSI_DEVID.

I agree.  Does userspace know that ITS guests always require devid?  I
guess it's okay to return -EINVAL if the userspace doesn't set the flag
but the virtual hardware requires it.

Paolo

> The question is if userspace code that sets the devid flag will anyway
> depend on some discovery mechanism of whether or not the kernel supports
> arm64 irqfd etc. and if so, can we be sure to add the required support
> at once in the kernel so that EINVAL never means 'you set the flags
> field on the ioctl on an old kernel'?
> 
> This smells an awful lot like a capability to me.
