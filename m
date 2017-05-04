From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 1/3] arm64: kvm: support kvmtool to detect RAS extension
 feature
Date: Thu, 04 May 2017 09:19:23 +0100
Message-ID: <590AE40B.7060002@arm.com>
References: <1493530677-4919-1-git-send-email-gengdongjiu@huawei.com> <20170502075631.GE16940@cbox> <8d443da4-d17f-2487-10d5-b6c9639dc5a4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <8d443da4-d17f-2487-10d5-b6c9639dc5a4@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, Dongjiu Geng <gengdongjiu@huawei.com>, marc.zyngier@arm.com, christoffer.dall@linaro.org, rkrcmar@redhat.com, linux@armlinux.org.uk, tbaicar@codeaurora.org, imammedo@redhat.com, zhaoshenglong@huawei.com, peter.maydell@linaro.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org, lersek@redhat.com, ard.biesheuvel@linaro.org, mtsirkin@redhat.com, drjones@redhat.com, ben@skyportsystems.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, xiexiuqi@huawei.com, wangxiongfeng2@huawei.com, songwenjun@huawei.com, wuquanming@huawei.com, huangshaoyu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,

On 02/05/17 16:48, Paolo Bonzini wrote:
> On 02/05/2017 09:56, Christoffer Dall wrote:
>> The subject and description of these patches are also misleading.
>> Hopefully this is in no way tied to kvmtool, but to userspace
>> generically, for example also to be used by QEMU?
> 
> Yes, QEMU already has a similar capability on x86.
> 
> Does ARM support background scrubbing of memory to detect errors? 

As part of RAS support, yes. A way for firmware to notify the OS about these
events was recently added to the ACPI specification.
We are aiming to turn on ARCH_SUPPORTS_MEMORY_FAILURE which does the Linux end
of things. Punit has a series here:
https://www.spinics.net/lists/arm-kernel/msg575944.html


> If
> so, are there any plans to support action-optional SIGBUS on ARM?

It looks like ARCH_SUPPORTS_MEMORY_FAILURE will bring that in, so yes.



Thanks,

James
