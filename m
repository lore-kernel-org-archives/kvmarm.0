Received: from mta1.migadu.com (out-65.mta1.migadu.com [95.215.58.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301274E9C08
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 16:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790611997; cv=none; b=N/qXsoJQLxnA2lvWQCKj35UZw65MD1YKwiVmn2TjS7rsVRN30tAC1p/7zgQpwGPQqC5WvVYsKhSJp+xNpJsgYeHp6QHsAbbRpMxbNeYG/EtoXXMXTLAZzFSvTkukVUMF1w9LkMIHVeeM6RNu+XaVruoRrD4RZ3PthgYzfnWQEEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790611997; c=relaxed/simple;
	bh=VCYMxlYVrU0ZRUnBfl0gDlG7/5tTg9Tcf8QxOVlz+MI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N+2u6Vo5xKHMqFJN3rSWhFjWNUUAG0spOljjVFeQMWgWopEDkimDOxDdqYbuFRVUaMqEi2y1opyUhMmvQwnhw3V2cKiOR1CrId75JwRAkrLaD5E7ZdubLATs5Iso40f7tCc8If7tXGOEyxUa/w3Kv1ighYF04PkjnxRae9p6NVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O05xgrkf; arc=none smtp.client-ip=95.215.58.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O05xgrkf"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=VCYMxlYVrU0ZRUnBfl0gDlG7/5tTg9Tcf8QxOVlz+MI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790611993; v=1; x=1791216793;
 b=O05xgrkfehz1moWxVChhG7F+KGscLzMUB2q7FBjfBhvjer2SSLRWVtyYNCBODTqpa+/MiKC/
 0pL4Xtq1CseKAehukkLlF/tPFHEagR7Y5/NUZLC+PEirvQ2vSYg7cGbL11vrmBlor5GHGSVM4sA
 0rbB3ZzOrkqxtHTGkA0eZyNU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e237c45ff539bdae;
	Mon, 28 Sep 2026 16:13:13 +0000
X-Mizu-Trace-ID: e237c45ff539bdae
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b8e81e2a0bso12709e87.0
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 09:13:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy3RC1HlxRpnxbPiT0K66qbJbpEVCOUvA/roRirUrllA2VGRau/GpQTZgAvkXYTsfS0rJoK+Ks=@lists.linux.dev
X-Gm-Message-State: AFq9FYIXKzdIyDtGKCRqReZM9HPXN02iX1k9Q605dxJct5S9OPF7I51J
	nQnZFZgpIpz9Jm9vE1Ty/JTaTJdj+6cOCzNi0N+UpdBoe0WR7Za+ypBrpION4c27yUL3lBOd96r
	kajm5NBbWiBu+6c5bJ+fsp/LJEBqe0456llpM4gF7
X-Received: by 2002:ac2:4650:0:b0:5b8:f142:cf3 with SMTP id
 2adb3069b0e04-5b8f1420dc7mr105362e87.11.1790611989788; Mon, 28 Sep 2026
 09:13:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260928152507.2116110-1-fuad.tabba@linux.dev> <86cxtx4bbp.wl-maz@kernel.org>
In-Reply-To: <86cxtx4bbp.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 28 Sep 2026 17:12:33 +0100
X-Gmail-Original-Message-ID: <CA+EHjTymQqcARDNHHDvkjFvEuf1C78NsvPJwcnaH4bOu-m9tQw@mail.gmail.com>
X-Gm-Features: AclHuK-OWctusFN_TR3hIpHHx8_H0y3i7Oz0Ee1onONuAo5w9l_i54qFA-ucEZA
Message-ID: <CA+EHjTymQqcARDNHHDvkjFvEuf1C78NsvPJwcnaH4bOu-m9tQw@mail.gmail.com>
Subject: Re: [PATCH v1 00/10] KVM: arm64: Nested stage-2 walk error handling
 and other small fixes
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Karl Mehltretter <kmehltretter@gmail.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 28 Sep 2026 16:58:34 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > retiring with the fault in PAR_EL1. Reporting the unreadable descriptor
> > as a Data Abort instead, for the stage-1 walks too, is a separate
> > change I'll send later.
>
> Why later?

The loop fix is small and stops the hang. The Data Abort change
replaces the SEA-in-PAR_EL1 reporting at the four walk sites in at.c
and nested.c and has to stop the PC advancing past the AT. I haven't
done it yet, and I didn't want to hold the hang fix for it.

[...]
> My definition of a series is "an ordered set of changes that have a
> common theme or form a progression towards a precise goal". This is
> not a series, but a patch dump.
> </rant>

Sorry about that. When you asked me a couple of weeks ago to group
related patches rather than post them one at a time, I took it past
"related" and put everything small I had into one series.

I'll split it. The nested AT walk fixes with their selftest as one
series, with the Data Abort change in it if you'd rather have them
together, the SMCCC filter WARN on its own with Oliver's change, the
three documentation fixes as one series, and the two selftest leaks as
one.

Sorry again :)

Cheers,
/fuad
