Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793721769;
	b=p5ay4LIoLTVvVE2EffoCuFlqIMc0W2BxxM6FMSA03dwQyPK2gGbtOq+TEafaHxWHldoJ
	 zGwgMyI0d4BxtQP+E0xKQfl6VPsam+tAUHHqzPoXmj4jYKKvcSFCBns5br44vZFmJaw5a
	 5veF/5EgCB156BHpb72a9nZoOJmwTJC8waF6h6dhLxVGC8FLA3fsw/4TWQT7gy2mBt3vx
	 XrFUyWeNclh/9UvH/dRbR1UAxb1hMWs55H2ENZYg9MiJvIVk1C0ch2TchoWO5wh4/8HCb
	 Uqbqsfk9Yvv++D22sRgtEfjiA0ynp8rXwoddvZwEBw/9/KE2Zd7ZbSustRi7jLIEVlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793721769;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=zOCB2yW7H1L7hqWLuRwpPyC8dh+ZZPOknwvDqx+RYXc=;
	b=jeTYZ7q3dqIQQVryFb6+hVB0TpdaWplbwtbK0bU4UaXfP8F5CvVjh+klYggCHjyDXOrA
	 +hkmBUOGehsoS5EMIuJYMVS4liujRzWq4EVSP702CO8jE2T6/SO828eGL9AGcXK2U0HkY
	 qQb6QD2AFF5m4VuPK2Nv+DGwAkzujNWmUhi2TGbiSRYsPKsbi4sEfE2GuykaFo7riG7nX
	 7Y+B+8cWJwDEU2WDNW4rRv82eTH3ZVwUU3NjnhO5PW6Xz6sG1KVpGXSx0b5PLVDQEcz28
	 XHmDrTRX38yGO4JTWJUNhY7j0PibSXrtFq1evXUJ5vc1U0UV0r7pW28XEMSQvVO4sxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NsteG9Gz;
	arc=none smtp.remote-ip=91.218.175.14
Received: from mta0.migadu.com (out-14.mta0.migadu.com [91.218.175.14])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8651E606A328
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 16:02:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8651E606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NsteG9Gz
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=zOCB2yW7H1L7hqWLuRwpPyC8dh+ZZPOknwvDqx+RYXc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793721766; v=1; x=1794326566;
 b=NsteG9Gzcn7zHD+jjLMI3L2qzQcem/kKHW5hgVhjZZ6NSIn1Hk8Vc2SYL+Y8XeeWXsByi6Jm
 O8mlH/6aP+DYNFxpDwiTNwZH0aw+p5JkZCXj0bAod9ZY39NqEmKKb/CEv4keI91G1FCEhaMGm4k
 p17nAutfSkmplVBD63YAXscg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a177ffac6c87c9a1;
	Tue, 03 Nov 2026 16:02:46 +0000
X-Mizu-Trace-ID: a177ffac6c87c9a1
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5bfca2a2af4so7469e87.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 08:02:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBw9ak5XkwTFPSEAJ+VP3ZzL29oHGxXAkcWDhWQSH9x2weKb+O/xkyPBCeQDxVndw9T3nP9RGQM=@lists.linux.dev
X-Gm-Message-State: APuU4Z9gCYrHMyQ0Qn84sL+GiCQ8nMpXhcLUtBPjnPYhYXvqsuaCHccb
	smAEf2TfdlYN8XTeRXF/9aQGTCKaynBaxvpAiw0Vxc6c6C0pGIGqEUobqZ0JnF/JRn4vnHC1qQN
	SNV3BVwgjNTmt2f6gv46drACnWwzfror5ayK37jSp
X-Received: by 2002:a05:6512:308c:b0:5bf:f368:d60a with SMTP id
 2adb3069b0e04-5bff368df88mr6002e87.11.1793721760355; Tue, 03 Nov 2026
 08:02:40 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261102194454.4086911-1-sascha.bischoff@arm.com> <20261102194454.4086911-16-sascha.bischoff@arm.com>
In-Reply-To: <20261102194454.4086911-16-sascha.bischoff@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 3 Nov 2026 16:02:03 +0000
X-Gmail-Original-Message-ID: <CA+EHjTxFT2AeAj-hvuQW3h+u7p25wVpo9CA4QZZrayQW-KOBiQ@mail.gmail.com>
X-Gm-Features: AclHuK_ewwkMxYhH2NmdYQ5NcJFK1vnOJxwlqW6fDvbpSmhufUmI6wkocmqxpCo
Message-ID: <CA+EHjTxFT2AeAj-hvuQW3h+u7p25wVpo9CA4QZZrayQW-KOBiQ@mail.gmail.com>
Subject: Re: [PATCH v2 15/16] KVM: selftests: Add VGICv5 ITS translation cache tests
To: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	peter.maydell@linaro.org, lpieralisi@kernel.org, timothy.hayes@arm.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 02 Nov 2026 19:44:53 +0000, Sascha Bischoff
<sascha.bischoff@arm.com> wrote:
[...]
> Also cover negative MSI paths by checking that KVM_SIGNAL_MSI rejects a
> message without KVM_MSI_VALID_DEVID and rejects a message whose address
> does not target the GICv5 ITS. Finally, inject once before guest-side
> ITS disable to prove delivery still works, then have VPE0 disable the
> ITS and verify that a cached KVM_SIGNAL_MSI delivery is rejected with
> ENXIO.

The MSI just before the disable is expected to be blocked (IDR1 is
narrowed), and the disabled check runs before any cache lookup, so the
final ENXIO doesn't test the cache. Could the test restore IDR1 and
deliver an MSI first, and the message describe what the last step
checks? (Sashiko [1])

Thanks!
/fuad

[1] https://lore.kernel.org/all/sashiko-outbox-194181@kernel.org/
