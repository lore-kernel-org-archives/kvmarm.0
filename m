Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788C0ECAAD2
	for <kvmarm@archiver.kernel.org>; Mon, 29 Aug 2022 16:15:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB0494C091;
	Mon, 29 Aug 2022 12:15:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1WcS-tOTeAHI; Mon, 29 Aug 2022 12:15:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A37944C094;
	Mon, 29 Aug 2022 12:15:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F232C4C091
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2022 12:15:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jsm8mt6hqkS9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Aug 2022 12:15:40 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85BFA4BA1E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2022 12:15:40 -0400 (EDT)
Date: Mon, 29 Aug 2022 18:15:36 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1661789739;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=+wStadIO0VmoiizHUtMBUV7ir4oix+OG46hCH3/9nUA=;
 b=axsCOB4iqY8LlEIt1QM5kBid32gDCkM7tTjX+MaW67UKJMAocXMBMyQTKWkZJQuliAWCSI
 ugfhKgH5bl8QaX3KFeeyeHQAfBD2EZSE87zo7nshwXmqu46M70v71qFDmiv34QxSkK6F98
 iiMDGI469oRRmmLbgxzwFTpnag5/u3c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v5 3/7] KVM: selftests: Automatically do init_ucall() for
 non-barebones VMs
Message-ID: <20220829161536.gszp6yvgbzwnor7r@kamzik>
References: <20220825232522.3997340-1-seanjc@google.com>
 <20220825232522.3997340-4-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220825232522.3997340-4-seanjc@google.com>
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

On Thu, Aug 25, 2022 at 11:25:18PM +0000, Sean Christopherson wrote:
> Do init_ucall() automatically during VM creation to kill two (three?)
> birds with one stone.
> 
> First, initializing ucall immediately after VM creations allows forcing
> aarch64's MMIO ucall address to immediately follow memslot0.  This is
> still somewhat fragile as tests could clobber the MMIO address with a
> new memslot, but it's safe-ish since tests have to be conversative when
> accounting for memslot0.  And this can be hardened in the future by
> creating a read-only memslot for the MMIO page (KVM ARM exits with MMIO
> if the guest writes to a read-only memslot).  Add a TODO to document that
> selftests can and should use a memslot for the ucall MMIO (doing so
> requires yet more rework because tests assumes thay can use all memslots
> except memslot0).
> 
> Second, initializing ucall for all VMs prepares for making ucall
> initialization meaningful on all architectures.  aarch64 is currently the
> only arch that needs to do any setup, but that will change in the future
> by switching to a pool-based implementation (instead of the current
> stack-based approach).
> 
> Lastly, defining the ucall MMIO address from common code will simplify
> switching all architectures (except s390) to a common MMIO-based ucall
> implementation (if there's ever sufficient motivation to do so).
> 
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/aarch64/arch_timer.c        |  1 -
>  .../selftests/kvm/aarch64/debug-exceptions.c  |  1 -
>  .../selftests/kvm/aarch64/hypercalls.c        |  1 -
>  .../testing/selftests/kvm/aarch64/psci_test.c |  1 -
>  .../testing/selftests/kvm/aarch64/vgic_init.c |  2 -
>  .../testing/selftests/kvm/aarch64/vgic_irq.c  |  1 -
>  tools/testing/selftests/kvm/dirty_log_test.c  |  2 -
>  .../selftests/kvm/include/ucall_common.h      |  6 +--
>  .../selftests/kvm/kvm_page_table_test.c       |  1 -
>  .../testing/selftests/kvm/lib/aarch64/ucall.c | 54 ++-----------------
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 11 ++++
>  .../selftests/kvm/lib/perf_test_util.c        |  2 -
>  tools/testing/selftests/kvm/lib/riscv/ucall.c |  2 +-
>  tools/testing/selftests/kvm/lib/s390x/ucall.c |  2 +-
>  .../testing/selftests/kvm/lib/x86_64/ucall.c  |  2 +-
>  .../testing/selftests/kvm/memslot_perf_test.c |  1 -
>  tools/testing/selftests/kvm/rseq_test.c       |  1 -
>  tools/testing/selftests/kvm/steal_time.c      |  1 -
>  .../kvm/system_counter_offset_test.c          |  1 -
>  19 files changed, 20 insertions(+), 73 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
