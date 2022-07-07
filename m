Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6D1C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jul 2022 07:16:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A73054B8EB;
	Thu,  7 Jul 2022 03:16:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l783Byi-9FlD; Thu,  7 Jul 2022 03:16:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C1FE4B919;
	Thu,  7 Jul 2022 03:16:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 298C94B8E9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jul 2022 02:40:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RqYX+q140V41 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jul 2022 02:40:00 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 13D994B874
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jul 2022 02:40:00 -0400 (EDT)
Date: Thu, 7 Jul 2022 08:39:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1657175998;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=1gBLIZvV+gDvafqhxIKbqt2xCNcdIDwr8ZOsL8htgQA=;
 b=J1nfV9ZQLgClWEZRgvgi6s1oubflxUnDJ+yJNsUBruN8s2bEVo7pk0xF3q3u4ON6yoVV/w
 0gicrshkBs5h7HLI8nkNaXXT4KGc3JUyNPAkL9+61YqqOcNLZ12p4o+kHxNQ0ki27aqhQG
 Ba8xJFVu9nZWeuxNLoe3CuwiK+lD3dc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Subject: Re: [PATCH 4/4] KVM: selftests: Fix filename reporting in guest
 asserts
Message-ID: <20220707063957.kl25qgb3bwrobui2@kamzik>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-5-coltonlewis@google.com>
 <20220616124519.erxasor4b5t7zaks@gator>
 <2fc82066-f092-bc19-ae69-6852820f41ef@redhat.com>
 <YsWqWkl8ymLFqxgY@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YsWqWkl8ymLFqxgY@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Mailman-Approved-At: Thu, 07 Jul 2022 03:16:36 -0400
Cc: thuth@redhat.com, kvm@vger.kernel.org, maz@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, vkuznets@redhat.com,
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

On Wed, Jul 06, 2022 at 03:29:30PM +0000, Colton Lewis wrote:
> On Mon, Jun 20, 2022 at 02:04:43PM +0200, Paolo Bonzini wrote:
> > On 6/16/22 14:45, Andrew Jones wrote:
> > > > +#define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...) do {	\
> > > > +		if (!(_condition))					\
> > > > +			ucall(UCALL_ABORT, GUEST_ASSERT_BUILTIN_NARGS + _nargs,	\
> > > > +			      "Failed guest assert: " _condstr,		\
> > > > +			      __FILE__,					\
> > > > +			      __LINE__,					\
> > > > +			      ##_args);					\
> > > We don't need another level of indentation nor the ## operator on _args.
> > > 
> > 
> > The ## is needed to drop the comma if there are no _args.
> 
> I haven't heard anything more about part 4 of this patch in a while,
> so I'm checking in that I didn't miss something requiring action on my
> part.

Paolo set me straight on the ## usage, so besides the indentation nit and
the other comment I had about losing an assert string, then it looks fine
to me.

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
