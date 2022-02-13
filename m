Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C84C433F5
	for <kvmarm@archiver.kernel.org>; Sun, 13 Feb 2022 18:36:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCA034B091;
	Sun, 13 Feb 2022 13:36:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4GM0TVorRT2N; Sun, 13 Feb 2022 13:36:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A78C49ECA;
	Sun, 13 Feb 2022 13:36:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2189D408F4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 00:05:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a-wpgTjhVEur for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Feb 2022 00:05:39 -0500 (EST)
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com
 [209.85.210.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 432AB404FA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 00:05:39 -0500 (EST)
Received: by mail-pf1-f174.google.com with SMTP id z16so1620882pfh.3
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Feb 2022 21:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :references:from:cc:in-reply-to:content-transfer-encoding;
 bh=SvASqGw57nnd+VLnYfU88dyRPvfuj1Dziis/gpDvPDQ=;
 b=XBfoxrRuIu3fmcbhjJ9kr7VMkCaBcJPqOurHmRK/FiCs/ms8WaQX1+mimEBoUIpFTy
 xJbVxkqyJGJ+3UaCl4oKwzFlzG9jWw5b1pRVl2DvbkLXt03ATv+tkT6D1Dpp0xtWy8xv
 G/w5f5rX2k0b2B82um9zrqxd9V3zkCE+/AiXXRm+uP0S7fTIPQVH6S1pVpdsAYSvtmCf
 lo3U4Guzx78b+GBEBIboxzMUhDuEKvceAKQ6rXaYq6Xw5WUPmZyzrQhI3aq0IwY4C3x+
 kXP3BMcSfvyqPG/yUZpOrSqvpzoywuA8txl+CJiOghHDWc9QTtX3iOZOoh62DGcofK60
 uJIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:references:from:cc:in-reply-to
 :content-transfer-encoding;
 bh=SvASqGw57nnd+VLnYfU88dyRPvfuj1Dziis/gpDvPDQ=;
 b=S2Mqhe/yeBasQv9bWOU1oe0OFZ83I6zzArdRg1iao3EFx35vCzvul5yLgulqhrYwWa
 vVZVZgifiNxbHR6hjvfRH5+CEBRaLsFWJ9jUz30T8avWfo3uLsWTbH5JNBtoux8+t53w
 82Xh487Q3gyLkfKKb7MSJxvpba2D/XSXyU0EJ195qKZ/hCFmF5+2y5LMRbO0VfvVcjf3
 Xk/teAPV4h3s9xmVwNe8pXlKokLRYym0eH0LYlCyMl0QBPH8r2Ks3W8rx15jSzI3xKXs
 XlIOnHji/k5oqT23F8p0vnEzB2TVkAm+/8QPk/FvwfjTdJdp0OelVYIr9zIpynwx8FuA
 M+gA==
X-Gm-Message-State: AOAM53116GZPPD216RSonNg6uzwWC0AAU3ohHn7BxossVHt6/fsPMAlx
 3l+t/qlVNzUCyfJXID40vn2eXBPpKPA=
X-Google-Smtp-Source: ABdhPJyB1aKZywkCHJZjJmET0O2A221R61VkLCC7y5fqq25Y8mxu103Gzp1+U5B1a7FbncablDHLaQ==
X-Received: by 2002:a05:6a00:98e:: with SMTP id
 u14mr8601475pfg.12.1644728738382; 
 Sat, 12 Feb 2022 21:05:38 -0800 (PST)
Received: from [192.168.66.3] (p912131-ipoe.ipoe.ocn.ne.jp. [153.243.13.130])
 by smtp.gmail.com with ESMTPSA id
 l8sm34061282pfc.187.2022.02.12.21.05.35
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 12 Feb 2022 21:05:37 -0800 (PST)
Message-ID: <3f4f5e98-fcb8-bf4d-e464-6ad365af92f8@gmail.com>
Date: Sun, 13 Feb 2022 14:05:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PULL 18/38] hw/arm/virt: Honor highmem setting when computing
 the memory map
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
References: <20220120123630.267975-1-peter.maydell@linaro.org>
 <20220120123630.267975-19-peter.maydell@linaro.org>
From: Akihiko Odaki <akihiko.odaki@gmail.com>
In-Reply-To: <20220120123630.267975-19-peter.maydell@linaro.org>
X-Mailman-Approved-At: Sun, 13 Feb 2022 13:36:01 -0500
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2022/01/20 21:36, Peter Maydell wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> Even when the VM is configured with highmem=off, the highest_gpa
> field includes devices that are above the 4GiB limit.
> Similarily, nothing seem to check that the memory is within
> the limit set by the highmem=off option.
> 
> This leads to failures in virt_kvm_type() on systems that have
> a crippled IPA range, as the reported IPA space is larger than
> what it should be.
> 
> Instead, honor the user-specified limit to only use the devices
> at the lowest end of the spectrum, and fail if we have memory
> crossing the 4GiB limit.
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Message-id: 20220114140741.1358263-4-maz@kernel.org
> Signed-off-by: Peter Maydell <peter.maydell@linaro.org>
> ---
>   hw/arm/virt.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 62bdce1eb4b..3b839ba78ba 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1670,7 +1670,7 @@ static uint64_t virt_cpu_mp_affinity(VirtMachineState *vms, int idx)
>   static void virt_set_memmap(VirtMachineState *vms)
>   {
>       MachineState *ms = MACHINE(vms);
> -    hwaddr base, device_memory_base, device_memory_size;
> +    hwaddr base, device_memory_base, device_memory_size, memtop;
>       int i;
>   
>       vms->memmap = extended_memmap;
> @@ -1697,7 +1697,11 @@ static void virt_set_memmap(VirtMachineState *vms)
>       device_memory_size = ms->maxram_size - ms->ram_size + ms->ram_slots * GiB;
>   
>       /* Base address of the high IO region */
> -    base = device_memory_base + ROUND_UP(device_memory_size, GiB);
> +    memtop = base = device_memory_base + ROUND_UP(device_memory_size, GiB);
> +    if (!vms->highmem && memtop > 4 * GiB) {
> +        error_report("highmem=off, but memory crosses the 4GiB limit\n");
> +        exit(EXIT_FAILURE);
> +    }
>       if (base < device_memory_base) {
>           error_report("maxmem/slots too huge");
>           exit(EXIT_FAILURE);
> @@ -1714,7 +1718,7 @@ static void virt_set_memmap(VirtMachineState *vms)
>           vms->memmap[i].size = size;
>           base += size;
>       }
> -    vms->highest_gpa = base - 1;
> +    vms->highest_gpa = (vms->highmem ? base : memtop) - 1;
>       if (device_memory_size > 0) {
>           ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>           ms->device_memory->base = device_memory_base;

Hi,
This breaks in a case where highmem is disabled but can have more than 4 
GiB of RAM. M1 (Apple Silicon) actually can have 36-bit PA with HVF, 
which is not enough for highmem MMIO but is enough to contain 32 GiB of RAM.

Where the magic number of 4 GiB / 32-bit came from? I also don't quite 
understand what failures virt_kvm_type() had.

Regards,
Akihiko Odaki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
