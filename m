From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: arm64 kvm built with clang doesn't boot
Date: Fri, 16 Mar 2018 14:31:19 +0000
Message-ID: <20180316143119.cdjw4dhm6crcjyrd@lakrids.cambridge.arm.com>
References: <CAAeHK+xjnXnrG0p06r-QRcUucYi5vcTJOn3mSS-JVxX9_TYg4w@mail.gmail.com>
 <20180316141313.q5vjmj627rv7r7kf@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180316141313.q5vjmj627rv7r7kf@lakrids.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Stephen Hines <srhines@google.com>, Greg Hackmann <ghackmann@google.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, kernel-dynamic-tools <kernel-dynamic-tools@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 16, 2018 at 02:13:14PM +0000, Mark Rutland wrote:
> On Fri, Mar 16, 2018 at 02:49:00PM +0100, Andrey Konovalov wrote:
> > Hi!
> 
> Hi,
>  
> > I've recently tried to boot clang built kernel on real hardware
> > (Odroid C2 board) instead of using a VM. The issue that I stumbled
> > upon is that arm64 kvm built with clang doesn't boot.
> > 
> > Adding -fno-jump-tables compiler flag to arch/arm64/kvm/* helps. There
> > was a patch some time ago that did exactly that
> > (https://patchwork.kernel.org/patch/10060381/), but it wasn't accepted
> > AFAICT (see the discussion on that thread).
> > 
> > What would be the best way to get this fixed?
> 
> I think that patch is our best bet currently, but to save ourselves pain
> in future it would be *really* nice if GCC and clang could provide an
> option line -fno-absolute-addressing that would implicitly disable any
> feature that would generate an absolute address as jump tables do.
> 
> > I've also had to disable CONFIG_JUMP_LABEL to get the kernel boot
> > (even without kvm enabled), but that might be a different (though
> > related) issue.
> 
> With v4.15 (and clang 5.0.0), I did not have to disable jump labels to
> get a kernel booting on a Juno platform, though I did have to pass
> -fno-jump-tables to the hyp code.

FWIW, with that same compiler and patch applied atop of v4.16-rc4, and
some bodges around clang not liking the rX register naming in the SMCCC
code, I get a kernel that boots on my Juno, though I immediately hit a
KASAN splat:

[    8.476766] ==================================================================
[    8.483990] BUG: KASAN: slab-out-of-bounds in __d_lookup_rcu+0x350/0x400
[    8.490664] Read of size 8 at addr ffff8009336e2a30 by task init/1
[    8.496808] 
[    8.498313] CPU: 2 PID: 1 Comm: init Not tainted 4.16.0-rc4-00001-g1e3a801c4e30-dirty #1
[    8.506361] Hardware name: ARM Juno development board (r1) (DT)
[    8.512248] Call trace:
[    8.514699]  dump_backtrace+0x0/0x29c
[    8.518356]  show_stack+0x20/0x2c
[    8.521667]  dump_stack+0x118/0x15c
[    8.525151]  print_address_description+0x80/0x2d0
[    8.529839]  kasan_report+0x208/0x278
[    8.533492]  __asan_load8+0x1b0/0x1b8
[    8.537148]  __d_lookup_rcu+0x350/0x400
[    8.540974]  lookup_fast+0x19c/0x780
[    8.544541]  walk_component+0x108/0x121c
[    8.548452]  path_lookupat+0x1a4/0x620
[    8.552197]  filename_lookup+0x1d8/0x440
[    8.556113]  user_path_at_empty+0x54/0x68
[    8.560112]  vfs_statx+0x108/0x1f0
[    8.563507]  SyS_newfstatat+0x118/0x19c
[    8.567333]  el0_svc_naked+0x30/0x34
[    8.570889] 
[    8.572380] Allocated by task 1:
[    8.575603]  kasan_kmalloc+0xe0/0x1ac
[    8.579259]  __kmalloc+0x1e4/0x278
[    8.582656]  __d_alloc+0x8c/0x370
[    8.585968]  d_alloc_parallel+0xdc/0xca0
[    8.589883]  nfs_readdir_xdr_to_array+0xe44/0x1694
[    8.594658]  nfs_readdir_filler+0x44/0xe8
[    8.598662]  do_read_cache_page+0x450/0x6f4
[    8.602836]  read_cache_page+0x44/0x54
[    8.606575]  nfs_readdir+0xd58/0xef4
[    8.610143]  iterate_dir+0x15c/0x26c
[    8.613711]  SyS_getdents64+0x180/0x30c
[    8.617538]  el0_svc_naked+0x30/0x34
[    8.621093] 
[    8.622584] Freed by task 0:
[    8.625451] (stack is not available)
[    8.629007] 
[    8.630505] The buggy address belongs to the object at ffff8009336e2a00
[    8.630505]  which belongs to the cache kmalloc-128 of size 128
[    8.642969] The buggy address is located 48 bytes inside of
[    8.642969]  128-byte region [ffff8009336e2a00, ffff8009336e2a80)
[    8.654558] The buggy address belongs to the page:
[    8.659335] page:ffff7e0024cdb880 count:1 mapcount:0 mapping:0000000000000000 index:0x0
[    8.667304] flags: 0x1fffc00000000100(slab)
[    8.671487] raw: 1fffc00000000100 0000000000000000 0000000000000000 0000000100100010
[    8.679206] raw: dead000000000100 dead000000000200 ffff800937403c00 0000000000000000
[    8.686907] page dumped because: kasan: bad access detected
[    8.692447] 
[    8.693935] Memory state around the buggy address:
[    8.698710]  ffff8009336e2900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    8.705902]  ffff8009336e2980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    8.713093] >ffff8009336e2a00: 00 00 00 00 00 00 06 fc fc fc fc fc fc fc fc fc
[    8.720277]                                      ^
[    8.725051]  ffff8009336e2a80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    8.732242]  ffff8009336e2b00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    8.739426] ==================================================================

Thanks,
Mark.
