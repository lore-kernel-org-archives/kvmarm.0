Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB34C43334
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jul 2022 14:50:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2848C4CF4C;
	Tue, 19 Jul 2022 10:50:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VwGTnOjjG0Pj; Tue, 19 Jul 2022 10:50:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB8664CF3C;
	Tue, 19 Jul 2022 10:50:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB1B44CE57
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 10:50:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AEJuCDqIQOJp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2022 10:50:20 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35FBA4CE52
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 10:50:20 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1658242219;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=jctjcs10cXLC6Fgs+ejM2KhG7RRpw0OENqiwSYLGZwM=;
 b=igz/bprdn0EGgw4vEzeXhl++PB2FmMwsYyqRSGFmlIKn/JmLNJ9qXP/VR7YYXrHw1CN6vf
 CKJ6eaCU2jt2EqcY8t0IeeQIR4ND/pAVHaRs/WbFVX+e4poPC+8/k+JflJuCl98mCDC6mA
 d2BW/Up+/tmF9bIhHJcC8q6LUMp20po=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-kkwaFwbkMtGGia0WGtTbbg-1; Tue, 19 Jul 2022 10:50:10 -0400
X-MC-Unique: kkwaFwbkMtGGia0WGtTbbg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5D11811E76;
 Tue, 19 Jul 2022 14:50:09 +0000 (UTC)
Received: from localhost (unknown [10.39.195.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 63DF040CFD0A;
 Tue, 19 Jul 2022 14:50:09 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Peter Collingbourne <pcc@google.com>, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 0/3] KVM: arm64: support MTE in protected VMs
In-Reply-To: <20220708212106.325260-1-pcc@google.com>
Organization: Red Hat GmbH
References: <20220708212106.325260-1-pcc@google.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date: Tue, 19 Jul 2022 16:50:08 +0200
Message-ID: <877d49p36n.fsf@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Andy Lutomirski <luto@amacapital.net>,
 Will Deacon <will@kernel.org>, Evgenii Stepanov <eugenis@google.com>,
 Michael Roth <michael.roth@amd.com>, Chao Peng <chao.p.peng@linux.intel.com>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org
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

On Fri, Jul 08 2022, Peter Collingbourne <pcc@google.com> wrote:

> Hi,
>
> This patch series contains a proposed extension to pKVM that allows MTE
> to be exposed to the protected guests. It is based on the base pKVM
> series previously sent to the list [1] and later rebased to 5.19-rc3
> and uploaded to [2].
>
> This series takes precautions against host compromise of the guests
> via direct access to their tag storage, by preventing the host from
> accessing the tag storage via stage 2 page tables. The device tree
> must describe the physical memory address of the tag storage, if any,
> and the memory nodes must declare that the tag storage location is
> described. Otherwise, the MTE feature is disabled in protected guests.
>
> Now that we can easily do so, we also prevent the host from accessing
> any unmapped reserved-memory regions without a driver, as the host
> has no business accessing that memory.
>
> A proposed extension to the devicetree specification is available at
> [3], a patched version of QEMU that produces the required device tree
> nodes is available at [4] and a patched version of the crosvm hypervisor
> that enables MTE is available at [5].

I'm unsure how this is supposed to work with QEMU + KVM, as your QEMU
patch adds mte-alloc properties to regions that are exposed as a
separate address space (which will not work with KVM). Is the magic in
that new shared section?

>
> v2:
> - refcount the PTEs owned by NOBODY
>
> [1] https://lore.kernel.org/all/20220519134204.5379-1-will@kernel.org/
> [2] https://android-kvm.googlesource.com/linux/ for-upstream/pkvm-base-v2
> [3] https://github.com/pcc/devicetree-specification mte-alloc
> [4] https://github.com/pcc/qemu mte-shared-alloc
> [5] https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/3719324
>
> Peter Collingbourne (3):
>   KVM: arm64: add a hypercall for disowning pages
>   KVM: arm64: disown unused reserved-memory regions
>   KVM: arm64: allow MTE in protected VMs if the tag storage is known
>
>  arch/arm64/include/asm/kvm_asm.h              |  1 +
>  arch/arm64/include/asm/kvm_host.h             |  6 ++
>  arch/arm64/include/asm/kvm_pkvm.h             |  4 +-
>  arch/arm64/kernel/image-vars.h                |  3 +
>  arch/arm64/kvm/arm.c                          | 83 ++++++++++++++++++-
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  9 ++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 11 +++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                |  8 +-
>  arch/arm64/kvm/mmu.c                          |  4 +-
>  11 files changed, 123 insertions(+), 8 deletions(-)

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
