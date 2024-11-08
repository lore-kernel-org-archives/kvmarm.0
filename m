Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9159F1DFE16
	for <kvmarm@lists.linux.dev>; Fri,  8 Nov 2024 09:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731056418; cv=none; b=VsFxBGYjWTNzuJ8IijGDX6M3ad35eXQsB5xn2ExWsJOZn+a9W+JmlJg7DyO63X1vsBHJZYdkmlJkEvDEdpt93csOJ1Y2y5Nf8j2l9QOfoI0VLWrAWpIBFLWgGPgn6OHSYFXFq3u6Ya441kmXzovEZKxk0NCnhCEWoMBKFbRh8PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731056418; c=relaxed/simple;
	bh=DiATwo03/8GtzbkcrrG2dwFva/jS1oeBl8PrDGHVMdU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tUqWNCAwAjIdH7sLaxLUCXktlGWd7UVj40Hj8F1/qgRsXtIXaYWNtz4vmnLS5gfP2vjDm6wJ/T7Nzh+sgz5E5KvyQ9wMSgrCuDliT4UbnY1inT72dLJpMJtV1xSXcxIbFt1o9OCM6D8ft/z5ehJBCQNuikAkXrSNqqMPK9QiYgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ikaxM/vr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ikaxM/vr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731056415;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZN3IWgvO5K2UzU+TxYiLQK0pb6ZI5Cu0LnpdZy+E0as=;
	b=ikaxM/vrDkMg7ed0pW1Tt1KyqKhs8de+P2Lvr9xAI2J4U++LpsDl9+pRStdlNVH5ylPH+g
	DQw7PupgRAtATuIpKkKoD6ok1RXU61Z49/gboi4cAJsFH72uzIHazsP+1bsgawN+vbyvCp
	UCxfRD2t4ZWpffEcSUG53cTJ7+gmSFg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-G3Wo57KYMaOMT576faj11w-1; Fri, 08 Nov 2024 04:00:12 -0500
X-MC-Unique: G3Wo57KYMaOMT576faj11w-1
X-Mimecast-MFC-AGG-ID: G3Wo57KYMaOMT576faj11w
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7b15d3cd6dcso221889785a.0
        for <kvmarm@lists.linux.dev>; Fri, 08 Nov 2024 01:00:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731056412; x=1731661212;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZN3IWgvO5K2UzU+TxYiLQK0pb6ZI5Cu0LnpdZy+E0as=;
        b=OL9Cz/cABzzlKn+3N7gf/DGKCZsmHyK3MHGJq9KjhaLkxnw9UxixEtOJJiNTi1ztl/
         UxE8hCqh7wnoJbElHnhO9BI+a72JTsMVIWcQI1e0rc77mUyoa8fz8OYyIQIObIyNVfWS
         IlKXI40+YF3l33G92mcBY79qWV3y4n/7Moj+nr8C+PTJi4oeWp20IDivBYuFY8cKsLPm
         x857X/l9SaoewcP9oB+ScK9T8LjEYrBuCWBwstzseiml6NrCBRV2sSiXOEvalMFqoO7S
         JopyPoJo9K6Yl3wtWC45m8/a4nedW1m1EOFGL+H2Oq/8n17z4R0c8k7pPjPusvtW93U3
         1n8A==
X-Forwarded-Encrypted: i=1; AJvYcCVxCTrRpDEeZ4GQmu9GLPliBTESwwuZsdMY2BmiMszFg3lbCKed7azsq2d626WTtVegqRrAHRM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9qm6jDP3kXmCSCjqKTxqOX3d0LfPN4aPqJlZYfhu0isaPsIEI
	THR6V6jtwuQ79o5icrgV2waswX+CbTTIFeCFR5JZf0XZusN0Q4kniPM8exDuKLCghThbF+4bEx/
	Hou6pcLEa313Ysf1QfhXItddQ5Hn3cpD0DRthBIOGbzs9DHzRQGb6eg==
X-Received: by 2002:a05:620a:9342:b0:7b1:56f0:e06f with SMTP id af79cd13be357-7b331e8cc94mr215955685a.15.1731056411871;
        Fri, 08 Nov 2024 01:00:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGkxg/sJsdiIHyCj/wQKR1CoiDq38NePwxcDPuV2+H6LqXetQIZJsRE5c1XC8s2tutl3zRGAQ==
X-Received: by 2002:a05:620a:9342:b0:7b1:56f0:e06f with SMTP id af79cd13be357-7b331e8cc94mr215951285a.15.1731056411365;
        Fri, 08 Nov 2024 01:00:11 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b32ac2dd1fsm142265085a.15.2024.11.08.01.00.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2024 01:00:10 -0800 (PST)
Message-ID: <77cc68a6-2d7a-4ef3-bf4d-93fc9987f466@redhat.com>
Date: Fri, 8 Nov 2024 10:00:06 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 2/3] KVM: selftests: Introduce kvm_vm_dead_free
To: Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>
Cc: eric.auger.pro@gmail.com, broonie@kernel.org, maz@kernel.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, joey.gouly@arm.com,
 shuah@kernel.org, pbonzini@redhat.com
