Return-Path: <SRS0=c4fT=6H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E56C2BA19
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 10:40:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B7B6020857
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 10:40:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NouqzbRN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7B6020857
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1D794B0F3;
	Thu, 23 Apr 2020 06:40:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4gOj7cp47V7H; Thu, 23 Apr 2020 06:40:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0F594B0F5;
	Thu, 23 Apr 2020 06:40:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 351B04B0F3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 06:40:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gai8Ysv20CVM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2020 06:40:07 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27BB54B0EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 06:40:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587638406;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+r/PR2FbN4xLG8Nok2HJ4M/QJoOCF0Nk3Bss40sN0xs=;
 b=NouqzbRNU0NtRrqjYHfw+/WBOocxOD7emRBy8+WtupinH1n2ksqncPmN2RWmtHCW4Slcwv
 Pylx1nxegLSqTrgXAkRKaJIMrtukm1/EoGxYBzn2rkqS3nzCsGdhHCiJe5zZKEKwzrBqRb
 KQdnNU45+wHkvERAscbdGcXDvxM+bq4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-AkzxH94nMVKFKkFx37Ew_w-1; Thu, 23 Apr 2020 06:39:20 -0400
X-MC-Unique: AkzxH94nMVKFKkFx37Ew_w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07DD5835B41;
 Thu, 23 Apr 2020 10:39:17 +0000 (UTC)
Received: from gondolin (ovpn-112-121.ams2.redhat.com [10.36.112.121])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 11C6260608;
 Thu, 23 Apr 2020 10:39:03 +0000 (UTC)
Date: Thu, 23 Apr 2020 12:39:01 +0200
From: Cornelia Huck <cohuck@redhat.com>
To: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: Re: [PATCH v2 1/7] KVM: s390: clean up redundant 'kvm_run' parameters
Message-ID: <20200423123901.72a4c6a4.cohuck@redhat.com>
In-Reply-To: <5e1e126d-f1b0-196c-594b-4289d0afb9a8@linux.alibaba.com>
References: <20200422125810.34847-1-tianjia.zhang@linux.alibaba.com>
 <20200422125810.34847-2-tianjia.zhang@linux.alibaba.com>
 <20200422154543.2efba3dd.cohuck@redhat.com>
 <dc5e0fa3-558b-d606-bda9-ed281cf9e9ae@de.ibm.com>
 <20200422180403.03f60b0c.cohuck@redhat.com>
 <5e1e126d-f1b0-196c-594b-4289d0afb9a8@linux.alibaba.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, david@redhat.com,
 benh@kernel.crashing.org, heiko.carstens@de.ibm.com,
 linux-mips@vger.kernel.org, paulus@ozlabs.org, hpa@zytor.com,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 frankja@linux.ibm.com, maz@kernel.org, joro@8bytes.org, x86@kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>, mingo@redhat.com,
 thuth@redhat.com, gor@linux.ibm.com, kvm-ppc@vger.kernel.org, bp@alien8.de,
 tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, jmattson@google.com,
 tsbogend@alpha.franken.de, sean.j.christopherson@intel.com,
 linux-kernel@vger.kernel.org, mpe@ellerman.id.au, pbonzini@redhat.com,
 vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
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

On Thu, 23 Apr 2020 11:01:43 +0800
Tianjia Zhang <tianjia.zhang@linux.alibaba.com> wrote:

> On 2020/4/23 0:04, Cornelia Huck wrote:
> > On Wed, 22 Apr 2020 17:58:04 +0200
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> On 22.04.20 15:45, Cornelia Huck wrote:  
> >>> On Wed, 22 Apr 2020 20:58:04 +0800
> >>> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> wrote:
> >>>      
> >>>> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
> >>>> structure. Earlier than historical reasons, many kvm-related function  
> >>>
> >>> s/Earlier than/For/ ?
> >>>      
> >>>> parameters retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time.
> >>>> This patch does a unified cleanup of these remaining redundant parameters.
> >>>>
> >>>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> >>>> ---
> >>>>   arch/s390/kvm/kvm-s390.c | 37 ++++++++++++++++++++++---------------
> >>>>   1 file changed, 22 insertions(+), 15 deletions(-)
> >>>>
> >>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> >>>> index e335a7e5ead7..d7bb2e7a07ff 100644
> >>>> --- a/arch/s390/kvm/kvm-s390.c
> >>>> +++ b/arch/s390/kvm/kvm-s390.c
> >>>> @@ -4176,8 +4176,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
> >>>>   	return rc;
> >>>>   }
> >>>>   
> >>>> -static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> >>>> +static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
> >>>>   {
> >>>> +	struct kvm_run *kvm_run = vcpu->run;
> >>>>   	struct runtime_instr_cb *riccb;
> >>>>   	struct gs_cb *gscb;
> >>>>   
> >>>> @@ -4235,7 +4236,7 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> >>>>   		}
> >>>>   		if (vcpu->arch.gs_enabled) {
> >>>>   			current->thread.gs_cb = (struct gs_cb *)
> >>>> -						&vcpu->run->s.regs.gscb;
> >>>> +						&kvm_run->s.regs.gscb;  
> >>>
> >>> Not sure if these changes (vcpu->run-> => kvm_run->) are really worth
> >>> it. (It seems they amount to at least as much as the changes advertised
> >>> in the patch description.)
> >>>
> >>> Other opinions?  
> >>
> >> Agreed. It feels kind of random. Maybe just do the first line (move kvm_run from the
> >> function parameter list into the variable declaration)? Not sure if this is better.
> >>  
> > 
> > There's more in this patch that I cut... but I think just moving
> > kvm_run from the parameter list would be much less disruptive.
> >   
> 
> I think there are two kinds of code(`vcpu->run->` and `kvm_run->`), but 
> there will be more disruptive, not less.

I just fail to see the benefit; sure, kvm_run-> is convenient, but the
current code is just fine, and any rework should be balanced against
the cost (e.g. cluttering git annotate).

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
