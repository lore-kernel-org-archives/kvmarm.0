Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E615FC4332F
	for <kvmarm@archiver.kernel.org>; Thu, 13 Oct 2022 14:14:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44E0E410AD;
	Thu, 13 Oct 2022 10:14:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IaSYBZWEjA0O; Thu, 13 Oct 2022 10:14:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19377410DE;
	Thu, 13 Oct 2022 10:14:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC4A5410DE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Oct 2022 10:14:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 542BTd2KYg9f for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Oct 2022 10:14:40 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 902A0410AD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Oct 2022 10:14:40 -0400 (EDT)
Date: Thu, 13 Oct 2022 16:14:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1665670479;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=YTnR3sTpueMD1WOCKjn13lgOyfXnFgP1FGLusy0IRdQ=;
 b=o8iWPUfoQGziwzej5BerN5CcyiIwIgIJX1BIPhpwk1A3iUth1ltoEDYJ5RgytnN8fxDsFE
 09J30ihjCMewpdUEKnz7/NFKmvIhtCq9EUwJd3uexhjD1ECAFaFNPxcaBIzPTV7p96Oxaz
 1WNityOODlONHfzCXCTeiTbpZu7U+44=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v9 09/14] KVM: selftests: Use the right memslot for code, 
 page-tables, and data allocations
Message-ID: <20221013141431.datybmwzfdeqxobv@kamzik>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <20221011010628.1734342-10-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-10-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, bgardon@google.com, maz@kernel.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, axelrasmussen@google.com,
 kvmarm@lists.cs.columbia.edu, dmatlack@google.com
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

On Tue, Oct 11, 2022 at 01:06:23AM +0000, Ricardo Koller wrote:
> Now that kvm_vm allows specifying different memslots for code, page tables,
> and data, use the appropriate memslot when making allocations in
> common/libraty code. Change them accordingly:
> 
> - code (allocated by lib/elf) use the CODE memslot
> - stacks, exception tables, and other core data pages (like the TSS in x86)
>   use the DATA memslot
> - page tables and the PGD use the PT memslot
> - test data (anything allocated with vm_vaddr_alloc()) uses the TEST_DATA
>   memslot
> 
> No functional change intended. All allocators keep using memslot #0.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  4 ++
>  .../selftests/kvm/lib/aarch64/processor.c     | 12 ++--
>  tools/testing/selftests/kvm/lib/elf.c         |  3 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 57 ++++++++++++-------
>  .../selftests/kvm/lib/riscv/processor.c       |  8 ++-
>  .../selftests/kvm/lib/s390x/processor.c       |  8 ++-
>  .../selftests/kvm/lib/x86_64/processor.c      | 13 +++--
>  7 files changed, 65 insertions(+), 40 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
