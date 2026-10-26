Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.220
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015465;
	b=lRlHl6TqokCzYDxcNJJkUGUmmwvXoW7VEwYIHi0aeGThEZ8UXMuaZkJUP1GoWplkfRrk
	 xBtZDWhTxt5JerbO/1fV66hF60nO/U2wCxtptqMeiKG20/euMAvsNbOBoPITL0WA2nxjK
	 62lIGY2gKjHox8/1pcvCSydHd3VeeFd5ved9nEXfufyLU2BPGRxOVlUHq/l5/Q7CBLSop
	 SZQ9u7Toc4Egnm+moQliyLab/OTyFcwzuQMKpeirpz72oCFvzAekpjAy0n6tF0LIuhDfP
	 zkrb5Dt9dZiwbDI9+KtezxrH6KWak2gCbrdcfTg8U/wtK9EJgidSSSGAfmArCLZI8qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015465;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=CmSw/EcPNEFhZ05u7chdCHEUGoMyzD3k6SqbGkaBrz4=;
	b=KRsvu/ykQTwRdSsQt+a7WQHi4hVcO+A4sY4akJ44hoi3RI8dhT/pzpplr6cVoQfHlW9T
	 Em9jDJMzSTkvFgoVz1ryzZ2OtZDf1hqa7NU4I7xWw09rYqp/R12Yh2fQWwRaImNY9Ubxx
	 +XK7G13FwXPG0ualXxGFJ3MQa8M4yJ66PAAIb8JRpqYAjTzSJJn3OirrxnXURZSaeHX09
	 P0UNLOvFU0AAcZxy0i/8CZqHcCxkXPmAFIQlyxKefCUHPDyTMfgG4S3qzZjUbvQCpRPef
	 /Tg7CUdlzTeoz8Haurxsdym2+l9WAC0XV/cAAll2a3MqmksYFGjnIe/ywwwgNIiGcWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Tw6qjBeK;
	arc=none smtp.remote-ip=91.218.175.220
Received: from mta0.migadu.com (out-220.mta0.migadu.com [91.218.175.220])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC134606A31B
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 11:51:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC134606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Tw6qjBeK
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=CmSw/EcPNEFhZ05u7chdCHEUGoMyzD3k6SqbGkaBrz4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793015462; v=1; x=1793620262;
 b=Tw6qjBeKiT9pLmehYrWlc6zUtz5jHK5P+iksl0Pmt73+ot2moYXjhAeHDHDWYYZE4YJUG11c
 joZbig81W+bd3W7vwRmZ6pfTs0kL1Rm4ghF52ZtBZny86az/VGTa8hv6nl8CUnfLVMIGffzCbB0
 blXZP9cgoiEk4B4Ad6jylNsY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4d9bf51f483ecd8c;
	Mon, 26 Oct 2026 11:51:02 +0000
X-Mizu-Trace-ID: 4d9bf51f483ecd8c
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5be3b2f17c1so7904e87.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 04:51:00 -0700 (PDT)
X-Gm-Message-State: AFq9FYJb1CtpAR1jyP+ePdxHduyapw7YJnKc9ysspgn9yvMAFm1NsY9g
	kzUVt9BID9N12et/jKYfRJoMhnesb8bUTp2as/FQpmu23pZW/Ls+b39xKlDzigwV7U4UEkTGbHd
	7e5lxK2XPftnZTXZLC5eZ0/ReA4IcQ0cRD37vtHi7
X-Received: by 2002:a05:6512:1598:b0:5bf:b5a1:392a with SMTP id
 2adb3069b0e04-5bfb79cfc82mr116080e87.12.1793015459786; Mon, 26 Oct 2026
 04:50:59 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261026082633.2515820-1-maz@kernel.org>
In-Reply-To: <20261026082633.2515820-1-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 26 Oct 2026 11:50:23 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwr3Ormu7ZpdTrz5u-HHSYvZNSdZnTqUQa3-fcCFp9HtQ@mail.gmail.com>
X-Gm-Features: AclHuK9n1V_9PjmJWw8uVMutqUR5g90Qj_eInKfrHBv9Spjhh8J9uWzH3IugIoY
Message-ID: <CA+EHjTwr3Ormu7ZpdTrz5u-HHSYvZNSdZnTqUQa3-fcCFp9HtQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Don't let a guest overwrite HCRX_EL2.MCE2
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Oct 2026 at 08:26, Marc Zyngier <maz@kernel.org> wrote:
>
> FEAT_MOPS is fun. CPUs are allowed to implement any of two ways to

It's a hoot! :)

> perform the memory copy, and the hypervisor is in charge of hiding
> the difference between implementation when the vcpu migrates from
> one to another. This is unhelpfully signalled with an exception,
> which KVM diligently handles.
>
> Today, we don't really make a good job of it in the sense that
> if L1 also has the trap bit set, we don't forward the trap as
> the architecture would require us to do.
>
> But there is no good reason to forward this to the L1 guest if
> L2 generates the "I'm on the wrong implementation". KVM can fix
> it up in place and return to L2 directly, as if the physical CPU
> was able to implement both options.
>
> Conversely, allowing L1 to clear HCRX_EL2.MCE2 is counter-productive,
> and violates the abstraction that KVM aims to give.
>
> Implement this behaviour by never allowing the guest's view of
> HCRX_EL2.MCE2 to make it into the HW, and document that KVM is in
> charge of the A/B handling.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
