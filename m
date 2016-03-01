From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH v2 0/8] arm64: Support for systems without AArch32 state
Date: Wed, 2 Mar 2016 00:19:23 +0300
Message-ID: <20160301211923.GA1325@yury-N73SV>
References: <1456393968-17386-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1456393968-17386-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 25, 2016 at 09:52:40AM +0000, Suzuki K Poulose wrote:
> This series add checks to make sure that the AArch32 state is
> supported before we process the 32bit ID registers. Also
> checks the same for COMPAT binary execution.
> 
> (Painfully) applies on top of 4.5-rc5 + [1] + [2].
> 
> Or it is available here :
>   git://linux-arm.org/linux-skp.git noaarch32/v2-4.5-rc5
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-February/410556.html
> [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-January/401913.html
> 
> Changes since V1:
>   - Prevent changing the personality to PER_LINUX32 by adding
>     wrapper for personality() syscall.
>   - Add the check to KVM before initialising a AArch32 vcpu
>   - Tested on hardware.
> 
> Btw, linux32 doesn't complain when the personality() syscall fails to change
> to PER_LINUX32. You can verify the personality by running 
>  $ cat /proc/cpuinfo
>  which would still list the 64bit features for the CPUs.

Hi Suzuki,

I have some troubles with access to appropriate hardware to test
it, but I didn't forget.

Yury.
