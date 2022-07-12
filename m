Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D436C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jul 2022 10:09:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F01BF4BE7C;
	Tue, 12 Jul 2022 06:09:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zN-4aHPr5lp4; Tue, 12 Jul 2022 06:09:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDFC44BE6C;
	Tue, 12 Jul 2022 06:08:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3316E4BE58
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 05:46:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lxJqq2nqccwg for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jul 2022 05:46:50 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 012504BE53
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 05:46:49 -0400 (EDT)
Date: Tue, 12 Jul 2022 11:46:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1657619209;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=mnXWUrIfGOW0Je0O0P1V4KP3f52Jsjrq+7JY38apOwQ=;
 b=mRKpQiTadNkQhambM7s0HxVay8Z7Sy/N4GJWSBXENM36+8p1e5BFZlgqBzBtclfqCIAMwF
 +RUIpJLttjNd7uWyrKOMX4CaC9oBRFzVe2pdtbz0y50SRGcAUSZH2e8vefttwIMk4w7gdy
 FlJJU/Jvnxg37DblqsEsgAzrFDN0OZc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 07/13] KVM: selftests: aarch64: Construct
 DEFAULT_MAIR_EL1 using sysreg.h macros
Message-ID: <20220712094648.nkm57lq7eapdfh5h@kamzik>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-8-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220624213257.1504783-8-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Mailman-Approved-At: Tue, 12 Jul 2022 06:08:57 -0400
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 dmatlack@google.com, pbonzini@redhat.com, axelrasmussen@google.com,
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

On Fri, Jun 24, 2022 at 02:32:51PM -0700, Ricardo Koller wrote:
> Define macros for memory type indexes and construct DEFAULT_MAIR_EL1
> with macros from asm/sysreg.h.  The index macros can then be used when
> constructing PTEs (instead of using raw numbers).
> 
> Reviewed-by: Oliver Upton <oupton@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h | 25 ++++++++++++++-----
>  .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
>  2 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 6649671fa7c1..74f10d006e15 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -38,12 +38,25 @@
>   * NORMAL             4     1111:1111
>   * NORMAL_WT          5     1011:1011
>   */
> -#define DEFAULT_MAIR_EL1 ((0x00ul << (0 * 8)) | \
> -			  (0x04ul << (1 * 8)) | \
> -			  (0x0cul << (2 * 8)) | \
> -			  (0x44ul << (3 * 8)) | \
> -			  (0xfful << (4 * 8)) | \
> -			  (0xbbul << (5 * 8)))
> +
> +/* Linux doesn't use these memory types, so let's define them. */
> +#define MAIR_ATTR_DEVICE_GRE	UL(0x0c)
> +#define MAIR_ATTR_NORMAL_WT	UL(0xbb)
> +
> +#define MT_DEVICE_nGnRnE	0
> +#define MT_DEVICE_nGnRE		1
> +#define MT_DEVICE_GRE		2
> +#define MT_NORMAL_NC		3
> +#define MT_NORMAL		4
> +#define MT_NORMAL_WT		5
> +
> +#define DEFAULT_MAIR_EL1							\
> +	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |		\
> +	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |		\
> +	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |			\
> +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |			\
> +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |				\
> +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT))
>  
>  #define MPIDR_HWID_BITMASK (0xff00fffffful)
>  
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 8dd511aa79c2..733a2b713580 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -133,7 +133,7 @@ void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
>  
>  void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
>  {
> -	uint64_t attr_idx = 4; /* NORMAL (See DEFAULT_MAIR_EL1) */
> +	uint64_t attr_idx = MT_NORMAL;
>  
>  	_virt_pg_map(vm, vaddr, paddr, attr_idx, 0);
>  }
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
