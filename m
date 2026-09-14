Received: from mta0.migadu.com (out-132.mta0.migadu.com [91.218.175.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553FA3DCDBF
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 13:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789392367; cv=none; b=InBE16kw+zWC36BDQyHIlvuECiCMnEbfDelTXiJ9rI360F3v6N/cIzmE4zaTHzcBEBrXMCzwTXJiVwcVHAZqQS4gFGrMS4fRv0yHIcPUjdiJYp4ow8ERcikJx6RLU3XpknbX6U+TqrjgCHXbzWqJGNQFHQua4GfvtHuZebfDmSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789392367; c=relaxed/simple;
	bh=+N3/FMtODxlYu0yzHGvAetRCmi/Ara+QGgp0mXejZKI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lPTlfMTPkO/KC34+BgN29tNJRUx2ZlXwLBNd7yoBpfj5/Uy1Wfmhbl5lLbnrrcQqXlryIp24woijv8r/HM4t6i1LlzqsYbs/FOjk0gqNptPk2CmWxPCuJuujwW2Fy9nk1mZh0rrnaOoOV/XmBY9EUI0HNtcPKO6ByAM51dp5asw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Tsk0Es2v; arc=none smtp.client-ip=91.218.175.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Tsk0Es2v"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=+N3/FMtODxlYu0yzHGvAetRCmi/Ara+QGgp0mXejZKI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789392363; v=1; x=1789997163;
 b=Tsk0Es2v2PG6OZS/CS5Md6xhP7LbhnHUYwY4mJYIfWm5kL4IEMwjaQUE7j3jx8AHd8NDsG9x
 xAA6BbR5ZpOqnrnd5mknoCphb/WZPtxIWnpgfF5s81ADGZ0TRoYZ4DeoBnU+E/U624bMLdnKde1
 TGG2UKgbFLZl/QnKVhqAdRTk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 3b41933d2db18385;
	Mon, 14 Sep 2026 13:26:03 +0000
X-Mizu-Trace-ID: 3b41933d2db18385
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384b7so7800e87.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 06:25:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzOQf6aY2fOkOo8+z0GY5CLBBXBu+14fEqP9z6V+2Fy2iXQf7JKBgrgp29Hg7kUBqQ3P4oQ8zU=@lists.linux.dev
X-Gm-Message-State: AFuF++nxDJuuan5DPSF6AX/xFApxa1Nox66MnzO8RE5S9rJ/iZuEkGRu
	jLSrlU0NI2kuQdVa3ZHxH5rmWRPL/XObhHBH7+8c0poJBo2pFPmtdcFFkjP6Urnrr+atNonkIpm
	klFlpx60lWYenDJ4kEkm+F6JV8xBniT94geSOhAXR
X-Received: by 2002:a05:6512:158b:b0:5b6:4ad:d6bb with SMTP id
 2adb3069b0e04-5b8ae4c5899mr62300e87.16.1789392358016; Mon, 14 Sep 2026
 06:25:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260913203108.3343404-1-vdonnefort@google.com>
In-Reply-To: <20260913203108.3343404-1-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 14 Sep 2026 14:25:21 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxMq-HePyXDMoJGZGkdnQ6HXtFAe9pjH16e2V9De74oNQ@mail.gmail.com>
X-Gm-Features: AcwNN1UW_r2mHiYhGRo37JOJzCoHDwSb5JGU4WvZjTv5ua45gr-aCFqUp_0FaZI
Message-ID: <CA+EHjTxMq-HePyXDMoJGZGkdnQ6HXtFAe9pjH16e2V9De74oNQ@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: Advertise MMFR0 TGRAN for pVMs
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Sun, Sep 13, 2026 at 9:31 PM Vincent Donnefort <vdonnefort@google.com> wrote:
>
> Protected VMs can support granules bigger than 4K. Advertise TGRAN16 and
> TGRAN64. TGRAN4 wasn't advertised as it is enabled by default (supported
> when 0). Add it as well for consistence.

nit: consistency

LGTM. However, could you fix the message for TGRAN4 and TGRAN64, and
add a Fixes: tag for 6c30bfb18d0b ("KVM: arm64: Add handlers for
protected VM System Registers")? 0 is IMP for both, so omitting them
advertised them: on the M4, where TGRAN64 reads 0xf, a 64K guest spins
at 100% with a silent console instead of parking. Those two lines are
a fix, not just a consistency change.

Tested under QEMU with protected and non-protected 4K and 16K guests,
and on an M4 with protected 4K, 16K and 64K guests.
Tested-by: Fuad Tabba <tabba@google.com>

With the commit message updated:
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
