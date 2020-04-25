Return-Path: <SRS0=8W4i=6K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1ECC55191
	for <kvmarm@archiver.kernel.org>; Sun, 26 Apr 2020 10:57:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C37A02084D
	for <kvmarm@archiver.kernel.org>; Sun, 26 Apr 2020 10:57:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C37A02084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 735F34B1F1;
	Sun, 26 Apr 2020 06:57:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 93dQlgQFddA3; Sun, 26 Apr 2020 06:57:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 051BE4B1F4;
	Sun, 26 Apr 2020 06:57:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41A8E4B1C9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Apr 2020 18:34:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7gBYNgTnRr6Z for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Apr 2020 18:34:28 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 678A34B19A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Apr 2020 18:34:28 -0400 (EDT)
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
 by mx2.suse.de (Postfix) with ESMTP id AC3E6AC46;
 Sat, 25 Apr 2020 22:34:25 +0000 (UTC)
Date: Sat, 25 Apr 2020 15:30:14 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/5] kvm: Replace vcpu->swait with rcuwait
Message-ID: <20200425223014.ndxjvpzk5mx7c2f3@linux-p48b>
References: <20200424054837.5138-1-dave@stgolabs.net>
 <20200424054837.5138-6-dave@stgolabs.net>
 <69af54bb-8632-fbf7-d774-da9a954ff1b7@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <69af54bb-8632-fbf7-d774-da9a954ff1b7@redhat.com>
User-Agent: NeoMutt/20180716
X-Mailman-Approved-At: Sun, 26 Apr 2020 06:57:24 -0400
Cc: kvm@vger.kernel.org, will@kernel.org, Davidlohr Bueso <dbueso@suse.de>,
 peterz@infradead.org, maz@kernel.org, bigeasy@linutronix.de,
 linux-kernel@vger.kernel.org, rostedt@goodmis.org, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, joel@joelfernandes.org, tglx@linutronix.de,
 torvalds@linux-foundation.org, kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Sat, 25 Apr 2020, Paolo Bonzini wrote:

>I'm squashing this in to keep the changes compared to the current code minimal,
>and queuing the series.

Thanks!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
