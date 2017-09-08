From: gengdongjiu <gengdongjiu@huawei.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIIHY2IDQvN10gYXJtNjQ6IGt2bTogc3VwcG9ydCB1c2Vy?=
 =?gb2312?Q?_space_to_query_RAS_extension_feature?=
Date: Fri, 8 Sep 2017 17:36:04 +0000
Message-ID: <0184EA26B2509940AA629AE1405DD7F2015F61EA@DGGEMA503-MBX.china.huawei.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <1503916701-13516-5-git-send-email-gengdongjiu@huawei.com>
 <59A84F9D.8030309@arm.com> <29951852-8d91-7c33-c68b-ad8b4bbdea54@huawei.com>
 <59B1747A.5030909@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <59B1747A.5030909@arm.com>
Content-Language: zh-CN
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>, Peter Maydell <peter.maydell@linaro.org>
Cc: "mark.rutland@arm.com" <mark.rutland@arm.com>, "Wangkefeng
 (Kevin)" <wangkefeng.wang@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "david.daney@cavium.com" <david.daney@cavium.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "tbaicar@codeaurora.org" <tbaicar@codeaurora.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Linuxarm <linuxarm@huawei.com>, "robert.moore@intel.com" <robert.moore@intel.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "zjzhang@codeaurora.org" <zjzhang@codeaurora.org>, "mingo@kernel.org" <mingo@kernel.org>, "stefan@hello-penguin.com" <stefan@hello-penguin.com>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Huangshaoyu <huangshaoyu@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

HI James,

[...]
> 
> The code to signal memory-failure to user-space doesn't depend on the CPU's RAS-extensions.
I roughly check your answer and agree with your general idea.
late I will check it in detail.

I have a question, do you sure that if CPU does not support RAS-extensions kernel can still call memory-failure() to send signal to qemu?

After my checking the code, the general flow is RAS module detects the error or CPU consumes the hardware poison data, happen exception, then EL3 firmware records the address to APEI table and send
notification to kernel. Kernel parses the APEI table to get address and call memory_failure() to identify the page to poison. That is to say, usually, after RAS detect the error, it call memory_failure(),
otherwise, it does not know whether this address is poison.
I am worried about one thing, if hardware does not has RAS, OS cannot know which address is poison, so it cannot identify the address , then the address that is delivered to Qemu(user space) may not right.

As you said, kernel can also call memory_failure() even without RAS support. in this without RAS case, how it consider the address is poison and needs to send SIGBUS to QEMU?

> 
> If Qemu supports notifying the guest about RAS errors using CPER records, it should generate a HEST describing firmware first. It can then
> choose the notification methods, some of which may require optional KVM APIs to support.
> 
> Seattle has a HEST, it doesn't support the CPU RAS-extensions. The kernel can notify user-space about memory_failure() on this machine. I
> would expect Qemu to be able to receive signals and describe memory errors to a guest (1).

Usually we consider the address got from APEI table is poison. If so, I want to know, without RAS and APEI table, how it identify the address to hwpoison?
