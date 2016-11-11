From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v5 06/11] arm/arm64: add
 initial gicv2 support
Date: Fri, 11 Nov 2016 16:30:56 +0100
Message-ID: <20161111153056.2jl5vvixb33jsmoe@hawk.localdomain>
References: <1478798481-25030-1-git-send-email-drjones@redhat.com>
 <1478798481-25030-7-git-send-email-drjones@redhat.com>
 <87vavu6pc7.fsf@linaro.org>
 <2400d95c-02c3-5621-8cc1-32a61d3795e8@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2400d95c-02c3-5621-8cc1-32a61d3795e8@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, peter.maydell@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, qemu-devel@nongnu.org, eric.auger@redhat.com, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 11, 2016 at 03:17:25PM +0000, Andre Przywara wrote:
> > 
> > This doesn't seem to be used and I'm not sure what GICD_TYPER_IRQS it is
> > trying to achieve.
> 
> The idea is to calculate the number of implemented SPIs. But I am not a
> big fan of copying a macro from the emulation code base to the test code.
>

Consider it rewritten then :-) I did review the spec while copying
over stuff from Linux, so Linux has been getting a review at the
same time. I agree that we should be cautious with copy+paste and
we should probably not bring over super complex macros that are hard
to understand, because we want kvm-unit-tests to be easy to read.
Let's not say "no macros from Linux", but rather case-by-case it.
I think this macro is a nice addition to our little API.

Thanks,
drew
