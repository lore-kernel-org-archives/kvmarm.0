From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH V3 1/4] KVM: Add documentation for KVM_CAP_NR_MEMSLOTS
Date: Tue, 7 Mar 2017 06:58:21 -0800
Message-ID: <20170307145821.GE101711@lvm>
References: <1488865964-17346-1-git-send-email-linucherian@gmail.com>
 <1488865964-17346-2-git-send-email-linucherian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BA3140BE4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 09:57:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hKhVr5fvRLcZ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Mar 2017 09:57:03 -0500 (EST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 18E7240A6A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 09:57:02 -0500 (EST)
Received: by mail-wm0-f45.google.com with SMTP id t189so7093010wmt.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Mar 2017 06:58:24 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1488865964-17346-2-git-send-email-linucherian@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linucherian@gmail.com
Cc: marc.zyngier@arm.com, Linu Cherian <linu.cherian@cavium.com>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 07, 2017 at 11:22:41AM +0530, linucherian@gmail.com wrote:
> From: Linu Cherian <linu.cherian@cavium.com>

Please add a patch description, even if it just repeats the subject line
as in this case.

Otherwise:

Acked-by: Christoffer Dall <cdall@linaro.org>

> 
> Signed-off-by: Linu Cherian <linu.cherian@cavium.com>
> ---
>  Documentation/virtual/kvm/api.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 03145b7..7b82f1c 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -951,6 +951,10 @@ This ioctl allows the user to create or modify a guest physical memory
>  slot.  When changing an existing slot, it may be moved in the guest
>  physical memory space, or its flags may be modified.  It may not be
>  resized.  Slots may not overlap in guest physical address space.
> +Bits 0-15 of "slot" specifies the slot id and this value should be
> +less than the maximum number of user memory slots supported per VM.
> +The maximum allowed slots can be queried using KVM_CAP_NR_MEMSLOTS,
> +if this capability is supported by the architecture.
>  
>  If KVM_CAP_MULTI_ADDRESS_SPACE is available, bits 16-31 of "slot"
>  specifies the address space which is being modified.  They must be
> -- 
> 1.9.1
> 
