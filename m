Return-Path: <SRS0=kG2x=5J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E577C41621
	for <kvmarm@archiver.kernel.org>; Tue, 24 Mar 2020 18:18:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD4E220775
	for <kvmarm@archiver.kernel.org>; Tue, 24 Mar 2020 18:18:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD4E220775
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C2D94A3B4;
	Tue, 24 Mar 2020 14:18:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h7jyoPOIg17T; Tue, 24 Mar 2020 14:18:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F8184A4A0;
	Tue, 24 Mar 2020 14:18:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C99DB4A4FC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Mar 2020 13:57:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g25TXsvMRRVX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Mar 2020 13:57:23 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6CCDF40217
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Mar 2020 13:57:23 -0400 (EDT)
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
 by mx2.suse.de (Postfix) with ESMTP id CD664ABC7;
 Tue, 24 Mar 2020 17:57:20 +0000 (UTC)
Date: Tue, 24 Mar 2020 10:56:14 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 3/4] kvm: Replace vcpu->swait with rcuwait
Message-ID: <20200324175614.fzwutnpw2xiigqni@linux-p48b>
References: <20200324044453.15733-4-dave@stgolabs.net>
 <202003250014.iSvLXrUS%lkp@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <202003250014.iSvLXrUS%lkp@intel.com>
User-Agent: NeoMutt/20180716
X-Mailman-Approved-At: Tue, 24 Mar 2020 14:18:11 -0400
Cc: kbuild-all@lists.01.org, kvm@vger.kernel.org,
 Davidlohr Bueso <dbueso@suse.de>, peterz@infradead.org, will@kernel.org,
 bigeasy@linutronix.de, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
 linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 joel@joelfernandes.org, pbonzini@redhat.com, tglx@linutronix.de,
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

On Wed, 25 Mar 2020, kbuild test robot wrote:

>   arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_vcpu_block':
>>> arch/x86/kvm/../../../virt/kvm/kvm_main.c:2698:16: error: macro "rcuwait_wait_event" passed 3 arguments, but takes just 2
>          TASK_IDLE);

This is because this series relies on the rcuwait change:

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=locking/core&id=80fbaf1c3f2926c834f8ca915441dfe27ce5487e

Thanks,
Davidlohr
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
