From: Tianyu Lan <lantianyu1986@gmail.com>
Subject: Re: [PATCH V2 3/10] KVM/MMU: Add last_level in the struct mmu_spte_page
Date: Fri, 22 Feb 2019 23:16:35 +0800
Message-ID: <CAOLK0pyGhbd43rVPZE7waaStUkGVYVgakG2VgqtME4PxNTOY0w@mail.gmail.com>
References: <20190202013825.51261-1-Tianyu.Lan@microsoft.com>
 <20190202013825.51261-4-Tianyu.Lan@microsoft.com> <572a6ce3-23f6-7b16-a070-4d4a81ee4335@redhat.com>
 <CAOLK0pzXnvk=FsfjH07jUyRJGpeiNG7-9vR9Vo0mLJtdPnt_7Q@mail.gmail.com> <d9043bc8-d006-bf64-2047-79a9b6f98183@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d9043bc8-d006-bf64-2047-79a9b6f98183@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Lan Tianyu <Tianyu.Lan@microsoft.com>, christoffer.dall@arm.com, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, jhogan@kernel.org, ralf@linux-mips.org, paul.burton@mips.com, paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au, Radim Krcmar <rkrcmar@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, bp@alien8.de, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm <kvm@vger.kernel.org>, michael.h.kelley@microsoft.com, kys@microsoft.com, Vi
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 15, 2019 at 11:23 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 15/02/19 16:05, Tianyu Lan wrote:
> > Yes, you are right. Thanks to point out and will fix. The last_level
> > flag is to avoid adding middle page node(e.g, PGD, PMD)
> > into flush list. The address range will be duplicated if adding both
> > leaf, node and middle node into flush list.
>
> Hmm, that's not easy to track.  One kvm_mmu_page could include both leaf
> and non-leaf page (for example a huge page for 0 to 2 MB and a page
> table for 2 MB to 4 MB).
>
> Is this really needed?  First, your benchmarks so far have been done
> with sp->last_level always set to true.  Second, you would only
> encounter this optimization in kvm_mmu_commit_zap_page when zapping a 1
> GB region (which then would be invalidated twice, at both the PMD and
> PGD level) or bigger.
>
> Paolo

Hi Paolo:
             Sorry for later response and I tried to figure out a bug
lead by defining wrong
max flush count. I just sent out V3. I still put the last_level flag
patch in the end of patchset.
Detail please see the change log. Just like you said this was an
optimization and wasn't 100%
required. If you still have some concerns, you can ignore it and other
patches in this patchset
should be good. Thanks.

-- 
Best regards
Tianyu Lan
