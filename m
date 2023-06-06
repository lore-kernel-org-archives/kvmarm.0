Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601B1125AB
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 09:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686043783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VvVw+wYo/gtmiGwGSDdmcHXZMo6R18G9lGqfmaFlyIc=;
	b=QzhgUE5WqziYoHXADD10paJMORru3Ue0HebMwKu42kV+2rc7VUyci4t0iBiT5QqSv96k1Z
	BzBuoBu+KU6NWMgtpzc0/+k8U0sPalgLpeokq7dfbPDGW1UcsmOGmGoVBRdzKtfZxZnrsk
	Ov5V0BUN1znb+o55jgzMlHoxcqWjUGI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-246-z5SYegqXNce9ZVAaa0eY4w-1; Tue, 06 Jun 2023 05:29:43 -0400
X-MC-Unique: z5SYegqXNce9ZVAaa0eY4w-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-625fd27e074so68064326d6.3
        for <kvmarm@lists.linux.dev>; Tue, 06 Jun 2023 02:29:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686043782; x=1688635782;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VvVw+wYo/gtmiGwGSDdmcHXZMo6R18G9lGqfmaFlyIc=;
        b=CpAYK0Np52+RCh/RR1KIhuWAVZwG1f+FRXPujC86AWIPLD0m7/jir8eVCT8V8VaPnZ
         dz3FGDDslUvBdlbCf6jKVY6dC9kLTkboqwR69Fz/ew05JNy1lQ89FGP/nSuk+JZ1PJG7
         0Qam8rMXKjEYq0K0cPghPaPTCw64fAlgPZj93kD9593/fzJEvg+RiBjfPiSddWGcEThC
         4i6IRsql/RZXueaqQUY/ZDU1kEv8WkXnigGdeMpMaBWPWr4hOUbEg0nqFSDEgw/kBdjm
         sre+eRe2ssbCyNz1DUXN4M3ay+nEenZHRBXELkQSxrwYKHFfVsq/0HaULkQtuRqaP62h
         Gs6g==
X-Gm-Message-State: AC+VfDwiA+BVDcC+6u6FkMUp+FKO5sptZFBjRoJFxe+PVFLiNuigO8mT
	6j+/Q8GGwQK4dLej7sxaLjGFgZGPk94PN5Ei98PA0IGtrwMDkt5zHtZvJ8EsyOYVdjJDy9YpyHK
	tk8jQiz57g0HdUpNz
X-Received: by 2002:ad4:5ae6:0:b0:621:170:68b7 with SMTP id c6-20020ad45ae6000000b00621017068b7mr2000598qvh.35.1686043782478;
        Tue, 06 Jun 2023 02:29:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5WKwmouv2fJWc37kUbEfU577Kxfql4Y418iSiwFMDnsPR2/phC23oilrE3UxHMMSY31bx5IA==
X-Received: by 2002:ad4:5ae6:0:b0:621:170:68b7 with SMTP id c6-20020ad45ae6000000b00621017068b7mr2000569qvh.35.1686043782212;
        Tue, 06 Jun 2023 02:29:42 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id w5-20020a0cc245000000b006260c683bf2sm5253563qvh.53.2023.06.06.02.29.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 02:29:41 -0700 (PDT)
Message-ID: <c46da9eb-a02d-1b1d-9c1b-9f900a5e9e6d@redhat.com>
Date: Tue, 6 Jun 2023 11:29:36 +0200
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
 <9cf2356b-f990-1cd2-c7e6-a984e9f604c6@redhat.com>
 <87r0qpnj2t.wl-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <87r0qpnj2t.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,
