From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH v2 0/8] arm64: Support for systems without AArch32 state
Date: Wed, 2 Mar 2016 18:07:21 +0300
Message-ID: <20160302150721.GA16286@yury-N73SV>
References: <1456393968-17386-1-git-send-email-suzuki.poulose@arm.com>
 <20160301211923.GA1325@yury-N73SV>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160301211923.GA1325@yury-N73SV>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 02, 2016 at 12:19:23AM +0300, Yury Norov wrote:
> On Thu, Feb 25, 2016 at 09:52:40AM +0000, Suzuki K Poulose wrote:
> > This series add checks to make sure that the AArch32 state is
> > supported before we process the 32bit ID registers. Also
> > checks the same for COMPAT binary execution.
> > 
> > (Painfully) applies on top of 4.5-rc5 + [1] + [2].
> > 
> > Or it is available here :
> >   git://linux-arm.org/linux-skp.git noaarch32/v2-4.5-rc5
> > 
> > [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-February/410556.html
> > [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-January/401913.html
> > 
> > Changes since V1:
> >   - Prevent changing the personality to PER_LINUX32 by adding
> >     wrapper for personality() syscall.
> >   - Add the check to KVM before initialising a AArch32 vcpu
> >   - Tested on hardware.
> > 
> > Btw, linux32 doesn't complain when the personality() syscall fails to change
> > to PER_LINUX32. You can verify the personality by running 
> >  $ cat /proc/cpuinfo
> >  which would still list the 64bit features for the CPUs.
> 
> Hi Suzuki,
> 
> I have some troubles with access to appropriate hardware to test
> it, but I didn't forget.
> 
> Yury.

Hi Suzuki,

ubuntu@arm64:~$ uname -a
Linux arm64 4.5.0-rc5-00019-g3e330b9 #76 SMP PREEMPT Wed Mar 2 17:46:57 MSK 2016 aarch64 aarch64 aarch64 GNU/Linux

ubuntu@arm64:~$ cat /proc/cpuinfo
processor       : 0-47
BogoMIPS        : 200.00
Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics
CPU implementer : 0x43
CPU architecture: 8
CPU variant     : 0x1
CPU part        : 0x0a1
CPU revision    : 0

ubuntu@arm64:~$ file readdir
readdir: ELF 32-bit LSB  executable, ARM, EABI5 version 1 (SYSV), statically linked, for GNU/Linux 2.6.32,
BuildID[sha1]=aeebc12494450b55a2ab0d39ebd2e121e9085d5c, not stripped

W/o 32_EL0:
ubuntu@arm64:~$ ./readdir 
-bash: ./readdir: cannot execute binary file: Exec format error

With 32_ELO but w/o your patchset: kernel just hangs (on 4.2 it
printed errors, but it was other machine);

With 32_EL0 and with your patchset:
ubuntu@arm64:~$ ./readdir 
-bash: ./readdir: cannot execute binary file: Exec format error

So, everything is looking OK. 

Tested-by: Yury Norov <ynorov@caviumnetworks.com>

Yury.
