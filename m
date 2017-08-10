From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 12/15] arm-soc: omap: replace open coded VA->PA
 calculations
Date: Thu, 10 Aug 2017 07:03:58 -0700
Message-ID: <20170810140357.GA8569@atomide.com>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
 <20170805205222.19868-13-ard.biesheuvel@linaro.org>
 <20170809190556.GD3934@atomide.com>
 <CAKv+Gu-kdjN8nXVNL2frsegu-z7HVnG8qcXpQbvM-oBbxKjUGA@mail.gmail.com>
 <20170809210517.GE3934@atomide.com>
 <CAKv+Gu_vKJJAsEMY9o-MWLpY8jztcXWB25eQRAMo=FMZfVJfHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_vKJJAsEMY9o-MWLpY8jztcXWB25eQRAMo=FMZfVJfHg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-renesas-soc@vger.kernel.org, Russell King <linux@armlinux.org.uk>, "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>, KVM devel mailing list <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Krzysztof Kozlowski <krzk@kernel.org>, Jason Cooper <jason@lakedaemon.net>, arm@kernel.org, Andrew Lunn <andrew@lunn.ch>, Gregory CLEMENT <gregory.clement@free-electrons.com>, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>, baohua@kernel.org, Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>, vireshk@kernel.org, Shiraz Hashim <shiraz.linux.kernel@gmail.com>, Patrice CHOTARD <patrice.chotard@st.com>, nico@linaro.o
List-Id: kvmarm@lists.cs.columbia.edu

* Ard Biesheuvel <ard.biesheuvel@linaro.org> [170810 02:23]:
> On 9 August 2017 at 22:05, Tony Lindgren <tony@atomide.com> wrote:
> > * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170809 12:24]:
> >> On 9 August 2017 at 20:05, Tony Lindgren <tony@atomide.com> wrote:
> >> > * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170805 13:54]:
> >> >> This replaces a couple of open coded calculations to obtain the
> >> >> physical address of a far symbol with calls to the new adr_l etc
> >> >> macros.
> >> >
> >> > I gave this series a quick test and omap3 no longer boots it seems.
> >> >
> >>
> >> Thanks Tony. I will investigate
> >
> > Thanks. Looks like omap4 still boots with all your patches, but
> > omap3 won't boot even with patch 12 left out.
> >
> 
> Are you using the same image on both? Which .config?

Yes it's the same image compiled with omap2plus_defconfig.

Regards,

Tony
