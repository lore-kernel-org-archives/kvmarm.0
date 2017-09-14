From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 3/7] acpi: apei: remove the unused code
Date: Thu, 14 Sep 2017 13:35:26 +0100
Message-ID: <59BA778E.5000804@arm.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com> <1503916701-13516-4-git-send-email-gengdongjiu@huawei.com> <59A84C51.3000506@arm.com> <45c69f99-61dd-e847-368b-20acb61b4d50@huawei.com> <59B2DEBA.6030608@arm.com> <b06c680c-93a3-7e20-1118-c6a9a24704df@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b06c680c-93a3-7e20-1118-c6a9a24704df@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com, john.garry@huawei.com, jonathan.cameron@huawei.com, shameerali.kolot
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 11/09/17 13:04, gengdongjiu wrote:
> On 2017/9/9 2:17, James Morse wrote:
>> On 04/09/17 12:43, gengdongjiu wrote:
>>> On 2017/9/1 1:50, James Morse wrote:
>>>> On 28/08/17 11:38, Dongjiu Geng wrote:
>>>> If you aren't handling the notification, why is this is in the HEST at all?
>>>> (and if its not: its not firmware-first)
>>
>>> For the SEI notification, may be we can parse and handle the CPER record other than the Error physical address
>>
>> Sure, but I only see this cleanup patch in this series, where does APEI learn
>> about NOTIFY_SEI? As this is nothing will ever touch those CPER records, if
>> you're using GHESv2 firmware will be prevented from delivering subsequent
>> notifications.

> James, whether it is possible you can review the previous v5 patch which adds the support for

Spreading 'current discussion' over two versions is a problem for anyone trying
to follow this series.

If you post a newer version its normal for people to delete the older versions.
When you post a new version you should be happy that its the latest and greatest.


> NOTIFY_SEI? thanks in advancecIn that patch, I share the SEI notification
handling with the SEA
> notification handling to avoid duplicated code.

You may be able to share some of the code, but I don't think you should share
the list of GHES between notification methods.
This leads to races between the firmware and OS: If CPU-A has received an SEI
firmware would have to avoid generating an SEA on CPU-B as the SEI-handler
running on CPU-A may find and process the second set of CPER records. CPU-B then
gets a spurious notification.

Why is this a problem? KVM needs to know if APEI handled the error, or whether
the Synchronous-External-Abort/SError-Interrupt was due to something else, in
which case we invoke todays default behaviour, which isn't appropriate for a RAS
event.


Thanks,

James
