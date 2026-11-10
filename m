Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794325564;
	b=NgtIwUuJQLg37BpGE6jEoWgQ6kw9tg5UhHq9mAUXH70A5HzAB+obE3UJKvvT/I+nJJKU
	 /r85Xm030Puowtc2csAtnq9Toh0/8anA975bAtBTvBaIZKD9n+MELSlGEC7xEUGTERgba
	 Sz8SY5H0WAcDWBVomyiDXYo9tpRgX8FykS5eq2gasMJnvvE/Oj5nkpBJqS8aKyTcek5Hd
	 6skuX5oFVxMm2jQ+Pp5qUihA26an3mo9dIv1LDQxgYWFF7pCA0zNJWkVlV2GZ+NCmRLTT
	 jH3oMnSEQ2dXV48fjYPC/KVyQxmAE/LPWdHdXMWHy6buloGDoI3Rs0F7GwL2vSPLWZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794325564;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=lvkJCeuy3a/KY5dr6gIVwmruU5aVYEprW8n3HZixyDo=;
	b=ABum0jgO4j6bgqkrYI1psKE1pe5MiW8ZZu9Uk6aLqO+PTS1XBn29py5muq+kX9CbYyHi
	 u75fKZK3IbsGqy2VA/zknaLa6K+yu6dZMVxWTZzoAYyqveXz02Y3a0bWNiWBiPmD5Ae8L
	 bbYuW7aKs3d+Rd6OCq6PsAv3LqrLlo4MEx6MYAMyGB/t4BkT3SIp8MghWbjHrMyR1RR6R
	 fDLjchYKMYHZFqvPL+//AO63cRAlO5ax+B+nrw8pOR+GjaK1ACzbpiJoseySHbkDaPG1S
	 2MDdV6/5DgaInYLOr+c/YynmnGzOz+k2IFWeQ2KmPykGe9pGC/AaXtp222IkJuPFMZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=UlOoB3pU;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70D58606AB54
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 15:46:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70D58606AB54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=UlOoB3pU
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4A9F1477;
	Tue, 10 Nov 2026 07:45:59 -0800 (PST)
Received: from [10.0.154.42] (e121487-lin.cambridge.arm.com [10.0.154.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D9A813F85F;
	Tue, 10 Nov 2026 07:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794325562; bh=uEBdDPO7syiTjatoW7Nc/1vZxRkrOCdYaIwx8bMhOMA=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=UlOoB3pUAme+6uL1VRZOc92FCVKw2Kb0z7mWqOKKnLO3sorCh8/7eNJH/TdjJycpz
	 fyeUUJLMpdwHe6gqy9WZqlYa2exG2HaOQtsA3Ww7jjQX2KeEOtrHRfMgyT7c2J9fcb
	 abPWUdlJypkHY2Xqt2umvhNxMz1+0uBU44RsZfLU=
Message-ID: <b33b0ca9-0134-4dad-aceb-8c9cb4ada9a2@arm.com>
Date: Tue, 10 Nov 2026 15:45:58 +0000
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
From: Vladimir Murzin <vladimir.murzin@arm.com>
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
 <20261016153939.913764-14-sascha.bischoff@arm.com>
 <412dc63b-df1f-4748-8235-542ecfc23894@arm.com>
 <a9f3e466-ab2b-4c98-a237-d8bd6810e06c@arm.com>
 <a991250c-946b-456f-bf61-f1ab536365bf@arm.com>
Content-Language: en-GB
In-Reply-To: <a991250c-946b-456f-bf61-f1ab536365bf@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sascha,

On 11/10/26 14:57, Vladimir Murzin wrote:
> Hi Sascha,
> 
> On 11/2/26 20:51, Sascha Bischoff wrote:
>> On 26/10/2026 13:03, Vladimir Murzin wrote:
>>> On 10/16/26 16:39, Sascha Bischoff wrote:
>>>> Describe the IRS CONFIG and SETLPI frames and associate each CPU
>>>> phandle with its IAFFID. This lets the guest discover and configure
>>>> the IRS for shared interrupts.
>> Hi Vladimir,
>>
>>> Out of curiosity why do we expose SETLPI frame to a guest?
>> Frankly, in case we want to make use of it one day. The intent for the SETLPI frame is that is allows the injection of LPIs by a device without an ITS being present. Effectively, it gives MSI support without translation.
>>
>> Rather than writing an EventID/DeviceID pair to the ITS_TRANSLATE_FRAME (specifically the ITS_TRANSLATER or ITS_RL_TRANSLATER) and having the (virtual) ITS translate them using the Device- and Interrupt-Translation-Tables, an implementation that includes the SETLPI_FRAME allows a device to directly write the LPI to make pending.
>>
>> This isn't something intended for use on the physical side, so we don't strictly expect any physical implementations to include the SETLPI_FRAME (famous last words?). However, it is something that an emulated GICv5 implementation can go and do if it doesn't want the complexity of emulating an ITS.
>>
>> When initially prototyping the GICv5 support, I did have a SETLPI driver that tested this mechanism, as software buy-in is also required for this to work. Instead of programming the DT/ITT with the translation, it just gives the device the desired LPI as the "event" instead.
>>
>> Does that answer your question?
>>
> 
> Yes, I was mostly wondering if we are going to have any user for that, but
> now I realised that it could be user (selftest and/or kvm-unit-test) which
> make sure that SETLPI stays unimplemented :D
> 

Just checking, are we permitted to expose SETLPI frame with IRS_IDR0.SETLPI set to 0
(IIUC it is what KVM currently sets)?

Thanks
Vladimir

> Cheers
> Vladimir
> 
>>> Thanks
>>> Vladimir
>> Thanks,
>> Sascha
> 

