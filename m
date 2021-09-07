Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 619C6C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 12:58:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C0D79610C9
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 12:58:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C0D79610C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42C1A4A198;
	Tue,  7 Sep 2021 08:58:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CM6aUYC3rAlc; Tue,  7 Sep 2021 08:58:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23FE44005D;
	Tue,  7 Sep 2021 08:58:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 937C74B1FE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 08:58:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xx7EWqEWNS7p for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 08:58:53 -0400 (EDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E2EF4B1FC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 08:58:53 -0400 (EDT)
Received: by mail-wr1-f44.google.com with SMTP id x6so14256245wrv.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 05:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=5900lkAEZ/6L9YX3yLKrRhWB8KnYm9l4XpxD5QVCI4Q=;
 b=iffw1HPOAcXeLtwO1sVuWL968Mdc83wMBs5ozkWh4VCd+fsYuUhBqYm6jXqTfFwy46
 Sdt3/+kwMKEzOE2QdpUMnCZv3oU6ZLSApxIor7q6RqRO/Uxus9IEPawyDi7CZcG6NcAE
 wXrPcfEtSLNPqmPKHG2Ulw0Q79UGb2T/zBWFsXLtrOJsDEatNjJHsajKQEaR/jqajxNq
 Ou1R/fpHVu5gCdJ2aYDHl+wV0OcMtsH3jaRktHM8oajEdKGu+wf7AKeEXVkKhPXH3Wr+
 tu9KzjqW+wdl5kKKLOUUnmWpnHJggKY1ZuWQuUNIVUmgsi6fCwu2xNpWeDmjapICFI6e
 sLdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=5900lkAEZ/6L9YX3yLKrRhWB8KnYm9l4XpxD5QVCI4Q=;
 b=AyrewYSltpRF5xZe6awR1VGYtzdThRjB47GZlfU6MPYK2JbjB371WqiciAH2d2e7Qi
 WisuqCd7dBs7ki9sJGnWSIAPK1MmET66E889EBdcckr1+fi/54iWP4DQUn01eFqe9X12
 LL+9xqhHjyeOcquKJWZT3ghot+otG5+cs9ocUqhME9SflJmca0eXjQwrFrU8MeedVYlz
 prhLoOEcTBSlGZ5Fdd8ved9kMOqQoZvEj5wTD8Xft+W6UeY2UJaXFwL/dhE/82bI18Mb
 bzoHr1i33TKt5FACcdhJ9695QllbxWXEMVHvW0QtYpGrXd+PSRczeh6y5xQFF1P6X4Ep
 DnIQ==
X-Gm-Message-State: AOAM532rpuKtVrrmMrIpgOZ7LXyTi58SnUHsKh6kdQt4pnFIZQfD5fv6
 VettUc61YYde+iiLju/3c7GnEZsvCzPaWsi2yHryyQ==
X-Google-Smtp-Source: ABdhPJyNz9w2xmO4gIGLIjfbsUDdHaw1SCa+g2bW1eVJgnkhUG69BUTuOpNo1cqP8VgHPCzIr+O6woJiQJA3q6jZoNU=
X-Received: by 2002:adf:fb91:: with SMTP id a17mr18062264wrr.376.1631019532386; 
 Tue, 07 Sep 2021 05:58:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210822144441.1290891-1-maz@kernel.org>
 <20210822144441.1290891-3-maz@kernel.org>
In-Reply-To: <20210822144441.1290891-3-maz@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 7 Sep 2021 13:58:03 +0100
Message-ID: <CAFEAcA9=SJd52ZEQb0gyW+2q9md4KMnLy8YsME-Mkd-AbvV41Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] hw/arm/virt: Honor highmem setting when computing
 highest_gpa
To: Marc Zyngier <maz@kernel.org>
Cc: kvm-devel <kvm@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>,
 Android Kernel Team <kernel-team@android.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Sun, 22 Aug 2021 at 15:45, Marc Zyngier <maz@kernel.org> wrote:
>
> Even when the VM is configured with highmem=off, the highest_gpa
> field includes devices that are above the 4GiB limit, which is
> what highmem=off is supposed to enforce. This leads to failures
> in virt_kvm_type() on systems that have a crippled IPA range,
> as the reported IPA space is larger than what it should be.
>
> Instead, honor the user-specified limit to only use the devices
> at the lowest end of the spectrum.
>
> Note that this doesn't affect memory, which is still allowed to
> go beyond 4GiB with highmem=on configurations.
>
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 81eda46b0b..bc189e30b8 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1598,7 +1598,7 @@ static uint64_t virt_cpu_mp_affinity(VirtMachineState *vms, int idx)
>  static void virt_set_memmap(VirtMachineState *vms)
>  {
>      MachineState *ms = MACHINE(vms);
> -    hwaddr base, device_memory_base, device_memory_size;
> +    hwaddr base, device_memory_base, device_memory_size, ceiling;
>      int i;
>
>      vms->memmap = extended_memmap;
> @@ -1625,7 +1625,7 @@ static void virt_set_memmap(VirtMachineState *vms)
>      device_memory_size = ms->maxram_size - ms->ram_size + ms->ram_slots * GiB;
>
>      /* Base address of the high IO region */
> -    base = device_memory_base + ROUND_UP(device_memory_size, GiB);
> +    ceiling = base = device_memory_base + ROUND_UP(device_memory_size, GiB);
>      if (base < device_memory_base) {
>          error_report("maxmem/slots too huge");
>          exit(EXIT_FAILURE);
> @@ -1642,7 +1642,11 @@ static void virt_set_memmap(VirtMachineState *vms)
>          vms->memmap[i].size = size;
>          base += size;
>      }
> -    vms->highest_gpa = base - 1;
> +    if (vms->highmem) {
> +           /* If we have highmem, move the IPA limit to the top */
> +           ceiling = base;
> +    }
> +    vms->highest_gpa = ceiling - 1;

This doesn't look right to me. If highmem is false and the
high IO region would be above the 4GB mark then we should not
create the high IO region at all, surely? This code looks like
it goes ahead and puts the high IO region above 4GB and then
lies in the highest_gpa value about what the highest used GPA is.

-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
