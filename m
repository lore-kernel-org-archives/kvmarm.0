From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH kvmtool 0/6] Various convenience fixes
Date: Fri, 25 Jan 2019 18:07:55 +0000
Message-ID: <20190125180801.209910-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2637A4A3AF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 13:08:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M2pgJWXaThNi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jan 2019 13:08:08 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E68174A3A2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 13:08:07 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

As I found myself using kvmtool more often in the last weeks, I got more
and more annoyed by some smaller "ticks" that kvmtool shows.

So this is an attempt to post various smaller fixes I gathered up over
the years, but never found worth enough to send out:

- drop unnecessarily detailed debug output
- add /chosen/stdout-path node in .dtb
- honour make -s switch
- remove pointless kvmtool version number
- improve meaningless PMU error message
- introduce autodetection of supported GIC type

Please have a look!

Cheers,
Andre.

Andre Przywara (6):
  arm: turn pr_info() into pr_debug() messages
  arm: fdt: add stdout-path to /chosen node
  Makefile: support -s switch
  Makefile: Remove echoing of kvmtools version file
  arm: pmu: Improve PMU error reporting
  arm: Auto-detect guest GIC type

 Makefile                     | 16 +++++++++++++++-
 arm/fdt.c                    |  3 ++-
 arm/gic.c                    | 25 +++++++++++++++++++++++++
 arm/include/arm-common/gic.h |  1 +
 arm/kvm.c                    | 16 ++++++++--------
 arm/pmu.c                    |  2 +-
 util/KVMTOOLS-VERSION-GEN    |  1 -
 virtio/mmio.c                |  3 ++-
 8 files changed, 54 insertions(+), 13 deletions(-)

-- 
2.17.1
