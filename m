From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 4/4] pre_init: add ARM implementations
Date: Wed, 2 Mar 2016 03:00:09 +0000
Message-ID: <20160302030009.GB7637@arm.com>
References: <1456327988-31568-1-git-send-email-andre.przywara@arm.com>
 <1456327988-31568-5-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1456327988-31568-5-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 24, 2016 at 03:33:08PM +0000, Andre Przywara wrote:
> The pre_init stub consists of two syscalls mouting the host's FS
> via 9pfs and then calling the actual init binary, which can now
> use normal dynamic linking.
> Based on the x86 code provide an ARM and ARM64 implementation of
> that. Beside removing the need for static linkage it reduces the
> size of the kvmtool binary by quite a lot (numbers for aarch64):
> 
> -rwxr-xr-x 1 root root     9952 Nov 16 14:37 guest/init
> -rwxr-xr-x 1 root root      512 Nov 16 14:37 guest/pre_init
> -rwxr-xr-x 2 root root  1284704 Nov 16 14:37 lkvm
> vs. the old version:
> -rwxr-xr-x 1 root root   776024 Nov 16 14:38 guest/init
> -rwxr-xr-x 2 root root  2050112 Nov 16 14:38 lkvm
> 
> Tested on Midway and Juno.

Hmm, I'm not super keen on switching behaviour like this on arm, where
it's not uncommon to build a static lkvm and transfer it to a remote
target and expect init to work.

Perhaps we could only do this when building a dynamic executable?

Will
