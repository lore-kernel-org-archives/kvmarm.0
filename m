Return-Path: <SRS0=I38I=X5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 639B2C47404
	for <kvmarm@archiver.kernel.org>; Fri,  4 Oct 2019 09:51:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E3D08215EA
	for <kvmarm@archiver.kernel.org>; Fri,  4 Oct 2019 09:51:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3D08215EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 522084A650;
	Fri,  4 Oct 2019 05:51:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p7O6hJm-D55a; Fri,  4 Oct 2019 05:51:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46D854A652;
	Fri,  4 Oct 2019 05:51:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B1F94A650
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Oct 2019 05:51:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yeEu6DD7agyF for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Oct 2019 05:51:25 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C87E4A588
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Oct 2019 05:51:25 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 4323F18C4290;
 Fri,  4 Oct 2019 09:51:24 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E365660BE1;
 Fri,  4 Oct 2019 09:51:18 +0000 (UTC)
Date: Fri, 4 Oct 2019 11:51:16 +0200
From: Andrew Jones <drjones@redhat.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v5 05/10] KVM: arm64: Support stolen time reporting via
 shared structure
Message-ID: <20191004095116.a6bi46y76chik3kd@kamzik.brq.redhat.com>
References: <20191002145037.51630-1-steven.price@arm.com>
 <20191002145037.51630-6-steven.price@arm.com>
 <20191003132235.ruanyfmdim5s6npj@kamzik.brq.redhat.com>
 <20191004070301.d7ari5rjlu3uuara@kamzik.brq.redhat.com>
 <b107c1ca-6804-dc47-af25-fcd0b201472f@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b107c1ca-6804-dc47-af25-fcd0b201472f@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2
 (mx1.redhat.com [10.5.110.62]); Fri, 04 Oct 2019 09:51:24 +0000 (UTC)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Fri, Oct 04, 2019 at 10:13:40AM +0100, Steven Price wrote:
> On 04/10/2019 08:03, Andrew Jones wrote:
> > On Thu, Oct 03, 2019 at 03:22:35PM +0200, Andrew Jones wrote:
> >> On Wed, Oct 02, 2019 at 03:50:32PM +0100, Steven Price wrote:
> >>> +int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init)
> >>> +{
> >>> +	struct kvm *kvm = vcpu->kvm;
> >>> +	u64 steal;
> >>> +	u64 steal_le;
> >>> +	u64 offset;
> >>> +	int idx;
> >>> +	u64 base = vcpu->arch.steal.base;
> >>> +
> >>> +	if (base == GPA_INVALID)
> >>> +		return -ENOTSUPP;
> >>> +
> >>> +	/* Let's do the local bookkeeping */
> >>> +	steal = vcpu->arch.steal.steal;
> >>> +	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
> >>> +	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
> >>> +	vcpu->arch.steal.steal = steal;
> >>> +
> >>> +	steal_le = cpu_to_le64(steal);
> >>
> >> Agreeing on a byte order for this interface makes sense, but I don't see
> >> it documented anywhere. Is this an SMCCC thing? Because I skimmed some
> >> of those specs and other users too but didn't see anything obvious. Anyway
> >> even if everybody but me knows that all data returned from SMCCC calls
> >> should be LE, it might be nice to document that in the pvtime doc.
> 
> A very good point - I'll document this in the Linux document and feed
> that back for DEN0057A.
> 
> > 
> > I have another [potentially dumb] SMCCC byte order question. If we need
> > to worry about using LE for the members of this structure, then why don't
> > we need to worry about the actual return values of the SMCCC calls? Like
> > the IPA of the structure?
> 
> The SMCCC calls pass values in registers. It's only when reading/writing
> these values from/to memory that the endianness actually has any meaning.
>

Ah yes, of course.

Thanks,
drew 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
