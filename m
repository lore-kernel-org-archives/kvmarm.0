From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 12/15] arm-soc: omap: replace open coded VA->PA
 calculations
Date: Wed, 9 Aug 2017 12:05:57 -0700
Message-ID: <20170809190556.GD3934@atomide.com>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
 <20170805205222.19868-13-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7398749C2C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Aug 2017 15:04:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6WSET1vaowga for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Aug 2017 15:04:31 -0400 (EDT)
Received: from muru.com (muru.com [72.249.23.125])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A02340A86
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Aug 2017 15:04:31 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170805205222.19868-13-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: andrew@lunn.ch, baohua@kernel.org, dave.martin@arm.com, jason@lakedaemon.net, kvm@vger.kernel.org, nico@linaro.org, marc.zyngier@arm.com, horms@verge.net.au, magnus.damm@gmail.com, linux@armlinux.org.uk, krzk@kernel.org, patrice.chotard@st.com, linux-renesas-soc@vger.kernel.org, arm@kernel.org, vireshk@kernel.org, gregory.clement@free-electrons.com, linux-omap@vger.kernel.org, shiraz.linux.kernel@gmail.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, sebastian.hesselbarth@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

* Ard Biesheuvel <ard.biesheuvel@linaro.org> [170805 13:54]:
> This replaces a couple of open coded calculations to obtain the
> physical address of a far symbol with calls to the new adr_l etc
> macros.

I gave this series a quick test and omap3 no longer boots it seems.

Regards,

Tony
