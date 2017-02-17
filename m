From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: race-free exit from KVM_RUN without POSIX signals
Date: Fri, 17 Feb 2017 10:40:29 +0100
Message-ID: <a0f8d9bf-b438-a011-fe38-fa83a2733631@redhat.com>
References: <1487169821-14806-1-git-send-email-pbonzini@redhat.com>
 <8a0f0818-07eb-c33e-9488-5a69c6bb67b1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E190240D6B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Feb 2017 04:39:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EIwNtPLcQ3Y5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Feb 2017 04:39:38 -0500 (EST)
Received: from mail-wr0-f195.google.com (mail-wr0-f195.google.com
 [209.85.128.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D48FF40D5E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Feb 2017 04:39:36 -0500 (EST)
Received: by mail-wr0-f195.google.com with SMTP id i10so4660542wrb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Feb 2017 01:40:26 -0800 (PST)
In-Reply-To: <8a0f0818-07eb-c33e-9488-5a69c6bb67b1@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: james.hogan@imgtec.com, marc.zyngier@arm.com, kvm-ppc@vger.kernel.org, borntraeger@de.ibm.com, paulus@samba.org, cornelia.huck@de.ibm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 16/02/2017 20:26, David Hildenbrand wrote:
> As mentioned already on IRC, maybe something like "block_vcpu_run" would
> fit better now.

Hmm, the purpose of the flag is cause an immediate exit and it does do
so...  Surely incorrect (or just uncommon) usage will prevent a VCPU
from running, but that is just a side effect of the semantics, not the
intended usage.

Paolo

> But this is also ok and looks good to me.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
