Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFDDEC43334
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jun 2022 06:54:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33E694B32A;
	Wed,  8 Jun 2022 02:54:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8vljxXEtzRjf; Wed,  8 Jun 2022 02:54:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFC2F4B303;
	Wed,  8 Jun 2022 02:54:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEB9149EAA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 18:39:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AXFdpMzDHhed for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2022 18:39:43 -0400 (EDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
 [209.85.221.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 82FC949E08
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 18:39:43 -0400 (EDT)
Received: by mail-wr1-f51.google.com with SMTP id s1so2871633wra.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Jun 2022 15:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=K458RIwl0S+ioiFb9q6BhBZEP6igJ1vcM1oS0iy4llE=;
 b=qkZmhHTmAVsM9bQoLDmXN8wTqVlvd2UVrZ/mz+y/bY9PphCXZGgHPRsakFVRcXu5aJ
 pZ04V2pv9rTHMt/onY3xurzgs18BBkcF7UtaKDzb4ZXg/0pTfW94UE129RD9Kkrpj7vs
 grZKlOe4EK0DD2Pqrp1DGyUIGBC4V3I+k5N6lzmDnXUZ0beG22M8xQlNh/sPnmupAsf7
 Q63CVRCFUV6sqfyuatSWwheVbm8fm8dCIu6ZSbt3E9bhVrzNTvUI9wGrEsv0BLfu7ri8
 b9HPINaJfXlnLzKKnhcXb4SegUySQMFEr2cPlMyLLruFuW0NCfHLF+c8G8yrg0rE7hkk
 nNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=K458RIwl0S+ioiFb9q6BhBZEP6igJ1vcM1oS0iy4llE=;
 b=UcKfUJ8hyOMkhMIrzW7S4f7UH5hGKfobz65mvVonMSyfPRIsiCEM6AlySi9zEOVp6I
 H40bHner5c1SbYh7kqDgdHmXORtXbLsZ8waPWXlDLXTxW1aPhAfTLjg9pMVKyGJmixAD
 APHYl8bVpA/8JgFbhZjjWGeDmKPgk6kmGHdWk+u/UdgLuLyEBJO5ephmvc5C6KA8fmjW
 AMgQaqHwwFL2psIUgqWd4VzZyHxn/2cu9iELz58Xq+3SYJrrV63CSsCmJlBc8P+UaRYr
 SQk79EtD7Uen3xtC8hw15CG4q6vmUiToqJFSDsm7pZzyc3/jTkMab43A9krE5nAP8fq/
 MLOw==
X-Gm-Message-State: AOAM533KrBb323mu0bgGr1jdAByUguYHKxgi48pupLcY6PZnep3q+n7h
 N2+jzEojuP+bcBa2p7iPId6ijgW0/nk0Nw2q0Thk5Q==
X-Google-Smtp-Source: ABdhPJxDaq9V2MMEiigrquHHUGZwnOdX78QxqTvnOU5iE+xtZ6TJ5vdAVKa3ZGBQRboVwR95hdfWZUjtGPaVIQjuJZM=
X-Received: by 2002:a5d:6c62:0:b0:218:3e13:4b17 with SMTP id
 r2-20020a5d6c62000000b002183e134b17mr12877442wrz.673.1654641582192; Tue, 07
 Jun 2022 15:39:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-90-will@kernel.org>
In-Reply-To: <20220519134204.5379-90-will@kernel.org>
From: Peter Collingbourne <pcc@google.com>
Date: Tue, 7 Jun 2022 15:39:30 -0700
Message-ID: <CAMn1gO5OqW0s+_CGf22uH=eHL4nCap3ACOQ28TPWpxGVbPpE2A@mail.gmail.com>
Subject: Re: [PATCH 89/89] Documentation: KVM: Add some documentation for
 Protected KVM on arm64
To: Will Deacon <will@kernel.org>
X-Mailman-Approved-At: Wed, 08 Jun 2022 02:54:18 -0400
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, May 19, 2022 at 8:05 AM Will Deacon <will@kernel.org> wrote:
>
> Add some initial documentation for the Protected KVM (pKVM) feature on
> arm64, describing the user ABI for creating protected VMs as well as
> their limitations.
>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  .../admin-guide/kernel-parameters.txt         |  4 +-
>  Documentation/virt/kvm/arm/index.rst          |  1 +
>  Documentation/virt/kvm/arm/pkvm.rst           | 96 +++++++++++++++++++
>  3 files changed, 100 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/virt/kvm/arm/pkvm.rst
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 63a764ec7fec..b8841a969f59 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2437,7 +2437,9 @@
>                               protected guests.
>
>                         protected: nVHE-based mode with support for guests whose
> -                                  state is kept private from the host.
> +                                  state is kept private from the host. See
> +                                  Documentation/virt/kvm/arm/pkvm.rst for more
> +                                  information about this mode of operation.
>
>                         Defaults to VHE/nVHE based on hardware support. Setting
>                         mode to "protected" will disable kexec and hibernation
> diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
> index b4067da3fcb6..49c388df662a 100644
> --- a/Documentation/virt/kvm/arm/index.rst
> +++ b/Documentation/virt/kvm/arm/index.rst
> @@ -9,6 +9,7 @@ ARM
>
>     hyp-abi
>     hypercalls
> +   pkvm
>     psci
>     pvtime
>     ptp_kvm
> diff --git a/Documentation/virt/kvm/arm/pkvm.rst b/Documentation/virt/kvm/arm/pkvm.rst
> new file mode 100644
> index 000000000000..64f099a5ac2e
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/pkvm.rst
> @@ -0,0 +1,96 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Protected virtual machines (pKVM)
> +=================================
> +
> +Introduction
> +------------
> +
> +Protected KVM (pKVM) is a KVM/arm64 extension which uses the two-stage
> +translation capability of the Armv8 MMU to isolate guest memory from the host
> +system. This allows for the creation of a confidential computing environment
> +without relying on whizz-bang features in hardware, but still allowing room for
> +complementary technologies such as memory encryption and hardware-backed
> +attestation.
> +
> +The major implementation change brought about by pKVM is that the hypervisor
> +code running at EL2 is now largely independent of (and isolated from) the rest
> +of the host kernel running at EL1 and therefore additional hypercalls are
> +introduced to manage manipulation of guest stage-2 page tables, creation of VM
> +data structures and reclamation of memory on teardown. An immediate consequence
> +of this change is that the host itself runs with an identity mapping enabled
> +at stage-2, providing the hypervisor code with a mechanism to restrict host
> +access to an arbitrary physical page.
> +
> +Enabling pKVM
> +-------------
> +
> +The pKVM hypervisor is enabled by booting the host kernel at EL2 with
> +"``kvm-arm.mode=protected``" on the command-line. Once enabled, VMs can be spawned
> +in either protected or non-protected state, although the hypervisor is still
> +responsible for managing most of the VM metadata in either case.
> +
> +Limitations
> +-----------
> +
> +Enabling pKVM places some significant limitations on KVM guests, regardless of
> +whether they are spawned in protected state. It is therefore recommended only
> +to enable pKVM if protected VMs are required, with non-protected state acting
> +primarily as a debug and development aid.
> +
> +If you're still keen, then here is an incomplete list of caveats that apply
> +to all VMs running under pKVM:
> +
> +- Guest memory cannot be file-backed (with the exception of shmem/memfd) and is
> +  pinned as it is mapped into the guest. This prevents the host from
> +  swapping-out, migrating, merging or generally doing anything useful with the
> +  guest pages. It also requires that the VMM has either ``CAP_IPC_LOCK`` or
> +  sufficient ``RLIMIT_MEMLOCK`` to account for this pinned memory.

I think it would be useful to also add a note to
Documentation/virt/kvm/api.rst saying that ioctl(KVM_RUN) can return
ENOMEM if the VMM does not have CAP_IPC_LOCK or sufficient
RLIMIT_MEMLOCK, since that's where people are going to look when they
see that return value.

Peter
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
