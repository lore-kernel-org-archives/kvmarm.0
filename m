From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 3/3] KVM: arm64: Introduce default dummy save/restore
 functions
Date: Tue, 14 Jul 2015 16:02:39 +0300
Message-ID: <020d01d0be35$5d3bab00$17b30100$@samsung.com>
References: <cover.1436874248.git.p.fedin@samsung.com>
 <248fcfc798e243b618c5275eef8aa333253fd4da.1436874248.git.p.fedin@samsung.com>
 <55A5007A.4040802@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AC7D58776
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jul 2015 08:50:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KkbjPtvbnu2I for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Jul 2015 08:50:54 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37BFA58775
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jul 2015 08:50:53 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NRH00BGFAWG0C90@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 14 Jul 2015 14:02:40 +0100 (BST)
In-reply-to: <55A5007A.4040802@arm.com>
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
To: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> You may want to check commit 8a14849, which makes this whole patch
> irrelevant.

 Thank you very much for pointing out, i will recheck.
 My patches are based on linux-stable.git, should i base them on something else?

> Also, we do check whether or not the GIC is enabled for a given VM, and
> not touching the registers if they are not. What is wrong with that?

 Look at arch/arm64/kvm/hyp.S, __kvm_vcpu_run function. It unconditionally calls entries in
__vgic_sr_vectors table. If vGIC initialization did not complete, this table stays unset and
contains zeroes. That was the problem.
 Ok, this is 64-bit-specific, i can fix this up later. My patch set can be used without 0003, in
this case it will fix only ARM32 architecture. So if you would like to accept the rest, you can do
it.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
