Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0096D35028D
	for <kvmarm@lists.linux.dev>; Thu, 25 Jun 2026 11:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386052; cv=none; b=iU9j2lc2oqW4vDcH/Mxuhld3BlwrO2hici+XZEFv+h4OmMo4qyK/JPQjKJsS3pTU8LSlgR7ahYprtrZHe04vkHlN7aktkFDK0roRVQmHbi4EeTXvA8SZE60eu8oLzuFvmurtNVojUnKUgHPV/dNXbtZxmguqZwuxSCl1x12se1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386052; c=relaxed/simple;
	bh=AF4UOY+6DNG4bmW7MhXoWzfZdBspNcMGDyFSUv3KGH0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n1ma5gXk/KyPvJZgxF17vsCgiKkPfZ3WPN8q5asTx5MK6lr29bsEIaisOf/w6v5crcX/zWKnptXI7geKa6mUeDWiP4tZb2/O8mUUR/gDDjI6ehtyAOyI20/DIf02fSDf38IMVTdIkBKbRQ1ySHaBcK/CZk2fV15x/S97y5KY66A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tY9BLDrL; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tY9BLDrL"
X-Forwarded-Encrypted: i=1; AFNElJ/DywxW2jZQ5FfDHKd3SlWB+oYLHjK89E7/sL2A0bkVNUV+7ZRE5Al45OwaPTMyag7mCSaoPEw=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782386048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Js4jLF01npwzaOg3T/bUVrQbZfaivvWEjYI8DxgoW1s=;
	b=tY9BLDrLzyW8QaczU6zegbxbA5jIbigNbBIuN7+HKRgqNNujoo6kmrP1zcHoCJqvFI3zJj
	rIWbrKUv6JIsoeUPnSc7CCdHASe2wV/H7l5AT1jgCrWUBzn2Md628XrVlGJ05Eg5MZBf4m
	/nI8VkNWdQWZkB9tn7wZt9zqA5fs3N0=
X-Gm-Message-State: AOJu0YxU7gOmludqaLllp36j1sxYpW5f8NPgdupBTMJUVQ0EFHabJulY
	fbKwxCdXQXo5EIxCrzZj+hK1FKL6oD2I7KxxeiEqxvzR158CnF8tZvbRco2Qk2rWru9Uafnqe90
	3syC4sPCSrieZvd9Y4dpbfMSePBZiTaKBiepkc3E/
X-Received: by 2002:ac8:7d88:0:b0:517:99ea:ab7e with SMTP id
 d75a77b69052e-51a6ebaf887mr9204431cf.24.1782386044257; Thu, 25 Jun 2026
 04:14:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260622190701.2039766-1-fuad.tabba@linux.dev>
 <20260622190701.2039766-2-fuad.tabba@linux.dev> <86tsqtqu9u.wl-maz@kernel.org>
 <CA+EHjTxn8W=KYqTeqs-ZTw-SBD9tH0zUz_O9rTHsq3M7ELXn_w@mail.gmail.com> <86fr2bq6b6.wl-maz@kernel.org>
In-Reply-To: <86fr2bq6b6.wl-maz@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 25 Jun 2026 12:13:27 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzJhP5hPSnp-=2ESCReDz3dPs-Cukw8z5UJru+7haT2jQ@mail.gmail.com>
X-Gm-Features: AVVi8CfTVMMlR1q7q5K8mMEw1_PqrmGvfIYlVGc5ZR0jkKVtOnV-eMOeM419v3U
Message-ID: <CA+EHjTzJhP5hPSnp-=2ESCReDz3dPs-Cukw8z5UJru+7haT2jQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Fix sign-extension of MMIO loads
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Thu, 25 Jun 2026 at 11:10, Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 23 Jun 2026 14:51:49 +0100,
> Fuad Tabba <fuad.tabba@linux.dev> wrote:
> >
> > My reading of the ARM ARM is that the byte reversal is keyed on the access
> > size there too. It lives in Mem{size}, with the register width handled
> > separately by SignExtend(regsize):
> >
> >     data = Mem[address, 2];        // byte-reversed by the access size, BE
> >     X[t] = SignExtend(data, regsize);
> >
> > So vcpu_data_host_to_guest(..., len) swapping by len matches the Mem-side
> > reversal. Swapping by the register width would reorder bytes that were never
> > loaded. An LDRSH into Wt reads 2 bytes but would bswap 4: the halfword
> > reaches the helper as 0x0180 host-native, cpu_to_be32 turns it into
> > 0x80010000 instead of the 0x8001 cpu_to_be16 gives, and it never sign-extends
> > to 0xffff8001.
> >
> > If that reading holds, none of the helper's ops are individually wrong, and
> > the only bug was the order, with the sign-extend running before the swap and
> > the width mask then dropping it. But I've gone round in circles on endianness
> > before (to say the least), so please say if I've done it again.
>
> That's quite convincing.
>
> And the quoted pseudocode is much easier to reason about than the
> current blurb in the commit message. For reference, J1.2.3.111 Mem{}()
> is the relevant bit of the M.b spec and clearly shows that the access
> is done LE, and only then byteswapped. Can you please repaint the
> commit log to describe things in those terms?

Will do.

>
> Also, can you augment your test to cover for BE accesses from the
> guest if the HW supports it?

I'll see what I can come up with...

Cheers,
/fuad



>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
