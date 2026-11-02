Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652717;
	b=jnfqEFFDJDbceHPcPGpL4pEzLb1JH27Pqx2kjAsj8ujn7xOoqXtb37b4z+QNJOfJLRMD
	 MSWAYZouSAdUKMX+SwZoVb0exuzoY8LQZO4U8WoTg7UY12+pp17KZkPYbzsACd1HZAyft
	 3wbC/5zso5uEj48d97P7EScv1bnReFkgDP4uT6ppej9GSoMxBjJeTUxtGuTC/YVnZXucw
	 jYqjQhLy094ABhkAsp6fT4ir+rVAersYQ68wJCZWH6ZoaIpqXrP6ah3xUWSE6qt3dPZKc
	 y/jdsdnW+u5pDg2qA9hK2OzkmxXblxBqRB6nfCQoNoRf4tJNrpTQf9i46oSIvKKG/Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652717;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=mXkAlDp/jDqONv+JRtyAiguFrJKWiJTAxrPRZ+Lf5Nc=;
	b=3fMkOpkgSDm0rHfujX6pOulZhEZ6zM1KRKqfRT+QF+vf10FOqcMJ+xwcuEyVebDgxlQQ
	 uSq0RFB/e3A3nLEF2sfYWNalnNUOW7sxZgkG76rriqrCwDecg7f5T/GMnPlOPYD9zjkmw
	 8Lo0Gknh2nh9xDotcL65nU/Xz4zO/eDBxEKdJ4KCuCUltcVty7qpsyoBQYLlvGzG1Ifv8
	 dpeLHgTyi6QDPIsYSu6ldFftT5MymMZUcaIqVOflf5eNUvMWMFIxC/uRGSZT8Zt4XP2Is
	 RRknJieHgh46U32ooWQEmz47SgVEnCGF47kpI7oRas0oBAAE4YgR7lOKqO/t+dKi89Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="hk8/ZdKT";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18BA2606A327
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:51:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18BA2606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=hk8/ZdKT
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 075A5152B;
	Mon,  2 Nov 2026 12:51:49 -0800 (PST)
Received: from [10.57.89.36] (unknown [10.57.89.36])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D803C3F59E;
	Mon,  2 Nov 2026 12:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793652712; bh=mgQn+vHOFjT2swpROsPep99kP2Me6p9DgEiGrp4PTPw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hk8/ZdKT1NluAKxyYzyFN2s4pgd7tngHZxYGJRkQGgeiPRZVWmheZh/O27eOpQXz9
	 s4gO7PSEjeVL7OoeQK9JGajNq+ayQlN9PHvi9+pM+163PfCVVKacPslDhRHfNZgG/7
	 KtuNor/mESZFZJy4A5vRG4YNEf/+ZcsUzAWNblIo=
Message-ID: <a9f3e466-ab2b-4c98-a237-d8bd6810e06c@arm.com>
Date: Mon, 2 Nov 2026 20:51:49 +0000
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
Subject: Re: [PATCH kvmtool v3 13/21] arm64: Describe the GICv5 IRS in the DT
To: Vladimir Murzin <vladimir.murzin@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
 <20261016153939.913764-14-sascha.bischoff@arm.com>
 <412dc63b-df1f-4748-8235-542ecfc23894@arm.com>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <412dc63b-df1f-4748-8235-542ecfc23894@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/10/2026 13:03, Vladimir Murzin wrote:
> On 10/16/26 16:39, Sascha Bischoff wrote:
>> Describe the IRS CONFIG and SETLPI frames and associate each CPU
>> phandle with its IAFFID. This lets the guest discover and configure
>> the IRS for shared interrupts.

Hi Vladimir,

> 
> Out of curiosity why do we expose SETLPI frame to a guest?

Frankly, in case we want to make use of it one day. The intent for the 
SETLPI frame is that is allows the injection of LPIs by a device without 
an ITS being present. Effectively, it gives MSI support without translation.

Rather than writing an EventID/DeviceID pair to the ITS_TRANSLATE_FRAME 
(specifically the ITS_TRANSLATER or ITS_RL_TRANSLATER) and having the 
(virtual) ITS translate them using the Device- and 
Interrupt-Translation-Tables, an implementation that includes the 
SETLPI_FRAME allows a device to directly write the LPI to make pending.

This isn't something intended for use on the physical side, so we don't 
strictly expect any physical implementations to include the SETLPI_FRAME 
(famous last words?). However, it is something that an emulated GICv5 
implementation can go and do if it doesn't want the complexity of 
emulating an ITS.

When initially prototyping the GICv5 support, I did have a SETLPI driver 
that tested this mechanism, as software buy-in is also required for this 
to work. Instead of programming the DT/ITT with the translation, it just 
gives the device the desired LPI as the "event" instead.

Does that answer your question?

> 
> Thanks
> Vladimir

Thanks,
Sascha
