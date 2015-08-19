From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH v4 1/2] arm64: KVM: Optimize arm64 skip 30-50% vfp/simd
 save/restore on exits
Date: Wed, 19 Aug 2015 16:21:14 -0700
Message-ID: <55D50F6A.9020604@samsung.com>
References: <1437082178-11039-1-git-send-email-m.smarduch@samsung.com>
 <1437082178-11039-2-git-send-email-m.smarduch@samsung.com>
 <55C235B9.3000800@arm.com> <20150819174958.GA11518@cbox>
 <55D4FA88.5060305@samsung.com> <20150819232839.69531eca@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20150819232839.69531eca@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Great that's even better.

On 8/19/2015 3:28 PM, Marc Zyngier wrote:
> On Wed, 19 Aug 2015 14:52:08 -0700
> Mario Smarduch <m.smarduch@samsung.com> wrote:
> 
>> Hi Christoffer,
>>    I'll test it and work with it.
> 
> FWIW, I've added these patches to both -queue and -next, and from the
> tests Christoffer has run, it looks pretty good.
> 
> Thanks,
> 
> 	M.
> 
