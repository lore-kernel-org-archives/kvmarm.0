From: Andrew Jones <drjones@redhat.com>
Subject: Re: v4.9-rc1 fails booting as a guest on ARM64 Cavium ThunderX
Date: Fri, 21 Oct 2016 14:07:32 +0200
Message-ID: <20161021120732.bl5p5vji25zibap3@kamzik.brq.redhat.com>
References: <924fd627-329a-54e0-694c-a9bdf979f696@redhat.com>
 <de2acaca-f694-be1a-5d2c-93fcf3b25011@arm.com>
 <99c7d3b5-0495-083f-b4b7-b58b20cf859e@redhat.com>
 <5a5e4ed5-a575-f720-36f0-acb545a170f4@arm.com>
 <e52f2867-102f-8aad-4815-2a682586f129@redhat.com>
 <20161021114951.gm3u6msvl4jz2kv7@kamzik.brq.redhat.com>
 <CAFEAcA-K+Fnw7Fwh3tK0nqLxhUrtLB7XrJVtswXwTb7d2X+Y+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA-K+Fnw7Fwh3tK0nqLxhUrtLB7XrJVtswXwTb7d2X+Y+Q@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Auger Eric <eric.auger@redhat.com>, Daniel Thompson <daniel.thompson@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Robert Richter <robert.richter@caviumnetworks.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 21, 2016 at 12:57:37PM +0100, Peter Maydell wrote:
> On 21 October 2016 at 12:49, Andrew Jones <drjones@redhat.com> wrote:
> > I also read the register before writing it and saw it was 3. I tried
> > writing 3 instead of 0 to see what would happen, but the failure
> > persisted. I did read back the register after writing it to confirm the
> > change took affect.
> 
> So what does it read back as after you write 0? The GICv3 spec
> says it can't read back as zero...
>

I read back zero

pre-read  bpr1=3
post-read bpr1=0
FAIL: gicv3: ipi: self: Timed-out (5s). ACKS: missing=1 extra=0 unexpected=0

Thanks,
drew
