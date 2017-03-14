From: Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH v3 00/25] arm/arm64: KVM: Rework the hyp-stub API
Date: Tue, 14 Mar 2017 09:25:24 -0500
Message-ID: <CAGo_u6rHmn676_PZYj+6LGf-bRBBxdn1=PYX32o-_ki=OBXs-g@mail.gmail.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com> <8493dac7-c9be-fd3b-c5c0-83fbbfa4af10@ti.com>
 <8d2cf6fa-cac7-268b-bc26-2649f5696196@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <8d2cf6fa-cac7-268b-bc26-2649f5696196@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Keerthy <j-keerthy@ti.com>, Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, cdall@linaro.org, james.morse@arm.com, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 14, 2017 at 8:55 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
[...]
>> Tested for kexec booting with the patch series applied on linux-next.
>>
>> kexec is working nicely with HYP and SVC modes. Tested for both modes by
>> using different u-boot for booting in HYP and SVC modes. Kexec works well.
>>
>> Tested on DRA7-EVM, AM57XX-EVM and KEYSTONE-K2E-EVM.
>>
>> Tested-by: Keerthy <j-keerthy@ti.com>
>
> Thanks a lot. I assume this Tested-by applies to the 32bit patches in
> this series?

Yes, the above platform list from Keerthy are all A15 32bit platforms.

---
Regards,
Nishanth Menon
