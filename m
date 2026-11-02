Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.26
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793622039;
	b=Ya8D/0pVp/CO18i6SCYf9YmUXhsJPqViZiRs72KFiOsx81BfaMZekjQIxGcpMFC5kfqt
	 wW+EQEeEB6LKF5765a65AVmIpS9rscuNcSRXWoW0G3lLHOnkrDYLLWt4zPeqhJOoTIQNZ
	 eIu7I+PalEpSv41TGA72fBOh/0nqAaxY6UNIPh2qnNFBQCQi4gT+Y1RMIQs4WU7czXhou
	 Io0ZUiVYb8lLIqVd7dIRuoferWdhmESUOZDS5EuCHv3aFSKZrlQmOmcqgYWIY9bsY4Hp4
	 LOt4waiaM7qCKppgl9NxQWmAHKKcdyn4xdj3oAWdn0pMPB1LjOlJAJL0DteSMsPu6Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793622039;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=n9Qb7Zv26gUhtCXZTzB8VxfwAxcPhk4AxUJPcz95PHE=;
	b=oQRprpiX5LYasEfJJSosQIV4xRPr5TUdR16BubKcgfJwLT9dU/Ec4EtW8+mTJUS/hFcz
	 d7RELuUsXmwVxryaIHp29Mc8ZTqpXml9PsnHF6F8p9QbJy9oE4EYFbDxh1ft5njrfwTYI
	 K5PJFktj9GvV5Mn5MioeD7FEH+a9/Ve5UhJNM3vMDpVQmKJ9hWU+zZB5ePV1GydxJkSdl
	 nkN8zfiBz6nWeA/u6shaZIkTmv3l2rA9AoqqNCMlgTh71VPqro7Jp1T79jAXDux6kWJKf
	 TdyskU8d9I2xsSwP2Kd6TpKeYoC7Z0jeOy21yTuCiC8xwAdvpV/EqJ6y2M+EtU1AheQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=frpi1aMT;
	arc=none smtp.remote-ip=91.218.175.26
Received: from mta0.migadu.com (out-26.mta0.migadu.com [91.218.175.26])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A903606A326
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 12:20:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A903606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=frpi1aMT
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=n9Qb7Zv26gUhtCXZTzB8VxfwAxcPhk4AxUJPcz95PHE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793622036; v=1; x=1794226836;
 b=frpi1aMT0grWOz2DbYDK5kmGCLFmpaykVNGiN2WrgYXCLoBU5dUH/2bclxmTXdfuGs7rU/Ra
 BieGWQQYhWKmT0H5/1NhlRj+8EKDcgbXXZxh9AVvQDzV5nncWOlVqgnFEfpYDAE95vt0RYufo3q
 2Ygcsh/hSqyBMESdnemx8aOg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 217921ee7ee95273;
	Mon, 02 Nov 2026 12:20:34 +0000
X-Mizu-Trace-ID: 217921ee7ee95273
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5be58ad9600so11204e87.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 04:20:32 -0800 (PST)
X-Gm-Message-State: APuU4Z+4HNBS+HOyMreM8l+tOpjfEPPnZW3BE/fXlJARo5uZvHjPPFQM
	VbsRQoU2XI/tqpiqA1ICDjK81R6gG6s0XjWaagRjj688hYRoDoHb8/czCRAB7Y9ICkpeAvhEjwk
	TPbFniinqLXIwKOyvpurdyYfI+/1lGtZd9NGrJO9M
X-Received: by 2002:a05:6512:67c3:b0:5bf:d238:4671 with SMTP id
 2adb3069b0e04-5bfd23846eamr373591e87.9.1793622031728; Mon, 02 Nov 2026
 04:20:31 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261102094748.2638468-2-ardb+git@google.com>
In-Reply-To: <20261102094748.2638468-2-ardb+git@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 2 Nov 2026 12:19:55 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwW9Pg+sMPOY49d9M5WLCM3Opz8ZBL4vBVqk9qJT9q0Nw@mail.gmail.com>
X-Gm-Features: AclHuK9zQLM777IMz9gaSa4k5VTfHhR4TDeMPA5ad8PHcF0LDzew-mhjZ3P0zAY
Message-ID: <CA+EHjTwW9Pg+sMPOY49d9M5WLCM3Opz8ZBL4vBVqk9qJT9q0Nw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Don't livelock when AT can't resolve a fault IPA
To: Ard Biesheuvel <ardb+git@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Ard,

On Mon, 02 Nov 2026 09:47:49 +0000, Ard Biesheuvel <ardb+git@google.com> wrote:
[...]
> When a stage-2 permission fault doesn't report its IPA in HPFAR_EL2,
> __get_fault_info() recovers it with an AT S1E1R/S1E1A on FAR_EL2. If that
> fails, kvm_hyp_handle_memory_fault() goes straight back to the guest, on
> the assumption that the replayed access will either succeed or take a
> fault that the slow path can handle.
[...]

Tested on QEMU (pKVM with protected and non-protected guests, VHE and
nVHE, and page_fault_test) and on an Apple M4 in nVHE, booting UEFI
guests with DAMON_STAT on. On the M4 I added a trace event to the new
branch, and it fired once in 120 boots, on a guest write to the UEFI
flash (a read-only memslot).

Since a guest can livelock on this, I was wondering if it should be Cc: stable.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
