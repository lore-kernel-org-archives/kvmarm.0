Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C96C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 10:11:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 47EE46128A
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 10:11:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 47EE46128A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEE104B287;
	Mon,  4 Oct 2021 06:11:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0h8HP3DYDVdd; Mon,  4 Oct 2021 06:11:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 392E74B262;
	Mon,  4 Oct 2021 06:11:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB3EA4B201
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 06:11:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TUnEVHrtx4Gt for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 06:11:17 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2AA84B1F5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 06:11:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633342277;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=7vrwkiYNmH9gme5GZD+IE0TvO4gorlXeNfmKqQOUQ2A=;
 b=bwAiiJZQN5s9tNPHe2/CaqU6mh3D2P/ZRMzmIK7N7bxnnvJkMJnTzlXGb70TNPQ4ricO3/
 P3RXGvIDAW6bHpP53QdrShIWRwcK6IxT/QPnX32R04tBg1J9rCmeodQE8V0RCuU4dpU3Dc
 wEAYzxmrq/lm2qKaaUDmEP2E3+wfY1o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-Z3ksWDhLNvGPHmuARftRTg-1; Mon, 04 Oct 2021 06:11:13 -0400
X-MC-Unique: Z3ksWDhLNvGPHmuARftRTg-1
Received: by mail-wm1-f72.google.com with SMTP id
 v5-20020a1cac05000000b0030b85d2d479so7980679wme.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 03:11:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=7vrwkiYNmH9gme5GZD+IE0TvO4gorlXeNfmKqQOUQ2A=;
 b=N8Vjq89sb2KgAyDh0QYUrmpldLdbMWLtzXcWJaeCXIqKOn2toJgiGyOWsi7qxgW0wn
 uOKP9kww+Qz578yfG94LoY3ekVGchIuaxF3A38+Y9BoDiQMkWWTatCagFnU4APWaPlZc
 dhWdqto+JcWNqfveBan5RSE6F9DKw4j7DyjUYX2iUxjYbEWNCzgiuO7+raBNojYkFUaw
 Bh4hHY2nO0EtIjXxMvS55reiW8Pvt88XsjfK/MyMLE6Fxc1pAv2/A3udwFft2vUR4AX+
 OThzNekk2S7sqNrznvVd8d3Vb0xMqKSQvPFWikJELhtEr671+OMHNWMs3Ij8OV6DWb8o
 q9fQ==
X-Gm-Message-State: AOAM533PVpGK3bTRrukDV0ICXd9b6NeleXbmqjaiFPDdcNF9HZ3WJaif
 +IYYZ9/0qXgmjD6pLgayN1qadcWvAFcyL24UR5KoDAyp/hOjJpuhBgFoW3dwiRoIyRbEy5xsaDg
 vL84CSOzP3Pu3KQ9/D48ff/hB
X-Received: by 2002:adf:a30b:: with SMTP id c11mr12974078wrb.289.1633342272551; 
 Mon, 04 Oct 2021 03:11:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzq2FZ3CpAT5XH1tlJ1e5mgY4TiPIO/pbY6WYKk/ugWs9aFSuDXGQ1ktJJSgRf+gzBqButoyw==
X-Received: by 2002:adf:a30b:: with SMTP id c11mr12974021wrb.289.1633342272059; 
 Mon, 04 Oct 2021 03:11:12 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id t11sm13810480wrz.65.2021.10.04.03.11.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Oct 2021 03:11:11 -0700 (PDT)
Date: Mon, 4 Oct 2021 12:11:10 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 4/5] hw/arm/virt: Use the PA range to compute the
 memory map
