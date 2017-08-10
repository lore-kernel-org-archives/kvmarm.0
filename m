From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 12/15] arm-soc: omap: replace open coded VA->PA
 calculations
Date: Thu, 10 Aug 2017 10:22:20 +0100
Message-ID: <CAKv+Gu_vKJJAsEMY9o-MWLpY8jztcXWB25eQRAMo=FMZfVJfHg@mail.gmail.com>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
 <20170805205222.19868-13-ard.biesheuvel@linaro.org>
 <20170809190556.GD3934@atomide.com>
 <CAKv+Gu-kdjN8nXVNL2frsegu-z7HVnG8qcXpQbvM-oBbxKjUGA@mail.gmail.com>
 <20170809210517.GE3934@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32CEF49C29
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Aug 2017 05:20:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3ANK1TF8P8eu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Aug 2017 05:20:49 -0400 (EDT)
Received: from mail-it0-f52.google.com (mail-it0-f52.google.com
 [209.85.214.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2BA6C40A86
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Aug 2017 05:20:48 -0400 (EDT)
Received: by mail-it0-f52.google.com with SMTP id 76so10393589ith.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Aug 2017 02:22:22 -0700 (PDT)
In-Reply-To: <20170809210517.GE3934@atomide.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Tony Lindgren <tony@atomide.com>
Cc: Andrew Lunn <andrew@lunn.ch>, baohua@kernel.org, Dave Martin <dave.martin@arm.com>, Jason Cooper <jason@lakedaemon.net>, KVM devel mailing list <kvm@vger.kernel.org>, "nico@linaro.org" <nico@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>, Russell King <linux@armlinux.org.uk>, Krzysztof Kozlowski <krzk@kernel.org>, Patrice CHOTARD <patrice.chotard@st.com>, linux-renesas-soc@vger.kernel.org, arm@kernel.org, vireshk@kernel.org, Gregory CLEMENT <gregory.clement@free-electrons.com>, "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>, Shiraz Hashim <shiraz.linux.kernel@gmail.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 9 August 2017 at 22:05, Tony Lindgren <tony@atomide.com> wrote:
> * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170809 12:24]:
>> On 9 August 2017 at 20:05, Tony Lindgren <tony@atomide.com> wrote:
>> > * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170805 13:54]:
>> >> This replaces a couple of open coded calculations to obtain the
>> >> physical address of a far symbol with calls to the new adr_l etc
>> >> macros.
>> >
>> > I gave this series a quick test and omap3 no longer boots it seems.
>> >
>>
>> Thanks Tony. I will investigate
>
> Thanks. Looks like omap4 still boots with all your patches, but
> omap3 won't boot even with patch 12 left out.
>

Are you using the same image on both? Which .config?
