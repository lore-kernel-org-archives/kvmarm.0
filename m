Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FFC8C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jan 2022 15:48:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3C2B4B19A;
	Mon, 10 Jan 2022 10:48:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bfWec7gICzJf; Mon, 10 Jan 2022 10:48:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC8E04B187;
	Mon, 10 Jan 2022 10:48:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1C274B183
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 10:48:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WHqEXcqZiC1h for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 10:48:36 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6B0A4B177
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 10:48:36 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641829716;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=FRh34pLIE/j1S6VXPTEy162SKih2nlk9xawUHYO91Iw=;
 b=DsmFFqZFwgyET2iY+Gb1sFUYp6AJaji6Ca+hSSk0nDlJe94GIoetn6mveQld/OFl3sLaSq
 viga72DATkqqHiQ6+m0tJq74CJjDU2kRiWdJRE/gY/hjmdv8tBCukldFazIlgYWYAxvw3O
 3s1yPSqwDw5gqxCKh1LEhpmrCniXT9Y=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-64mZgJgkP-C0YCUgsMfAyw-1; Mon, 10 Jan 2022 10:48:35 -0500
X-MC-Unique: 64mZgJgkP-C0YCUgsMfAyw-1
Received: by mail-wm1-f69.google.com with SMTP id
 s190-20020a1ca9c7000000b00347c6c39d9aso111832wme.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 07:48:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=FRh34pLIE/j1S6VXPTEy162SKih2nlk9xawUHYO91Iw=;
 b=um3Nsx4nIBnd9WxKS9bbtGkNGaVeUQ39ucPCeumazgj+cNFHM5p7pgt0C6cEWyNOrl
 SRBwgXPF4gc1FBHEq+IAT0xGzdFB/1tchQvLM0u9HVHbA/lV3v00C4ZV06YomKcV5PzZ
 zSsgU6fhe2MWt6G1upZxxvL4X8x0qwLdWqjqgf1fCKSWluEjtNZNIF6Q+ij7zl6Gb/Ml
 UwcpnlTPwUG3hxNcQs9DhGkX3FmS82j9pBkopJkHRSYYioXCY/dSx/AhSBu7bc2+gZ1Z
 BD8jpHrxq2lZA9zCFEb7sKQl2tDLajlvjndObwHA3/L3CLnvCFb70XHbofR/HDrju0sL
 r7ow==
X-Gm-Message-State: AOAM532DCWP8R1U1UQz9MjOsXlNgfAHnRxO1DB2AUZDLrWxlnm4jEYkq
 KB61rzxCu5xExk4ntV4uFebSiDdys9oSDRXK/Rk2fGOrELXrL9dwir95jBJkR4HISjpb2rsnZOE
 /p6DTapVLa+IG0KJAjZWL+GbH
X-Received: by 2002:a05:6000:144c:: with SMTP id
 v12mr220808wrx.266.1641829714356; 
 Mon, 10 Jan 2022 07:48:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJydJ6KvXu0aXm01WZeSn2a0YAfQz/ZkJxslisA/6vpKl4Olp4DRMWEoBlP6JYDRfwXVCFQ3Nw==
X-Received: by 2002:a05:6000:144c:: with SMTP id
 v12mr220793wrx.266.1641829714194; 
 Mon, 10 Jan 2022 07:48:34 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id b14sm6946310wrg.15.2022.01.10.07.48.33
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 10 Jan 2022 07:48:33 -0800 (PST)
Subject: Re: [PATCH v4 2/6] hw/arm/virt: Add a control for the the highmem
 redistributors
To: Marc Zyngier <maz@kernel.org>
References: <20220107163324.2491209-1-maz@kernel.org>
 <20220107163324.2491209-3-maz@kernel.org>
 <448274ac-2650-7c09-742d-584109fb5c56@redhat.com>
 <87k0f7tx17.wl-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <f1d5a00b-b9d1-8e86-acd6-f7a605b77d8b@redhat.com>
Date: Mon, 10 Jan 2022 16:48:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87k0f7tx17.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
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

Hi Marc,

On 1/10/22 4:45 PM, Marc Zyngier wrote:
> Hi Eric,
>
> On Mon, 10 Jan 2022 15:35:44 +0000,
> Eric Auger <eric.auger@redhat.com> wrote:
>> Hi Marc,
>>
>> On 1/7/22 5:33 PM, Marc Zyngier wrote:
> [...]
>
>>> @@ -190,7 +191,8 @@ static inline int virt_gicv3_redist_region_count(VirtMachineState *vms)
>>>  
>>>      assert(vms->gic_version == VIRT_GIC_VERSION_3);
>>>  
>>> -    return MACHINE(vms)->smp.cpus > redist0_capacity ? 2 : 1;
>>> +    return (MACHINE(vms)->smp.cpus > redist0_capacity &&
>>> +            vms->highmem_redists) ? 2 : 1;
>> If we fail to use the high redist region, is there any check that the
>> number of vcpus does not exceed the first redist region capacity.
>> Did you check that config, does it nicely fail?
> I did, and it does (example on M1 with KVM):
>
> $ /home/maz/vminstall/qemu-hack -m 1G -smp 256 -cpu host -machine virt,accel=kvm,gic-version=3,highmem=on -nographic -drive if=pflash,format=raw,readonly=on,file=/usr/share/AAVMF/AAVMF_CODE.fd
> qemu-hack: warning: Number of SMP cpus requested (256) exceeds the recommended cpus supported by KVM (8)
> qemu-hack: warning: Number of hotpluggable cpus requested (256) exceeds the recommended cpus supported by KVM (8)
> qemu-hack: Capacity of the redist regions(123) is less than number of vcpus(256)

OK perfect!

Eric
>
> Thanks,
>
> 	M.
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
