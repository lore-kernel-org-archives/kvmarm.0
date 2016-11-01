From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v2 1/3] arm64: crypto/aes-ce-ccm: Cleanup hwcap check
Date: Tue, 1 Nov 2016 14:18:12 +0000
Message-ID: <42a11fce-d231-2317-3c8e-a9044bbe5f62@arm.com>
References: <1477929825-5907-1-git-send-email-suzuki.poulose@arm.com>
 <1477929825-5907-2-git-send-email-suzuki.poulose@arm.com>
 <CAKv+Gu9Y4Y2g66hQFFpsNxpwoKyfgrsqD5JstdEDUEUBykjO4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9Y4Y2g66hQFFpsNxpwoKyfgrsqD5JstdEDUEUBykjO4g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 01/11/16 14:03, Ard Biesheuvel wrote:
> Hi Suzuki,
>
> On 31 October 2016 at 16:03, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>> Use the module_cpu_feature_match to make sure the system has
>> HWCAP_AES to use the module.
>>
>> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>  arch/arm64/crypto/aes-ce-ccm-glue.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
>> index f4bf2f2..fa82eaa 100644
>> --- a/arch/arm64/crypto/aes-ce-ccm-glue.c
>> +++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
...
>> -module_init(aes_mod_init);
>> +module_cpu_feature_match(AES, aes_mod_init);
>
> I don't think this change is correct. This will result in the AES
> instruction dependency to be exposed via the module alias, causing the
> module to be loaded automatically as soon as udev detects that the CPU
> implements those instructions. For plain AES, that makes sense, but
> AES in CCM mode is specific to CCMP (WPA2) on mac80211 controllers
> that have no hardware AES support, and to IPsec VPN. For this reason,
> the algo type is exposed via the module alias instead (i.e,
> 'ccm(aes)'), which will result in the module being loaded as soon as
> the crypto algo manager instantiates the transform. On CPUs that don't
> implement the AES instructions, this will fail, and it will fall back
> to the generic CCM driver instead.

Ah, thanks for the explanation. I will drop it.

Cheers
Suzuki
