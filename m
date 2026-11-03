Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.246
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793732934;
	b=wWTzRf1of+ozK78IE6RhjDIsV8gUQLMThN2cxkQyxPWgbiWI06JQ7qHVFSaIjOxQWn3k
	 1lt9LkAyNOA1moHf+BoDVplmJZ+A+adGzd6vBKfsRm/2Y8CXeEaAaAeWBxgFWlAW2TMc4
	 2nslnFxqYAH6cgdobfHX6E0AtrmpkwUOucs87kcRWaEvQ9vAhGxmMnTlTgeL6CCrZUciX
	 CMiQuD24+ZT9PiWON+kRB+bq6IoEaHgwoSAx6xlfS2h0qKM2AZMi2ANMVALAxruRnvYmb
	 Y2qVxjg3g4TAT+dBbCvhg8wDy8hQY78cIB6Ll8b/JMBWoacNigwp+60cqM/dMgjwEzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793732934;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=yRNBCNleXapj6/D9Dy5JVT8U1O3DIrFP6P/UGlFxQWo=;
	b=oXBdfRHjJYZmtjDETpBv/QzODxHsTTMpuVAJfBgwutf0B9IOjAlFToH42p/qFP934qJX
	 A256tv47mBoKv1a1ntKMiVOSSHtBHeQHETlpgcH00o1EtfkHosyNXlpEaDxp7CH/fxmj8
	 0AEj/KrT5x8n9a8qG2OwG5NN5U/IB0h4ZFb1m0ZMZ5+wg5o9tGSJdYKEuzQz7dBlStGm9
	 Ns9H0WlnNCq+GgT8U+Hhk2IEQMpbRhBtis9zMjrIlC/CfBmHAKpBdAN4jJOuj8R18n5El
	 CbAlnIKjsiuKciM3AeNeL7zQyypKQDuXwG1jnlpZQRFQcWZreMIbb4FZ/O+qf/bIIAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=k7QRZwec;
	arc=none smtp.remote-ip=95.215.58.246
Received: from mta1.migadu.com (out-246.mta1.migadu.com [95.215.58.246])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83559606D808
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 19:08:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83559606D808
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=k7QRZwec
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=yRNBCNleXapj6/D9Dy5JVT8U1O3DIrFP6P/UGlFxQWo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793732930; v=1; x=1794337730;
 b=k7QRZwecMPnx/QNoipPrtAdaySBRx3hl/uQlIte0h3pc6j81BpJEyvmJMLgjW27PEHJq3fn7
 GkuylPGVP2vVQAAVeS8Oy4wl+cJyPCsgsCg66qoNrR9SUQFmRC8N3yFoJZsBgcarJPO7eHERG1h
 Rmgtj6Y4C/A9hI8OmLBMy01o=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ad2d3477951902c1;
	Tue, 03 Nov 2026 19:08:50 +0000
X-Mizu-Trace-ID: ad2d3477951902c1
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5bfca2a2af4so904e87.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 11:08:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBz72IO9uUU0DG1vptklDTmqHpIaipf90Fy78EHSC2J1ts/zO1QN9oL6K/hodEkfDG0Lb1ZLJhI=@lists.linux.dev
X-Gm-Message-State: APuU4Z+P+oEudefyaYv++Hoci3ZUhxqnOvY/TwRIuO9ldw9A3flulb8y
	jW880RYXdRFzkMB/XjnkUZ7HaYPuFG5YaHGAnt1l5xE2moAgnDUfwWnvOKkUSq9LuRJviGZeV6V
	XZpHWLVwqOBSQJHcfy/1MKolbYkpCV5tL6Oxk7Lqw
X-Received: by 2002:a05:6512:6c8:b0:5bf:c9c6:ae92 with SMTP id
 2adb3069b0e04-5bff406f902mr12922e87.7.1793732925312; Tue, 03 Nov 2026
 11:08:45 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261103084742.1302597-1-fuad.tabba@linux.dev> <auoT0b1LxuDlZOnc@kernel.org>
In-Reply-To: <auoT0b1LxuDlZOnc@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 3 Nov 2026 19:08:08 +0000
X-Gmail-Original-Message-ID: <CA+EHjTynpZOE5s4U_Ls4WHdhHqTTo5Vp8YqKxK3EwxBT3O2XVg@mail.gmail.com>
X-Gm-Features: AclHuK8AbjAuWLo00Tzpop7EQF-bwBMdIvmJij4-h9aVeKs-eFdilzti7zR-K-4
Message-ID: <CA+EHjTynpZOE5s4U_Ls4WHdhHqTTo5Vp8YqKxK3EwxBT3O2XVg@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Stop stage-2 teardown scaling with the
 IPA size
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Tue, 03 Nov 2026 17:03:13 +0000, Oliver Upton <oupton@kernel.org> wrote:
[...]
> I don't see why optimized destroy walks for CCA and pKVM is
> fundamentally incompatible with driving them from a loop that
> reschedules. Non-preemptible kernels are still very much a thing, I'd
> rather not undo the fix we took for that exact use case.
>
> So unless I'm missing something completely obvious, I'd rather that CCA
> and pKVM do teardowns from that loop.

In v2, pKVM's teardown will run from that loop.
kvm_pgtable_stage2_destroy_range() will return where its walk stopped
(Suzuki's suggestion) and pkvm_pgtable_stage2_destroy_range() where
the next mapping starts, so stage2_destroy_range() resumes from there.
That replaces the pKVM path in patch 1 and the lookup in patch 2, and
I'll drop patch 3 and the Fixes: tags.

Thanks,
/fuad
