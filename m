From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [RFC PATCH] kvm-unit-tests: arm/arm64: strip GIC
 headers
Date: Tue, 8 Nov 2016 11:52:03 +0100
Message-ID: <20161108105203.jn46d5nrsmfx732x@kamzik.brq.redhat.com>
References: <20161108094802.15638-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161108094802.15638-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 08, 2016 at 09:48:02AM +0000, Andre Przywara wrote:
> Hi,
> 
> this is an illustrative patch which shows what can be removed from
> the kvm-unit-tests GIC headers. If this patch finds mercy, it should be
> squashed into the in-flight GIC patches, eventually.
> The rationale for this patch is that while it seems like a good idea to
> copy the header files with the GIC definitions from Linux, we should
> avoid the danger of copying bugs on the way. This is especially true
> for those definitions that are used by the very emulation code that we
> are about to test. Beside this the headers contain much more definitions
> than we actually need.
> So strip those header files, by first removing all definitions that are
> actually only useful for hypervisors. Also we remove definitions for
> registers that are not needed yet. The idea is to add them one by one as
> soon as we start to test functionality, so that review can be much easier
> and safer.
> Applies on top of Drew's v3 GIC series (as in his github branch).

Thanks Andre!

I'll squash this into v4 (which I'll send today or tomorrow)

drew
