From: Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH v2 16/16] arm64: Add ARM_SMCCC_ARCH_WORKAROUND_1 BP
 hardening support
Date: Thu, 1 Feb 2018 14:52:26 +0800
Message-ID: <876a9d85-31ee-d6fb-3e91-0a092eeb55c3@huawei.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
 <20180129174559.1866-17-marc.zyngier@arm.com>
 <476d111e-6fb0-9bef-2448-a94d0cc03f45@huawei.com>
 <49853e5e-f093-2e79-1cfb-182f51fcd6a0@arm.com>
 <CAKv+Gu-XidYPh0hi1nzG5m0AO7EfRE6bnKfxCToG+9zsmvzmNg@mail.gmail.com>
 <CAKv+Gu-L0WOLSUbcHSTQ_FVDNSJoXQv25ExUmtv8ZEYhkCSQ-Q@mail.gmail.com>
 <501451b6-cc84-e8d3-b7b6-49a7de953976@arm.com>
 <f6579ab5-8d52-3f62-e538-515b28376d59@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <f6579ab5-8d52-3f62-e538-515b28376d59@huawei.com>
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
To: Marc Zyngier <marc.zyngier@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoffer Dall <christoffer.dall@linaro.org>, Jon Masters <jcm@redhat.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 2018/2/1 10:40, Hanjun Guo wrote:
> On 2018/1/31 23:05, Marc Zyngier wrote:
>> On 31/01/18 14:38, Ard Biesheuvel wrote:
>>> On 31 January 2018 at 14:35, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>>> On 31 January 2018 at 14:11, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>>>> On 31/01/18 13:56, Hanjun Guo wrote:
>>>>>> Hi Marc,
>>>>>>
>>>>>> On 2018/1/30 1:45, Marc Zyngier wrote:
>>>>>>>  static int enable_psci_bp_hardening(void *data)
>>>>>>>  {
>>>>>>>      const struct arm64_cpu_capabilities *entry = data;
>>>>>>>
>>>>>>> -    if (psci_ops.get_version)
>>>>>>> +    if (psci_ops.get_version) {
>>>>>>> +            if (check_smccc_arch_workaround_1(entry))
>>>>>>> +                    return 0;
>>>>>>
>>>>>> If I'm using the new version SMCCC, the firmware have the choicARM_SMCCC_ARCH_WORKAROUND_1e to decide
>>>>>> whether this machine needs the workaround, even if the CPU is vulnerable
>>>>>> for CVE-2017-5715, but..
>>>>>>
>>>>>>> +
>>>>>>>              install_bp_hardening_cb(entry,
>>>>>>>                                     (bp_hardening_cb_t)psci_ops.get_version,
>>>>>>>                                     __psci_hyp_bp_inval_start,
>>>>>>>                                     __psci_hyp_bp_inval_end);
>>>>>>
>>>>>> ..the code above seems will enable get_psci_version() for CPU and will
>>>>>> trap to trust firmware even the new version of firmware didn't say
>>>>>> we need the workaround, did I understand it correctly?
>>>>>
>>>>> Well, you only get there if we've established that your CPU is affected
>>>>> (it has an entry matching its MIDR with the HARDEN_BRANCH_PREDICTOR
>>>>> capability), and that entry points to enable_psci_bp_hardening. It is
> 
> I understand, but A53, A57, A72 and etc are always in the list :)

Sorry, A53 is not susceptible to branch predictor aliasing..

Thanks
Hanjun
