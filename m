From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v3 4/4] target-arm: Add the GICv2m to the
	virt board
Date: Tue, 26 May 2015 14:52:25 +0100
Message-ID: <CAFEAcA8J3nXMGw3iH5r_410P+5LVwvJDPMwcYoQs86q1gHh2JQ@mail.gmail.com>
References: <1432464666-4825-1-git-send-email-christoffer.dall@linaro.org>
	<1432464666-4825-5-git-send-email-christoffer.dall@linaro.org>
	<55646D0F.9040801@linaro.org>
	<CAFEAcA-NVfKXNOUo=3Li298wys-KFw1Vn9mVHbh+bc0aJ2efEQ@mail.gmail.com>
	<5564702F.2030308@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <5564702F.2030308@linaro.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Eric Auger <eric.auger@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, Christoffer Dall <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 26 May 2015 at 14:07, Eric Auger <eric.auger@linaro.org> wrote:
> On 05/26/2015 02:55 PM, Peter Maydell wrote:
>> On 26 May 2015 at 13:54, Eric Auger <eric.auger@linaro.org> wrote:
>>> Reviewed-by: Eric Auger <eric.auger@linaro.org>
>>>
>>> The only question I have is related to mid-term virt strategy about
>>> GICv3 integration. Are we going to reuse that memory map for the machine
>>> instantiating the GICv3? If yes, shouldn't we put the GICv2M somewhere
>>> else to leave space for GICv3 redistributors, assuming we reuse the
>>> shared distributor region. I understood the memory map is difficult to
>>> change once applied once.
>>
>> I wouldn't expect that you'd have a GICv2M at all in a
>> system with a GICv3 in it, would you?
>
> no indeed. but we currently use a single static a15memmap memory map in
> virt. This one is currently planned to be reused for machines
> instantiating GICv3 so we start seeing things like
> VIRT_GIC_CPU =  VIRT_GIC_REDIST. I fear this is going to become messy.

I think the answer is not to reuse constant names like that.
The v3 redistributor is not a v2 CPU interface, just as a
UART is not an RTC.

-- PMM
