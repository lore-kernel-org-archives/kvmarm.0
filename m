Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792576699;
	b=DKLkJj+GnlK5gmSeRfTT+Uzgsv5IuTrdvcdy92/Mhl67W3KrRZbTbXtAL6ao+Liae2id
	 uennhYqubwyU4DKUCQVaqOwLA3l3UpT/1b+egEHoohDPg7eetI5t6TcwNwlYjXIpn2hNE
	 CRH3qe+mKzTY4ZEJvVlY0v88s248xG9hqbPLnTh5P97hwYDigEm8XNV9swsVhey5BUfsw
	 /ed6e3W0/6c8mAFlNEn9mZoIId0Vdf6J8qq7tHh375SSODha/m8X028DvkmAULI6fi8wL
	 OzJlJ9sQ1SqSqvLNwUKbXFrNN/malAFYBQxh4Tuzmg2WBkfafHJw6z1KR2QirG33TTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792576699;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=cz8+V7XCKKhBDpf80aiJInY1iYNOWN4+wC7qm69EtcE=;
	b=rukk30UFwvJwzr+jkDTdEUpshRM9QxLPlDrfIh6o4IGtOqP7Hx60ReJGIWOpuPXSYetJ
	 R31dAIhnRxIS7zfKOHLeZw4wDRZlwh8l3l5tP0IeWUq6eCaT1P2kPbsnGryGu2AoxwOEL
	 CES1nYYKIEa03bjaZpvEeO45F9tq4H2y/xJSoIy3DfRRm95bj95/a84CT6lQTk1upkjVJ
	 ZLcJ68lCjPRUIWWJCYt86nQ4ZBlHToeqUDDLI20PLyyEmprQlU8fFsfNZhea4+XqJfQnb
	 XTr6zpUOwM/RvBBIzJw3J6OAPxAt4/kX8nWNWujXbu7R15o9TY9TMRtg1MbTbOmPoag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DRkcpboT;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81B5D606A31B;
	Wed, 21 Oct 2026 09:58:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81B5D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DRkcpboT
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75B8216F8;
	Wed, 21 Oct 2026 02:58:14 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D4FE73F7D8;
	Wed, 21 Oct 2026 02:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792576697; bh=IDazUdpoih0dXqrNnstcGcC5WHNZlytoR2PIn318lzU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DRkcpboTgyBklO5nuoilzcuW60prH769ubwJBYdbsa7qFkOBtmzSkDopdCyhAq/Vf
	 0xUBoqHSlTFtlUGpNPuruwGePjNOawfP0umRaLeQQ9ORXwAvjKwdlEFaU0NFOaBVsD
	 x51xk7Lm3RaVhL6tF2NWgRDq+mj7fmlqjVsqiIGY=
Message-ID: <5d487949-9195-442f-97af-acb9e3fdfb0d@arm.com>
Date: Wed, 21 Oct 2026 10:58:13 +0100
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
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-6-suzuki.poulose@arm.com> <arZmXFw5Jw2IbAmA@arm.com>
 <a11aba04-eaaa-43fd-988b-a2581b1b2fdb@arm.com> <araketG70TIKeNuf@arm.com>
 <12e83d88-de4c-4230-aac2-1796123320ad@arm.com>
 <70d47475-e26e-40e1-b409-b0c16aecb8c0@arm.com>
 <195cdfe4-a55a-453f-9c34-620738eca244@arm.com> <arqrZ_Auk9BYOopa@arm.com>
 <0f68dcff-1dfe-4515-9912-515ca6457674@arm.com> <arudWVBPXcnUvYNh@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <arudWVBPXcnUvYNh@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/09/2026 12:15, Catalin Marinas wrote:
> On Mon, Sep 28, 2026 at 07:28:20PM +0100, Suzuki K Poulose wrote:
>> On 28/09/2026 19:01, Catalin Marinas wrote:
>>> possible, to defer the RMM activation until the first user (still do the
>>> RMI probing as an initcall). If we run on RME-capable hardware and
>>> firmware but don't care about realms or TSM, we still get the normal OS
>>> functionality.
>>
>> Would you prefer this in the first drop of the RMM ? Or is this
>> something we could add as a separate series ?
> 
> I think we could add the deferring as a separate patch, maybe together
> with the KVM bits. An advantage of keeping it here if we merge this
> first is that we still exercise the activation path without full realm
> support or TSM. Otherwise a lot of this would be dead code until the
> other series arrive. Either way, do it as as separate patch on top of
> this series.
> 

I have been looking at the "on-demand" activation support and came
across the following design decision.

* We have KVM_CAP_ARM_RME which advertises that KVM can create Realm VMs
   to the userspace. A VMM could check this before it creates a Realm VM
   using KVM_CREATE_VM with type=RealmVM.


Now, we could delay the RMM activation as late as the KVM_CREATE_VM and
kick it off while we initialise the kvm as part of kvm_arch_init_vm().
But if that fails, we would fail the KVM_CREATE_VM.

The question is, what should KVM_CAP_ARM_RME indicate ?
We could initially enable the cap based on the presence of RMM (but not 
activated). However, should we turn the KVM_CAP_ARM_RME=off when we fail
to activate the RMM ? Is that senisble ? (i.e., runtime disabling a cap).

Cheers
Suzuki



