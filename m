Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D74C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 13 Oct 2022 14:09:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7371E410AD;
	Thu, 13 Oct 2022 10:09:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4gobQSpJJih5; Thu, 13 Oct 2022 10:09:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D65549EED;
	Thu, 13 Oct 2022 10:09:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9E9B410AD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Oct 2022 10:09:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s5Aa23qmcpkz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Oct 2022 10:09:14 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A1D540E62
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Oct 2022 10:09:14 -0400 (EDT)
Date: Thu, 13 Oct 2022 16:09:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1665670153;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=m4OT6t/hF2QZxwP8g/89k5+woQDdrKhIkPj7KFIFu+M=;
 b=qoFO2n4LWMAwtxat68aciJa0fWzzXGCWd4h2xV6/hkJM+JDOHbIJOOSMXtTHYqbi3o53YQ
 kAsbsYGiqzf5850K4x5mWHS5Rhhq6qoWZHdKvpK+4zzDHf3k1BXe8Y3tFBnfnmKeyzeGy6
 ep5PtDI9xNBtPQMAHfNwOtgGL0FsQRU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v9 08/14] KVM: selftests: Fix alignment in
 virt_arch_pgd_alloc() and vm_vaddr_alloc()
Message-ID: <20221013140911.izpjfm72ar6nq2vs@kamzik>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <20221011010628.1734342-9-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-9-ricarkol@google.com>
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

On Tue, Oct 11, 2022 at 01:06:22AM +0000, Ricardo Koller wrote:
> Refactor virt_arch_pgd_alloc() and vm_vaddr_alloc() in both RISC-V and
> aarch64 to fix the alignment of parameters in a couple of calls. This will
> make it easier to fix the alignment in a future commit that adds an extra
> parameter (that happens to be very long).
> 
> No functional change intended.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/lib/aarch64/processor.c     | 27 ++++++++++---------
>  .../selftests/kvm/lib/riscv/processor.c       | 27 ++++++++++---------
>  2 files changed, 30 insertions(+), 24 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
