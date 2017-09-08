From: gengdongjiu <gengdongjiu@huawei.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIIHY2IDQvN10gYXJtNjQ6IGt2bTogc3VwcG9ydCB1c2Vy?=
 =?gb2312?Q?_space_to_query_RAS_extension_feature?=
Date: Fri, 8 Sep 2017 14:34:27 +0000
Message-ID: <0184EA26B2509940AA629AE1405DD7F2015F5A1C@DGGEMA503-MBX.china.huawei.com>
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
To: James Morse <james.morse@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Zhaoshenglong <zhaoshenglong@huawei.com>
Cc: "mark.rutland@arm.com" <mark.rutland@arm.com>, "Wangkefeng
 (Kevin)" <wangkefeng.wang@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "david.daney@cavium.com" <david.daney@cavium.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "tbaicar@codeaurora.org" <tbaicar@codeaurora.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Linuxarm <linuxarm@huawei.com>, "robert.moore@intel.com" <robert.moore@intel.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "zjzhang@codeaurora.org" <zjzhang@codeaurora.org>, "mingo@kernel.org" <mingo@kernel.org>, "stefan@hello-penguin.com" <stefan@hello-penguin.com>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Huangshaoyu <huangshaoyu@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,
  Thanks a lot for your detailed comments.

CC Peter.

Peter is Qemu expert. Let us see his suggestion.

> 
> Hi gengdongjiu,
> 
> On 05/09/17 08:18, gengdongjiu wrote:
> > On 2017/9/1 2:04, James Morse wrote:
> >> On 28/08/17 11:38, Dongjiu Geng wrote:
> >>> Userspace will want to check if the CPU has the RAS extension.
> >>
> >> ... but user-space wants to know if it can inject SErrors with a specified ESR.
> >>
> >> What if we gain another way of doing this that isn't via the
> >> RAS-extensions, now user-space has to check for two capabilities.
> >>
> >>
> >>> If it has, it wil specify the virtual SError syndrome value,
> >>> otherwise it will not be set. This patch adds support for querying
> >>> the availability of this extension.
> >>
> >> I'm against telling user-space what features the CPU has unless it
> >> can use them directly. In this case we are talking about a KVM API,
> >> so we should describe the API not the CPU.
> >
> > shenglong (zhaoshenglong@huawei.com) who is Qemu maintainer suggested
> > checking the CPU RAS-extensions to decide whether generate the APEI table and record CPER for the guest OS in the user space.
> > he means if the host does not support RAS, user space may also not support RAS.
> 
> The code to signal memory-failure to user-space doesn't depend on the CPU's RAS-extensions.
> 
> If Qemu supports notifying the guest about RAS errors using CPER records, it should generate a HEST describing firmware first. It can then
> choose the notification methods, some of which may require optional KVM APIs to support.
> 
> Seattle has a HEST, it doesn't support the CPU RAS-extensions. The kernel can notify user-space about memory_failure() on this machine. I
> would expect Qemu to be able to receive signals and describe memory errors to a guest (1).
> 
> The question should be: 'How can Qemu know it can use SEI as a firmware-first notification?' It needs a KVM API to trigger an SError in the
> guest with a specified ESR. The name of the KVM CAP needs to reflect the API (2).
> 
> Just because this is the first KVM API that needs the CPU to have the RAS extensions doesn't mean we should call it 'has RAS' and be done
> with it.
> 
> We will eventually need another KVM API to configure trapping and emulating values in the RAS ERR registers so that Qemu can emulate a
> machine without firmware-first. (This is likely to be a page of memory that backs the registers, there will need to be another KVM CAP to
> describe this support (3)).
> 
> 
> Exposing the CPUs support for RAS-extensions to support (2) means having per-platform support for (1). This is either creating extra work,
> or not supporting as many platforms as we could. Both are bad.
> Once we have (3) as well, any developer needs to know that 'has RAS' just meant the first API KVM implemented using RAS, and doesn't
> mean later APIs also using RAS are supported by the kernel.


Hi Peter/ shenglong,
   What is your idea about it? We may need to consult with you about it.

> 
> 
> Thanks,
> 
> James
