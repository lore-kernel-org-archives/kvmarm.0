From: Alexander Graf <agraf@suse.de>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Thu, 19 Feb 2015 16:27:17 +0100
Message-ID: <54E600D5.4070803@suse.de>
References: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>	<54E5F847.6050602@suse.de> <CAKv+Gu9zciD-KuRXbQhLJBgW6i4jk0-=hG6UrBWr6-g-uZkO1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9zciD-KuRXbQhLJBgW6i4jk0-=hG6UrBWr6-g-uZkO1A@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Laszlo Ersek <lersek@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Maydell <peter.maydell@linaro.org>, KVM devel mailing list <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu



On 19.02.15 15:56, Ard Biesheuvel wrote:
> On 19 February 2015 at 14:50, Alexander Graf <agraf@suse.de> wrote:
>>
>>
>> On 19.02.15 11:54, Ard Biesheuvel wrote:
>>> This is a 0th order approximation of how we could potentially force the guest
>>> to avoid uncached mappings, at least from the moment the MMU is on. (Before
>>> that, all of memory is implicitly classified as Device-nGnRnE)
>>>
>>> The idea (patch #2) is to trap writes to MAIR_EL1, and replace uncached mappings
>>> with cached ones. This way, there is no need to mangle any guest page tables.
>>
>> Would you mind to give a brief explanation on what this does? What
>> happens to actually assigned devices that need to be mapped as uncached?
>> What happens to DMA from such devices when the guest assumes that it's
>> accessing RAM uncached and then triggers DMA?
>>
> 
> On ARM, stage 2 mappings that are more strict will supersede stage 1
> mappings, so the idea is to use cached mappings exclusively for stage
> 1 so that the host is fully in control of the actual memory attributes
> by setting the attributes at stage 2. This also makes sense because
> the host will ultimately know better whether some range that the guest
> thinks is a device is actually a device or just emulated (no stage 2
> mapping), backed by host memory (such as the NOR flash read case) or
> backed by a passthrough device.

Ok, so that means if the guest maps RAM as uncached, it will actually
end up as cached memory. Now if the guest triggers a DMA request to a
passed through device to that RAM, it will conflict with the cache.

I don't know whether it's a big deal, but it's the scenario that came up
with the approach above before when I talked to people about it.


Alex
