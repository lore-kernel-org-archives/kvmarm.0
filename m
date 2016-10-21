From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: v4.9-rc1 fails booting as a guest on ARM64 Cavium ThunderX
Date: Fri, 21 Oct 2016 12:57:37 +0100
Message-ID: <CAFEAcA-K+Fnw7Fwh3tK0nqLxhUrtLB7XrJVtswXwTb7d2X+Y+Q@mail.gmail.com>
References: <924fd627-329a-54e0-694c-a9bdf979f696@redhat.com>
 <de2acaca-f694-be1a-5d2c-93fcf3b25011@arm.com> <99c7d3b5-0495-083f-b4b7-b58b20cf859e@redhat.com>
 <5a5e4ed5-a575-f720-36f0-acb545a170f4@arm.com> <e52f2867-102f-8aad-4815-2a682586f129@redhat.com>
 <20161021114951.gm3u6msvl4jz2kv7@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161021114951.gm3u6msvl4jz2kv7@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Auger Eric <eric.auger@redhat.com>, Daniel Thompson <daniel.thompson@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Robert Richter <robert.richter@caviumnetworks.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 21 October 2016 at 12:49, Andrew Jones <drjones@redhat.com> wrote:
> I also read the register before writing it and saw it was 3. I tried
> writing 3 instead of 0 to see what would happen, but the failure
> persisted. I did read back the register after writing it to confirm the
> change took affect.

So what does it read back as after you write 0? The GICv3 spec
says it can't read back as zero...

thanks
-- PMM
