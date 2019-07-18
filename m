Return-Path: <SRS0=vMTE=VP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F13C76191
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jul 2019 12:36:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF4C220880
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jul 2019 12:36:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF4C220880
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B5E04A558;
	Thu, 18 Jul 2019 08:36:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yJjtN575Yn2j; Thu, 18 Jul 2019 08:36:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FD4D4A57C;
	Thu, 18 Jul 2019 08:36:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67C734A56A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jul 2019 08:36:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ueP-REmCQ4vV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jul 2019 08:36:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8242D4A559
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jul 2019 08:36:39 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C8CF2B;
 Thu, 18 Jul 2019 05:36:39 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08CCE3F71F;
 Thu, 18 Jul 2019 05:36:37 -0700 (PDT)
Subject: Re: [PATCH 43/59] KVM: arm64: nv: Trap and emulate AT instructions
 from virtual EL2
To: Tomasz Nowicki <tn@semihalf.com>, Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-44-marc.zyngier@arm.com>
 <4cd8b175-7676-0d3b-2853-365a346e1302@arm.com>
 <852db652-5318-113b-083c-baf12eb58593@semihalf.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <6537c8d2-3bda-788e-8861-b70971a625cb@arm.com>
Date: Thu, 18 Jul 2019 13:36:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <852db652-5318-113b-083c-baf12eb58593@semihalf.com>
Content-Language: en-US
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2602630009837851637=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This is a multi-part message in MIME format.
--===============2602630009837851637==
Content-Type: multipart/alternative;
 boundary="------------8D881CF89150A10BDC25F270"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------8D881CF89150A10BDC25F270
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 7/18/19 1:13 PM, Tomasz Nowicki wrote:

