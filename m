From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [PATCH 4/4] pre_init: add ARM implementations
Date: Wed, 2 Mar 2016 23:38:34 +0000
Message-ID: <56D7797A.5040008@arm.com>
References: <1456327988-31568-1-git-send-email-andre.przywara@arm.com>
 <1456327988-31568-5-git-send-email-andre.przywara@arm.com>
 <20160302030009.GB7637@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160302030009.GB7637@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 02/03/16 03:00, Will Deacon wrote:
> On Wed, Feb 24, 2016 at 03:33:08PM +0000, Andre Przywara wrote:
>> The pre_init stub consists of two syscalls mouting the host's FS
>> via 9pfs and then calling the actual init binary, which can now
>> use normal dynamic linking.
>> Based on the x86 code provide an ARM and ARM64 implementation of
>> that. Beside removing the need for static linkage it reduces the
>> size of the kvmtool binary by quite a lot (numbers for aarch64):
>>
>> -rwxr-xr-x 1 root root     9952 Nov 16 14:37 guest/init
>> -rwxr-xr-x 1 root root      512 Nov 16 14:37 guest/pre_init
>> -rwxr-xr-x 2 root root  1284704 Nov 16 14:37 lkvm
>> vs. the old version:
>> -rwxr-xr-x 1 root root   776024 Nov 16 14:38 guest/init
>> -rwxr-xr-x 2 root root  2050112 Nov 16 14:38 lkvm
>>
>> Tested on Midway and Juno.
> 
> Hmm, I'm not super keen on switching behaviour like this on arm, where
> it's not uncommon to build a static lkvm and transfer it to a remote
> target and expect init to work.

So are you concerned about a fully static root file system on the host,
which does not provide libc.so and/or ld-linux.so at all? Is that really
a use case? I had the impression that people use a statically linked
kvmtool to avoid dependencies like to libfdt.so.
In this case I am wondering if we should provide some switch to build a
static lkvm with a static init if people are concerned, or we should
ship a guest/init binary statically linked against musl libc, for
instance: this is only 29K compared to the above multi-100 KB gcc version.
Or is there some trick to build small static binaries linked against glibc?
Actually by just looking at init.c: Should we code the whole of it in
assembly? Apart from printf it only consists of syscalls.

> Perhaps we could only do this when building a dynamic executable?

This is of course an option as well.

Cheers,
Andre

