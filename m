Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E253D902B;
	Fri, 10 Apr 2026 15:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775833928; cv=none; b=Z6aD/O3dDOeH9tKnTRc2yEmHGD18PS0wuB+k3RQM4iGEu/UM5M4aUxBhRedpALg5VS5R7tKkiUED/EUOGqF7br7/ukiEIjxT9T8GRnXE+mT0qKlSvs5Y4chCRj2MLyerEoJOrvu/81ddkvI7ZAeGzJbNqso0yYtRezBfrhbSv80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775833928; c=relaxed/simple;
	bh=SgeTFShUt5ftBYW+tYad/4IX9OU1k7JOPTiu6AXMfNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WeGiBwhY4dFeFEq8AjPgbX9fJT7xr5uhABQm9RYl5cfaEO2VZT/ON5gprQ+IeisZnGkx+V1Wel7qgsdeqAAbq4wAoYKYqjjv8RI1nFmiT0GXEKRBYlsFr2X4An2FutVTQaECS8vOUfdn/cnm1sarMU1VXOrbYmij94JhwUtoY/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Whp3kSZI; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Whp3kSZI"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C88221CE2;
	Fri, 10 Apr 2026 08:12:00 -0700 (PDT)
Received: from [10.1.29.18] (e122027.cambridge.arm.com [10.1.29.18])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 390203FAA1;
	Fri, 10 Apr 2026 08:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775833926; bh=SgeTFShUt5ftBYW+tYad/4IX9OU1k7JOPTiu6AXMfNA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Whp3kSZI4EIQPricoHgPcGQcXYQwuSke488yFcKXb6hzahgn750nLaoY/rSPGuvLi
	 tSYSQ1ywveATyALdJ8/51zIi6U4Rws6qWSNF/a0yWgAP4tf+qUq64Mw/L2K5vBUewu
	 nRwsd0tfQiFuWXWhC4EynyHREF6tIFfxgM8rJz1g=
Message-ID: <3845a15c-46d4-41c6-b645-8fbbead34761@arm.com>
Date: Fri, 10 Apr 2026 16:12:01 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 21/48] arm64: RMI: Handle RMI_EXIT_RIPAS_CHANGE
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-22-steven.price@arm.com>
 <59c83ace-c8be-4c71-99b6-cd5f085a3063@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <59c83ace-c8be-4c71-99b6-cd5f085a3063@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20/03/2026 11:15, Suzuki K Poulose wrote:
> Hi Steven
> 
> On 18/03/2026 15:53, Steven Price wrote:
>> The guest can request that a region of it's protected address space is
>> switched between RIPAS_RAM and RIPAS_EMPTY (and back) using
>> RSI_IPA_STATE_SET. This causes a guest exit with the
>> RMI_EXIT_RIPAS_CHANGE code. We treat this as a request to convert a
>> protected region to unprotected (or back), exiting to the VMM to make
>> the necessary changes to the guest_memfd and memslot mappings. On the
>> next entry the RIPAS changes are committed by making RMI_RTT_SET_RIPAS
>> calls.
>>
>> The VMM may wish to reject the RIPAS change requested by the guest. For
>> now it can only do this by no longer scheduling the VCPU as we don't
>> currently have a usecase for returning that rejection to the guest, but
>> by postponing the RMI_RTT_SET_RIPAS changes to entry we leave the door
>> open for adding a new ioctl in the future for this purpose.
> 
> I have been thinking about this. Today we do a KVM_MEMORY_FAULT_EXIT
> to the VMM to handle the request. The other option is to make this
> a KVM_EXIT_HYPERCALL with SMC_RSI_SET_RIPAS. But this would leak RSI
> implementation to the VMM. The advantage is that the VMM can provide
> a clear response RSI_ACCEPT vs RSI_REJECT (including accepting a partial
> range) and KVM can satisfy the RMI_RTT_SET_RIPAS.

Faking up hypercalls based on a very narrow interface seems like a bad
API design. The guest is of course perfectly allowed to have another
interface directly to the VMM to communicate intent.

> We may end up doing something similar for Device assignment too, where
> the VMM gets a chance to reject any inconsistent device mappings.
> 
> Like you mentioned, the VMM can stop the Realm today as an alternate
> approach.
The intention here is that we start with a very basic interface and can
then extend it when we work out how to handle rejection. The ordering in
the kernel is explicitly to allow that extension. I get the impression
that device assignment has a much better justification for handling the
reject flow so it's probably best to leave that until device assignment
is implemented.

Thanks,
Steve

