Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC6AC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 16:50:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C0DF86109F
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 16:50:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C0DF86109F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7179C4B191;
	Wed, 27 Oct 2021 12:50:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kfvB5DdVnOKn; Wed, 27 Oct 2021 12:50:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 205554B1C0;
	Wed, 27 Oct 2021 12:49:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EE164B150
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 10:36:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7k2ZbuHOMyto for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 10:36:48 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41963407F1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 10:36:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635345408;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0gXXVZ1M1SPzD/8mviUXXiKMlrNVIcsqsHOKxhlwRek=;
 b=G1PA1ucuiB4g1VrcrH6nFW0KnMDWQ55BP1PKevICK+aLU4sOkU4f563k3jaurGpXP2OG4L
 6K61BlzVfhaiz+y+IkuTt9dVckhXsmNWNuntz7ftup5bsyHbkQW7M6U8C/3F/bGtSut2P6
 3SxM7xGGcUz4pfEc7kKVGTjbWmk5UxE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-UU3N_ykSOO6SiL7u12Utfg-1; Wed, 27 Oct 2021 10:36:46 -0400
X-MC-Unique: UU3N_ykSOO6SiL7u12Utfg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1095C112C391;
 Wed, 27 Oct 2021 14:35:56 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 83585794A9;
 Wed, 27 Oct 2021 14:35:46 +0000 (UTC)
Message-ID: <3a0c3397302d59ea313e079435a18bf1b9a43474.camel@redhat.com>
Subject: Re: [PATCH v2 16/43] KVM: Don't redo ktime_get() when calculating
 halt-polling stop/deadline
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>,  Marc Zyngier <maz@kernel.org>, Huacai Chen
 <chenhuacai@kernel.org>, Aleksandar Markovic
 <aleksandar.qemu.devel@gmail.com>, Paul Mackerras <paulus@ozlabs.org>, Anup
 Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>
Date: Wed, 27 Oct 2021 17:35:45 +0300
In-Reply-To: <0072221e-02e8-4d60-9b0f-80d8c423bf4e@redhat.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-17-seanjc@google.com>
 <0072221e-02e8-4d60-9b0f-80d8c423bf4e@redhat.com>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mailman-Approved-At: Wed, 27 Oct 2021 12:49:56 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, 2021-10-25 at 16:26 +0200, Paolo Bonzini wrote:
> On 09/10/21 04:12, Sean Christopherson wrote:
> > Calculate the halt-polling "stop" time using "cur" instead of redoing
> > ktime_get().  In the happy case where hardware correctly predicts
> > do_halt_poll, "cur" is only a few cycles old.  And if the branch is
> > mispredicted, arguably that extra latency should count toward the
> > halt-polling time.
> > 
> > In all likelihood, the numbers involved are in the noise and either
> > approach is perfectly ok.
> 
> Using "start" makes the change even more obvious, so:
> 
>      Calculate the halt-polling "stop" time using "start" instead of redoing
>      ktime_get().  In practice, the numbers involved are in the noise (e.g.,
>      in the happy case where hardware correctly predicts do_halt_poll and
>      there are no interrupts, "start" is probably only a few cycles old)
>      and either approach is perfectly ok.  But it's more precise to count
>      any extra latency toward the halt-polling time.
> 
> Paolo
> 
Agreed.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
