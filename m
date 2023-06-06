Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F902125AB
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 09:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686044014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NfCVlNZr5FMM7IYZiy0Efi0L7IH3DzTFtcUbvK87ioM=;
	b=d2pXKN9m1YM1xDrlHUYZ2LBo+kKBceAjWJ6MldiJDtGO6e27h4/a0p/yGnmmYvcZ9Au4vk
	k0szG4jM4JgNitoHSAabDdsSawUx+TaLRlWM0DqD2NqpWIKDR3i3RojoFdq8hw489ntsTv
	1Aco0Mth7+PTGBx0O0WR0SQJS9mhWK0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-vH9w12ayO-SWFkBpH72oPw-1; Tue, 06 Jun 2023 05:33:33 -0400
X-MC-Unique: vH9w12ayO-SWFkBpH72oPw-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-3f7f713eeb0so89263881cf.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Jun 2023 02:33:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686044013; x=1688636013;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NfCVlNZr5FMM7IYZiy0Efi0L7IH3DzTFtcUbvK87ioM=;
        b=lw8RV/7kAbYWrKGYQjvpWAPeIs+vpPc0r+L7Y3+BheoC6CnjPveD2K7XnntB6zuXbK
         NvOAHj5IeTQW/TVADcXBXeR8EzFlfLlH063TvzLKu7cORB1rS1bg1ghdU3miZlD2EIla
         D5s667QibS4nsOE8/XoWMm6SgfjNW8tTfQkXqpIczOxgihRtKJ1iylgiMihlkXqz5jJU
         AlL1+jSJJRoi5oqgO6asBknxXZ/Aa26Rwnc+pjNl03r2Dbxm04KQLh3chORqJc9B12lk
         e+SyUUOzb0ZcrkA+4kF90ZIvJumumlfsPJlpraSMoXYLoevYZ6gFeEt/+yuSw4V/b/F4
         tGrQ==
X-Gm-Message-State: AC+VfDwj36s+LgwfrJrCCqi+lJOnAN6gOKPa1cMtRPadrN6ISeABSO5U
	NcLXvE6CEQP22Fh3Vfk1jpSLYYMU10eslYZ2S0mkhaDqDPr8xMhDwhAupAWVSysfyRb4hfXZYn4
	foFdVCIiVyVQptMJz
X-Received: by 2002:ac8:7c54:0:b0:3f5:1626:6a3d with SMTP id o20-20020ac87c54000000b003f516266a3dmr1313719qtv.42.1686044012684;
        Tue, 06 Jun 2023 02:33:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5n5fSaR9rhGQJeywpdZviphMffC6+N0hasH8JtAg/z6WKXKQqm2K/P4sycA2R8M1LOqxyk5Q==
X-Received: by 2002:ac8:7c54:0:b0:3f5:1626:6a3d with SMTP id o20-20020ac87c54000000b003f516266a3dmr1313701qtv.42.1686044012476;
        Tue, 06 Jun 2023 02:33:32 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id r12-20020ac85e8c000000b003f9ad6acba4sm634844qtx.79.2023.06.06.02.33.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 02:33:31 -0700 (PDT)
Message-ID: <bdcf630c-b6a7-0649-8419-15f98f6b1a0c@redhat.com>
Date: Tue, 6 Jun 2023 11:33:27 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 00/59] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <16d9fda4-3ead-7d5e-9f54-ef29fbd932ac@redhat.com>
 <87zg64nhqh.wl-maz@kernel.org>
 <d0b77823-c04c-4ee0-cb55-2cc20a48903b@redhat.com>
 <86r0rfkpwd.wl-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <86r0rfkpwd.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 5/17/23 16:12, Marc Zyngier wrote:
> On Wed, 17 May 2023 09:59:45 +0100,
> Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Marc,
>>Hi Marc,
>> On 5/16/23 22:28, Marc Zyngier wrote:
>>> On Tue, 16 May 2023 17:53:14 +0100,
>>> Eric Auger <eauger@redhat.com> wrote:
>>>>
>>>> Hi Marc,
>>>>
>>>> On 5/15/23 19:30, Marc Zyngier wrote:
>>>>> This is the 4th drop of NV support on arm64 for this year.
>>>>>
>>>>> For the previous episodes, see [1].
>>>>>
>>>>> What's changed:
>>>>>
>>>>> - New framework to track system register traps that are reinjected in
>>>>>   guest EL2. It is expected to replace the discrete handling we have
>>>>>   enjoyed so far, which didn't scale at all. This has already fixed a
>>>>>   number of bugs that were hidden (a bunch of traps were never
>>>>>   forwarded...). Still a work in progress, but this is going in the
>>>>>   right direction.
>>>>>
>>>>> - Allow the L1 hypervisor to have a S2 that has an input larger than
>>>>>   the L0 IPA space. This fixes a number of subtle issues, depending on
>>>>>   how the initial guest was created.
>>>>>
>>>>> - Consequently, the patch series has gone longer again. Boo. But
>>>>>   hopefully some of it is easier to review...
>>>>>
>>>>> [1] https://lore.kernel.org/r/20230405154008.3552854-1-maz@kernel.org
>>>>
>>>> I have started testing this and when booting my fedora guest I get
>>>>
>>>> [  151.796544] kvm [7617]: Unsupported guest sys_reg access at:
>>>> 23f425fd0 [80000209]
>>>> [  151.796544]  { Op0( 3), Op1( 3), CRn(14), CRm( 3), Op2( 1), func_write },
>>>>
>>>> as soon as the host has kvm-arm.mode=nested
>>>>
>>>> This seems to be triggered very early by EDK2
>>>> (ArmPkg/Drivers/TimerDxe/TimerDxe.c).
>>>>
>>>> If I am not wrong this CNTV_CTL_EL0. Do you have any idea?
>>>
>>> So here's my current analysis:
>>>
>>> I assume you are running EDK2 as the L1 guest in a nested
>>> configuration. I also assume that you are not running on an Apple
>>> CPU. If these assumptions are correct, then EDK2 runs at vEL2, and is
>>> in nVHE mode.
>>>
>>> Finally, I'm going to assume that your implementation has FEAT_ECV and
>>> FEAT_NV2, because I can't see how it could fail otherwise.
>> all the above is correct.
>>>
>>> In these precise conditions, KVM sets the CNTHCTL_EL2.EL1TVT bit so
>>> that we can trap the EL0 virtual timer and faithfully emulate it (it
>>> is otherwise written to memory, which isn't very helpful).
>>
>> indeed
>>>
>>> As it turns out, we don't handle these traps. I didn't spot it because
>>> my test machines are all Apple boxes that don't have a nVHE mode, so
>>> nothing on the nVHE path is getting *ANY* coverage. Hint: having
>>> access to such a machine would help (shipping address on request!).
>>> Otherwise, I'll eventually kill the nVHE support altogether.
>>>
>>> I have written the following patch, which compiles, but that I cannot
>>> test with my current setup. Could you please give it a go?
>>
>> with the patch below, my guest boots nicely. You did it great on the 1st
>> shot!!! So this fixes my issue. I will continue testing the v10.
> 
> Thanks a lot for reporting the issue and testing my hacks. I'll
> eventually fold it into the rest of the series.
> 
> By the way, what are you using as your VMM? I'd really like to
> reproduce your setup.
Sorry I missed your reply. I am using libvirt + qemu (feat Miguel's RFC)
and fedora L1 guest.

Thanks to your fix, this boots fine. But at the moment it does not
reboot and hangs in edk2 I think. Unfortunately this time I have no
trace on host :-( While looking at your series I will add some traces.

Eric
> 
> Cheers,
> 
> 	M.
> 

