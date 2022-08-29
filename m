Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5381AECAAD5
	for <kvmarm@archiver.kernel.org>; Mon, 29 Aug 2022 16:21:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4BED4C151;
	Mon, 29 Aug 2022 12:21:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3rgm4fu0826l; Mon, 29 Aug 2022 12:21:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9DC04C14E;
	Mon, 29 Aug 2022 12:21:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C0534C127
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2022 12:21:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c9oqfEEHuChT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Aug 2022 12:21:14 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 214204BAC3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2022 12:21:14 -0400 (EDT)
Date: Mon, 29 Aug 2022 18:21:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1661790073;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=V84lDEZ16EblHvtM8fgyVev0owrVHxHzScy/ND3jaaQ=;
 b=CaPKCCVzoPf4bcbSMTSpQx2lOZ5yESWOlPHBTiOGHy4YQpHkCtql8IPuRRpSByvC5hO8de
 6xl8kO3jvz+Vdxt6cwkLhNUnQ9HU+hkqAyGXbfk+QrVReKpiqR0UixIQTF6rHD9/2AuqXA
 G+ANmKWFLtjqyg/LGkmx1D+5lFNxgSE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v5 6/7] KVM: selftest: Drop now-unnecessary ucall_uninit()
Message-ID: <20220829162111.wl65dxexk5qtrssf@kamzik>
References: <20220825232522.3997340-1-seanjc@google.com>
 <20220825232522.3997340-7-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220825232522.3997340-7-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Tom Rix <trix@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 llvm@lists.linux.dev, Colton Lewis <coltonlewis@google.com>,
 linux-riscv@lists.infradead.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Peter Gonda <pgonda@google.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>,
 Atish Patra <atishp@atishpatra.org>, linux-arm-kernel@lists.infradead.org,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>
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

On Thu, Aug 25, 2022 at 11:25:21PM +0000, Sean Christopherson wrote:
> Drop ucall_uninit() and ucall_arch_uninit() now that ARM doesn't modify
> the host's copy of ucall_exit_mmio_addr, i.e. now that there's no need to
> reset the pointer before potentially creating a new VM.  The few calls to
> ucall_uninit() are all immediately followed by kvm_vm_free(), and that is
> likely always going to hold true, i.e. it's extremely unlikely a test
> will want to effectively disable ucall in the middle of a test.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c       |  1 -
>  tools/testing/selftests/kvm/include/ucall_common.h |  6 ------
>  tools/testing/selftests/kvm/kvm_page_table_test.c  |  1 -
>  tools/testing/selftests/kvm/lib/aarch64/ucall.c    | 14 ++------------
>  tools/testing/selftests/kvm/lib/perf_test_util.c   |  1 -
>  tools/testing/selftests/kvm/lib/riscv/ucall.c      |  4 ----
>  tools/testing/selftests/kvm/lib/s390x/ucall.c      |  4 ----
>  tools/testing/selftests/kvm/lib/x86_64/ucall.c     |  4 ----
>  8 files changed, 2 insertions(+), 33 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
