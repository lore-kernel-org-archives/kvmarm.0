Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF3BECAAD8
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 08:45:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A603D4B24C;
	Tue, 20 Sep 2022 04:45:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6q28SKryqKgs; Tue, 20 Sep 2022 04:45:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 829C44B632;
	Tue, 20 Sep 2022 04:45:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDDBC4B24C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 04:45:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 59P3ZgxW29Lo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 04:45:54 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCC244B210
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 04:45:54 -0400 (EDT)
Date: Tue, 20 Sep 2022 10:45:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663663554;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=lMg8dliGJzByApcJFv4j6u1kjHjAp/4NbWInC1+sFlA=;
 b=oPo+LehcYlQPGSyYqZ6y8gkPKtAGt6xIaMLXot7pMzW8JpnxTtavDoTPRlwinKwA9rtxKn
 EgsNsq1zk71pLcJGebkUBQjgZcvJ/3V7uwPEMg8U+K0j0xUL/+ckH2OTtS9w+YKiKxaYQj
 FrW7Yckk5dRn8Gm/0X7JuJFyJAhRM68=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 05/19] lib/alloc_phys: Remove locking
Message-ID: <20220920084553.734jvkqpognzgfpr@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-6-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-6-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: nikos.nikoleris@arm.com, pbonzini@redhat.com, thuth@redhat.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Tue, Aug 09, 2022 at 10:15:44AM +0100, Alexandru Elisei wrote:
> With powerpc moving the page allocator, there are no architectures left
> which use the physical allocator after the boot setup:  arm, arm64,
> s390x and powerpc drain the physical allocator to initialize the page
> allocator; and x86 calls setup_vm() to drain the allocator for each of
> the tests that allocate memory.

Please put the motivation for this change in the commit message. I looked
ahead at the next patch to find it, but I'm not sure I agree with it. We
should be able to keep the locking even when used early, since we probably
need our locking to be something we can use early elsewhere anyway.

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