On 6/6/23 09:30, Marc Zyngier wrote:
> Hey Eric,
> 
> On Mon, 05 Jun 2023 12:28:12 +0100,
> Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Marc,
>>
>> On 5/15/23 19:30, Marc Zyngier wrote:
>>> This is the 4th drop of NV support on arm64 for this year.
>>>
>>> For the previous episodes, see [1].
>>>
>>> What's changed:
>>>
>>> - New framework to track system register traps that are reinjected in
>>>   guest EL2. It is expected to replace the discrete handling we have
>>>   enjoyed so far, which didn't scale at all. This has already fixed a
>>>   number of bugs that were hidden (a bunch of traps were never
>>>   forwarded...). Still a work in progress, but this is going in the
>>>   right direction.
>>>
>>> - Allow the L1 hypervisor to have a S2 that has an input larger than
>>>   the L0 IPA space. This fixes a number of subtle issues, depending on
>>>   how the initial guest was created.
>>>
>>> - Consequently, the patch series has gone longer again. Boo. But
>>>   hopefully some of it is easier to review...
>>>
>>> [1] https://lore.kernel.org/r/20230405154008.3552854-1-maz@kernel.org
>>>
>>> Andre Przywara (1):
>>>   KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ
>>
>> I guess you have executed kselftests on L1 guests. Have all the tests
>> passed there? On my end it stalls in the KVM_RUN.
> 
> No, I hardly run any kselftest, because they are just not designed to
> run at EL2 at all. There's some work to be done there, but I just
> don't have the bandwidth for that (hint, wink...)

oh OK, I missed that point. If nobody is working on this I can start
looking at it. Would be interesting to run them on nested guest too.
> 
>>
>> for instance
>> tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c fails in
>> test_guest_raz(vcpu) on the KVM_RUN. Even with a basic
>>
>> static void guest_main(void)
>> {
>> GUEST_DONE();
>> }
> 
> My guess is that the test harness expects things to run at EL1.
> Depending on the value you get for HCR_EL2, you could get all sort of
> odd behaviours. Also, the harness configures EL1 only, which is
> unlikely to work at EL2. My conclusion is that "processor.c" needs to
> be taught about EL2, at the very least.
> 
>>
>> I get
>>  aarch32_id_regs-768     [002] .....   410.544665: kvm_exit: IRQ:
>> HSR_EC: 0x0000 (UNKNOWN), PC: 0x0000000000401ec4
>>  aarch32_id_regs-768     [002] d....   410.544666: kvm_entry: PC:
>> 0x0000000000401ec4
>>  aarch32_id_regs-768     [002] .....   410.544675: kvm_exit: IRQ:
>> HSR_EC: 0x0000 (UNKNOWN), PC: 0x0000000000401ec4
>>  aarch32_id_regs-768     [002] d....   410.544676: kvm_entry: PC:
>> 0x0000000000401ec4
>>  aarch32_id_regs-768     [002] .....   410.544685: kvm_exit: IRQ:
>> HSR_EC: 0x0000 (UNKNOWN), PC: 0x0000000000401ec4
>>
>> looping forever instead of
>>
>> aarch32_id_regs-1085576 [079] d..1. 1401295.068739: kvm_entry: PC:
>> 0x0000000000401ec4
>>  aarch32_id_regs-1085576 [079] ...1. 1401295.068745: kvm_exit: TRAP:
>> HSR_EC: 0x0020 (IABT_LOW), PC: 0x0000000000401ec4
>>  aarch32_id_regs-1085576 [079] d..1. 1401295.068790: kvm_entry: PC:
>> 0x0000000000401ec4
>>  aarch32_id_regs-1085576 [079] ...1. 1401295.068792: kvm_exit: TRAP:
>> HSR_EC: 0x0020 (IABT_LOW), PC: 0x0000000000401ec4
>>  aarch32_id_regs-1085576 [079] d..1. 1401295.068794: kvm_entry: PC:
>> 0x0000000000401ec4
>>  aarch32_id_regs-1085576 [079] ...1. 1401295.068795: kvm_exit: TRAP:
>> HSR_EC: 0x0020 (IABT_LOW), PC: 0x0000000000401ec4
>>  aarch32_id_regs-1085576 [079] d..1. 1401295.068797: kvm_entry: PC:
>> 0x0000000000401ec4
>> ../..
>>
>> Any idea or any known restriction wrt kselftests?
> 
> See above. I'd love someone to actually start looking into it and
> devise a testing harness that would run both at EL{0,1,2} *at the same
> time* so that we can start exercising some of the trap behaviours that
> the architecture mandates.
> 
> Also, Alexandru had a some KUT tests a few years ago, but I don't know
> what happened of them.

Yeah I remember that one too. Alexandru, do you have plans to revive it?
That would be also interesting to run kuts on nested, giving a chance to
have incremental and more unitary testing.

Thanks!

Eric

> 
> Thanks,
> 
> 	M.
> 

