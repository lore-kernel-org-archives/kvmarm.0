From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 03/25] KVM: arm64: Make kvm_condition_valid32()
 accessible from EL2
Date: Mon, 5 Jun 2017 10:10:23 +0100
Message-ID: <2ab26ba3-26b7-4072-00ca-eefd2bdf269b@arm.com>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-4-marc.zyngier@arm.com> <20170604121129.GB9464@cbox>
 <394ef6fd-1123-0a1f-f462-ed5cb52e24da@arm.com> <20170605082321.GA8984@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3962240CD1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 05:06:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rNgLK8FgON1h for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Jun 2017 05:06:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3DA640C47
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 05:06:22 -0400 (EDT)
In-Reply-To: <20170605082321.GA8984@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 05/06/17 09:23, Christoffer Dall wrote:
> On Mon, Jun 05, 2017 at 09:13:53AM +0100, Marc Zyngier wrote:
>> On 04/06/17 13:11, Christoffer Dall wrote:
>>> On Thu, Jun 01, 2017 at 11:20:55AM +0100, Marc Zyngier wrote:
>>>> As we're about to trap CP15 accesses and handle them at EL2, we
>>>> need to evaluate whether or not the condition flags are valid,
>>>> as an implementation is allowed to trap despite the condition
>>>> not being met.
>>>>
>>>> Tagging the function as __hyp_text allows this.
>>>
>>> is the cc_map also guaranteed to work (by simple reference) in EL2 then?
>>
>> Yes. By virtue of being const, this ends up in the read-only part of the
>> kernel, which we always map at EL2.
>>
> 
> And why don't we have to do any address-translation-to-hyp tricks on the
> address?  Are we guaranteed that it's a relative address and everything
> is relocated with the same offset, or how was that again?

Arghh, I completely missed this. Yeah, it works because this is a single
compilation unit, that the array is static, used only once, and that the
compiler is using relative addressing and not playing any dirty tricks
on us.

We could make the whole thing private to kvm_condition_valid32, but
that's not more of a guarantee that things won't break if the compiler
decides to generate absolute addresses.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
