From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 5/5] arm/arm64: KVM: Don't panic on failure to properly
 reset system registers
Date: Thu, 31 Jan 2019 10:15:53 +0000
Message-ID: <84c2c5e9-e494-dd6c-aaa3-c965818c6058@arm.com>
References: <20190125094656.5026-1-christoffer.dall@arm.com>
 <20190125094656.5026-6-christoffer.dall@arm.com>
 <20190129163337.nbwivspcvlcmzrmo@kamzik.brq.redhat.com>
 <b2c0fa37-37ad-3696-e862-5d0434496d1f@arm.com>
 <20190130153604.l3ro4gdfsot2glnb@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190130153604.l3ro4gdfsot2glnb@kamzik.brq.redhat.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 30/01/2019 15:36, Andrew Jones wrote:
> On Wed, Jan 30, 2019 at 10:56:19AM +0000, Marc Zyngier wrote:
>> On 29/01/2019 16:33, Andrew Jones wrote:

[...]

>> If we only get halfway through resetting, then we'll get a warn splat,
>>> complete with a backtrace, for each register. Should we do something
>>> like the following instead?
>>>
>>>   for (num = 1; num < NR_SYS_REGS; num++)
>>>      if (__vcpu_sys_reg(vcpu, num) == 0x4242424242424242)
>>>         failed++;
>>>   WARN(failed, "Didn't reset %d system registers", failed);
>>
>> And doing so we'd loose the important bit of information, which is the
>> position in the table that doesn't get initialized.
>>
>> The vcpu reset issue is rare enough that nobody noticed it yet (I only
>> reproduced it twice), and having it to scream 200 times is not really a
>> concern. What I want to catch is the case where someone has added a new
>> sysreg in the table, and has failed to provide a working init function.
> 
> OK, Christoffer also said that information was useful. Would any following
> registers also be useful? Or should it be something like
> 
>   for (num = 1; num < NR_SYS_REGS; num++) {
>        WARN(__vcpu_sys_reg(vcpu, num) == 0x4242424242424242,
>             "Didn't reset __vcpu_sys_reg(%zi)\n", num);
>        break;
>    }
> 
> to ensure the first one, the most important one, is there, and that it
> doesn't get pushed out of the buffer by hundreds of more lines?

Fair enough.

	M.
-- 
Jazz is not dead. It just smells funny...
