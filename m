Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.128
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795521817;
	b=FzsJf/11ZiQ6Rfz3zGcOUfWFhyJNRSUURQlN3YUp6J3nayr0hliPxXLO2fnOxwI8bpji
	 z9HeakDU8XFZh7vpUcNSBzVQ+2jIiva62gRODVhM0jht60AHQkjUkIypEeATkXeOI/KXk
	 vP7OjcFA1FlmzXIEyoiORgi/2CmQopZH0/wuclBMgfaLmeEIA7scsmPuC1CnMWCjkIE+i
	 Tgn6Dyomomee8hNYcKjRe89PP5dTG+dlsk7LqAc90ClNaFAHqi+FUPm4DBVpBgKqKKA57
	 1gZzZBuRgugq647egqK7BF2uo7P1aqUAwoEQw5CLkuHGckt/QnhsXtqBzJ9A2tLSkxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795521817;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=sr8kNtZUVcrLtCrf+RT8Hi9gA3/tGSBNUGobytTqIAA=;
	b=gK7XHi15wIgFq01B1NExo9DN1s4xUyPJ0U5jYQzuOOC+nUvktj89rOeHmF2ZnWuSmSVg
	 o2HmOrXO+HjSQYfueQFz5VqE4y+B/inFO8xfY5Jj9WjbFFk/NaX4z1J9zdeg21E8QJmPE
	 u1cvLyjmNhs8QiRnXB7TuLDqyw1HSMOnDsFil7/VSQ4XVtHkZbyU9fCtWrusI3sBe0c6m
	 7Ao3BdncCQE3eRahauSbmDKz0yZzznhuSZXY4vgCZpW/UJt39o6zcvErCQdcgOzuUg56T
	 unKYz4sE6rFzCqWUrdzVscWVysJZIh2sW9Cxc/7k3tgYLJ/NG9j3HJSCx1/vAby/o4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uirWn9No;
	arc=none smtp.remote-ip=95.215.58.128
Received: from mta1.migadu.com (out-128.mta1.migadu.com [95.215.58.128])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38807606A31E
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 12:03:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38807606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uirWn9No
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=sq+1U9QBpgUl6gibIVwLvQO1miis3EZ+uRylCpz45Xo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795521814; v=1; x=1796126614;
 b=uirWn9NoEnOAGA1QLmhh6dTHi2v2AHIaOs+2kXHIz2N7rAVPplSsN0iZzCh86DSUnHvwCvtx
 GPnZ1o5blQZheFcSII6SWzio4UeyBm3MYx0a74jJNq63ViidFf9YJpI8y469b03pnVLbywnLPHC
 bifBMoiPmc5b0leJKYBO5UT0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 78a6f0b49a6cb946;
	Tue, 24 Nov 2026 12:03:34 +0000
X-Mizu-Trace-ID: 78a6f0b49a6cb946
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5be58ad9600so22970e87.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 04:03:33 -0800 (PST)
X-Gm-Message-State: APuU4Z+DWYcydLSTd6hTbYn88ftfTFO8FLdfGYPUFcaAtP0m0zdjdFej
	8siKfnagDn2G8jhX2rDnYXSDBE1MYYxuSmlIecqXI3SheKbgN2MnsyaJvT9wFPGTdn08LmyQdSD
	fPX7S9yCCmyGOTBSC9fInss1swe5wbBt6WJ9XCeuM
X-Received: by 2002:a05:6512:3d1d:b0:5bf:f0fb:2c9c with SMTP id
 2adb3069b0e04-5c1c8256cebmr422660e87.5.1795521812773; Tue, 24 Nov 2026
 04:03:32 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261123192457.8700-1-maz@kernel.org> <20261123192457.8700-4-maz@kernel.org>
 <CA+EHjTynhBzhjrFzd514Sycib=1rmh7JqYp0xSPVBvurk6Sm-A@mail.gmail.com> <86a4myzeos.wl-maz@kernel.org>
In-Reply-To: <86a4myzeos.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 24 Nov 2026 12:02:56 +0000
X-Gmail-Original-Message-ID: <CA+EHjTyOzMofQ-7exH65h1G0jCtNy=f9MsW2ORSpLpF4J8xZ5w@mail.gmail.com>
X-Gm-Features: Aa3M54o_qgTofyawRoobP2Y_UigNAYnryN0_2l63uok4neYEvOqeAAfM8d_tF7s
Message-ID: <CA+EHjTyOzMofQ-7exH65h1G0jCtNy=f9MsW2ORSpLpF4J8xZ5w@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Drop open-coded GIC idreg sanitisation
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Tue, 24 Nov 2026 10:50:11 +0000, Marc Zyngier <maz@kernel.org> wrote:
[...]
> However, I want to know whether this change is an acceptable behaviour
> or not *from an ABI perspective*. We have several options:
>
> (1) delay all idreg enforcement to the same (late) point
>
> (2) keep things as currently done, meaning that the GIC fields are
>     special and sanitised at a different time
>
> (3) say that idregs can change at any point if you change the
>     configuration of the system, such as creating a GIC
>
> I'd be tempted to go with either (1) or (3). (2) feels like a total
> bodge.

(3) works. The GIC fields can already change when userspace creates
the vGIC. The final ID_AA64MMFR3_EL1 only depends on the order if
userspace sets S1PIE or S1POE without the features they imply, creates
the vGIC, then sets those features.

(1) changes one thing afaict. A VMM that saves the ID registers
between creating the vGIC and the first run, and writes them back once
the VM has run, would get -EBUSY where the vGIC's GIC fields differ
from their reset value. QEMU and crosvm copy the registers as a block,
but I don't know if either ever does that.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
