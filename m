From: Robert Richter <rric@kernel.org>
Subject: Re: v4.9-rc1 fails booting as a guest on ARM64 Cavium ThunderX
Date: Thu, 3 Nov 2016 19:01:27 +0100
Message-ID: <20161103180127.GX25086@rric.localdomain>
References: <924fd627-329a-54e0-694c-a9bdf979f696@redhat.com>
 <de2acaca-f694-be1a-5d2c-93fcf3b25011@arm.com>
 <99c7d3b5-0495-083f-b4b7-b58b20cf859e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <99c7d3b5-0495-083f-b4b7-b58b20cf859e@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Andrew Jones <drjones@redhat.com>, daniel.thompson@linaro.org, Robert Richter <robert.richter@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

Eric,

On 21.10.16 11:05:01, Auger Eric wrote:
> On 21/10/2016 10:45, Marc Zyngier wrote:

> > What is the failure syndrome? Do you see it crashing? Locking up? What
> > is the PC at that stage?
> No guest crash. the guest just locks up. No traces output.

I am trying to reproduce this but could boot a 4.9-rc3 kernel as
guest. Are there any special settings? Here my command line:

 qemu-system-aarch64 -name qemu.test -enable-kvm -smp 8 -m 16G -cpu host -nographic -kernel /boot/vmlinuz-4.9.0-rc3.0.vanilla10-00002-gcfd8c2cee6ac -initrd /boot/initrd.img-4.9.0-rc3.0.vanilla10-00002-gcfd8c2cee6ac -M virt,gic_version=3 -hdb /dev/sdb -append "root=/dev/vda3"

Thanks,

-Robert
