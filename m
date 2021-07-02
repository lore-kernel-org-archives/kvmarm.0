Return-Path: <SRS0=R38U=L2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F915C11F68
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 16:42:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9124661429
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 16:42:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9124661429
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E67D40CF9;
	Fri,  2 Jul 2021 12:42:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wQbrpS7K3jYV; Fri,  2 Jul 2021 12:42:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A6F64A4A0;
	Fri,  2 Jul 2021 12:42:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E89649D50
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 12:42:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OfhT-WoLlVPj for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jul 2021 12:42:35 -0400 (EDT)
Received: from smtprelay.hostedemail.com (smtprelay0098.hostedemail.com
 [216.40.44.98])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C5624A4A0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 12:42:35 -0400 (EDT)
Received: from omf19.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
 by smtprelay04.hostedemail.com (Postfix) with ESMTP id C507B180A9C91;
 Fri,  2 Jul 2021 16:42:34 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by
 omf19.hostedemail.com (Postfix) with ESMTPA id 10EBB20D764; 
 Fri,  2 Jul 2021 16:42:26 +0000 (UTC)
Message-ID: <34a668a0606092990326207d2acc5441592756d6.camel@perches.com>
Subject: Re: [PATCH V7 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <peterz@infradead.org>
Date: Fri, 02 Jul 2021 09:42:25 -0700
In-Reply-To: <YN88rE+cxb7HrEtI@hirez.programming.kicks-ass.net>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <20210622094306.8336-2-lingshan.zhu@intel.com>
 <YN722HIrzc6Z2+oD@hirez.programming.kicks-ass.net>
 <7379289718c6826dd1affec5824b749be2aee0a4.camel@perches.com>
 <YN88rE+cxb7HrEtI@hirez.programming.kicks-ass.net>
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
X-Stat-Signature: ycuw4tc4dkddxofnskkdygh116nc5379
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 10EBB20D764
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18HOccKXnefKVhqRarv+ICfPC7oSScH3Ls=
X-HE-Tag: 1625244146-824246
Cc: wanpengli@tencent.com, Like Xu <like.xu@linux.intel.com>,
 eranian@google.com, weijiang.yang@intel.com, Guo Ren <guoren@kernel.org>,
 linux-riscv@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, kan.liang@linux.intel.com, ak@linux.intel.com,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, joro@8bytes.org,
 x86@kernel.org, linux-csky@vger.kernel.org, wei.w.wang@intel.com,
 xen-devel@lists.xenproject.org, liuxiangdong5@huawei.com, bp@alien8.de,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, vkuznets@redhat.com,
 linux-arm-kernel@lists.infradead.org, jmattson@google.com,
 like.xu.linux@gmail.com, Nick Hu <nickhu@andestech.com>, seanjc@google.com,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 Zhu Lingshan <lingshan.zhu@intel.com>
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

On Fri, 2021-07-02 at 18:19 +0200, Peter Zijlstra wrote:
> On Fri, Jul 02, 2021 at 09:00:22AM -0700, Joe Perches wrote:
> > On Fri, 2021-07-02 at 13:22 +0200, Peter Zijlstra wrote:
> > > On Tue, Jun 22, 2021 at 05:42:49PM +0800, Zhu Lingshan wrote:
> > > > diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> > []
> > > > +	if (perf_guest_cbs && perf_guest_cbs->handle_intel_pt_intr)
> > > > +		static_call_update(x86_guest_handle_intel_pt_intr,
> > > > +				   perf_guest_cbs->handle_intel_pt_intr);
> > > > +}
> > > =

> > > Coding style wants { } on that last if().
> > =

> > That's just your personal preference.
> =

> As a maintainer, those carry weight, also that's tip rules:
> =

> =A0=A0https://lore.kernel.org/lkml/20181107171149.165693799@linutronix.de/

Right, definitely so.

But merely referencing 'coding style' is ambiguous at best.

btw:

ASCII commonly refers to '{' and '}', the curly brackets, to be braces
and '[' and ']', the square brackets, to be brackets.

It might be clearer to use that terminology.

belts and braces, etc...

cheers, Joe

----------------

+Bracket rules
+^^^^^^^^^^^^^
+
+Brackets should be omitted only if the statement which follows 'if', 'for',
+'while' etc. is truly a single line::
+
+	if (foo)
+		do_something();
+
+The following is not considered to be a single line statement even
+though C does not require brackets::
+
+	for (i =3D 0; i < end; i++)
+		if (foo[i])
+			do_something(foo[i]);
+
+Adding brackets around the outer loop enhances the reading flow::
+
+	for (i =3D 0; i < end; i++) {
+		if (foo[i])
+			do_something(foo[i]);
+	}


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
