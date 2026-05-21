Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54DC835AC1C;
	Thu, 21 May 2026 15:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779378290; cv=none; b=HgUcR4WcQEhk0mn4NHHElQ33n6UR4DJqo6xMuy8CJ5OPQN9AQITCmXWSh17ZqWml8vzmaSU1yN2zVf+NAvufXxa5ZcRri5gSxjWSkADJvNXCF+wXDpr+snfgK/SODYO5aAu5Lyy2oktWnzg07555AjdELj/+1EpmqzyA8/AtwPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779378290; c=relaxed/simple;
	bh=UrfZUUpRqaH1mE/7ucNYsDj09LOk5RANQORw2tRBYiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mLgdKtIFYAD0DmsdFTNdOGEX5ljC8qu5Ugg4dlux59OUuFwmDMGIuHEinnUa1KbnnErpUTDIA9EjvBcbPBzIaWCFAEv1LnL0fri0J3Jft2ItSASRhXFzav1rrXWoTh8tMH+eFfoN2AELyMvUX5tG82HfvxJ+Qhla0Zcw3INfpx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DlX1kQJI; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DlX1kQJI"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2F3B1C25;
	Thu, 21 May 2026 08:44:43 -0700 (PDT)
Received: from [10.1.32.22] (e122027.cambridge.arm.com [10.1.32.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 822D43F632;
	Thu, 21 May 2026 08:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779378288; bh=UrfZUUpRqaH1mE/7ucNYsDj09LOk5RANQORw2tRBYiA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DlX1kQJI04Azq/gx7Xr7XCerghscK+I2BjbSQ/IkppD9dcgn/K+ofLohDMd8Tr4Vg
	 UxDQegPlGsCyuk11Kc2dQTExT7chHzDKE6BKxEhYB3So5LdVFnyDQ8SKvfE0CCd9F1
	 1slydp5jvDctwffmGyk/i4tk6l+O04R3g1ASQ2+0=
Message-ID: <9989811e-ef1f-43a1-becc-04edc6a69b38@arm.com>
Date: Thu, 21 May 2026 16:44:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 05/44] arm64: RMI: Add wrappers for RMI calls
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-6-steven.price@arm.com> <yq5aecj8t10l.fsf@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yq5aecj8t10l.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/05/2026 06:35, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
> 
>> The wrappers make the call sites easier to read and deal with the
>> boiler plate of handling the error codes from the RMM.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> +#define rmi_smccc(...) do {						\
>> +	arm_smccc_1_1_invoke(__VA_ARGS__);				\
>> +} while (RMI_RETURN_STATUS(res.a0) == RMI_BUSY ||			\
>> +	 RMI_RETURN_STATUS(res.a0) == RMI_BLOCKED)
>> +
> 
> I guess this is not used. Also, that would require the call site to have a struct arm_smccc_res res.

Ah good spot - yes this was replaced with a proper static inline
rmi_smccc_invoke() function. I missed removing this macro.

Thanks,
Steve
