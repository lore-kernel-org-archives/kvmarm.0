Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794322663;
	b=asnWNNVlj8p3+8LbbF+iGBAIq6Xmfd9ljVb02Ja6Ckz1gd7UAsdBkokNUf9FWVym07Qe
	 gNQPAMUJ56YRqWODFAkd75ufvhZWUI1AdupeJBMA+OF2wWzCdES+BEG53B/hpdnG4LK6O
	 BO66HDGqOylFtF/Iv6aOy/iJ81GECP1D9C2zbioZAnvOArK/W4qmnSFmHzKOXNpqv7AIa
	 gNK1AHwCZrtER9BcaSvo74hdVgo6BAEzU+XGqQPb3na8lBPUqtbkP0UQsHRMN90h/3Pp2
	 AqMklqhCJj3UPjE8MsFqC3qxAPcFsJUCdvkjXoq/QL0MtG+payFMbnJJBn48EdncqkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794322663;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=fLlVJdPL3DY4EDAqFahzx8+kySFUr4xeSi3l9Ce0Ktk=;
	b=JGZ+ZRj9mzRy4WCVQELwTbTg+xQ7ejBAk/E2uIrUqqxfBJyjo6Uw6L9mZjFcd2XK+BGj
	 ygZiqxdsjNzw1VeRFi/8MPk+mAoz8n8KwQ9gLB5F8hJsJOYrI+Fnr2YjClNNvwMJdWYIE
	 QY3HegMOkpLz3gH7rpGrEwMMyQfDW6U+J6qdHIjroiBxwCUgX5uc/l/oh6fvWWROAiAXw
	 b/b/Mx/duMYZONfRphNb3j2E4j/4Uk9jChg2IaAF+18zcmFNmpMA3zYYidvfJOuRTeziO
	 fbh92C467s4flMRmyTu9HxqjeqmISWuZQj81A+VnauWCtur+/tRfTp2Nf7gdfanEw/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XDABZq6d;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA2F60A2602
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 14:57:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DA2F60A2602
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XDABZq6d
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04B251477;
	Tue, 10 Nov 2026 06:57:39 -0800 (PST)
Received: from [10.0.154.42] (e121487-lin.cambridge.arm.com [10.0.154.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7CA503F632;
	Tue, 10 Nov 2026 06:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794322662; bh=S1BfGexgfnGouZFA00zRJdKPcI1rxUjpr6WoZSMWPuk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XDABZq6d1v3+n6W+0nHpluNWB/cjTXK1gYFQyLAqeaM3hF8XP+E/XomAP12yY9/Kk
	 kFpxNRdXOUpmr6uvdP955bLYQAEqK/oB+q0ShEn/86IK8mndNag2SS1gCszJQsGzp2
	 WhgS6XJU05KAr2iUhfqxT/DDBzhXsfv7yXlzKko8=
Message-ID: <a991250c-946b-456f-bf61-f1ab536365bf@arm.com>
Date: Tue, 10 Nov 2026 14:57:38 +0000
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
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
 <20261016153939.913764-14-sascha.bischoff@arm.com>
 <412dc63b-df1f-4748-8235-542ecfc23894@arm.com>
 <a9f3e466-ab2b-4c98-a237-d8bd6810e06c@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <a9f3e466-ab2b-4c98-a237-d8bd6810e06c@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sascha,

On 11/2/26 20:51, Sascha Bischoff wrote:
> On 26/10/2026 13:03, Vladimir Murzin wrote:
>> On 10/16/26 16:39, Sascha Bischoff wrote:
>>> Describe the IRS CONFIG and SETLPI frames and associate each CPU
>>> phandle with its IAFFID. This lets the guest discover and configure
>>> the IRS for shared interrupts.
> 
> Hi Vladimir,
> 
>>
>> Out of curiosity why do we expose SETLPI frame to a guest?
> 
> Frankly, in case we want to make use of it one day. The intent for the SETLPI frame is that is allows the injection of LPIs by a device without an ITS being present. Effectively, it gives MSI support without translation.
> 
> Rather than writing an EventID/DeviceID pair to the ITS_TRANSLATE_FRAME (specifically the ITS_TRANSLATER or ITS_RL_TRANSLATER) and having the (virtual) ITS translate them using the Device- and Interrupt-Translation-Tables, an implementation that includes the SETLPI_FRAME allows a device to directly write the LPI to make pending.
> 
> This isn't something intended for use on the physical side, so we don't strictly expect any physical implementations to include the SETLPI_FRAME (famous last words?). However, it is something that an emulated GICv5 implementation can go and do if it doesn't want the complexity of emulating an ITS.
> 
> When initially prototyping the GICv5 support, I did have a SETLPI driver that tested this mechanism, as software buy-in is also required for this to work. Instead of programming the DT/ITT with the translation, it just gives the device the desired LPI as the "event" instead.
> 
> Does that answer your question?
> 


Yes, I was mostly wondering if we are going to have any user for that, but
now I realised that it could be user (selftest and/or kvm-unit-test) which
make sure that SETLPI stays unimplemented :D

Cheers
Vladimir

>>
>> Thanks
>> Vladimir
> 
> Thanks,
> Sascha

