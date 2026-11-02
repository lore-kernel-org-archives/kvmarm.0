Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793649293;
	b=MHj7a/F+ShCTwB6kYnc4Em4viWleNHVHVNHA2JeTIhLBPw6D1VGFuY1Et2UYLWX5xpww
	 r3ka7Rm7PoSSuEcu2dcIT31eDUWMab6uhdSskYXIRNKKkv7zYp1YFIkmr5iytCh7/pQtR
	 m5c7UpDNaui2ZXh0bc0x4lCip86bH6sxKv6nQtEm0SCbFb28h5YzVXHin7oA3d/r4MH8E
	 YOIgxZmfo3A3JjUfA3E+FVxVOxzZUEz8M6soXGB/tqzLYtbqREGeFt492HzbR2p/llqmj
	 HVRj61w4WrjikWIg21LuusJ1SlnO3DSK1atQVUvtEyKDAo16wJy1lhVC47bGd9Ml9GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793649293;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=qQZlprcLCqGJpLfm0p60QEg4NrqMVcGx4q7JCCY84zc=;
	b=DlfjHx8xC85AKCj7QGTDEl3aDL9Wyk1w1as3HFC2dIrswZt//L/feJtLOevrnbejKHbo
	 v9VpcmMRN2x5mlKg+vVFYBBd0kas1mugmRqD/eVckN7X14uIw5rOYlKu3BpO8idTn6TRh
	 9x7+ZAvmJmvuK5FIMN0QSrzRcQc0lQvpM51WrRFPggWXT/zlLuYyUh2hMSf1vOb4TvIXl
	 xzxSCzPc2jfhzmfvYM1eGORMbpkH38lT6JHMDSK6KE06Tc9qAFZCfJt9jG44W/7AkZbsy
	 fHliggUgL1+TuaeFEheLXGcKOSeow1ZrRBGmHlq7pm5XQNVQDidwvmkQVz/Alj6gRkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="X/kk41v/";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C5DC606A324
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 19:54:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C5DC606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=X/kk41v/
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 453761576;
	Mon,  2 Nov 2026 11:54:49 -0800 (PST)
Received: from [10.57.89.36] (unknown [10.57.89.36])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 34F1C3F673;
	Mon,  2 Nov 2026 11:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793649292; bh=3qWgROG2eeRHWA/3jGfeifpn46oZOrIOyXPJYK9WxrE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X/kk41v/6JhALMLbRnT0y8hn0y2CjG+9vLipSw03oCiDRRonA7m5yrVRjHtSL1c8x
	 rTIP/taw8fR/43CzaCJmUF+8AydW7qiZ0bNzTmfb5btOZii/dVGlRPg6E56jmMd7vC
	 gm7k6LQUMvg9ODKqmQwnGQkRyf4nHvTzPw6lfAFc=
Message-ID: <27662aa1-c34c-47b4-acff-33ab8ed532e6@arm.com>
Date: Mon, 2 Nov 2026 19:54:49 +0000
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
Subject: Re: [PATCH kvmtool v3 00/21] arm64: Support GICv5-based guests
To: Vladimir Murzin <vladimir.murzin@arm.com>,
 "will@kernel.org" <will@kernel.org>,
 "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>
Cc: "maz@kernel.org" <maz@kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 Timothy Hayes <Timothy.Hayes@arm.com>,
 Peter Maydell <peter.maydell@linaro.org>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
 <8658049d-fdd3-49a5-9b8e-acf3c3467c1d@arm.com>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <8658049d-fdd3-49a5-9b8e-acf3c3467c1d@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Vladimir,

On 21/10/2026 11:35, Vladimir Murzin wrote:
> Hi Sascha,
> 
> On 10/16/26 16:39, Sascha Bischoff wrote:
>> This series adds support for GICv5-based VMs to kvmtool. These are
>> exposed as --irqchip=gicv5 and --irqchip=gicv5-its, where the former
>> only creates a vGICv5 device and the latter adds in a GICv5 ITS. The
>> GICv5 specification can be found at [1].
>>
>> The GICv5 support in KVM needed by --irqchip=gicv5 is expected to
>> land in Linux v7.4. KVM support for GICv5 ITS has yet to be posted,
>> but should follow shortly. Thus, --irqchip=gicv5 works with the
>> corresponding KVM changes, while --irqchip=gicv5-its cannot yet be
>> used with upstream KVM.
>>
> 

First of all, sorry for the delay on my part. Thanks a lot for the time 
you have spent reviewing and testing these changes. I really appreciate it.

> I successfully booted a Linux guest on GICv5 FVP (with FEAT_GCIE_LEGACY)
> using both --irqchip=gicv5 and --irqchip=gicv3. I also used this series
> to boot a Linux guest on GICv3 FVP with kvmtool's automatic irqchip selection.
> Everything worked fine.

Phew, that's good news!

> 
> FWIW, feel free to add
> 
> Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
> 
> for non-ITS parts.

Thanks, have done so!

> 
> Since --irqchip=gicv5 already provides a usable Linux guest and is
> aligned with upstream vGICv5 support, it would be nice to get these
> parts merged sooner (which would also reduce the series to just ITS
> support). So I'll do my best to review non-ITS bits.

Yeah, the IRS part is what I am keen to get in sooner rather than later. 
I'll post a new version of these changes soon. However, I will keep the 
ITS changes in there - they're already at the end and hence are easy to 
drop, and it is useful to be able to point people to a complete series 
for testing the GICv5 ITS support in KVM.

I hope that's OK! Feel free to completely ignore the ITS support for the 
time being.

> 
> Cheers
> Vladimir

Thanks,
Sascha
