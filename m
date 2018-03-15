From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 00/26] KVM/arm64: Randomise EL2 mappings (variant 3a
 mitigation)
Date: Thu, 15 Mar 2018 16:19:56 +0000
Message-ID: <1a57727e-d4b8-f0e8-e910-ee1bc136ac0f@arm.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
 <20180315155741.7syqjajb77kh5vx2@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180315155741.7syqjajb77kh5vx2@kamzik.brq.redhat.com>
Content-Language: en-GB
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
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Steve Capper <steve.capper@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 15/03/18 15:57, Andrew Jones wrote:
> On Wed, Mar 14, 2018 at 04:50:23PM +0000, Marc Zyngier wrote:
>> Whilst KVM benefits from the kernel randomisation via KASLR, there is
>> no additional randomisation when the kernel is running at EL1, as we
>> directly use a fixed offset from the linear mapping. This is not
>> necessarily a problem, but we could do a bit better by independently
>> randomizing the HYP placement.
>>
>> This series proposes to randomise the offset by inserting a few random
>> bits between the MSB of the RAM linear mapping and the top of the HYP
>> VA (VA_BITS - 2). That's not a lot of random bits (on my Mustang, I
>> get 13 bits), but that's better than nothing.
>>
>> In order to achieve this, we need to be able to patch dynamic values
>> in the kernel text. This results in a bunch of changes to the
>> alternative framework, the insn library, and a few more hacks in KVM
>> itself (we get a new way to map the GIC at EL2).
>>
>> Another (and more recent) goal of this series is to work around what
>> has been described as "variant 3a", which covers speculative reads of
>> privileged system registers. Randomizing the location of the
>> hypervisor would be pointless if one could simply obtain VBAR_EL2. In
>> order to work around this, we place the vectors at a fairly static
>> location (next to the idmap), independently of the hypervisor's own
>> mappings. This ensures that we can leak VBAR_EL2 without disclosing
>> much about HYP itself (and is similar to what the rest of the kernel
>> does with KPTI). This is only enabled at runtime for Cortex-A57 and
>> Cortex-A72.
>>
>> This has been tested on the FVP model, Seattle (both 39 and 48bit VA),
>> Mustang and Thunder-X. I've also done a sanity check on 32bit (which
>> is only impacted by the HYP IO VA stuff).
>>
> 
> I've smoke tested this series on a seattle with several busy VMs running
> simultaneously. My host kernel configures 64K pages. I didn't see any
> problems.

Excellent, thanks for testing. Out of curiosity: do you have a firmware
that implements the SMCCC_ARCH_WORKAROUND_1 call or not?

	M.
-- 
Jazz is not dead. It just smells funny...
