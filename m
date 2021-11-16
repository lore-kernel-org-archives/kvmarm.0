Return-Path: <SRS0=+NXu=QD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C493C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 15:04:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C627461A4E
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 15:04:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C627461A4E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 583B84B08A;
	Tue, 16 Nov 2021 10:04:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ny3ITcu0QHel; Tue, 16 Nov 2021 10:04:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15BE24B108;
	Tue, 16 Nov 2021 10:04:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FDDB4B08F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 10:04:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xq6y67vLkME3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Nov 2021 10:04:05 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6078F4B08A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 10:04:05 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637075045;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=PbwhlYSET4WxARKb5uDjrAIi8kWP88Xedd5ECAgSeaU=;
 b=d2jnc6/X2KUSW3HUKxdni5Z+/+FthCpXycgxoJi63TqrNgw7pI9Mnq45JAcQu1Yi4Y6kvM
 0GWEa+CfVdTFadtxbpb1cMtAHCXaxUM3PN0+A9+udTX5CqcMeYw/b1uzRWZuwEQVoniLMR
 r9DlXt5q8LucrNRJHWgXnUpJAmk9sWg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-24-8NqL3LsANZit7G29sdqVjg-1; Tue, 16 Nov 2021 10:04:00 -0500
X-MC-Unique: 8NqL3LsANZit7G29sdqVjg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40E6A192376D;
 Tue, 16 Nov 2021 15:03:57 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
 by smtp.corp.redhat.com (Postfix) with ESMTP id C63895DEFB;
 Tue, 16 Nov 2021 15:03:41 +0000 (UTC)
Message-ID: <dd5292e5-7387-9797-2d74-6a3350cbe4f5@redhat.com>
Date: Tue, 16 Nov 2021 16:03:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/5] KVM: Turn the vcpu array into an xarray
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
 linux-mips@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linuxppc-dev@lists.ozlabs.org
References: <20211105192101.3862492-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211105192101.3862492-1-maz@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: Juergen Gross <jgross@suse.com>, Huacai Chen <chenhuacai@kernel.org>,
 Janosch Frank <frankja@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Anup Patel <anup.patel@wdc.com>, David Hildenbrand <david@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>, Atish Patra <atish.patra@wdc.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
 kernel-team@android.com, Claudio Imbrenda <imbrenda@linux.ibm.com>
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

On 11/5/21 20:20, Marc Zyngier wrote:
> The kvm structure is pretty large. A large portion of it is the vcpu
> array, which is 4kB on x86_64 and arm64 as they deal with 512 vcpu
> VMs. Of course, hardly anyone runs VMs this big, so this is often a
> net waste of memory and cache locality.
> 
> A possible approach is to turn the fixed-size array into an xarray,
> which results in a net code deletion after a bit of cleanup.
> 
> This series is on top of the current linux/master as it touches the
> RISC-V implementation. Only tested on arm64.

Queued, only locally until I get a review for my replacement of patch 4 
(see 
https://lore.kernel.org/kvm/20211116142205.719375-1-pbonzini@redhat.com/T/).

Paolo

> Marc Zyngier (5):
>    KVM: Move wiping of the kvm->vcpus array to common code
>    KVM: mips: Use kvm_get_vcpu() instead of open-coded access
>    KVM: s390: Use kvm_get_vcpu() instead of open-coded access
>    KVM: x86: Use kvm_get_vcpu() instead of open-coded access
>    KVM: Convert the kvm->vcpus array to a xarray
> 
>   arch/arm64/kvm/arm.c           | 10 +---------
>   arch/mips/kvm/loongson_ipi.c   |  4 ++--
>   arch/mips/kvm/mips.c           | 23 ++---------------------
>   arch/powerpc/kvm/powerpc.c     | 10 +---------
>   arch/riscv/kvm/vm.c            | 10 +---------
>   arch/s390/kvm/kvm-s390.c       | 26 ++++++--------------------
>   arch/x86/kvm/vmx/posted_intr.c |  2 +-
>   arch/x86/kvm/x86.c             |  9 +--------
>   include/linux/kvm_host.h       |  7 ++++---
>   virt/kvm/kvm_main.c            | 33 ++++++++++++++++++++++++++-------
>   10 files changed, 45 insertions(+), 89 deletions(-)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
