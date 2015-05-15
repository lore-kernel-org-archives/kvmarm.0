From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC] ARM/ARM64: KVM: Implement KVM_FLUSH_DCACHE_GPA ioctl
Date: Fri, 15 May 2015 17:24:55 +0200
Message-ID: <55560FC7.30108@redhat.com>
References: <1430817191-6231-1-git-send-email-j.fanguede@virtualopensystems.com>
 <20150506141249.GA6796@cbox>
 <CAGE1QJrabWWs0O1V-MpOxT_=1472TXb5rvJzJAJNfWH70x9pcg@mail.gmail.com>
 <20150507112027.GC25885@cbox>
 <CAGE1QJoyaGpuf=6Msa=xpm0pPGRkYWctcXGf=rwnha5o9Gm4bw@mail.gmail.com>
 <CAMJs5B9i9q8gJU93B09-uLMF6w1bTft-40DWPFUP6ky=SketSQ@mail.gmail.com>
 <CAGE1QJoEAg9tAM63MEbpLuqvY_ZwGrHPU1sqo=L_iByKrERUow@mail.gmail.com>
 <554B9A70.6020309@redhat.com> <5555DBFD.4080503@redhat.com>
 <20150515151235.GD14144@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <20150515151235.GD14144@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Laszlo Ersek <lersek@redhat.com>
Cc: list@lists.cs.columbia.edu, Overall <kvm@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, open@lists.cs.columbia.edu, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 15/05/2015 17:12, Christoffer Dall wrote:
>>> > > Can you find out what memory attributes the guest is using for the
>>> > > memory---and if it's uncached, why?
>> > 
>> > For USB, see "drivers/usb/core/hcd-pci.c", function usb_hcd_pci_probe():
>> > it uses ioremap_nocache().
>> > 
>> > On the "why", that ioremap_nocache() call can be tracked to
>> > 
>> > http://git.kernel.org/cgit/linux/kernel/git/tglx/history.git/commit/?id=a914dd8b
>> > 
>> > (Feb 2002), which predates the kernel's move to git. I guess
>> > ioremap_nocache() is used simply because USB host controllers are
>> > supposed to programmed like that.
>> > 
>> > And, from "arch/arm64/include/asm/io.h":
>> > 
>> > #define ioremap_nocache(addr, size)     __ioremap((addr), (size),
>> > __pgprot(PROT_DEVICE_nGnRE))
>> > 
> So this just means that these devices should be mapped as device memory
> (like the VGA case before) right?  And therefore should work with Drew's
> patches (assuming they are actually correct and you add the right QEMU
> annotations to set the memory regions and non-cacheable), correct?

As far as I understand ioremap_nocache() is used on a MMIO BAR.  QEMU
does not back those with RAM at all, each access causes a userspace exit.

Paolo
