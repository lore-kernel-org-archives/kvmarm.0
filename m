Return-Path: <SRS0=R38U=L2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE62FC11F6A
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 16:00:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 27D3B613F7
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 16:00:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27D3B613F7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AC444B089;
	Fri,  2 Jul 2021 12:00:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vaFiF-mma8Vs; Fri,  2 Jul 2021 12:00:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D3964B08A;
	Fri,  2 Jul 2021 12:00:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36B894B086
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 12:00:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HC0kurV0L7Uv for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jul 2021 12:00:34 -0400 (EDT)
Received: from smtprelay.hostedemail.com (smtprelay0181.hostedemail.com
 [216.40.44.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 38D1149E8C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 12:00:34 -0400 (EDT)
Received: from omf08.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
 by smtprelay07.hostedemail.com (Postfix) with ESMTP id 5E8CE181D207E;
 Fri,  2 Jul 2021 16:00:33 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by
 omf08.hostedemail.com (Postfix) with ESMTPA id 850751A29F9; 
 Fri,  2 Jul 2021 16:00:25 +0000 (UTC)
Message-ID: <7379289718c6826dd1affec5824b749be2aee0a4.camel@perches.com>
Subject: Re: [PATCH V7 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <peterz@infradead.org>, Zhu Lingshan
 <lingshan.zhu@intel.com>
Date: Fri, 02 Jul 2021 09:00:22 -0700
In-Reply-To: <YN722HIrzc6Z2+oD@hirez.programming.kicks-ass.net>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <20210622094306.8336-2-lingshan.zhu@intel.com>
 <YN722HIrzc6Z2+oD@hirez.programming.kicks-ass.net>
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 850751A29F9
X-Stat-Signature: shha9bwa3wcuy6qog6sh3abeec4qbbut
X-Rspamd-Server: rspamout03
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18c3UUJH2LcjAG65GSZ68xha895S86OjZI=
X-HE-Tag: 1625241625-20610
Cc: wanpengli@tencent.com, Like Xu <like.xu@linux.intel.com>,
 eranian@google.com, weijiang.yang@intel.com, Guo Ren <guoren@kernel.org>,
 linux-riscv@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, kan.liang@linux.intel.com, ak@linux.intel.com,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, joro@8bytes.org,
 x86@kernel.org, linux-csky@vger.kernel.org, wei.w.wang@intel.com,
 xen-devel@lists.xenproject.org, liuxiangdong5@huawei.com, bp@alien8.de,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel@lists.infradead.org, jmattson@google.com,
 like.xu.linux@gmail.com, Nick Hu <nickhu@andestech.com>, seanjc@google.com,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, 2021-07-02 at 13:22 +0200, Peter Zijlstra wrote:
> On Tue, Jun 22, 2021 at 05:42:49PM +0800, Zhu Lingshan wrote:
> > diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
[]
> > @@ -90,6 +90,27 @@ DEFINE_STATIC_CALL_NULL(x86_pmu_pebs_aliases, *x86_p=
mu.pebs_aliases);
> > =A0=A0*/
> > =A0DEFINE_STATIC_CALL_RET0(x86_pmu_guest_get_msrs, *x86_pmu.guest_get_m=
srs);
> > =A0
> > =

> > +DEFINE_STATIC_CALL_RET0(x86_guest_state, *(perf_guest_cbs->state));
> > +DEFINE_STATIC_CALL_RET0(x86_guest_get_ip, *(perf_guest_cbs->get_ip));
> > +DEFINE_STATIC_CALL_RET0(x86_guest_handle_intel_pt_intr, *(perf_guest_c=
bs->handle_intel_pt_intr));
> > +
> > +void arch_perf_update_guest_cbs(void)
> > +{
> > +	static_call_update(x86_guest_state, (void *)&__static_call_return0);
> > +	static_call_update(x86_guest_get_ip, (void *)&__static_call_return0);
> > +	static_call_update(x86_guest_handle_intel_pt_intr, (void *)&__static_=
call_return0);
> > +
> > +	if (perf_guest_cbs && perf_guest_cbs->state)
> > +		static_call_update(x86_guest_state, perf_guest_cbs->state);
> > +
> > +	if (perf_guest_cbs && perf_guest_cbs->get_ip)
> > +		static_call_update(x86_guest_get_ip, perf_guest_cbs->get_ip);
> > +
> > +	if (perf_guest_cbs && perf_guest_cbs->handle_intel_pt_intr)
> > +		static_call_update(x86_guest_handle_intel_pt_intr,
> > +				   perf_guest_cbs->handle_intel_pt_intr);
> > +}
> =

> Coding style wants { } on that last if().

That's just your personal preference.

The coding-style document doesn't require that.

It just says single statement.  It's not the number of
vertical lines or characters required for the statement.

----------------------------------

Do not unnecessarily use braces where a single statement will do.

.. code-block:: c

	if (condition)
		action();

and

.. code-block:: none

	if (condition)
		do_this();
	else
		do_that();

This does not apply if only one branch of a conditional statement is a sing=
le
statement; in the latter case use braces in both branches:


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
