From: Edward Cragg <edward.cragg@codethink.co.uk>
Subject: PCIe passthrough support on ARM
Date: Thu, 4 Feb 2016 16:53:56 +0000
Message-ID: <20160204165355.GA10442@codethink.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10C3648532
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 11:48:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5rmOSIyzCPSu for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2016 11:48:30 -0500 (EST)
Received: from ducie-dc1.codethink.co.uk (ducie-dc1.codethink.co.uk
 [185.25.241.215])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D83D148531
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 11:48:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by ducie-dc1.codethink.co.uk (Postfix) with ESMTP id ABA1C46174E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 16:53:58 +0000 (GMT)
Received: from ducie-dc1.codethink.co.uk ([127.0.0.1])
 by localhost (ducie-dc1.codethink.co.uk [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fIsj78Bia49Z for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2016 16:53:57 +0000 (GMT)
Received: from pomo (unknown [10.24.2.122])
 by ducie-dc1.codethink.co.uk (Postfix) with ESMTPSA id D89B1460855
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 16:53:56 +0000 (GMT)
Received: from ed by pomo with local (Exim 4.86)
 (envelope-from <edward.cragg@codethink.co.uk>) id 1aRNAK-0004e8-8F
 for kvmarm@lists.cs.columbia.edu; Thu, 04 Feb 2016 16:53:56 +0000
Content-Disposition: inline
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

I'm involved in planning a project for which there is a requirement for PCIe
passthrough in KVM on ARMv8. We have no hardware to test on at the moment.

I understand that virtualisation support for ARM is quite young, and it seems
like support is trickling in at the moment for this sort of thing.

Is anyone working on PCIe passthrough on ARM platforms who might be able to
share some insight into what would be required to support this?

Thanks,

Ed
