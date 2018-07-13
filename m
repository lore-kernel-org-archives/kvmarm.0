From: Julien Thierry <julien.thierry@arm.com>
Subject: [kvmtool PATCH 0/2] Makefile: Optional dependencies fixes
Date: Fri, 13 Jul 2018 09:04:02 +0100
Message-ID: <1531469044-5718-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4631B4A109
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jul 2018 03:51:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8xIs4ayJQr7W for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Jul 2018 03:51:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EAFE4A0D1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jul 2018 03:51:26 -0400 (EDT)
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
Cc: andre.przywara@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

I found some minor issues with the detection of optional dependencies, so
here are some minor fixes.

Cheers,

Julien

-->

Julien Thierry (2):
  Makefile: fix skipped dependencies
  Makefile: Try dynamic linkage for bfd

 Makefile | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

--
1.9.1
