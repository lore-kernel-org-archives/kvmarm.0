From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 04/13] vfio-pci: use 32-bit comparisons for register address for gcc-4.5
Date: Fri, 16 Dec 2016 20:50:33 +0100
Message-ID: <3673393.CH4rJCRAcf@wuerfel>
References: <20161216105634.235457-1-arnd@arndb.de> <20161216105634.235457-5-arnd@arndb.de> <20161216083056.33ea0fa9@t450s.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20161216083056.33ea0fa9@t450s.home>
Sender: linux-arch-owner@vger.kernel.org
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kernel-build-reports@lists.linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Friday, December 16, 2016 8:30:56 AM CET Alex Williamson wrote:
> 
> Acked-by: Alex Williamson <alex.williamson@redhat.com>
> 
> Would you like me to pull this one patch in through the vfio tree?
> Thanks,

If you think the patch is appropriate, please merge it.

I originally just posted this as illustration to raise the
question of whether we actually want to support gcc-4.5,
from the feedback so far it does seem like the answer is yes,
and we will need it.

	Arnd
