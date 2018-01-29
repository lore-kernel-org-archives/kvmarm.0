From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 12/14] firmware/psci: Expose PSCI conduit
Date: Mon, 29 Jan 2018 10:08:30 +0000
Message-ID: <26bcd8c6-c834-3d3a-426a-98fca3dfbbbf@arm.com>
References: <20180126142847.31240-1-marc.zyngier@arm.com>
 <20180126142847.31240-13-marc.zyngier@arm.com>
 <CAKv+Gu8RAzwpcGqrSxsegYnVgfFQCkYp+sgaPzm8906A4QMLCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8RAzwpcGqrSxsegYnVgfFQCkYp+sgaPzm8906A4QMLCw@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Jon Masters <jcm@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 29/01/18 10:04, Ard Biesheuvel wrote:
> On 26 January 2018 at 14:28, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> In order to call into the firmware to apply workarounds, it is
>> useful to find out whether we're using HVC or SMC. Let's expose
>> this through the psci_ops.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  drivers/firmware/psci.c | 26 +++++++++++++++++++++-----
>>  include/linux/psci.h    |  7 +++++++
>>  2 files changed, 28 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/firmware/psci.c b/drivers/firmware/psci.c
>> index 8b25d31e8401..570187e5d084 100644
>> --- a/drivers/firmware/psci.c
>> +++ b/drivers/firmware/psci.c
>> @@ -59,7 +59,9 @@ bool psci_tos_resident_on(int cpu)
>>         return cpu == resident_cpu;
>>  }
>>
>> -struct psci_operations psci_ops;
>> +struct psci_operations psci_ops = {
>> +       .conduit = PSCI_CONDUIT_NONE,
>> +};
>>
>>  typedef unsigned long (psci_fn)(unsigned long, unsigned long,
>>                                 unsigned long, unsigned long);
>> @@ -210,6 +212,20 @@ static unsigned long psci_migrate_info_up_cpu(void)
>>                               0, 0, 0);
>>  }
>>
>> +static void set_conduit(enum psci_conduit conduit)
>> +{
>> +       switch (conduit) {
>> +       case PSCI_CONDUIT_HVC:
>> +               invoke_psci_fn = __invoke_psci_fn_hvc;
>> +               break;
>> +       case PSCI_CONDUIT_SMC:
>> +               invoke_psci_fn = __invoke_psci_fn_smc;
>> +               break;
> 
> I get a GCC warning here about PSCI_CONDUIT_NONE not being handled.


Yup, I fixed it already.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
