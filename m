From: Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: Vexpress TC2 no longer booting on v4.12-rc1
Date: Mon, 5 Jun 2017 10:18:21 +0100
Message-ID: <a8b9336e-661a-841a-ca93-45ebe1b55994@arm.com>
References: <CANLsYkz3dcVArStN2GJguYfJbWc_4dC4vvTE1KVtYpVWipEYjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1786A40C4E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 05:14:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SA6t1-fRiryM for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Jun 2017 05:14:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0D1240C49
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 05:14:21 -0400 (EDT)
In-Reply-To: <CANLsYkz3dcVArStN2GJguYfJbWc_4dC4vvTE1KVtYpVWipEYjg@mail.gmail.com>
Content-Language: en-US
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
Cc: Christoffer Dall <cdall@linaro.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 02/06/17 23:16, Mathieu Poirier wrote:
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
> 
> Compiler: arm-linux-gnueabi-gcc (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.4)
> 5.4.0 20160609
> Kernel command line: console=ttyAMA0,38400 loglevel=8 root=/dev/sda2 rootwait
> U-boot:
>  ## Flattened Device Tree blob at 82000000
>    Booting using the fdt blob at 0x82000000
>    Loading Ramdisk to 9fcea000, end 9feea6d1 ... OK
>    Loading Device Tree to 9fce2000, end 9fce9ad8 ... OK
> 
> I'm not sure what else you need at this time - simply get back to me
> with what I'm missing and I'll be happy to provided.  I'm also
> offering to test patches.
> 

Fixed[1] and must be queued in rmk's tree[2].

-- 
Regards,
Sudeep

[1] https://www.spinics.net/lists/arm-kernel/msg581877.html
[2] http://www.armlinux.org.uk/developer/patches/viewpatch.php?id=8675
