From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 00/26] KVM/ARM: Add support for GICv4
Date: Mon, 9 Oct 2017 19:02:50 +0100
Message-ID: <63365b61-5a2e-220c-a543-d2245bd7f8a5@arm.com>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
 <20171009175239.GE23730@char.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171009175239.GE23730@char.us.oracle.com>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/10/17 18:52, Konrad Rzeszutek Wilk wrote:
> On Fri, Oct 06, 2017 at 04:33:35PM +0100, Marc Zyngier wrote:
>> This series implements full support for GICv4 in KVM, bringing direct
>> injection of MSIs to arm and arm64, assuming you have the right
>> hardware (which is quite unlikely).
>>
>> To get an idea of the design, I'd recommend you start with commit
>> 7954907bedaf as well as patch #26, which try to shed some light on the
>> approach that I've taken. And before that, please digest some of the
>> GICv3/GICv4 architecture documentation[1] (less than 800 pages!). Once
>> you feel reasonably insane, you'll be in the right mood to read the
> 
> You may want to update the link:
> 
> s/pfd/pdf/
> 
> (Does that mean you typed this by hand, my gosh, you really are breathing
> this everyday) :-)
I am, and I'm feeling pretty dizzy. You can't imagine the kind of fumes
this thing generates... ;-)

I probably copy/pasted the URL, edited something, messed up the URL,
fixed it (sort of), and ended posting the crap (twice!) without even
realizing. Oh well. I'll blame the spec, as always.

Thanks for the heads up!

	M.
-- 
Jazz is not dead. It just smells funny...
