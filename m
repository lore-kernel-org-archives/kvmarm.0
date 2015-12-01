From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: BUG ALERT: ARM32 KVM does not work in 4.4-rc3
Date: Tue, 01 Dec 2015 09:25:18 +0000
Message-ID: <565D677E.8000505@arm.com>
References: <00fe01d12c09$576ca200$0645e600$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <00fe01d12c09$576ca200$0645e600$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 01/12/15 07:24, Pavel Fedin wrote:
> Hello!
> 
> My project involves ARM64, but from time to time i also test ARM32
> KVM. I have discovered that it stopped working in 4.4-rc3. The same
> virtual machine works perfectly under current kvmarm/next, but gets
> stuck at random point under 4.4-rc3 from linux-stable. I'm not sure
> that i have time to investigate this quickly, but i'll post some new
> information as soon as i get it

root@canarsie:~# uname -a
Linux canarsie 4.4.0-rc3 #5044 SMP PREEMPT Tue Dec 1 09:12:40 GMT 2015 armv7l GNU/Linux
root@canarsie:~# cat /proc/cpuinfo 
processor	: 0
model name	: ARMv7 Processor rev 4 (v7l)
BogoMIPS	: 48.00
Features	: half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm 
CPU implementer	: 0x41
CPU architecture: 7
CPU variant	: 0x0
CPU part	: 0xc07
CPU revision	: 4

processor	: 1
model name	: ARMv7 Processor rev 4 (v7l)
BogoMIPS	: 48.00
Features	: half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm 
CPU implementer	: 0x41
CPU architecture: 7
CPU variant	: 0x0
CPU part	: 0xc07
CPU revision	: 4

Hardware	: Generic DT based system
Revision	: 0000
Serial		: 0000000000000000

The same kernel is used both as a guest and a host with v4.4-rc3.

So until you bisect it to an exact commit and configuration, I declare
the alert over. ;-)

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
