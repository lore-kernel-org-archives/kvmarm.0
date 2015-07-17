From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 00/12] kvmtool: Improve portability
Date: Fri, 17 Jul 2015 17:02:06 +0100
Message-ID: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: Szabolcs.Nagy@arm.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

this is a collection of patches to bring kvmtool closer to standards
compliance (with standards not necessarily meaning GNU only).
With all those patches applied, you can compile kvmtool with newer
C standards, with clang and against musl-libc.

The first patch was already on the list, it allows compiling with
-std=gnu99 (or gnu11, even). As this will become the new GCC default 
at some point, that sounds useful.

Patch 2-7 fix compilation with clang: some are real bugs, some are
just things that clang is pickier about. Please note that the BIOS
code for x86 still does not compile with clang. I have the gut
feeling that rewriting this is assembly would be cleaner than all
those hacks we do to make this possible in C, but I will look at this
later.

The next four patches fix compilation against musl-libc. No real bugs
here, but again improves code quality. Compiling against musl-libc
gives you really small binaries (174K for ARM, for instance).

The last patch just follows a comment in the code to remove a kludge.

Cheers,
Andre.

Andre Przywara (12):
  avoid casts when initializing structures
  qcow: fix signedness bugs
  kvm-ipc: use proper type for file descriptor
  Makefile: remove unneeded -s switch on compiling BIOS files
  ui: remove pointless double const in keymap declarations
  kvm__set_dir(): avoid variable arguments call
  util/util.c: avoid clang error on vsnprintf
  Fix call to connect()
  use <poll.h> instead of <sys/poll.h>
  check for and use C library provided strlcpy and strlcat
  avoid using predefined PAGE_SIZE
  remove KVM_CAP_MAX_VCPUS hack

 Makefile                 | 15 ++++++++++-----
 config/feature-tests.mak | 10 ++++++++++
 disk/core.c              |  2 +-
 disk/qcow.c              | 14 +++++++-------
 include/kvm/kvm.h        |  6 +++++-
 include/kvm/mutex.h      |  2 +-
 include/kvm/strbuf.h     |  2 ++
 include/linux/rbtree.h   |  2 +-
 kvm-ipc.c                |  4 ++--
 kvm.c                    | 29 ++++++-----------------------
 main.c                   |  9 ++++++++-
 ui/gtk3.c                |  2 +-
 ui/sdl.c                 |  2 +-
 util/strbuf.c            |  2 ++
 util/util.c              |  1 +
 virtio/9p.c              |  2 +-
 virtio/balloon.c         |  2 +-
 virtio/blk.c             |  2 +-
 virtio/console.c         |  2 +-
 virtio/net.c             |  2 +-
 virtio/rng.c             |  2 +-
 virtio/scsi.c            |  2 +-
 22 files changed, 65 insertions(+), 51 deletions(-)

-- 
2.3.5

