From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: Vexpress TC2 no longer booting on v4.12-rc1
Date: Fri, 2 Jun 2017 23:24:50 +0100
Message-ID: <20170602222449.GB4902@n2100.armlinux.org.uk>
References: <CANLsYkz3dcVArStN2GJguYfJbWc_4dC4vvTE1KVtYpVWipEYjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF8BD40C5A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 18:21:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3Cv3brXt9Ptx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jun 2017 18:21:05 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEA9F4095A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 18:21:05 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CANLsYkz3dcVArStN2GJguYfJbWc_4dC4vvTE1KVtYpVWipEYjg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jun 02, 2017 at 04:16:59PM -0600, Mathieu Poirier wrote:
> Good afternoon Russell and friends,
> 
> I noticed that my vexpress-TC2 platform stopped booting when moving to
> kernel v4.12-rc1 (same with -rc2 and 3).  The last time things worked
> properly was on v4.11.  I did a bisect between v4.11 and v4.12-rc1 and
> ended up on [1], hence this email.
> 
> Since CONFIG_ARM_VIRT_EXT is selected by  default I removed the
> "#ifdef CONFIG_ARM_VIRT_EXT" section in the last hunk of the patch and
> the system sprung up to life again.

Hmm, this doesn't make much sense.  The code in last hunk of the patch
you refer to should only get run during system shutdown, not during
system boot, so I think something else is going on...

Please could you test again, this time rather than removing the #ifdef,
add two "mov r0, r0" there?  (So replacing the two instructions that
removing the ifdef would have exposed.)

Thanks.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
