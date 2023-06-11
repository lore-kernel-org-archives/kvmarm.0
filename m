Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD2333F1
	for <kvmarm@lists.linux.dev>; Sun, 11 Jun 2023 16:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686500900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9vmYekSpS02whsTld5Bdgst4soFOJdPas4Z/h+dfoe0=;
	b=P7WgA/p0f6kQ3iGfewom2l7L8nIB5XQvk1KwMUH0/J9vSZZGYBnBKuu+n+35+Spoby6yRv
	LYZkKd0Wnnz2Mc9TSo1c37TKFFrfWeocu5dVhiXcalBkLFgEen66Pro4xV8Crohyk5CUo2
	Cw6kEyoDYEj3KpUu8BiqzwWtrVNyrF0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-RNkaxwPhMNKMfEBYU2b-pw-1; Sun, 11 Jun 2023 12:28:18 -0400
X-MC-Unique: RNkaxwPhMNKMfEBYU2b-pw-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6261e50ee78so50662466d6.3
        for <kvmarm@lists.linux.dev>; Sun, 11 Jun 2023 09:28:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686500898; x=1689092898;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9vmYekSpS02whsTld5Bdgst4soFOJdPas4Z/h+dfoe0=;
        b=JsV/Zuo3WBVHOtEIsFX4CNCgWtqmAF8CBu+2u4iGw7nk3M2sQ3zzjhd3TKAvXGWI2m
         DGS5IpbGKbj3e/wznpvXpdE92S1iom2o8T6JwcxW8zQG+4AVCeQxK9u2B813GQp52alj
         LfoL4cO8zqM6jsftuzVzx8+uKgqOklvzr7YrmQ10tdDVXfnfS7e2/+lMQ5RJBKx0nDpw
         1aSJy4aQxivZxG5lffvChkiBIJQm5uFe546dTXAIRYKgqIwVOS80iEdIyYhWPSFOLJUc
         4SdPcNm096/o0tOxz0n7hiAiFeup7Ui25smXueJzYAHHLJ/EwIXGB7KP9SoOV2fVhM+z
         nAAg==
X-Gm-Message-State: AC+VfDwvHwBb4vYAlo2rp/Rt6Pzz7UgLhaV2YGjO4+RtKA3/SbFqh/Yu
	WAIk0F7D9EiuXwmdrCYSw4Wt70PdiRRqrn6EaOMnP9CMdx+dsg8ZCTCHIt88jUgOzvWzzqs+Sw1
	FYX8hR5y7GV3Ub/SQ
X-Received: by 2002:a05:6214:2606:b0:62d:ec9b:ccdc with SMTP id gu6-20020a056214260600b0062dec9bccdcmr544961qvb.26.1686500898096;
        Sun, 11 Jun 2023 09:28:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6/MgWv7Up3SZbfYqsEot/VfyX/cb8KRnptNWO7bNDaXA/kYumepG04T97SGTXJ1wTaF1I0ug==
X-Received: by 2002:a05:6214:2606:b0:62d:ec9b:ccdc with SMTP id gu6-20020a056214260600b0062dec9bccdcmr544948qvb.26.1686500897846;
        Sun, 11 Jun 2023 09:28:17 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id pv9-20020ad45489000000b0062de51d8a12sm626087qvb.26.2023.06.11.09.28.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jun 2023 09:28:17 -0700 (PDT)
Message-ID: <7e404568-0ddb-4c39-9421-488f852df29a@redhat.com>
Date: Sun, 11 Jun 2023 18:28:12 +0200
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
To: Miguel Luis <miguel.luis@oracle.com>
Cc: Marc Zyngier <maz@kernel.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>, James Morse
 <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <16d9fda4-3ead-7d5e-9f54-ef29fbd932ac@redhat.com>
 <87zg64nhqh.wl-maz@kernel.org>
 <d0b77823-c04c-4ee0-cb55-2cc20a48903b@redhat.com>
 <86r0rfkpwd.wl-maz@kernel.org>
 <bdcf630c-b6a7-0649-8419-15f98f6b1a0c@redhat.com>
 <054769EB-0722-45FB-8670-23CC7915AAA9@oracle.com>
 <14268e71-686d-9c51-901b-6985ad91537f@redhat.com>
 <580B5BEE-3D59-414C-B780-6115952AF183@oracle.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <580B5BEE-3D59-414C-B780-6115952AF183@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Miguel,

