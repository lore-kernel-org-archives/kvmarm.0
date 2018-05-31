From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v5 10/15] ARM: spectre-v2: warn about incorrect context
 switching functions
Date: Thu, 31 May 2018 11:11:34 +0100
Message-ID: <20180531101134.GR17671@n2100.armlinux.org.uk>
References: <20180529145320.GJ17671@n2100.armlinux.org.uk>
 <E1fNg1d-00059d-NR@rmk-PC.armlinux.org.uk>
 <86r2lu9yzf.wl-marc.zyngier@arm.com>
 <20180531094922.GQ17671@n2100.armlinux.org.uk>
 <b91753a0-7c47-1e46-6884-4643a90afdc7@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <b91753a0-7c47-1e46-6884-4643a90afdc7@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 31, 2018 at 11:07:18AM +0100, Marc Zyngier wrote:
> > I notice that you haven't replied to some of the patches (7 and 8),
> > which makes me think that you have an issue with them - and as tonight
> > is likely the last linux-next before the merge window, we're basically
> > out of time to do another respin if there's something you don't like
> > there and if we want to get them in during the next merge window.
> Patches 7 and 8 didn't compile for me, and I had to fix-up things
> manually in order to test it. Not that it should hold you back from
> merging it.

As noted in a reply to the cover, I made a mistake merging some changes
in that resulted in a simple-to-fix build error (a 'void' instead of a
'bool' return type.)  I wasn't going to send the series out for a third
time on the same day just because of that.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
