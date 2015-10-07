From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Virt MM DEBUG_LL support arm32
Date: Tue, 06 Oct 2015 17:32:58 -0700
Message-ID: <5614683A.1010007@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11A9F41AF6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Oct 2015 20:31:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MexHGOlQjMH6 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Oct 2015 20:31:05 -0400 (EDT)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 638C2412D0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Oct 2015 20:31:04 -0400 (EDT)
Received: from uscpsbgex2.samsung.com
 (u123.gpu85.samsung.co.kr [203.254.195.123]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NVT00CFPQUZRA20@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 06 Oct 2015 20:32:59 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: peter.maydell@linaro.com
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Peter,
   I noticed that icedcc, and 8250 don't work
with DEBUG_LL early debug print. And the kernel dies if
these are selected. Besides PL011 is there any other
serial devices that can be used for early debug with Virt MM?
Maybe some additional options are needed?

Thanks,
- Mario
