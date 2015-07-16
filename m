From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH v4 0/2] arm/arm64: KVM: Optimize arm64 fp/simd,
 saves 30-50% on exits for non-VHE
Date: Thu, 16 Jul 2015 12:22:12 -0700
Message-ID: <55A80464.7000701@samsung.com>
References: <1436577547-5646-1-git-send-email-m.smarduch@samsung.com>
 <20150716155253.GU7845@cbox> <55A7F68C.6020903@samsung.com>
 <20150716190529.GA14369@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20150716190529.GA14369@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/16/2015 12:05 PM, Christoffer Dall wrote:
> On Thu, Jul 16, 2015 at 11:23:08AM -0700, Mario Smarduch wrote:
>> On 07/16/2015 08:52 AM, Christoffer Dall wrote:
>>> On Fri, Jul 10, 2015 at 06:19:05PM -0700, Mario Smarduch wrote:
>>>> This is a followp to previous iteration but implemented on top of VHE patches. 
>>>> Only non-VHE path is addressied by this patch. In second patch 32-bit handler 
>>>> is updated to keep exit handling consistent with 64-bit code, and nothing
>>>> has changed.
>>>>
>>> Why not simply preserve this the way it was in v3 and have it merged
>>> first - after all we have reviewed it and I thought it was more or less
>>> ready to be merged - I suspect the VHE patches may have a way to go
>>> still ?
>>
>> Definitely, that's a better path. After looking at VHE patches,
>> I would probably leave V3 the way it is (keeping deactivate_xxxx:
>> symmetric). Marc has Reviewed V3 and you commented either way was
>> fine with you, so V3 should be ok.
> 
> Yes, but there was a comment in the assembly file to fix up IIRC.

That's right 1/2 and 0/2 header need little bit of editing.

> 
> Can you do a quick respin with that commentary changed and then Marc
> can queue that if he agrees?
> 
> Thanks,
> -Christoffer
> 

