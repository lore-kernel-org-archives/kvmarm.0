Return-Path: <SRS0=VGwd=LQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A92C48BDF
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 09:43:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0E0546135D
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 09:43:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E0546135D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91C94407F4;
	Tue, 22 Jun 2021 05:43:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 716+UO9D1pJY; Tue, 22 Jun 2021 05:43:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69FB740617;
	Tue, 22 Jun 2021 05:43:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5054840617
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 05:43:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gsxrIEaOhPGr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jun 2021 05:43:20 -0400 (EDT)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com
 [209.85.210.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F0E87402DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 05:43:19 -0400 (EDT)
Received: by mail-ot1-f52.google.com with SMTP id
 j11-20020a9d738b0000b02903ea3c02ded8so20617222otk.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 02:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=mOZsVL4W9RtqKElq9uj4H6IEXm0Hjxy6DO7qW7nF8+s=;
 b=ux0YEZplnfIscu7weLF3XpMoCtMnkNmS6hVSWuN56okSLW/zGV1P+guRXMFRqRkbf7
 Orp3GVpNMWhLy8UtZep53Z6pymX+WaeuKiMBhSvFvW6/XyhpgTlktM+RQbnkC8iI/O3J
 SNDkBBMrMo+ywAPTzu2X1V2oRTSHHVxXL0N6GZQ66fkZMVbICFky94VQxIOgL1khTDJ/
 10I1gamEP+yLZDLwjGD3OLmFleSlcamkg+L3gTC5dl81NSS/qNHiLNYAALAy1X1kjFhq
 ep/UgbeZLCglgQHlqBhfpYHMWUpBPmett/7lXuSbLiI7EYBc+8nCCO8QEvWc/dd2Xg8E
 FkFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=mOZsVL4W9RtqKElq9uj4H6IEXm0Hjxy6DO7qW7nF8+s=;
 b=CrISr6PezsjRcvMhKfqHTZmb33IbyCmkXZvoLsGyeXpM9EeNzRuP+AyUpw62Kf+FsG
 efXDsg4pINSe5sBJhENf3dHChnBc6Oi3DfJoHgyaC+3MLw03Go8M9JdhWQR1Tkvte/n/
 bYabCGrxJbhMuJFcM59iTQ+nXOJxOpqMDOCJ2rlDkY4qjHzUutBcYlOXI0pebEU4Y7CH
 QGxVVQc3AL1OKZu+1WsCkWF/BSI8F7h4S6vZkCZsPTdDUrZea3WmNyV6vYZpgJIlviAt
 BY/CtrYvWjwrHVt9V2Z2AzJIMJIu0ZjMskUNhldp/TTMEGFg+ucuWfv4oqC2kBR6QEGk
 IhEA==
X-Gm-Message-State: AOAM5318w0E4C9ZrpBtYDcM1be2zA+Mtamnv4jiYFQVL34GZDr+BDBqf
 U3WdLcqmv9Q3t0OExdA3F5jG0kswibsQXZTuKXCh3Q==
X-Google-Smtp-Source: ABdhPJzlIDoe2rVjsQdnkHJBL+8HQrVMGP+s17mqW1WIzdE5TsTe6sX5gcHWH9dUwFLCPfuFLUMJObjVJ+/GHUBWjfw=
X-Received: by 2002:a05:6830:2315:: with SMTP id
 u21mr2367474ote.365.1624354999094; 
 Tue, 22 Jun 2021 02:43:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210621111716.37157-1-steven.price@arm.com>
 <20210621111716.37157-7-steven.price@arm.com>
In-Reply-To: <20210621111716.37157-7-steven.price@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jun 2021 10:42:42 +0100
Message-ID: <CA+EHjTwww=QFq30bi8n2t2fkfr1B_0v0KSZ75dK+ZJDUU3f5xQ@mail.gmail.com>
Subject: Re: [PATCH v17 6/6] KVM: arm64: Document MTE capability and ioctl
To: Steven Price <steven.price@arm.com>
Cc: Juan Quintela <quintela@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
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

Hi,


On Mon, Jun 21, 2021 at 12:18 PM Steven Price <steven.price@arm.com> wrote:
>
> A new capability (KVM_CAP_ARM_MTE) identifies that the kernel supports
> granting a guest access to the tags, and provides a mechanism for the
> VMM to enable it.
>
> A new ioctl (KVM_ARM_MTE_COPY_TAGS) provides a simple way for a VMM to
> access the tags of a guest without having to maintain a PROT_MTE mapping
> in userspace. The above capability gates access to the ioctl.
>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  Documentation/virt/kvm/api.rst | 61 ++++++++++++++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 7fcb2fd38f42..97661a97943f 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5034,6 +5034,43 @@ see KVM_XEN_VCPU_SET_ATTR above.
>  The KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST type may not be used
>  with the KVM_XEN_VCPU_GET_ATTR ioctl.
>
> +4.130 KVM_ARM_MTE_COPY_TAGS
> +---------------------------
> +
> +:Capability: KVM_CAP_ARM_MTE
> +:Architectures: arm64
> +:Type: vm ioctl
> +:Parameters: struct kvm_arm_copy_mte_tags
> +:Returns: number of bytes copied, < 0 on error (-EINVAL for incorrect
> +          arguments, -EFAULT if memory cannot be accessed).
> +
> +::
> +
> +  struct kvm_arm_copy_mte_tags {
> +       __u64 guest_ipa;
> +       __u64 length;
> +       void __user *addr;
> +       __u64 flags;
> +       __u64 reserved[2];
> +  };
> +
> +Copies Memory Tagging Extension (MTE) tags to/from guest tag memory. The
> +``guest_ipa`` and ``length`` fields must be ``PAGE_SIZE`` aligned. The ``addr``
> +field must point to a buffer which the tags will be copied to or from.
> +
> +``flags`` specifies the direction of copy, either ``KVM_ARM_TAGS_TO_GUEST`` or
> +``KVM_ARM_TAGS_FROM_GUEST``.
> +
> +The size of the buffer to store the tags is ``(length / 16)`` bytes
> +(granules in MTE are 16 bytes long). Each byte contains a single tag
> +value. This matches the format of ``PTRACE_PEEKMTETAGS`` and
> +``PTRACE_POKEMTETAGS``.
> +
> +If an error occurs before any data is copied then a negative error code is
> +returned. If some tags have been copied before an error occurs then the number
> +of bytes successfully copied is returned. If the call completes successfully
> +then ``length`` is returned.
> +
>  5. The kvm_run structure
>  ========================
>
> @@ -6362,6 +6399,30 @@ default.
>
>  See Documentation/x86/sgx/2.Kernel-internals.rst for more details.
>
> +7.26 KVM_CAP_ARM_MTE
> +--------------------
> +
> +:Architectures: arm64
> +:Parameters: none
> +
> +This capability indicates that KVM (and the hardware) supports exposing the
> +Memory Tagging Extensions (MTE) to the guest. It must also be enabled by the
> +VMM before creating any VCPUs to allow the guest access. Note that MTE is only
> +available to a guest running in AArch64 mode and enabling this capability will
> +cause attempts to create AArch32 VCPUs to fail.

I was wondering if there might be an issue with AArch32 at EL0 and
MTE, because I think that even if AArch64 at EL1 is disallowed, the
guest can still run AArch32 at EL0.

Thanks,
/fuad

> +
> +When enabled the guest is able to access tags associated with any memory given
> +to the guest. KVM will ensure that the tags are maintained during swap or
> +hibernation of the host; however the VMM needs to manually save/restore the
> +tags as appropriate if the VM is migrated.
> +
> +When this capability is enabled all memory in memslots must be mapped as
> +not-shareable (no MAP_SHARED), attempts to create a memslot with a
> +MAP_SHARED mmap will result in an -EINVAL return.
> +
> +When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
> +perform a bulk copy of tags to/from the guest.
> +
>  8. Other capabilities.
>  ======================
>
> --
> 2.20.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
