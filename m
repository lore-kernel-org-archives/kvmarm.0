From: Fu Wei <fu.wei@linaro.org>
Subject: Re: [PATCH v3 6/6] kvm: arm64: Add ACPI support for virt arch timer
Date: Mon, 22 Feb 2016 00:35:46 +0800
Message-ID: <CADyBb7uPxV0DUwsqpq5fBeZSU6JXRzh6kNeHy-vmpq+f0+q1FQ@mail.gmail.com>
References: <1454358418-5157-1-git-send-email-fu.wei@linaro.org>
 <1454358418-5157-7-git-send-email-fu.wei@linaro.org>
 <56B8CBE8.7020305@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C458F495BD
 for <kvmarm@lists.cs.columbia.edu>; Sun, 21 Feb 2016 11:29:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pbnTL2UybZ9k for <kvmarm@lists.cs.columbia.edu>;
 Sun, 21 Feb 2016 11:29:13 -0500 (EST)
Received: from mail-oi0-f49.google.com (mail-oi0-f49.google.com
 [209.85.218.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E8E849444
 for <kvmarm@lists.cs.columbia.edu>; Sun, 21 Feb 2016 11:29:13 -0500 (EST)
Received: by mail-oi0-f49.google.com with SMTP id m82so41331010oif.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 21 Feb 2016 08:35:46 -0800 (PST)
In-Reply-To: <56B8CBE8.7020305@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Linaro ACPI Mailman List <linaro-acpi@lists.linaro.org>, Will Deacon <will.deacon@arm.com>, Wim Van Sebroeck <wim@iguana.be>, kvmarm@lists.cs.columbia.edu, Al Stone <al.stone@linaro.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-acpi@vger.kernel.org, Rob Herring <robherring2@gmail.com>, jeffrey.t.kirsher@intel.com, Catalin Marinas <catalin.marinas@arm.com>, Len Brown <lenb@kernel.org>, Arnd Bergmann <arnd@arndb.de>, gleb@kernel.org, Jon Masters <jcm@redhat.com>, richardcochran@gmail.com, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, G Gregory <graeme.gregory@linaro.org>, Rafael Wysocki <rjw@rjwysocki.net>, LKML <linux-kernel@vger.kernel.org>, Leo Duran <leo.duran@amd.com>, Hanjun Guo <hanjun.guo@linaro.org>, pbonzini@redhat.com, davem@davemloft.net
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc

On 9 February 2016 at 01:10, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 01/02/16 20:26, fu.wei@linaro.org wrote:
>> From: Fu Wei <fu.wei@linaro.org>
>>
>> This patch adds ACPI/GTDT support for virt arch timer
>> using the API in GTDT driver.
>>
>> Signed-off-by: Fu Wei <fu.wei@linaro.org>
>> ---
>>  virt/kvm/arm/arch_timer.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>> index 0a279d3..4077347 100644
>> --- a/virt/kvm/arm/arch_timer.c
>> +++ b/virt/kvm/arm/arch_timer.c
>> @@ -385,6 +385,9 @@ static int kvm_timer_get_ppi(unsigned int *ppi)
>>  {
>>       struct device_node *np;
>>       int ret = -EINVAL;
>> +#ifdef CONFIG_ACPI_GTDT
>> +     struct arch_timer_data data;
>> +#endif
>>
>>       np = of_find_matching_node(NULL, arch_timer_of_match);
>>       if (!np) {
>> @@ -397,6 +400,11 @@ static int kvm_timer_get_ppi(unsigned int *ppi)
>>       of_node_put(np);
>>
>>  skip_of:
>> +#ifdef CONFIG_ACPI_GTDT
>> +     if (!*ppi && !gtdt_arch_timer_data_init(NULL, &data))
>> +             *ppi = data.virt_ppi;
>> +#endif
>> +
>>       if (*ppi)
>>               return 0;
>>
>>
>
> As I already pointed out in another thread hacking some KVM ACPI stuff,
> this is the wrong approach.
>
> We should have a *common* accessor in the timer code that exports the
> relevant information, whatever the firmware "du jour" is.
>
> See Julien's series, which seems to address the issue in a much more
> convincing way:
>
> https://lists.cs.columbia.edu/pipermail/kvmarm/2016-February/018531.html
>

Thanks for your info, I have read through Julien's patchset in mailing list.
This patch is a improvement from Wei Huang's patch using my GTDT driver,
because his approach is getting info from DTB or ACPI directly.

But It seems Wei Huang is helping Julien on his patchset and trying to
provide Tested-by,
So I will delete these two patches(about kvm), and test Julien's patch also.

> Thanks,
>
>         M.
> --
> Jazz is not dead. It just smells funny...



-- 
Best regards,

Fu Wei
Software Engineer
Red Hat Software (Beijing) Co.,Ltd.Shanghai Branch
Ph: +86 21 61221326(direct)
Ph: +86 186 2020 4684 (mobile)
Room 1512, Regus One Corporate Avenue,Level 15,
One Corporate Avenue,222 Hubin Road,Huangpu District,
Shanghai,China 200021
