From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: 32-bit fp/simd race - never mind :)
Date: Wed, 17 Jun 2015 20:24:02 -0700
Message-ID: <558239D2.5030107@samsung.com>
References: <55823354.1040207@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36BE755F1C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 23:13:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gbd3Km6Ta5sq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jun 2015 23:13:29 -0400 (EDT)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2634B55F1B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 23:13:28 -0400 (EDT)
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQ400LVLES8V130@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 17 Jun 2015 23:24:08 -0400 (EDT)
In-reply-to: <55823354.1040207@samsung.com>
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

I have been looking at it for too long, my concepts
got twisted.

On 06/17/2015 07:56 PM, Mario Smarduch wrote:
> Maybe I've been looking at this code too long, but it
> appears that on __kvm_vcpu_return we save/restore
> fp/simd registers and then change to hyp role. In
> between if we get an interrupt vCPU may be migrated
> to another CPU? Or am I missing something?
> 
> Thanks,
> - Mario
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
