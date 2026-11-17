Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.212
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794944897;
	b=CM7msD+eHPXVmxq/SNlZrsGQw4jRjQAGNQYuqlUFlF9JV9OHkTBD5NkwODEWqwN1pvp7
	 ln6psDmvXaKm1xLMCN9yX8aIaXiqpec1P2zQG7ChnvdzL+obNdgxaMYsgaCqGuFud7ZWC
	 tbw7dXGsXIV409C1DGsvVSyLMIoLKLNFCl99BXH3Rwu5y0+0Cq6M/B1jmmp7NG4Z4oBwe
	 hlIV9O4jKLKsWiU3YmX8Fr1FTDaGSWCIL6SyrodKLtU6RjBqRmC6gXHxalFKJ3q+SfjoL
	 lMSvMoqihh8Rg9NVK8wRejOIXbz5ITK81ljxRxLi9el/gHHZ4bCMkTJwdc5xYa8nbeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794944897;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=uKJuLqQr75Y+bo8J7GoFF1WkhE7oAHbeqLhg/Qlni5U=;
	b=K0ZBldcpX7uEs7GTGjiKwUA51rp8v6TEmkGzZak/PQrRf3ZfG0ahjl5FtJum4yHMBvsU
	 oF4PYKAm96RIojVrMXcXHzgRPqOZA5oUcp0V9ZxzYzJ81DCltwN25BfnujUV1PfOpqAne
	 gTEcZiR3wcoOvim+LMB0CTCc7Qr5KancpE6qnspeFmwKoNZTf0McZ5SoLp7ZMFdArexFw
	 HVoDiZgkpTO5/QMIfxi5aD3LYqoRfYgbEGnitSeL0bTffRpz+deYyRPwzUodE9Dz0oNDN
	 drnmkXb2Wlyq9EHVlvDjtxqUSFx7Y22P6hTO2IRwrHbzbPyPjQxE/Q7lQhVxGwEu/MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UXM8ypuM;
	arc=none smtp.remote-ip=91.218.175.212
Received: from mta0.migadu.com (out-212.mta0.migadu.com [91.218.175.212])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4CE606A32C
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 19:48:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C4CE606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UXM8ypuM
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=uKJuLqQr75Y+bo8J7GoFF1WkhE7oAHbeqLhg/Qlni5U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794944894; v=1; x=1795549694;
 b=UXM8ypuMZFrmGzxKR0QiG77imGgss9oJ49yHHDBuseqi54SVZz5yE6Kv6q5+jvTtaBK6+E+X
 U00gFoPNePAFkIbhk/x1IOQEUkTx275fdpyiOdYVUOIRiRxzP5fPXBiToar/5oy1DXyqzRN+vL6
 If4hXEAVets2MoyhuyqJxQL0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 0d2a261d291bac5f;
	Tue, 17 Nov 2026 19:48:14 +0000
X-Mizu-Trace-ID: 0d2a261d291bac5f
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5c00d7ac49dso1200e87.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 11:48:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErG6NVsDsubY79MtFNscAcezc9lkJzcWyRkZimHvD3NtvaHZnmKjJyqpmQ/+6fPJ9ZQ+48w+6B4=@lists.linux.dev
X-Gm-Message-State: APuU4Z8EVuqDP6Gs3YRNxoDCUMU/seHUPh0Npzd23tTqErlOBEmZDZQ5
	DIb/nFCON5wbfmzhyDeGCE6yUh5rU21Lw/XuS24upBHG8a/55N00obIPSyvU5kZ97ISEPd5qw5Z
	yn3Dwr4zUj5CwfMLbLkDGxPdxeKwQOP9IjeILG7BF
X-Received: by 2002:a05:6512:2514:b0:5c1:488e:a067 with SMTP id
 2adb3069b0e04-5c1a21b8c88mr211122e87.16.1794944892940; Tue, 17 Nov 2026
 11:48:12 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261109084854.840576-1-fuad.tabba@linux.dev> <20261109084854.840576-2-fuad.tabba@linux.dev>
 <86bj7n1bzx.wl-maz@kernel.org>
In-Reply-To: <86bj7n1bzx.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 17 Nov 2026 19:47:36 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwJ9XTCfrfBLgGjed3GrRtiTnk-ErvPSwU-AhvyTVcnsw@mail.gmail.com>
X-Gm-Features: AclHuK-8bTfTjzWgE2se3igLLysfjqAzQV8BoEmKuQlaC_gyenaFOJ31_2y-pYk
Message-ID: <CA+EHjTwJ9XTCfrfBLgGjed3GrRtiTnk-ErvPSwU-AhvyTVcnsw@mail.gmail.com>
Subject: Re: [PATCH v2 01/19] KVM: arm64: Hide generic ptrauth from protected
 VMs without ptrauth
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Tue, 17 Nov 2026 19:41:54 +0000, Marc Zyngier <maz@kernel.org> wrote:
[...]
> Burying a fix in a selftest series is a recipe to make sure it is
> ignored for a full cycle... Why isn't that with the "massive feature
> set" series?

It's in this one because pkvm_id_regs depends on it. The test checks
that GPA and GPI read 0 in a protected VM without ptrauth, and it
fails without the fix.

Would you prefer that I send it on its own, or with the respin of the
features series?

Cheers,
/fuad
