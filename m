From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 1/2] arm: KVM: Do not update PC if the trap handler has
 updated it
Date: Tue, 22 Dec 2015 14:50:15 +0000
Message-ID: <CAFEAcA9dALQv8Xcyg5FLAvRaJfH5UT2u4jrLjofLh5Ff2yo=8Q@mail.gmail.com>
References: <1450778118-12715-1-git-send-email-marc.zyngier@arm.com>
 <1450778118-12715-2-git-send-email-marc.zyngier@arm.com> <CAFEAcA8F2TJuRR5ELvit0FPa3XFMJ847S8WK25i5aVdGBU=PUA@mail.gmail.com>
 <20151222143947.GA5631@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151222143947.GA5631@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Shannon Zhao <shannon.zhao@linaro.org>, kvm-devel <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 22 December 2015 at 14:39, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Tue, Dec 22, 2015 at 11:08:10AM +0000, Peter Maydell wrote:
>> Won't this result in our incorrectly skipping the first insn
>> in the fault handler if the original offending instruction
>> was itself the first insn in the fault handler?
>>
> Wouldn't that then loop with the exception forever?

Yes, but so would real hardware...

thanks
-- PMM
