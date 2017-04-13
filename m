From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: kvm/arm64: use-after-free in
 kvm_unmap_hva_handler/unmap_stage2_pmds
Date: Thu, 13 Apr 2017 14:45:24 +0100
Message-ID: <20170413134524.GF24027@leverpostej>
References: <CAAeHK+yjKm3mO2h9M30t-V_PnMhXEM887_zESCSg6gkbzivPsQ@mail.gmail.com>
 <20f6c994-d83e-7a6f-9f13-f10287211a6c@arm.com>
 <9f473bb9-d0eb-6803-1263-75ffef0301fe@redhat.com>
 <CAAeHK+x8udHKq9xa1zkTO6ax5E8Dk32HYWfaT05FMchL2cr48g@mail.gmail.com>
 <1050c9d8-5813-5df9-29e5-3ab6e61b5de6@arm.com>
 <CAAeHK+yzzdQVvGQcuprTHEa7S9CPiAVYodD__jQ8a=CzA6RaZg@mail.gmail.com>
 <20170413093418.GC24027@leverpostej>
 <CAAeHK+wJ4Xm+g22V_3fUqfMfP4V7m36FHYzVOFuxH8WbiFcenA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1750E40A7F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Apr 2017 09:43:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m0jh+u48ekWr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Apr 2017 09:43:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A013F40966
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Apr 2017 09:43:21 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CAAeHK+wJ4Xm+g22V_3fUqfMfP4V7m36FHYzVOFuxH8WbiFcenA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrey Konovalov <andreyknvl@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>, Kostya Serebryany <kcc@google.com>, syzkaller <syzkaller@googlegroups.com>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 13, 2017 at 01:53:13PM +0200, Andrey Konovalov wrote:
> On Thu, Apr 13, 2017 at 11:34 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > I had a go at reproducing this on an arm64 board following [1], but so
> > far I've had no luck. 

[...]

> Hi Mark,
> 
> You assume that you have KASAN enabled.

Yes; I have KASAN_OUTLINE enabled.

> Since a few unintended line breaks were added in the email, here's the
> program in plaintext:
> https://gist.githubusercontent.com/xairy/69864355b5a64f74e7cb445b7325a7df/raw/bdbbbf177dbea13eac0a5ddfa9c3e6c32695b13b/kvm-arm-uaf-log

Thanks!

> I run it as:
> # ./syz-execprog -repeat=0 -collide=false -sandbox=namespace ./kvm-arm-uaf-log

Thanks again. Having the exact command was very helpful for
sanity-checking my configuration.

In the end, it turned out that in my filesystem, /dev/kvm was not
accessible by the nobody user, so the executor couldn't open it, and
none of the KVM paths were being triggered.

> And it takes less than a second to trigger the bug.

After having chomd'd /dev/kvm appropriately, I can also reproduce the
issue within a second or two, running the same command.

Thanks,
Mark.
