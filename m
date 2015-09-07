From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 6/8] arm/arm64: KVM: Add forwarded physical interrupts
 documentation
Date: Mon, 07 Sep 2015 18:50:10 +0100
Message-ID: <55EDCE52.1040006@arm.com>
References: <1441395650-19663-1-git-send-email-christoffer.dall@linaro.org>
 <1441395650-19663-7-git-send-email-christoffer.dall@linaro.org>
 <55EDBF36.4040307@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB0264117C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2015 13:49:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MQFpXbZghanU for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2015 13:49:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 825E140FB3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2015 13:49:38 -0400 (EDT)
In-Reply-To: <55EDBF36.4040307@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/09/15 17:45, Eric Auger wrote:
> Hi Christoffer,
> On 09/04/2015 09:40 PM, Christoffer Dall wrote:
>> Forwarded physical interrupts on arm/arm64 is a tricky concept and the
>> way we deal with them is not apparently easy to understand by reading
>> various specs.
>>
>> Therefore, add a proper documentation file explaining the flow and
>> rationale of the behavior of the vgic.
>>
>> Some of this text was contributed by Marc Zyngier and edited by me.
>> Omissions and errors are all mine.
>>
>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>> ---
>>  Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt | 181 +++++++++++++++++++++
>>  1 file changed, 181 insertions(+)
>>  create mode 100644 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
>>
>> diff --git a/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
>> new file mode 100644
>> index 0000000..24b6f28
>> --- /dev/null
>> +++ b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
>> @@ -0,0 +1,181 @@
>> +KVM/ARM VGIC Forwarded Physical Interrupts
>> +==========================================

[...]

>> +1.  KVM runs the VCPU
>> +2.  The guest programs the time to fire in T+100
>> +4.  At T+100 the timer fires and a physical IRQ causes the VM to exit
>> +5.  With interrupts disabled on the CPU, KVM looks at the timer state
>> +    and injects a forwarded physical interrupt because it concludes the
>> +    timer has expired.
> I don't get how we can trap without the virtual timer PPI handler being
> entered on host side. Please can you elaborate on this?

On VM exit, we disable the virtual timer (see the code in
hyp.S::save_timer_state where we clear the enable bit). We still perform
the exit, but the cause for exit is now gone, and the handler will never
fire.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
