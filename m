From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 6/9] arm/arm64: KVM: Add mapped interrupts documentation
Date: Fri, 04 Sep 2015 16:59:39 +0100
Message-ID: <55E9BFEB.6000801@arm.com>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org> <1440942866-23802-7-git-send-email-christoffer.dall@linaro.org> <55E865D8.9080406@arm.com> <20150904155733.GN5171@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150904155733.GN5171@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/09/15 16:57, Christoffer Dall wrote:
> On Thu, Sep 03, 2015 at 04:23:04PM +0100, Marc Zyngier wrote:
>> On 30/08/15 14:54, Christoffer Dall wrote:
>>> +
>>> +
>>> +Life Cycle for Forwarded Physical Interrupts
>>> +--------------------------------------------
>>> +
>>> +By forwarded physical interrupts we mean interrupts presented to a guest
>>> +representing a real HW event originally signaled to the host as a
>>
>> s/signaled/signalled/
>>
> Actaully this was my first version as well, but aspell told me it was
> spelled signaled.
> 
> Turns out it's mostly acceptable to use both spellings:
> 
> http://www.merriam-webster.com/dictionary/signaled

I stand corrected! :-)

	M.
-- 
Jazz is not dead. It just smells funny...
