From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v3 04/41] KVM: arm64: Rework hyp_panic for VHE and non-VHE
Date: Fri, 9 Feb 2018 10:55:18 +0000
Message-ID: <82ed8658-383e-4b10-866f-10389f697b73@arm.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-5-christoffer.dall@linaro.org>
 <be470bdb-258e-6b4d-b409-e230d2d90888@arm.com> <20180208132416.GP29286@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180208132416.GP29286@cbox>
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
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 02/08/2018 01:24 PM, Christoffer Dall wrote:
> On Mon, Feb 05, 2018 at 06:04:25PM +0000, Julien Grall wrote:
>> On 12/01/18 12:07, Christoffer Dall wrote:
>>> +
>>>   	panic(__hyp_panic_string,
>>>   	      spsr,  elr,
>>>   	      read_sysreg_el2(esr),   read_sysreg_el2(far),
>>>   	      read_sysreg(hpfar_el2), par, vcpu);
>>>   }
>>> -static hyp_alternate_select(__hyp_call_panic,
>>> -			    __hyp_call_panic_nvhe, __hyp_call_panic_vhe,
>>> -			    ARM64_HAS_VIRT_HOST_EXTN);
>>
>> Out of interest, any specific rather to remove hyp_alternate_select and
>> "open-code" it?
>>
> 
> Not sure I understand your question.
> 
> Are you asking why I replace the hyp alternatives with the has_vhe()?
> If so, has_vhe() uses a static key and should therefore have the same
> performance characteristics, but I find the has_vhe() version below much
> more readable.

That what I was asking. Thank you for the explanation.

Cheers,

-- 
Julien Grall
