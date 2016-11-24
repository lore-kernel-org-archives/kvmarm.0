From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v7 11/11] arm/arm64: gic:
 don't just use zero
Date: Thu, 24 Nov 2016 15:11:03 +0100
Message-ID: <20161124141103.yzfswsvi6ion7po5@kamzik.brq.redhat.com>
References: <20161123165406.32661-1-drjones@redhat.com>
 <20161123165406.32661-12-drjones@redhat.com>
 <2f88f60c-f7a2-3916-cd1f-5a86453d9ba9@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2f88f60c-f7a2-3916-cd1f-5a86453d9ba9@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org, peter.maydell@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, pbonzini@redhat.com, alex.bennee@linaro.org, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 24, 2016 at 10:57:01AM +0100, Auger Eric wrote:
> Hi,
> 
> On 23/11/2016 17:54, Andrew Jones wrote:
> > Allow user to select who sends ipis and with which irq,
> > rather than just always sending irq=0 from cpu0.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Tested-by: Eric Auger <eric.auger@redhat.com>

Thanks!

But if I spin a v8 then I may just dump all the command line parsing
stuff, dropping the optional input arguments sender and irq, or at
least irq. I'm feeling it's a bit crufty... Any thoughts on that?

drew
