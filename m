From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH 0/3] Support userspace irqchip with arch timers
Date: Thu, 29 Sep 2016 17:11:36 +0200
Message-ID: <57ED2F28.1090100@suse.de>
References: <20160927190806.22988-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160927190806.22988-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 09/27/2016 09:08 PM, Christoffer Dall wrote:
> Hi Alex,
>
> Marc and I have been looking at this during Linaro connect and have
> slightly reworked your patch into this small series.
>
> It would be good if you could have a look at it and test it out.

Tested-by: Alexander Graf <agraf@suse.de>

Works fine so far :).

> I've tested it with your QEMU, and it works for UP, but secondary CPUs
> fail to come up, and it looks like the kernel never gets an IPI for
> those CPUs from userspace.  Any chance you're willing to take a look at
> that?

I can try, but not very soon. I doubt it's something fundamental - we 
probably just don't synchronize kvm/qemu state properly on IPIs (read: a 
QEMU bug).

> Also, let me know if the split of your patch with preserving your
> authorship is ok with you.

Works for me :)


Alex

