Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.39.247.168
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792507028;
	b=qJWX2IxCehBF612J/iyVVdDzrLE8oA/fNFTjD3I9XMOLLFin9nvvQXNvHsoT/mjqk/0J
	 zDmRi+l2ZWFkrZnJso89+yp+UQ88sDdejfdS+90Q6FxrexLmYvmi2NoKlx/Im05/7lcz2
	 V3Uz79/7OkMM6AoL478HTjL+ei14g1YeqjQfQs+fF4ovmOSLyJQUFi4syOHff/4VTPO7s
	 z3XfuzdRoKkgktsPJkKHJ1v/rSm6WuuQ4NnjIXyW3g+Hq0/pj+0bMqXBXvixXuKFf0BHM
	 7N8d69WrOQwsXRLdPjCFN/MKiQNUKFG+tICcg2K/DdOdVALSdFj/IlKM99ocHQ929xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792507028;
	h=DMARC-Filter:Message-ID:DKIM-Signature:Date:MIME-Version:Subject:To:
	 Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=/KQ70MsaDZXGGg9xwr15iwDR73QEsKB18yX4p0CKZSM=;
	b=2RJHdACkiGcoM9SlmAP4wblYlsSm8idcx0FCVMvwdbvc5hNGuiiB1B1rOpw7/mEH2+Wm
	 Y1HAGSJb8XtKFpz2I2h8HoC/lUllKVgKbC+qShWGu8XYLahH+4kEs5b0jGpXokcAmQpGN
	 tvpsv904O6xFVfJbkapfqo+GdQRwd8qt67PTQ0G3dDgPtkox9X78Q7J0PAK7nB8tpd6BR
	 5IlXaAMTT6N8vQGgwwpNvq/7YIo66iQwbeIP9k+luL/CYVco0I4/+ktXGHOmusvP37uf3
	 21FzdvTOZVV6Jaht05V02EV7z4zg9+Ng1R1sRwM2NmdWHoSWKETCUXady8QVWTyHt9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cyberchaos.dev;
	spf=pass smtp.mailfrom=cyberchaos.dev;
	dkim=pass header.d=cyberchaos.dev header.i=@cyberchaos.dev header.a=rsa-sha256 header.s=mail header.b=YggroFkc;
	arc=none smtp.remote-ip=195.39.247.168
Received: from mail.cyberchaos.dev (mail.cyberchaos.dev [195.39.247.168])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC73606A31B;
	Tue, 20 Oct 2026 14:37:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBC73606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cyberchaos.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberchaos.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cyberchaos.dev header.i=@cyberchaos.dev header.a=rsa-sha256 header.s=mail header.b=YggroFkc
Message-ID: <7e59d984-1c00-4414-aa45-3092491ac39b@cyberchaos.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberchaos.dev;
	s=mail; t=1792507019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/KQ70MsaDZXGGg9xwr15iwDR73QEsKB18yX4p0CKZSM=;
	b=YggroFkcCadfQfVG8niIpNsyieORHWjFzYJGR4w/M8tD1eH9iDKWbMHv5Jgf+IwlrHxLJB
	usD4/MSGgmm58e7uu+YwBIbmwpP1nLJ/M2O1xRpIi05kCSpf/p72CvGX11rD3GHaQbT2Eq
	oetmXAEU064lrnsbFA+yaG0sVJJyMwU=
Date: Tue, 20 Oct 2026 16:36:55 +0200
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] arm64: Apply existing Apple CPU workarounds to M3 and
 M4
To: Marc Zyngier <maz@kernel.org>,
 Michael Reeves <michael.reeves077@gmail.com>
Cc: Oliver Upton <oupton@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Myria Sarvay <myrialsarvay@gmail.com>,
 Yureka Lilian <yureka@cyberchaos.dev>, Fuad Tabba <fuad.tabba@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, Sven Peter <sven@kernel.org>,
 Janne Grunau <j@jannau.net>, Neal Gompa <neal@gompa.dev>,
 asahi@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261008-apple-m3-m4-kvm-v1-0-7bb4cbf3d63b@gmail.com>
 <20261008-apple-m3-m4-kvm-v1-2-7bb4cbf3d63b@gmail.com>
 <86cxtk2utm.wl-maz@kernel.org>
 <CANpmGNv4uYRLALMLKZn-HJwTiqJO90Fx23DOO7K7d-PfSWn=2w@mail.gmail.com>
 <86bj932ssc.wl-maz@kernel.org>
Content-Language: en-US
From: Yureka Lilian <yureka@cyberchaos.dev>
Autocrypt: addr=yuka@yuka.dev; keydata=
 xjMEZ3vnnhYJKwYBBAHaRw8BAQdAn6RVMnaxLzmDDx+J3jSUGY7BqjyDhsWhdwKBSI6QpXfN
 Fll1cmVrYSA8eXVrYUB5dWthLmRldj7CjgQTFgoANhYhBPGINbLQ3ypM7JNhigKbtnC7kwpH
 BQJne+eeAhsDBAsJCAcEFQoJCAUWAgMBAAIeBQIXgAAKCRACm7Zwu5MKRx1qAP9ToLaOMd73
 VVf1JdwoMc5G44OZfKNk/+ezt9Dl2oqZdQD/Xvgd0lytU3BZ4WnYeMNzo2xHeRxXmX+MfXhA
 D33tzQ/OOARne+eeEgorBgEEAZdVAQUBAQdAIs9uImfvgSCnJOcfvzshLuaSRJ/a0Vp/9rUA
 eBGZq10DAQgHwngEGBYKACAWIQTxiDWy0N8qTOyTYYoCm7Zwu5MKRwUCZ3vnngIbDAAKCRAC
 m7Zwu5MKRyW9AP0dBOuwgWso+QjBZUsbuEmGGUz2OWtszs2Yb7087RMerwEA3al6E7vqq0HC
 7LiB3nisU+xqQojJ4n/fWCu70iEkjQw=
In-Reply-To: <86bj932ssc.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/26 10:16, Marc Zyngier wrote:
> On Fri, 09 Oct 2026 01:03:57 +0100,
> Michael Reeves <michael.reeves077@gmail.com> wrote:
>>> I can provide the binary (and a few scripts) to test this easily.
>>> Should they have been fixed, we can always create a second
>>> implementation list to cover the PMU.
>> Can you please send that so we can try? That would be much
>> appreciated, thank you.
> I've sent you (and Yureka) details over IRC. If you need help with
> setting things up, let me know directly.
>
> Thanks,
>
> 	M.


Hi all,


sorry for the long delay on this. I needed to get my testing setup in 
shape to be able to run the tests with the limited amount of I/O I have 
working on these devices.
But I can now confirm, that the following SoCs reproduce the SEIS 
erratum (produce a host SError using the binary sent by Marc) unless the 
MIDR part numbers are added to the has_broken_gic_v3_seis list.

The affected SoCs are:
- T8132 (M4)
- T8140 (A18 Pro)
- T6050 (M5 Pro)

So please add those to the list for v2 of this series, and probably also 
add T604x (M4 Pro/Max) and T8142 (M5) since I doubt they will be different).


Thanks,

Yureka