> Hello Alex,
>
> On 09.07.2019 15:20, Alexandru Elisei wrote:
>> On 6/21/19 10:38 AM, Marc Zyngier wrote:
>>> From: Jintack Lim <jintack.lim@linaro.org>
>>>
>>> When supporting nested virtualization a guest hypervisor executing AT
>>> instructions must be trapped and emulated by the host hypervisor,
>>> because untrapped AT instructions operating on S1E1 will use the wrong
>>> translation regieme (the one used to emulate virtual EL2 in EL1 instead
>> I think that should be "regime".
>>
>>> of virtual EL1) and AT instructions operating on S12 will not work from
>>> EL1.
>>>
>>> This patch does several things.
>>>
>>> 1. List and define all AT system instructions to emulate and document
>>> the emulation design.
>>>
>>> 2. Implement AT instruction handling logic in EL2. This will be used to
>>> emulate AT instructions executed in the virtual EL2.
>>>
>>> AT instruction emulation works by loading the proper processor
>>> context, which depends on the trapped instruction and the virtual
>>> HCR_EL2, to the EL1 virtual memory control registers and executing AT
>>> instructions. Note that ctxt->hw_sys_regs is expected to have the
>>> proper processor context before calling the handling
>>> function(__kvm_at_insn) implemented in this patch.
>>>
>>> 4. Emulate AT S1E[01] instructions by issuing the same instructions in
>>> EL2. We set the physical EL1 registers, NV and NV1 bits as described in
>>> the AT instruction emulation overview.
>> Is item number 3 missing, or is that the result of an unfortunate typo?
>>
>>> 5. Emulate AT A12E[01] instructions in two steps: First, do the stage-1
>>> translation by reusing the existing AT emulation functions.  Second, do
>>> the stage-2 translation by walking the guest hypervisor's stage-2 page
>>> table in software. Record the translation result to PAR_EL1.
>>>
>>> 6. Emulate AT S1E2 instructions by issuing the corresponding S1E1
>>> instructions in EL2. We set the physical EL1 registers and the HCR_EL2
>>> register as described in the AT instruction emulation overview.
>>>
>>> 7. Forward system instruction traps to the virtual EL2 if the corresponding
>>> virtual AT bit is set in the virtual HCR_EL2.
>>>
>>>    [ Much logic above has been reworked by Marc Zyngier ]
>>>
>>> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>>> ---
>>>   arch/arm64/include/asm/kvm_arm.h |   2 +
>>>   arch/arm64/include/asm/kvm_asm.h |   2 +
>>>   arch/arm64/include/asm/sysreg.h  |  17 +++
>>>   arch/arm64/kvm/hyp/Makefile      |   1 +
>>>   arch/arm64/kvm/hyp/at.c          | 217 +++++++++++++++++++++++++++++++
>>>   arch/arm64/kvm/hyp/switch.c      |  13 +-
>>>   arch/arm64/kvm/sys_regs.c        | 202 +++++++++++++++++++++++++++-
>>>   7 files changed, 450 insertions(+), 4 deletions(-)
>>>   create mode 100644 arch/arm64/kvm/hyp/at.c
>>>
> [...]
>
>>> +
>>> +void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>>> +{
>>> +	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
>>> +	struct mmu_config config;
>>> +	struct kvm_s2_mmu *mmu;
>>> +
>>> +	/*
>>> +	 * We can only get here when trapping from vEL2, so we're
>>> +	 * translating a guest guest VA.
>>> +	 *
>>> +	 * FIXME: Obtaining the S2 MMU for a a guest guest is horribly
>>> +	 * racy, and we may not find it.
>>> +	 */
>>> +	spin_lock(&vcpu->kvm->mmu_lock);
>>> +
>>> +	mmu = lookup_s2_mmu(vcpu->kvm,
>>> +			    vcpu_read_sys_reg(vcpu, VTTBR_EL2),
>>> +			    vcpu_read_sys_reg(vcpu, HCR_EL2));
>>  From ARM DDI 0487D.b, the description for AT S1E1R (page C5-467, it's the same
>> for the other at s1e{0,1}* instructions):
>>
>> [..] Performs stage 1 address translation, with permisions as if reading from
>> the given virtual address from EL1, or from EL2 [..], using the following
>> translation regime:
>> - If HCR_EL2.{E2H,TGE} is {1, 1}, the EL2&0 translation regime, accessed from EL2.
>>
>> If the guest is VHE, I don't think there's any need to switch mmus. The AT
>> instruction will use the physical EL1&0 translation regime already on the
>> hardware (assuming host HCR_EL2.TGE == 0), which is the vEL2&0 regime for the
>> guest hypervisor.
> Here we want to run AT for L2 (guest guest) EL1&0 regime and not the L1 
> (guest hypervisor) so we have to lookup and switch to nested VM MMU 
> context. Or did I miss your point?
>
> Thanks,
> Tomasz

What I mean to say is that if the L1 guest has set HCR_EL2.{E2H, TGE} = {1, 1}, then the instruction affects the vEL2&0 translation regime (as per the instruction description in the arhitecture), which is already loaded. The AT instruction will affect the L1 guest hypervisor, not the L2 guest.

In other words:

if (!vcpu_el2_e2h_is_set(vcpu) || !vcpu_el2_tge_is_set(vcpu))
        /* switch mmus, the instruction affects the L2 guest (the guest guest) */
else
        /* do not switch mmus, the instruction affects the L1 guest hypervisor which is loaded */

I hope this makes things clearer.


--------------8D881CF89150A10BDC25F270
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    <div class="moz-cite-prefix">
      <pre><tt>On 7/18/19 1:13 PM, Tomasz Nowicki wrote:</tt></pre>
    </div>
    <blockquote type="cite"
      cite="mid:852db652-5318-113b-083c-baf12eb58593@semihalf.com">
      <pre class="moz-quote-pre" wrap="">Hello Alex,

On 09.07.2019 15:20, Alexandru Elisei wrote:
</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">On 6/21/19 10:38 AM, Marc Zyngier wrote:
</pre>
        <blockquote type="cite">
          <pre class="moz-quote-pre" wrap="">From: Jintack Lim <a class="moz-txt-link-rfc2396E" href="mailto:jintack.lim@linaro.org">&lt;jintack.lim@linaro.org&gt;</a>

When supporting nested virtualization a guest hypervisor executing AT
instructions must be trapped and emulated by the host hypervisor,
because untrapped AT instructions operating on S1E1 will use the wrong
translation regieme (the one used to emulate virtual EL2 in EL1 instead
</pre>
        </blockquote>
        <pre class="moz-quote-pre" wrap="">
I think that should be "regime".

</pre>
        <blockquote type="cite">
          <pre class="moz-quote-pre" wrap="">of virtual EL1) and AT instructions operating on S12 will not work from
EL1.

This patch does several things.

1. List and define all AT system instructions to emulate and document
the emulation design.

2. Implement AT instruction handling logic in EL2. This will be used to
emulate AT instructions executed in the virtual EL2.

AT instruction emulation works by loading the proper processor
context, which depends on the trapped instruction and the virtual
HCR_EL2, to the EL1 virtual memory control registers and executing AT
instructions. Note that ctxt-&gt;hw_sys_regs is expected to have the
proper processor context before calling the handling
function(__kvm_at_insn) implemented in this patch.

4. Emulate AT S1E[01] instructions by issuing the same instructions in
EL2. We set the physical EL1 registers, NV and NV1 bits as described in
the AT instruction emulation overview.
</pre>
        </blockquote>
        <pre class="moz-quote-pre" wrap="">
Is item number 3 missing, or is that the result of an unfortunate typo?

</pre>
        <blockquote type="cite">
          <pre class="moz-quote-pre" wrap="">
5. Emulate AT A12E[01] instructions in two steps: First, do the stage-1
translation by reusing the existing AT emulation functions.  Second, do
the stage-2 translation by walking the guest hypervisor's stage-2 page
table in software. Record the translation result to PAR_EL1.

6. Emulate AT S1E2 instructions by issuing the corresponding S1E1
instructions in EL2. We set the physical EL1 registers and the HCR_EL2
register as described in the AT instruction emulation overview.

7. Forward system instruction traps to the virtual EL2 if the corresponding
virtual AT bit is set in the virtual HCR_EL2.

   [ Much logic above has been reworked by Marc Zyngier ]

Signed-off-by: Jintack Lim <a class="moz-txt-link-rfc2396E" href="mailto:jintack.lim@linaro.org">&lt;jintack.lim@linaro.org&gt;</a>
Signed-off-by: Marc Zyngier <a class="moz-txt-link-rfc2396E" href="mailto:marc.zyngier@arm.com">&lt;marc.zyngier@arm.com&gt;</a>
Signed-off-by: Christoffer Dall <a class="moz-txt-link-rfc2396E" href="mailto:christoffer.dall@arm.com">&lt;christoffer.dall@arm.com&gt;</a>
---
  arch/arm64/include/asm/kvm_arm.h |   2 +
  arch/arm64/include/asm/kvm_asm.h |   2 +
  arch/arm64/include/asm/sysreg.h  |  17 +++
  arch/arm64/kvm/hyp/Makefile      |   1 +
  arch/arm64/kvm/hyp/at.c          | 217 +++++++++++++++++++++++++++++++
  arch/arm64/kvm/hyp/switch.c      |  13 +-
  arch/arm64/kvm/sys_regs.c        | 202 +++++++++++++++++++++++++++-
  7 files changed, 450 insertions(+), 4 deletions(-)
  create mode 100644 arch/arm64/kvm/hyp/at.c

</pre>
        </blockquote>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
[...]

</pre>
      <blockquote type="cite">
        <blockquote type="cite">
          <pre class="moz-quote-pre" wrap="">+
+void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+{
+	struct kvm_cpu_context *ctxt = &amp;vcpu-&gt;arch.ctxt;
+	struct mmu_config config;
+	struct kvm_s2_mmu *mmu;
+
+	/*
+	 * We can only get here when trapping from vEL2, so we're
+	 * translating a guest guest VA.
+	 *
+	 * FIXME: Obtaining the S2 MMU for a a guest guest is horribly
+	 * racy, and we may not find it.
+	 */
+	spin_lock(&amp;vcpu-&gt;kvm-&gt;mmu_lock);
+
+	mmu = lookup_s2_mmu(vcpu-&gt;kvm,
+			    vcpu_read_sys_reg(vcpu, VTTBR_EL2),
+			    vcpu_read_sys_reg(vcpu, HCR_EL2));
</pre>
        </blockquote>
        <pre class="moz-quote-pre" wrap=""> From ARM DDI 0487D.b, the description for AT S1E1R (page C5-467, it's the same
for the other at s1e{0,1}* instructions):

[..] Performs stage 1 address translation, with permisions as if reading from
the given virtual address from EL1, or from EL2 [..], using the following
translation regime:
- If HCR_EL2.{E2H,TGE} is {1, 1}, the EL2&amp;0 translation regime, accessed from EL2.

If the guest is VHE, I don't think there's any need to switch mmus. The AT
instruction will use the physical EL1&amp;0 translation regime already on the
hardware (assuming host HCR_EL2.TGE == 0), which is the vEL2&amp;0 regime for the
guest hypervisor.
</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
Here we want to run AT for L2 (guest guest) EL1&amp;0 regime and not the L1 
(guest hypervisor) so we have to lookup and switch to nested VM MMU 
context. Or did I miss your point?

Thanks,
Tomasz</pre>
    </blockquote>
    <pre>What I mean to say is that if the L1 guest has set HCR_EL2.{E2H, TGE} = {1, 1}, then the instruction affects the vEL2&amp;0 translation regime (as per the instruction description in the arhitecture), which is already loaded. The AT instruction will affect the L1 guest hypervisor, not the L2 guest.

In other words:

if (!vcpu_el2_e2h_is_set(vcpu) || !vcpu_el2_tge_is_set(vcpu))
        /* switch mmus, the instruction affects the L2 guest (the guest guest) */
else
        /* do not switch mmus, the instruction affects the L1 guest hypervisor which is loaded */

I hope this makes things clearer.
</pre>
    <blockquote type="cite"
      cite="mid:852db652-5318-113b-083c-baf12eb58593@semihalf.com">
      <pre class="moz-quote-pre" wrap="">
</pre>
    </blockquote>
  </body>
</html>

--------------8D881CF89150A10BDC25F270--

--===============2602630009837851637==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2602630009837851637==--
