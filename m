Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3933EC49361
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 06:58:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B89A961396
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 06:58:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B89A961396
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5959740821;
	Fri, 18 Jun 2021 02:58:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J3F-c1XCeydu; Fri, 18 Jun 2021 02:58:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45B374A49C;
	Fri, 18 Jun 2021 02:58:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE5964A1A7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 02:58:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q+o0BXjvYqpc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 02:58:07 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 943A249F6C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 02:58:07 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9D0F60BBB;
 Fri, 18 Jun 2021 06:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1623999486;
 bh=m8+3j1h9uPUH7ldRSsFhVI1uLiB+yHr1XUMjZUudEWQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ujJUai8fcs5lEWU/3cU8/GXeqIcba5i+t/74SdT0lsvSNS5jMnSJkzqTbvpMrEMkJ
 GNZlc0ZiLYB3If5vVG2bGndtSF7yKhimWXiEpNzuorEgiB331hXcnxlleA0v5oj8OO
 poK2IP3ORzF2KLRtDSg759FiOOgN7gPULOcVPPco=
Date: Fri, 18 Jun 2021 08:58:04 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v11 3/7] KVM: stats: Support binary stats retrieval for a
 VM
Message-ID: <YMxD/NxAvKkXB2iM@kroah.com>
References: <20210618044819.3690166-1-jingzhangos@google.com>
 <20210618044819.3690166-4-jingzhangos@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210618044819.3690166-4-jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 David Matlack <dmatlack@google.com>, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Fri, Jun 18, 2021 at 04:48:15AM +0000, Jing Zhang wrote:
> Add a VM ioctl to get a statistics file descriptor by which a read
> functionality is provided for userspace to read out VM stats header,
> descriptors and data.
> Define VM statistics descriptors and header for all architectures.
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Fuad Tabba <tabba@google.com> #arm64
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/kvm/guest.c    | 14 +++++++++++++
>  arch/mips/kvm/mips.c      | 14 +++++++++++++
>  arch/powerpc/kvm/book3s.c | 16 +++++++++++++++
>  arch/powerpc/kvm/booke.c  | 16 +++++++++++++++
>  arch/s390/kvm/kvm-s390.c  | 19 +++++++++++++++++
>  arch/x86/kvm/x86.c        | 24 ++++++++++++++++++++++
>  include/linux/kvm_host.h  |  6 ++++++
>  virt/kvm/kvm_main.c       | 43 +++++++++++++++++++++++++++++++++++++++
>  8 files changed, 152 insertions(+)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 4962331d01e6..f456d1defe2b 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -28,6 +28,20 @@
>  
>  #include "trace.h"
>  
> +struct _kvm_stats_desc kvm_vm_stats_desc[] = {
> +	KVM_GENERIC_VM_STATS()
> +};
> +static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
> +		sizeof(struct kvm_vm_stat) / sizeof(u64));
> +
> +struct kvm_stats_header kvm_vm_stats_header = {

Can this be const?

> +	.name_size = KVM_STATS_NAME_LEN,
> +	.count = ARRAY_SIZE(kvm_vm_stats_desc),
> +	.desc_offset = sizeof(struct kvm_stats_header) + KVM_STATS_ID_MAXLEN,
> +	.data_offset = sizeof(struct kvm_stats_header) + KVM_STATS_ID_MAXLEN +
> +		       sizeof(kvm_vm_stats_desc),
> +};

If it can't be const, what is modified in it that prevents that from
happening?

thanks,

greg k-h
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
