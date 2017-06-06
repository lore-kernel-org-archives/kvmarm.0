From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH V17 02/11] ras: acpi/apei: cper: add support for generic
 data v3 structure
Date: Tue, 6 Jun 2017 09:22:15 +0000
Message-ID: <CAKv+Gu-JVeR7DJa-tMhNXtfv2tQGB67H+m=raqBj5X48n9oKPw@mail.gmail.com>
References: <1495225933-4410-1-git-send-email-tbaicar@codeaurora.org>
 <1495225933-4410-3-git-send-email-tbaicar@codeaurora.org>
 <20170602141338.GJ6371@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BC6D40969
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 05:18:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A+VtkxrCn2NH for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Jun 2017 05:18:10 -0400 (EDT)
Received: from mail-it0-f43.google.com (mail-it0-f43.google.com
 [209.85.214.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89B7240962
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 05:18:10 -0400 (EDT)
Received: by mail-it0-f43.google.com with SMTP id m47so102800255iti.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Jun 2017 02:22:16 -0700 (PDT)
In-Reply-To: <20170602141338.GJ6371@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, KVM devel mailing list <kvm@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Robert Moore <robert.moore@intel.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Lv Zheng <lv.zheng@intel.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Fu Wei <fu.wei@linaro.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, Russell King <linux@armlinux.org.uk>, gengdongjiu@huawei.com, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, eun.taik.lee@samsung.com, shijie.huang@arm.com, Laura Abbott <labbott@redhat.com>, Len Brown <lenb@kernel.org>, harba@codeaurora.org, John Garry <john.garry@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.ag>
List-Id: kvmarm@lists.cs.columbia.edu

On 2 June 2017 at 14:13, Will Deacon <will.deacon@arm.com> wrote:
> On Fri, May 19, 2017 at 02:32:04PM -0600, Tyler Baicar wrote:
>> The ACPI 6.1 spec adds a new revision of the generic error data
>> entry structure. Add support to handle the new structure as well
>> as properly verify and iterate through the generic data entries.
>>
>> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
>> CC: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
>> ---
>>  drivers/acpi/apei/ghes.c    | 11 +++++------
>>  drivers/firmware/efi/cper.c | 37 ++++++++++++++++++++++---------------
>>  include/acpi/ghes.h         | 36 ++++++++++++++++++++++++++++++++++++
>>  3 files changed, 63 insertions(+), 21 deletions(-)
>
> Given that Boris and Rafael are ok with this series, it makes sense to
> take this via arm64, but I need an ack from Ard or Matt on the EFI changes
> in this patch and the subsequent one.
>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
