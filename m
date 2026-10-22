Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792658372;
	b=jGqj7v8HfjSQeGnZka1QQl2wG9b+4b0Lpj72R8dtDt86SD3a3EKQquA4IyTtovkYI/EX
	 fVs7UhhEJqZXFyBYv8OpJx6U2E9lT9FEwYbCYsM3mG8UsfX9P2XNp+debvxedDsBgDvhe
	 xOh5VynH/LOrWljAhhLrhry+44h3DN9hATT4cKHPYdVc9KhTadAM2um0/99s1H2CGzxke
	 oDp7DkMCwwGnTYQlMfGghY64W981hlntzsJ3e4EPgMAAlN4iyVXmNby9YYpBdKUZVOhQO
	 08gR3iNPyXRsakGCWY2FXuho1AkfmU8rACAb5tzC3Vj9YD4dK7DPSoKC8zchHrSNEUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792658372;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=CvCWEqXaZH/iIUkBgP+o8Ay2lvbiOFHenVSVWHTDnio=;
	b=tgc9/W4jQxOomtxja9etFVOZznrMIlZRzE3rzCRm/c9LIr1C9vdZWejy0/E5Su6YtABp
	 vNL/RBkhk3G+Fqg0F0ZV3uj8loez8A28P3HeJraDT9Lpq0YrDXqmtTFEP+9FW2xLYl8Y3
	 Y56wj5qdSMPdnuHh2UIYnXphTzmplBV/FIxoCGzyPIJqRJIpYaRpoQO06iQvarbH7pgnG
	 S4KxRfjAxlPCkHrwtpj0W3joMYha4eo+r4x90vfy4XZ1w8Ixc1HmUClOLy6vXao5nJMlb
	 mQ2KkfnClPgs99SL7OzhOsBrk2sT1ajoBVZZkvny3pVUN0I+yZKk3qV73tmBO1Htj2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=hEObLniC;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10514606A31A;
	Thu, 22 Oct 2026 08:39:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10514606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=hEObLniC
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD9062C46;
	Thu, 22 Oct 2026 01:39:21 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE8D93F673;
	Thu, 22 Oct 2026 01:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792658365; bh=uD8Z+VnaxokujgVMBewvc6O/2Oc94t5bbNpab8XT2Mo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hEObLniCfO8tvUEME++blEmza9btcaiRUMVFVtYl9TdDINt/Jh+KSuOXaWp/rKmlo
	 WUhI/MoxamaYnryozypEz5akzYCHQwBT1DP41jmVMtmfcNM9rOY0pgG75S1zir53qf
	 PQfmGihfe1dbVdN8Zrb0zomrdSqiyDwI9lvPy+WU=
Message-ID: <4a086f49-14a3-43a9-ba9b-ab387f5e7f91@arm.com>
Date: Thu, 22 Oct 2026 09:39:20 +0100
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 5/7] firmware: arm_rmm: Activate the RMM
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, will@kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 gshan@redhat.com, joey.gouly@arm.com, tabba@google.com,
 yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com,
 jonathan.cameron@oss.qualcomm.com
References: <a11aba04-eaaa-43fd-988b-a2581b1b2fdb@arm.com>
 <araketG70TIKeNuf@arm.com> <12e83d88-de4c-4230-aac2-1796123320ad@arm.com>
 <70d47475-e26e-40e1-b409-b0c16aecb8c0@arm.com>
 <195cdfe4-a55a-453f-9c34-620738eca244@arm.com> <arqrZ_Auk9BYOopa@arm.com>
 <0f68dcff-1dfe-4515-9912-515ca6457674@arm.com> <arudWVBPXcnUvYNh@arm.com>
 <5d487949-9195-442f-97af-acb9e3fdfb0d@arm.com> <86ld7ryvm8.wl-maz@kernel.org>
 <atj7A1CV4paW3htS@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <atj7A1CV4paW3htS@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21/10/2026 18:48, Catalin Marinas wrote:
> On Wed, Oct 21, 2026 at 03:30:07PM +0100, Marc Zyngier wrote:
>> On Wed, 21 Oct 2026 10:58:13 +0100,
>> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>>
>>> On 29/09/2026 12:15, Catalin Marinas wrote:
>>>> On Mon, Sep 28, 2026 at 07:28:20PM +0100, Suzuki K Poulose wrote:
>>>>> On 28/09/2026 19:01, Catalin Marinas wrote:
>>>>>> possible, to defer the RMM activation until the first user (still do the
>>>>>> RMI probing as an initcall). If we run on RME-capable hardware and
>>>>>> firmware but don't care about realms or TSM, we still get the normal OS
>>>>>> functionality.
>>>>>
>>>>> Would you prefer this in the first drop of the RMM ? Or is this
>>>>> something we could add as a separate series ?
>>>>
>>>> I think we could add the deferring as a separate patch, maybe together
>>>> with the KVM bits. An advantage of keeping it here if we merge this
>>>> first is that we still exercise the activation path without full realm
>>>> support or TSM. Otherwise a lot of this would be dead code until the
>>>> other series arrive. Either way, do it as as separate patch on top of
>>>> this series.
>>>>
>>>
>>> I have been looking at the "on-demand" activation support and came
>>> across the following design decision.
>>>
>>> * We have KVM_CAP_ARM_RME which advertises that KVM can create Realm VMs
>>>    to the userspace. A VMM could check this before it creates a Realm VM
>>>    using KVM_CREATE_VM with type=RealmVM.
>>>
>>>
>>> Now, we could delay the RMM activation as late as the KVM_CREATE_VM and
>>> kick it off while we initialise the kvm as part of kvm_arch_init_vm().
>>> But if that fails, we would fail the KVM_CREATE_VM.
>>>
>>> The question is, what should KVM_CAP_ARM_RME indicate ?  We could
>>> initially enable the cap based on the presence of RMM (but not
>>> activated). However, should we turn the KVM_CAP_ARM_RME=off when we
>>> fail to activate the RMM ? Is that senisble ? (i.e., runtime
>>> disabling a cap).
>>
>> I think this sets a bad precedent. If activation can fail, KVM end-up
>> not delivering on the promise that it makes, and that's not great.
>>
>> My take is that the least surprising behaviour is best. If you have
>> bought into the CCA kool-aid by enabling it on the kernel command
>> line, that's not by accident. You expect your VMs to reliably be
>> created when KVM tells you that CCA is available.
>>
>> So KVM_CAP_ARM_RME should indicate whether the RMM has been
>> successfully activated, and nothing else.
> 
> Tying activation to kvm-arm.mode=rmm works for me, roughly similar to
> kvm-arm.mode=protected. It's still an eager activation (just
> conditional) and KVM_CAP_ARM_RME then only reports whether activation
> succeeded. We lose kexec/hibernation but that's fine, it was explicitly
> requested on the command line.

Thank you both, I will tie the activation to kvm init, gated on the
kvm-arm.mode.

> 
> There's also the case of a host-only PCIe TSM (without realms). IIUC
> (grep'ing FIRME spec) on an RME system IDE key programming goes via the
> RMM, so this would need the RMM activated even without KVM. Not sure it
> makes sense without realms, so I think we can ignore it until there's a
> concrete use case (and add one more hook to activate the RMM).

We could, again gate this on kvm-arm.mode. RMM is not useful without
the capability to run realms. The dependency is the other way around.
If an RMM exists and would be used for any other device TSM, then it
should act as the TSM for all devices, to make sure we have a single
TSM managing the IDEs (and the SPDM connections).

So, tying this again to the kvm-arm.mode=rmm, i.e., the capability
to run Realms makes sense to me. Thoughts ?

Suzuki
> 

