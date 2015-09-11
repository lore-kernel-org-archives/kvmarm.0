From: Julien Grall <julien.grall@citrix.com>
Subject: Re: [PATCH v4 3/4] irqchip: GIC: Convert to EOImode == 1
Date: Fri, 11 Sep 2015 13:53:31 +0100
Message-ID: <55F2CECB.10801@citrix.com>
References: <1440604845-28229-1-git-send-email-marc.zyngier@arm.com>
 <1440604845-28229-4-git-send-email-marc.zyngier@arm.com>
 <55F08731.3050402@citrix.com> <55F15353.2000800@arm.com>
 <55F1AE75.6000405@citrix.com> <1441968881.3549.20.camel@citrix.com>
 <55F2B40F.3070405@citrix.com> <55F2B65E.9060303@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55F2B65E.9060303@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Ian Campbell <ian.campbell@citrix.com>, Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org, Eric Auger <eric.auger@linaro.org>, Stefano Stabellini <stefano.stabellini@eu.citrix.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, Jiang Liu <jiang.liu@linux.intel.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 11/09/15 12:09, Marc Zyngier wrote:
> On 11/09/15 11:59, Julien Grall wrote:
>>
>>
>> On 11/09/2015 11:54, Ian Campbell wrote:
>>> On Thu, 2015-09-10 at 17:23 +0100, Julien Grall wrote:
>>>> I applied the two patches on top of linus/master and I'm able to boot
>>>> correctly on X-gene. Thank you!
>>>
>>> Perhaps we should replicate this approach in Xen and get rid of
>>>   PLATFORM_QUIRK_GIC_64K_STRIDE?
>>
>> I was thinking to do it. But, I wasn't sure if it was worth to get a 
>> such "ugly" patch compare to the quirk.
> 
> It is not a quirk. It is actually recommended in the SBSA spec. The
> patch is ugly because we can't do the right thing on the one platform
> that actually implemented ARM's own recommendation (we can't tell the
> bloody firmware to stop overriding our DT).
> 
> I would otherwise have added a "arm,use-sbsa-aliasing" property (or
> something similar) instead of trying to guess things...

I will give a look to port this patch on Xen.

Regards,

-- 
Julien Grall
