From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: v4.9-rc1 fails booting as a guest on ARM64 Cavium ThunderX
Date: Fri, 21 Oct 2016 14:20:33 +0100
Message-ID: <20161021142033.041ad0e2@arm.com>
References: <924fd627-329a-54e0-694c-a9bdf979f696@redhat.com>
 <de2acaca-f694-be1a-5d2c-93fcf3b25011@arm.com>
 <99c7d3b5-0495-083f-b4b7-b58b20cf859e@redhat.com>
 <5a5e4ed5-a575-f720-36f0-acb545a170f4@arm.com>
 <e52f2867-102f-8aad-4815-2a682586f129@redhat.com>
 <20161021114951.gm3u6msvl4jz2kv7@kamzik.brq.redhat.com>
 <CAFEAcA-K+Fnw7Fwh3tK0nqLxhUrtLB7XrJVtswXwTb7d2X+Y+Q@mail.gmail.com>
 <20161021120732.bl5p5vji25zibap3@kamzik.brq.redhat.com>
 <bf32d77e-93e1-c943-e6b6-953b3d8c9e20@arm.com>
 <CAFEAcA9R863ZpuPu7Lj_FmFJit2XqMH_WULao+z9q5Dms5g41Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 108CB49B3D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 09:10:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6r8i6lQgjy8P for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Oct 2016 09:10:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBC8D49B37
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 09:10:31 -0400 (EDT)
In-Reply-To: <CAFEAcA9R863ZpuPu7Lj_FmFJit2XqMH_WULao+z9q5Dms5g41Q@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Daniel Thompson <daniel.thompson@linaro.org>, Robert Richter <robert.richter@caviumnetworks.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 21 Oct 2016 13:58:47 +0100
Peter Maydell <peter.maydell@linaro.org> wrote:

> On 21 October 2016 at 13:52, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
> > index a808829..5c03171 100644
> > --- a/arch/arm/include/asm/arch_gicv3.h
> > +++ b/arch/arm/include/asm/arch_gicv3.h
> > @@ -222,6 +222,11 @@ static inline void gic_write_bpr1(u32 val)
> >         write_sysreg(val, ICC_BPR1);
> >  }
> >
> > +static inline u32 gic_write_bpr1(void)
> > +{
> > +       return read_sysreg(ICC_BPR1);  
> 
> 
> ...a write function that calls read_sysreg() and returns a value?

As you can tell, I haven't even compiled the 32bit version... :-/

	M.
-- 
Jazz is not dead. It just smells funny.
