From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH V4 2/15] KVM/MMU: Add tlb flush with range helper function
Date: Sun, 14 Oct 2018 14:33:53 +0100
Message-ID: <20181014133352.GX30658@n2100.armlinux.org.uk>
References: <20181013145406.4911-1-Tianyu.Lan@microsoft.com>
 <20181013145406.4911-3-Tianyu.Lan@microsoft.com>
 <4D709C3A-A91C-4CA7-922A-E77618EF21B4@oracle.com>
 <alpine.DEB.2.21.1810141014350.1438@nanos.tec.linutronix.de>
 <20181014092734.GV30658@n2100.armlinux.org.uk>
 <20181014093541.GW30658@n2100.armlinux.org.uk>
 <CAOLK0pzHAc1ipDbd3Trg2W_Gb_DxdEKM2ML5Fk09u0-O8y6UAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOLK0pzHAc1ipDbd3Trg2W_Gb_DxdEKM2ML5Fk09u0-O8y6UAg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tianyu Lan <lantianyu1986@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-mips@linux-mips.org, kvm <kvm@vger.kernel.org>, Radim Krcmar <rkrcmar@redhat.com>, benh@kernel.crashing.org, will.deacon@arm.com, christoffer.dall@arm.com, paulus@ozlabs.org, "H. Peter Anvin" <hpa@zytor.com>, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, sthemmin@microsoft.com, mpe@ellerman.id.au, the arch/x86 maintainers <x86@kernel.org>, michael.h.kelley@microsoft.com, Ingo Molnar <mingo@redhat.com>, catalin.marinas@arm.com, jhogan@kernel.org, Tianyu Lan <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, haiyangz@microsoft.com, kvm-ppc@vger.kernel.org, liran.alon@oracle.com, Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>, ralf@linux-mips.
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Oct 14, 2018 at 09:21:23PM +0800, Tianyu Lan wrote:
> Sorry to confuse your. I get from CCers from get_maintainer.pl script.

Unfortunately you seem to have made a mistake.  My email address is
'linux@armlinux.org.uk' not 'linux@armlinux.org'.  There is no
'linux@armlinux.org' in MAINTAINERS, yet your emails appear to be
copied to this address.

Consequently, if it was your intention to copy me with the entire
series, that didn't happen.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
