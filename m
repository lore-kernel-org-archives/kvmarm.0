From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: kvm/arm64: use-after-free in
 kvm_unmap_hva_handler/unmap_stage2_pmds
Date: Thu, 13 Apr 2017 13:53:13 +0200
Message-ID: <CAAeHK+wJ4Xm+g22V_3fUqfMfP4V7m36FHYzVOFuxH8WbiFcenA@mail.gmail.com>
References: <CAAeHK+yjKm3mO2h9M30t-V_PnMhXEM887_zESCSg6gkbzivPsQ@mail.gmail.com>
 <20f6c994-d83e-7a6f-9f13-f10287211a6c@arm.com>
 <9f473bb9-d0eb-6803-1263-75ffef0301fe@redhat.com>
 <CAAeHK+x8udHKq9xa1zkTO6ax5E8Dk32HYWfaT05FMchL2cr48g@mail.gmail.com>
 <1050c9d8-5813-5df9-29e5-3ab6e61b5de6@arm.com>
 <CAAeHK+yzzdQVvGQcuprTHEa7S9CPiAVYodD__jQ8a=CzA6RaZg@mail.gmail.com>
 <20170413093418.GC24027@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FF2340B5E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Apr 2017 07:50:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DpFGeM72Fw-F for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Apr 2017 07:50:47 -0400 (EDT)
Received: from mail-pg0-f46.google.com (mail-pg0-f46.google.com [74.125.83.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1491408EB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Apr 2017 07:50:46 -0400 (EDT)
Received: by mail-pg0-f46.google.com with SMTP id x125so29612180pgb.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Apr 2017 04:53:15 -0700 (PDT)
In-Reply-To: <20170413093418.GC24027@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>, Kostya Serebryany <kcc@google.com>, syzkaller <syzkaller@googlegroups.com>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 13, 2017 at 11:34 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Wed, Apr 12, 2017 at 08:51:31PM +0200, Andrey Konovalov wrote:
>> On Wed, Apr 12, 2017 at 8:43 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> > On 12/04/17 17:19, Andrey Konovalov wrote:
>
>> >> I now have a way to reproduce it, so I can test proposed patches. I
>> >> don't have a simple C reproducer though.
>> >>
>> >> The bug happens when the following syzkaller program is executed:
>> >>
>> >> mmap(&(0x7f0000000000/0xc000)=nil, (0xc000), 0x3, 0x32, 0xffffffffffffffff, 0x0)
>> >> unshare(0x400)
>> >> perf_event_open(&(0x7f000002f000-0x78)={0x1, 0x78, 0x0, 0x0, 0x0, 0x0,
>> >> 0x0, 0x6, 0x0, 0x0, 0xd34, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
>> >> 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x0, 0xffffffff,
>> >> 0xffffffffffffffff, 0x0)
>> >> r0 = openat$kvm(0xffffffffffffff9c,
>> >> &(0x7f000000c000-0x9)="2f6465762f6b766d00", 0x0, 0x0)
>> >> ioctl$TIOCSBRK(0xffffffffffffffff, 0x5427)
>> >> r1 = ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
>> >> syz_kvm_setup_cpu$arm64(r1, 0xffffffffffffffff,
>> >> &(0x7f0000dc6000/0x18000)=nil, &(0x7f000000c000)=[{0x0,
>> >> &(0x7f000000c000)="5ba3c16f533efbed09f8221253c73763327fadce2371813b45dd7f7982f84a873e4ae89a6c2bd1af83a6024c36a1ff518318",
>> >> 0x32}], 0x1, 0x0, &(0x7f000000d000-0x10)=[@featur2={0x1, 0x3}], 0x1)
>> >
>> > Is that the only thing the program does? Or is there anything running in
>> > parallel?
>>
>> These calls are executed repeatedly and in random order. That's all.
>>
>> Except that I'm running the reproducer on a real arm board, so there's
>> probably a bunch of stuff going on besides these calls.
>
> I had a go at reproducing this on an arm64 board following [1], but so
> far I've had no luck. I've dumped the above into syz-kvm-bug, and I'm
> trying to reproduce the issue with:
>
>         PATH=$PATH:$(pwd)/bin syz-execprog \
>                 -executor $(pwd)/bin/syz-executor \
>                 -cover=0 -repeat=0 -procs 16 \
>                 syz-kvm-bug
>
> Just to check, is that the correct way to reproduce the problem with the
> above log?

Hi Mark,

You assume that you have KASAN enabled.

Since a few unintended line breaks were added in the email, here's the
program in plaintext:
https://gist.githubusercontent.com/xairy/69864355b5a64f74e7cb445b7325a7df/raw/bdbbbf177dbea13eac0a5ddfa9c3e6c32695b13b/kvm-arm-uaf-log

I run it as:
# ./syz-execprog -repeat=0 -collide=false -sandbox=namespace ./kvm-arm-uaf-log

And it takes less than a second to trigger the bug.

Thanks!

>
> How quickly does that reproduce the problem for you?
>
> Thanks,
> Mark.
>
> [1] https://github.com/google/syzkaller/wiki/How-to-execute-syzkaller-programs
