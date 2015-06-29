From: "Chalamarla, Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com>
Subject: Re: [PATCH] arm64/kvm: Add generic v8 KVM target
Date: Mon, 29 Jun 2015 18:39:54 +0000
Message-ID: <85D36B67-643B-407F-944F-D18D54FF9909@caviumnetworks.com>
References: <1434531646-4873-1-git-send-email-suzuki.poulose@arm.com>
 <CAFEAcA92uymQ3LjPQnuFiwvjSgc+jY54VrfK_Sh4v1DJ+=OPpw@mail.gmail.com>
 <558A6A84.5020603@arm.com> <20150624085128.GA22785@cbox>
 <558A7936.7020109@arm.com> <20150625123034.GE28244@cbox>
 <558BF6C9.3000009@arm.com> <558C05A9.8080201@arm.com>
 <CAFEAcA_ULz=ugQW=NmthzqYRtvcfwteQTh0DonHRN6U5NykEtQ@mail.gmail.com>
 <20150626095318.GG28244@cbox>
 <F37C68A5-E48F-462C-AD18-0F3C096348C7@caviumnetworks.com>
 <559180CA.3050905@arm.com>
 <CAFEAcA-E+KdiL4suQ0DoEvB-zGpNZ7-dq46FegC_iXYRPvo9jA@mail.gmail.com>
 <559185D4.7060308@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <559185D4.7060308@arm.com>
Content-Language: en-US
Content-ID: <EA1162B2BC8341409E4DAE83A5B49B80@namprd07.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, "Chalamarla, Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvm-devel <kvm@vger.kernel.org>, "timur@codeaurora.org" <timur@codeaurora.org>, "vgandhi@codeaurora.org" <vgandhi@codeaurora.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu


> On Jun 29, 2015, at 10:52 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> 
> On 29/06/15 18:38, Peter Maydell wrote:
>> On 29 June 2015 at 18:30, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> On 29/06/15 18:13, Chalamarla, Tirumalesh wrote:
>>>> Will this also prevents migrating between same implementations,
>>>> if no how is this identified.
>>> 
>>> This shouldn't. It is pretty easy to look at the incoming guest's MIDR,
>>> and verify that it matches the default MIDR on the receiving system. Any
>>> difference, and the migration should abort.
>> 
>> Do you really want to forbid migration between (say)
>> Cortex-A57 r3p0 and Cortex-A57 r3p1 ?
>> 
>> That seems pretty harsh.
> 
> I think we may need to allow for some flexibility (same major version
> only, or +/- 1 minor version...). The idea I'm trying to convey is that
> with "generic CPI", migration is not guaranteed unless we're on
> extremely similar hardware.
> 
yes, this is the point i am trying to make, we need some flexibility. so that it works with same chips with different passes may be. 
if we are allowing this, then we are not putting emulation as a requirement. 

Thanks,
Tirumalesh. 

> 	M.
> -- 
> Jazz is not dead. It just smells funny...

