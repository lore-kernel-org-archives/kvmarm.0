From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH] arm64/kvm: Add generic v8 KVM target
Date: Fri, 3 Jul 2015 09:12:01 +0100
Message-ID: <CAFEAcA8nt7yr0K4QesJjWqEwBgziWOt2DViY70E=z2wjt=X7XA@mail.gmail.com>
References: <1434531646-4873-1-git-send-email-suzuki.poulose@arm.com>
 <CAFEAcA92uymQ3LjPQnuFiwvjSgc+jY54VrfK_Sh4v1DJ+=OPpw@mail.gmail.com>
 <558A6A84.5020603@arm.com> <20150624085128.GA22785@cbox> <558A7936.7020109@arm.com>
 <20150625123034.GE28244@cbox> <558BF6C9.3000009@arm.com> <558C05A9.8080201@arm.com>
 <CAFEAcA_ULz=ugQW=NmthzqYRtvcfwteQTh0DonHRN6U5NykEtQ@mail.gmail.com>
 <20150626095318.GG28244@cbox> <F37C68A5-E48F-462C-AD18-0F3C096348C7@caviumnetworks.com>
 <559180CA.3050905@arm.com> <CAFEAcA-E+KdiL4suQ0DoEvB-zGpNZ7-dq46FegC_iXYRPvo9jA@mail.gmail.com>
 <559185D4.7060308@arm.com> <85D36B67-643B-407F-944F-D18D54FF9909@caviumnetworks.com>
 <D805D093-CCFE-4835-853A-B2654DAA10A1@caviumnetworks.com> <559642EE.1050605@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <559642EE.1050605@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "Chalamarla, Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvm-devel <kvm@vger.kernel.org>, "timur@codeaurora.org" <timur@codeaurora.org>, "vgandhi@codeaurora.org" <vgandhi@codeaurora.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 3 July 2015 at 09:08, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 02/07/15 21:29, Chalamarla, Tirumalesh wrote:
>> is there a chance that this get merged in to 4.2? if not is it possible
>> to accept the other patches like adding implementations explicitly(like
>> Thunder).
>
> We first need to reach a conclusion on this. Until then, I don't plan to
> get anything in. As for 4.2, it feels way too late (the merge window is
> almost closed now).

I would still like to see the proponents of this patch say
what their model is for userspace support of cross-host migration,
if we're abandoning the model the current API envisages.

thanks
-- PMM
