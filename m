Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795799041;
	b=fMKK3ikuV2FFIQCASO3zNH/dem8cXQcB/33X82Dgt2KGB17acUuTSAmvXF9kuYtXEDGH
	 phzPvD7jMUP4HIywqI2rPO1MKGPA35XRlGwluhm/QEezQP6ZWIppzyUnLMHa4LfYXdLmg
	 V5zEioyIc+qf+3FtFPou4XJD2pKyUHx9522sqrM5NydztevDFWvFzRcjtWwC36RVA7fIG
	 LpmvLba4Blo9w71iKVlZ65a5er6BhklND5HCEJiI9XgrNjwnysfa9F98aFgQux5jbPJjA
	 aw63m+GwvSpPx5Uzlet7KQV3pFs8dtfHHhC2+jAG8hLSXSPx3Ttsc4chvyt/F63o+FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795799041;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=mvdbAcNvPUl8+xzdr4AGicznVSCZCG5IMnLlhWSXHrU=;
	b=vXbURUgn3x0lmBv2aHPkfzDI/4GvJPITKxE2CQ8ORTwnvqwyg/ZgNWpZ2iltCF/rZmnW
	 cHDxTo/5JxQYQoKI8jpShFDe7mGda4Yn7OqzB58MTiV9YoDn8Epdv+nt9swu6pNfR8w6P
	 g39r7GSkhNiDCIuEX/d6YRv/OYfx7qp8UPgRPftJuqsuCuIupQv7mjgCKX7tbXkoADZYw
	 TaONnHY85A45YkM8qsufC00oI5BlMGWMUPE9smWIO6qkEARCNX0bHdMJ7eQjtA6pUj0yU
	 L28og98fiifW9dTc78OOoJh49BLFiUSAwXaQhfg8cSGW/WVBrmhQgMrbDq9R3vIQ60Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=tTkQH1ZZ;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 617AE606A31E
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 17:04:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 617AE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=tTkQH1ZZ
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 097361575;
	Fri, 27 Nov 2026 09:03:58 -0800 (PST)
Received: from [10.57.93.100] (unknown [10.57.93.100])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B22653F632;
	Fri, 27 Nov 2026 09:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795799040; bh=i+TR0LzfgP/WQDZoX/lAs0W+jLjvNb+/N+OgMW3wgv8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tTkQH1ZZfilUfU3xL7Yhc+Jx/xhLm5R5sKA/HF/HbtoIdwQyfb0+pnWiJtFaPOfat
	 IIIuNDYDs24vugGcoicxQ7dSLW+uyvT94G04XT7TlOULBPuHuBee6FCMxLjZU6iOUX
	 GU6TxtjrHYWE+xM8PyTqEVXlPuwZgHKeREHNcL1U=
Message-ID: <e8d77727-5d88-42a8-9df3-234bbc5137e5@arm.com>
Date: Fri, 27 Nov 2026 17:03:58 +0000
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
Subject: Re: [PATCH kvmtool v6 00/23] arm64: Support GICv5-based guests
To: Will Deacon <will@kernel.org>, Vladimir Murzin <vladimir.murzin@arm.com>
Cc: julien.thierry.kdev@gmail.com, maz@kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, timothy.hayes@arm.com,
 Peter Maydell <peter.maydell@linaro.org>
References: <20261125151356.2875108-1-sascha.bischoff@arm.com>
 <1aa97f61-b740-4044-9065-f3ccfcb709fd@arm.com>
 <awhpViXFw-mts2ck@willie-the-truck>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <awhpViXFw-mts2ck@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Will,

On 26/11/2026 17:16, Will Deacon wrote:
> On Thu, Nov 26, 2026 at 10:22:56AM +0000, Vladimir Murzin wrote:
>> I reviewed and tested the patches for GICv5 IRS support (01-18). They
>> do what they promise - allow booting a GICv5-enabled guest. In my
>> opinion, patches are in good shape, so could you please have a look and
>> consider merging GICv5 IRS support (patches 01-18)?
> 
> I just hoovered up the pile of kvmtool patches sitting on the list, so
> this doesn't apply any more. Please can you send a v7?
> 

Done!

> Cheers,
> 
> Will

Thanks,
Sascha
