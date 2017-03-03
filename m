From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V11 10/10] arm/arm64: KVM: add guest SEA support
Date: Fri, 3 Mar 2017 15:43:46 -0700
Message-ID: <e1578c9f-7595-9705-9a5a-5811cf6c8513@codeaurora.org>
References: <1487712121-16688-1-git-send-email-tbaicar@codeaurora.org>
 <1487712121-16688-11-git-send-email-tbaicar@codeaurora.org>
 <86258A5CC0A3704780874CF6004BA8A62DCAD116@lhreml502-mbs>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A351040BBB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Mar 2017 17:42:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LQH09CroeGdb for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Mar 2017 17:42:36 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B2C8140AF9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Mar 2017 17:42:36 -0500 (EST)
In-Reply-To: <86258A5CC0A3704780874CF6004BA8A62DCAD116@lhreml502-mbs>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shiju Jose <shiju.jose@huawei.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "lenb@kernel.org" <lenb@kernel.org>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, "robert.moore@intel.com" <robert.moore@intel.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "nkaje@codeaurora.org" <nkaje@codeaurora.org>, "zjzhang@codeaurora.org" <zjzhang@codeaurora.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "james.morse@arm.com" <james.morse@arm.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, eun.taik.lee@samsung.com
List-Id: kvmarm@lists.cs.columbia.edu

Hello Shiju,


On 3/3/2017 8:34 AM, Shiju Jose wrote:
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c index
>> b2d57fc..403277b 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -602,6 +602,24 @@ static const char *fault_name(unsigned int esr)  }
>>
>>   /*
>> + * Handle Synchronous External Aborts that occur in a guest kernel.
>> + */
>> +int handle_guest_sea(unsigned long addr, unsigned int esr) {
>> +	/*
>> +	 * synchronize_rcu() will wait for nmi_exit(), so no need to
>> +	 * rcu_read_lock().
>> +	 */
>> +	if(IS_ENABLED(HAVE_ACPI_APEI_SEA)) {
> IS_ENABLED(HAVE_ACPI_APEI_SEA) to be changed to IS_ENABLED(ACPI_APEI_SEA) same
> as in the patch "acpi: apei: handle SEA notification type for ARMv8"?
>
Good catch, I guess my FW still triggers the SCI interrupt as well as 
replays the SEA to kernel which is why I still get into the GHES handling :)

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
