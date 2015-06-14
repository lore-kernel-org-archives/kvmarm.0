From: zichao <zhichao.huang@linaro.org>
Subject: Re: [PATCH v2 05/11] KVM: arm: check ordering of all system register
 tables
Date: Mon, 15 Jun 2015 00:18:55 +0800
Message-ID: <557DA96F.3000705@linaro.org>
References: <1433046432-1824-1-git-send-email-zhichao.huang@linaro.org> <1433046432-1824-6-git-send-email-zhichao.huang@linaro.org> <87fv5z7jrh.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <87fv5z7jrh.fsf@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, will.deacon@arm.com, huangzhichao@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/6/10 21:52, Alex Benn=C3=A9e wrote:
>=20
> Zhichao Huang <zhichao.huang@linaro.org> writes:
>=20
>> We now have multiple tables for the various system registers
>> we trap. Make sure we check the order of all of them, as it is
>> critical that we get the order right (been there, done that...).
>>
>> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
>> ---
>>  arch/arm/kvm/coproc.c | 26 +++++++++++++++++++++-----
>>  1 file changed, 21 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
>> index d23395b..16d5f69 100644
>> --- a/arch/arm/kvm/coproc.c
>> +++ b/arch/arm/kvm/coproc.c
>> @@ -737,6 +737,9 @@ static struct coproc_reg invariant_cp15[] =3D {
>>  	{ CRn( 0), CRm( 0), Op1( 0), Op2( 3), is32, NULL, get_TLBTR },
>>  	{ CRn( 0), CRm( 0), Op1( 0), Op2( 6), is32, NULL, get_REVIDR },
>> =20
>> +	{ CRn( 0), CRm( 0), Op1( 1), Op2( 1), is32, NULL, get_CLIDR },
>> +	{ CRn( 0), CRm( 0), Op1( 1), Op2( 7), is32, NULL, get_AIDR },
>> +
>>  	{ CRn( 0), CRm( 1), Op1( 0), Op2( 0), is32, NULL, get_ID_PFR0 },
>>  	{ CRn( 0), CRm( 1), Op1( 0), Op2( 1), is32, NULL, get_ID_PFR1 },
>>  	{ CRn( 0), CRm( 1), Op1( 0), Op2( 2), is32, NULL, get_ID_DFR0 },
>> @@ -752,9 +755,6 @@ static struct coproc_reg invariant_cp15[] =3D {
>>  	{ CRn( 0), CRm( 2), Op1( 0), Op2( 3), is32, NULL, get_ID_ISAR3 },
>>  	{ CRn( 0), CRm( 2), Op1( 0), Op2( 4), is32, NULL, get_ID_ISAR4 },
>>  	{ CRn( 0), CRm( 2), Op1( 0), Op2( 5), is32, NULL, get_ID_ISAR5 },
>> -
>> -	{ CRn( 0), CRm( 0), Op1( 1), Op2( 1), is32, NULL, get_CLIDR },
>> -	{ CRn( 0), CRm( 0), Op1( 1), Op2( 7), is32, NULL, get_AIDR },
>>  };
>> =20
>>  /*
>> @@ -1297,13 +1297,29 @@ int kvm_arm_copy_coproc_indices(struct kvm_v=
cpu *vcpu, u64 __user *uindices)
>>  	return write_demux_regids(uindices);
>>  }
>> =20
>> +static int check_sysreg_table(const struct coproc_reg *table, unsig=
ned int n)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i =3D 1; i < n; i++) {
>> +		if (cmp_reg(&table[i-1], &table[i]) >=3D 0) {
>> +			kvm_err("sys_reg table %p out of order (%d)\n",
>> +					table, i - 1);
>=20
> Isn't a BUG_ON *and* a kvm_err() overkill?
>=20

In deed, it would not be able to happened, because all the cp14_regs/cp=
15_regs are static codes.

I think the BUG_ON will make the developers to notice whether they get =
the order right.

And another reason may be to keep the same way with the ARM64.

>> +			return 1;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  void kvm_coproc_table_init(void)
>>  {
>>  	unsigned int i;
>> =20
>>  	/* Make sure tables are unique and in order. */
>> -	for (i =3D 1; i < ARRAY_SIZE(cp15_regs); i++)
>> -		BUG_ON(cmp_reg(&cp15_regs[i-1], &cp15_regs[i]) >=3D 0);
>> +	BUG_ON(check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs)));
>> +	BUG_ON(check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs)));
>> +	BUG_ON(check_sysreg_table(invariant_cp15, ARRAY_SIZE(invariant_cp1=
5)));
>> =20
>>  	/* We abuse the reset function to overwrite the table itself. */
>>  	for (i =3D 0; i < ARRAY_SIZE(invariant_cp15); i++)
>=20
