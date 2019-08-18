Return-Path: <SRS0=LHWX=WO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B60F1C3A589
	for <kvmarm@archiver.kernel.org>; Sun, 18 Aug 2019 17:53:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4336F20B7C
	for <kvmarm@archiver.kernel.org>; Sun, 18 Aug 2019 17:53:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4336F20B7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B9ED4A5B6;
	Sun, 18 Aug 2019 13:53:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2Z59MCejw6Or; Sun, 18 Aug 2019 13:53:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 772724A571;
	Sun, 18 Aug 2019 13:53:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 635004A56C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Aug 2019 13:53:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x5UeVV8UDneW for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Aug 2019 13:53:40 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D7234A567
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Aug 2019 13:53:40 -0400 (EDT)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why)
 by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
 (Exim 4.80) (envelope-from <maz@kernel.org>)
 id 1hzPMv-0007XI-97; Sun, 18 Aug 2019 19:53:29 +0200
Date: Sun, 18 Aug 2019 18:53:26 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] KVM: Call kvm_arch_vcpu_blocking early into the
 blocking sequence
Message-ID: <20190818185326.63f3ea9d@why>
In-Reply-To: <a7250b9a-60e9-b04c-5515-e506aea46515@redhat.com>
References: <20190802103709.70148-1-maz@kernel.org>
 <20190802103709.70148-3-maz@kernel.org>
 <a7250b9a-60e9-b04c-5515-e506aea46515@redhat.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, james.morse@arm.com,
 joro@8bytes.org, Suravee.Suthikulpanit@amd.com, tangnianyao@huawei.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, 2 Aug 2019 12:46:33 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 02/08/19 12:37, Marc Zyngier wrote:
> > When a vpcu is about to block by calling kvm_vcpu_block, we call
> > back into the arch code to allow any form of synchronization that
> > may be required at this point (SVN stops the AVIC, ARM synchronises
> > the VMCR and enables GICv4 doorbells). But this synchronization
> > comes in quite late, as we've potentially waited for halt_poll_ns
> > to expire.
> > 
> > Instead, let's move kvm_arch_vcpu_blocking() to the beginning of
> > kvm_vcpu_block(), which on ARM has several benefits:
> > 
> > - VMCR gets synchronised early, meaning that any interrupt delivered
> >   during the polling window will be evaluated with the correct guest
> >   PMR
> > - GICv4 doorbells are enabled, which means that any guest interrupt
> >   directly injected during that window will be immediately recognised
> > 
> > Tang Nianyao ran some tests on a GICv4 machine to evaluate such
> > change, and reported up to a 10% improvement for netperf:
> > 
> > <quote>
> > 	netperf result:
> > 	D06 as server, intel 8180 server as client
> > 	with change:
> > 	package 512 bytes - 5500 Mbits/s
> > 	package 64 bytes - 760 Mbits/s
> > 	without change:
> > 	package 512 bytes - 5000 Mbits/s
> > 	package 64 bytes - 710 Mbits/s
> > </quote>
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  virt/kvm/kvm_main.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 887f3b0c2b60..90d429c703cb 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2322,6 +2322,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> >  	bool waited = false;
> >  	u64 block_ns;
> >  
> > +	kvm_arch_vcpu_blocking(vcpu);
> > +
> >  	start = cur = ktime_get();
> >  	if (vcpu->halt_poll_ns && !kvm_arch_no_poll(vcpu)) {
> >  		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
> > @@ -2342,8 +2344,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> >  		} while (single_task_running() && ktime_before(cur, stop));
> >  	}
> >  
> > -	kvm_arch_vcpu_blocking(vcpu);
> > -
> >  	for (;;) {
> >  		prepare_to_swait_exclusive(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
> >  
> > @@ -2356,9 +2356,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> >  
> >  	finish_swait(&vcpu->wq, &wait);
> >  	cur = ktime_get();
> > -
> > -	kvm_arch_vcpu_unblocking(vcpu);
> >  out:
> > +	kvm_arch_vcpu_unblocking(vcpu);
> >  	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
> >  
> >  	if (!vcpu_valid_wakeup(vcpu))
> >   
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks for that. I've pushed this patch into -next so that it gets a
bit of exposure (I haven't heard from the AMD folks, and I'd like to
make sure it doesn't regress their platforms).

	M.
-- 
Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
