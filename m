From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 0/2] Fix kvm__pause races
Date: Fri, 19 Oct 2018 10:36:29 +0100
Message-ID: <1539941791-40118-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 310114A1DF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 05:36:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o2D-eSDfSbKs for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Oct 2018 05:36:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27CDC4A1D1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 05:36:46 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: will.deacon@arm.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

Here are some fixes for potential races I found in the pause/resume
code.

Cheers,

Julien

-->

Julien Thierry (2):
  kvm: Do not pause already paused vcpus
  kvm-cpu: Pause vCPU in signal handler

 kvm-cpu.c | 17 ++++++++++++-----
 kvm.c     |  5 ++++-
 2 files changed, 16 insertions(+), 6 deletions(-)

--
1.9.1
