Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A572F58
	for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 21:02:51 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-517c06c1a1bso2946291a12.3
        for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 14:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682370171; x=1684962171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1uQH+wYaaizJExDZ1lotMDM9eIvQ+68rMtzBLQSleuw=;
        b=JneI2OA1E1OdqMOTyHcP8Y4VRO/M9RnrlgeSCeKHVB/FO2c1RrSNkRY+pwhBQSagr9
         CG0AaAJpky4z/4V7+t/RIIm80pjtl/IqdteWNQmgaoC+MOd/d6rZ1b24CKGJyTvHyaGo
         AV0Xw1Acxxm7AJCajRLwNYES6xPwR9kmnhi1aUhi69yfSewYM0mA4TFl8z+Y1eFNLszv
         IXMuxLbTgs8s+MX6S41BCw/c9/u/4V5a5U2OpYp6Ry6mBQqI3TlvBeqaG5KYh12Sa3UT
         XvTaYOE3cLoAOU9mf8evSTQ4tohh44X8ZEk537Gpl1aQym7ARKB6YEc8RnyBPGvwLQhu
         2krg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682370171; x=1684962171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1uQH+wYaaizJExDZ1lotMDM9eIvQ+68rMtzBLQSleuw=;
        b=iX3O7usY9O0qD9nED0Wra7sFyA7znjV+gDnCeHI7ahUFnxXSW4LgaWX9rLOBlupo8M
         QU5n/wdHH5POw7I/MRoSIz9osvCCgZelbbTBmDHOnPxozJqSeh5dbsFWXd+ug1UnJAPS
         wPGxHXxgEi6yH0dwgGswU+GSYv7TRF+GX4h+oywHjb6XdCCpWAsZwpJQ9XiFLTkOB4dD
         H+C2QJPcX6DEwKg+r+gQLgOAs8GJeiZrOyKnTFlCw5YUzVBHlcO2TZzdPRSs/7KtVHHh
         M2cod1jIuOpBdiyvkdCA9boLgpDLGxWZRukgwtCN3Ulg3AGXnup02WYHLjjb3/WvNLks
         zP6g==
X-Gm-Message-State: AAQBX9dfYE0/1b/KYbNbaXaxRamF4H4kMETARijNdIxx7AGCO8Qsudpi
	zLChh4r36Z4i38maLJy1JjwU5DpFe/A=
X-Google-Smtp-Source: AKy350ZVpddszBRkUO90RIV24p1F+ndg4m9IYyTcWuFgHIzNl/wA4ph7nNO9wTPMyU14d/M6m8Ee39OmARo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:214d:b0:1a9:62fb:7b06 with SMTP id
 s13-20020a170903214d00b001a962fb7b06mr2252373ple.7.1682370170756; Mon, 24 Apr
 2023 14:02:50 -0700 (PDT)
Date: Mon, 24 Apr 2023 14:02:49 -0700
In-Reply-To: <20230412213510.1220557-18-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-18-amoorthy@google.com>
Message-ID: <ZEbueTfeJugSl31X@google.com>
Subject: Re: [PATCH v3 17/22] KVM: Introduce KVM_CAP_ABSENT_MAPPING_FAULT
 without implementation
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 12, 2023, Anish Moorthy wrote:
> Add documentation, memslot flags, useful helper functions, and the
> actual new capability itself.
> 
> Memory fault exits on absent mappings are particularly useful for
> userfaultfd-based postcopy live migration. When many vCPUs fault on a
> single userfaultfd the faults can take a while to surface to userspace
> due to having to contend for uffd wait queue locks. Bypassing the uffd
> entirely by returning information directly to the vCPU exit avoids this
> contention and improves the fault rate.
> 
> Suggested-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 31 ++++++++++++++++++++++++++++---
>  include/linux/kvm_host.h       |  7 +++++++
>  include/uapi/linux/kvm.h       |  2 ++
>  tools/include/uapi/linux/kvm.h |  1 +
>  virt/kvm/kvm_main.c            |  3 +++
>  5 files changed, 41 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index f174f43c38d45..7967b9909e28b 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1312,6 +1312,7 @@ yet and must be cleared on entry.
>    /* for kvm_userspace_memory_region::flags */
>    #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
>    #define KVM_MEM_READONLY	(1UL << 1)
> +  #define KVM_MEM_ABSENT_MAPPING_FAULT (1UL << 2)

This name is both too specific and too vague.  It's too specific because it affects
more than just "absent" mappings, it will affect any page fault that can't be
resolved by fast GUP, i.e. I'm objecting for all the same reasons I objected to
the exit reason being name KVM_MEMFAULT_REASON_ABSENT_MAPPING.  It's too vague
because it doesn't describe what behavior the flag actually enables in any way.

I liked the "nowait" verbiage from the RFC.  "fast_only" is an ok alternative,
but that's much more of a kernel-internal name.

Oliver, you had concerns with using "fault" in the name, is something like
KVM_MEM_NOWAIT_ON_PAGE_FAULT or KVM_MEM_NOWAIT_ON_FAULT palatable?  IMO, "fault"
is perfectly ok, we just need to ensure it's unlikely to be ambiguous for userspace.
