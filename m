From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC kvm-unit-tests PATCH 0/8] Support for out-of-tree builds
Date: Thu,  6 Apr 2017 20:07:19 +0100
Message-ID: <20170406190727.5624-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: drjones@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

While I was working on MTTCG I did find it a pain to maintain 2 source
trees (one for 64bit and one for 32bit). After speaking to someone
about the changes they made to their tests to support out-of-tree
builds I thought it might be worth porting to kvm-unit-tests.

As it turns out there where a few more warts involved but essentially
most of the difficulty is handled by VPATH. The remaining changes deal
creating target build directories and handling things like scripts
(which are just symlinked to the repo).

So far I've tested x86, arm and aarch64 builds but I'll complete the
set once people are happy with the general approach.

Enjoy,



Alex Bennée (8):
  configure: make it run-able from outside source tree
  Makefile: ensure build-head works out-of-src-tree
  Makefile: set VPATH based on SRCDIR
  Makefiles: use explicit path for including sub-Makefiles
  Makefile: add explicit mkdir for .o targets
  Makefiles: handle linking of scripts into build-tree
  Makefiles: fix up the x86 build include and link paths
  Makefiles: fix up the arm build include and link paths

 Makefile                | 33 +++++++++++++++++++++++++++------
 arm/Makefile            |  2 +-
 arm/Makefile.arm        |  2 +-
 arm/Makefile.arm64      |  2 +-
 arm/Makefile.common     | 15 +++++++++------
 configure               | 24 +++++++++++++++++-------
 powerpc/Makefile        |  2 +-
 powerpc/Makefile.ppc64  |  2 +-
 scripts/asm-offsets.mak |  4 +++-
 x86/Makefile            |  2 +-
 x86/Makefile.common     | 14 +++++++++-----
 x86/Makefile.i386       |  2 +-
 x86/Makefile.x86_64     |  2 +-
 13 files changed, 73 insertions(+), 33 deletions(-)

-- 
2.11.0
