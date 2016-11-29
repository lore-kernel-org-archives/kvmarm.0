From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V5 02/10] ras: acpi/apei: cper: generic error data entry
 v3 per ACPI 6.1
Date: Tue, 29 Nov 2016 10:30:02 -0700
Message-ID: <9cec3193-74b4-4e27-670b-3d6d36ee27a5@codeaurora.org>
References: <1479767763-27532-1-git-send-email-tbaicar@codeaurora.org>
 <1479767763-27532-3-git-send-email-tbaicar@codeaurora.org>
 <86258A5CC0A3704780874CF6004BA8A62DC87D66@lhreml502-mbb>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB1B6404AC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2016 12:29:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q+qIeC44EaF8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Nov 2016 12:29:19 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A68404047D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2016 12:29:19 -0500 (EST)
In-Reply-To: <86258A5CC0A3704780874CF6004BA8A62DC87D66@lhreml502-mbb>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shiju Jose <shiju.jose@huawei.com>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "lenb@kernel.org" <lenb@kernel.org>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, "robert.moore@intel.com" <robert.moore@intel.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "nkaje@codeaurora.org" <nkaje@codeaurora.org>, "zjzhang@codeaurora.org" <zjzhang@codeaurora.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "james.morse@arm.com" <james.morse@arm.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "eun.taik.lee@samsung.com" <eun.taik.lee@samsung.com>"sandeepa.s.prabhu@gmail.com" <s>
List-Id: kvmarm@lists.cs.columbia.edu

On 11/29/2016 4:29 AM, Shiju Jose wrote:
>> @@ -451,12 +484,12 @@ void cper_estatus_print(const char *pfx,
>>   	printk("%s""event severity: %s\n", pfx,
>> cper_severity_str(severity));
>>   	data_len = estatus->data_length;
>>   	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
>> +
>>   	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
>> -	while (data_len >= sizeof(*gdata)) {
>> -		gedata_len = gdata->error_data_length;
>> +
>> +	while (data_len >= acpi_hest_generic_data_size(gdata)) {
>>   		cper_estatus_print_section(newpfx, gdata, sec_no);
>> -		data_len -= gedata_len + sizeof(*gdata);
>> -		gdata = (void *)(gdata + 1) + gedata_len;
>> +		gdata = acpi_hest_generic_data_next(gdata);
>>   		sec_no++;
>>   	}
>>   }
> Hi Tyler,
> Will the above while loop does not come out because data_len is not getting updated as it did in V4 patch?
> This is the behaviour seen when we tested on our platform. It worked fine when we update the data_len.

Hello Shiju,

Thank you for testing, and you're right...looks like I got a little too excited at this code simplification. :)
I'll add the data_len update in the next patchset.

Thanks,
Tyler
