From: Tianyu Lan <lantianyu1986@gmail.com>
Subject: Re: [PATCH V3 00/10] X86/KVM/Hyper-V: Add HV ept tlb range list flush
 support in KVM
Date: Sat, 23 Feb 2019 22:37:53 +0800
Message-ID: <CAOLK0pzvtO6Aj0T7uKwOHdNcsnM_Fq_wPL1VUTwF347fYA5Vdw@mail.gmail.com>
References: <20190222150637.2337-1-Tianyu.Lan@microsoft.com>
 <75e9238a-f168-b90d-e1f1-89938e6df57a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <75e9238a-f168-b90d-e1f1-89938e6df57a@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm <kvm@vger.kernel.org>, Radim Krcmar <rkrcmar@redhat.com>, benh@kernel.crashing.org, will.deacon@arm.com, christoffer.dall@arm.com, paulus@ozlabs.org, "H. Peter Anvin" <hpa@zytor.com>, kvmarm@lists.cs.columbia.edu, Sasha Levin <sashal@kernel.org>, sthemmin@microsoft.com, mpe@ellerman.id.au, the arch/x86 maintainers <x86@kernel.org>, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, Ingo Molnar <mingo@redhat.com>, catalin.marinas@arm.com, jhogan@kernel.org, linux-mips@vger.kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, haiyangz@microsoft.com, kvm-ppc@vger.kernel.org, bp@alien8.de, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>, ralf@linux-mips.org, paul.burton@mips.com, devel@linuxdriverproject.org, Vitaly Kuznetsov <vkuznets@redhat.com>, linuxppc-d
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Feb 23, 2019 at 2:26 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 22/02/19 16:06, lantianyu1986@gmail.com wrote:
> > From: Lan Tianyu <Tianyu.Lan@microsoft.com>
> >
> > This patchset is to introduce hv ept tlb range list flush function
> > support in the KVM MMU component. Flushing ept tlbs of several address
> > range can be done via single hypercall and new list flush function is
> > used in the kvm_mmu_commit_zap_page() and FNAME(sync_page). This patchset
> > also adds more hv ept tlb range flush support in more KVM MMU function.
> >
> > This patchset is based on the fix patch "x86/Hyper-V: Fix definition HV_MAX_FLUSH_REP_COUNT".
> > (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1939455.html)
>
> Note that this won't make it in 5.1 unless Linus releases an -rc8.
> Otherwise, I'll get to it next week.
Hi Paolo:
      Sure. Thanks for your review.

-- 
Best regards
Tianyu Lan