References: <20241107094000.70705-1-eric.auger@redhat.com>
 <20241107094000.70705-3-eric.auger@redhat.com> <Zyz_KGtoXt0gnMM8@google.com>
 <Zy0QFhFsICeNt8kF@linux.dev> <Zy0bcM0m-N18gAZz@google.com>
 <Zy0fPgwymCdBwLd_@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <Zy0fPgwymCdBwLd_@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -PQpcRCFcroOxvVjHjs_rUa2L3iL1GCeDYL_6Ncq-hk_1731056412
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 11/7/24 21:12, Oliver Upton wrote:
> On Thu, Nov 07, 2024 at 11:56:32AM -0800, Sean Christopherson wrote:
>> On Thu, Nov 07, 2024, Oliver Upton wrote:
>>> On Thu, Nov 07, 2024 at 09:55:52AM -0800, Sean Christopherson wrote:
>>>> On Thu, Nov 07, 2024, Eric Auger wrote:
>>>>> In case a KVM_REQ_VM_DEAD request was sent to a VM, subsequent
>>>>> KVM ioctls will fail and cause test failure. This now happens
>>>>> with an aarch64 vgic test where the kvm_vm_free() fails. Let's
>>>>> add a new kvm_vm_dead_free() helper that does all the deallocation
>>>>> besides the KVM_SET_USER_MEMORY_REGION2 ioctl.
>>>> Please no.  I don't want to bleed the kvm->vm_dead behavior all over selftests.
>>>> The hack in __TEST_ASSERT_VM_VCPU_IOCTL() is there purely to provide users with
>>>> a more helpful error message, it is most definitely not intended to be an "official"
>>>> way to detect and react to the VM being dead.
>>>>
>>>> IMO, tests that intentionally result in a dead VM should assert that subsequent
>>>> VM/vCPU ioctls return -EIO, and that's all.  Attempting to gracefully free
>>>> resources adds complexity and pollutes the core selftests APIs, with very little
>>>> benefit.
>>> Encouraging tests to explicitly leak resources to fudge around assertions
>>> in the selftests library seems off to me.
>> I don't disagree, but I really, really don't want to add vm_dead().
> It'd still be valuable to test that the VM is properly dead and
> subsequent ioctls also return EIO, but I understand the hesitation.

Currently the vgic_test does not check that the VM is dead, it just
checks the first expected errno according to the uapi documentation.
Besides AFAIK this latter has not been updated according to the new VM
dead implementation.

Eric
>
>>> IMO, the better approach would be to provide a helper that gives the
>>> impression of freeing the VM but implicitly leaks it, paired with some
>>> reasoning for it.
>> Actually, duh.  There's no need to manually delete KVM memslots for *any* VM,
>> dead or alive.  Just skip that unconditionally when freeing the VM, and then the
>> vGIC test just needs to assert on -EIO instead -ENXIO/-EBUSY.
> Yeah, that'd tighten up the assertions a bit more to the exact ioctl
> where we expect the VM to go sideways.
>
>> ---
>> From: Sean Christopherson <seanjc@google.com>
>> Date: Thu, 7 Nov 2024 11:39:59 -0800
>> Subject: [PATCH] KVM: selftests: Don't bother deleting memslots in KVM when
>>  freeing VMs
>>
>> When freeing a VM, don't call into KVM to manually remove each memslot,
>> simply cleanup and free any userspace assets associated with the memory
>> region.  KVM is ultimately responsible for ensuring kernel resources are
>> freed when the VM is destroyed, deleting memslots one-by-one is
>> unnecessarily slow, and unless a test is already leaking the VM fd, the
>> VM will be destroyed when kvm_vm_release() is called.
>>
>> Not deleting KVM's memslot also allows cleaning up dead VMs without having
>> to care whether or not the to-be-freed VM is dead or alive.
> Can you add a comment to kvm_vm_free() about why we want to avoid ioctls
> in that helper? It'd help discourage this situation from happening again
> in the future in the unlikely case someone wants to park an ioctl there.
>
>> Reported-by: Eric Auger <eric.auger@redhat.com>
>> Reported-by: Mark Brown <broonie@kernel.org>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
> I'm assuming you want to take this, happy to grab it otherwise.
>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
>
>>>> Marking a VM dead should be a _very_ rare event; it's not something that I think
>>>> we should encourage, i.e. we shouldn't make it easier to deal with.  Ideally,
>>>> use of kvm_vm_dead() should be limited to things like sev_vm_move_enc_context_from(),
>>>> where KVM needs to prever accessing the source VM to protect the host.  IMO, the
>>>> vGIC case and x86's enter_smm() are hacks.  E.g. I don't see any reason why the
>>>> enter_smm() case can't synthesize a triple fault.
>>> The VGIC case is at least better than the alternative of slapping
>>> bandaids all over the shop to cope with a half-baked VM and ensure we
>>> tear it down correctly. Userspace is far up shit creek at the point the
>>> VM is marked as dead, so I don't see any value in hobbling along
>>> afterwards.
>> Again, I don't disagree, but I don't want to normalize shooting the VM on errors.
> Definitely not. It is very much a break-glass situation where this is
> even somewhat OK.
>

