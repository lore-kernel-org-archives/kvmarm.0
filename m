Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E98AC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 18:13:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0A8849F2F;
	Tue, 22 Mar 2022 14:13:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bXPOdM7-NqWI; Tue, 22 Mar 2022 14:13:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67D4E49EEE;
	Tue, 22 Mar 2022 14:13:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9844B49EEA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:13:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id URQw681zDmsR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 14:13:15 -0400 (EDT)
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com
 [209.85.166.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2467849ECB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:13:15 -0400 (EDT)
Received: by mail-io1-f43.google.com with SMTP id 125so7845418iov.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 11:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=rtlpiHKGuBI50mYkezQOMw981of4REeJs1p1T1jGRPs=;
 b=b1k7K7ub7mzBu3/wLuv94d84NYAlaajtfz6AOuR0CeT9C9qpU91QBP1wQJB/2RAXLe
 GN5zOQaagJhe27FM8MOPvm08HNFOa5bSpOxyEy0ci74fos4f/fJuFx3DEt0HzRCcfZnW
 npFZwNfX5aB1iXWx6m/OWMBxdVuUt8zGqB1hI+8vlEa+1k9wBWo+qM5zex7uBxaF+Vcu
 uXVcjMjKcNtHim7npKFNLvwvVpT1pxRZODArBqMETzMc+ICCDZIbFg+U/go3dxvN41WP
 SP2Fya60PunclCXP/JP4lFIf8EYh77i4MxWLTEctWVK5vyKHswcNcPtaLN0Z2ebnWbRE
 dM5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=rtlpiHKGuBI50mYkezQOMw981of4REeJs1p1T1jGRPs=;
 b=OLUUoOZpQkjQ56mykgpZc7urkCMAZhAdwa4bd5u2QM64v2P8L+pKwz278cP0Xo2pXP
 qA30B47s+kGMYOiUBlDhagg2ysvtrsefJMzzSPE+5NYfUlokJ9w8q0jaWK9S0RmwjSXk
 2GOWfss2GLePix+PfAx+yM9zzOpjtC+Mg36KUgEqmhWkvHcL0a6U7ndpPAsV/bSnNJLJ
 HXXAa3VSxR1YAeUphis0k8smj2nmafg+sBJbifhLQAKsoDZfEczdDXDLc/uJ8KuqqYJt
 E5KqfK6XY6d32QvM47vh7BG4z+g4v82rbQxn7vnV/wofOUFHKXjpw9+NxpG80UJpcvJe
 002Q==
X-Gm-Message-State: AOAM531PdWI6HplefxyciF/5X46mj3QfYQf1CQxry0c7zN/CbKSgF/2A
 KPACEN5y4LLaL6mI1/68KvG6GQ==
X-Google-Smtp-Source: ABdhPJxq27BzAmXq4Aget5l4uWNoLAIXNiKfQwk5X/rVxCtuv8st/BJUxLXdZyLFZ4x7jhTu9xZtcw==
X-Received: by 2002:a05:6638:3e13:b0:321:446d:2977 with SMTP id
 co19-20020a0566383e1300b00321446d2977mr5417041jab.178.1647972793943; 
 Tue, 22 Mar 2022 11:13:13 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 w13-20020a92d2cd000000b002c8533c4b27sm341551ilg.78.2022.03.22.11.13.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Mar 2022 11:13:13 -0700 (PDT)
Date: Tue, 22 Mar 2022 18:13:09 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 00/22] Support SDEI Virtualization
Message-ID: <YjoRteSXpPkDGqgp@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220322080710.51727-1-gshan@redhat.com>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Tue, Mar 22, 2022 at 04:06:48PM +0800, Gavin Shan wrote:
> This series intends to virtualize Software Delegated Exception Interface
> (SDEI), which is defined by DEN0054C (v1.1). It allows the hypervisor to
> deliver NMI-alike SDEI event to guest and it's needed by Async PF to
> deliver page-not-present notification from hypervisor to guest. The code
> and the required qemu changes can be found from:
> 
>    https://developer.arm.com/documentation/den0054/c
>    https://github.com/gwshan/linux    ("kvm/arm64_sdei")
>    https://github.com/gwshan/qemu     ("kvm/arm64_sdei")
> 
> For the design and migration needs, please refer to the document in
> PATCH[21/22] in this series. The series is organized as below:
> 
>   PATCH[01]    Introduces template for smccc_get_argx()
>   PATCH[02]    Adds SDEI virtualization infrastructure
>   PATCH[03-17] Supports various SDEI hypercalls and event handling
>   PATCH[18-20] Adds ioctl commands to support migration and configuration
>                and exports SDEI capability
>   PATCH[21]    Adds SDEI document 
>   PATCH[22]    Adds SDEI selftest case
> 
> Testing
> =======
> 
> [1] The selftest case included in this series works fine. The default SDEI
>     event, whose number is zero, can be registered, enabled, raised. The
>     SDEI event handler can be invoked.
> 
>     [host]# pwd
>     /home/gavin/sandbox/linux.main/tools/testing/selftests/kvm
>     [root@virtlab-arm01 kvm]# ./aarch64/sdei 
> 
>         NR_VCPUS: 2    SDEI Event: 0x00000000
> 
>     --- VERSION
>         Version:              1.1 (vendor: 0x4b564d)
>     --- FEATURES
>         Shared event slots:   0
>         Private event slots:  0
>         Relative mode:        No
>     --- PRIVATE_RESET
>     --- SHARED_RESET
>     --- PE_UNMASK
>     --- EVENT_GET_INFO
>         Type:                 Private
>         Priority:             Normal
>         Signaled:             Yes
>     --- EVENT_REGISTER
>     --- EVENT_ENABLE
>     --- EVENT_SIGNAL
>         Handled:              Yes
>         IRQ:                  No
>         Status:               Registered-Enabled-Running
>         PC/PSTATE:            000000000040232c 00000000600003c5
>         Regs:                 0000000000000000 0000000000000000
>                               0000000000000000 0000000000000000
>     --- PE_MASK
>     --- EVENT_DISABLE
>     --- EVENT_UNREGISTER
> 
>         Result: OK
> 
> [2] There are additional patches in the following repositories to create
>     procfs entries, allowing to inject SDEI event from host side. The
>     SDEI client in the guest side registers the SDEI default event, whose
>     number is zero. Also, the QEMU exports SDEI ACPI table and supports
>     migration for SDEI.
> 
>     https://github.com/gwshan/linux    ("kvm/arm64_sdei")
>     https://github.com/gwshan/qemu     ("kvm/arm64_sdei")
> 
>     [2.1] Start the guests and migrate the source VM to the destination
>           VM.
> 
>     [host]# /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64       \
>             -accel kvm -machine virt,gic-version=host                     \
>             -cpu host -smp 6,sockets=2,cores=3,threads=1                  \
>             -m 1024M,slots=16,maxmem=64G                                  \
>                :                                                          \
>             -kernel /home/gavin/sandbox/linux.guest/arch/arm64/boot/Image \
>             -initrd /home/gavin/sandbox/images/rootfs.cpio.xz             \
>             -append earlycon=pl011,mmio,0x9000000                         \
>                :
> 
>     [host]# /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64       \
>             -accel kvm -machine virt,gic-version=host                     \
>             -cpu host -smp 6,sockets=2,cores=3,threads=1                  \
>             -m 1024M,slots=16,maxmem=64G                                  \
>                :                                                          \
>             -kernel /home/gavin/sandbox/linux.guest/arch/arm64/boot/Image \
>             -initrd /home/gavin/sandbox/images/rootfs.cpio.xz             \
>             -append earlycon=pl011,mmio,0x9000000                         \
>             -incoming tcp:0:4444                                          \
>                :
> 
>     [2.2] Check kernel log on the source VM. The SDEI service is enabled
>           and the default SDEI event (0x0) is enabled.
> 
>      [guest-src]# dmesg | grep -i sdei
>      ACPI: SDEI 0x000000005BC80000 000024 \
>                 (v00 BOCHS  BXPC     00000001 BXPC 00000001)
>      sdei: SDEIv1.1 (0x4b564d) detected in firmware.
>      SDEI TEST: Version 1.1, Vendor 0x4b564d
>      sdei_init: SDEI event (0x0) registered
>      sdei_init: SDEI event (0x0) enabled
> 
>  
>      (qemu) migrate -d tcp:localhost:4444
> 
>     [2.3] Migrate the source VM to the destination VM. Inject SDEI event
>           to the destination VM. The event is raised and handled.
> 
>     (qemu) migrate -d tcp:localhost:4444
> 
>     [host]# echo 0 > /proc/kvm/kvm-5360/vcpu-1
> 
>     [guest-dst]#
>     =========== SDEI Event (CPU#1) ===========
>     Event: 0000000000000000  Parameter: 00000000dabfdabf
>     PC: ffff800008cbb554  PSTATE: 00000000604000c5  SP: ffff800009c7bde0
>     Regs:    00000000000016ee ffff00001ffd2e28 00000000000016ed 0000000000000001 
>              ffff800016c28000 0000000000000000 0000000000000000 0000000000000000 
>              0000000000000000 0000000000000000 0000000000000000 0000000000000000 
>              0000000000000000 0000000000000000 0000000000000000 0000000000000000 
>              0000000000000000 0000000000000000 0000000000000000 ffff800009399008 
>              ffff8000097d9af0 ffff8000097d99f8 ffff8000093a8db8 ffff8000097d9b18 
>              0000000000000000 0000000000000000 ffff000000339d00 0000000000000000 
>              0000000000000000 ffff800009c7bde0 ffff800008cbb5c4 
>     Context: 00000000000016ee ffff00001ffd2e28 00000000000016ed 0000000000000001 
>              ffff800016c28000 03ffffffffffffff 000000024325db59 ffff8000097de190 
>              ffff00000033a790 ffff800008cbb814 0000000000000a30 0000000000000000 
> 
> Changelog
> ========= 
> v5:

Next time can you include a link to the cover letter of the previous
patch set? It is extremely helpful for understanding the progress to
date and allows reviewers to see prior feedback.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
