From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: Re: [PATCH v3 07/11] KVM: arm: add trap handlers for 64-bit debug registers
Date: Wed, 01 Jul 2015 15:43:53 +0800
Message-ID: <D99B53D5-38B0-4448-A97A-D96F4C01104C@linaro.org>
References: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org> <1434969694-7432-8-git-send-email-zhichao.huang@linaro.org> <20150630132029.GV11332@cbox>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150630132029.GV11332@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com, huangzhichao@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On June 30, 2015 9:20:29 PM GMT+08:00, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>On Mon, Jun 22, 2015 at 06:41:30PM +0800, Zhichao Huang wrote:
>> Add handlers for all the 64-bit debug registers.
>> 
>> There is an overlap between 32 and 64bit registers. Make sure that
>> 64-bit registers preceding 32-bit ones.
>> 
>> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
>> ---
>>  arch/arm/kvm/coproc.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>> 
>> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
>> index 59b65b7..eeee648 100644
>> --- a/arch/arm/kvm/coproc.c
>> +++ b/arch/arm/kvm/coproc.c
>> @@ -435,9 +435,17 @@ static const struct coproc_reg cp15_regs[] = {
>>  	{ CRn( 1), CRm((n)), Op1( 0), Op2( 1), is32, trap_raz_wi }
>>  
>>  /*
>> + * Architected CP14 registers.
>> + *
>
>belongs in other patch?

OK, I will move it to the patch [06/11].
>
>>   * Trapped cp14 registers. We generally ignore most of the external
>>   * debug, on the principle that they don't really make sense to a
>>   * guest. Revisit this one day, whould this principle change.
>> + *
>> + * CRn denotes the primary register number, but is copied to the CRm in the
>> + * user space API for 64-bit register access in line with the terminology used
>> + * in the ARM ARM.
>> + * Important: Must be sorted ascending by CRn, CRM, Op1, Op2 and
>with 64-bit
>> + *            registers preceding 32-bit ones.
>>   */
>>  static const struct coproc_reg cp14_regs[] = {
>>  	/* DBGIDR */
>> @@ -445,10 +453,14 @@ static const struct coproc_reg cp14_regs[] = {
>>  	/* DBGDTRRXext */
>>  	{ CRn( 0), CRm( 0), Op1( 0), Op2( 2), is32, trap_raz_wi },
>>  	DBG_BCR_BVR_WCR_WVR(0),
>> +	/* DBGDRAR (64bit) */
>> +	{ CRn( 0), CRm( 1), Op1( 0), Op2( 0), is64, trap_raz_wi},
>>  	/* DBGDSCRint */
>>  	{ CRn( 0), CRm( 1), Op1( 0), Op2( 0), is32, trap_dbgdscr,
>>  				NULL, cp14_DBGDSCRext },
>>  	DBG_BCR_BVR_WCR_WVR(1),
>> +	/* DBGDSAR (64bit) */
>> +	{ CRn( 0), CRm( 2), Op1( 0), Op2( 0), is64, trap_raz_wi},
>>  	/* DBGDSCRext */
>>  	{ CRn( 0), CRm( 2), Op1( 0), Op2( 2), is32, trap_debug32,
>>  				reset_val, cp14_DBGDSCRext, 0 },
>> -- 
>> 1.7.12.4
>> 
>Otherwise:
>Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

-- 
Zhichao Huang
