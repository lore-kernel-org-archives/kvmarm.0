Return-Path: <SRS0=aIiX=IH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D56D5C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  9 Mar 2021 11:01:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 43EC36523B
	for <kvmarm@archiver.kernel.org>; Tue,  9 Mar 2021 11:01:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43EC36523B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9DEA4B3C7;
	Tue,  9 Mar 2021 06:01:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b-vwSiQgoAK0; Tue,  9 Mar 2021 06:01:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEC0B4B3E2;
	Tue,  9 Mar 2021 06:01:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44CB14B413
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 06:01:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9rno5qIwe8io for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Mar 2021 06:01:45 -0500 (EST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com
 [209.85.208.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 451214B407
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 06:01:45 -0500 (EST)
Received: by mail-ed1-f41.google.com with SMTP id bd6so19177443edb.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Mar 2021 03:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=vdZ4o+zoeGhBm3eWUzEKAm3SjsyvDpQ7XHjJEgZbpvA=;
 b=mLLgcOkGiUnzFw3UE3oQBVac/QperD9HatYPiTHaHcjhWXjSDD9xGqDW9WAKvrfswy
 12Kaqb8Mxo0fSaxpDqm5TJki2Vs+jTW3433sX1ZHcUJ2m4/Pi8FnaoAW78pwEm2X2erO
 8fRS7lCr/tep5XCTaV5V8csBu2hfOkYN7lB7rNFPcE42icw/QkJvQMHzxIFuBAyUjAKG
 INrt/uotzmU+770iB07TJu/T//V7mQ1Qt4g/7OPcU5T2DXTKnmMfH8FkMRcC01sKh52i
 FJwt39CTqR9mmdQ4vly4YFUdfl8mt8Hy/tDK5ys81SjtV9JAkLVYUbJnVwi+M/VNYQMN
 5TUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=vdZ4o+zoeGhBm3eWUzEKAm3SjsyvDpQ7XHjJEgZbpvA=;
 b=Pf2tM8H0ZpWFPxV1RlSaGR9FLfnG8Duvx2p+UklLyGG/DXRW2Ku9b/bpFAEoDOSVp6
 sMvpRHitBu8UTWkvDWxzjYzBud16pzlpJNtBm2qO2P9Q+qlw6s+/YqKaPfrz4YLOrU6q
 MHkutn2UcNOepXoqeOsx7FWjb6hYVDd9EVr02KbJkDSAM4ZReb9A+yrlug4DeulrmJMB
 egUaVBQEgG/CPQ5wwhuv0UFCxt7WFPrQLpNVXsw91DAAVKnsUeyr3s1daWmZQdku7m4u
 IJjWf9xV5m1bay+2ucjv4zACRaYlJQWC9wogQ8i0KY/VFwe2e41wUSHFsd95QlKFb4Rm
 3dzQ==
X-Gm-Message-State: AOAM5323wukdi0hrt0BILReOmk+64nCTRI9LYgmYxYZKup1lApxo672l
 GdCwtlBWHnsUJz9YjQQYpw1EoXEHmi2AeAHn+hEWCg==
X-Google-Smtp-Source: ABdhPJxklFVbfFNwNwAAaKz6vbxUZ69o/Z0+23/AeFD9ENbDqkgki+Ljib01MLFfq9nwJFRwK6T2DanfvfvyeHNfctY=
X-Received: by 2002:a05:6402:19a:: with SMTP id
 r26mr3358969edv.44.1615287704169; 
 Tue, 09 Mar 2021 03:01:44 -0800 (PST)
MIME-Version: 1.0
References: <20210301142315.30920-1-steven.price@arm.com>
 <20210301142315.30920-7-steven.price@arm.com>
In-Reply-To: <20210301142315.30920-7-steven.price@arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 9 Mar 2021 11:01:27 +0000
Message-ID: <CAFEAcA8pkvWeGV19QEaZx+pENDpUTO3=p-euPjkjeiU8OGtZzw@mail.gmail.com>
Subject: Re: [PATCH v9 6/6] KVM: arm64: Document MTE capability and ioctl
To: Steven Price <steven.price@arm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 QEMU Developers <qemu-devel@nongnu.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Dave Martin <Dave.Martin@arm.com>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Mon, 1 Mar 2021 at 14:23, Steven Price <steven.price@arm.com> wrote:
>
> A new capability (KVM_CAP_ARM_MTE) identifies that the kernel supports
> granting a guest access to the tags, and provides a mechanism for the
> VMM to enable it.
>
> A new ioctl (KVM_ARM_MTE_COPY_TAGS) provides a simple way for a VMM to
> access the tags of a guest without having to maintain a PROT_MTE mapping
> in userspace. The above capability gates access to the ioctl.
>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  Documentation/virt/kvm/api.rst | 37 ++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index aed52b0fc16e..1406ea138127 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4939,6 +4939,23 @@ KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO
>  Allows Xen vCPU attributes to be read. For the structure and types,
>  see KVM_XEN_VCPU_SET_ATTR above.
>
> +4.131 KVM_ARM_MTE_COPY_TAGS
> +---------------------------
> +
> +:Capability: KVM_CAP_ARM_MTE
> +:Architectures: arm64
> +:Type: vm ioctl
> +:Parameters: struct kvm_arm_copy_mte_tags
> +:Returns: 0 on success, < 0 on error
> +
> +Copies Memory Tagging Extension (MTE) tags to/from guest tag memory.

Mostly virt/kvm/api.rst seems to include documentation of the
associated structs, something like:

::

  struct kvm_arm_copy_mte_tags {
         __u64 guest_ipa;
         __u64 length;
         union {
                 void __user *addr;
                 __u64 padding;
         };
         __u64 flags;
  };


which saves the reader having to cross-reference against the header file.
It also means you can more naturally use the actual field names in the doc,
eg:

> +The
> +starting address and length of guest memory must be ``PAGE_SIZE`` aligned.

you could say "The guest_ipa and length fields" here.

Also "The addr field must point to a buffer which the tags will
be copied to or from." I assume.

> +The size of the buffer to store the tags is ``(length / MTE_GRANULE_SIZE)``
> +bytes (i.e. 1/16th of the corresponding size).

> + Each byte contains a single tag
> +value. This matches the format of ``PTRACE_PEEKMTETAGS`` and
> +``PTRACE_POKEMTETAGS``.

What are the valid values for 'flags' ? It looks like they specify which
direction the copy is, which we definitely need to document here.

What happens if the caller requests a tag copy for an area of guest
address space which doesn't have tags (eg it has nothing mapped),
or for an area of guest addres space which has tags in some parts
but not in others ?

> +
>  5. The kvm_run structure
>  ========================
>
> @@ -6227,6 +6244,25 @@ KVM_RUN_BUS_LOCK flag is used to distinguish between them.
>  This capability can be used to check / enable 2nd DAWR feature provided
>  by POWER10 processor.
>
> +7.23 KVM_CAP_ARM_MTE
> +--------------------
> +
> +:Architectures: arm64
> +:Parameters: none
> +
> +This capability indicates that KVM (and the hardware) supports exposing the
> +Memory Tagging Extensions (MTE) to the guest. It must also be enabled by the
> +VMM before the guest will be granted access.
> +
> +When enabled the guest is able to access tags associated with any memory given
> +to the guest. KVM will ensure that the pages are flagged ``PG_mte_tagged`` so
> +that the tags are maintained during swap or hibernation of the host, however

s/,/;/

> +the VMM needs to manually save/restore the tags as appropriate if the VM is
> +migrated.
> +
> +When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
> +perform a bulk copy of tags to/from the guest

"guest."

> +
>  8. Other capabilities.
>  ======================
>
> @@ -6716,3 +6752,4 @@ KVM_XEN_HVM_SET_ATTR, KVM_XEN_HVM_GET_ATTR, KVM_XEN_VCPU_SET_ATTR and
>  KVM_XEN_VCPU_GET_ATTR ioctls, as well as the delivery of exception vectors
>  for event channel upcalls when the evtchn_upcall_pending field of a vcpu's
>  vcpu_info is set.
> +
> --
> 2.20.1


Stray whitespace change ?

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
