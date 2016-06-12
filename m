From: ib10evp0@gmx.org
Subject: Status of live migration on ARMv7
Date: Sun, 12 Jun 2016 14:40:40 +0200
Message-ID: <trinity-d5cbcace-be15-4c67-b55c-1a70d1fb7c21-1465735240100@3capp-gmx-bs77>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08BEE49D55
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 Jun 2016 08:36:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WmqimM-fnZzY for <kvmarm@lists.cs.columbia.edu>;
 Sun, 12 Jun 2016 08:36:17 -0400 (EDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B121849CF7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 Jun 2016 08:36:16 -0400 (EDT)
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
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

I was wondering what the status of live migration for ARMv7 with Virtualization
Extensions is. I saw somebody was able to live migrate on ARM [1] but the 
repository he linked [2] has not been updated for 2 years. I'd like to know if
live migration support for ARM is already in the mainstream kernel or if there
are any custom patches required and if so if there is any newer code than [2].

BTW: The Migration page [3] claims the migration feature is hardware independent
but it remains unclear if this expands to CPU architectures and if this applies
to live migration or only offline migration. Some clarification in this regard
would be nice to have.

Regards


[1] https://sites.google.com/site/itriccmahypervisor/project/demo
[2] https://github.com/ITRI-CCMA-hypervisor/linux-kvm-arm/tree/live-migration-v8
[3] http://www.linux-kvm.org/page/Migration
