From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH V5 00/10] x86/KVM/Hyper-v: Add HV ept tlb range flush
 hypercall support in KVM
Date: Tue, 27 Nov 2018 15:11:29 +0300
Message-ID: <20181127121129.GR3088@unbuntlaptop>
References: <20181108144259.10817-1-Tianyu.Lan@microsoft.com>
 <CAOLK0pyvtfhoGM+D7h=gXwNpNjXGZiDJKpuVi9HOwb++4asCXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CB8B4A32F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Nov 2018 07:12:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c4uPIO7PRK8T for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Nov 2018 07:12:30 -0500 (EST)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31B274A324
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Nov 2018 07:12:30 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <CAOLK0pyvtfhoGM+D7h=gXwNpNjXGZiDJKpuVi9HOwb++4asCXw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Tianyu Lan <lantianyu1986@gmail.com>
Cc: linux-mips@linux-mips.org, kvm <kvm@vger.kernel.org>, benh@kernel.crashing.org, will.deacon@arm.com, "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>, paulus@ozlabs.org, "H. Peter Anvin" <hpa@zytor.com>, kvmarm@lists.cs.columbia.edu, sthemmin@microsoft.com, mpe@ellerman.id.au, the arch/x86 maintainers <x86@kernel.org>, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, Ingo Molnar <mingo@redhat.com>, catalin.marinas@arm.com, jhogan@kernel.org, Tianyu Lan <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, haiyangz@microsoft.com, kvm-ppc@vger.kernel.org, bp@alien8.de, devel@linuxdriverproject.org, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, ralf@linux-mips.org, paul.burton@mips.com, Paolo Bonzini <pbonzini@redhat.com>, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 27, 2018 at 07:59:22PM +0800, Tianyu Lan wrote:
> Gentile Ping...
> 
> On Thu, Nov 8, 2018 at 10:43 PM <lantianyu1986@gmail.com> wrote:
> >
> > From: Lan Tianyu <Tianyu.Lan@microsoft.com>
> >
> > Sorry. Some patches was blocked and I try to resend via another account.

The patches were still blocked?  They didn't show up on driver-devel.

regards,
dan carpenter
