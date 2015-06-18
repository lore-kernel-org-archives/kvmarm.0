From: Mario Smarduch <m.smarduch@samsung.com>
Subject: 32-bit fp/simd race
Date: Wed, 17 Jun 2015 19:56:20 -0700
Message-ID: <55823354.1040207@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9039F55F0D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 22:45:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2tpqqYmKosZY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jun 2015 22:45:47 -0400 (EDT)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE96855EE0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 22:45:47 -0400 (EDT)
Received: from uscpsbgex1.samsung.com
 (u122.gpu85.samsung.co.kr [203.254.195.122]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQ400LPKDI2PY30@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 17 Jun 2015 22:56:26 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Maybe I've been looking at this code too long, but it
appears that on __kvm_vcpu_return we save/restore
fp/simd registers and then change to hyp role. In
between if we get an interrupt vCPU may be migrated
to another CPU? Or am I missing something?

Thanks,
- Mario