On 6/10/23 10:25, Miguel Luis wrote:
> Hi Eric,
> 
>> On 7 Jun 2023, at 16:40, Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Miguel,
>>
>> On 6/6/23 19:52, Miguel Luis wrote:
>>> Hello Eric, Marc,
>>>
>>>> On 6 Jun 2023, at 09:33, Eric Auger <eauger@redhat.com> wrote:
>>>>
>>>> Hi Marc,
>>>>
>>>> On 5/17/23 16:12, Marc Zyngier wrote:
>>>>> On Wed, 17 May 2023 09:59:45 +0100,
>>>>> Eric Auger <eauger@redhat.com> wrote:
>>>>>>
>>>>>> Hi Marc,
>>>>>> Hi Marc,
>>>>>> On 5/16/23 22:28, Marc Zyngier wrote:
>>>>>>> On Tue, 16 May 2023 17:53:14 +0100,
>>>>>>> Eric Auger <eauger@redhat.com> wrote:
>>>>>>>>
>>>>>>>> Hi Marc,
>>>>>>>>
>>>>>>>> On 5/15/23 19:30, Marc Zyngier wrote:
>>>>>>>>> This is the 4th drop of NV support on arm64 for this year.
>>>>>>>>>
>>>>>>>>> For the previous episodes, see [1].
>>>>>>>>>
>>>>>>>>> What's changed:
>>>>>>>>>
>>>>>>>>> - New framework to track system register traps that are reinjected in
>>>>>>>>> guest EL2. It is expected to replace the discrete handling we have
>>>>>>>>> enjoyed so far, which didn't scale at all. This has already fixed a
>>>>>>>>> number of bugs that were hidden (a bunch of traps were never
>>>>>>>>> forwarded...). Still a work in progress, but this is going in the
>>>>>>>>> right direction.
>>>>>>>>>
>>>>>>>>> - Allow the L1 hypervisor to have a S2 that has an input larger than
>>>>>>>>> the L0 IPA space. This fixes a number of subtle issues, depending on
>>>>>>>>> how the initial guest was created.
>>>>>>>>>
>>>>>>>>> - Consequently, the patch series has gone longer again. Boo. But
>>>>>>>>> hopefully some of it is easier to review...
>>>>>>>>>
>>>>>>>>> [1] https://lore.kernel.org/r/20230405154008.3552854-1-maz@kernel.org
>>>>>>>>
>>>>>>>> I have started testing this and when booting my fedora guest I get
>>>>>>>>
>>>>>>>> [  151.796544] kvm [7617]: Unsupported guest sys_reg access at:
>>>>>>>> 23f425fd0 [80000209]
>>>>>>>> [  151.796544]  { Op0( 3), Op1( 3), CRn(14), CRm( 3), Op2( 1), func_write },
>>>>>>>>
>>>>>>>> as soon as the host has kvm-arm.mode=nested
>>>>>>>>
>>>>>>>> This seems to be triggered very early by EDK2
>>>>>>>> (ArmPkg/Drivers/TimerDxe/TimerDxe.c).
>>>>>>>>
>>>>>>>> If I am not wrong this CNTV_CTL_EL0. Do you have any idea?
>>>>>>>
>>>>>>> So here's my current analysis:
>>>>>>>
>>>>>>> I assume you are running EDK2 as the L1 guest in a nested
>>>>>>> configuration. I also assume that you are not running on an Apple
>>>>>>> CPU. If these assumptions are correct, then EDK2 runs at vEL2, and is
>>>>>>> in nVHE mode.
>>>>>>>
>>>>>>> Finally, I'm going to assume that your implementation has FEAT_ECV and
>>>>>>> FEAT_NV2, because I can't see how it could fail otherwise.
>>>>>> all the above is correct.
>>>>>>>
>>>>>>> In these precise conditions, KVM sets the CNTHCTL_EL2.EL1TVT bit so
>>>>>>> that we can trap the EL0 virtual timer and faithfully emulate it (it
>>>>>>> is otherwise written to memory, which isn't very helpful).
>>>>>>
>>>>>> indeed
>>>>>>>
>>>>>>> As it turns out, we don't handle these traps. I didn't spot it because
>>>>>>> my test machines are all Apple boxes that don't have a nVHE mode, so
>>>>>>> nothing on the nVHE path is getting *ANY* coverage. Hint: having
>>>>>>> access to such a machine would help (shipping address on request!).
>>>>>>> Otherwise, I'll eventually kill the nVHE support altogether.
>>>>>>>
>>>>>>> I have written the following patch, which compiles, but that I cannot
>>>>>>> test with my current setup. Could you please give it a go?
>>>>>>
>>>>>> with the patch below, my guest boots nicely. You did it great on the 1st
>>>>>> shot!!! So this fixes my issue. I will continue testing the v10.
>>>>>
>>>>> Thanks a lot for reporting the issue and testing my hacks. I'll
>>>>> eventually fold it into the rest of the series.
>>>>>
>>>>> By the way, what are you using as your VMM? I'd really like to
>>>>> reproduce your setup.
>>>> Sorry I missed your reply. I am using libvirt + qemu (feat Miguel's RFC)
>>>> and fedora L1 guest.
>>>>
>>>
>>> Following this subject, I’ve forward ported Alexandru’s KUT patches
>>> ( and I encourage others to do it also =) ) which expose an EL2 test that
>>
>> Do you have a branch available with Alexandru's rebased kut series?
> 
> Now I do :)
> 
> https://github.com/mluis/kvm-unit-tests/tree/nv-WIP

Cool, thanks!

Eric
> 
> Thanks,
> Miguel
> 
>>
>> Thanks
>>
>> Eric
>>> does three checks:
>>>
>>> - whether VHE is supported and enabled
>>> - disable VHE
>>> - re-enable VHE  
>>>
>>> I’m running qemu with virtualization=on as well to run this test and it is passing although
>>> problems seem to happen when running with virtualization=off, which I’m still looking into it.
>>>
>>> Thanks
>>> Miguel
>>>
>>>> Thanks to your fix, this boots fine. But at the moment it does not
>>>> reboot and hangs in edk2 I think. Unfortunately this time I have no
>>>> trace on host :-( While looking at your series I will add some traces.
>>>>
>>>> Eric
>>>>>
>>>>> Cheers,
>>>>>
>>>>> M.
> 
> 

