From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 0/3] KVM: arm/arm64: Clean up some obsolete code
Date: Mon, 2 Nov 2015 22:15:38 +0100
Message-ID: <20151102211538.GA5819@cbox>
References: <cover.1445934536.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C62C4981C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2015 16:12:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C-pKhNtT+fsB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2015 16:12:32 -0500 (EST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1B48497C0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2015 16:12:31 -0500 (EST)
Received: by wmeg8 with SMTP id g8so71446663wme.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Nov 2015 13:15:40 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <cover.1445934536.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 27, 2015 at 11:37:28AM +0300, Pavel Fedin wrote:
> Current KVM code has lots of old redundancies, which can be cleaned up.
> This patchset is actually a better alternative to
> http://www.spinics.net/lists/arm-kernel/msg430726.html, which allows to
> keep piggy-backed LRs. The idea is based on the fact that our code also
> maintains LR state in elrsr, and this information is enough to track LR
> usage.
> 
> In case of problems this series can be applied partially, each patch is
> a complete refactoring step on its own.
> 
> Thanks to Andre Przywara for pinpointing some 4.3+ specifics.
> 
> This version has been tested on SMDK5410 development board
> (Exynos5410 SoC).

I ran this through my test scripts and I'm now quite sure that there's
some breakage in here.

One of my tests is running two VMs in parallel, each booting up, running
hackbench, and then doing reboot (from within the guest), and just
repeating like that.

I've run your patches in the above config 100 times, and every time,
the rebooting VMs got stuck before 50 reboots.

Without these patches, I could run the above config 100 times, and every
time, the rebooting VMs passed 200 reboots.

I'll try to test each patch individually soon.

-Christoffer
