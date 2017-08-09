From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 12/15] arm-soc: omap: replace open coded VA->PA calculations
Date: Wed, 9 Aug 2017 20:22:57 +0100
Message-ID: <CAKv+Gu-kdjN8nXVNL2frsegu-z7HVnG8qcXpQbvM-oBbxKjUGA@mail.gmail.com>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
 <20170805205222.19868-13-ard.biesheuvel@linaro.org> <20170809190556.GD3934@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-renesas-soc-owner@vger.kernel.org>
In-Reply-To: <20170809190556.GD3934@atomide.com>
Sender: linux-renesas-soc-owner@vger.kernel.org
To: Tony Lindgren <tony@atomide.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-renesas-soc@vger.kernel.org, Russell King <linux@armlinux.org.uk>, "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>, KVM devel mailing list <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Krzysztof Kozlowski <krzk@kernel.org>, Jason Cooper <jason@lakedaemon.net>, arm@kernel.org, Andrew Lunn <andrew@lunn.ch>, Gregory CLEMENT <gregory.clement@free-electrons.com>, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>, baohua@kernel.org, Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>, vireshk@kernel.org, Shiraz Hashim <shiraz.linux.kernel@gmail.com>, Patrice CHOTARD <patrice.chotard@st.com>, nico@linaro.o
List-Id: kvmarm@lists.cs.columbia.edu

On 9 August 2017 at 20:05, Tony Lindgren <tony@atomide.com> wrote:
> * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170805 13:54]:
>> This replaces a couple of open coded calculations to obtain the
>> physical address of a far symbol with calls to the new adr_l etc
>> macros.
>
> I gave this series a quick test and omap3 no longer boots it seems.
>

Thanks Tony. I will investigate
