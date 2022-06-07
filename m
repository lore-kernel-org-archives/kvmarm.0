Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFC3CCA47C
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 11:12:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21A8D4B325;
	Tue,  7 Jun 2022 07:12:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GANkPTm3l7NF; Tue,  7 Jun 2022 07:12:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60DBD4B366;
	Tue,  7 Jun 2022 07:12:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59C984B2F6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2022 20:42:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DCpDtvfEjMXW for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jun 2022 20:42:35 -0400 (EDT)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35BB14B19D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2022 20:42:35 -0400 (EDT)
Received: by mail-wr1-f49.google.com with SMTP id q7so21926198wrg.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jun 2022 17:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=xrS17sEQ3fRPRqMXnMRDhd1tVPi2Vsh08gg2EBYpymM=;
 b=SandzrnngwOhRTb7pOv7vDUXRvqY6I+fX26+o4AE+4oTdmUbOSgFO7ZLB+rx1z3A/D
 xV9ISdzwufntSdxLAJVDSJSsY/g1ASXMr+GS9Ep8fv6saHUVZfAID5Y6sMpqLDrZ6+ri
 8DnY1F8gCpDfLb3G9J0S3+A6EiWDuwMmOamclAsFTGps0qCe6xHs+s4QaTBeyZzhvvtd
 xs1nbZ0048cLZuV27n8vhLONuob2ISCzfsahl7H2WWuDMBdZvGFld2a0fq6RyDYfpi2n
 GM9dIiSUT1ll9rIbt5B9ToV1tMRPrwu7j/rrIe5zmemKTTII4nDov62UIwXsQSFMGmQ5
 hf4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=xrS17sEQ3fRPRqMXnMRDhd1tVPi2Vsh08gg2EBYpymM=;
 b=XkAvF411Sqoq6IckxI/RPAJHHMEQvHggEVYRifxzHXfqRx2b4SNktcZ8joz38mlD9m
 Manp1cp0VvMSRCuZGyue1YqHedFofynxOfPkg82TYm7IFU6PrN1wE0l06e11VlEAsGTK
 utcQw08YbocNlJpGjZqGOGw/QylZuFZQdRm4oC1AwRy9JzRV5Yyt3EalEOQUyrk4Cl2c
 /NUFi6WsgUtXa+r0NftrCPM/jMHRyDQVkz7nseub2oMus/D2VI7hBIE/Is09vspsk26e
 6ieiwkNKYI229AyaBpyR/Hoxu7qalpioAxfuyaLjOumUYGKx8KZ9CjaV+A7z5MrkxiNn
 jDrg==
X-Gm-Message-State: AOAM532PjHVJjNMr38+6wmaVg8zLaM8+YsSyIfvnafGrvnWqdrERJVNN
 LTFKXgSL4c8QjR1gYKZANQW6SLzo4OXlRiFJ6HfMhw==
X-Google-Smtp-Source: ABdhPJycltbOTsL7TkxiF885x5QthonQlvgpxJIZFOu+1GRjvPzN5Kl98cntZbpqNcd7ixaTx3UK+BqqMjFqf1qFZU4=
X-Received: by 2002:a5d:4b10:0:b0:213:5e0:2c6c with SMTP id
 v16-20020a5d4b10000000b0021305e02c6cmr23787190wrq.126.1654562553942; Mon, 06
 Jun 2022 17:42:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-60-will@kernel.org>
In-Reply-To: <20220519134204.5379-60-will@kernel.org>
From: Peter Collingbourne <pcc@google.com>
Date: Mon, 6 Jun 2022 17:42:22 -0700
Message-ID: <CAMn1gO7Gs8YUEv9Gx8qakedGNwFVgt9i+X+rjw50uc7YGMhpEQ@mail.gmail.com>
Subject: Re: [PATCH 59/89] KVM: arm64: Do not support MTE for protected VMs
To: Will Deacon <will@kernel.org>
X-Mailman-Approved-At: Tue, 07 Jun 2022 07:12:43 -0400
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

On Thu, May 19, 2022 at 7:40 AM Will Deacon <will@kernel.org> wrote:
>
> From: Fuad Tabba <tabba@google.com>
>
> Return an error (-EINVAL) if trying to enable MTE on a protected
> vm.
>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/arm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 10e036bf06e3..8a1b4ba1dfa7 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -90,7 +90,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                 break;
>         case KVM_CAP_ARM_MTE:
>                 mutex_lock(&kvm->lock);
> -               if (!system_supports_mte() || kvm->created_vcpus) {
> +               if (!system_supports_mte() ||
> +                   kvm_vm_is_protected(kvm) ||

Should this check be added to kvm_vm_ioctl_check_extension() as well?

Peter
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
