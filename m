From: hiwu <hiwu@derytech.com.tw>
Subject: KVM/ARM: trap every load /store instruction
Date: Fri, 10 Jul 2015 22:16:55 +0800
Message-ID: <559FD3D7.4030605@derytech.com.tw>
References: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
 <1434718396-13110-6-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA58558547
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 10:05:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WA0GBWQib71O for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2015 10:05:21 -0400 (EDT)
Received: from msr8.hinet.net (msr8.hinet.net [168.95.4.108])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D9CA5853B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 10:05:20 -0400 (EDT)
Received: from dns.derytech.com.tw (218-161-54-187.HINET-IP.hinet.net
 [218.161.54.187])
 by msr8.hinet.net (8.14.9/8.14.9) with ESMTP id t6AEGumG013389
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 22:16:57 +0800 (CST)
Received: from [127.0.0.1] (1-160-13-154.dynamic.hinet.net [1.160.13.154])
 (Authenticated sender: hiwu@derytech.com.tw)
 by dns.derytech.com.tw (Postfix) with ESMTPA id E5956A60038
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 22:14:45 +0800 (CST)
In-Reply-To: <1434718396-13110-6-git-send-email-marc.zyngier@arm.com>
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

Hi:

Is it possible to trap every  load /store instruction (ldr/str) on KVM/ARM ?

Thank you

-Jack
