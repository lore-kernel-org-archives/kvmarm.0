From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v3 08/15] ARM: spectre-v2: harden user aborts in kernel
 space
Date: Fri, 25 May 2018 09:15:55 -0700
Message-ID: <20180525161555.GD98604@atomide.com>
References: <20180525135938.GE17671@n2100.armlinux.org.uk>
 <E1fMDHD-00073Q-Ob@rmk-PC.armlinux.org.uk>
 <20180525154742.GA77025@atomide.com>
 <20180525155207.GF17671@n2100.armlinux.org.uk>
 <20180525160119.GC98604@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180525160119.GC98604@atomide.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

* Tony Lindgren <tony@atomide.com> [180525 16:04]:
> * Russell King - ARM Linux <linux@armlinux.org.uk> [180525 15:54]:
> > On Fri, May 25, 2018 at 08:47:42AM -0700, Tony Lindgren wrote:
> > > We can now get this with the whole series applied:
> > > 
> > > CPU0: Spectre v2: firmware did not set auxiliary control register
> > > IBE bit, system vulnerable
> > > CPU: Spectre v2: using ICIALLU workaround
> > > 
> > > So maybe change the wording from "using %s workaround" to
> > > "chosen workaround %s"?
> > > 
> > > Or I guess disabling the pr_info when not functional can
> > > be done in the later patches based on some variable set
> > > by check_spectre_auxcr() would be doable too.
> > 
> > You should not be getting both messages.  It looks like you're using
> > an older series - I assumed you pulled my git tree rather than the
> > patches?  The public git tree isn't up to date with these changes.
> 
> Yes I just fetched your git tree because it allows using
> git mergetool because of the conflicts with next. I'll apply
> manually and test again.

And testing with the correct patches in the $subject series
makes the issue go away.

Regards,

Tony
