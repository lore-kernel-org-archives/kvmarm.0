Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E0B6C25B0E
	for <kvmarm@archiver.kernel.org>; Fri, 19 Aug 2022 05:28:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CA134E052;
	Fri, 19 Aug 2022 01:28:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nJl5xMLmXLhs; Fri, 19 Aug 2022 01:28:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4541D4E090;
	Fri, 19 Aug 2022 01:28:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFEDB4E090
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Aug 2022 01:28:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YkwX+mkRLOrH for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Aug 2022 01:28:09 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 822B94E052
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Aug 2022 01:28:09 -0400 (EDT)
Date: Fri, 19 Aug 2022 07:28:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1660886888;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=EVozTVP3R6alT//Ll18ulj/6MH8/qR/TwWtAnvBrzdU=;
 b=PMVRFKEZeKyE8EKMtXnLtfOneiT2O4Md6EbjoDnjs8TZwCMnre2cYE8B5wXoyUp7+VZUDi
 rkPY43Q9UBf2HkEAX370IebDwbZrbovf2i8dqr69md/ZWSGw8MNtVegMBEMuMBZcYbryyw
 X9xABLnKrnUYYniQPyUqfhwsay43Jlk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v1 3/5] KVM: selftests: Dirty host pages in dirty_log_test
Message-ID: <20220819052805.qnhw2d3arxixzvhl@kamzik>
References: <20220819005601.198436-1-gshan@redhat.com>
 <20220819005601.198436-4-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220819005601.198436-4-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kselftest@vger.kernel.org, bgardon@google.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, corbet@lwn.net, maz@kernel.org,
 shan.gavin@gmail.com, drjones@redhat.com, will@kernel.org, zhenyzha@redhat.com,
 dmatlack@google.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com
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

On Fri, Aug 19, 2022 at 08:55:59AM +0800, Gavin Shan wrote:
> It's assumed that 1024 host pages, instead of guest pages, are dirtied
> in each iteration in guest_code(). The current implementation misses
> the case of mismatched page sizes in host and guest. For example,
> ARM64 could have 64KB page size in guest, but 4KB page size in host.
> (TEST_PAGES_PER_LOOP / 16), instead of TEST_PAGES_PER_LOOP, host pages
> are dirtied in every iteration.
> 
> Fix the issue by touching all sub-pages when we have mismatched
> page sizes in host and guest.

I'll let the dirty-log test authors decide what's best to do for this
test, but I'd think we should let the guest continue dirtying its
pages without knowledge of the host pages. Then, adjust the host test
code to assert all sub-pages, other than the ones it expects the guest
to have written, remain untouched.

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
