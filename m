From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v11 06/21] KVM: ARM64: Add access handler for PMCEID0
 and PMCEID1 register
Date: Sat, 20 Feb 2016 21:34:52 +0800
Message-ID: <56C86B7C.9020906@linaro.org>
References: <1454656456-11640-1-git-send-email-zhaoshenglong@huawei.com> <1454656456-11640-7-git-send-email-zhaoshenglong@huawei.com> <20160208120950.GC620@cbox> <56C866EB.9060105@linaro.org> <CAFEAcA8=iRkAMLStMzu0wAPWfXZ9vYu_YzEKrEyVrWHP4=VS2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA8=iRkAMLStMzu0wAPWfXZ9vYu_YzEKrEyVrWHP4=VS2w@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/2/20 21:30, Peter Maydell wrote:
> On 20 February 2016 at 13:15, Shannon Zhao<shannon.zhao@linaro.org>  wrote:
>> >
>> >
>> >On 2016/2/8 20:09, Christoffer Dall wrote:
>>> >>Isn't it really a BUG_ON(p->is_write) ?
>>> >>
>>> >>Presumably a guest write to these registers will raise an undefined
>>> >>exception in EL0/1 and we don't get here by any other path than the trap
>>> >>handler, do we?
>> >
>> >Yeah, for EL1, it shouldn't get here. But for EL0, to support the function
>> >of PMUSERENR, we firstly trap the access to EL2, then according to the real
>> >value of PMUSERENR to decide whether inject an UND to EL1.
> I thought the PMUSERENR check took priority over trap-to-EL2 checks
> in the architecture; so if this is an EL0 access and you get to EL2
> at all then you know that PMUSERENR is set to permit EL0 reads.
>
> Similarly, UNDEF because of write-to-always-RO register has
> priority over trap-to-EL2, so I think Christoffer is right
> and you should never be able to get here for a write.
> (This should be easy to write a test program for if you're unsure.)
Thanks, I'll check this.

-- 
Shannon
