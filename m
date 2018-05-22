From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 07/14] ARM: spectre-v2: add Cortex A8 and A15 validation
 of the IBE bit
Date: Tue, 22 May 2018 11:28:12 -0700
Message-ID: <20180522182811.GM98604@atomide.com>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
 <E1fKjFJ-000641-5N@rmk-PC.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <E1fKjFJ-000641-5N@rmk-PC.armlinux.org.uk>
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

* Russell King <rmk+kernel@armlinux.org.uk> [180521 12:09]:
> When the branch predictor hardening is enabled, firmware must have set
> the IBE bit in the auxiliary control register.  If this bit has not
> been set, the Spectre workarounds will not be functional.
> 
> Add validation that this bit is set, and print a warning at alert level
> if this is not the case.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Yup the alert is working:

Tested-by: Tony Lindgren <tony@atomide.com>