Message-ID: <20211004101110.imtfcufnrdwhneev@gator>
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-5-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211003164605.3116450-5-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Sun, Oct 03, 2021 at 05:46:04PM +0100, Marc Zyngier wrote:
> The highmem attribute is nothing but another way to express the
> PA range of a VM. To support HW that has a smaller PA range then
> what QEMU assumes, pass this PA range to the virt_set_memmap()
> function, allowing it to correctly exclude highmem devices
> if they are outside of the PA range.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt.c | 46 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 35 insertions(+), 11 deletions(-)
> 
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 9d2abdbd5f..a572e0c9d9 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1610,10 +1610,10 @@ static uint64_t virt_cpu_mp_affinity(VirtMachineState *vms, int idx)
>      return arm_cpu_mp_affinity(idx, clustersz);
>  }
>  
> -static void virt_set_memmap(VirtMachineState *vms)
> +static void virt_set_memmap(VirtMachineState *vms, int pa_bits)
>  {
>      MachineState *ms = MACHINE(vms);
> -    hwaddr base, device_memory_base, device_memory_size;
> +    hwaddr base, device_memory_base, device_memory_size, memtop;
>      int i;
>  
>      vms->memmap = extended_memmap;
> @@ -1628,9 +1628,12 @@ static void virt_set_memmap(VirtMachineState *vms)
>          exit(EXIT_FAILURE);
>      }
>  
> -    if (!vms->highmem &&
> -        vms->memmap[VIRT_MEM].base + ms->maxram_size > 4 * GiB) {
> -        error_report("highmem=off, but memory crosses the 4GiB limit\n");
> +    if (!vms->highmem)
> +	    pa_bits = 32;
> +
> +    if (vms->memmap[VIRT_MEM].base + ms->maxram_size > BIT_ULL(pa_bits)) {
> +	    error_report("Addressing limited to %d bits, but memory exceeds it by %llu bytes\n",
> +			 pa_bits, vms->memmap[VIRT_MEM].base + ms->maxram_size - BIT_ULL(pa_bits));
>          exit(EXIT_FAILURE);
>      }
>      /*
> @@ -1645,7 +1648,7 @@ static void virt_set_memmap(VirtMachineState *vms)
>      device_memory_size = ms->maxram_size - ms->ram_size + ms->ram_slots * GiB;
>  
>      /* Base address of the high IO region */
> -    base = device_memory_base + ROUND_UP(device_memory_size, GiB);
> +    memtop = base = device_memory_base + ROUND_UP(device_memory_size, GiB);
>      if (base < device_memory_base) {
>          error_report("maxmem/slots too huge");
>          exit(EXIT_FAILURE);
> @@ -1662,9 +1665,17 @@ static void virt_set_memmap(VirtMachineState *vms)
>          vms->memmap[i].size = size;
>          base += size;
>      }
> -    vms->highest_gpa = (vms->highmem ?
> -                        base :
> -                        vms->memmap[VIRT_MEM].base + ms->maxram_size) - 1;
> +
> +    /*
> +     * If base fits within pa_bits, all good. If it doesn't, limit it
> +     * to the end of RAM, which is guaranteed to fit within pa_bits.

We tested that

  vms->memmap[VIRT_MEM].base + ms->maxram_size

fits within pa_bits, but here we're setting highest_gpa to

  ROUND_UP(vms->memmap[VIRT_MEM].base + ms->ram_size, GiB) +
  ROUND_UP(ms->maxram_size - ms->ram_size + ms->ram_slots * GiB, GiB)

which will be larger. Shouldn't we test memtop instead to make this
guarantee?


> +     */
> +    if (base <= BIT_ULL(pa_bits)) {
> +        vms->highest_gpa = base -1;
> +    } else {
> +        vms->highest_gpa = memtop - 1;
> +    }
> +
>      if (device_memory_size > 0) {
>          ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>          ms->device_memory->base = device_memory_base;
> @@ -1860,7 +1871,20 @@ static void machvirt_init(MachineState *machine)
>       * to create a VM with the right number of IPA bits.
>       */
>      if (!vms->memmap) {
> -        virt_set_memmap(vms);
> +        ARMCPU *armcpu = ARM_CPU(first_cpu);


I think it's too early to use first_cpu here (although, I'll admit I'm
always confused as to what gets initialized when...) Assuming we need to
realize the cpus first, then we don't do that until a bit further down
in this function. I wonder if it's possible to delay this memmap setup
until after cpu realization. I see the memmap getting used prior when
calculating virt_max_cpus, but that looks like it needs to be updated
anyway to take highmem into account as to whether or not we should
consider the high gicv3 redist region in the calculation.

> +        int pa_bits;
> +
> +        if (object_property_get_bool(OBJECT(first_cpu), "aarch64", NULL)) {
> +            pa_bits = arm_pamax(armcpu);
> +        } else if (arm_feature(&armcpu->env, ARM_FEATURE_LPAE)) {
> +            /* v7 with LPAE */
> +            pa_bits = 40;
> +        } else {
> +            /* Anything else */
> +            pa_bits = 32;
> +        }
> +
> +        virt_set_memmap(vms, pa_bits);
>      }
>  
>      /* We can probe only here because during property set
> @@ -2596,7 +2620,7 @@ static int virt_kvm_type(MachineState *ms, const char *type_str)
>      max_vm_pa_size = kvm_arm_get_max_vm_ipa_size(ms, &fixed_ipa);
>  
>      /* we freeze the memory map to compute the highest gpa */
> -    virt_set_memmap(vms);
> +    virt_set_memmap(vms, max_vm_pa_size);
>  
>      requested_pa_size = 64 - clz64(vms->highest_gpa);
>  
> -- 
> 2.30.2
> 

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
