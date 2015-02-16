From: Jan Kiszka <jan.kiszka@web.de>
Subject: vexpress: Framebuffer broken with KVM enabled
Date: Mon, 16 Feb 2015 10:13:30 +0100
Message-ID: <54E1B4BA.3030705@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A03B45C17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Feb 2015 04:08:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wsUDU+wR7fTP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Feb 2015 04:08:17 -0500 (EST)
Received: from mout.web.de (mout.web.de [212.227.15.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D513445B19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Feb 2015 04:08:16 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel <qemu-devel@nongnu.org>
Cc: kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

next issue related to KVM/QEMU on the TK1: The guest image I'm running
gives proper framebuffer output when in emulation mode. Once KVM is
enabled, the screen is - at best - only initially updated. Sometimes I
see the famous tux images and a bit of the console texts, but usually it
stays black. Explanations?

Jan
