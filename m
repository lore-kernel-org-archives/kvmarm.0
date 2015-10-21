From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v3 15/20] KVM: ARM64: Add reset and access handlers for
 PMSWINC register
Date: Wed, 21 Oct 2015 15:02:49 +0800
Message-ID: <56273899.9080509@huawei.com>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
 <1443133885-3366-16-git-send-email-shannon.zhao@linaro.org>
 <56211702.6060908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <56211702.6060908@redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Wei Huang <wei@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: Hangaohuai <hangaohuai@huawei.com>, kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, "Huangpeng (Peter)" <peter.huangpeng@huawei.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/10/16 23:25, Wei Huang wrote:
>>  /**
>> > + * kvm_pmu_software_increment - do software increment
>> > + * @vcpu: The vcpu pointer
>> > + * @val: the value guest writes to PMSWINC register
>> > + */
>> > +void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u32 val)
>> > +{
>> > +	int i;
>> > +	u32 type, enable;
>> > +
>> > +	for (i = 0; i < 32; i++) {
>> > +		if ((val >> i) & 0x1) {
>> > +			if (!vcpu_mode_is_32bit(vcpu)) {
>> > +				type = vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i)
>> > +				       & ARMV8_EVTYPE_EVENT;
>> > +				enable = vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
>> > +				if ((type == 0) && ((enable >> i) & 0x1))
>> > +					vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i)++;
> Most parts make sense here. I just wonder about the case of counter
> overflow here. Should we trigger an interrupt and set Overflow Flag
> status register when SW increment overflows here? I didn't find anything
> in ARM document.
> 
I didn't find either. But since SW increment uses the PMEVCNTR<n>_EL0 to
count, it should be same with other events to trigger an interrupt and
set Overflow Flag status register.

I will add this in next version patch. Thanks.

-- 
Shannon
