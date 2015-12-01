From: Pavel Fedin <p.fedin@samsung.com>
Subject: BUG ALERT: ARM32 KVM does not work in 4.4-rc3
Date: Tue, 01 Dec 2015 10:24:38 +0300
Message-ID: <00fe01d12c09$576ca200$0645e600$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E03A5498C7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 02:23:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3mIHe-Zg9j0W for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2015 02:23:20 -0500 (EST)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1408C49794
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 02:23:19 -0500 (EST)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYO009VP4L4ME00@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 01 Dec 2015 07:24:40 +0000 (GMT)
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

 My project involves ARM64, but from time to time i also test ARM32 KVM. I have discovered that it stopped working in 4.4-rc3. The
same virtual machine works perfectly under current kvmarm/next, but gets stuck at random point under 4.4-rc3 from linux-stable.
 I'm not sure that i have time to investigate this quickly, but i'll post some new information as soon as i get it

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
