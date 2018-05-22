From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 06/14] ARM: spectre-v2: harden branch predictor on
 context switches
Date: Tue, 22 May 2018 11:27:34 -0700
Message-ID: <20180522182734.GL98604@atomide.com>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
 <E1fKjFD-00063u-Q5@rmk-PC.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <E1fKjFD-00063u-Q5@rmk-PC.armlinux.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

* Russell King <rmk+kernel@armlinux.org.uk> [180521 12:06]:
> Harden the branch predictor against Spectre v2 attacks on context
> switches for ARMv7 and later CPUs.  We do this by:
> 
> Cortex A9, A12, A17, A73, A75: invalidating the BTB.
> Cortex A15, Brahma B15: invalidating the instruction cache.
> 
> Cortex A57 and Cortex A72 are not addressed in this patch.
> 
> Cortex R7 and Cortex R8 are also not addressed as we do not enforce
> memory protection on these cores.

Not seeing regressions so:

Tested-by: Tony Lindgren <tony@atomide.com>
